Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87JfIDM179543 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 14:41:19 -0500
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD04A1428F4
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 12:41:17 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id K1ijty8neLnHzJlH for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 12:41:17 -0700 (PDT)
Received: from /spool/local by us.ibm.com with XMail ESMTP
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 7 Sep 2011 15:38:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p87Jbu6U246242 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 15:37:56 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p87FbhHC003113 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:37:43 -0300
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p87FbfDD003082 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:37:42 -0300
Subject: [PATCH] xfs: Check the return value of xfs_buf_get()
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 07 Sep 2011 14:37:54 -0500
Message-ID: <1315424274.9298.10.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>

Check the return value of xfs_buf_get() and fail appropriately.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_attr.c  |    4 ++--
 fs/xfs/xfs_fsops.c |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 8f0f658..39cdaeb 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -2121,8 +2121,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 
 		bp = xfs_buf_get(mp->m_ddev_targp, dblkno, blkcnt,
 				 XBF_LOCK | XBF_DONT_BLOCK);
-		ASSERT(!xfs_buf_geterror(bp));
-
+		if(!bp)
+			return ENOMEM;
 		tmp = (valuelen < XFS_BUF_SIZE(bp)) ? valuelen :
 							XFS_BUF_SIZE(bp);
 		xfs_buf_iomove(bp, 0, tmp, src, XBRW_WRITE);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index e023f94..1c6fdeb 100644
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
@@ -227,6 +231,10 @@ xfs_growfs_data_private(
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
@@ -253,6 +261,10 @@ xfs_growfs_data_private(
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
@@ -276,6 +288,10 @@ xfs_growfs_data_private(
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
@@ -300,6 +316,10 @@ xfs_growfs_data_private(
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
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
