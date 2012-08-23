Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52ZtO134546 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:35 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SRacb11Ik5FwxOP8 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:20 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZa-0003EG-OM
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bi-Lq
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 007/102] xfs: Check the return value of xfs_buf_get()
Date: Thu, 23 Aug 2012 15:01:25 +1000
Message-Id: <1345698180-13612-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Chandra Seetharaman <sekharan@us.ibm.com>

Upstream commit: b522950f0ab8551f2ef56c210ebd50e6c6396601

Check the return value of xfs_buf_get() and fail appropriately.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_attr.c  |    4 ++--
 fs/xfs/xfs_fsops.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 99d4011..fe01931 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -2110,8 +2110,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
 				 XBF_LOCK | XBF_DONT_BLOCK);
-		ASSERT(bp);
-		ASSERT(!XFS_BUF_GETERROR(bp));
+		if (!bp)
+			return ENOMEM;
 
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 9153d2c..ac49ad1 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -194,6 +194,10 @@ xfs_growfs_data_private(
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
 		agf = XFS_BUF_TO_AGF(bp);
 		memset(agf, 0, mp->m_sb.sb_sectsize);
 		agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
@@ -226,6 +230,10 @@ xfs_growfs_data_private(
 		bp = xfs_buf_get(mp->m_ddev_targp,
 				 XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 				 XFS_FSS_TO_BB(mp, 1), XBF_LOCK | XBF_MAPPED);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
 		agi = XFS_BUF_TO_AGI(bp);
 		memset(agi, 0, mp->m_sb.sb_sectsize);
 		agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
@@ -251,6 +259,10 @@ xfs_growfs_data_private(
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
 				 BTOBB(mp->m_sb.sb_blocksize),
 				 XBF_LOCK | XBF_MAPPED);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
@@ -273,6 +285,10 @@ xfs_growfs_data_private(
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_CNT_BLOCK(mp)),
 				 BTOBB(mp->m_sb.sb_blocksize),
 				 XBF_LOCK | XBF_MAPPED);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
@@ -296,6 +312,10 @@ xfs_growfs_data_private(
 				 XFS_AGB_TO_DADDR(mp, agno, XFS_IBT_BLOCK(mp)),
 				 BTOBB(mp->m_sb.sb_blocksize),
 				 XBF_LOCK | XBF_MAPPED);
+		if (!bp) {
+			error = ENOMEM;
+			goto error0;
+		}
 		block = XFS_BUF_TO_BLOCK(bp);
 		memset(block, 0, mp->m_sb.sb_blocksize);
 		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
