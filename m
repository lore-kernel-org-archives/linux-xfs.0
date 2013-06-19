Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC1517FCC
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55F5CAC002
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	1RbAN8vATrfH3yFO for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4z-0003DH-18
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4y-0000H5-TQ
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 46/50] xfs: Introduce tr_fsyncts to m_reservation
Date: Wed, 19 Jun 2013 15:36:09 +1000
Message-Id: <1371620173-712-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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

A preparation step.

For now fsync_ts transaction use the pre-calculated log reservation
size of tr_swrite.
This patch introduce a new item tr_fsyncts to mp->m_reservations
structure so that we can fetch the log reservation value for it
in a same manner to others.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 include/xfs_trans_resv.h |    3 ++-
 libxfs/xfs_trans_resv.c  |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/xfs_trans_resv.h b/include/xfs_trans_resv.h
index e5e32c7..785128f 100644
--- a/include/xfs_trans_resv.h
+++ b/include/xfs_trans_resv.h
@@ -60,6 +60,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
+	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
 
 /*
@@ -107,7 +108,7 @@ struct xfs_trans_resv {
  * Logging the inode timestamps on an fsync -- same as SWRITE
  * as long as SWRITE logs the entire inode core
  */
-#define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_resv.tr_swrite.tr_logres)
+#define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_resv.tr_fsyncts.tr_logres)
 #define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_swrite.tr_logres)
 #define XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_resv.tr_addafork.tr_logres)
 #define XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_resv.tr_attrsetm.tr_logres)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index e0b8ef6..36aeafe 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -734,6 +734,7 @@ xfs_trans_resv_calc(
 	resp->tr_ichange.tr_logres = xfs_calc_ichange_reservation(mp);
 	resp->tr_growdata.tr_logres = xfs_calc_growdata_reservation(mp);
 	resp->tr_swrite.tr_logres = xfs_calc_swrite_reservation(mp);
+	resp->tr_fsyncts.tr_logres = xfs_calc_swrite_reservation(mp);
 	resp->tr_writeid.tr_logres = xfs_calc_writeid_reservation(mp);
 	resp->tr_attrsetrt.tr_logres = xfs_calc_attrsetrt_reservation(mp);
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
