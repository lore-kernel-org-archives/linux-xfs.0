Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54002 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfDOCHu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:07:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F24vZ6151232
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:48 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ru76t3y83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:48 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F26s5J176722
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2ru4vsbw11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3F27lIe013239
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:07:47 GMT
Subject: [PATCH 1/3] xfs: implement per-inode writeback completion queues
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 14 Apr 2019 19:07:48 -0700
Message-ID: <155529406877.243484.8074329168835632578.stgit@magnolia>
In-Reply-To: <155529406249.243484.1307333973877627694.stgit@magnolia>
References: <155529406249.243484.1307333973877627694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When scheduling writeback of dirty file data in the page cache, XFS uses
IO completion workqueue items to ensure that filesystem metadata only
updates after the write completes successfully.  This is essential for
converting unwritten extents to real extents at the right time and
performing COW remappings.

Unfortunately, XFS queues each IO completion work item to an unbounded
workqueue, which means that the kernel can spawn dozens of threads to
try to handle the items quickly.  These threads need to take the ILOCK
to update file metadata, which results in heavy ILOCK contention if a
large number of the work items target a single file, which is
inefficient.

Worse yet, the writeback completion threads get stuck waiting for the
ILOCK while holding transaction reservations, which can use up all
available log reservation space.  When that happens, metadata updates to
other parts of the filesystem grind to a halt, even if the filesystem
could otherwise have handled it.

Even worse, if one of the things grinding to a halt happens to be a
thread in the middle of a defer-ops finish holding the same ILOCK and
trying to obtain more log reservation having exhausted the permanent
reservation, we now have an ABBA deadlock - writeback has a transaction
reserved and wants the ILOCK, and someone else has the ILOCk and wants a
transaction reservation.

Therefore, we create a per-inode writeback io completion queue + work
item.  When writeback finishes, it can add the ioend to the per-inode
queue and let the single worker item process that queue.  This
dramatically cuts down on the number of kworkers and ILOCK contention in
the system, and seems to have eliminated an occasional deadlock I was
seeing while running generic/476.

Testing with a program that simulates a heavy random-write workload to a
single file demonstrates that the number of kworkers drops from
approximately 120 threads per file to 1, without dramatically changing
write bandwidth or pagecache access latency.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c   |   48 +++++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_aops.h   |    1 -
 fs/xfs/xfs_icache.c |    3 +++
 fs/xfs/xfs_inode.h  |    7 +++++++
 4 files changed, 47 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3619e9e8d359..f7a9bb661826 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -234,11 +234,9 @@ xfs_setfilesize_ioend(
  * IO write completion.
  */
 STATIC void
-xfs_end_io(
-	struct work_struct *work)
+xfs_end_ioend(
+	struct xfs_ioend	*ioend)
 {
-	struct xfs_ioend	*ioend =
-		container_of(work, struct xfs_ioend, io_work);
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
@@ -278,19 +276,48 @@ xfs_end_io(
 	xfs_destroy_ioend(ioend, error);
 }
 
+/* Finish all pending io completions. */
+void
+xfs_end_io(
+	struct work_struct	*work)
+{
+	struct xfs_inode	*ip;
+	struct xfs_ioend	*ioend;
+	struct list_head	completion_list;
+	unsigned long		flags;
+
+	ip = container_of(work, struct xfs_inode, i_iodone_work);
+
+	spin_lock_irqsave(&ip->i_iodone_lock, flags);
+	list_replace_init(&ip->i_iodone_list, &completion_list);
+	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
+
+	while (!list_empty(&completion_list)) {
+		ioend = list_first_entry(&completion_list, struct xfs_ioend,
+				io_list);
+		list_del_init(&ioend->io_list);
+		xfs_end_ioend(ioend);
+	}
+}
+
 STATIC void
 xfs_end_bio(
 	struct bio		*bio)
 {
 	struct xfs_ioend	*ioend = bio->bi_private;
-	struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
+	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned long		flags;
 
 	if (ioend->io_fork == XFS_COW_FORK ||
-	    ioend->io_state == XFS_EXT_UNWRITTEN)
-		queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
-	else if (ioend->io_append_trans)
-		queue_work(mp->m_data_workqueue, &ioend->io_work);
-	else
+	    ioend->io_state == XFS_EXT_UNWRITTEN ||
+	    ioend->io_append_trans != NULL) {
+		spin_lock_irqsave(&ip->i_iodone_lock, flags);
+		if (list_empty(&ip->i_iodone_list))
+			queue_work(mp->m_unwritten_workqueue, &ip->i_iodone_work);
+		list_add_tail(&ioend->io_list, &ip->i_iodone_list);
+		spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
+	} else
 		xfs_destroy_ioend(ioend, blk_status_to_errno(bio->bi_status));
 }
 
@@ -594,7 +621,6 @@ xfs_alloc_ioend(
 	ioend->io_inode = inode;
 	ioend->io_size = 0;
 	ioend->io_offset = offset;
-	INIT_WORK(&ioend->io_work, xfs_end_io);
 	ioend->io_append_trans = NULL;
 	ioend->io_bio = bio;
 	return ioend;
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 6c2615b83c5d..f62b03186c62 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -18,7 +18,6 @@ struct xfs_ioend {
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	xfs_off_t		io_offset;	/* offset in the file */
-	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
 	struct bio		*io_bio;	/* bio being built */
 	struct bio		io_inline_bio;	/* MUST BE LAST! */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 245483cc282b..e70e7db29026 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -70,6 +70,9 @@ xfs_inode_alloc(
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
+	INIT_WORK(&ip->i_iodone_work, xfs_end_io);
+	INIT_LIST_HEAD(&ip->i_iodone_list);
+	spin_lock_init(&ip->i_iodone_lock);
 
 	return ip;
 }
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e62074a5257c..88239c2dd824 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -57,6 +57,11 @@ typedef struct xfs_inode {
 
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
+
+	/* pending io completions */
+	spinlock_t		i_iodone_lock;
+	struct work_struct	i_iodone_work;
+	struct list_head	i_iodone_list;
 } xfs_inode_t;
 
 /* Convert from vfs inode to xfs inode */
@@ -503,4 +508,6 @@ bool xfs_inode_verify_forks(struct xfs_inode *ip);
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 
+void xfs_end_io(struct work_struct *work);
+
 #endif	/* __XFS_INODE_H__ */
