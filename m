Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAG6j8r4067678 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:45:08 -0600
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id a9I0vkCNabOowJG1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 22:47:13 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qAG6lCgQ004748
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:47:13 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qAG6lBAc020992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 06:47:12 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qAG6lB6V005901 for <xfs@oss.sgi.com>; Fri, 16 Nov 2012 00:47:11 -0600
Message-ID: <50A5E16B.50209@oracle.com>
Date: Fri, 16 Nov 2012 14:47:07 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 15/15] xfs: Make xfs_trans_mod_sb() aware of negative deltas
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

For FS shrink, the FS_DBLOCKS will be reduced, and maybe the AG count will be
decreased as well if there have empty AGs beyond the new FS size.
This patch is trying to make xfs_trans_mod_sb() aware of those possible negative
delta values for shrinkfs only.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_trans.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index d7346da..6ae2627 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -864,7 +864,7 @@ xfs_trans_mod_sb(
 		 * transaction.  Make sure it does not exceed the
 		 * number reserved.
 		 */
-		if (delta < 0) {
+		if (delta < 0 && tp->t_type != XFS_TRANS_SHRINKFS) {
 			tp->t_blk_res_used += (uint)-delta;
 			ASSERT(tp->t_blk_res_used <= tp->t_blk_res);
 		}
@@ -905,11 +905,17 @@ xfs_trans_mod_sb(
 		tp->t_res_frextents_delta += delta;
 		break;
 	case XFS_TRANS_SB_DBLOCKS:
-		ASSERT(delta > 0);
+		if (tp->t_type != XFS_TRANS_SHRINKFS)
+			ASSERT(delta > 0);
+		else
+			ASSERT(delta < 0);
 		tp->t_dblocks_delta += delta;
 		break;
 	case XFS_TRANS_SB_AGCOUNT:
-		ASSERT(delta > 0);
+		if (tp->t_type != XFS_TRANS_SHRINKFS)
+			ASSERT(delta > 0);
+		else
+			ASSERT(delta < 0);
 		tp->t_agcount_delta += delta;
 		break;
 	case XFS_TRANS_SB_IMAXPCT:
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
