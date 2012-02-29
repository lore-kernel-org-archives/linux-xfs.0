Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T9tB7k002228 for <xfs@oss.sgi.com>; Wed, 29 Feb 2012 03:55:11 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	fCJLUldA9bb3aS42 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Feb 2012 01:55:10 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S2gFZ-0006Ci-Jh
	for xfs@oss.sgi.com; Wed, 29 Feb 2012 09:55:09 +0000
Message-Id: <20120229095509.559250501@bombadil.infradead.org>
Date: Wed, 29 Feb 2012 04:53:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/8] xfs: reimplement fdatasync support
References: <20120229095347.009884687@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-implement-fdatasync
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

Add an in-memory only flag to say we logged timestamps only, and use it to
check if fdatasync can optimize away the log force.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c       |    7 +++++--
 fs/xfs/xfs_inode_item.c |    3 ++-
 fs/xfs/xfs_inode_item.h |   11 ++++++++++-
 fs/xfs/xfs_super.c      |    2 +-
 4 files changed, 18 insertions(+), 5 deletions(-)

Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-02-28 12:02:29.643918816 +0100
+++ xfs/fs/xfs/xfs_inode_item.c	2012-02-28 12:02:53.871918171 +0100
@@ -438,7 +438,8 @@ out:
 	 * games in recovery easier, which isn't a big deal as just about any
 	 * transaction would dirty it anyway.
 	 */
-	iip->ili_format.ilf_fields = XFS_ILOG_CORE | iip->ili_fields;
+	iip->ili_format.ilf_fields = XFS_ILOG_CORE |
+		(iip->ili_fields & ~XFS_ILOG_TIMESTAMP);
 	iip->ili_format.ilf_size = nvecs;
 }
 
Index: xfs/fs/xfs/xfs_inode_item.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.h	2012-02-28 12:02:29.643918816 +0100
+++ xfs/fs/xfs/xfs_inode_item.h	2012-02-28 12:04:47.539915134 +0100
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
Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2012-02-28 12:01:00.063921211 +0100
+++ xfs/fs/xfs/xfs_file.c	2012-02-28 12:02:53.875918171 +0100
@@ -197,8 +197,11 @@ xfs_file_fsync(
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
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2012-02-28 12:01:00.071921207 +0100
+++ xfs/fs/xfs/xfs_super.c	2012-02-28 12:02:53.875918171 +0100
@@ -907,7 +907,7 @@ xfs_fs_dirty_inode(
 	ip->i_d.di_mtime.t_nsec = (__int32_t)inode->i_mtime.tv_nsec;
 
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_TIMESTAMP);
 	error = xfs_trans_commit(tp, 0);
 	if (error)
 		goto trouble;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
