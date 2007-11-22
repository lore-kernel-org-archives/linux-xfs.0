Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:50:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0nwGX016746
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:50:01 -0800
Date: Thu, 22 Nov 2007 11:50:03 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2/2] Debug - don't exhaustively check the AIL on every operation
Message-ID: <20071122005003.GQ114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>


Checking the entire AIL on every insert and remove is
prohibitively expensive - the sustained sequntial create rate
on a single disk drops from about 1800/s to 60/s because of
this checking resulting in the xfslogd becoming cpu bound.

By default on debug builds, only check the next and previous
entries in the list to ensure they are ordered correctly.
If you really want, define XFS_TRANS_DEBUG to use the old
behaviour.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_trans_ail.c |   37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2007-11-22 10:34:01.564358689 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2007-11-22 10:34:03.320134239 +1100
@@ -34,9 +34,9 @@ STATIC xfs_log_item_t * xfs_ail_min(xfs_
 STATIC xfs_log_item_t * xfs_ail_next(xfs_ail_entry_t *, xfs_log_item_t *);
 
 #ifdef DEBUG
-STATIC void xfs_ail_check(xfs_ail_entry_t *);
+STATIC void xfs_ail_check(xfs_ail_entry_t *, xfs_log_item_t *);
 #else
-#define	xfs_ail_check(a)
+#define	xfs_ail_check(a,l)
 #endif /* DEBUG */
 
 
@@ -563,7 +563,7 @@ xfs_ail_insert(
 	next_lip->li_ail.ail_forw = lip;
 	lip->li_ail.ail_forw->li_ail.ail_back = lip;
 
-	xfs_ail_check(base);
+	xfs_ail_check(base, lip);
 	return;
 }
 
@@ -577,12 +577,12 @@ xfs_ail_delete(
 	xfs_log_item_t	*lip)
 /* ARGSUSED */
 {
+	xfs_ail_check(base, lip);
 	lip->li_ail.ail_forw->li_ail.ail_back = lip->li_ail.ail_back;
 	lip->li_ail.ail_back->li_ail.ail_forw = lip->li_ail.ail_forw;
 	lip->li_ail.ail_forw = NULL;
 	lip->li_ail.ail_back = NULL;
 
-	xfs_ail_check(base);
 	return lip;
 }
 
@@ -626,13 +626,13 @@ xfs_ail_next(
  */
 STATIC void
 xfs_ail_check(
-	xfs_ail_entry_t *base)
+	xfs_ail_entry_t *base,
+	xfs_log_item_t	*lip)
 {
-	xfs_log_item_t	*lip;
 	xfs_log_item_t	*prev_lip;
 
-	lip = base->ail_forw;
-	if (lip == (xfs_log_item_t*)base) {
+	prev_lip = base->ail_forw;
+	if (prev_lip == (xfs_log_item_t*)base) {
 		/*
 		 * Make sure the pointers are correct when the list
 		 * is empty.
@@ -642,9 +642,27 @@ xfs_ail_check(
 	}
 
 	/*
+	 * Check the next and previous entries are valid.
+	 */
+	ASSERT((lip->li_flags & XFS_LI_IN_AIL) != 0);
+	prev_lip = lip->li_ail.ail_back;
+	if (prev_lip != (xfs_log_item_t*)base) {
+		ASSERT(prev_lip->li_ail.ail_forw == lip);
+		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) <= 0);
+	}
+	prev_lip = lip->li_ail.ail_forw;
+	if (prev_lip != (xfs_log_item_t*)base) {
+		ASSERT(prev_lip->li_ail.ail_back == lip);
+		ASSERT(XFS_LSN_CMP(prev_lip->li_lsn, lip->li_lsn) >= 0);
+	}
+
+
+#ifdef XFS_TRANS_DEBUG
+	/*
 	 * Walk the list checking forward and backward pointers,
 	 * lsn ordering, and that every entry has the XFS_LI_IN_AIL
-	 * flag set.
+	 * flag set. This is really expensive, so only do it when
+	 * specifically debugging the transaction subsystem.
 	 */
 	prev_lip = (xfs_log_item_t*)base;
 	while (lip != (xfs_log_item_t*)base) {
@@ -659,5 +677,6 @@ xfs_ail_check(
 	}
 	ASSERT(lip == (xfs_log_item_t*)base);
 	ASSERT(base->ail_back == prev_lip);
+#endif /* XFS_TRANS_DEBUG */
 }
 #endif /* DEBUG */
