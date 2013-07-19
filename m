Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE39C7FC9
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:26:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6928C304043
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:26:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	L8vWB5OwB4CW7k6F for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048F-Ev
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001zp-Ar
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 39/49] xfs: Get rid of all XFS_XXX_LOG_RES() macro
Date: Fri, 19 Jul 2013 16:25:10 +1000
Message-Id: <1374215120-7271-40-git-send-email-david@fromorbit.com>
In-Reply-To: <1374215120-7271-1-git-send-email-david@fromorbit.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

Get rid of all XFS_XXX_LOG_RES() macros since they are obsoleted now.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_resv.h | 36 ------------------------------------
 1 file changed, 36 deletions(-)

diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index 140d3f3..de7de9a 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -92,42 +92,6 @@ struct xfs_trans_resv {
 	(XFS_DAENTER_BLOCKS(mp, XFS_DATA_FORK) + \
 	 XFS_DAENTER_BMAPS(mp, XFS_DATA_FORK) + 1)
 
-
-#define XFS_WRITE_LOG_RES(mp)	((mp)->m_resv.tr_write.tr_logres)
-#define XFS_RENAME_LOG_RES(mp)	((mp)->m_resv.tr_rename.tr_logres)
-#define XFS_LINK_LOG_RES(mp)	((mp)->m_resv.tr_link.tr_logres)
-#define XFS_REMOVE_LOG_RES(mp)	((mp)->m_resv.tr_remove.tr_logres)
-#define XFS_SYMLINK_LOG_RES(mp)	((mp)->m_resv.tr_symlink.tr_logres)
-#define XFS_CREATE_LOG_RES(mp)	((mp)->m_resv.tr_create.tr_logres)
-#define XFS_MKDIR_LOG_RES(mp)	((mp)->m_resv.tr_mkdir.tr_logres)
-#define XFS_IFREE_LOG_RES(mp)	((mp)->m_resv.tr_ifree.tr_logres)
-#define XFS_SWRITE_LOG_RES(mp)	((mp)->m_resv.tr_swrite.tr_logres)
-#define XFS_ICHANGE_LOG_RES(mp)	((mp)->m_resv.tr_ichange.tr_logres)
-#define XFS_GROWDATA_LOG_RES(mp)  ((mp)->m_resv.tr_growdata.tr_logres)
-#define XFS_ITRUNCATE_LOG_RES(mp) ((mp)->m_resv.tr_itruncate.tr_logres)
-#define XFS_GROWRTZERO_LOG_RES(mp) ((mp)->m_resv.tr_growrtzero.tr_logres)
-#define XFS_GROWRTFREE_LOG_RES(mp) ((mp)->m_resv.tr_growrtfree.tr_logres)
-#define XFS_GROWRTALLOC_LOG_RES(mp) ((mp)->m_resv.tr_growrtalloc.tr_logres)
-
-/*
- * Logging the inode timestamps on an fsync -- same as SWRITE
- * as long as SWRITE logs the entire inode core
- */
-#define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_resv.tr_fsyncts.tr_logres)
-#define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_writeid.tr_logres)
-#define XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_resv.tr_addafork.tr_logres)
-#define XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_resv.tr_attrsetm.tr_logres)
-#define XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_resv.tr_attrinval.tr_logres)
-#define XFS_ATTRSETRT_LOG_RES(mp) ((mp)->m_resv.tr_attrsetrt.tr_logres)
-#define XFS_ATTRRM_LOG_RES(mp)	  ((mp)->m_resv.tr_attrrm.tr_logres)
-#define XFS_SB_LOG_RES(mp)	  ((mp)->m_resv.tr_sb.tr_logres)
-#define XFS_QM_SETQLIM_LOG_RES(mp) ((mp)->m_resv.tr_qm_setqlim.tr_logres)
-#define XFS_QM_DQALLOC_LOG_RES(mp) ((mp)->m_resv.tr_qm_dqalloc.tr_logres)
-#define XFS_QM_SBCHANGE_LOG_RES(mp) ((mp)->m_resv.tr_qm_sbchange.tr_logres)
-#define XFS_QM_QUOTAOFF_LOG_RES(mp) ((mp)->m_resv.tr_qm_quotaoff.tr_logres)
-#define XFS_QM_QUOTAOFF_END_LOG_RES(mp) ((mp)->m_resv.tr_qm_equotaoff.tr_logres)
-#define XFS_CLEAR_AGI_BUCKET_LOG_RES(mp) ((mp)->m_resv.tr_clearagi.tr_logres)
-
 /*
  * Various log count values.
  */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
