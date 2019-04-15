Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57704 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfDOCKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Apr 2019 22:10:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F253lG156556
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:10:01 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2ru59cv4fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:10:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3F275oi177065
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:08:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ru4vsbw3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:08:00 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3F27xTR017608
        for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2019 02:08:00 GMT
Subject: [PATCH 3/3] xfs: merge adjacent io completions of the same type
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 14 Apr 2019 19:08:01 -0700
Message-ID: <155529408121.243484.4204906013564330851.stgit@magnolia>
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

It's possible for pagecache writeback to split up a large amount of work
into smaller pieces for throttling purposes or to reduce the amount of
time a writeback operation is pending.  Whatever the reason, XFS can end
up with a bunch of IO completions that call for the same operation to be
performed on a contiguous extent mapping.  Since mappings are extent
based in XFS, we'd prefer to run fewer transactions when we can.

When we're processing an ioend on the list of io completions, check to
see if the next items on the list are both adjacent and of the same
type.  If so, we can merge the completions to reduce transaction
overhead.

On fast storage this doesn't seem to make much of a difference in
performance, though the number of transactions for an overnight xfstests
run seems to drop by ~5%.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f7a9bb661826..53afa2e6e3e7 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -237,6 +237,7 @@ STATIC void
 xfs_end_ioend(
 	struct xfs_ioend	*ioend)
 {
+	struct list_head	ioend_list;
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
@@ -273,7 +274,89 @@ xfs_end_ioend(
 done:
 	if (ioend->io_append_trans)
 		error = xfs_setfilesize_ioend(ioend, error);
+	list_replace_init(&ioend->io_list, &ioend_list);
 	xfs_destroy_ioend(ioend, error);
+
+	while (!list_empty(&ioend_list)) {
+		ioend = list_first_entry(&ioend_list, struct xfs_ioend,
+				io_list);
+		list_del_init(&ioend->io_list);
+		xfs_destroy_ioend(ioend, error);
+	}
+}
+
+/*
+ * We can merge two adjacent ioends if they have the same set of work to do.
+ */
+static bool
+xfs_ioend_can_merge(
+	struct xfs_ioend	*ioend,
+	int			ioend_error,
+	struct xfs_ioend	*next)
+{
+	int			next_error;
+
+	next_error = blk_status_to_errno(next->io_bio->bi_status);
+	if (ioend_error != next_error)
+		return false;
+	if ((ioend->io_fork == XFS_COW_FORK) ^ (next->io_fork == XFS_COW_FORK))
+		return false;
+	if ((ioend->io_state == XFS_EXT_UNWRITTEN) ^
+	    (next->io_state == XFS_EXT_UNWRITTEN))
+		return false;
+	if (ioend->io_offset + ioend->io_size != next->io_offset)
+		return false;
+	if (xfs_ioend_is_append(ioend) != xfs_ioend_is_append(next))
+		return false;
+	return true;
+}
+
+/* Try to merge adjacent completions. */
+STATIC void
+xfs_ioend_try_merge(
+	struct xfs_ioend	*ioend,
+	struct list_head	*more_ioends)
+{
+	struct xfs_ioend	*next_ioend;
+	int			ioend_error;
+	int			error;
+
+	if (list_empty(more_ioends))
+		return;
+
+	ioend_error = blk_status_to_errno(ioend->io_bio->bi_status);
+
+	while (!list_empty(more_ioends)) {
+		next_ioend = list_first_entry(more_ioends, struct xfs_ioend,
+				io_list);
+		if (!xfs_ioend_can_merge(ioend, ioend_error, next_ioend))
+			break;
+		list_move_tail(&next_ioend->io_list, &ioend->io_list);
+		ioend->io_size += next_ioend->io_size;
+		if (ioend->io_append_trans) {
+			error = xfs_setfilesize_ioend(next_ioend, 1);
+			ASSERT(error == 1);
+		}
+	}
+}
+
+/* list_sort compare function for ioends */
+static int
+xfs_ioend_compare(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	struct xfs_ioend	*ia;
+	struct xfs_ioend	*ib;
+
+	ia = container_of(a, struct xfs_ioend, io_list);
+	ib = container_of(b, struct xfs_ioend, io_list);
+	if (ia->io_offset < ib->io_offset)
+		return -1;
+	else if (ia->io_offset > ib->io_offset)
+		return 1;
+	return 0;
 }
 
 /* Finish all pending io completions. */
@@ -292,10 +375,13 @@ xfs_end_io(
 	list_replace_init(&ip->i_iodone_list, &completion_list);
 	spin_unlock_irqrestore(&ip->i_iodone_lock, flags);
 
+	list_sort(NULL, &completion_list, xfs_ioend_compare);
+
 	while (!list_empty(&completion_list)) {
 		ioend = list_first_entry(&completion_list, struct xfs_ioend,
 				io_list);
 		list_del_init(&ioend->io_list);
+		xfs_ioend_try_merge(ioend, &completion_list);
 		xfs_end_ioend(ioend);
 	}
 }
