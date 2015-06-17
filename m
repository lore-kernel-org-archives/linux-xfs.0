Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C2CBA7F9D
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 05:54:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D2CDAC002
	for <xfs@oss.sgi.com>; Wed, 17 Jun 2015 03:54:59 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id TYRHYVDemkuYVDnR (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Jun 2015 03:54:58 -0700 (PDT)
Received: from [88.128.80.44] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z5Azh-0002Br-Md
	for xfs@oss.sgi.com; Wed, 17 Jun 2015 10:54:58 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] libxfs: simplify xfs_trans_free_items
Date: Wed, 17 Jun 2015 12:52:59 +0200
Message-Id: <1434538381-4847-3-git-send-email-hch@lst.de>
In-Reply-To: <1434538381-4847-1-git-send-email-hch@lst.de>
References: <1434538381-4847-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Remove the unused flags parameter and mark the function as static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h |  1 -
 libxfs/trans.c       | 11 ++++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 63da624..5819efa 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -423,7 +423,6 @@ int xfs_trans_roll(struct xfs_trans **, struct xfs_inode *);
 /* xfs_trans_item.c */
 void xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void xfs_trans_del_item(struct xfs_log_item *);
-void xfs_trans_free_items(struct xfs_trans *, int);
 
 /* xfs_inode_item.c */
 void xfs_inode_item_init(struct xfs_inode *, struct xfs_mount *);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 9a44af4..866c379 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -30,6 +30,8 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 
+static void xfs_trans_free_items(struct xfs_trans *tp);
+
 /*
  * Simple transaction interface
  */
@@ -205,7 +207,7 @@ libxfs_trans_cancel(
 	xfs_trans_t	*otp = tp;
 #endif
 	if (tp != NULL) {
-		xfs_trans_free_items(tp, flags);
+		xfs_trans_free_items(tp);
 		free(tp);
 		tp = NULL;
 	}
@@ -778,10 +780,9 @@ inode_item_unlock(
  * Unlock all of the items of a transaction and free all the descriptors
  * of that transaction.
  */
-void
+static void
 xfs_trans_free_items(
-	struct xfs_trans	*tp,
-	int			flags)
+	struct xfs_trans	*tp)
 {
 	struct xfs_log_item_desc *lidp, *next;
 
@@ -818,7 +819,7 @@ libxfs_trans_commit(
 #ifdef XACT_DEBUG
 		fprintf(stderr, "committed clean transaction %p\n", tp);
 #endif
-		xfs_trans_free_items(tp, flags);
+		xfs_trans_free_items(tp);
 		free(tp);
 		tp = NULL;
 		return 0;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
