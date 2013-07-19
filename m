Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D38B8050
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:45:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F224F304039
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:45:42 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	1plw6DJ8uoK0RqNL for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:45:41 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004Jc-El
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002MQ-Dl
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 42/49] xfs: Introduce tr_fsyncts to m_reservation
Date: Fri, 19 Jul 2013 16:45:17 +1000
Message-Id: <1374216324-8781-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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
 include/xfs_trans_resv.h | 3 ++-
 libxfs/xfs_trans_resv.c  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/xfs_trans_resv.h b/include/xfs_trans_resv.h
index 0aac1fa..326f17d 100644
--- a/include/xfs_trans_resv.h
+++ b/include/xfs_trans_resv.h
@@ -62,6 +62,7 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
 	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
+	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
 
 /*
@@ -109,7 +110,7 @@ struct xfs_trans_resv {
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
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
