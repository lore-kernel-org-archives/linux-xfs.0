Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:19:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J7J4fB001557
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:19:06 -0700
Date: Thu, 19 Apr 2007 17:18:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: make xfs_dm_punch_hole() atomic when punching EOF
Message-ID: <20070419071856.GR48531920@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Currently punching a hole to EOF via xfs_dm_punch_hole()
truncates the file and then extends it. This leaves a small
window where applications can see an incorrect file size
while the punch is in progress. This can cause problems
with DMF leading to premature completion of recalls and
hence data corruption.

Use the UNRESVSP ioctl rather than FREESP+setattr to punch the
hole at EOF. This can leave specualtive allocations past EOF,
so truncate them off so we don't leave blocks that can't be
migrated away around in the filesystem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/dmapi/xfs_dm.c        |   47 +++++++++++++++++++++++++++----------------
 fs/xfs/linux-2.6/xfs_ksyms.c |    1 
 fs/xfs/xfs_rw.h              |   14 ++++++++++--
 fs/xfs/xfs_vnodeops.c        |   28 ++++++++++++++++---------
 4 files changed, 60 insertions(+), 30 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/dmapi/xfs_dm.c	2007-04-19 16:55:44.345586509 +1000
+++ 2.6.x-xfs-new/fs/xfs/dmapi/xfs_dm.c	2007-04-19 17:18:05.818466833 +1000
@@ -2601,9 +2601,9 @@ xfs_dm_punch_hole(
 	xfs_inode_t	*xip;
 	xfs_mount_t	*mp;
 	u_int		bsize;
-	int		cmd = XFS_IOC_UNRESVSP; /* punch */
 	xfs_fsize_t	realsize;
 	bhv_vnode_t	*vp = vn_from_inode(inode);
+	int		punch_to_eof = 0;
 
 	/* Returns negative errors to DMAPI */
 
@@ -2638,12 +2638,24 @@ xfs_dm_punch_hole(
 	down_rw_sems(inode, DM_SEM_FLAG_WR);
 
 	xfs_ilock(xip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	if ((off >= xip->i_size) || ((off+len) > xip->i_size)) {
+	realsize = xip->i_size;
+
+	if ((off >= realsize) || ((off + len) > realsize)) {
 		xfs_iunlock(xip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 		error = -E2BIG;
 		goto up_and_out;
 	}
-	realsize = xip->i_size;
+	if (len == 0)
+		punch_to_eof = 1;
+
+	/*
+	 * When we are punching to EOF, we have to make sure we punch the
+	 * last partial block that contains EOF. Round up the length to
+	 * make sure we punch the block and not just zero it.
+	 */
+	if (punch_to_eof)
+		len = roundup((realsize - off), bsize);
+
 	xfs_iunlock(xip, XFS_ILOCK_EXCL);
 
 	bf.l_type = 0;
@@ -2651,20 +2663,21 @@ xfs_dm_punch_hole(
 	bf.l_start = (xfs_off_t)off;
 	bf.l_len = (xfs_off_t)len;
 
-	if (len == 0)
-		cmd = XFS_IOC_FREESP; /* truncate */
-	error = xfs_change_file_space(xbdp, cmd, &bf, (xfs_off_t)off,
-				      sys_cred,
-				      ATTR_DMI|ATTR_NOLOCK);
-
-	/* If truncate, grow it back to its original size. */
-	if ((error == 0) && (len == 0)) {
-		bhv_vattr_t va;
-
-		va.va_mask = XFS_AT_SIZE;
-		va.va_size = realsize;
-		error = xfs_setattr(xbdp, &va, ATTR_DMI|ATTR_NOLOCK,
-				    sys_cred);
+	error = xfs_change_file_space(xbdp, XFS_IOC_UNRESVSP, &bf,
+				(xfs_off_t)off, sys_cred, ATTR_DMI|ATTR_NOLOCK);
+
+	/*
+	 * if punching to end of file, kill any blocks past EOF that
+	 * may have been (speculatively) preallocated. No point in
+	 * leaving them around if we are migrating the file....
+	 */
+	if (!error && punch_to_eof) {
+		error = xfs_free_eofblocks(mp, xip, XFS_FREE_EOF_NOLOCK);
+		if (!error) {
+			/* Update linux inode block count after free above */
+			inode->i_blocks = XFS_FSB_TO_BB(mp,
+				xip->i_d.di_nblocks + xip->i_delayed_blks);
+		}
 	}
 
 	/* Let threads in send_data_event know we punched the file. */
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-04-19 16:56:33.471205020 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_ksyms.c	2007-04-19 17:18:05.082563433 +1000
@@ -332,3 +332,4 @@ EXPORT_SYMBOL(xfs_xlatesb);
 EXPORT_SYMBOL(xfs_zero_eof);
 EXPORT_SYMBOL(xlog_recover_process_iunlinks);
 EXPORT_SYMBOL(xfs_ichgtime_fast);
+EXPORT_SYMBOL(xfs_free_eofblocks);
Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-04-19 16:56:33.655181121 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-04-19 17:18:04.890588633 +1000
@@ -1207,13 +1207,15 @@ xfs_fsync(
 }
 
 /*
- * This is called by xfs_inactive to free any blocks beyond eof,
- * when the link count isn't zero.
+ * This is called by xfs_inactive to free any blocks beyond eof
+ * when the link count isn't zero and by xfs_dm_punch_hole() when
+ * punching a hole to EOF.
  */
-STATIC int
-xfs_inactive_free_eofblocks(
+int
+xfs_free_eofblocks(
 	xfs_mount_t	*mp,
-	xfs_inode_t	*ip)
+	xfs_inode_t	*ip,
+	int		flags)
 {
 	xfs_trans_t	*tp;
 	int		error;
@@ -1222,6 +1224,7 @@ xfs_inactive_free_eofblocks(
 	xfs_filblks_t	map_len;
 	int		nimaps;
 	xfs_bmbt_irec_t	imap;
+	int		use_iolock = (flags & XFS_FREE_EOF_LOCK);
 
 	/*
 	 * Figure out if there are any blocks beyond the end
@@ -1262,11 +1265,13 @@ xfs_inactive_free_eofblocks(
 		 * cache and we can't
 		 * do that within a transaction.
 		 */
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+		if (use_iolock)
+			xfs_ilock(ip, XFS_IOLOCK_EXCL);
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
-			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+			if (use_iolock)
+				xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
 
@@ -1303,7 +1308,8 @@ xfs_inactive_free_eofblocks(
 			error = xfs_trans_commit(tp,
 						XFS_TRANS_RELEASE_LOG_RES);
 		}
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, (use_iolock ? (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)
+					    : XFS_ILOCK_EXCL));
 	}
 	return error;
 }
@@ -1579,7 +1585,8 @@ xfs_release(
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
-			if ((error = xfs_inactive_free_eofblocks(mp, ip)))
+			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			if (error)
 				return error;
 			/* Update linux inode block count after free above */
 			vn_to_inode(vp)->i_blocks = XFS_FSB_TO_BB(mp,
@@ -1660,7 +1667,8 @@ xfs_inactive(
 		     (!(ip->i_d.di_flags &
 				(XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) ||
 		      (ip->i_delayed_blks != 0)))) {
-			if ((error = xfs_inactive_free_eofblocks(mp, ip)))
+			error = xfs_free_eofblocks(mp, ip, XFS_FREE_EOF_LOCK);
+			if (error)
 				return VN_INACTIVE_CACHE;
 			/* Update linux inode block count after free above */
 			vn_to_inode(vp)->i_blocks = XFS_FSB_TO_BB(mp,
Index: 2.6.x-xfs-new/fs/xfs/xfs_rw.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_rw.h	2007-04-19 16:55:44.373582872 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_rw.h	2007-04-19 16:56:33.839157222 +1000
@@ -72,6 +72,12 @@ xfs_fsb_to_db_io(struct xfs_iocore *io, 
 }
 
 /*
+ * Flags for xfs_free_eofblocks
+ */
+#define XFS_FREE_EOF_LOCK	(1<<0)
+#define XFS_FREE_EOF_NOLOCK	(1<<1)
+
+/*
  * Prototypes for functions in xfs_rw.c.
  */
 extern int xfs_write_clear_setuid(struct xfs_inode *ip);
@@ -91,10 +97,12 @@ extern void xfs_ioerror_alert(char *func
 extern int xfs_rwlock(bhv_desc_t *bdp, bhv_vrwlock_t write_lock);
 extern void xfs_rwunlock(bhv_desc_t *bdp, bhv_vrwlock_t write_lock);
 extern int xfs_setattr(bhv_desc_t *, bhv_vattr_t *vap, int flags,
-		       cred_t *credp);
+			cred_t *credp);
 extern int xfs_change_file_space(bhv_desc_t *bdp, int cmd, xfs_flock64_t *bf,
-				 xfs_off_t offset, cred_t *credp, int flags);
+			xfs_off_t offset, cred_t *credp, int flags);
 extern int xfs_set_dmattrs(bhv_desc_t *bdp, u_int evmask, u_int16_t state,
-			   cred_t *credp);
+			cred_t *credp);
+extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
+			int flags);
 
 #endif /* __XFS_RW_H__ */
