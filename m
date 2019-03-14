Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:54172 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfCNVHh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:07:37 -0400
Subject: [PATCH 35/36] libxfs: shorten inode item lifetime
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:07:27 -0700
Message-ID: <155259764777.31886.5969876849048391381.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Shorten the inode item lifetime so that we only keep them around while
the inode is joined with a transaction.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c  |    4 +---
 libxfs/trans.c |   19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 69d5abb2..fd8c6591 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1429,9 +1429,7 @@ void
 libxfs_irele(
 	struct xfs_inode	*ip)
 {
-	if (ip->i_itemp)
-		kmem_zone_free(xfs_ili_zone, ip->i_itemp);
-	ip->i_itemp = NULL;
+	ASSERT(ip->i_itemp == NULL);
 	libxfs_idestroy(ip);
 	kmem_zone_free(xfs_inode_zone, ip);
 }
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 2ceb9838..ce199654 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -820,6 +820,16 @@ _("Transaction block reservation exceeded! %u > %u\n"),
 	tp->t_flags |= (XFS_TRANS_SB_DIRTY | XFS_TRANS_DIRTY);
 }
 
+void
+xfs_inode_item_put(
+	struct xfs_inode_log_item	*iip)
+{
+	struct xfs_inode		*ip = iip->ili_inode;
+
+	ip->i_itemp = NULL;
+	kmem_zone_free(xfs_ili_zone, iip);
+}
+
 
 /*
  * Transaction commital code follows (i.e. write to disk in libxfs)
@@ -844,7 +854,7 @@ inode_item_done(
 	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
 		ip->i_transp = NULL;	/* disassociate from transaction */
 		iip->ili_flags = 0;	/* reset all flags */
-		return;
+		goto free;
 	}
 
 	/*
@@ -854,7 +864,7 @@ inode_item_done(
 	if (error) {
 		fprintf(stderr, _("%s: warning - imap_to_bp failed (%d)\n"),
 			progname, error);
-		return;
+		goto free;
 	}
 
 	/*
@@ -870,7 +880,7 @@ inode_item_done(
 		fprintf(stderr, _("%s: warning - iflush_int failed (%d)\n"),
 			progname, error);
 		libxfs_putbuf(bp);
-		return;
+		goto free;
 	}
 
 	libxfs_writebuf(bp, 0);
@@ -878,6 +888,8 @@ inode_item_done(
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
 			ip->i_ino, bp);
 #endif
+free:
+	xfs_inode_item_put(iip);
 }
 
 static void
@@ -955,6 +967,7 @@ inode_item_unlock(
 	ip->i_transp = NULL;
 
 	iip->ili_flags = 0;
+	xfs_inode_item_put(iip);
 }
 
 /* Detach and unlock all of the items in a transaction */
