Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 02:56:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6Q9u6va024537
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:56:06 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C0B7EA5AB8
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:16 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id haXbBFZRW4g0Gl5y for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 02:57:16 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6Q9v5Ng031896
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 11:57:06 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6Q9v58O031894
	for xfs@oss.sgi.com; Sat, 26 Jul 2008 11:57:05 +0200
Date: Sat, 26 Jul 2008 11:57:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/6] cleanup xfs_mountfs
Message-ID: <20080726095705.GB31858@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Remove all the useless flags and code keyed off it in xfs_mountfs.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-07-24 19:37:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-07-24 22:57:15.000000000 +0200
@@ -308,8 +308,7 @@ xfs_qm_unmount_quotadestroy(
  */
 void
 xfs_qm_mount_quotas(
-	xfs_mount_t	*mp,
-	int		mfsi_flags)
+	xfs_mount_t	*mp)
 {
 	int		error = 0;
 	uint		sbf;
@@ -344,8 +343,7 @@ xfs_qm_mount_quotas(
 	/*
 	 * If any of the quotas are not consistent, do a quotacheck.
 	 */
-	if (XFS_QM_NEED_QUOTACHECK(mp) &&
-	    !(mfsi_flags & XFS_MFSI_NO_QUOTACHECK)) {
+	if (XFS_QM_NEED_QUOTACHECK(mp)) {
 		error = xfs_qm_quotacheck(mp);
 		if (error) {
 			/* Quotacheck failed and disabled quotas. */
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.h	2008-05-24 20:05:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.h	2008-07-24 22:57:15.000000000 +0200
@@ -165,7 +165,7 @@ typedef struct xfs_dquot_acct {
 #define XFS_QM_RELE(xqm)	((xqm)->qm_nrefs--)
 
 extern void		xfs_qm_destroy_quotainfo(xfs_mount_t *);
-extern void		xfs_qm_mount_quotas(xfs_mount_t *, int);
+extern void		xfs_qm_mount_quotas(xfs_mount_t *);
 extern int		xfs_qm_quotacheck(xfs_mount_t *);
 extern void		xfs_qm_unmount_quotadestroy(xfs_mount_t *);
 extern int		xfs_qm_unmount_quotas(xfs_mount_t *);
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2008-07-24 19:37:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c	2008-07-24 22:57:15.000000000 +0200
@@ -160,7 +160,7 @@ xfs_qm_newmount(
 			 * mounting, and get on with the boring life
 			 * without disk quotas.
 			 */
-			xfs_qm_mount_quotas(mp, 0);
+			xfs_qm_mount_quotas(mp);
 		} else {
 			/*
 			 * Clear the quota flags, but remember them. This
@@ -182,13 +182,12 @@ STATIC int
 xfs_qm_endmount(
 	xfs_mount_t	*mp,
 	uint		needquotamount,
-	uint		quotaflags,
-	int		mfsi_flags)
+	uint		quotaflags)
 {
 	if (needquotamount) {
 		ASSERT(mp->m_qflags == 0);
 		mp->m_qflags = quotaflags;
-		xfs_qm_mount_quotas(mp, mfsi_flags);
+		xfs_qm_mount_quotas(mp);
 	}
 
 #if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
Index: linux-2.6-xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_recover.c	2008-07-24 19:37:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_recover.c	2008-07-24 22:57:15.000000000 +0200
@@ -3938,8 +3938,7 @@ xlog_recover(
  */
 int
 xlog_recover_finish(
-	xlog_t		*log,
-	int		mfsi_flags)
+	xlog_t		*log)
 {
 	/*
 	 * Now we're ready to do the transactions needed for the
@@ -3967,9 +3966,7 @@ xlog_recover_finish(
 		xfs_log_force(log->l_mp, (xfs_lsn_t)0,
 			      (XFS_LOG_FORCE | XFS_LOG_SYNC));
 
-		if ( (mfsi_flags & XFS_MFSI_NOUNLINK) == 0 ) {
-			xlog_recover_process_iunlinks(log);
-		}
+		xlog_recover_process_iunlinks(log);
 
 		xlog_recover_check_summary(log);
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2008-07-24 22:54:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2008-07-24 22:57:15.000000000 +0200
@@ -697,11 +697,11 @@ xfs_initialize_perag_data(xfs_mount_t *m
  * Update alignment values based on mount options and sb values
  */
 STATIC int
-xfs_update_alignment(xfs_mount_t *mp, int mfsi_flags, __uint64_t *update_flags)
+xfs_update_alignment(xfs_mount_t *mp, __uint64_t *update_flags)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
 
-	if (mp->m_dalign && !(mfsi_flags & XFS_MFSI_SECOND)) {
+	if (mp->m_dalign) {
 		/*
 		 * If stripe unit and stripe width are not multiples
 		 * of the fs blocksize turn off alignment.
@@ -857,7 +857,7 @@ xfs_set_inoalignment(xfs_mount_t *mp)
  * Check that the data (and log if separate) are an ok size.
  */
 STATIC int
-xfs_check_sizes(xfs_mount_t *mp, int mfsi_flags)
+xfs_check_sizes(xfs_mount_t *mp)
 {
 	xfs_buf_t	*bp;
 	xfs_daddr_t	d;
@@ -880,8 +880,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
 		return error;
 	}
 
-	if (((mfsi_flags & XFS_MFSI_CLIENT) == 0) &&
-	    mp->m_logdev_targp != mp->m_ddev_targp) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp) {
 		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
 			cmn_err(CE_WARN, "XFS: size check 3 failed");
@@ -916,8 +915,7 @@ xfs_check_sizes(xfs_mount_t *mp, int mfs
  */
 int
 xfs_mountfs(
-	xfs_mount_t	*mp,
-	int		mfsi_flags)
+	xfs_mount_t	*mp)
 {
 	xfs_sb_t	*sbp = &(mp->m_sb);
 	xfs_inode_t	*rip;
@@ -978,7 +976,7 @@ xfs_mountfs(
 	 * allocator alignment is within an ag, therefore ag has
 	 * to be aligned at stripe boundary.
 	 */
-	error = xfs_update_alignment(mp, mfsi_flags, &update_flags);
+	error = xfs_update_alignment(mp, &update_flags);
 	if (error)
 		goto error1;
 
@@ -997,8 +995,7 @@ xfs_mountfs(
 	 * since a single partition filesystem is identical to a single
 	 * partition volume/filesystem.
 	 */
-	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
-	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
+	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
 		if (xfs_uuid_mount(mp)) {
 			error = XFS_ERROR(EINVAL);
 			goto error1;
@@ -1026,7 +1023,7 @@ xfs_mountfs(
 	/*
 	 * Check that the data (and log if separate) are an ok size.
 	 */
-	error = xfs_check_sizes(mp, mfsi_flags);
+	error = xfs_check_sizes(mp);
 	if (error)
 		goto error1;
 
@@ -1040,13 +1037,6 @@ xfs_mountfs(
 	}
 
 	/*
-	 * For client case we are done now
-	 */
-	if (mfsi_flags & XFS_MFSI_CLIENT) {
-		return 0;
-	}
-
-	/*
 	 *  Copies the low order bits of the timestamp and the randomly
 	 *  set "sequence" number out of a UUID.
 	 */
@@ -1183,7 +1173,7 @@ xfs_mountfs(
 	 * delayed until after the root and real-time bitmap inodes
 	 * were consistently read in.
 	 */
-	error = xfs_log_mount_finish(mp, mfsi_flags);
+	error = xfs_log_mount_finish(mp);
 	if (error) {
 		cmn_err(CE_WARN, "XFS: log mount finish failed");
 		goto error4;
@@ -1192,7 +1182,7 @@ xfs_mountfs(
 	/*
 	 * Complete the quota initialisation, post-log-replay component.
 	 */
-	error = XFS_QM_MOUNT(mp, quotamount, quotaflags, mfsi_flags);
+	error = XFS_QM_MOUNT(mp, quotamount, quotaflags);
 	if (error)
 		goto error4;
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-07-24 19:37:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-07-24 22:57:15.000000000 +0200
@@ -114,7 +114,7 @@ struct xfs_dqtrxops;
 struct xfs_quotainfo;
 
 typedef int	(*xfs_qminit_t)(struct xfs_mount *, uint *, uint *);
-typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint, int);
+typedef int	(*xfs_qmmount_t)(struct xfs_mount *, uint, uint);
 typedef int	(*xfs_qmunmount_t)(struct xfs_mount *);
 typedef void	(*xfs_qmdone_t)(struct xfs_mount *);
 typedef void	(*xfs_dqrele_t)(struct xfs_dquot *);
@@ -158,8 +158,8 @@ typedef struct xfs_qmops {
 
 #define XFS_QM_INIT(mp, mnt, fl) \
 	(*(mp)->m_qm_ops->xfs_qminit)(mp, mnt, fl)
-#define XFS_QM_MOUNT(mp, mnt, fl, mfsi_flags) \
-	(*(mp)->m_qm_ops->xfs_qmmount)(mp, mnt, fl, mfsi_flags)
+#define XFS_QM_MOUNT(mp, mnt, fl) \
+	(*(mp)->m_qm_ops->xfs_qmmount)(mp, mnt, fl)
 #define XFS_QM_UNMOUNT(mp) \
 	(*(mp)->m_qm_ops->xfs_qmunmount)(mp)
 #define XFS_QM_DONE(mp) \
@@ -440,13 +440,6 @@ void xfs_do_force_shutdown(struct xfs_mo
 /*
  * Flags for xfs_mountfs
  */
-#define XFS_MFSI_SECOND		0x01	/* Secondary mount -- skip stuff */
-#define XFS_MFSI_CLIENT		0x02	/* Is a client -- skip lots of stuff */
-/*	XFS_MFSI_RRINODES	*/
-#define XFS_MFSI_NOUNLINK	0x08	/* Skip unlinked inode processing in */
-					/* log recovery */
-#define XFS_MFSI_NO_QUOTACHECK	0x10	/* Skip quotacheck processing */
-/*	XFS_MFSI_CONVERT_SUNIT	*/
 #define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
 
 #define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
@@ -515,7 +508,7 @@ typedef struct xfs_mod_sb {
 
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
-extern int	xfs_mountfs(xfs_mount_t *mp, int);
+extern int	xfs_mountfs(xfs_mount_t *mp);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
 extern int	xfs_unmountfs(xfs_mount_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2008-05-28 15:35:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2008-07-24 22:57:15.000000000 +0200
@@ -588,12 +588,12 @@ error:
  * mp		- ubiquitous xfs mount point structure
  */
 int
-xfs_log_mount_finish(xfs_mount_t *mp, int mfsi_flags)
+xfs_log_mount_finish(xfs_mount_t *mp)
 {
 	int	error;
 
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
-		error = xlog_recover_finish(mp->m_log, mfsi_flags);
+		error = xlog_recover_finish(mp->m_log);
 	else {
 		error = 0;
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
Index: linux-2.6-xfs/fs/xfs/xfs_log.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.h	2008-05-28 15:35:25.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.h	2008-07-24 22:57:15.000000000 +0200
@@ -149,7 +149,7 @@ int	  xfs_log_mount(struct xfs_mount	*mp
 			struct xfs_buftarg	*log_target,
 			xfs_daddr_t		start_block,
 			int		 	num_bblocks);
-int	  xfs_log_mount_finish(struct xfs_mount *mp, int);
+int	  xfs_log_mount_finish(struct xfs_mount *mp);
 void	  xfs_log_move_tail(struct xfs_mount	*mp,
 			    xfs_lsn_t		tail_lsn);
 int	  xfs_log_notify(struct xfs_mount	*mp,
Index: linux-2.6-xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log_priv.h	2008-07-23 09:41:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log_priv.h	2008-07-24 22:57:15.000000000 +0200
@@ -468,7 +468,7 @@ extern int	 xlog_find_tail(xlog_t	*log,
 				xfs_daddr_t *head_blk,
 				xfs_daddr_t *tail_blk);
 extern int	 xlog_recover(xlog_t *log);
-extern int	 xlog_recover_finish(xlog_t *log, int mfsi_flags);
+extern int	 xlog_recover_finish(xlog_t *log);
 extern void	 xlog_pack_data(xlog_t *log, xlog_in_core_t *iclog, int);
 extern void	 xlog_recover_process_iunlinks(xlog_t *log);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-24 22:54:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-24 22:57:15.000000000 +0200
@@ -1601,7 +1601,7 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
-	error = xfs_mountfs(mp, flags);
+	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
 
