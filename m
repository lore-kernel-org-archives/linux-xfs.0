Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7SJsD244766 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5E071CE33CF
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:30:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	23fBXege6jjf1Yxb for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:30:15 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50071192-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 18:00:14 +1030 (CDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfc-0001D1-W1
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:30:05 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwfH-0006ZP-NJ
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/34] xfs: clean up xfs_ail_delete()
Date: Tue, 21 Dec 2010 18:29:12 +1100
Message-Id: <1292916570-25015-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_ail_delete() has a needlessly complex interface. It returns the log item
that was passed in for deletion (which the callers then assert is identical to
the one passed in), and callers of xfs_ail_delete() still need to invalidate
current traversal cursors.

Make xfs_ail_delete() return void, move the cursor invalidation inside it, and
clean up the callers just to use the log item pointer they passed in.

While cleaning up, remove the messy and unnecessary "/* ARGUSED */" comments
around all these functions.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans_ail.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index dc90695..645928c 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -29,7 +29,7 @@
 #include "xfs_error.h"
 
 STATIC void xfs_ail_insert(struct xfs_ail *, xfs_log_item_t *);
-STATIC xfs_log_item_t * xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
+STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
 STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
 STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
 
@@ -468,16 +468,13 @@ xfs_trans_ail_update(
 	xfs_log_item_t	*lip,
 	xfs_lsn_t	lsn) __releases(ailp->xa_lock)
 {
-	xfs_log_item_t		*dlip = NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 	xfs_lsn_t		tail_lsn;
 
 	mlip = xfs_ail_min(ailp);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		dlip = xfs_ail_delete(ailp, lip);
-		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(ailp, dlip);
+		xfs_ail_delete(ailp, lip);
 	} else {
 		lip->li_flags |= XFS_LI_IN_AIL;
 	}
@@ -485,7 +482,7 @@ xfs_trans_ail_update(
 	lip->li_lsn = lsn;
 	xfs_ail_insert(ailp, lip);
 
-	if (mlip == dlip) {
+	if (mlip == lip) {
 		mlip = xfs_ail_min(ailp);
 		/*
 		 * It is not safe to access mlip after the AIL lock is
@@ -524,21 +521,18 @@ xfs_trans_ail_delete(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip) __releases(ailp->xa_lock)
 {
-	xfs_log_item_t		*dlip;
 	xfs_log_item_t		*mlip;
 	xfs_lsn_t		tail_lsn;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
 		mlip = xfs_ail_min(ailp);
-		dlip = xfs_ail_delete(ailp, lip);
-		ASSERT(dlip == lip);
-		xfs_trans_ail_cursor_clear(ailp, dlip);
+		xfs_ail_delete(ailp, lip);
 
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
 
-		if (mlip == dlip) {
+		if (mlip == lip) {
 			mlip = xfs_ail_min(ailp);
 			/*
 			 * It is not safe to access mlip after the AIL lock
@@ -632,7 +626,6 @@ STATIC void
 xfs_ail_insert(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	xfs_log_item_t	*next_lip;
 
@@ -661,18 +654,14 @@ xfs_ail_insert(
 /*
  * Delete the given item from the AIL.  Return a pointer to the item.
  */
-/*ARGSUSED*/
-STATIC xfs_log_item_t *
+STATIC void
 xfs_ail_delete(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	xfs_ail_check(ailp, lip);
-
 	list_del(&lip->li_ail);
-
-	return lip;
+	xfs_trans_ail_cursor_clear(ailp, lip);
 }
 
 /*
@@ -682,7 +671,6 @@ xfs_ail_delete(
 STATIC xfs_log_item_t *
 xfs_ail_min(
 	struct xfs_ail	*ailp)
-/* ARGSUSED */
 {
 	if (list_empty(&ailp->xa_ail))
 		return NULL;
@@ -699,7 +687,6 @@ STATIC xfs_log_item_t *
 xfs_ail_next(
 	struct xfs_ail	*ailp,
 	xfs_log_item_t	*lip)
-/* ARGSUSED */
 {
 	if (lip->li_ail.next == &ailp->xa_ail)
 		return NULL;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
