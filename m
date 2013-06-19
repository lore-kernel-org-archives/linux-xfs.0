Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AEB9D7FB6
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97F53304051
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	EQBllDD5Mmqa9Wrg for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4z-0003DJ-2f
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:13 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4y-0000HG-UV
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 47/50] xfs: Make writeid transaction use tr_writeid
Date: Wed, 19 Jun 2013 15:36:10 +1000
Message-Id: <1371620173-712-48-git-send-email-david@fromorbit.com>
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

tr_writeid is defined at mp->m_resv structure, however, it does not
really being used when it should be..

This patch changes it to tr_writeid to fetch the correct log
reservation size.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_trans_resv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/xfs_trans_resv.h b/include/xfs_trans_resv.h
index 785128f..27b64c5 100644
--- a/include/xfs_trans_resv.h
+++ b/include/xfs_trans_resv.h
@@ -109,7 +109,7 @@ struct xfs_trans_resv {
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_resv.tr_fsyncts.tr_logres)
-#define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_swrite.tr_logres)
+#define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_writeid.tr_logres)
 #define XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_resv.tr_addafork.tr_logres)
 #define XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_resv.tr_attrsetm.tr_logres)
 #define XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_resv.tr_attrinval.tr_logres)
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
