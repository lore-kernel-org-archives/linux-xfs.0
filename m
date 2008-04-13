Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Apr 2008 02:09:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3D98lNO017730
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:08:47 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4230E12963E0
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:09:21 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id xxGwuheWksHUJgAK for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 02:09:21 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m3D99EF3019997
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2008 11:09:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m3D99EU4019993
	for xfs@oss.sgi.com; Sun, 13 Apr 2008 11:09:14 +0200
Date: Sun, 13 Apr 2008 11:09:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] shrink mrlock_t
Message-ID: <20080413090914.GA19896@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

The writer field is not needed for non_DEBU builds so remove it.  While
we're at i also clean up the interface for is locked asserts to go
through and xfs_iget.c helper with an interface like the xfs_ilock
routines to isolated the XFS codebase from mrlock internals.  That way
we can kill mrlock_t entirely once rw_semaphores grow an islocked
facility.  Also remove unused flags to the ilock family of functions.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/mrlock.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/mrlock.h	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/mrlock.h	2008-04-10 19:00:35.000000000 +0200
@@ -20,29 +20,24 @@
 
 #include <linux/rwsem.h>
 
-enum { MR_NONE, MR_ACCESS, MR_UPDATE };
-
 typedef struct {
 	struct rw_semaphore	mr_lock;
+#ifdef DEBUG
 	int			mr_writer;
+#endif
 } mrlock_t;
 
+#ifdef DEBUG
 #define mrinit(mrp, name)	\
 	do { (mrp)->mr_writer = 0; init_rwsem(&(mrp)->mr_lock); } while (0)
+#else
+#define mrinit(mrp, name)	\
+	do { init_rwsem(&(mrp)->mr_lock); } while (0)
+#endif
+
 #define mrlock_init(mrp, t,n,s)	mrinit(mrp, n)
 #define mrfree(mrp)		do { } while (0)
 
