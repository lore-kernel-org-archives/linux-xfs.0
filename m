Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B79C07DA5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:35:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E81F304051
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZzwvtqtzaRMKYFWv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:35:06 -0700 (PDT)
Subject: [PATCH 28/71] xfs: when replaying bmap operations,
	don't let unlinked inodes get reaped
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:35:01 -0700
Message-ID: <147216810156.867.6921848738908792090.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Log recovery will iget an inode to replay BUI items and iput the inode
when it's done.  Unfortunately, the iput will see that i_nlink == 0
and decide to truncate & free the inode, which prevents us from
replaying subsequent BUIs.  We can't skip the BUIs because we have to
replay all the redo items to ensure that atomic operations complete.

Since unlinked inode recovery will reap the inode anyway, we can
safely introduce a new inode flag to indicate that an inode is in this
'unlinked recovery' state and should not be auto-reaped in the
drop_inode path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c   |    1 +
 fs/xfs/xfs_inode.c       |    8 ++++++++
 fs/xfs/xfs_inode.h       |    6 ++++++
 fs/xfs/xfs_log_recover.c |    1 +
 4 files changed, 16 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 9b1720c..418c012 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -492,6 +492,7 @@ xfs_bui_recover(
 	if (error)
 		goto err_inode;
 
+	xfs_iflags_set(ip, XFS_IRECOVER_UNLINKED);
 	xfs_defer_init(&dfops, &firstfsb);
 
 	/* Process deferred bmap item. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e08eaea..0c25a76 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1855,6 +1855,14 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	/*
+	 * If this unlinked inode is in the middle of recovery, don't
+	 * truncate and free the inode just yet; log recovery will take
+	 * care of that.  See the comment for this inode flag.
+	 */
+	if (xfs_iflags_test(ip, XFS_IRECOVER_UNLINKED))
+		return;
+
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
 		 * force is true because we are evicting an inode from the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4094f2c..7283db3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -221,6 +221,12 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
+/*
+ * If this unlinked inode is in the middle of recovery, don't let drop_inode
+ * truncate and free the inode.  This can happen if we iget the inode during
+ * log recovery to replay a bmap operation on the inode.
+ */
+#define XFS_IRECOVER_UNLINKED	(1 << 10)
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 37673d6..c9c05b9 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4854,6 +4854,7 @@ xlog_recover_process_one_iunlink(
 	if (error)
 		goto fail_iput;
 
+	xfs_iflags_clear(ip, XFS_IRECOVER_UNLINKED);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
