Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47900 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:29:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NTIGI126726
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qtwkut94p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:29:18 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NTHVG003193
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:18 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NTHMX022229
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:17 GMT
Subject: [PATCH 23/23] libxfs: free buffer and inode log items when
 cancelling a transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:29:16 -0800
Message-ID: <155148295652.16677.2568753166058619886.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're cancelling a transaction, cancel the log items instead of
leaking them, now that we no longer recycle them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index 0f9f12b6..c36837b1 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -24,6 +24,7 @@ STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
 static int xfs_trans_reserve(struct xfs_trans *tp, struct xfs_trans_res *resp,
 		uint blocks, uint rtextents);
 static int __xfs_trans_commit(struct xfs_trans *tp, bool regrant);
+static void trans_cancel(struct xfs_trans *tp);
 
 /*
  * Simple transaction interface
@@ -326,6 +327,7 @@ libxfs_trans_cancel(
 	if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
 		xfs_defer_cancel(tp);
 
+	trans_cancel(tp);
 	xfs_trans_free_items(tp);
 	xfs_trans_free(tp);
 
@@ -878,6 +880,55 @@ inode_item_done(
 	kmem_zone_free(xfs_ili_zone, iip);
 }
 
+static void
+inode_item_cancel(
+	struct xfs_inode_log_item	*iip)
+{
+	struct xfs_inode		*ip;
+
+	ip = iip->ili_inode;
+	ASSERT(ip != NULL);
+
+	if (iip->ili_fields & XFS_ILOG_ALL) {
+#ifdef XACT_DEBUG
+		fprintf(stderr, "cancelling dirty inode %lu\n", ip->i_ino);
+#endif
+	}
+
+	ip->i_transp = NULL;	/* disassociate from transaction */
+	ip->i_itemp = NULL;
+	kmem_zone_free(xfs_ili_zone, iip);
+}
+
+static void
+buf_item_cancel(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp;
+	int			hold;
+	extern kmem_zone_t	*xfs_buf_item_zone;
+
+	bp = bip->bli_buf;
+	ASSERT(bp != NULL);
+
+	hold = (bip->bli_flags & XFS_BLI_HOLD);
+	if (bip->bli_flags & XFS_BLI_DIRTY) {
+#ifdef XACT_DEBUG
+		fprintf(stderr, "cancelling dirty buffer %p (hold=%d)\n",
+			bp, hold);
+#endif
+	}
+	if (hold)
+		bip->bli_flags &= ~XFS_BLI_HOLD;
+	else
+		libxfs_putbuf(bp);
+
+	/* release the buf item */
+	bp->b_log_item = NULL;			/* remove log item */
+	bp->b_transp = NULL;			/* remove xact ptr */
+	kmem_zone_free(xfs_buf_item_zone, bip);
+}
+
 static void
 buf_item_done(
 	xfs_buf_log_item_t	*bip)
@@ -928,6 +979,27 @@ trans_committed(
 	}
 }
 
+static void
+trans_cancel(
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *next;
+
+	list_for_each_entry_safe(lip, next, &tp->t_items, li_trans) {
+		xfs_trans_del_item(lip);
+
+		if (lip->li_type == XFS_LI_BUF)
+			buf_item_cancel((xfs_buf_log_item_t *)lip);
+		else if (lip->li_type == XFS_LI_INODE)
+			inode_item_cancel((xfs_inode_log_item_t *)lip);
+		else {
+			fprintf(stderr, _("%s: unrecognised log item type\n"),
+				progname);
+			ASSERT(0);
+		}
+	}
+}
+
 static void
 buf_item_unlock(
 	xfs_buf_log_item_t	*bip)
@@ -1033,6 +1105,7 @@ __xfs_trans_commit(
 	return 0;
 
 out_unreserve:
+	trans_cancel(tp);
 	xfs_trans_free_items(tp);
 	xfs_trans_free(tp);
 	return error;
