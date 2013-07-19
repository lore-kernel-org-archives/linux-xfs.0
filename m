Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C7767F8E
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:25:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3973FAC00E
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:25:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MnFL9O8dgLeY5GP4 for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:25:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V0483-00048s-Jg
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V0483-0001ze-8O
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:25:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/49] xfs: Make writeid transaction use tr_writeid
Date: Fri, 19 Jul 2013 16:25:08 +1000
Message-Id: <1374215120-7271-38-git-send-email-david@fromorbit.com>
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

tr_writeid is defined at mp->m_resv structure, however, it does not
really being used when it should be..

This patch changes it to tr_writeid to fetch the correct log
reservation size.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans_resv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_resv.h b/fs/xfs/xfs_trans_resv.h
index 326f17d..b8d5666 100644
--- a/fs/xfs/xfs_trans_resv.h
+++ b/fs/xfs/xfs_trans_resv.h
@@ -111,7 +111,7 @@ struct xfs_trans_resv {
  * as long as SWRITE logs the entire inode core
  */
 #define XFS_FSYNC_TS_LOG_RES(mp) ((mp)->m_resv.tr_fsyncts.tr_logres)
-#define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_swrite.tr_logres)
+#define XFS_WRITEID_LOG_RES(mp)	 ((mp)->m_resv.tr_writeid.tr_logres)
 #define XFS_ADDAFORK_LOG_RES(mp) ((mp)->m_resv.tr_addafork.tr_logres)
 #define XFS_ATTRSETM_LOG_RES(mp) ((mp)->m_resv.tr_attrsetm.tr_logres)
 #define XFS_ATTRINVAL_LOG_RES(mp) ((mp)->m_resv.tr_attrinval.tr_logres)
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
