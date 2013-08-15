Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B86A67F50
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 00:08:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98D0B8F8040
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 22:08:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9ujLp5G6l6M2hb8A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 22:08:07 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r7F586F5015803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 05:08:07 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7F585uo019559
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 05:08:06 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7F5844e028645 for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 05:08:04 GMT
Message-ID: <520C6253.6080809@oracle.com>
Date: Thu, 15 Aug 2013 13:08:35 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2] xfs: Simplify xfs_ail_min() with list_first_entry_or_null()
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

At xfs_ail_min(), we do check if the AIL list is empty or not before
returning the first item in it with list_empty() and list_first_entry().

This can be simplified a bit with a new list operation routine that is
the list_first_entry_or_null() which has been introduced by:

commit 6d7581e62f8be462440d7b22c6361f7c9fa4902b
    list: introduce list_first_entry_or_null

v2: make xfs_ail_min() as a static inline function and move it to
    xfs_trans_priv.h as per Dave Chinner's comments.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c  |   14 --------------
 fs/xfs/xfs_trans_priv.h |   12 ++++++++++++
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0eda725..0e7df03 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -61,20 +61,6 @@ xfs_ail_check(
 #endif /* DEBUG */
 
 /*
- * Return a pointer to the first item in the AIL.  If the AIL is empty, then
- * return NULL.
- */
-xfs_log_item_t *
-xfs_ail_min(
-	struct xfs_ail  *ailp)
-{
-	if (list_empty(&ailp->xa_ail))
-		return NULL;
-
-	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
-}
-
- /*
  * Return a pointer to the last item in the AIL.  If the AIL is empty, then
  * return NULL.
  */
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index d43b130..c52def0 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -86,6 +86,18 @@ void	xfs_trans_ail_update_bulk(struct xfs_ail *ailp,
 				struct xfs_ail_cursor *cur,
 				struct xfs_log_item **log_items, int nr_items,
 				xfs_lsn_t lsn) __releases(ailp->xa_lock);
+/*
+ * Return a pointer to the first item in the AIL.  If the AIL is empty, then
+ * return NULL.
+ */
+static inline struct xfs_log_item *
+xfs_ail_min(
+	struct xfs_ail  *ailp)
+{
+	return list_first_entry_or_null(&ailp->xa_ail, struct xfs_log_item,
+					li_ail);
+}
+
 static inline void
 xfs_trans_ail_update(
 	struct xfs_ail		*ailp,
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
