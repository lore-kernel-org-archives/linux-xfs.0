Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 21:12:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6K4CVbm028103
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 21:12:33 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id D6AA41801056F
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 23:12:33 -0500 (CDT)
Message-ID: <46A03631.7060604@sandeen.net>
Date: Thu, 19 Jul 2007 23:12:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 7/7] - remove unused variable from locking macros
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

The "s" in these locking macros used to be used like flags
in spin_lock_irqsave; but in the xfs codebase today it's 
never used.

gcc optimizes it away, but still, why keep it around?

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/linux-2.4/spin.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/spin.h
+++ linux/fs/xfs/linux-2.4/spin.h
@@ -30,15 +30,12 @@
 
 typedef spinlock_t lock_t;
 
-#define SPLDECL(s)			unsigned long s
 #define DEFINE_SPINLOCK(s)		spinlock_t s = SPIN_LOCK_UNLOCKED
 
 #define spinlock_init(lock, name)	spin_lock_init(lock)
 #define	spinlock_destroy(lock)
-#define mutex_spinlock(lock)		({ spin_lock(lock); 0; })
-#define mutex_spinunlock(lock, s)	do { spin_unlock(lock); (void)s; } while (0)
-#define nested_spinlock(lock)		spin_lock(lock)
-#define nested_spinunlock(lock)		spin_unlock(lock)
+#define mutex_spinlock(lock)		spin_lock(lock)
+#define mutex_spinunlock(lock)		spin_unlock(lock)
 
 #ifndef HAVE_WRITE_TRYLOCK
 #define write_trylock(lock)		(0)
