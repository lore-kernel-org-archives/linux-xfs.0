Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B58E77F55
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3C9B2AC04F
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id k7KfP21mpC48BYIa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:20 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5cHiZ030996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:18 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cG8U009827
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:18 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cGum028329 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:16 GMT
Message-ID: <5195C245.9050804@oracle.com>
Date: Fri, 17 May 2013 13:38:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 3/8] xfs: Make writeid transaction use tr_writeid
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

tr_writeid is defined at mp->m_reservation structure, however,
it does not really being used.

This patch fix it to tr_writeid to fetch the log reservation size.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 509ad4d..6177040 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -255,7 +255,7 @@ struct xfs_log_item_desc {
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_reservations.tr_fsyncts.tr_logres)
-#define	XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_reservations.tr_swrite.tr_logres)
+#define	XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_reservations.tr_writeid.tr_logres)
 #define	XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_reservations.tr_addafork.tr_logres)
 #define	XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_reservations.tr_attrsetm.tr_logres)
 #define	XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_reservations.tr_attrinval.tr_logres)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
