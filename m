Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E925C7FA0
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 06:48:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA3BE304053
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 04:48:32 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id RnRNwYMRunRI8atB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Dec 2013 04:48:32 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBOCmUvq011729
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:31 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmUvm011246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:30 GMT
Received: from ubhmt109.oracle.com (ubhmt109.oracle.com [156.151.24.14])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBOCmTsX011234 for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 12:48:29 GMT
Message-ID: <52B9829A.10804@oracle.com>
Date: Tue, 24 Dec 2013 20:48:26 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs: simplify xfs_ail_max
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

We have already simplified xfs_ail_min() with a new list helper, i.e,
list_first_entry_or_null(), but xfs_ail_max() still remains as same
as there is no corresponding list helper we can use for now.  It's
fairly easy to simulate the list behavior of getting the last item
in the AIL, therefore we can simplify xfs_ail_max() and move it to
the header file to make this pair of AIL routines looks symmetrical.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c  | 14 --------------
 fs/xfs/xfs_trans_priv.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 14 deletions(-)

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
index 12e86af..c564e94 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -97,6 +97,19 @@ xfs_ail_min(
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
+	return list_empty(&ailp->xa_ail) ? NULL :
+		list_last_entry(&ailp->xa_ail, struct xfs_log_item, li_ail);
+}
+
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
