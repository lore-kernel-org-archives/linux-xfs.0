Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 20:45:15 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m164j5lL022907
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 20:45:08 -0800
Received: from mta5.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1783CDA033D
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 20:45:23 -0800 (PST)
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200]) by cuda.sgi.com with ESMTP id vR2iAg4lpvffHKta for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 20:45:23 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JVS009FDVVJ3NZ0@mta5.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Tue, 05 Feb 2008 23:45:22 -0500 (EST)
Date: Tue, 05 Feb 2008 23:44:51 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] XFS: Replace custom AIL linked-list code with struct
 list_head
In-reply-to: <20080204205230.GA14084@lst.de>
Message-id: <1202273091-19629-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
References: <20080204205230.GA14084@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dgc@sgi.com, xfs@oss.sgi.com, hch@infradead.org
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
This patch assumes you already have Dave Chinner's patch for
xfsidbg_xlogitem and xfsidbg_xaildump is needed.

Changes since V2:

- remove extra parenthesis

Changes since V1:

- Pass around a pointer to the AIL, not the struct list_head
- Make sure things compile & run with CONFIG_XFS_DEBUG
---
 fs/xfs/xfs_mount.h     |    2 +-
 fs/xfs/xfs_trans.h     |    7 +--
 fs/xfs/xfs_trans_ail.c |  149 +++++++++++++++++++----------------------------
 3 files changed, 62 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index f7c620e..435d625 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -220,7 +220,7 @@ extern void	xfs_icsb_sync_counters_flags(struct xfs_mount *, int);
 #endif
 
 typedef struct xfs_ail {
-	xfs_ail_entry_t		xa_ail;
+	struct list_head	xa_ail;
 	uint			xa_gen;
 	struct task_struct	*xa_task;
 	xfs_lsn_t		xa_target;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7f40628..50ce02b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -113,13 +113,8 @@ struct xfs_mount;
 struct xfs_trans;
 struct xfs_dquot_acct;
 
-typedef struct xfs_ail_entry {
-	struct xfs_log_item	*ail_forw;	/* AIL forw pointer */
-	struct xfs_log_item	*ail_back;	/* AIL back pointer */
-} xfs_ail_entry_t;
-
 typedef struct xfs_log_item {
-	xfs_ail_entry_t			li_ail;		/* AIL pointers */
+	struct list_head		li_ail;		/* AIL pointers */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
 	struct xfs_log_item_desc	*li_desc;	/* ptr to current desc*/
 	struct xfs_mount		*li_mountp;	/* ptr to fs mount */
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 4d6330e..0fe9d59 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -28,13 +28,13 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
-STATIC void xfs_ail_insert(xfs_ail_entry_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_delete(xfs_ail_entry_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_min(xfs_ail_entry_t *);
-STATIC xfs_log_item_t * xfs_ail_next(xfs_ail_entry_t *, xfs_log_item_t *);
+STATIC void xfs_ail_insert(xfs_ail_t *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_delete(xfs_ail_t *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_min(xfs_ail_t *);
+STATIC xfs_log_item_t * xfs_ail_next(xfs_ail_t *, xfs_log_item_t *);
 
 #ifdef DEBUG
-STATIC void xfs_ail_check(xfs_ail_entry_t *, xfs_log_item_t *);
+STATIC void xfs_ail_check(xfs_ail_t *, xfs_log_item_t *);
 #else
 #define	xfs_ail_check(a,l)
 #endif /* DEBUG */
@@ -57,7 +57,7 @@ xfs_trans_tail_ail(
 	xfs_log_item_t	*lip;
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
+	lip = xfs_ail_min(&mp->m_ail);
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
@@ -91,7 +91,7 @@ xfs_trans_push_ail(
 {
 	xfs_log_item_t		*lip;
 
-	lip = xfs_ail_min(&mp->m_ail.xa_ail);
+	lip = xfs_ail_min(&mp->m_ail);
 	if (lip && !XFS_FORCED_SHUTDOWN(mp)) {
 		if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0)
 			xfsaild_wakeup(mp, threshold_lsn);
@@ -111,15 +111,17 @@ xfs_trans_first_push_ail(
 {
 	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
+	lip = xfs_ail_min(&mp->m_ail);
 	*gen = (int)mp->m_ail.xa_gen;
 	if (lsn == 0)
 		return lip;
 
-	while (lip && (XFS_LSN_CMP(lip->li_lsn, lsn) < 0))
-		lip = lip->li_ail.ail_forw;
+	list_for_each_entry(lip, &mp->m_ail.xa_ail, li_ail) {
+		if (XFS_LSN_CMP(lip->li_lsn, lsn) >= 0)
+			return lip;
+	}
 
-	return lip;
+	return NULL;
 }
 
 /*
@@ -326,7 +328,7 @@ xfs_trans_unlocked_item(
 	 * the call to xfs_log_move_tail() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
-	min_lip = xfs_ail_min(&mp->m_ail.xa_ail);
+	min_lip = xfs_ail_min(&mp->m_ail);
 
 	if (min_lip == lip)
 		xfs_log_move_tail(mp, 1);
@@ -354,15 +356,13 @@ xfs_trans_update_ail(
 	xfs_log_item_t	*lip,
 	xfs_lsn_t	lsn) __releases(mp->m_ail_lock)
 {
-	xfs_ail_entry_t		*ailp;
 	xfs_log_item_t		*dlip=NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	ailp = &(mp->m_ail.xa_ail);
-	mlip = xfs_ail_min(ailp);
+	mlip = xfs_ail_min(&mp->m_ail);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(ailp, lip);
+		dlip = xfs_ail_delete(&mp->m_ail, lip);
 		ASSERT(dlip == lip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
@@ -370,11 +370,11 @@ xfs_trans_update_ail(
 
 	lip->li_lsn = lsn;
 
-	xfs_ail_insert(ailp, lip);
+	xfs_ail_insert(&mp->m_ail, lip);
 	mp->m_ail.xa_gen++;
 
 	if (mlip == dlip) {
-		mlip = xfs_ail_min(&(mp->m_ail.xa_ail));
+		mlip = xfs_ail_min(&mp->m_ail);
 		spin_unlock(&mp->m_ail_lock);
 		xfs_log_move_tail(mp, mlip->li_lsn);
 	} else {
@@ -404,14 +404,12 @@ xfs_trans_delete_ail(
 	xfs_mount_t	*mp,
 	xfs_log_item_t	*lip) __releases(mp->m_ail_lock)
 {
-	xfs_ail_entry_t		*ailp;
 	xfs_log_item_t		*dlip;
 	xfs_log_item_t		*mlip;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		ailp = &(mp->m_ail.xa_ail);
-		mlip = xfs_ail_min(ailp);
-		dlip = xfs_ail_delete(ailp, lip);
+		mlip = xfs_ail_min(&mp->m_ail);
+		dlip = xfs_ail_delete(&mp->m_ail, lip);
 		ASSERT(dlip == lip);
 
 
@@ -420,7 +418,7 @@ xfs_trans_delete_ail(
 		mp->m_ail.xa_gen++;
 
 		if (mlip == dlip) {
-			mlip = xfs_ail_min(&(mp->m_ail.xa_ail));
+			mlip = xfs_ail_min(&mp->m_ail);
 			spin_unlock(&mp->m_ail_lock);
 			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
 		} else {
@@ -458,7 +456,7 @@ xfs_trans_first_ail(
 {
 	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
+	lip = xfs_ail_min(&mp->m_ail);
 	*gen = (int)mp->m_ail.xa_gen;
 
 	return lip;
@@ -482,9 +480,9 @@ xfs_trans_next_ail(
 
 	ASSERT(mp && lip && gen);
 	if (mp->m_ail.xa_gen == *gen) {
-		nlip = xfs_ail_next(&(mp->m_ail.xa_ail), lip);
+		nlip = xfs_ail_next(&mp->m_ail, lip);
 	} else {
-		nlip = xfs_ail_min(&(mp->m_ail).xa_ail);
+		nlip = xfs_ail_min(&mp->m_ail);
 		*gen = (int)mp->m_ail.xa_gen;
 		if (restarts != NULL) {
 			XFS_STATS_INC(xs_push_ail_restarts);
@@ -514,8 +512,7 @@ int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
-	mp->m_ail.xa_ail.ail_forw = (xfs_log_item_t*)&mp->m_ail.xa_ail;
-	mp->m_ail.xa_ail.ail_back = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	INIT_LIST_HEAD(&mp->m_ail.xa_ail);
 	return xfsaild_start(mp);
 }
 
@@ -534,7 +531,7 @@ xfs_trans_ail_destroy(
  */
 STATIC void
 xfs_ail_insert(
-	xfs_ail_entry_t	*base,
+	xfs_ail_t	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
@@ -543,27 +540,22 @@ xfs_ail_insert(
 	/*
 	 * If the list is empty, just insert the item.
 	 */
-	if (base->ail_back == (xfs_log_item_t*)base) {
-		base->ail_forw = lip;
-		base->ail_back = lip;
-		lip->li_ail.ail_forw = (xfs_log_item_t*)base;
-		lip->li_ail.ail_back = (xfs_log_item_t*)base;
+	if (list_empty(&ailp->xa_ail)) {
+		list_add(&lip->li_ail, &ailp->xa_ail);
 		return;
 	}
 
-	next_lip = base->ail_back;
-	while ((next_lip != (xfs_log_item_t*)base) &&
-	       (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) > 0)) {
-		next_lip = next_lip->li_ail.ail_back;
+	list_for_each_entry_reverse(next_lip, &ailp->xa_ail, li_ail) {
+		if (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) <= 0)
+			break;
 	}
-	ASSERT((next_lip == (xfs_log_item_t*)base) ||
+
+	ASSERT((&next_lip->li_ail == &ailp->xa_ail) ||
 	       (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) <= 0));
-	lip->li_ail.ail_forw = next_lip->li_ail.ail_forw;
-	lip->li_ail.ail_back = next_lip;
-	next_lip->li_ail.ail_forw = lip;
-	lip->li_ail.ail_forw->li_ail.ail_back = lip;
 
-	xfs_ail_check(base, lip);
+	list_add(&lip->li_ail, &next_lip->li_ail);
+
+	xfs_ail_check(ailp, lip);
 	return;
 }
 
@@ -573,15 +565,13 @@ xfs_ail_insert(
 /*ARGSUSED*/
 STATIC xfs_log_item_t *
 xfs_ail_delete(
-	xfs_ail_entry_t	*base,
+	xfs_ail_t	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
-	xfs_ail_check(base, lip);
-	lip->li_ail.ail_forw->li_ail.ail_back = lip->li_ail.ail_back;
-	lip->li_ail.ail_back->li_ail.ail_forw = lip->li_ail.ail_forw;
-	lip->li_ail.ail_forw = NULL;
-	lip->li_ail.ail_back = NULL;
+	xfs_ail_check(ailp, lip);
+
+	list_del(&lip->li_ail);
 
 	return lip;
 }
@@ -592,14 +582,13 @@ xfs_ail_delete(
  */
 STATIC xfs_log_item_t *
 xfs_ail_min(
-	xfs_ail_entry_t	*base)
+	xfs_ail_t	*ailp)
 /* ARGSUSED */
 {
-	register xfs_log_item_t *forw = base->ail_forw;
-	if (forw == (xfs_log_item_t*)base) {
+	if (list_empty(&ailp->xa_ail))
 		return NULL;
-	}
-	return forw;
+
+	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
 }
 
 /*
@@ -609,15 +598,14 @@ xfs_ail_min(
  */
 STATIC xfs_log_item_t *
 xfs_ail_next(
-	xfs_ail_entry_t	*base,
+	xfs_ail_t	*ailp,
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
-	if (lip->li_ail.ail_forw == (xfs_log_item_t*)base) {
+	if (lip->li_ail.next == &ailp->xa_ail)
 		return NULL;
-	}
-	return lip->li_ail.ail_forw;
 
+	return list_first_entry(&lip->li_ail, xfs_log_item_t, li_ail);
 }
 
 #ifdef DEBUG
@@ -626,57 +614,40 @@ xfs_ail_next(
  */
 STATIC void
 xfs_ail_check(
-	xfs_ail_entry_t *base,
+	xfs_ail_t 	*ailp,
 	xfs_log_item_t	*lip)
 {
 	xfs_log_item_t	*prev_lip;
 
-	prev_lip = base->ail_forw;
-	if (prev_lip == (xfs_log_item_t*)base) {
-		/*
-		 * Make sure the pointers are correct when the list
-		 * is empty.
-		 */
-		ASSERT(base->ail_back == (xfs_log_item_t*)base);
+	if (list_empty(&ailp->xa_ail))
 		return;
-	}
 
 	/*
 	 * Check the next and previous entries are valid.
 	 */
 	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
-	prev_lip = lip->li_ail.ail_back;
-	if (prev_lip != (xfs_log_item_t*)base) {
-		ASSERT(prev_lip->li_ail.ail_forw == lip);
+	prev_lip = list_entry(lip->li_ail.prev, xfs_log_item_t, li_ail);
+	if (&prev_lip->li_ail != &ailp->xa_ail)
 		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
-	}
-	prev_lip = lip->li_ail.ail_forw;
-	if (prev_lip != (xfs_log_item_t*)base) {
-		ASSERT(prev_lip->li_ail.ail_back == lip);
+
+	prev_lip = list_entry(lip->li_ail.next, xfs_log_item_t, li_ail);
+	if (&prev_lip->li_ail != &ailp->xa_ail)
 		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
-	}
 
 
 #ifdef XFS_TRANS_DEBUG
 	/*
-	 * Walk the list checking forward and backward pointers,
-	 * lsn ordering, and that every entry has the XFS_LI_IN_AIL
-	 * flag set. This is really expensive, so only do it when
-	 * specifically debugging the transaction subsystem.
+	 * Walk the list checking lsn ordering, and that every entry has the
+	 * XFS_LI_IN_AIL flag set. This is really expensive, so only do it
+	 * when specifically debugging the transaction subsystem.
 	 */
-	prev_lip = (xfs_log_item_t*)base;
-	while (lip != (xfs_log_item_t*)base) {
-		if (prev_lip != (xfs_log_item_t*)base) {
-			ASSERT(prev_lip->li_ail.ail_forw == lip);
+	prev_lip = list_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
+	list_for_each_entry(lip, &ailp->xa_ail, li_ail) {
+		if (&prev_lip->li_ail != &ailp->xa_ail)
 			ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
-		}
-		ASSERT(lip->li_ail.ail_back == prev_lip);
 		ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
 		prev_lip = lip;
-		lip = lip->li_ail.ail_forw;
 	}
-	ASSERT(lip == (xfs_log_item_t*)base);
-	ASSERT(base->ail_back == prev_lip);
 #endif /* XFS_TRANS_DEBUG */
 }
 #endif /* DEBUG */
-- 
1.5.4.rc2.85.g9de45-dirty
