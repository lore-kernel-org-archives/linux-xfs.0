Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p64LL1nE189650 for <xfs@oss.sgi.com>; Mon, 4 Jul 2011 16:21:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD91A4A1C6
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2011 14:20:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	01i5GnhtCZtHBQ3s for <xfs@oss.sgi.com>;
	Mon, 04 Jul 2011 14:20:58 -0700 (PDT)
Date: Mon, 4 Jul 2011 17:20:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: use a cursor for bulk AIL insertion
Message-ID: <20110704212055.GA24500@infradead.org>
References: <1309757260-5484-1-git-send-email-david@fromorbit.com>
	<1309757260-5484-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309757260-5484-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

FYI: the following patch implementing my suggested cleanups survived a
few rounds of xfsqa:


Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-07-04 16:04:08.932174424 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-07-04 16:12:51.402677292 +0200
@@ -267,26 +267,14 @@ out:
 static struct xfs_log_item *
 __xfs_trans_ail_cursor_last(
 	struct xfs_ail		*ailp,
-	struct xfs_ail_cursor	*cur,
-	xfs_lsn_t		lsn,
-	bool			do_init)
+	xfs_lsn_t		lsn)
 {
-	xfs_log_item_t		*lip = NULL;
-
-	if (do_init)
-		xfs_trans_ail_cursor_init(ailp, cur);
+	struct xfs_log_item	*lip;
 
-	if (list_empty(&ailp->xa_ail)) 
-		goto out;
-
-	list_for_each_entry_reverse(lip, &ailp->xa_ail, li_ail) {
+	list_for_each_entry_reverse(lip, &ailp->xa_ail, li_ail)
 		if (XFS_LSN_CMP(lip->li_lsn, lsn) <= 0)
-			break;
-	}
-out:
-	if (cur)
-		cur->item = lip;
-	return lip;
+			return lip;
+	return NULL;
 }
 
 /*
@@ -300,7 +288,9 @@ xfs_trans_ail_cursor_last(
 	struct xfs_ail_cursor	*cur,
 	xfs_lsn_t		lsn)
 {
-	return __xfs_trans_ail_cursor_last(ailp, cur, lsn, true);
+	xfs_trans_ail_cursor_init(ailp, cur);
+	cur->item = __xfs_trans_ail_cursor_last(ailp, lsn);
+	return cur->item;
 }
 
 /*
@@ -319,27 +309,22 @@ xfs_ail_splice(
 	struct xfs_log_item	*lip = cur ? cur->item : NULL;
 	struct xfs_log_item	*next_lip;
 
-	do {
-		/* no placeholder, so get our insert location */
-		if (!lip)
-			lip = __xfs_trans_ail_cursor_last(ailp, cur,
-								lsn, false);
-
+	/*
+	 * Get a new cursor if we do not have a placeholder or an
+	 * invalidated one.
+	 */
+	if (!lip || (__psint_t)lip & 1) {
+		lip = __xfs_trans_ail_cursor_last(ailp, lsn);
 		if (!lip) {
 			/*
-			 * The list is empty, so just splice and return.  Our
-			 * cursor is already guaranteed to be up to date, so we
-			 * don't need to touch it here.
+			 * The list is empty, so just splice and return.
 			 */
+			if (cur)
+				cur->item = NULL;
 			list_splice(list, &ailp->xa_ail);
 			return;
 		}
-
-		/* The placeholder was invalidated, need to get a new cursor */
-		if ((__psint_t)lip & 1)
-			lip = NULL;
-
-	} while (lip == NULL);
+	}
 
 	/*
 	 * Our cursor points to the item we want to insert _after_, so we have

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
