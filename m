Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 16:36:09 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0L0ZvCU020073
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 16:36:04 -0800
Received: from mta5.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A917ACA984E
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 16:36:16 -0800 (PST)
Received: from mta5.srv.hcvlny.cv.net (mta5.srv.hcvlny.cv.net [167.206.4.200]) by cuda.sgi.com with ESMTP id esgOo5wye9fAI60n for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 16:36:16 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JUY00L7EXOCAB40@mta5.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Sun, 20 Jan 2008 19:36:15 -0500 (EST)
Date: Sun, 20 Jan 2008 19:35:57 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] XFS: Replace custom AIL linked-list code with struct
 list_head
Message-id: <1200875757-26598-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---

I tested it with xfsqa, and things work as well as they do without it.

---
 fs/xfs/xfs_mount.h     |    2 +-
 fs/xfs/xfs_trans.h     |    7 +---
 fs/xfs/xfs_trans_ail.c |   91 +++++++++++++++++++++---------------------------
 3 files changed, 42 insertions(+), 58 deletions(-)

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
index 4d6330e..c3d402d 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -28,10 +28,10 @@
 #include "xfs_trans_priv.h"
 #include "xfs_error.h"
 
-STATIC void xfs_ail_insert(xfs_ail_entry_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_delete(xfs_ail_entry_t *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_min(xfs_ail_entry_t *);
-STATIC xfs_log_item_t * xfs_ail_next(xfs_ail_entry_t *, xfs_log_item_t *);
+STATIC void xfs_ail_insert(struct list_head *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_delete(struct list_head *, xfs_log_item_t *);
+STATIC xfs_log_item_t * xfs_ail_min(struct list_head *);
+STATIC xfs_log_item_t * xfs_ail_next(struct list_head *, xfs_log_item_t *);
 
 #ifdef DEBUG
 STATIC void xfs_ail_check(xfs_ail_entry_t *, xfs_log_item_t *);
@@ -116,10 +116,12 @@ xfs_trans_first_push_ail(
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
@@ -354,15 +356,13 @@ xfs_trans_update_ail(
 	xfs_log_item_t	*lip,
 	xfs_lsn_t	lsn) __releases(mp->m_ail_lock)
 {
-	xfs_ail_entry_t		*ailp;
 	xfs_log_item_t		*dlip=NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	ailp = &(mp->m_ail.xa_ail);
-	mlip = xfs_ail_min(ailp);
+	mlip = xfs_ail_min(&mp->m_ail.xa_ail);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(ailp, lip);
+		dlip = xfs_ail_delete(&mp->m_ail.xa_ail, lip);
 		ASSERT(dlip == lip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
@@ -370,11 +370,11 @@ xfs_trans_update_ail(
 
 	lip->li_lsn = lsn;
 
-	xfs_ail_insert(ailp, lip);
+	xfs_ail_insert(&mp->m_ail.xa_ail, lip);
 	mp->m_ail.xa_gen++;
 
 	if (mlip == dlip) {
-		mlip = xfs_ail_min(&(mp->m_ail.xa_ail));
+		mlip = xfs_ail_min(&mp->m_ail.xa_ail);
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
+		mlip = xfs_ail_min(&mp->m_ail.xa_ail);
+		dlip = xfs_ail_delete(&mp->m_ail.xa_ail, lip);
 		ASSERT(dlip == lip);
 
 
@@ -514,8 +512,7 @@ int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
-	mp->m_ail.xa_ail.ail_forw = (xfs_log_item_t*)&mp->m_ail.xa_ail;
-	mp->m_ail.xa_ail.ail_back = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	INIT_LIST_HEAD(&mp->m_ail.xa_ail);
 	return xfsaild_start(mp);
 }
 
@@ -534,8 +531,8 @@ xfs_trans_ail_destroy(
  */
 STATIC void
 xfs_ail_insert(
-	xfs_ail_entry_t	*base,
-	xfs_log_item_t	*lip)
+	struct list_head	*base,
+	xfs_log_item_t		*lip)
 /* ARGSUSED */
 {
 	xfs_log_item_t	*next_lip;
@@ -543,25 +540,20 @@ xfs_ail_insert(
 	/*
 	 * If the list is empty, just insert the item.
 	 */
-	if (base->ail_back == (xfs_log_item_t*)base) {
-		base->ail_forw = lip;
-		base->ail_back = lip;
-		lip->li_ail.ail_forw = (xfs_log_item_t*)base;
-		lip->li_ail.ail_back = (xfs_log_item_t*)base;
+	if (list_empty(base)) {
+		list_add(&lip->li_ail, base);
 		return;
 	}
 
-	next_lip = base->ail_back;
-	while ((next_lip != (xfs_log_item_t*)base) &&
-	       (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) > 0)) {
-		next_lip = next_lip->li_ail.ail_back;
+	list_for_each_entry_reverse(next_lip, base, li_ail) {
+		if (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) <= 0)
+			break;
 	}
-	ASSERT((next_lip == (xfs_log_item_t*)base) ||
+
+	ASSERT((&next_lip->li_ail == base) ||
 	       (XFS_LSN_CMP(next_lip->li_lsn, lip->li_lsn) <= 0));
-	lip->li_ail.ail_forw = next_lip->li_ail.ail_forw;
-	lip->li_ail.ail_back = next_lip;
-	next_lip->li_ail.ail_forw = lip;
-	lip->li_ail.ail_forw->li_ail.ail_back = lip;
+
+	list_add(&lip->li_ail, &next_lip->li_ail);
 
 	xfs_ail_check(base, lip);
 	return;
@@ -573,15 +565,13 @@ xfs_ail_insert(
 /*ARGSUSED*/
 STATIC xfs_log_item_t *
 xfs_ail_delete(
-	xfs_ail_entry_t	*base,
-	xfs_log_item_t	*lip)
+	struct list_head	*base,
+	xfs_log_item_t		*lip)
 /* ARGSUSED */
 {
 	xfs_ail_check(base, lip);
-	lip->li_ail.ail_forw->li_ail.ail_back = lip->li_ail.ail_back;
-	lip->li_ail.ail_back->li_ail.ail_forw = lip->li_ail.ail_forw;
-	lip->li_ail.ail_forw = NULL;
-	lip->li_ail.ail_back = NULL;
+
+	list_del(&lip->li_ail);
 
 	return lip;
 }
@@ -592,14 +582,13 @@ xfs_ail_delete(
  */
 STATIC xfs_log_item_t *
 xfs_ail_min(
-	xfs_ail_entry_t	*base)
+	struct list_head	*base)
 /* ARGSUSED */
 {
-	register xfs_log_item_t *forw = base->ail_forw;
-	if (forw == (xfs_log_item_t*)base) {
+	if (list_empty(base))
 		return NULL;
-	}
-	return forw;
+
+	return list_first_entry(base, xfs_log_item_t, li_ail);
 }
 
 /*
@@ -609,14 +598,14 @@ xfs_ail_min(
  */
 STATIC xfs_log_item_t *
 xfs_ail_next(
-	xfs_ail_entry_t	*base,
-	xfs_log_item_t	*lip)
+	struct list_head	*base,
+	xfs_log_item_t		*lip)
 /* ARGSUSED */
 {
-	if (lip->li_ail.ail_forw == (xfs_log_item_t*)base) {
+	if (lip->li_ail.next == base)
 		return NULL;
-	}
-	return lip->li_ail.ail_forw;
+
+	return list_first_entry(&lip->li_ail, xfs_log_item_t, li_ail);
 
 }
 
-- 
1.5.4.rc2.85.g9de45-dirty