Index: linux/fs/xfs/linux-2.4/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_super.c
+++ linux/fs/xfs/linux-2.4/xfs_super.c
@@ -405,7 +405,7 @@ xfs_fs_clear_inode(
 
 	VN_LOCK(vp);
 	vp->v_flag &= ~VMODIFIED;
-	VN_UNLOCK(vp, 0);
+	VN_UNLOCK(vp);
 
 	if (VNHEAD(vp))
 		if (bhv_vop_reclaim(vp))
Index: linux/fs/xfs/linux-2.4/xfs_vnode.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_vnode.c
+++ linux/fs/xfs/linux-2.4/xfs_vnode.c
@@ -144,7 +144,7 @@ vn_hold(
 	VN_LOCK(vp);
 	inode = igrab(vn_to_inode(vp));
 	ASSERT(inode);
-	VN_UNLOCK(vp, 0);
+	VN_UNLOCK(vp);
 
 	return vp;
 }
Index: linux/fs/xfs/linux-2.4/xfs_vnode.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_vnode.h
+++ linux/fs/xfs/linux-2.4/xfs_vnode.h
@@ -466,7 +466,7 @@ static inline struct bhv_vnode *vn_grab(
  * Vnode spinlock manipulation.
  */
 #define VN_LOCK(vp)		mutex_spinlock(&(vp)->v_lock)
-#define VN_UNLOCK(vp, s)	mutex_spinunlock(&(vp)->v_lock, s)
+#define VN_UNLOCK(vp)		mutex_spinunlock(&(vp)->v_lock)
 
 STATIC_INLINE void vn_flagset(struct bhv_vnode *vp, uint flag)
 {
Index: linux/fs/xfs/linux-2.6/spin.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/spin.h
+++ linux/fs/xfs/linux-2.6/spin.h
@@ -30,16 +30,13 @@
 
 typedef spinlock_t lock_t;
 
-#define SPLDECL(s)			unsigned long s
 #ifndef DEFINE_SPINLOCK
 #define DEFINE_SPINLOCK(s)		spinlock_t s = SPIN_LOCK_UNLOCKED
 #endif
 
 #define spinlock_init(lock, name)	spin_lock_init(lock)
 #define	spinlock_destroy(lock)
-#define mutex_spinlock(lock)		({ spin_lock(lock); 0; })
-#define mutex_spinunlock(lock, s)	do { spin_unlock(lock); (void)s; } while (0)
-#define nested_spinlock(lock)		spin_lock(lock)
-#define nested_spinunlock(lock)		spin_unlock(lock)
+#define mutex_spinlock(lock)		spin_lock(lock)
+#define mutex_spinunlock(lock)		spin_unlock(lock)
 
 #endif /* __XFS_SUPPORT_SPIN_H__ */
Index: linux/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux/fs/xfs/linux-2.6/xfs_super.c
@@ -447,7 +447,7 @@ xfs_fs_clear_inode(
 
 	VN_LOCK(vp);
 	vp->v_flag &= ~VMODIFIED;
-	VN_UNLOCK(vp, 0);
+	VN_UNLOCK(vp);
 
 	if (VNHEAD(vp))
 		if (bhv_vop_reclaim(vp))
Index: linux/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_vnode.c
+++ linux/fs/xfs/linux-2.6/xfs_vnode.c
@@ -183,7 +183,7 @@ vn_hold(
 	VN_LOCK(vp);
 	inode = igrab(vn_to_inode(vp));
 	ASSERT(inode);
-	VN_UNLOCK(vp, 0);
+	VN_UNLOCK(vp);
 
 	return vp;
 }
Index: linux/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ linux/fs/xfs/linux-2.6/xfs_vnode.h
@@ -485,7 +485,7 @@ static inline struct bhv_vnode *vn_grab(
  * Vnode spinlock manipulation.
  */
 #define VN_LOCK(vp)		mutex_spinlock(&(vp)->v_lock)
-#define VN_UNLOCK(vp, s)	mutex_spinunlock(&(vp)->v_lock, s)
+#define VN_UNLOCK(vp)		mutex_spinunlock(&(vp)->v_lock)
 
 STATIC_INLINE void vn_flagset(struct bhv_vnode *vp, uint flag)
 {
Index: linux/fs/xfs/quota/xfs_dquot.c
===================================================================
--- linux.orig/fs/xfs/quota/xfs_dquot.c
+++ linux/fs/xfs/quota/xfs_dquot.c
@@ -1209,7 +1209,6 @@ xfs_qm_dqflush(
 	xfs_buf_t		*bp;
 	xfs_disk_dquot_t	*ddqp;
 	int			error;
-	SPLDECL(s);
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(XFS_DQ_IS_FLUSH_LOCKED(dqp));
@@ -1270,9 +1269,9 @@ xfs_qm_dqflush(
 	mp = dqp->q_mount;
 
 	/* lsn is 64 bits */
-	AIL_LOCK(mp, s);
+	AIL_LOCK(mp);
 	dqp->q_logitem.qli_flush_lsn = dqp->q_logitem.qli_item.li_lsn;
-	AIL_UNLOCK(mp, s);
+	AIL_UNLOCK(mp);
 
 	/*
 	 * Attach an iodone routine so that we can remove this dquot from the
@@ -1318,7 +1317,6 @@ xfs_qm_dqflush_done(
 	xfs_dq_logitem_t	*qip)
 {
 	xfs_dquot_t		*dqp;
-	SPLDECL(s);
 
 	dqp = qip->qli_dquot;
 
@@ -1333,15 +1331,15 @@ xfs_qm_dqflush_done(
 	if ((qip->qli_item.li_flags & XFS_LI_IN_AIL) &&
 	    qip->qli_item.li_lsn == qip->qli_flush_lsn) {
 
-		AIL_LOCK(dqp->q_mount, s);
+		AIL_LOCK(dqp->q_mount);
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
 		 */
 		if (qip->qli_item.li_lsn == qip->qli_flush_lsn)
 			xfs_trans_delete_ail(dqp->q_mount,
-					     (xfs_log_item_t*)qip, s);
+					     (xfs_log_item_t*)qip);
 		else
-			AIL_UNLOCK(dqp->q_mount, s);
+			AIL_UNLOCK(dqp->q_mount);
 	}
 
 	/*
Index: linux/fs/xfs/quota/xfs_dquot.h
===================================================================
--- linux.orig/fs/xfs/quota/xfs_dquot.h
+++ linux/fs/xfs/quota/xfs_dquot.h
@@ -125,8 +125,8 @@ XFS_DQ_IS_LOCKED(xfs_dquot_t *dqp)
 
 #define XFS_DQ_PINLOCK(dqp)	   mutex_spinlock( \
 				     &(XFS_DQ_TO_QINF(dqp)->qi_pinlock))
-#define XFS_DQ_PINUNLOCK(dqp, s)   mutex_spinunlock( \
-				     &(XFS_DQ_TO_QINF(dqp)->qi_pinlock), s)
+#define XFS_DQ_PINUNLOCK(dqp)      mutex_spinunlock( \
+				     &(XFS_DQ_TO_QINF(dqp)->qi_pinlock))
 
 #define XFS_DQ_IS_FLUSH_LOCKED(dqp) (issemalocked(&((dqp)->q_flock)))
 #define XFS_DQ_IS_ON_FREELIST(dqp)  ((dqp)->dq_flnext != (dqp))
Index: linux/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- linux.orig/fs/xfs/quota/xfs_dquot_item.c
+++ linux/fs/xfs/quota/xfs_dquot_item.c
@@ -94,14 +94,13 @@ STATIC void
 xfs_qm_dquot_logitem_pin(
 	xfs_dq_logitem_t *logitem)
 {
-	unsigned long	s;
 	xfs_dquot_t *dqp;
 
 	dqp = logitem->qli_dquot;
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
-	s = XFS_DQ_PINLOCK(dqp);
+	XFS_DQ_PINLOCK(dqp);
 	dqp->q_pincount++;
-	XFS_DQ_PINUNLOCK(dqp, s);
+	XFS_DQ_PINUNLOCK(dqp);
 }
 
 /*
@@ -115,17 +114,16 @@ xfs_qm_dquot_logitem_unpin(
 	xfs_dq_logitem_t *logitem,
 	int		  stale)
 {
-	unsigned long	s;
 	xfs_dquot_t *dqp;
 
 	dqp = logitem->qli_dquot;
 	ASSERT(dqp->q_pincount > 0);
-	s = XFS_DQ_PINLOCK(dqp);
+	XFS_DQ_PINLOCK(dqp);
 	dqp->q_pincount--;
 	if (dqp->q_pincount == 0) {
 		sv_broadcast(&dqp->q_pinwait);
 	}
-	XFS_DQ_PINUNLOCK(dqp, s);
+	XFS_DQ_PINUNLOCK(dqp);
 }
 
 /* ARGSUSED */
@@ -189,8 +187,6 @@ void
 xfs_qm_dqunpin_wait(
 	xfs_dquot_t	*dqp)
 {
-	SPLDECL(s);
-
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	if (dqp->q_pincount == 0) {
 		return;
@@ -200,9 +196,9 @@ xfs_qm_dqunpin_wait(
 	 * Give the log a push so we don't wait here too long.
 	 */
 	xfs_log_force(dqp->q_mount, (xfs_lsn_t)0, XFS_LOG_FORCE);
-	s = XFS_DQ_PINLOCK(dqp);
+	XFS_DQ_PINLOCK(dqp);
 	if (dqp->q_pincount == 0) {
-		XFS_DQ_PINUNLOCK(dqp, s);
+		XFS_DQ_PINUNLOCK(dqp);
 		return;
 	}
 	sv_wait(&(dqp->q_pinwait), PINOD,
@@ -562,15 +558,14 @@ xfs_qm_qoffend_logitem_committed(
 	xfs_lsn_t lsn)
 {
 	xfs_qoff_logitem_t	*qfs;
-	SPLDECL(s);
 
 	qfs = qfe->qql_start_lip;
-	AIL_LOCK(qfs->qql_item.li_mountp,s);
+	AIL_LOCK(qfs->qql_item.li_mountp);
 	/*
 	 * Delete the qoff-start logitem from the AIL.
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
-	xfs_trans_delete_ail(qfs->qql_item.li_mountp, (xfs_log_item_t *)qfs, s);
+	xfs_trans_delete_ail(qfs->qql_item.li_mountp, (xfs_log_item_t *)qfs);
 	kmem_free(qfs, sizeof(xfs_qoff_logitem_t));
 	kmem_free(qfe, sizeof(xfs_qoff_logitem_t));
 	return (xfs_lsn_t)-1;
Index: linux/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux.orig/fs/xfs/quota/xfs_qm.c
+++ linux/fs/xfs/quota/xfs_qm.c
@@ -344,7 +344,6 @@ xfs_qm_mount_quotas(
 	xfs_mount_t	*mp,
 	int		mfsi_flags)
 {
-	unsigned long	s;
 	int		error = 0;
 	uint		sbf;
 
@@ -404,10 +403,10 @@ xfs_qm_mount_quotas(
 	 * We actually don't have to acquire the SB_LOCK at all.
 	 * This can only be called from mount, and that's single threaded. XXX
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	sbf = mp->m_sb.sb_qflags;
 	mp->m_sb.sb_qflags = mp->m_qflags & XFS_MOUNT_QUOTA_ALL;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	if (sbf != (mp->m_qflags & XFS_MOUNT_QUOTA_ALL)) {
 		if (xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS)) {
@@ -1401,7 +1400,6 @@ xfs_qm_qino_alloc(
 {
 	xfs_trans_t	*tp;
 	int		error;
-	unsigned long	s;
 	int		committed;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_QINOCREATE);
@@ -1433,7 +1431,7 @@ xfs_qm_qino_alloc(
 	 * sbfields arg may contain fields other than *QUOTINO;
 	 * VERSIONNUM for example.
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	if (flags & XFS_QMOPT_SBVERSION) {
 #if defined(DEBUG) && defined(XFS_LOUD_RECOVERY)
 		unsigned oldv = mp->m_sb.sb_versionnum;
@@ -1460,7 +1458,7 @@ xfs_qm_qino_alloc(
 		mp->m_sb.sb_uquotino = (*ip)->i_ino;
 	else
 		mp->m_sb.sb_gquotino = (*ip)->i_ino;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 	xfs_mod_sb(tp, sbfields);
 
 	if ((error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES))) {
Index: linux/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux.orig/fs/xfs/quota/xfs_qm_syscalls.c
+++ linux/fs/xfs/quota/xfs_qm_syscalls.c
@@ -205,7 +205,6 @@ xfs_qm_scall_quotaoff(
 	boolean_t		force)
 {
 	uint			dqtype;
-	unsigned long	s;
 	int			error;
 	uint			inactivate_flags;
 	xfs_qoff_logitem_t	*qoffstart;
@@ -242,9 +241,9 @@ xfs_qm_scall_quotaoff(
 	if ((flags & XFS_ALL_QUOTA_ACCT) == 0) {
 		mp->m_qflags &= ~(flags);
 
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		mp->m_sb.sb_qflags = mp->m_qflags;
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 		mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
 
 		/* XXX what to do if error ? Revert back to old vals incore ? */
@@ -420,7 +419,6 @@ xfs_qm_scall_quotaon(
 	uint		flags)
 {
 	int		error;
-	unsigned long	s;
 	uint		qf;
 	uint		accflags;
 	__int64_t	sbflags;
@@ -473,10 +471,10 @@ xfs_qm_scall_quotaon(
 	 * Change sb_qflags on disk but not incore mp->qflags
 	 * if this is the root filesystem.
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	qf = mp->m_sb.sb_qflags;
 	mp->m_sb.sb_qflags = qf | flags;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	/*
 	 * There's nothing to change if it's the same.
@@ -820,7 +818,6 @@ xfs_qm_log_quotaoff(
 {
 	xfs_trans_t	       *tp;
 	int			error;
-	unsigned long	s;
 	xfs_qoff_logitem_t     *qoffi=NULL;
 	uint			oldsbqflag=0;
 
@@ -837,10 +834,10 @@ xfs_qm_log_quotaoff(
 	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
 
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	oldsbqflag = mp->m_sb.sb_qflags;
 	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	xfs_mod_sb(tp, XFS_SB_QFLAGS);
 
@@ -859,9 +856,9 @@ error0:
 		 * No one else is modifying sb_qflags, so this is OK.
 		 * We still hold the quotaofflock.
 		 */
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		mp->m_sb.sb_qflags = oldsbqflag;
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 	}
 	*qoffstartp = qoffi;
 	return (error);
Index: linux/fs/xfs/xfs_alloc.c
===================================================================
--- linux.orig/fs/xfs/xfs_alloc.c
+++ linux/fs/xfs/xfs_alloc.c
@@ -2500,10 +2500,9 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*bsy;
 	int			n;
-	SPLDECL(s);
 
 	mp = tp->t_mountp;
-	s = mutex_spinlock(&mp->m_perag[agno].pagb_lock);
+	mutex_spinlock(&mp->m_perag[agno].pagb_lock);
 
 	/* search pagb_list for an open slot */
 	for (bsy = mp->m_perag[agno].pagb_list, n = 0;
@@ -2533,7 +2532,7 @@ xfs_alloc_mark_busy(xfs_trans_t *tp,
 		xfs_trans_set_sync(tp);
 	}
 
-	mutex_spinunlock(&mp->m_perag[agno].pagb_lock, s);
+	mutex_spinunlock(&mp->m_perag[agno].pagb_lock);
 }
 
 void
@@ -2543,11 +2542,10 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 {
 	xfs_mount_t		*mp;
 	xfs_perag_busy_t	*list;
-	SPLDECL(s);
 
 	mp = tp->t_mountp;
 
-	s = mutex_spinlock(&mp->m_perag[agno].pagb_lock);
+	mutex_spinlock(&mp->m_perag[agno].pagb_lock);
 	list = mp->m_perag[agno].pagb_list;
 
 	ASSERT(idx < XFS_PAGB_NUM_SLOTS);
@@ -2559,7 +2557,7 @@ xfs_alloc_clear_busy(xfs_trans_t *tp,
 		TRACE_UNBUSY("xfs_alloc_clear_busy", "missing", agno, idx, tp);
 	}
 
-	mutex_spinunlock(&mp->m_perag[agno].pagb_lock, s);
+	mutex_spinunlock(&mp->m_perag[agno].pagb_lock);
 }
 
 
@@ -2578,11 +2576,10 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	xfs_agblock_t		uend, bend;
 	xfs_lsn_t		lsn;
 	int			cnt;
-	SPLDECL(s);
 
 	mp = tp->t_mountp;
 
-	s = mutex_spinlock(&mp->m_perag[agno].pagb_lock);
+	mutex_spinlock(&mp->m_perag[agno].pagb_lock);
 	cnt = mp->m_perag[agno].pagb_count;
 
 	uend = bno + len - 1;
@@ -2615,12 +2612,12 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 	if (cnt) {
 		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "found", agno, bno, len, n, tp);
 		lsn = bsy->busy_tp->t_commit_lsn;
-		mutex_spinunlock(&mp->m_perag[agno].pagb_lock, s);
+		mutex_spinunlock(&mp->m_perag[agno].pagb_lock);
 		xfs_log_force(mp, lsn, XFS_LOG_FORCE|XFS_LOG_SYNC);
 	} else {
 		TRACE_BUSYSEARCH("xfs_alloc_search_busy", "not-found", agno, bno, len, n, tp);
 		n = -1;
-		mutex_spinunlock(&mp->m_perag[agno].pagb_lock, s);
+		mutex_spinunlock(&mp->m_perag[agno].pagb_lock);
 	}
 
 	return n;
Index: linux/fs/xfs/xfs_attr_leaf.c
===================================================================
--- linux.orig/fs/xfs/xfs_attr_leaf.c
+++ linux/fs/xfs/xfs_attr_leaf.c
@@ -226,17 +226,15 @@ xfs_attr_shortform_bytesfit(xfs_inode_t 
 STATIC void
 xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
 {
-	unsigned long s;
-
 	if ((mp->m_flags & XFS_MOUNT_ATTR2) &&
 	    !(XFS_SB_VERSION_HASATTR2(&mp->m_sb))) {
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		if (!XFS_SB_VERSION_HASATTR2(&mp->m_sb)) {
 			XFS_SB_VERSION_ADDATTR2(&mp->m_sb);
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 			xfs_mod_sb(tp, XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
 		} else
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 	}
 }
 
Index: linux/fs/xfs/xfs_bmap.c
===================================================================
--- linux.orig/fs/xfs/xfs_bmap.c
+++ linux/fs/xfs/xfs_bmap.c
@@ -3970,7 +3970,6 @@ xfs_bmap_add_attrfork(
 	xfs_bmap_free_t		flist;		/* freed extent records */
 	xfs_mount_t		*mp;		/* mount structure */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	unsigned long		s;		/* spinlock spl value */
 	int			blks;		/* space reservation */
 	int			version = 1;	/* superblock attr version */
 	int			committed;	/* xaction was committed */
@@ -4067,7 +4066,7 @@ xfs_bmap_add_attrfork(
 	   (!XFS_SB_VERSION_HASATTR2(&mp->m_sb) && version == 2)) {
 		__int64_t sbfields = 0;
 
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		if (!XFS_SB_VERSION_HASATTR(&mp->m_sb)) {
 			XFS_SB_VERSION_ADDATTR(&mp->m_sb);
 			sbfields |= XFS_SB_VERSIONNUM;
@@ -4077,10 +4076,10 @@ xfs_bmap_add_attrfork(
 			sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
 		}
 		if (sbfields) {
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 			xfs_mod_sb(tp, sbfields);
 		} else
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 	}
 	if ((error = xfs_bmap_finish(&tp, &flist, &committed)))
 		goto error2;
Index: linux/fs/xfs/xfs_buf_item.c
===================================================================
--- linux.orig/fs/xfs/xfs_buf_item.c
+++ linux/fs/xfs/xfs_buf_item.c
@@ -377,7 +377,6 @@ xfs_buf_item_unpin(
 	xfs_mount_t	*mp;
 	xfs_buf_t	*bp;
 	int		freed;
-	SPLDECL(s);
 
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
@@ -408,8 +407,8 @@ xfs_buf_item_unpin(
 			XFS_BUF_SET_FSPRIVATE(bp, NULL);
 			XFS_BUF_CLR_IODONE_FUNC(bp);
 		} else {
-			AIL_LOCK(mp,s);
-			xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip, s);
+			AIL_LOCK(mp);
+			xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
 			xfs_buf_item_relse(bp);
 			ASSERT(XFS_BUF_FSPRIVATE(bp, void *) == NULL);
 		}
@@ -1112,7 +1111,6 @@ xfs_buf_iodone(
 	xfs_buf_log_item_t	*bip)
 {
 	struct xfs_mount	*mp;
-	SPLDECL(s);
 
 	ASSERT(bip->bli_buf == bp);
 
@@ -1127,11 +1125,11 @@ xfs_buf_iodone(
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 	/*
 	 * xfs_trans_delete_ail() drops the AIL lock.
 	 */
-	xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip, s);
+	xfs_trans_delete_ail(mp, (xfs_log_item_t *)bip);
 
 #ifdef XFS_TRANS_DEBUG
 	kmem_free(bip->bli_orig, XFS_BUF_COUNT(bp));
Index: linux/fs/xfs/xfs_da_btree.c
===================================================================
--- linux.orig/fs/xfs/xfs_da_btree.c
+++ linux/fs/xfs/xfs_da_btree.c
@@ -2265,10 +2265,9 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 	}
 #ifdef XFS_DABUF_DEBUG
 	{
-		SPLDECL(s);
 		xfs_dabuf_t	*p;
 
-		s = mutex_spinlock(&xfs_dabuf_global_lock);
+		mutex_spinlock(&xfs_dabuf_global_lock);
 		for (p = xfs_dabuf_global_list; p; p = p->next) {
 			ASSERT(p->blkno != dabuf->blkno ||
 			       p->target != dabuf->target);
@@ -2278,7 +2277,7 @@ xfs_da_buf_make(int nbuf, xfs_buf_t **bp
 			xfs_dabuf_global_list->prev = dabuf;
 		dabuf->next = xfs_dabuf_global_list;
 		xfs_dabuf_global_list = dabuf;
-		mutex_spinunlock(&xfs_dabuf_global_lock, s);
+		mutex_spinunlock(&xfs_dabuf_global_lock);
 	}
 #endif
 	return dabuf;
@@ -2320,16 +2319,14 @@ xfs_da_buf_done(xfs_dabuf_t *dabuf)
 		kmem_free(dabuf->data, BBTOB(dabuf->bbcount));
 #ifdef XFS_DABUF_DEBUG
 	{
-		SPLDECL(s);
-
-		s = mutex_spinlock(&xfs_dabuf_global_lock);
+		mutex_spinlock(&xfs_dabuf_global_lock);
 		if (dabuf->prev)
 			dabuf->prev->next = dabuf->next;
 		else
 			xfs_dabuf_global_list = dabuf->next;
 		if (dabuf->next)
 			dabuf->next->prev = dabuf->prev;
-		mutex_spinunlock(&xfs_dabuf_global_lock, s);
+		mutex_spinunlock(&xfs_dabuf_global_lock);
 	}
 	memset(dabuf, 0, XFS_DA_BUF_SIZE(dabuf->nbuf));
 #endif
Index: linux/fs/xfs/xfs_extfree_item.c
===================================================================
--- linux.orig/fs/xfs/xfs_extfree_item.c
+++ linux/fs/xfs/xfs_extfree_item.c
@@ -109,19 +109,18 @@ STATIC void
 xfs_efi_item_unpin(xfs_efi_log_item_t *efip, int stale)
 {
 	xfs_mount_t	*mp;
-	SPLDECL(s);
 
 	mp = efip->efi_item.li_mountp;
-	AIL_LOCK(mp, s);
+	AIL_LOCK(mp);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
 		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip, s);
+		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 	}
 }
 
@@ -137,10 +136,9 @@ xfs_efi_item_unpin_remove(xfs_efi_log_it
 {
 	xfs_mount_t	*mp;
 	xfs_log_item_desc_t	*lidp;
-	SPLDECL(s);
 
 	mp = efip->efi_item.li_mountp;
-	AIL_LOCK(mp, s);
+	AIL_LOCK(mp);
 	if (efip->efi_flags & XFS_EFI_CANCELED) {
 		/*
 		 * free the xaction descriptor pointing to this item
@@ -151,11 +149,11 @@ xfs_efi_item_unpin_remove(xfs_efi_log_it
 		 * pull the item off the AIL.
 		 * xfs_trans_delete_ail() drops the AIL lock.
 		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip, s);
+		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
 		efip->efi_flags |= XFS_EFI_COMMITTED;
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 	}
 }
 
@@ -349,13 +347,12 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 {
 	xfs_mount_t	*mp;
 	int		extents_left;
-	SPLDECL(s);
 
 	mp = efip->efi_item.li_mountp;
 	ASSERT(efip->efi_next_extent > 0);
 	ASSERT(efip->efi_flags & XFS_EFI_COMMITTED);
 
-	AIL_LOCK(mp, s);
+	AIL_LOCK(mp);
 	ASSERT(efip->efi_next_extent >= nextents);
 	efip->efi_next_extent -= nextents;
 	extents_left = efip->efi_next_extent;
@@ -363,10 +360,10 @@ xfs_efi_release(xfs_efi_log_item_t	*efip
 		/*
 		 * xfs_trans_delete_ail() drops the AIL lock.
 		 */
-		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip, s);
+		xfs_trans_delete_ail(mp, (xfs_log_item_t *)efip);
 		xfs_efi_item_free(efip);
 	} else {
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 	}
 }
 
Index: linux/fs/xfs/xfs_fsops.c
===================================================================
--- linux.orig/fs/xfs/xfs_fsops.c
+++ linux/fs/xfs/xfs_fsops.c
@@ -464,15 +464,13 @@ xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
 {
-	unsigned long	s;
-
 	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	cnt->freedata = mp->m_sb.sb_fdblocks - XFS_ALLOC_SET_ASIDE(mp);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	cnt->freeino = mp->m_sb.sb_ifree;
 	cnt->allocino = mp->m_sb.sb_icount;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 	return 0;
 }
 
@@ -499,7 +497,6 @@ xfs_reserve_blocks(
 {
 	__int64_t		lcounter, delta, fdblks_delta;
 	__uint64_t		request;
-	unsigned long		s;
 
 	/* If inval is null, report current values and return */
 	if (inval == (__uint64_t *)NULL) {
@@ -528,7 +525,7 @@ xfs_reserve_blocks(
 	 * enabled, disabled or even compiled in....
 	 */
 retry:
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_SB_LOCKED);
 
 	/*
@@ -571,7 +568,7 @@ out:
 		outval->resblks = mp->m_resblks;
 		outval->resblks_avail = mp->m_resblks_avail;
 	}
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	if (fdblks_delta) {
 		/*
Index: linux/fs/xfs/xfs_iget.c
===================================================================
--- linux.orig/fs/xfs/xfs_iget.c
+++ linux/fs/xfs/xfs_iget.c
@@ -201,7 +201,6 @@ xfs_iget_core(
 	/* REFERENCED */
 	xfs_chash_t	*ch;
 	xfs_chashlist_t	*chl, *chlnew;
-	SPLDECL(s);
 
 
 	ih = XFS_IHASH(mp, ino);
@@ -408,7 +407,7 @@ finish_inode:
 	chlnew = NULL;
 	ch = XFS_CHASH(mp, ip->i_blkno);
  chlredo:
-	s = mutex_spinlock(&ch->ch_lock);
+	mutex_spinlock(&ch->ch_lock);
 	for (chl = ch->ch_list; chl != NULL; chl = chl->chl_next) {
 		if (chl->chl_blkno == ip->i_blkno) {
 
@@ -432,7 +431,7 @@ finish_inode:
 	/* no hash list found for this block; add a new hash list */
 	if (chl == NULL)  {
 		if (chlnew == NULL) {
-			mutex_spinunlock(&ch->ch_lock, s);
+			mutex_spinunlock(&ch->ch_lock);
 			ASSERT(xfs_chashlist_zone != NULL);
 			chlnew = (xfs_chashlist_t *)
 					kmem_zone_alloc(xfs_chashlist_zone,
@@ -458,7 +457,7 @@ finish_inode:
 		}
 	}
 
-	mutex_spinunlock(&ch->ch_lock, s);
+	mutex_spinunlock(&ch->ch_lock);
 
 
 	/*
@@ -723,7 +722,6 @@ xfs_iextract(
 	xfs_mount_t	*mp;
 	xfs_chash_t	*ch;
 	xfs_chashlist_t *chl, *chm;
-	SPLDECL(s);
 
 	ih = ip->i_hash;
 	write_lock(&ih->ih_lock);
@@ -742,7 +740,7 @@ xfs_iextract(
 	 */
 	mp = ip->i_mount;
 	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
+	mutex_spinlock(&ch->ch_lock);
 
 	if (ip->i_cnext == ip) {
 		/* Last inode on chashlist */
@@ -769,7 +767,7 @@ xfs_iextract(
 		ip->i_cprev = __return_address;
 		ip->i_cnext = __return_address;
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
+	mutex_spinunlock(&ch->ch_lock);
 
 	/*
 	 * Remove from mount's inode list.
Index: linux/fs/xfs/xfs_inode.c
===================================================================
--- linux.orig/fs/xfs/xfs_inode.c
+++ linux/fs/xfs/xfs_inode.c
@@ -2193,7 +2193,6 @@ xfs_ifree_cluster(
 	xfs_inode_t		*ip, **ip_found;
 	xfs_inode_log_item_t	*iip;
 	xfs_log_item_t		*lip;
-	SPLDECL(s);
 
 	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
 		blks_per_cluster = 1;
@@ -2299,9 +2298,9 @@ xfs_ifree_cluster(
 				iip = (xfs_inode_log_item_t *)lip;
 				ASSERT(iip->ili_logged == 1);
 				lip->li_cb = (void(*)(xfs_buf_t*,xfs_log_item_t*)) xfs_istale_done;
-				AIL_LOCK(mp,s);
+				AIL_LOCK(mp);
 				iip->ili_flush_lsn = iip->ili_item.li_lsn;
-				AIL_UNLOCK(mp, s);
+				AIL_UNLOCK(mp);
 				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
 				pre_flushed++;
 			}
@@ -2322,9 +2321,9 @@ xfs_ifree_cluster(
 			iip->ili_last_fields = iip->ili_format.ilf_fields;
 			iip->ili_format.ilf_fields = 0;
 			iip->ili_logged = 1;
-			AIL_LOCK(mp,s);
+			AIL_LOCK(mp);
 			iip->ili_flush_lsn = iip->ili_item.li_lsn;
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 
 			xfs_buf_attach_iodone(bp,
 				(void(*)(xfs_buf_t*,xfs_log_item_t*))
@@ -2758,16 +2757,15 @@ xfs_idestroy(
 		 */
 		xfs_mount_t	*mp = ip->i_mount;
 		xfs_log_item_t	*lip = &ip->i_itemp->ili_item;
-		int		s;
 
 		ASSERT(((lip->li_flags & XFS_LI_IN_AIL) == 0) ||
 				       XFS_FORCED_SHUTDOWN(ip->i_mount));
 		if (lip->li_flags & XFS_LI_IN_AIL) {
-			AIL_LOCK(mp, s);
+			AIL_LOCK(mp);
 			if (lip->li_flags & XFS_LI_IN_AIL)
-				xfs_trans_delete_ail(mp, lip, s);
+				xfs_trans_delete_ail(mp, lip);
 			else
-				AIL_UNLOCK(mp, s);
+				AIL_UNLOCK(mp);
 		}
 		xfs_inode_item_destroy(ip);
 	}
@@ -3067,7 +3065,6 @@ xfs_iflush(
 	int			clcount;	/* count of inodes clustered */
 	int			bufwasdelwri;
 	enum { INT_DELWRI = (1 << 0), INT_ASYNC = (1 << 1) };
-	SPLDECL(s);
 
 	XFS_STATS_INC(xs_iflush_count);
 
@@ -3185,7 +3182,7 @@ xfs_iflush(
 	ip->i_chash->chl_buf = bp;
 
 	ch = XFS_CHASH(mp, ip->i_blkno);
-	s = mutex_spinlock(&ch->ch_lock);
+	mutex_spinlock(&ch->ch_lock);
 
 	clcount = 0;
 	for (iq = ip->i_cnext; iq != ip; iq = iq->i_cnext) {
@@ -3239,7 +3236,7 @@ xfs_iflush(
 			xfs_iunlock(iq, XFS_ILOCK_SHARED);
 		}
 	}
-	mutex_spinunlock(&ch->ch_lock, s);
+	mutex_spinunlock(&ch->ch_lock);
 
 	if (clcount) {
 		XFS_STATS_INC(xs_icluster_flushcnt);
@@ -3276,7 +3273,7 @@ cluster_corrupt_out:
 	/* Corruption detected in the clustering loop.  Invalidate the
 	 * inode buffer and shut down the filesystem.
 	 */
-	mutex_spinunlock(&ch->ch_lock, s);
+	mutex_spinunlock(&ch->ch_lock);
 
 	/*
 	 * Clean up the buffer.  If it was B_DELWRI, just release it --
@@ -3327,7 +3324,6 @@ xfs_iflush_int(
 #ifdef XFS_TRANS_DEBUG
 	int			first;
 #endif
-	SPLDECL(s);
 
 	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE|MR_ACCESS));
 	ASSERT(issemalocked(&(ip->i_flock)));
@@ -3522,9 +3518,9 @@ xfs_iflush_int(
 		iip->ili_logged = 1;
 
 		ASSERT(sizeof(xfs_lsn_t) == 8);	/* don't lock if it shrinks */
-		AIL_LOCK(mp,s);
+		AIL_LOCK(mp);
 		iip->ili_flush_lsn = iip->ili_item.li_lsn;
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 
 		/*
 		 * Attach the function xfs_iflush_done to the inode's
Index: linux/fs/xfs/xfs_inode_item.c
===================================================================
--- linux.orig/fs/xfs/xfs_inode_item.c
+++ linux/fs/xfs/xfs_inode_item.c
@@ -968,7 +968,6 @@ xfs_iflush_done(
 	xfs_inode_log_item_t	*iip)
 {
 	xfs_inode_t	*ip;
-	SPLDECL(s);
 
 	ip = iip->ili_inode;
 
@@ -983,15 +982,15 @@ xfs_iflush_done(
 	 */
 	if (iip->ili_logged &&
 	    (iip->ili_item.li_lsn == iip->ili_flush_lsn)) {
-		AIL_LOCK(ip->i_mount, s);
+		AIL_LOCK(ip->i_mount);
 		if (iip->ili_item.li_lsn == iip->ili_flush_lsn) {
 			/*
 			 * xfs_trans_delete_ail() drops the AIL lock.
 			 */
 			xfs_trans_delete_ail(ip->i_mount,
-					     (xfs_log_item_t*)iip, s);
+					     (xfs_log_item_t*)iip);
 		} else {
-			AIL_UNLOCK(ip->i_mount, s);
+			AIL_UNLOCK(ip->i_mount);
 		}
 	}
 
@@ -1025,21 +1024,19 @@ xfs_iflush_abort(
 {
 	xfs_inode_log_item_t	*iip;
 	xfs_mount_t		*mp;
-	SPLDECL(s);
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
 	if (iip) {
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
-			AIL_LOCK(mp, s);
+			AIL_LOCK(mp);
 			if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
 				/*
 				 * xfs_trans_delete_ail() drops the AIL lock.
 				 */
-				xfs_trans_delete_ail(mp, (xfs_log_item_t *)iip,
-					s);
+				xfs_trans_delete_ail(mp, (xfs_log_item_t *)iip);
 			} else
-				AIL_UNLOCK(mp, s);
+				AIL_UNLOCK(mp);
 		}
 		iip->ili_logged = 0;
 		/*
Index: linux/fs/xfs/xfs_log.c
===================================================================
--- linux.orig/fs/xfs/xfs_log.c
+++ linux/fs/xfs/xfs_log.c
@@ -376,10 +376,10 @@ xfs_log_notify(xfs_mount_t	  *mp,		/* mo
 {
 	xlog_t *log = mp->m_log;
 	xlog_in_core_t	  *iclog = (xlog_in_core_t *)iclog_hndl;
-	int	abortflg, spl;
+	int	abortflg;
 
 	cb->cb_next = NULL;
-	spl = LOG_LOCK(log);
+	LOG_LOCK(log);
 	abortflg = (iclog->ic_state & XLOG_STATE_IOERROR);
 	if (!abortflg) {
 		ASSERT_ALWAYS((iclog->ic_state == XLOG_STATE_ACTIVE) ||
@@ -388,7 +388,7 @@ xfs_log_notify(xfs_mount_t	  *mp,		/* mo
 		*(iclog->ic_callback_tail) = cb;
 		iclog->ic_callback_tail = &(cb->cb_next);
 	}
-	LOG_UNLOCK(log, spl);
+	LOG_UNLOCK(log);
 	return abortflg;
 }	/* xfs_log_notify */
 
@@ -584,7 +584,6 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	xfs_log_ticket_t tic = NULL;
 	xfs_lsn_t	 lsn;
 	int		 error;
-	SPLDECL(s);
 
 	/* the data section must be 32 bit size aligned */
 	struct {
@@ -637,24 +636,24 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		}
 
 
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 		iclog = log->l_iclog;
 		iclog->ic_refcnt++;
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		xlog_state_want_sync(log, iclog);
 		(void) xlog_state_release_iclog(log, iclog);
 
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 		if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
 		      iclog->ic_state == XLOG_STATE_DIRTY)) {
 			if (!XLOG_FORCED_SHUTDOWN(log)) {
 				sv_wait(&iclog->ic_forcesema, PMEM,
 					&log->l_icloglock, s);
 			} else {
-				LOG_UNLOCK(log, s);
+				LOG_UNLOCK(log);
 			}
 		} else {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 		}
 		if (tic) {
 			xlog_trace_loggrant(log, tic, "unmount rec");
@@ -675,15 +674,15 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 		 * a file system that went into forced_shutdown as
 		 * the result of an unmount..
 		 */
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 		iclog = log->l_iclog;
 		iclog->ic_refcnt++;
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 
 		xlog_state_want_sync(log, iclog);
 		(void) xlog_state_release_iclog(log, iclog);
 
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 
 		if ( ! (   iclog->ic_state == XLOG_STATE_ACTIVE
 			|| iclog->ic_state == XLOG_STATE_DIRTY
@@ -692,7 +691,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 				sv_wait(&iclog->ic_forcesema, PMEM,
 					&log->l_icloglock, s);
 		} else {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 		}
 	}
 
@@ -740,7 +739,6 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 	xlog_ticket_t	*tic;
 	xlog_t		*log = mp->m_log;
 	int		need_bytes, free_bytes, cycle, bytes;
-	SPLDECL(s);
 
 	if (XLOG_FORCED_SHUTDOWN(log))
 		return;
@@ -748,12 +746,12 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 
 	if (tail_lsn == 0) {
 		/* needed since sync_lsn is 64 bits */
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 		tail_lsn = log->l_last_sync_lsn;
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 	}
 
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 
 	/* Also an invalid lsn.  1 implies that we aren't passing in a valid
 	 * tail_lsn.
@@ -802,7 +800,7 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 			tic = tic->t_next;
 		} while (tic != log->l_reserve_headq);
 	}
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 }	/* xfs_log_move_tail */
 
 /*
@@ -814,14 +812,13 @@ xfs_log_move_tail(xfs_mount_t	*mp,
 int
 xfs_log_need_covered(xfs_mount_t *mp)
 {
-	SPLDECL(s);
 	int		needed = 0, gen;
 	xlog_t		*log = mp->m_log;
 
 	if (!xfs_fs_writable(mp))
 		return 0;
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	if (((log->l_covered_state == XLOG_STATE_COVER_NEED) ||
 		(log->l_covered_state == XLOG_STATE_COVER_NEED2))
 			&& !xfs_trans_first_ail(mp, &gen)
@@ -834,7 +831,7 @@ xfs_log_need_covered(xfs_mount_t *mp)
 		}
 		needed = 1;
 	}
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 	return needed;
 }
 
@@ -859,17 +856,16 @@ xfs_lsn_t
 xlog_assign_tail_lsn(xfs_mount_t *mp)
 {
 	xfs_lsn_t tail_lsn;
-	SPLDECL(s);
 	xlog_t	  *log = mp->m_log;
 
 	tail_lsn = xfs_trans_tail_ail(mp);
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	if (tail_lsn != 0) {
 		log->l_tail_lsn = tail_lsn;
 	} else {
 		tail_lsn = log->l_tail_lsn = log->l_last_sync_lsn;
 	}
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 
 	return tail_lsn;
 }	/* xlog_assign_tail_lsn */
@@ -1283,11 +1279,10 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
     int		threshold_block;	/* block in lsn we'd like to be at */
     int		threshold_cycle;	/* lsn cycle we'd like to be at */
     int		free_threshold;
-    SPLDECL(s);
 
     ASSERT(BTOBB(need_bytes) < log->l_logBBsize);
 
-    s = GRANT_LOCK(log);
+    GRANT_LOCK(log);
     free_bytes = xlog_space_left(log,
 				 log->l_grant_reserve_cycle,
 				 log->l_grant_reserve_bytes);
@@ -1318,7 +1313,7 @@ xlog_grant_push_ail(xfs_mount_t	*mp,
 	if (XFS_LSN_CMP(threshold_lsn, log->l_last_sync_lsn) > 0)
 	    threshold_lsn = log->l_last_sync_lsn;
     }
-    GRANT_UNLOCK(log, s);
+    GRANT_UNLOCK(log);
 
     /*
      * Get the transaction layer to kick the dirty buffers out to
@@ -1368,7 +1363,6 @@ xlog_sync(xlog_t		*log,
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
 	int		error;
-	SPLDECL(s);
 	int		v2 = XFS_SB_VERSION_HASLOGV2(&log->l_mp->m_sb);
 
 	XFS_STATS_INC(xs_log_writes);
@@ -1393,9 +1387,9 @@ xlog_sync(xlog_t		*log,
 		 roundoff < BBTOB(1)));
 
 	/* move grant heads by roundoff in sync */
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	xlog_grant_add_space(log, roundoff);
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 
 	/* put cycle number in every block */
 	xlog_pack_data(log, iclog, roundoff); 
@@ -1570,14 +1564,12 @@ xlog_state_finish_copy(xlog_t		*log,
 		       int		record_cnt,
 		       int		copy_bytes)
 {
-	SPLDECL(s);
-
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	iclog->ic_header.h_num_logops += record_cnt;
 	iclog->ic_offset += copy_bytes;
 
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 }	/* xlog_state_finish_copy */
 
 
@@ -2067,9 +2059,8 @@ xlog_state_do_callback(
 	int		   funcdidcallbacks; /* flag: function did callbacks */
 	int		   repeats;	/* for issuing console warnings if
 					 * looping too many times */
-	SPLDECL(s);
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	first_iclog = iclog = log->l_iclog;
 	ioerrors = 0;
 	funcdidcallbacks = 0;
@@ -2152,19 +2143,19 @@ xlog_state_do_callback(
 
 				iclog->ic_state = XLOG_STATE_CALLBACK;
 
-				LOG_UNLOCK(log, s);
+				LOG_UNLOCK(log);
 
 				/* l_last_sync_lsn field protected by
 				 * GRANT_LOCK. Don't worry about iclog's lsn.
 				 * No one else can be here except us.
 				 */
-				s = GRANT_LOCK(log);
+				GRANT_LOCK(log);
 				ASSERT(XFS_LSN_CMP(
 						log->l_last_sync_lsn,
 						INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT)
 					)<=0);
 				log->l_last_sync_lsn = INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT);
-				GRANT_UNLOCK(log, s);
+				GRANT_UNLOCK(log);
 
 				/*
 				 * Keep processing entries in the callback list
@@ -2173,7 +2164,7 @@ xlog_state_do_callback(
 				 * empty and change the state to DIRTY so that
 				 * we don't miss any more callbacks being added.
 				 */
-				s = LOG_LOCK(log);
+				LOG_LOCK(log);
 			} else {
 				ioerrors++;
 			}
@@ -2182,14 +2173,14 @@ xlog_state_do_callback(
 			while (cb != 0) {
 				iclog->ic_callback_tail = &(iclog->ic_callback);
 				iclog->ic_callback = NULL;
-				LOG_UNLOCK(log, s);
+				LOG_UNLOCK(log);
 
 				/* perform callbacks in the order given */
 				for (; cb != 0; cb = cb_next) {
 					cb_next = cb->cb_next;
 					cb->cb_func(cb->cb_arg, aborted);
 				}
-				s = LOG_LOCK(log);
+				LOG_LOCK(log);
 				cb = iclog->ic_callback;
 			}
 
@@ -2254,7 +2245,7 @@ xlog_state_do_callback(
 		flushcnt = log->l_flushcnt;
 		log->l_flushcnt = 0;
 	}
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 	while (flushcnt--)
 		vsema(&log->l_flushsema);
 }	/* xlog_state_do_callback */
@@ -2280,9 +2271,8 @@ xlog_state_done_syncing(
 	int		aborted)
 {
 	xlog_t		   *log = iclog->ic_log;
-	SPLDECL(s);
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
@@ -2298,7 +2288,7 @@ xlog_state_done_syncing(
 	 */
 	if (iclog->ic_state != XLOG_STATE_IOERROR) {
 		if (--iclog->ic_bwritecnt == 1) {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 			return;
 		}
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
@@ -2310,7 +2300,7 @@ xlog_state_done_syncing(
 	 * I/O, the others get to wait for the result.
 	 */
 	sv_broadcast(&iclog->ic_writesema);
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 	xlog_state_do_callback(log, aborted, iclog);	/* also cleans log */
 }	/* xlog_state_done_syncing */
 
@@ -2343,23 +2333,22 @@ xlog_state_get_iclog_space(xlog_t	  *log
 			   int		  *continued_write,
 			   int		  *logoffsetp)
 {
-	SPLDECL(s);
 	int		  log_offset;
 	xlog_rec_header_t *head;
 	xlog_in_core_t	  *iclog;
 	int		  error;
 
 restart:
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	if (XLOG_FORCED_SHUTDOWN(log)) {
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		return XFS_ERROR(EIO);
 	}
 
 	iclog = log->l_iclog;
 	if (! (iclog->ic_state == XLOG_STATE_ACTIVE)) {
 		log->l_flushcnt++;
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		xlog_trace_iclog(iclog, XLOG_TRACE_SLEEP_FLUSH);
 		XFS_STATS_INC(xs_log_noiclogs);
 		/* Ensure that log writes happen */
@@ -2401,12 +2390,12 @@ restart:
 
 		/* If I'm the only one writing to this iclog, sync it to disk */
 		if (iclog->ic_refcnt == 1) {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 			if ((error = xlog_state_release_iclog(log, iclog)))
 				return error;
 		} else {
 			iclog->ic_refcnt--;
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 		}
 		goto restart;
 	}
@@ -2427,7 +2416,7 @@ restart:
 	*iclogp = iclog;
 
 	ASSERT(iclog->ic_offset <= iclog->ic_size);
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 
 	*logoffsetp = log_offset;
 	return 0;
@@ -2445,7 +2434,6 @@ xlog_grant_log_space(xlog_t	   *log,
 {
 	int		 free_bytes;
 	int		 need_bytes;
-	SPLDECL(s);
 #ifdef DEBUG
 	xfs_lsn_t	 tail_lsn;
 #endif
@@ -2457,7 +2445,7 @@ xlog_grant_log_space(xlog_t	   *log,
 #endif
 
 	/* Is there space or do we need to sleep? */
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	xlog_trace_loggrant(log, tic, "xlog_grant_log_space: enter");
 
 	/* something is already sleeping; insert new transaction at end */
@@ -2480,7 +2468,7 @@ xlog_grant_log_space(xlog_t	   *log,
 		 */
 		xlog_trace_loggrant(log, tic,
 				    "xlog_grant_log_space: wake 1");
-		s = GRANT_LOCK(log);
+		GRANT_LOCK(log);
 	}
 	if (tic->t_flags & XFS_LOG_PERM_RESERV)
 		need_bytes = tic->t_unit_res*tic->t_ocnt;
@@ -2502,14 +2490,14 @@ redo:
 		sv_wait(&tic->t_sema, PINOD|PLTWAIT, &log->l_grant_lock, s);
 
 		if (XLOG_FORCED_SHUTDOWN(log)) {
-			s = GRANT_LOCK(log);
+			GRANT_LOCK(log);
 			goto error_return;
 		}
 
 		xlog_trace_loggrant(log, tic,
 				    "xlog_grant_log_space: wake 2");
 		xlog_grant_push_ail(log->l_mp, need_bytes);
-		s = GRANT_LOCK(log);
+		GRANT_LOCK(log);
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_reserve_headq, tic);
@@ -2531,7 +2519,7 @@ redo:
 #endif
 	xlog_trace_loggrant(log, tic, "xlog_grant_log_space: exit");
 	xlog_verify_grant_head(log, 1);
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	return 0;
 
  error_return:
@@ -2545,7 +2533,7 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	return XFS_ERROR(EIO);
 }	/* xlog_grant_log_space */
 
@@ -2559,7 +2547,6 @@ STATIC int
 xlog_regrant_write_log_space(xlog_t	   *log,
 			     xlog_ticket_t *tic)
 {
-	SPLDECL(s);
 	int		free_bytes, need_bytes;
 	xlog_ticket_t	*ntic;
 #ifdef DEBUG
@@ -2577,7 +2564,7 @@ xlog_regrant_write_log_space(xlog_t	   *
 		panic("regrant Recovery problem");
 #endif
 
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	xlog_trace_loggrant(log, tic, "xlog_regrant_write_log_space: enter");
 
 	if (XLOG_FORCED_SHUTDOWN(log))
@@ -2616,14 +2603,14 @@ xlog_regrant_write_log_space(xlog_t	   *
 			/* If we're shutting down, this tic is already
 			 * off the queue */
 			if (XLOG_FORCED_SHUTDOWN(log)) {
-				s = GRANT_LOCK(log);
+				GRANT_LOCK(log);
 				goto error_return;
 			}
 
 			xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: wake 1");
 			xlog_grant_push_ail(log->l_mp, tic->t_unit_res);
-			s = GRANT_LOCK(log);
+			GRANT_LOCK(log);
 		}
 	}
 
@@ -2643,14 +2630,14 @@ redo:
 
 		/* If we're shutting down, this tic is already off the queue */
 		if (XLOG_FORCED_SHUTDOWN(log)) {
-			s = GRANT_LOCK(log);
+			GRANT_LOCK(log);
 			goto error_return;
 		}
 
 		xlog_trace_loggrant(log, tic,
 				    "xlog_regrant_write_log_space: wake 2");
 		xlog_grant_push_ail(log->l_mp, need_bytes);
-		s = GRANT_LOCK(log);
+		GRANT_LOCK(log);
 		goto redo;
 	} else if (tic->t_flags & XLOG_TIC_IN_Q)
 		xlog_del_ticketq(&log->l_write_headq, tic);
@@ -2667,7 +2654,7 @@ redo:
 
 	xlog_trace_loggrant(log, tic, "xlog_regrant_write_log_space: exit");
 	xlog_verify_grant_head(log, 1);
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	return 0;
 
 
@@ -2682,7 +2669,7 @@ redo:
 	 */
 	tic->t_curr_res = 0;
 	tic->t_cnt = 0; /* ungrant will give back unit_res * t_cnt. */
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	return XFS_ERROR(EIO);
 }	/* xlog_regrant_write_log_space */
 
@@ -2698,14 +2685,12 @@ STATIC void
 xlog_regrant_reserve_log_space(xlog_t	     *log,
 			       xlog_ticket_t *ticket)
 {
-	SPLDECL(s);
-
 	xlog_trace_loggrant(log, ticket,
 			    "xlog_regrant_reserve_log_space: enter");
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	xlog_grant_sub_space(log, ticket->t_curr_res);
 	ticket->t_curr_res = ticket->t_unit_res;
 	XLOG_TIC_RESET_RES(ticket);
@@ -2715,7 +2700,7 @@ xlog_regrant_reserve_log_space(xlog_t	  
 
 	/* just return if we still have some of the pre-reserved space */
 	if (ticket->t_cnt > 0) {
-		GRANT_UNLOCK(log, s);
+		GRANT_UNLOCK(log);
 		return;
 	}
 
@@ -2723,7 +2708,7 @@ xlog_regrant_reserve_log_space(xlog_t	  
 	xlog_trace_loggrant(log, ticket,
 			    "xlog_regrant_reserve_log_space: exit");
 	xlog_verify_grant_head(log, 0);
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	ticket->t_curr_res = ticket->t_unit_res;
 	XLOG_TIC_RESET_RES(ticket);
 }	/* xlog_regrant_reserve_log_space */
@@ -2747,12 +2732,10 @@ STATIC void
 xlog_ungrant_log_space(xlog_t	     *log,
 		       xlog_ticket_t *ticket)
 {
-	SPLDECL(s);
-
 	if (ticket->t_cnt > 0)
 		ticket->t_cnt--;
 
-	s = GRANT_LOCK(log);
+	GRANT_LOCK(log);
 	xlog_trace_loggrant(log, ticket, "xlog_ungrant_log_space: enter");
 
 	xlog_grant_sub_space(log, ticket->t_curr_res);
@@ -2769,7 +2752,7 @@ xlog_ungrant_log_space(xlog_t	     *log,
 
 	xlog_trace_loggrant(log, ticket, "xlog_ungrant_log_space: exit");
 	xlog_verify_grant_head(log, 1);
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 	xfs_log_move_tail(log->l_mp, 1);
 }	/* xlog_ungrant_log_space */
 
@@ -2781,11 +2764,9 @@ void
 xlog_state_put_ticket(xlog_t	    *log,
 		      xlog_ticket_t *tic)
 {
-	unsigned long s;
-
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	xlog_ticket_put(log, tic);
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 }	/* xlog_state_put_ticket */
 
 /*
@@ -2801,15 +2782,14 @@ int
 xlog_state_release_iclog(xlog_t		*log,
 			 xlog_in_core_t	*iclog)
 {
-	SPLDECL(s);
 	int		sync = 0;	/* do we sync? */
 
 	xlog_assign_tail_lsn(log->l_mp);
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		return XFS_ERROR(EIO);
 	}
 
@@ -2826,7 +2806,7 @@ xlog_state_release_iclog(xlog_t		*log,
 		/* cycle incremented when incrementing curr_block */
 	}
 
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 
 	/*
 	 * We let the log lock go, so it's possible that we hit a log I/O
@@ -2917,13 +2897,12 @@ xlog_state_sync_all(xlog_t *log, uint fl
 {
 	xlog_in_core_t	*iclog;
 	xfs_lsn_t	lsn;
-	SPLDECL(s);
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	iclog = log->l_iclog;
 	if (iclog->ic_state & XLOG_STATE_IOERROR) {
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		return XFS_ERROR(EIO);
 	}
 
@@ -2958,12 +2937,12 @@ xlog_state_sync_all(xlog_t *log, uint fl
 				iclog->ic_refcnt++;
 				lsn = INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT);
 				xlog_state_switch_iclogs(log, iclog, 0);
-				LOG_UNLOCK(log, s);
+				LOG_UNLOCK(log);
 
 				if (xlog_state_release_iclog(log, iclog))
 					return XFS_ERROR(EIO);
 				*log_flushed = 1;
-				s = LOG_LOCK(log);
+				LOG_LOCK(log);
 				if (INT_GET(iclog->ic_header.h_lsn, ARCH_CONVERT) == lsn &&
 				    iclog->ic_state != XLOG_STATE_DIRTY)
 					goto maybe_sleep;
@@ -2994,7 +2973,7 @@ maybe_sleep:
 		 * sleep was disturbed by a bad news.
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR) {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
@@ -3011,7 +2990,7 @@ maybe_sleep:
 	} else {
 
 no_sleep:
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 	}
 	return 0;
 }	/* xlog_state_sync_all */
@@ -3037,15 +3016,13 @@ xlog_state_sync(xlog_t	  *log,
 {
     xlog_in_core_t	*iclog;
     int			already_slept = 0;
-    SPLDECL(s);
-
 
 try_again:
-    s = LOG_LOCK(log);
+    LOG_LOCK(log);
     iclog = log->l_iclog;
 
     if (iclog->ic_state & XLOG_STATE_IOERROR) {
-	    LOG_UNLOCK(log, s);
+	    LOG_UNLOCK(log);
 	    return XFS_ERROR(EIO);
     }
 
@@ -3056,7 +3033,7 @@ try_again:
 	}
 
 	if (iclog->ic_state == XLOG_STATE_DIRTY) {
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		return 0;
 	}
 
@@ -3091,11 +3068,11 @@ try_again:
 		} else {
 			iclog->ic_refcnt++;
 			xlog_state_switch_iclogs(log, iclog, 0);
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 			if (xlog_state_release_iclog(log, iclog))
 				return XFS_ERROR(EIO);
 			*log_flushed = 1;
-			s = LOG_LOCK(log);
+			LOG_LOCK(log);
 		}
 	}
 
@@ -3107,7 +3084,7 @@ try_again:
 		 * gotten a log write error.
 		 */
 		if (iclog->ic_state & XLOG_STATE_IOERROR) {
-			LOG_UNLOCK(log, s);
+			LOG_UNLOCK(log);
 			return XFS_ERROR(EIO);
 		}
 		XFS_STATS_INC(xs_log_force_sleep);
@@ -3121,13 +3098,13 @@ try_again:
 			return XFS_ERROR(EIO);
 		*log_flushed = 1;
 	} else {		/* just return */
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 	}
 	return 0;
 
     } while (iclog != log->l_iclog);
 
-    LOG_UNLOCK(log, s);
+    LOG_UNLOCK(log);
     return 0;
 }	/* xlog_state_sync */
 
@@ -3139,9 +3116,7 @@ try_again:
 void
 xlog_state_want_sync(xlog_t *log, xlog_in_core_t *iclog)
 {
-	SPLDECL(s);
-
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
 		xlog_state_switch_iclogs(log, iclog, 0);
@@ -3150,7 +3125,7 @@ xlog_state_want_sync(xlog_t *log, xlog_i
 			(XLOG_STATE_WANT_SYNC|XLOG_STATE_IOERROR));
 	}
 
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 }	/* xlog_state_want_sync */
 
 
@@ -3172,7 +3147,6 @@ xlog_state_ticket_alloc(xlog_t *log)
 	xlog_ticket_t	*next;
 	xfs_caddr_t	buf;
 	uint		i = (NBPP / sizeof(xlog_ticket_t)) - 2;
-	SPLDECL(s);
 
 	/*
 	 * The kmem_zalloc may sleep, so we shouldn't be holding the
@@ -3180,7 +3154,7 @@ xlog_state_ticket_alloc(xlog_t *log)
 	 */
 	buf = (xfs_caddr_t) kmem_zalloc(NBPP, KM_SLEEP);
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 
 	/* Attach 1st ticket to Q, so we can keep track of allocated memory */
 	t_list = (xlog_ticket_t *)buf;
@@ -3209,7 +3183,7 @@ xlog_state_ticket_alloc(xlog_t *log)
 	}
 	t_list->t_next = NULL;
 	log->l_tail = t_list;
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 }	/* xlog_state_ticket_alloc */
 
 
@@ -3260,15 +3234,14 @@ xlog_ticket_get(xlog_t		*log,
 {
 	xlog_ticket_t	*tic;
 	uint		num_headers;
-	SPLDECL(s);
 
  alloc:
 	if (log->l_freelist == NULL)
 		xlog_state_ticket_alloc(log);		/* potentially sleep */
 
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	if (log->l_freelist == NULL) {
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 		goto alloc;
 	}
 	tic		= log->l_freelist;
@@ -3276,7 +3249,7 @@ xlog_ticket_get(xlog_t		*log,
 	if (log->l_freelist == NULL)
 		log->l_tail = NULL;
 	log->l_ticket_cnt--;
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 
 	/*
 	 * Permanent reservations have up to 'cnt'-1 active log operations
@@ -3451,10 +3424,9 @@ xlog_verify_iclog(xlog_t	 *log,
 	__uint8_t		clientid;
 	int			len, i, j, k, op_len;
 	int			idx;
-	SPLDECL(s);
 
 	/* check validity of iclog pointers */
-	s = LOG_LOCK(log);
+	LOG_LOCK(log);
 	icptr = log->l_iclog;
 	for (i=0; i < log->l_iclog_bufs; i++) {
 		if (icptr == 0)
@@ -3463,7 +3435,7 @@ xlog_verify_iclog(xlog_t	 *log,
 	}
 	if (icptr != log->l_iclog)
 		xlog_panic("xlog_verify_iclog: corrupt iclog ring");
-	LOG_UNLOCK(log, s);
+	LOG_UNLOCK(log);
 
 	/* check log magic numbers */
 	ptr = (xfs_caddr_t) &(iclog->ic_header);
@@ -3575,8 +3547,6 @@ xfs_log_force_umount(
 	xlog_t		*log;
 	int		retval;
 	int		dummy;
-	SPLDECL(s);
-	SPLDECL(s2);
 
 	log = mp->m_log;
 
@@ -3605,8 +3575,8 @@ xfs_log_force_umount(
 	 * before we mark the filesystem SHUTDOWN and wake
 	 * everybody up to tell the bad news.
 	 */
-	s = GRANT_LOCK(log);
-	s2 = LOG_LOCK(log);
+	GRANT_LOCK(log);
+	LOG_LOCK(log);
 	mp->m_flags |= XFS_MOUNT_FS_SHUTDOWN;
 	XFS_BUF_DONE(mp->m_sb_bp);
 	/*
@@ -3622,7 +3592,7 @@ xfs_log_force_umount(
 	 */
 	if (logerror)
 		retval = xlog_state_ioerror(log);
-	LOG_UNLOCK(log, s2);
+	LOG_UNLOCK(log);
 
 	/*
 	 * We don't want anybody waiting for log reservations
@@ -3645,7 +3615,7 @@ xfs_log_force_umount(
 			tic = tic->t_next;
 		} while (tic != log->l_write_headq);
 	}
-	GRANT_UNLOCK(log, s);
+	GRANT_UNLOCK(log);
 
 	if (! (log->l_iclog->ic_state & XLOG_STATE_IOERROR)) {
 		ASSERT(!logerror);
@@ -3654,9 +3624,9 @@ xfs_log_force_umount(
 		 * log down completely.
 		 */
 		xlog_state_sync_all(log, XFS_LOG_FORCE|XFS_LOG_SYNC, &dummy);
-		s2 = LOG_LOCK(log);
+		LOG_LOCK(log);
 		retval = xlog_state_ioerror(log);
-		LOG_UNLOCK(log, s2);
+		LOG_UNLOCK(log);
 	}
 	/*
 	 * Wake up everybody waiting on xfs_log_force.
@@ -3669,13 +3639,13 @@ xfs_log_force_umount(
 	{
 		xlog_in_core_t	*iclog;
 
-		s = LOG_LOCK(log);
+		LOG_LOCK(log);
 		iclog = log->l_iclog;
 		do {
 			ASSERT(iclog->ic_callback == 0);
 			iclog = iclog->ic_next;
 		} while (iclog != log->l_iclog);
-		LOG_UNLOCK(log, s);
+		LOG_UNLOCK(log);
 	}
 #endif
 	/* return non-zero if log IOERROR transition had already happened */
Index: linux/fs/xfs/xfs_log_priv.h
===================================================================
--- linux.orig/fs/xfs/xfs_log_priv.h
+++ linux/fs/xfs/xfs_log_priv.h
@@ -106,9 +106,9 @@ struct xfs_mount;
 #endif
 
 #define GRANT_LOCK(log)		mutex_spinlock(&(log)->l_grant_lock)
-#define GRANT_UNLOCK(log, s)	mutex_spinunlock(&(log)->l_grant_lock, s)
+#define GRANT_UNLOCK(log)	mutex_spinunlock(&(log)->l_grant_lock)
 #define LOG_LOCK(log)		mutex_spinlock(&(log)->l_icloglock)
-#define LOG_UNLOCK(log, s)	mutex_spinunlock(&(log)->l_icloglock, s)
+#define LOG_UNLOCK(log)		mutex_spinunlock(&(log)->l_icloglock)
 
 #define xlog_panic(args...)	cmn_err(CE_PANIC, ## args)
 #define xlog_exit(args...)	cmn_err(CE_PANIC, ## args)
Index: linux/fs/xfs/xfs_log_recover.c
===================================================================
--- linux.orig/fs/xfs/xfs_log_recover.c
+++ linux/fs/xfs/xfs_log_recover.c
@@ -2663,7 +2663,6 @@ xlog_recover_do_efi_trans(
 	xfs_mount_t		*mp;
 	xfs_efi_log_item_t	*efip;
 	xfs_efi_log_format_t	*efi_formatp;
-	SPLDECL(s);
 
 	if (pass == XLOG_RECOVER_PASS1) {
 		return 0;
@@ -2681,11 +2680,11 @@ xlog_recover_do_efi_trans(
 	efip->efi_next_extent = efi_formatp->efi_nextents;
 	efip->efi_flags |= XFS_EFI_COMMITTED;
 
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 	/*
 	 * xfs_trans_update_ail() drops the AIL lock.
 	 */
-	xfs_trans_update_ail(mp, (xfs_log_item_t *)efip, lsn, s);
+	xfs_trans_update_ail(mp, (xfs_log_item_t *)efip, lsn);
 	return 0;
 }
 
@@ -2710,7 +2709,6 @@ xlog_recover_do_efd_trans(
 	xfs_log_item_t		*lip;
 	int			gen;
 	__uint64_t		efi_id;
-	SPLDECL(s);
 
 	if (pass == XLOG_RECOVER_PASS1) {
 		return;
@@ -2728,7 +2726,7 @@ xlog_recover_do_efd_trans(
 	 * in the AIL.
 	 */
 	mp = log->l_mp;
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 	lip = xfs_trans_first_ail(mp, &gen);
 	while (lip != NULL) {
 		if (lip->li_type == XFS_LI_EFI) {
@@ -2738,7 +2736,7 @@ xlog_recover_do_efd_trans(
 				 * xfs_trans_delete_ail() drops the
 				 * AIL lock.
 				 */
-				xfs_trans_delete_ail(mp, lip, s);
+				xfs_trans_delete_ail(mp, lip);
 				break;
 			}
 		}
@@ -2752,7 +2750,7 @@ xlog_recover_do_efd_trans(
 	if (lip != NULL) {
 		xfs_efi_item_free(efip);
 	} else {
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 	}
 }
 
@@ -3078,10 +3076,9 @@ xlog_recover_process_efis(
 	xfs_efi_log_item_t	*efip;
 	int			gen;
 	xfs_mount_t		*mp;
-	SPLDECL(s);
 
 	mp = log->l_mp;
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 
 	lip = xfs_trans_first_ail(mp, &gen);
 	while (lip != NULL) {
@@ -3102,12 +3099,12 @@ xlog_recover_process_efis(
 			continue;
 		}
 
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 		xlog_recover_process_efi(mp, efip);
-		AIL_LOCK(mp,s);
+		AIL_LOCK(mp);
 		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
 	}
-	AIL_UNLOCK(mp, s);
+	AIL_UNLOCK(mp);
 }
 
 /*
Index: linux/fs/xfs/xfs_mount.c
===================================================================
--- linux.orig/fs/xfs/xfs_mount.c
+++ linux/fs/xfs/xfs_mount.c
@@ -664,7 +664,6 @@ xfs_initialize_perag_data(xfs_mount_t *m
 	uint64_t	bfreelst = 0;
 	uint64_t	btree = 0;
 	int		error;
-	int		s;
 
 	for (index = 0; index < agcount; index++) {
 		/*
@@ -689,11 +688,11 @@ xfs_initialize_perag_data(xfs_mount_t *m
 	/*
 	 * Overwrite incore superblock counters with just-read data
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	sbp->sb_ifree = ifree;
 	sbp->sb_icount = ialloc;
 	sbp->sb_fdblocks = bfree + bfreelst + btree;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	/* Fixup the per-cpu counters as well. */
 	xfs_icsb_reinit_counters(mp);
@@ -1609,7 +1608,6 @@ xfs_mod_incore_sb(
 	int64_t		delta,
 	int		rsvd)
 {
-	unsigned long	s;
 	int	status;
 
 	/* check for per-cpu counters */
@@ -1626,9 +1624,9 @@ xfs_mod_incore_sb(
 		/* FALLTHROUGH */
 #endif
 	default:
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		status = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 		break;
 	}
 
@@ -1649,7 +1647,6 @@ xfs_mod_incore_sb(
 int
 xfs_mod_incore_sb_batch(xfs_mount_t *mp, xfs_mod_sb_t *msb, uint nmsb, int rsvd)
 {
-	unsigned long	s;
 	int		status=0;
 	xfs_mod_sb_t	*msbp;
 
@@ -1660,7 +1657,7 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 	 * the scope of the SB_LOCK so that all of the changes will
 	 * be atomic.
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	msbp = &msb[0];
 	for (msbp = &msbp[0]; msbp < (msb + nmsb); msbp++) {
 		/*
@@ -1674,11 +1671,11 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 		case XFS_SBS_IFREE:
 		case XFS_SBS_FDBLOCKS:
 			if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-				XFS_SB_UNLOCK(mp, s);
+				XFS_SB_UNLOCK(mp);
 				status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							msbp->msb_delta, rsvd);
-				s = XFS_SB_LOCK(mp);
+				XFS_SB_LOCK(mp);
 				break;
 			}
 			/* FALLTHROUGH */
@@ -1712,12 +1709,12 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 			case XFS_SBS_IFREE:
 			case XFS_SBS_FDBLOCKS:
 				if (!(mp->m_flags & XFS_MOUNT_NO_PERCPU_SB)) {
-					XFS_SB_UNLOCK(mp, s);
+					XFS_SB_UNLOCK(mp);
 					status = xfs_icsb_modify_counters(mp,
 							msbp->msb_field,
 							-(msbp->msb_delta),
 							rsvd);
-					s = XFS_SB_LOCK(mp);
+					XFS_SB_LOCK(mp);
 					break;
 				}
 				/* FALLTHROUGH */
@@ -1733,7 +1730,7 @@ xfs_mod_incore_sb_batch(xfs_mount_t *mp,
 			msbp--;
 		}
 	}
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 	return status;
 }
 
@@ -1913,7 +1910,6 @@ xfs_icsb_cpu_notify(
 {
 	xfs_icsb_cnts_t *cntp;
 	xfs_mount_t	*mp;
-	int		s;
 
 	mp = (xfs_mount_t *)container_of(nfb, xfs_mount_t, m_icsb_notifier);
 	cntp = (xfs_icsb_cnts_t *)
@@ -1936,7 +1932,7 @@ xfs_icsb_cpu_notify(
 		 * count into the total on the global superblock and
 		 * re-enable the counters. */
 		xfs_icsb_lock(mp);
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		xfs_icsb_disable_counter(mp, XFS_SBS_ICOUNT);
 		xfs_icsb_disable_counter(mp, XFS_SBS_IFREE);
 		xfs_icsb_disable_counter(mp, XFS_SBS_FDBLOCKS);
@@ -1953,7 +1949,7 @@ xfs_icsb_cpu_notify(
 					 XFS_ICSB_SB_LOCKED, 0);
 		xfs_icsb_balance_counter(mp, XFS_SBS_FDBLOCKS,
 					 XFS_ICSB_SB_LOCKED, 0);
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 		xfs_icsb_unlock(mp);
 		break;
 	}
@@ -2184,11 +2180,10 @@ xfs_icsb_sync_counters_flags(
 	int		flags)
 {
 	xfs_icsb_cnts_t	cnt;
-	int		s;
 
 	/* Pass 1: lock all counters */
 	if ((flags & XFS_ICSB_SB_LOCKED) == 0)
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 
 	xfs_icsb_count(mp, &cnt, flags);
 
@@ -2201,7 +2196,7 @@ xfs_icsb_sync_counters_flags(
 		mp->m_sb.sb_fdblocks = cnt.icsb_fdblocks;
 
 	if ((flags & XFS_ICSB_SB_LOCKED) == 0)
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 }
 
 /*
@@ -2242,11 +2237,10 @@ xfs_icsb_balance_counter(
 {
 	uint64_t	count, resid;
 	int		weight = num_online_cpus();
-	int		s;
 	uint64_t	min = (uint64_t)min_per_cpu;
 
 	if (!(flags & XFS_ICSB_SB_LOCKED))
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 
 	/* disable counter and sync counter */
 	xfs_icsb_disable_counter(mp, field);
@@ -2280,7 +2274,7 @@ xfs_icsb_balance_counter(
 	xfs_icsb_enable_counter(mp, field, count, resid);
 out:
 	if (!(flags & XFS_ICSB_SB_LOCKED))
-		XFS_SB_UNLOCK(mp, s);
+		XFS_SB_UNLOCK(mp);
 }
 
 int
@@ -2292,7 +2286,7 @@ xfs_icsb_modify_counters(
 {
 	xfs_icsb_cnts_t	*icsbp;
 	long long	lcounter;	/* long counter for 64 bit fields */
-	int		cpu, ret = 0, s;
+	int		cpu, ret = 0;
 
 	might_sleep();
 again:
@@ -2376,9 +2370,9 @@ slow_path:
 	 * xfs_mod_incore_sb_unlocked() as the unlocked path operates
 	 * directly on the global counters.
 	 */
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	ret = xfs_mod_incore_sb_unlocked(mp, field, delta, rsvd);
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	/*
 	 * Now that we've modified the global superblock, we
Index: linux/fs/xfs/xfs_mount.h
===================================================================
--- linux.orig/fs/xfs/xfs_mount.h
+++ linux/fs/xfs/xfs_mount.h
@@ -74,8 +74,8 @@ extern struct bhv_vnodeops xfs_vnodeops;
 #define	AIL_LOCK_T		lock_t
 #define	AIL_LOCKINIT(x,y)	spinlock_init(x,y)
 #define	AIL_LOCK_DESTROY(x)	spinlock_destroy(x)
-#define	AIL_LOCK(mp,s)		s=mutex_spinlock(&(mp)->m_ail_lock)
-#define	AIL_UNLOCK(mp,s)	mutex_spinunlock(&(mp)->m_ail_lock, s)
+#define	AIL_LOCK(mp)		mutex_spinlock(&(mp)->m_ail_lock)
+#define	AIL_UNLOCK(mp)		mutex_spinunlock(&(mp)->m_ail_lock)
 
 
 /*
@@ -603,7 +603,7 @@ typedef struct xfs_mod_sb {
 #define	XFS_MOUNT_ILOCK(mp)	mutex_lock(&((mp)->m_ilock))
 #define	XFS_MOUNT_IUNLOCK(mp)	mutex_unlock(&((mp)->m_ilock))
 #define	XFS_SB_LOCK(mp)		mutex_spinlock(&(mp)->m_sb_lock)
-#define	XFS_SB_UNLOCK(mp,s)	mutex_spinunlock(&(mp)->m_sb_lock,(s))
+#define	XFS_SB_UNLOCK(mp)	mutex_spinunlock(&(mp)->m_sb_lock)
 
 extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
Index: linux/fs/xfs/xfs_mru_cache.c
===================================================================
--- linux.orig/fs/xfs/xfs_mru_cache.c
+++ linux/fs/xfs/xfs_mru_cache.c
@@ -242,7 +242,7 @@ _xfs_mru_cache_clear_reap_list(
 		 */
 		list_move(&elem->list_node, &tmp);
 	}
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 
 	list_for_each_entry_safe(elem, next, &tmp, list_node) {
 
@@ -294,7 +294,7 @@ _xfs_mru_cache_reap(
 	if (!mru->reap_all)
 		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
 	mru->reap_all = 0;
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 }
 
 int
@@ -413,7 +413,7 @@ xfs_mru_cache_flush(
 
 	mutex_spinlock(&mru->lock);
 	mru->reap_all = 1;
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 
 	queue_work(xfs_mru_reap_wq, &mru->work.work);
 	flush_workqueue(xfs_mru_reap_wq);
@@ -423,7 +423,7 @@ xfs_mru_cache_flush(
 	mru->reap_all = 0;
 	if (restart)
 		queue_delayed_work(xfs_mru_reap_wq, &mru->work, mru->grp_time);
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 }
 
 void
@@ -476,7 +476,7 @@ xfs_mru_cache_insert(
 	radix_tree_preload_end();
 	_xfs_mru_cache_list_insert(mru, elem);
 
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 
 	return 0;
 }
@@ -506,7 +506,7 @@ xfs_mru_cache_remove(
 		list_del(&elem->list_node);
 	}
 
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 
 	if (elem)
 		kmem_zone_free(xfs_mru_elem_zone, elem);
@@ -563,7 +563,7 @@ xfs_mru_cache_lookup(
 		_xfs_mru_cache_list_insert(mru, elem);
 	}
 	else
-		mutex_spinunlock(&mru->lock, 0);
+		mutex_spinunlock(&mru->lock);
 
 	return elem ? elem->value : NULL;
 }
@@ -590,7 +590,7 @@ xfs_mru_cache_peek(
 	mutex_spinlock(&mru->lock);
 	elem = radix_tree_lookup(&mru->store, key);
 	if (!elem)
-		mutex_spinunlock(&mru->lock, 0);
+		mutex_spinunlock(&mru->lock);
 
 	return elem ? elem->value : NULL;
 }
@@ -604,5 +604,5 @@ void
 xfs_mru_cache_done(
 	xfs_mru_cache_t	*mru)
 {
-	mutex_spinunlock(&mru->lock, 0);
+	mutex_spinunlock(&mru->lock);
 }
Index: linux/fs/xfs/xfs_qmops.c
===================================================================
--- linux.orig/fs/xfs/xfs_qmops.c
+++ linux/fs/xfs/xfs_qmops.c
@@ -47,7 +47,6 @@ xfs_mount_reset_sbqflags(xfs_mount_t *mp
 {
 	int			error;
 	xfs_trans_t		*tp;
-	unsigned long		s;
 
 	mp->m_qflags = 0;
 	/*
@@ -56,9 +55,9 @@ xfs_mount_reset_sbqflags(xfs_mount_t *mp
 	 */
 	if (mp->m_sb.sb_qflags == 0)
 		return 0;
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	mp->m_sb.sb_qflags = 0;
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	/*
 	 * if the fs is readonly, let the incore superblock run
Index: linux/fs/xfs/xfs_trans.c
===================================================================
--- linux.orig/fs/xfs/xfs_trans.c
+++ linux/fs/xfs/xfs_trans.c
@@ -1328,7 +1328,6 @@ xfs_trans_chunk_committed(
 	xfs_lsn_t		item_lsn;
 	struct xfs_mount	*mp;
 	int			i;
-	SPLDECL(s);
 
 	lidp = licp->lic_descs;
 	for (i = 0; i < licp->lic_unused; i++, lidp++) {
@@ -1369,7 +1368,7 @@ xfs_trans_chunk_committed(
 		 * the test below.
 		 */
 		mp = lip->li_mountp;
-		AIL_LOCK(mp,s);
+		AIL_LOCK(mp);
 		if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0) {
 			/*
 			 * This will set the item's lsn to item_lsn
@@ -1378,9 +1377,9 @@ xfs_trans_chunk_committed(
 			 *
 			 * xfs_trans_update_ail() drops the AIL lock.
 			 */
-			xfs_trans_update_ail(mp, lip, item_lsn, s);
+			xfs_trans_update_ail(mp, lip, item_lsn);
 		} else {
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 		}
 
 		/*
Index: linux/fs/xfs/xfs_trans_ail.c
===================================================================
--- linux.orig/fs/xfs/xfs_trans_ail.c
+++ linux/fs/xfs/xfs_trans_ail.c
@@ -54,16 +54,15 @@ xfs_trans_tail_ail(
 {
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
-	SPLDECL(s);
 
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 	lip = xfs_ail_min(&(mp->m_ail));
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
 		lsn = lip->li_lsn;
 	}
-	AIL_UNLOCK(mp, s);
+	AIL_UNLOCK(mp);
 
 	return lsn;
 }
@@ -88,17 +87,16 @@ xfs_trans_push_ail(
 	int			restarts;
 	int			lock_result;
 	int			flush_log;
-	SPLDECL(s);
 
 #define	XFS_TRANS_PUSH_AIL_RESTARTS	1000
 
-	AIL_LOCK(mp,s);
+	AIL_LOCK(mp);
 	lip = xfs_trans_first_ail(mp, &gen);
 	if (lip == NULL || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
 		 * Just return if the AIL is empty.
 		 */
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 		return (xfs_lsn_t)0;
 	}
 
@@ -135,14 +133,14 @@ xfs_trans_push_ail(
 		lock_result = IOP_TRYLOCK(lip);
 		switch (lock_result) {
 		      case XFS_ITEM_SUCCESS:
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 			XFS_STATS_INC(xs_push_ail_success);
 			IOP_PUSH(lip);
-			AIL_LOCK(mp,s);
+			AIL_LOCK(mp);
 			break;
 
 		      case XFS_ITEM_PUSHBUF:
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 			XFS_STATS_INC(xs_push_ail_pushbuf);
 #ifdef XFSRACEDEBUG
 			delay_for_intr();
@@ -151,7 +149,7 @@ xfs_trans_push_ail(
 			ASSERT(lip->li_ops->iop_pushbuf);
 			ASSERT(lip);
 			IOP_PUSHBUF(lip);
-			AIL_LOCK(mp,s);
+			AIL_LOCK(mp);
 			break;
 
 		      case XFS_ITEM_PINNED:
@@ -180,7 +178,7 @@ xfs_trans_push_ail(
 			/*
 			 * Just return if we shut down during the last try.
 			 */
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 			return (xfs_lsn_t)0;
 		}
 
@@ -192,10 +190,10 @@ xfs_trans_push_ail(
 		 * push out the log so it will become unpinned and
 		 * move forward in the AIL.
 		 */
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 		XFS_STATS_INC(xs_push_ail_flush);
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		AIL_LOCK(mp, s);
+		AIL_LOCK(mp);
 	}
 
 	lip = xfs_ail_min(&(mp->m_ail));
@@ -205,7 +203,7 @@ xfs_trans_push_ail(
 		lsn = lip->li_lsn;
 	}
 
-	AIL_UNLOCK(mp, s);
+	AIL_UNLOCK(mp);
 	return lsn;
 }	/* xfs_trans_push_ail */
 
@@ -275,8 +273,7 @@ void
 xfs_trans_update_ail(
 	xfs_mount_t	*mp,
 	xfs_log_item_t	*lip,
-	xfs_lsn_t	lsn,
-	unsigned long	s) __releases(mp->m_ail_lock)
+	xfs_lsn_t	lsn) __releases(mp->m_ail_lock)
 {
 	xfs_ail_entry_t		*ailp;
 	xfs_log_item_t		*dlip=NULL;
@@ -299,10 +296,10 @@ xfs_trans_update_ail(
 
 	if (mlip == dlip) {
 		mlip = xfs_ail_min(&(mp->m_ail));
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 		xfs_log_move_tail(mp, mlip->li_lsn);
 	} else {
-		AIL_UNLOCK(mp, s);
+		AIL_UNLOCK(mp);
 	}
 
 
@@ -327,8 +324,7 @@ xfs_trans_update_ail(
 void
 xfs_trans_delete_ail(
 	xfs_mount_t	*mp,
-	xfs_log_item_t	*lip,
-	unsigned long	s) __releases(mp->m_ail_lock)
+	xfs_log_item_t	*lip) __releases(mp->m_ail_lock)
 {
 	xfs_ail_entry_t		*ailp;
 	xfs_log_item_t		*dlip;
@@ -347,10 +343,10 @@ xfs_trans_delete_ail(
 
 		if (mlip == dlip) {
 			mlip = xfs_ail_min(&(mp->m_ail));
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
 		} else {
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 		}
 	}
 	else {
@@ -359,12 +355,12 @@ xfs_trans_delete_ail(
 		 * serious trouble if we get to this stage.
 		 */
 		if (XFS_FORCED_SHUTDOWN(mp))
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 		else {
 			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
 		"%s: attempting to delete a log item that is not in the AIL",
 					__FUNCTION__);
-			AIL_UNLOCK(mp, s);
+			AIL_UNLOCK(mp);
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
 	}
Index: linux/fs/xfs/xfs_trans_priv.h
===================================================================
--- linux.orig/fs/xfs/xfs_trans_priv.h
+++ linux/fs/xfs/xfs_trans_priv.h
@@ -47,11 +47,10 @@ xfs_log_busy_slot_t		*xfs_trans_add_busy
  * From xfs_trans_ail.c
  */
 void			xfs_trans_update_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip, xfs_lsn_t lsn,
-				     unsigned long s)
+				     struct xfs_log_item *lip, xfs_lsn_t lsn)
 				     __releases(mp->m_ail_lock);
 void			xfs_trans_delete_ail(struct xfs_mount *mp,
-				     struct xfs_log_item *lip, unsigned long s)
+				     struct xfs_log_item *lip)
 				     __releases(mp->m_ail_lock);
 struct xfs_log_item	*xfs_trans_first_ail(struct xfs_mount *, int *);
 struct xfs_log_item	*xfs_trans_next_ail(struct xfs_mount *,
Index: linux/fs/xfs/xfs_utils.c
===================================================================
--- linux.orig/fs/xfs/xfs_utils.c
+++ linux/fs/xfs/xfs_utils.c
@@ -335,7 +335,6 @@ xfs_bump_ino_vers2(
 	xfs_inode_t	*ip)
 {
 	xfs_mount_t	*mp;
-	unsigned long		s;
 
 	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
 	ASSERT(ip->i_d.di_version == XFS_DINODE_VERSION_1);
@@ -345,13 +344,13 @@ xfs_bump_ino_vers2(
 	memset(&(ip->i_d.di_pad[0]), 0, sizeof(ip->i_d.di_pad));
 	mp = tp->t_mountp;
 	if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
-		s = XFS_SB_LOCK(mp);
+		XFS_SB_LOCK(mp);
 		if (!XFS_SB_VERSION_HASNLINK(&mp->m_sb)) {
 			XFS_SB_VERSION_ADDNLINK(&mp->m_sb);
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 			xfs_mod_sb(tp, XFS_SB_VERSIONNUM);
 		} else {
-			XFS_SB_UNLOCK(mp, s);
+			XFS_SB_UNLOCK(mp);
 		}
 	}
 	/* Caller must log the inode */
Index: linux/fs/xfs/xfs_vfsops.c
===================================================================
--- linux.orig/fs/xfs/xfs_vfsops.c
+++ linux/fs/xfs/xfs_vfsops.c
@@ -839,7 +839,6 @@ xfs_statvfs(
 	xfs_extlen_t	lsize;
 	xfs_mount_t	*mp;
 	xfs_sb_t	*sbp;
-	unsigned long	s;
 
 	mp = XFS_BHVTOM(bdp);
 	sbp = &(mp->m_sb);
@@ -847,7 +846,7 @@ xfs_statvfs(
 	statp->f_type = XFS_SB_MAGIC;
 
 	xfs_icsb_sync_counters_flags(mp, XFS_ICSB_LAZY_COUNT);
-	s = XFS_SB_LOCK(mp);
+	XFS_SB_LOCK(mp);
 	statp->f_bsize = sbp->sb_blocksize;
 	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
 	statp->f_blocks = sbp->sb_dblocks - lsize;
@@ -867,7 +866,7 @@ xfs_statvfs(
 						statp->f_files,
 						mp->m_maxicount);
 	statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
-	XFS_SB_UNLOCK(mp, s);
+	XFS_SB_UNLOCK(mp);
 
 	xfs_statvfs_fsid(statp, mp);
 	statp->f_namelen = MAXNAMELEN - 1;
Index: linux/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux.orig/fs/xfs/xfs_vnodeops.c
+++ linux.orig/fs/xfs/xfs_vnodeops.c
@@ -3740,11 +3740,11 @@ xfs_inode_flush(
 		if (iip && iip->ili_last_lsn) {
 			xlog_t		*log = mp->m_log;
 			xfs_lsn_t	sync_lsn;
-			int		s, log_flags = XFS_LOG_FORCE;
+			int		log_flags = XFS_LOG_FORCE;
 
-			s = GRANT_LOCK(log);
+			GRANT_LOCK(log);
 			sync_lsn = log->l_last_sync_lsn;
-			GRANT_UNLOCK(log, s);
+			GRANT_UNLOCK(log);
 
 			if ((XFS_LSN_CMP(iip->ili_last_lsn, sync_lsn) <= 0))
 				return 0;
