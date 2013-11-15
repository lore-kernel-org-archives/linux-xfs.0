Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 76D817F72
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 22:32:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6301D8F8054
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 20:32:04 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UvtweFWv7DH00YAV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 20:32:03 -0800 (PST)
Message-ID: <5285A39C.4030507@oracle.com>
Date: Fri, 15 Nov 2013 12:31:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 2/6] xfs: simplify xfs_ail_max() via list_last_entry_or_null()
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, jiri@resnulli.us, gregkh@linuxfoundation.org, oleg@redhat.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, akpm@linux-foundation.org

From: Jie Liu <jeff.liu@oracle.com>

Simplify xfs_ail_max() with list_last_entry_or_null(), and move it to
xfs_trans_priv.h as an inline function as now it is one line.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c  | 14 --------------
 fs/xfs/xfs_trans_priv.h | 12 ++++++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a728735..af605d0 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -62,20 +62,6 @@ xfs_ail_check(
 #endif /* DEBUG */
 
 /*
- * Return a pointer to the last item in the AIL.  If the AIL is empty, then
- * return NULL.
- */
-static xfs_log_item_t *
-xfs_ail_max(
-	struct xfs_ail  *ailp)
-{
-	if (list_empty(&ailp->xa_ail))
-		return NULL;
-
-	return list_entry(ailp->xa_ail.prev, xfs_log_item_t, li_ail);
-}
-
-/*
  * Return a pointer to the item which follows the given item in the AIL.  If
  * the given item is the last item in the list, then return NULL.
  */
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 12e86af..b1d93ae 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -97,6 +97,18 @@ xfs_ail_min(
 					li_ail);
 }
 
+/*
+ * Return a pointer to the last item in the AIL.  If the AIL is empty, then
+ * return NULL.
+ */
+static inline struct xfs_log_item *
+xfs_ail_max(
+	struct xfs_ail  *ailp)
+{
+	return list_last_entry_or_null(&ailp->xa_ail, struct xfs_log_item,
+				       li_ail);
+}
+
 static inline void
 xfs_trans_ail_update(
 	struct xfs_ail		*ailp,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
