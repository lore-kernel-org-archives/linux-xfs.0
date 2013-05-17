Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 471A97F5D
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 00:38:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 270358F8040
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 22:38:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id usgpz5LWKQdnxR2I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 22:38:37 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r4H5cY9l031346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:35 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cZ7g013875
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:35 GMT
Received: from abhmt102.oracle.com (abhmt102.oracle.com [141.146.116.54])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r4H5cZdS010733 for <xfs@oss.sgi.com>; Fri, 17 May 2013 05:38:35 GMT
Message-ID: <5195C258.4040103@oracle.com>
Date: Fri, 17 May 2013 13:38:32 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 5/8] xfs: Get rid of all XFS_XXX_LOG_RES() macro
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

Get rid of all XFS_XXX_LOG_RES() macros since they are obsoleted now.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans.h |   44 --------------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8049f55..a1a1835 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -231,50 +231,6 @@ struct xfs_log_item_desc {
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
-
-#define	XFS_WRITE_LOG_RES(mp)	((mp)->m_reservations.tr_write.tr_logres)
-#define	XFS_RENAME_LOG_RES(mp)	((mp)->m_reservations.tr_rename.tr_logres)
-#define	XFS_LINK_LOG_RES(mp)	((mp)->m_reservations.tr_link.tr_logres)
-#define	XFS_REMOVE_LOG_RES(mp)	((mp)->m_reservations.tr_remove.tr_logres)
-#define	XFS_SYMLINK_LOG_RES(mp)	((mp)->m_reservations.tr_symlink.tr_logres)
-#define	XFS_CREATE_LOG_RES(mp)	((mp)->m_reservations.tr_create.tr_logres)
-#define	XFS_MKDIR_LOG_RES(mp)	((mp)->m_reservations.tr_mkdir.tr_logres)
-#define	XFS_IFREE_LOG_RES(mp)	((mp)->m_reservations.tr_ifree.tr_logres)
-#define	XFS_ICHANGE_LOG_RES(mp)	((mp)->m_reservations.tr_ichange.tr_logres)
-#define	XFS_GROWDATA_LOG_RES(mp)  ((mp)->m_reservations.tr_growdata.tr_logres)
-#define	XFS_ITRUNCATE_LOG_RES(mp) ((mp)->m_reservations.tr_itruncate.tr_logres)
-#define	XFS_GROWRTALLOC_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_growrtalloc.tr_logres)
-#define	XFS_GROWRTZERO_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_growrtzero.tr_logres)
-#define	XFS_GROWRTFREE_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_growrtfree.tr_logres)
-#define	XFS_SWRITE_LOG_RES(mp)	((mp)->m_reservations.tr_swrite.tr_logres)
-/*
- * Logging the inode timestamps on an fsync -- same as SWRITE
- * as long as SWRITE logs the entire inode core
- */
-#define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_reservations.tr_fsyncts.tr_logres)
-#define	XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_reservations.tr_writeid.tr_logres)
-#define	XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_reservations.tr_addafork.tr_logres)
-#define	XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_reservations.tr_attrsetm.tr_logres)
-#define	XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_reservations.tr_attrinval.tr_logres)
-#define XFS_ATTRSETRT_LOG_RES(mp) ((mp)->m_reservations.tr_attrsetrt.tr_logres)
-#define	XFS_ATTRRM_LOG_RES(mp)	  ((mp)->m_reservations.tr_attrrm.tr_logres)
-#define XFS_SB_LOG_RES(mp)	  ((mp)->m_reservations.tr_sb.tr_logres)
-#define	XFS_CLEAR_AGI_BUCKET_LOG_RES(mp)\
-	((mp)->m_reservations.tr_clearagi.tr_logres)
-#define XFS_QM_SBCHANGE_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_qm_sbchange.tr_logres)
-#define XFS_QM_SETQLIM_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_qm_setqlim.tr_logres)
-#define XFS_QM_DQALLOC_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_qm_dqalloc.tr_logres)
-#define XFS_QM_QUOTAOFF_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_qm_quotaoff.tr_logres)
-#define XFS_QM_QUOTAOFF_END_LOG_RES(mp)	\
-	((mp)->m_reservations.tr_qm_equotaoff.tr_logres)
-
 /*
  * Various log count values.
  */
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
