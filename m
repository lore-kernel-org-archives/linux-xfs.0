Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49784 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727412AbfCNVD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:03:56 -0400
Subject: [PATCH 01/36] libxfs: fix repair deadlock due to failed inode
 flushes.
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:03:49 -0700
Message-ID: <155259742930.31886.16675099707553706623.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Arkadiusz Miskiewicz <arekm@maven.pl>, Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

If inode_item_done() fails to flush an inode after we've grabbed a
reference to the underlying buffer during a transaction commit, we
fail to put the buffer and hence leak it. We then deadlock on the
next lookup ofthe inode buffer as it is still locked and no-one owns
it.

To fix it, put the buffer on error so that it gets unlocked and
can be recovered appropriately in a later phase of repair.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Fixes: d15188a1ec14 ("xfs: rework the inline directory verifiers")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 46ff8b4a..10a35dd4 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -824,8 +824,10 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 
 /*
  * Transaction commital code follows (i.e. write to disk in libxfs)
+ *
+ * XXX (dgc): should failure to flush the inode (e.g. due to uncorrected
+ * corruption) result in transaction commit failure w/ EFSCORRUPTED?
  */
-
 static void
 inode_item_done(
 	xfs_inode_log_item_t	*iip)
@@ -856,17 +858,24 @@ inode_item_done(
 		return;
 	}
 
+	/*
+	 * Flush the inode and disassociate it from the transaction regardless
+	 * of whether the flush succeed or not. If we fail the flush, make sure
+	 * we still release the buffer reference we currently hold.
+	 */
 	bp->b_log_item = iip;
 	error = libxfs_iflush_int(ip, bp);
+	ip->i_transp = NULL;	/* disassociate from transaction */
+	bp->b_log_item = NULL;	/* remove log item */
+	bp->b_transp = NULL;	/* remove xact ptr */
+
 	if (error) {
 		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
 			progname, error);
+		libxfs_putbuf(bp);
 		return;
 	}
 
-	ip->i_transp = NULL;	/* disassociate from transaction */
-	bp->b_log_item = NULL;	/* remove log item */
-	bp->b_transp = NULL;	/* remove xact ptr */
 	libxfs_writebuf(bp, 0);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