-static inline void mraccess(mrlock_t *mrp)
-{
-	down_read(&mrp->mr_lock);
-}
-
-static inline void mrupdate(mrlock_t *mrp)
-{
-	down_write(&mrp->mr_lock);
-	mrp->mr_writer = 1;
-}
-
 static inline void mraccess_nested(mrlock_t *mrp, int subclass)
 {
 	down_read_nested(&mrp->mr_lock, subclass);
@@ -51,10 +46,11 @@ static inline void mraccess_nested(mrloc
 static inline void mrupdate_nested(mrlock_t *mrp, int subclass)
 {
 	down_write_nested(&mrp->mr_lock, subclass);
+#ifdef DEBUG
 	mrp->mr_writer = 1;
+#endif
 }
 
-
 static inline int mrtryaccess(mrlock_t *mrp)
 {
 	return down_read_trylock(&mrp->mr_lock);
@@ -64,39 +60,31 @@ static inline int mrtryupdate(mrlock_t *
 {
 	if (!down_write_trylock(&mrp->mr_lock))
 		return 0;
+#ifdef DEBUG
 	mrp->mr_writer = 1;
+#endif
 	return 1;
 }
 
-static inline void mrunlock(mrlock_t *mrp)
+static inline void mrunlock_excl(mrlock_t *mrp)
 {
-	if (mrp->mr_writer) {
-		mrp->mr_writer = 0;
-		up_write(&mrp->mr_lock);
-	} else {
-		up_read(&mrp->mr_lock);
-	}
+#ifdef DEBUG
+	mrp->mr_writer = 0;
+#endif
+	up_write(&mrp->mr_lock);
 }
 
-static inline void mrdemote(mrlock_t *mrp)
+static inline void mrunlock_shared(mrlock_t *mrp)
 {
-	mrp->mr_writer = 0;
-	downgrade_write(&mrp->mr_lock);
+	up_read(&mrp->mr_lock);
 }
 
-#ifdef DEBUG
-/*
- * Debug-only routine, without some platform-specific asm code, we can
- * now only answer requests regarding whether we hold the lock for write
- * (reader state is outside our visibility, we only track writer state).
- * Note: means !ismrlocked would give false positives, so don't do that.
- */
-static inline int ismrlocked(mrlock_t *mrp, int type)
+static inline void mrdemote(mrlock_t *mrp)
 {
-	if (mrp && type == MR_UPDATE)
-		return mrp->mr_writer;
-	return 1;
-}
+#ifdef DEBUG
+	mrp->mr_writer = 0;
 #endif
+	downgrade_write(&mrp->mr_lock);
+}
 
 #endif /* __XFS_SUPPORT_MRLOCK_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2008-04-10 07:24:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2008-04-10 18:25:12.000000000 +0200
@@ -240,6 +240,9 @@ EXPORT_SYMBOL(xfs_igrow_finish);
 EXPORT_SYMBOL(xfs_ilock);
 EXPORT_SYMBOL(xfs_ilock_map_shared);
 EXPORT_SYMBOL(xfs_ilock_nowait);
+#ifdef DEBUG
+EXPORT_SYMBOL(xfs_isilocked);
+#endif
 EXPORT_SYMBOL(xfs_internal_inum);
 EXPORT_SYMBOL(xfs_iput);
 EXPORT_SYMBOL(xfs_iput_new);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 07:24:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-04-10 18:25:12.000000000 +0200
@@ -393,7 +393,7 @@ xfs_zero_last_block(
 	int		error = 0;
 	xfs_bmbt_irec_t	imap;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
 	if (zero_offset == 0) {
@@ -424,14 +424,14 @@ xfs_zero_last_block(
 	 * out sync.  We need to drop the ilock while we do this so we
 	 * don't deadlock when the buffer cache calls back to us.
 	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL| XFS_EXTSIZE_RD);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	zero_len = mp->m_sb.sb_blocksize - zero_offset;
 	if (isize + zero_len > offset)
 		zero_len = offset - isize;
 	error = xfs_iozero(ip, isize, zero_len);
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	ASSERT(error >= 0);
 	return error;
 }
@@ -464,8 +464,7 @@ xfs_zero_eof(
 	int		error = 0;
 	xfs_bmbt_irec_t	imap;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(offset > isize);
 
 	/*
@@ -474,8 +473,7 @@ xfs_zero_eof(
 	 */
 	error = xfs_zero_last_block(ip, offset, isize);
 	if (error) {
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 		return error;
 	}
 
@@ -506,8 +504,7 @@ xfs_zero_eof(
 		error = xfs_bmapi(NULL, ip, start_zero_fsb, zero_count_fsb,
 				  0, NULL, 0, &imap, &nimaps, NULL, NULL);
 		if (error) {
-			ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
-			ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 			return error;
 		}
 		ASSERT(nimaps > 0);
@@ -531,7 +528,7 @@ xfs_zero_eof(
 		 * Drop the inode lock while we're doing the I/O.
 		 * We'll still have the iolock to protect us.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
 		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
@@ -547,13 +544,13 @@ xfs_zero_eof(
 		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
 		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return 0;
 
 out_lock:
-	xfs_ilock(ip, XFS_ILOCK_EXCL|XFS_EXTSIZE_RD);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	ASSERT(error >= 0);
 	return error;
 }
Index: linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_dquot.c	2008-04-10 07:24:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_dquot.c	2008-04-10 18:25:12.000000000 +0200
@@ -933,7 +933,7 @@ xfs_qm_dqget(
 	       type == XFS_DQ_PROJ ||
 	       type == XFS_DQ_GROUP);
 	if (ip) {
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		if (type == XFS_DQ_USER)
 			ASSERT(ip->i_udquot == NULL);
 		else
@@ -1088,7 +1088,7 @@ xfs_qm_dqget(
 	xfs_qm_mplist_unlock(mp);
 	XFS_DQ_HASH_UNLOCK(h);
  dqret:
-	ASSERT((ip == NULL) || XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	xfs_dqtrace_entry(dqp, "DQGET DONE");
 	*O_dqpp = dqp;
 	return (0);
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2008-04-09 20:02:28.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2008-04-10 18:25:12.000000000 +0200
@@ -670,7 +670,7 @@ xfs_qm_dqattach_one(
 	xfs_dquot_t	*dqp;
 	int		error;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
 	/*
 	 * See if we already have it in the inode itself. IO_idqpp is
@@ -874,7 +874,7 @@ xfs_qm_dqattach(
 		return 0;
 
 	ASSERT((flags & XFS_QMOPT_ILOCKED) == 0 ||
-	       XFS_ISLOCKED_INODE_EXCL(ip));
+	       xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (! (flags & XFS_QMOPT_ILOCKED))
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -888,7 +888,8 @@ xfs_qm_dqattach(
 			goto done;
 		nquotas++;
 	}
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	if (XFS_IS_OQUOTA_ON(mp)) {
 		error = XFS_IS_GQUOTA_ON(mp) ?
 			xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
@@ -913,7 +914,7 @@ xfs_qm_dqattach(
 	 * This WON'T, in general, result in a thrash.
 	 */
 	if (nquotas == 2) {
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT(ip->i_udquot);
 		ASSERT(ip->i_gdquot);
 
@@ -956,7 +957,7 @@ xfs_qm_dqattach(
 
 #ifdef QUOTADEBUG
 	else
-		ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 #endif
 	return error;
 }
@@ -1291,7 +1292,7 @@ xfs_qm_dqget_noattach(
 	xfs_mount_t	*mp;
 	xfs_dquot_t	*udqp, *gdqp;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	mp = ip->i_mount;
 	udqp = NULL;
 	gdqp = NULL;
@@ -1392,7 +1393,7 @@ xfs_qm_qino_alloc(
 	 * Keep an extra reference to this quota inode. This inode is
 	 * locked exclusively and joined to the transaction already.
 	 */
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(*ip));
+	ASSERT(xfs_isilocked(*ip, XFS_ILOCK_EXCL));
 	VN_HOLD(XFS_ITOV((*ip)));
 
 	/*
@@ -2563,7 +2564,7 @@ xfs_qm_vop_chown(
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
 
 	/* old dquot */
@@ -2607,7 +2608,7 @@ xfs_qm_vop_chown_reserve(
 	uint		delblks, blkflags, prjflags = 0;
 	xfs_dquot_t	*unresudq, *unresgdq, *delblksudq, *delblksgdq;
 
-	ASSERT(XFS_ISLOCKED_INODE(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	mp = ip->i_mount;
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
@@ -2717,7 +2718,7 @@ xfs_qm_vop_dqattach_and_dqmod_newinode(
 	if (!XFS_IS_QUOTA_ON(tp->t_mountp))
 		return;
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
 
 	if (udqp) {
Index: linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_quota_priv.h	2008-04-10 18:25:12.000000000 +0200
@@ -27,11 +27,6 @@
 /* Number of dquots that fit in to a dquot block */
 #define XFS_QM_DQPERBLK(mp)	((mp)->m_quotainfo->qi_dqperchunk)
 
-#define XFS_ISLOCKED_INODE(ip)		(ismrlocked(&(ip)->i_lock, \
-					    MR_UPDATE | MR_ACCESS) != 0)
-#define XFS_ISLOCKED_INODE_EXCL(ip)	(ismrlocked(&(ip)->i_lock, \
-					    MR_UPDATE) != 0)
-
 #define XFS_DQ_IS_ADDEDTO_TRX(t, d)	((d)->q_transp == (t))
 
 #define XFS_QI_MPLRECLAIMS(mp)	((mp)->m_quotainfo->qi_dqreclaims)
Index: linux-2.6-xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_trans_dquot.c	2008-04-10 18:25:12.000000000 +0200
@@ -834,7 +834,7 @@ xfs_trans_reserve_quota_nblks(
 	ASSERT(ip->i_ino != mp->m_sb.sb_uquotino);
 	ASSERT(ip->i_ino != mp->m_sb.sb_gquotino);
 
-	ASSERT(XFS_ISLOCKED_INODE_EXCL(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(ip->i_mount));
 	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES | XFS_QMOPT_ENOSPC)) ==
 				XFS_TRANS_DQ_RES_RTBLKS ||
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-04-09 20:02:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-04-10 18:25:12.000000000 +0200
@@ -4074,7 +4074,6 @@ xfs_bmap_add_attrfork(
 error2:
 	xfs_bmap_cancel(&flist);
 error1:
-	ASSERT(ismrlocked(&ip->i_lock,MR_UPDATE));
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 error0:
 	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2008-04-10 19:16:53.000000000 +0200
@@ -593,8 +593,9 @@ xfs_iunlock_map_shared(
  *		XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL
  */
 void
-xfs_ilock(xfs_inode_t	*ip,
-	  uint		lock_flags)
+xfs_ilock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
@@ -607,16 +608,16 @@ xfs_ilock(xfs_inode_t	*ip,
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
 
-	if (lock_flags & XFS_IOLOCK_EXCL) {
+	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrupdate_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
-	} else if (lock_flags & XFS_IOLOCK_SHARED) {
+	else if (lock_flags & XFS_IOLOCK_SHARED)
 		mraccess_nested(&ip->i_iolock, XFS_IOLOCK_DEP(lock_flags));
-	}
-	if (lock_flags & XFS_ILOCK_EXCL) {
+
+	if (lock_flags & XFS_ILOCK_EXCL)
 		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
-	} else if (lock_flags & XFS_ILOCK_SHARED) {
+	else if (lock_flags & XFS_ILOCK_SHARED)
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
-	}
+
 	xfs_ilock_trace(ip, 1, lock_flags, (inst_t *)__return_address);
 }
 
@@ -631,15 +632,12 @@ xfs_ilock(xfs_inode_t	*ip,
  * lock_flags -- this parameter indicates the inode's locks to be
  *       to be locked.  See the comment for xfs_ilock() for a list
  *	 of valid values.
- *
  */
 int
-xfs_ilock_nowait(xfs_inode_t	*ip,
-		 uint		lock_flags)
+xfs_ilock_nowait(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
-	int	iolocked;
-	int	ilocked;
-
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
 	 * and only XFS_IOLOCK_SHARED, XFS_IOLOCK_EXCL, XFS_ILOCK_SHARED,
@@ -651,37 +649,30 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
 
-	iolocked = 0;
 	if (lock_flags & XFS_IOLOCK_EXCL) {
-		iolocked = mrtryupdate(&ip->i_iolock);
-		if (!iolocked) {
-			return 0;
-		}
+		if (!mrtryupdate(&ip->i_iolock))
+			goto out;
 	} else if (lock_flags & XFS_IOLOCK_SHARED) {
-		iolocked = mrtryaccess(&ip->i_iolock);
-		if (!iolocked) {
-			return 0;
-		}
+		if (!mrtryaccess(&ip->i_iolock))
+			goto out;
 	}
 	if (lock_flags & XFS_ILOCK_EXCL) {
-		ilocked = mrtryupdate(&ip->i_lock);
-		if (!ilocked) {
-			if (iolocked) {
-				mrunlock(&ip->i_iolock);
-			}
-			return 0;
-		}
+		if (!mrtryupdate(&ip->i_lock))
+			goto out_undo_iolock;
 	} else if (lock_flags & XFS_ILOCK_SHARED) {
-		ilocked = mrtryaccess(&ip->i_lock);
-		if (!ilocked) {
-			if (iolocked) {
-				mrunlock(&ip->i_iolock);
-			}
-			return 0;
-		}
+		if (!mrtryaccess(&ip->i_lock))
+			goto out_undo_iolock;
 	}
 	xfs_ilock_trace(ip, 2, lock_flags, (inst_t *)__return_address);
 	return 1;
+
+ out_undo_iolock:
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrunlock_excl(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		mrunlock_shared(&ip->i_iolock);
+ out:
+	return 0;
 }
 
 /*
@@ -697,8 +688,9 @@ xfs_ilock_nowait(xfs_inode_t	*ip,
  *
  */
 void
-xfs_iunlock(xfs_inode_t	*ip,
-	    uint	lock_flags)
+xfs_iunlock(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	/*
 	 * You can't set both SHARED and EXCL for the same lock,
@@ -713,31 +705,25 @@ xfs_iunlock(xfs_inode_t	*ip,
 			XFS_LOCK_DEP_MASK)) == 0);
 	ASSERT(lock_flags != 0);
 
-	if (lock_flags & (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL)) {
-		ASSERT(!(lock_flags & XFS_IOLOCK_SHARED) ||
-		       (ismrlocked(&ip->i_iolock, MR_ACCESS)));
-		ASSERT(!(lock_flags & XFS_IOLOCK_EXCL) ||
-		       (ismrlocked(&ip->i_iolock, MR_UPDATE)));
-		mrunlock(&ip->i_iolock);
-	}
-
-	if (lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) {
-		ASSERT(!(lock_flags & XFS_ILOCK_SHARED) ||
-		       (ismrlocked(&ip->i_lock, MR_ACCESS)));
-		ASSERT(!(lock_flags & XFS_ILOCK_EXCL) ||
-		       (ismrlocked(&ip->i_lock, MR_UPDATE)));
-		mrunlock(&ip->i_lock);
+	if (lock_flags & XFS_IOLOCK_EXCL)
+		mrunlock_excl(&ip->i_iolock);
+	else if (lock_flags & XFS_IOLOCK_SHARED)
+		mrunlock_shared(&ip->i_iolock);
+
+	if (lock_flags & XFS_ILOCK_EXCL)
+		mrunlock_excl(&ip->i_lock);
+	else if (lock_flags & XFS_ILOCK_SHARED)
+		mrunlock_shared(&ip->i_lock);
 
+	if ((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) &&
+	    !(lock_flags & XFS_IUNLOCK_NONOTIFY) && ip->i_itemp) {
 		/*
 		 * Let the AIL know that this item has been unlocked in case
 		 * it is in the AIL and anyone is waiting on it.  Don't do
 		 * this if the caller has asked us not to.
 		 */
-		if (!(lock_flags & XFS_IUNLOCK_NONOTIFY) &&
-		     ip->i_itemp != NULL) {
-			xfs_trans_unlocked_item(ip->i_mount,
-						(xfs_log_item_t*)(ip->i_itemp));
-		}
+		xfs_trans_unlocked_item(ip->i_mount,
+					(xfs_log_item_t*)(ip->i_itemp));
 	}
 	xfs_ilock_trace(ip, 3, lock_flags, (inst_t *)__return_address);
 }
@@ -747,21 +733,47 @@ xfs_iunlock(xfs_inode_t	*ip,
  * if it is being demoted.
  */
 void
-xfs_ilock_demote(xfs_inode_t	*ip,
-		 uint		lock_flags)
+xfs_ilock_demote(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
 {
 	ASSERT(lock_flags & (XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL));
 	ASSERT((lock_flags & ~(XFS_IOLOCK_EXCL|XFS_ILOCK_EXCL)) == 0);
 
-	if (lock_flags & XFS_ILOCK_EXCL) {
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	if (lock_flags & XFS_ILOCK_EXCL)
 		mrdemote(&ip->i_lock);
-	}
-	if (lock_flags & XFS_IOLOCK_EXCL) {
-		ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+	if (lock_flags & XFS_IOLOCK_EXCL)
 		mrdemote(&ip->i_iolock);
+}
+
+#ifdef DEBUG
+/*
+ * Debug-only routine, without additional rw_semaphore APIs, we can
+ * now only answer requests regarding whether we hold the lock for write
+ * (reader state is outside our visibility, we only track writer state).
+ *
+ * Note: this means !xfs_isilocked would give false positives, so don't do that.
+ */
+int
+xfs_isilocked(
+	xfs_inode_t		*ip,
+	uint			lock_flags)
+{
+	if ((lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) ==
+			XFS_ILOCK_EXCL) {
+		if (!ip->i_lock.mr_writer)
+			return 0;
+	}
+
+	if ((lock_flags & (XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED)) ==
+			XFS_IOLOCK_EXCL) {
+		if (!ip->i_iolock.mr_writer)
+			return 0;
 	}
+
+	return 1;
 }
+#endif
 
 /*
  * The following three routines simply manage the i_flock
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-04-10 15:05:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-04-10 18:25:12.000000000 +0200
@@ -1291,7 +1291,7 @@ xfs_file_last_byte(
 	xfs_fileoff_t	size_last_block;
 	int		error;
 
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE | MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
 
 	mp = ip->i_mount;
 	/*
@@ -1402,7 +1402,7 @@ xfs_itruncate_start(
 	bhv_vnode_t	*vp;
 	int		error = 0;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT((new_size == 0) || (new_size <= ip->i_size));
 	ASSERT((flags == XFS_ITRUNC_DEFINITE) ||
 	       (flags == XFS_ITRUNC_MAYBE));
@@ -1528,8 +1528,7 @@ xfs_itruncate_finish(
 	xfs_bmap_free_t	free_list;
 	int		error;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT((new_size == 0) || (new_size <= ip->i_size));
 	ASSERT(*tp != NULL);
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -1780,8 +1779,7 @@ xfs_igrow_start(
 	xfs_fsize_t	new_size,
 	cred_t		*credp)
 {
-	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(new_size > ip->i_size);
 
 	/*
@@ -1809,8 +1807,7 @@ xfs_igrow_finish(
 	xfs_fsize_t	new_size,
 	int		change_flag)
 {
-	ASSERT(ismrlocked(&(ip->i_lock), MR_UPDATE) != 0);
-	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
 	ASSERT(ip->i_transp == tp);
 	ASSERT(new_size > ip->i_size);
 
@@ -2287,7 +2284,7 @@ xfs_ifree(
 	xfs_dinode_t    	*dip;
 	xfs_buf_t       	*ibp;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_d.di_nlink == 0);
 	ASSERT(ip->i_d.di_nextents == 0);
@@ -2746,7 +2743,7 @@ void
 xfs_ipin(
 	xfs_inode_t	*ip)
 {
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	atomic_inc(&ip->i_pincount);
 }
@@ -2779,7 +2776,7 @@ __xfs_iunpin_wait(
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE | MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	if (atomic_read(&ip->i_pincount) == 0)
 		return;
 
@@ -2829,7 +2826,7 @@ xfs_iextents_copy(
 	xfs_fsblock_t		start_block;
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(ifp->if_bytes > 0);
 
 	nrecs = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
@@ -3132,7 +3129,7 @@ xfs_iflush(
 
 	XFS_STATS_INC(xs_iflush_count);
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
@@ -3297,7 +3294,7 @@ xfs_iflush_int(
 	int			first;
 #endif
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-04-10 18:25:12.000000000 +0200
@@ -386,20 +386,9 @@ xfs_iflags_test_and_clear(xfs_inode_t *i
 #define	XFS_ILOCK_EXCL		(1<<2)
 #define	XFS_ILOCK_SHARED	(1<<3)
 #define	XFS_IUNLOCK_NONOTIFY	(1<<4)
-/*	#define XFS_IOLOCK_NESTED	(1<<5)	*/
-#define XFS_EXTENT_TOKEN_RD	(1<<6)
-#define XFS_SIZE_TOKEN_RD	(1<<7)
-#define XFS_EXTSIZE_RD		(XFS_EXTENT_TOKEN_RD|XFS_SIZE_TOKEN_RD)
-#define XFS_WILLLEND		(1<<8)	/* Always acquire tokens for lending */
-#define XFS_EXTENT_TOKEN_WR	(XFS_EXTENT_TOKEN_RD | XFS_WILLLEND)
-#define XFS_SIZE_TOKEN_WR       (XFS_SIZE_TOKEN_RD | XFS_WILLLEND)
-#define XFS_EXTSIZE_WR		(XFS_EXTSIZE_RD | XFS_WILLLEND)
-/* TODO:XFS_SIZE_TOKEN_WANT	(1<<9) */
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
-				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED \
-				| XFS_EXTENT_TOKEN_RD | XFS_SIZE_TOKEN_RD \
-				| XFS_WILLLEND)
+				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
 
 /*
  * Flags for lockdep annotations.
@@ -483,6 +472,7 @@ void		xfs_ilock(xfs_inode_t *, uint);
 int		xfs_ilock_nowait(xfs_inode_t *, uint);
 void		xfs_iunlock(xfs_inode_t *, uint);
 void		xfs_ilock_demote(xfs_inode_t *, uint);
+int		xfs_isilocked(xfs_inode_t *, uint);
 void		xfs_iflock(xfs_inode_t *);
 int		xfs_iflock_nowait(xfs_inode_t *);
 uint		xfs_ilock_map_shared(xfs_inode_t *);
Index: linux-2.6-xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode_item.c	2008-04-10 07:24:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode_item.c	2008-04-10 18:25:12.000000000 +0200
@@ -547,7 +547,7 @@ STATIC void
 xfs_inode_item_pin(
 	xfs_inode_log_item_t	*iip)
 {
-	ASSERT(ismrlocked(&(iip->ili_inode->i_lock), MR_UPDATE));
+	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 	xfs_ipin(iip->ili_inode);
 }
 
@@ -664,13 +664,13 @@ xfs_inode_item_unlock(
 
 	ASSERT(iip != NULL);
 	ASSERT(iip->ili_inode->i_itemp != NULL);
-	ASSERT(ismrlocked(&(iip->ili_inode->i_lock), MR_UPDATE));
+	ASSERT(xfs_isilocked(iip->ili_inode, XFS_ILOCK_EXCL));
 	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
 		  XFS_ILI_IOLOCKED_EXCL)) ||
-	       ismrlocked(&(iip->ili_inode->i_iolock), MR_UPDATE));
+	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_EXCL));
 	ASSERT((!(iip->ili_inode->i_itemp->ili_flags &
 		  XFS_ILI_IOLOCKED_SHARED)) ||
-	       ismrlocked(&(iip->ili_inode->i_iolock), MR_ACCESS));
+	       xfs_isilocked(iip->ili_inode, XFS_IOLOCK_SHARED));
 	/*
 	 * Clear the transaction pointer in the inode.
 	 */
@@ -769,7 +769,7 @@ xfs_inode_item_pushbuf(
 
 	ip = iip->ili_inode;
 
-	ASSERT(ismrlocked(&(ip->i_lock), MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 
 	/*
 	 * The ili_pushbuf_flag keeps others from
@@ -857,7 +857,7 @@ xfs_inode_item_push(
 
 	ip = iip->ili_inode;
 
-	ASSERT(ismrlocked(&(ip->i_lock), MR_ACCESS));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
 	ASSERT(issemalocked(&(ip->i_flock)));
 	/*
 	 * Since we were able to lock the inode's flush lock and
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2008-04-09 20:02:27.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2008-04-10 18:25:12.000000000 +0200
@@ -196,14 +196,14 @@ xfs_iomap(
 		break;
 	case BMAPI_WRITE:
 		xfs_iomap_enter_trace(XFS_IOMAP_WRITE_ENTER, ip, offset, count);
-		lockmode = XFS_ILOCK_EXCL|XFS_EXTSIZE_WR;
+		lockmode = XFS_ILOCK_EXCL;
 		if (flags & BMAPI_IGNSTATE)
 			bmapi_flags |= XFS_BMAPI_IGSTATE|XFS_BMAPI_ENTIRE;
 		xfs_ilock(ip, lockmode);
 		break;
 	case BMAPI_ALLOCATE:
 		xfs_iomap_enter_trace(XFS_IOMAP_ALLOC_ENTER, ip, offset, count);
-		lockmode = XFS_ILOCK_SHARED|XFS_EXTSIZE_RD;
+		lockmode = XFS_ILOCK_SHARED;
 		bmapi_flags = XFS_BMAPI_ENTIRE;
 
 		/* Attempt non-blocking lock */
@@ -624,7 +624,7 @@ xfs_iomap_write_delay(
 	int		prealloc, fsynced = 0;
 	int		error;
 
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE) != 0);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Make sure that the dquots are there. This doesn't hold
Index: linux-2.6-xfs/fs/xfs/xfs_trans_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans_inode.c	2008-04-07 09:33:00.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_trans_inode.c	2008-04-10 18:25:12.000000000 +0200
@@ -111,13 +111,13 @@ xfs_trans_iget(
 		 */
 		ASSERT(ip->i_itemp != NULL);
 		ASSERT(lock_flags & XFS_ILOCK_EXCL);
-		ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
-		       ismrlocked(&ip->i_iolock, MR_UPDATE));
+		       xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_EXCL)) ||
 		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_EXCL));
 		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
-		       ismrlocked(&ip->i_iolock, (MR_UPDATE | MR_ACCESS)));
+		       xfs_isilocked(ip, XFS_IOLOCK_EXCL|XFS_IOLOCK_SHARED));
 		ASSERT((!(lock_flags & XFS_IOLOCK_SHARED)) ||
 		       (ip->i_itemp->ili_flags & XFS_ILI_IOLOCKED_ANY));
 
@@ -185,7 +185,7 @@ xfs_trans_ijoin(
 	xfs_inode_log_item_t	*iip;
 
 	ASSERT(ip->i_transp == NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(lock_flags & XFS_ILOCK_EXCL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
@@ -232,7 +232,7 @@ xfs_trans_ihold(
 {
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	ip->i_itemp->ili_flags |= XFS_ILI_HOLD;
 }
@@ -257,7 +257,7 @@ xfs_trans_log_inode(
 
 	ASSERT(ip->i_transp == tp);
 	ASSERT(ip->i_itemp != NULL);
-	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	lidp = xfs_trans_find_item(tp, (xfs_log_item_t*)(ip->i_itemp));
 	ASSERT(lidp != NULL);
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2008-04-10 15:05:31.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2008-04-10 18:25:12.000000000 +0200
@@ -267,7 +267,7 @@ xfs_bump_ino_vers2(
 {
 	xfs_mount_t	*mp;
 
-	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1);
 
 	ip->i_d.di_version = XFS_DINODE_VERSION_2;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-04-10 15:05:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-04-10 18:25:12.000000000 +0200
@@ -1443,7 +1443,7 @@ xfs_inactive_attrs(
 	int		error;
 	xfs_mount_t	*mp;
 
-	ASSERT(ismrlocked(&ip->i_iolock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	tp = *tpp;
 	mp = ip->i_mount;
 	ASSERT(ip->i_d.di_forkoff != 0);
@@ -1914,7 +1914,7 @@ xfs_create(
 	 * It is locked (and joined to the transaction).
 	 */
 
-	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	/*
 	 * Now we join the directory inode to the transaction.  We do not do it
