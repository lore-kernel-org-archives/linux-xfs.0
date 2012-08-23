Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N547QM135545 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:07 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	d3VovNoMu1sTj1Y3 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:53 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pap-0003Hd-Jf
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pap-0003fp-Gn
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 056/102] xfs: reimplement fdatasync support
Date: Thu, 23 Aug 2012 15:02:14 +1000
Message-Id: <1345698180-13612-57-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

Upstream commit: 8f639ddea0c4978ae9b4e46ea041c9e5afe0ee8d

Add an in-memory only flag to say we logged timestamps only, and use it to
check if fdatasync can optimize away the log force.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c  |    7 +++++--
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/xfs_inode_item.c      |    3 ++-
 fs/xfs/xfs_inode_item.h      |   11 ++++++++++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index a575a63..1dbd1d8 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -191,8 +191,11 @@ xfs_file_fsync(
 	 * to flush the log up to the latest LSN that touched the inode.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
+	if (xfs_ipincount(ip)) {
+		if (!datasync ||
+		    (ip->i_itemp->ili_fields & ~XFS_ILOG_TIMESTAMP))
+			lsn = ip->i_itemp->ili_last_lsn;
+	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (lsn)
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index c12df49..ec5ca7b 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -944,7 +944,7 @@ xfs_fs_dirty_inode(
 	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
 
 	xfs_trans_ijoin(tp, ip);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
 	error = xfs_trans_commit(tp, 0);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 45514c5..a76d1b9 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -438,7 +438,8 @@ out:
 	 * games in recovery easier, which isn't a big deal as just about any
 	 * transaction would dirty it anyway.
 	 */
-	iip->ili_format.ilf_fields = XFS_ILOG_CORE | iip->ili_fields;
+	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
+		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
 	ASSERT(nvecs == lip->li_desc->lid_size);
 	iip->ili_format.ilf_size = nvecs;
 }
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index bc183d8..41d61c3 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -86,6 +86,15 @@ typedef struct xfs_inode_log_format_64 {
 #define	XFS_ILOG_AEXT	0x080	/* log i_af.if_extents */
 #define	XFS_ILOG_ABROOT	0x100	/* log i_af.i_broot */
 
+
+/*
+ * The timestamps are dirty, but not necessarily anything else in the inode
+ * core.  Unlike the other fields above this one must never make it to disk
+ * in the ilf_fields of the inode_log_format, but is purely store in-memory in
+ * ili_fields in the inode_log_item.
+ */
+#define XFS_ILOG_TIMESTAMP	0x4000
+
 #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
 				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
 				 XFS_ILOG_UUID | XFS_ILOG_ADATA | \
@@ -101,7 +110,7 @@ typedef struct xfs_inode_log_format_64 {
 				 XFS_ILOG_DEXT | XFS_ILOG_DBROOT | \
 				 XFS_ILOG_DEV | XFS_ILOG_UUID | \
 				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
-				 XFS_ILOG_ABROOT)
+				 XFS_ILOG_ABROOT | XFS_ILOG_TIMESTAMP)
 
 static inline int xfs_ilog_fbroot(int w)
 {
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
