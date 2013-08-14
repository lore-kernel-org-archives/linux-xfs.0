Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6AF47FB4
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 03:27:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F3B4AC001
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 01:27:30 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id kbaiZP2M3U2iWBGs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Aug 2013 01:27:28 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r7E8RRCe023100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:27:28 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7E8RPid026111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:27:26 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r7E8RPk8012931 for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 08:27:25 GMT
Message-ID: <520B3F8C.5020405@oracle.com>
Date: Wed, 14 Aug 2013 16:27:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Simplify xfs_ail_min() with list_first_entry_or_null()
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

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans_ail.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0eda725..e91d160 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -68,10 +68,7 @@ xfs_log_item_t *
 xfs_ail_min(
 	struct xfs_ail  *ailp)
 {
-	if (list_empty(&ailp->xa_ail))
-		return NULL;
-
-	return list_first_entry(&ailp->xa_ail, xfs_log_item_t, li_ail);
+	return list_first_entry_or_null(&ailp->xa_ail, xfs_log_item_t, li_ail);
 }
 
  /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
