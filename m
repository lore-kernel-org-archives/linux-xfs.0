Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Oct 2008 15:12:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m97MCMd6011234
	for <xfs@oss.sgi.com>; Tue, 7 Oct 2008 15:12:22 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2276D4C8375
	for <xfs@oss.sgi.com>; Tue,  7 Oct 2008 15:14:00 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id TJYMht0XhhqewztN for <xfs@oss.sgi.com>; Tue, 07 Oct 2008 15:14:00 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KnKoY-0002dM-EL
	for xfs@oss.sgi.com; Wed, 08 Oct 2008 09:13:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] XFS: Allocate the struct xfs_ail
Date: Wed,  8 Oct 2008 09:13:51 +1100
Message-Id: <1223417638-10050-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1223417638-10050-1-git-send-email-david@fromorbit.com>
References: <1223417638-10050-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Rather than embedding the struct xfs_ail in the struct xfs_mount,
allocate it during AIL initialisation. Add a back pointer to
the struct xfs_ail so that we can pass around the xfs_ail
and still be able to access the xfs_mount if need be. This
is th first step involved in isolating the AIL implementation
from the surrounding filesystem code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   28 +++++++-------
 fs/xfs/xfs_mount.h           |   10 +----
 fs/xfs/xfs_trans_ail.c       |   87 +++++++++++++++++++++++------------------
 fs/xfs/xfs_trans_priv.h      |   17 ++++++--
 4 files changed, 77 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index f4bf7ca..2801d2b 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -814,18 +814,18 @@ xfs_setup_devices(
  */
 void
 xfsaild_wakeup(
-	xfs_mount_t		*mp,
+	struct xfs_ail		*ailp,
 	xfs_lsn_t		threshold_lsn)
 {
-	mp->m_ail.xa_target = threshold_lsn;
-	wake_up_process(mp->m_ail.xa_task);
+	ailp->xa_target = threshold_lsn;
+	wake_up_process(ailp->xa_task);
 }
 
 int
 xfsaild(
 	void	*data)
 {
-	xfs_mount_t	*mp = (xfs_mount_t *)data;
+	struct xfs_ail	*ailp = data;
 	xfs_lsn_t	last_pushed_lsn = 0;
 	long		tout = 0;
 
@@ -837,11 +837,11 @@ xfsaild(
 		/* swsusp */
 		try_to_freeze();
 
-		ASSERT(mp->m_log);
-		if (XFS_FORCED_SHUTDOWN(mp))
+		ASSERT(ailp->xa_mount->m_log);
+		if (XFS_FORCED_SHUTDOWN(ailp->xa_mount))
 			continue;
 
-		tout = xfsaild_push(mp, &last_pushed_lsn);
+		tout = xfsaild_push(ailp, &last_pushed_lsn);
 	}
 
 	return 0;
@@ -849,20 +849,20 @@ xfsaild(
 
 int
 xfsaild_start(
-	xfs_mount_t	*mp)
+	struct xfs_ail	*ailp)
 {
-	mp->m_ail.xa_target = 0;
-	mp->m_ail.xa_task = kthread_run(xfsaild, mp, "xfsaild");
-	if (IS_ERR(mp->m_ail.xa_task))
-		return -PTR_ERR(mp->m_ail.xa_task);
+	ailp->xa_target = 0;
+	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild");
+	if (IS_ERR(ailp->xa_task))
+		return -PTR_ERR(ailp->xa_task);
 	return 0;
 }
 
 void
 xfsaild_stop(
-	xfs_mount_t	*mp)
+	struct xfs_ail	*ailp)
 {
-	kthread_stop(mp->m_ail.xa_task);
+	kthread_stop(ailp->xa_task);
 }
 
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index fc70c69..dc29bbd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -63,6 +63,7 @@ struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
 struct xfs_nameops;
+struct xfs_ail;
 
 /*
  * Prototypes and functions for the Data Migration subsystem.
@@ -224,18 +225,11 @@ extern void	xfs_icsb_sync_counters_locked(struct xfs_mount *, int);
 #define xfs_icsb_sync_counters_locked(mp, flags) do { } while (0)
 #endif
 
-typedef struct xfs_ail {
-	struct list_head	xa_ail;
-	uint			xa_gen;
-	struct task_struct	*xa_task;
-	xfs_lsn_t		xa_target;
-} xfs_ail_t;
-
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	spinlock_t		m_ail_lock;	/* fs AIL mutex */
-	xfs_ail_t		m_ail;		/* fs active log item list */
+	struct xfs_ail		*m_ail;		/* fs active log item list */
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1f77c00..db72b52 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -28,13 +28,13 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
-STATIC void xfs_ail_insert(xfs_ail_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_delete(xfs_ail_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_min(xfs_ail_t *);
-STATIC xfs_log_item_t * xfs_ail_next(xfs_ail_t *, xfs_log_item_t *);
+STATIC void xfs_ail_insert(struct xfs_ail *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
+STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
 
 #ifdef DEBUG
-STATIC void xfs_ail_check(xfs_ail_t *, xfs_log_item_t *);
+STATIC void xfs_ail_check(struct xfs_ail *, xfs_log_item_t *);
 #else
 #define	xfs_ail_check(a,l)
 #endif /* DEBUG */
@@ -57,7 +57,7 @@ xfs_trans_tail_ail(
 	xfs_log_item_t	*lip;
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_ail_min(&mp->m_ail);
+	lip = xfs_ail_min(mp->m_ail);
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
@@ -91,10 +91,10 @@ xfs_trans_push_ail(
 {
 	xfs_log_item_t		*lip;
 
-	lip = xfs_ail_min(&mp->m_ail);
+	lip = xfs_ail_min(mp->m_ail);
 	if (lip && !XFS_FORCED_SHUTDOWN(mp)) {
-		if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0)
-			xfsaild_wakeup(mp, threshold_lsn);
+		if (XFS_LSN_CMP(threshold_lsn, mp->m_ail->xa_target) > 0)
+			xfsaild_wakeup(mp->m_ail, threshold_lsn);
 	}
 }
 
@@ -111,12 +111,12 @@ xfs_trans_first_push_ail(
 {
 	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(&mp->m_ail);
-	*gen = (int)mp->m_ail.xa_gen;
+	lip = xfs_ail_min(mp->m_ail);
+	*gen = (int)mp->m_ail->xa_gen;
 	if (lsn == 0)
 		return lip;
 
-	list_for_each_entry(lip, &mp->m_ail.xa_ail, li_ail) {
+	list_for_each_entry(lip, &mp->m_ail->xa_ail, li_ail) {
 		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
 			return lip;
 	}
@@ -129,17 +129,18 @@ xfs_trans_first_push_ail(
  */
 long
 xfsaild_push(
-	xfs_mount_t	*mp,
+	struct xfs_ail	*ailp,
 	xfs_lsn_t	*last_lsn)
 {
 	long		tout = 1000; /* milliseconds */
 	xfs_lsn_t	last_pushed_lsn = *last_lsn;
-	xfs_lsn_t	target =  mp->m_ail.xa_target;
+	xfs_lsn_t	target =  ailp->xa_target;
 	xfs_lsn_t	lsn;
 	xfs_log_item_t	*lip;
 	int		gen;
 	int		restarts;
 	int		flush_log, count, stuck;
+	xfs_mount_t	*mp = ailp->xa_mount;
 
 #define	XFS_TRANS_PUSH_AIL_RESTARTS	10
 
@@ -331,7 +332,7 @@ xfs_trans_unlocked_item(
 	 * the call to xfs_log_move_tail() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
-	min_lip = xfs_ail_min(&mp->m_ail);
+	min_lip = xfs_ail_min(mp->m_ail);
 
 	if (min_lip == lip)
 		xfs_log_move_tail(mp, 1);
@@ -362,10 +363,10 @@ xfs_trans_update_ail(
 	xfs_log_item_t		*dlip=NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	mlip = xfs_ail_min(&mp->m_ail);
+	mlip = xfs_ail_min(mp->m_ail);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(&mp->m_ail, lip);
+		dlip = xfs_ail_delete(mp->m_ail, lip);
 		ASSERT(dlip == lip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
@@ -373,11 +374,11 @@ xfs_trans_update_ail(
 
 	lip->li_lsn = lsn;
 
-	xfs_ail_insert(&mp->m_ail, lip);
-	mp->m_ail.xa_gen++;
+	xfs_ail_insert(mp->m_ail, lip);
+	mp->m_ail->xa_gen++;
 
 	if (mlip == dlip) {
-		mlip = xfs_ail_min(&mp->m_ail);
+		mlip = xfs_ail_min(mp->m_ail);
 		spin_unlock(&mp->m_ail_lock);
 		xfs_log_move_tail(mp, mlip->li_lsn);
 	} else {
@@ -411,17 +412,17 @@ xfs_trans_delete_ail(
 	xfs_log_item_t		*mlip;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		mlip = xfs_ail_min(&mp->m_ail);
-		dlip = xfs_ail_delete(&mp->m_ail, lip);
+		mlip = xfs_ail_min(mp->m_ail);
+		dlip = xfs_ail_delete(mp->m_ail, lip);
 		ASSERT(dlip == lip);
 
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
-		mp->m_ail.xa_gen++;
+		mp->m_ail->xa_gen++;
 
 		if (mlip == dlip) {
-			mlip = xfs_ail_min(&mp->m_ail);
+			mlip = xfs_ail_min(mp->m_ail);
 			spin_unlock(&mp->m_ail_lock);
 			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
 		} else {
@@ -459,8 +460,8 @@ xfs_trans_first_ail(
 {
 	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(&mp->m_ail);
-	*gen = (int)mp->m_ail.xa_gen;
+	lip = xfs_ail_min(mp->m_ail);
+	*gen = (int)mp->m_ail->xa_gen;
 
 	return lip;
 }
@@ -482,11 +483,11 @@ xfs_trans_next_ail(
 	xfs_log_item_t	*nlip;
 
 	ASSERT(mp && lip && gen);
-	if (mp->m_ail.xa_gen == *gen) {
-		nlip = xfs_ail_next(&mp->m_ail, lip);
+	if (mp->m_ail->xa_gen == *gen) {
+		nlip = xfs_ail_next(mp->m_ail, lip);
 	} else {
-		nlip = xfs_ail_min(&mp->m_ail);
-		*gen = (int)mp->m_ail.xa_gen;
+		nlip = xfs_ail_min(mp->m_ail);
+		*gen = (int)mp->m_ail->xa_gen;
 		if (restarts != NULL) {
 			XFS_STATS_INC(xs_push_ail_restarts);
 			(*restarts)++;
@@ -515,15 +516,25 @@ int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
-	INIT_LIST_HEAD(&mp->m_ail.xa_ail);
-	return xfsaild_start(mp);
+	struct xfs_ail	*ailp;
+
+	ailp = kmem_zalloc(sizeof(struct xfs_ail), KM_MAYFAIL);
+	if (!ailp)
+		return ENOMEM;
+
+	ailp->xa_mount = mp;
+	INIT_LIST_HEAD(&ailp->xa_ail);
+	return xfsaild_start(ailp);
 }
 
 void
 xfs_trans_ail_destroy(
 	xfs_mount_t	*mp)
 {
-	xfsaild_stop(mp);
+	struct xfs_ail	*ailp = mp->m_ail;
+
+	xfsaild_stop(ailp);
+	kmem_free(ailp);
 }
 
 /*
@@ -534,7 +545,7 @@ xfs_trans_ail_destroy(
  */
 STATIC void
 xfs_ail_insert(
-	xfs_ail_t	*ailp,
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
@@ -568,7 +579,7 @@ xfs_ail_insert(
 /*ARGSUSED*/
 STATIC xfs_log_item_t *
 xfs_ail_delete(
-	xfs_ail_t	*ailp,
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
@@ -585,7 +596,7 @@ xfs_ail_delete(
  */
 STATIC xfs_log_item_t *
 xfs_ail_min(
-	xfs_ail_t	*ailp)
+	struct xfs_ail	*ailp)
 /* ARGSUSED */
 {
 	if (list_empty(&ailp->xa_ail))
@@ -601,7 +612,7 @@ xfs_ail_min(
  */
 STATIC xfs_log_item_t *
 xfs_ail_next(
-	xfs_ail_t	*ailp,
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
@@ -617,7 +628,7 @@ xfs_ail_next(
  */
 STATIC void
 xfs_ail_check(
-	xfs_ail_t 	*ailp,
+	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
 {
 	xfs_log_item_t	*prev_lip;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 3c748c4..98317fd 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -56,13 +56,20 @@ struct xfs_log_item	*xfs_trans_first_ail(struct xfs_mount *, int *);
 struct xfs_log_item	*xfs_trans_next_ail(struct xfs_mount *,
 				     struct xfs_log_item *, int *, int *);
 
-
 /*
  * AIL push thread support
  */
-long	xfsaild_push(struct xfs_mount *, xfs_lsn_t *);
-void	xfsaild_wakeup(struct xfs_mount *, xfs_lsn_t);
-int	xfsaild_start(struct xfs_mount *);
-void	xfsaild_stop(struct xfs_mount *);
+struct xfs_ail {
+	struct xfs_mount	*xa_mount;
+	struct list_head	xa_ail;
+	uint			xa_gen;
+	struct task_struct	*xa_task;
+	xfs_lsn_t		xa_target;
+};
+
+long	xfsaild_push(struct xfs_ail *, xfs_lsn_t *);
+void	xfsaild_wakeup(struct xfs_ail *, xfs_lsn_t);
+int	xfsaild_start(struct xfs_ail *);
+void	xfsaild_stop(struct xfs_ail *);
 
 #endif	/* __XFS_TRANS_PRIV_H__ */
-- 
1.5.6.5
