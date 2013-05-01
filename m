Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED6D07F4C
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 09:27:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAF9D304066
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 07:27:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zamhVrc07eGQOhOv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 07:27:42 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r41ERfrk009318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:27:42 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r41EReqn017312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:27:41 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r41EReH3017299 for <xfs@oss.sgi.com>; Wed, 1 May 2013 14:27:40 GMT
Message-ID: <51812658.4060505@oracle.com>
Date: Wed, 01 May 2013 22:27:36 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove XFS_SWRITE_LOG_RES macros
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

Remove the XFS_SWRITE_LOG_RES macros as there is no user of it nowadays.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/xfs/xfs_trans.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index cd29f61..cdff1c6 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -246,10 +246,8 @@ struct xfs_log_item_desc {
 #define	XFS_GROWRTALLOC_LOG_RES(mp)	((mp)->m_reservations.tr_growrtalloc)
 #define	XFS_GROWRTZERO_LOG_RES(mp)	((mp)->m_reservations.tr_growrtzero)
 #define	XFS_GROWRTFREE_LOG_RES(mp)	((mp)->m_reservations.tr_growrtfree)
-#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite)
 /*
- * Logging the inode timestamps on an fsync -- same as SWRITE
- * as long as SWRITE logs the entire inode core
+ * Logging the inode timestamps on an fsync
  */
 #define XFS_FSYNC_TS_LOG_RES(mp)        ((mp)->m_reservations.tr_swrite)
 #define	XFS_WRITEID_LOG_RES(mp)		((mp)->m_reservations.tr_swrite)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
