Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E295AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240584AbiATAXt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237314AbiATAXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D902C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E726FB81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9521DC004E1;
        Thu, 20 Jan 2022 00:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638225;
        bh=u4qrgJpKWL6t1TOgzSRQabEIHdoucYAk1ORnYtJeor4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mX9xp8nCGddg/T7J6veD4BF3uqltJRMGZMRNHR742oZv8Ue3g+tWTcpM6lxEN4o1V
         J4+x5TXKVfugXVCC0xC5uuQUctEVadPlSPFZjnvobQv++39kyy5XiG7J68UE/bLXIi
         P520VZnYCV6XFmvuCkZbSTULuMAKOUGQYUb5qciK79b84pehctmJf+vU2T+1wftrF6
         6HwxrqZz7t4OaP7hXcE5vwW+dV1X6SBoD7fNCfnFeERfc12TWrLuGRxvIJVuMi+x6v
         ro+NJoUsSs76X/MCmfft1Rsd+y6O9CY5L2+Ay8qg/xraDieuephU/RnhdpW4C02U4T
         L3/RGYga6Txrg==
Subject: [PATCH 06/48] xfs: remove the xfs_dinode_t typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:45 -0800
Message-ID: <164263822527.865554.11247552485969553312.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: de38db7239c4bd2f37ebfcb8a5f22b4e8e657737

Remove the few leftover instances of the xfs_dinode_t typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/bmap.c               |    4 ++--
 db/bmroot.c             |   18 +++++++++---------
 db/check.c              |   30 +++++++++++++++--------------
 db/field.c              |    4 ++--
 db/frag.c               |   18 +++++++++---------
 db/inode.c              |   46 +++++++++++++++++++++++----------------------
 db/metadump.c           |   20 ++++++++++----------
 estimate/xfs_estimate.c |    2 +-
 libxfs/util.c           |    2 +-
 libxfs/xfs_format.h     |    4 ++--
 libxfs/xfs_inode_buf.c  |    6 +++---
 libxfs/xfs_inode_fork.c |   16 ++++++++--------
 repair/attr_repair.c    |    6 +++---
 repair/attr_repair.h    |    2 +-
 repair/da_util.h        |    2 +-
 repair/dino_chunks.c    |    4 ++--
 repair/dinode.c         |   48 ++++++++++++++++++++++++-----------------------
 repair/dinode.h         |    6 +++---
 repair/dir2.c           |   14 +++++++-------
 repair/dir2.h           |    2 +-
 repair/incore.h         |    2 +-
 repair/prefetch.c       |    6 +++---
 repair/rt.c             |    4 ++--
 repair/rt.h             |    2 +-
 24 files changed, 134 insertions(+), 134 deletions(-)


diff --git a/db/bmap.c b/db/bmap.c
index fdc70e95..43300456 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -38,7 +38,7 @@ bmap(
 	struct xfs_btree_block	*block;
 	xfs_fsblock_t		bno;
 	xfs_fileoff_t		curoffset;
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 	xfs_fileoff_t		eoffset;
 	xfs_bmbt_rec_t		*ep;
 	enum xfs_dinode_fmt	fmt;
@@ -129,7 +129,7 @@ bmap_f(
 	int		c;
 	xfs_fileoff_t	co, cosave;
 	int		dfork = 0;
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 	xfs_fileoff_t	eo;
 	xfs_filblks_t	len;
 	int		nex;
diff --git a/db/bmroot.c b/db/bmroot.c
index f859ac3c..488727ba 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -61,7 +61,7 @@ bmroota_key_count(
 {
 	xfs_bmdr_block_t	*block;
 #ifdef DEBUG
-	xfs_dinode_t		*dip = obj;
+	struct xfs_dinode		*dip = obj;
 #endif
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -80,7 +80,7 @@ bmroota_key_offset(
 {
 	xfs_bmdr_block_t	*block;
 #ifdef DEBUG
-	xfs_dinode_t		*dip = obj;
+	struct xfs_dinode		*dip = obj;
 #endif
 	xfs_bmdr_key_t		*kp;
 
@@ -100,7 +100,7 @@ bmroota_ptr_count(
 {
 	xfs_bmdr_block_t	*block;
 #ifdef DEBUG
-	xfs_dinode_t		*dip = obj;
+	struct xfs_dinode		*dip = obj;
 #endif
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -118,7 +118,7 @@ bmroota_ptr_offset(
 	int			idx)
 {
 	xfs_bmdr_block_t	*block;
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 	xfs_bmdr_ptr_t		*pp;
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -138,7 +138,7 @@ bmroota_size(
 	int			startoff,
 	int			idx)
 {
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 #ifdef DEBUG
 	xfs_bmdr_block_t	*block;
 #endif
@@ -161,7 +161,7 @@ bmrootd_key_count(
 {
 	xfs_bmdr_block_t	*block;
 #ifdef DEBUG
-	xfs_dinode_t		*dip = obj;
+	struct xfs_dinode		*dip = obj;
 #endif
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -196,7 +196,7 @@ bmrootd_ptr_count(
 {
 	xfs_bmdr_block_t	*block;
 #ifdef DEBUG
-	xfs_dinode_t		*dip = obj;
+	struct xfs_dinode		*dip = obj;
 #endif
 
 	ASSERT(bitoffs(startoff) == 0);
@@ -215,7 +215,7 @@ bmrootd_ptr_offset(
 {
 	xfs_bmdr_block_t	*block;
 	xfs_bmdr_ptr_t		*pp;
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -233,7 +233,7 @@ bmrootd_size(
 	int			startoff,
 	int			idx)
 {
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
diff --git a/db/check.c b/db/check.c
index 368f80c0..496a4da3 100644
--- a/db/check.c
+++ b/db/check.c
@@ -276,7 +276,7 @@ static void		process_bmbt_reclist(xfs_bmbt_rec_t *rp, int numrecs,
 					     dbm_t type, inodata_t *id,
 					     xfs_rfsblock_t *tot,
 					     blkmap_t **blkmapp);
-static void		process_btinode(inodata_t *id, xfs_dinode_t *dip,
+static void		process_btinode(inodata_t *id, struct xfs_dinode *dip,
 					dbm_t type, xfs_rfsblock_t *totd,
 					xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 					blkmap_t **blkmapp, int whichfork);
@@ -287,18 +287,18 @@ static xfs_ino_t	process_data_dir_v2(int *dot, int *dotdot,
 static xfs_dir2_data_free_t *process_data_dir_v2_freefind(
 					struct xfs_dir2_data_hdr *data,
 					struct xfs_dir2_data_unused *dup);
-static void		process_dir(xfs_dinode_t *dip, blkmap_t *blkmap,
+static void		process_dir(struct xfs_dinode *dip, blkmap_t *blkmap,
 				    inodata_t *id);
-static int		process_dir_v2(xfs_dinode_t *dip, blkmap_t *blkmap,
+static int		process_dir_v2(struct xfs_dinode *dip, blkmap_t *blkmap,
 				       int *dot, int *dotdot, inodata_t *id,
 				       xfs_ino_t *parent);
-static void		process_exinode(inodata_t *id, xfs_dinode_t *dip,
+static void		process_exinode(inodata_t *id, struct xfs_dinode *dip,
 					dbm_t type, xfs_rfsblock_t *totd,
 					xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 					blkmap_t **blkmapp, int whichfork);
 static void		process_inode(xfs_agf_t *agf, xfs_agino_t agino,
-				      xfs_dinode_t *dip, int isfree);
-static void		process_lclinode(inodata_t *id, xfs_dinode_t *dip,
+				      struct xfs_dinode *dip, int isfree);
+static void		process_lclinode(inodata_t *id, struct xfs_dinode *dip,
 					 dbm_t type, xfs_rfsblock_t *totd,
 					 xfs_rfsblock_t *toti, xfs_extnum_t *nex,
 					 blkmap_t **blkmapp, int whichfork);
@@ -315,7 +315,7 @@ static void		process_quota(qtype_t qtype, inodata_t *id,
 				      blkmap_t *blkmap);
 static void		process_rtbitmap(blkmap_t *blkmap);
 static void		process_rtsummary(blkmap_t *blkmap);
-static xfs_ino_t	process_sf_dir_v2(xfs_dinode_t *dip, int *dot,
+static xfs_ino_t	process_sf_dir_v2(struct xfs_dinode *dip, int *dot,
 					  int *dotdot, inodata_t *id);
 static void		quota_add(xfs_dqid_t *p, xfs_dqid_t *g, xfs_dqid_t *u,
 				  int dq, xfs_qcnt_t bc, xfs_qcnt_t ic,
@@ -2272,7 +2272,7 @@ process_bmbt_reclist(
 static void
 process_btinode(
 	inodata_t		*id,
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	dbm_t			type,
 	xfs_rfsblock_t		*totd,
 	xfs_rfsblock_t		*toti,
@@ -2626,7 +2626,7 @@ process_data_dir_v2_freefind(
 
 static void
 process_dir(
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	blkmap_t	*blkmap,
 	inodata_t	*id)
 {
@@ -2665,7 +2665,7 @@ process_dir(
 
 static int
 process_dir_v2(
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	blkmap_t	*blkmap,
 	int		*dot,
 	int		*dotdot,
@@ -2702,7 +2702,7 @@ process_dir_v2(
 static void
 process_exinode(
 	inodata_t		*id,
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	dbm_t			type,
 	xfs_rfsblock_t		*totd,
 	xfs_rfsblock_t		*toti,
@@ -2729,7 +2729,7 @@ static void
 process_inode(
 	xfs_agf_t		*agf,
 	xfs_agino_t		agino,
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	int			isfree)
 {
 	blkmap_t		*blkmap;
@@ -3038,7 +3038,7 @@ process_inode(
 static void
 process_lclinode(
 	inodata_t			*id,
-	xfs_dinode_t			*dip,
+	struct xfs_dinode			*dip,
 	dbm_t				type,
 	xfs_rfsblock_t			*totd,
 	xfs_rfsblock_t			*toti,
@@ -3697,7 +3697,7 @@ process_rtsummary(
 
 static xfs_ino_t
 process_sf_dir_v2(
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	int			*dot,
 	int			*dotdot,
 	inodata_t		*id)
@@ -4576,7 +4576,7 @@ scanfunc_ino(
 					isfree = XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j);
 					if (isfree)
 						nfree++;
-					dip = (xfs_dinode_t *)((char *)iocur_top->data +
+					dip = (struct xfs_dinode *)((char *)iocur_top->data +
 						((off + j) << mp->m_sb.sb_inodelog));
 					process_inode(agf, agino + ioff + j, dip, isfree);
 				}
diff --git a/db/field.c b/db/field.c
index 51268938..90d3609a 100644
--- a/db/field.c
+++ b/db/field.c
@@ -203,13 +203,13 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_DINODE_A, "dinode_a", NULL, (char *)inode_a_flds, inode_a_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_a_flds },
 	{ FLDT_DINODE_CORE, "dinode_core", NULL, (char *)inode_core_flds,
-	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_core_flds },
+	  SI(bitsz(struct xfs_dinode)), 0, NULL, inode_core_flds },
 	{ FLDT_DINODE_FMT, "dinode_fmt", fp_dinode_fmt, NULL,
 	  SI(bitsz(int8_t)), 0, NULL, NULL },
 	{ FLDT_DINODE_U, "dinode_u", NULL, (char *)inode_u_flds, inode_u_size,
 	  FTARG_SIZE|FTARG_OKEMPTY, NULL, inode_u_flds },
 	{ FLDT_DINODE_V3, "dinode_v3", NULL, (char *)inode_v3_flds,
-	  SI(bitsz(xfs_dinode_t)), 0, NULL, inode_v3_flds },
+	  SI(bitsz(struct xfs_dinode)), 0, NULL, inode_v3_flds },
 
 /* dir v2 fields */
 	{ FLDT_DIR2, "dir2", NULL, (char *)dir2_flds, dir2_size, FTARG_SIZE,
diff --git a/db/frag.c b/db/frag.c
index 9bc63614..ea81b349 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -56,13 +56,13 @@ static int		frag_f(int argc, char **argv);
 static int		init(int argc, char **argv);
 static void		process_bmbt_reclist(xfs_bmbt_rec_t *rp, int numrecs,
 					     extmap_t **extmapp);
-static void		process_btinode(xfs_dinode_t *dip, extmap_t **extmapp,
+static void		process_btinode(struct xfs_dinode *dip, extmap_t **extmapp,
 					int whichfork);
-static void		process_exinode(xfs_dinode_t *dip, extmap_t **extmapp,
+static void		process_exinode(struct xfs_dinode *dip, extmap_t **extmapp,
 					int whichfork);
-static void		process_fork(xfs_dinode_t *dip, int whichfork);
+static void		process_fork(struct xfs_dinode *dip, int whichfork);
 static void		process_inode(xfs_agf_t *agf, xfs_agino_t agino,
-				      xfs_dinode_t *dip);
+				      struct xfs_dinode *dip);
 static void		scan_ag(xfs_agnumber_t agno);
 static void		scan_lbtree(xfs_fsblock_t root, int nlevels,
 				    scan_lbtree_f_t func, extmap_t **extmapp,
@@ -233,7 +233,7 @@ process_bmbt_reclist(
 
 static void
 process_btinode(
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	extmap_t		**extmapp,
 	int			whichfork)
 {
@@ -257,7 +257,7 @@ process_btinode(
 
 static void
 process_exinode(
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	extmap_t		**extmapp,
 	int			whichfork)
 {
@@ -269,7 +269,7 @@ process_exinode(
 
 static void
 process_fork(
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		whichfork)
 {
 	extmap_t	*extmap;
@@ -296,7 +296,7 @@ static void
 process_inode(
 	xfs_agf_t		*agf,
 	xfs_agino_t		agino,
-	xfs_dinode_t		*dip)
+	struct xfs_dinode		*dip)
 {
 	uint64_t		actual;
 	uint64_t		ideal;
@@ -509,7 +509,7 @@ scanfunc_ino(
 				for (j = 0; j < inodes_per_buf; j++) {
 					if (XFS_INOBT_IS_FREE_DISK(&rp[i], ioff + j))
 						continue;
-					dip = (xfs_dinode_t *)((char *)iocur_top->data +
+					dip = (struct xfs_dinode *)((char *)iocur_top->data +
 						((off + j) << mp->m_sb.sb_inodelog));
 					process_inode(agf, agino + ioff + j, dip);
 				}
diff --git a/db/inode.c b/db/inode.c
index 22bc63a8..083888d8 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -52,7 +52,7 @@ const field_t	inode_crc_hfld[] = {
 };
 
 /* XXX: fix this up! */
-#define	OFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
+#define	OFF(f)	bitize(offsetof(struct xfs_dinode, di_ ## f))
 const field_t	inode_flds[] = {
 	{ "core", FLDT_DINODE_CORE, OI(OFF(magic)), C1, 0, TYP_NONE },
 	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
@@ -74,7 +74,7 @@ const field_t	inode_crc_flds[] = {
 };
 
 
-#define	COFF(f)	bitize(offsetof(xfs_dinode_t, di_ ## f))
+#define	COFF(f)	bitize(offsetof(struct xfs_dinode, di_ ## f))
 const field_t	inode_core_flds[] = {
 	{ "magic", FLDT_UINT16X, OI(COFF(magic)), C1, 0, TYP_NONE },
 	{ "mode", FLDT_UINT16O, OI(COFF(mode)), C1, 0, TYP_NONE },
@@ -250,7 +250,7 @@ inode_a_bmbt_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -266,7 +266,7 @@ inode_a_bmx_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -283,7 +283,7 @@ inode_a_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(startoff == 0);
 	dip = obj;
@@ -296,7 +296,7 @@ inode_a_offset(
 	int		startoff,
 	int		idx)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -310,7 +310,7 @@ inode_a_sfattr_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -328,7 +328,7 @@ inode_a_size(
 	int				idx)
 {
 	struct xfs_attr_shortform	*asf;
-	xfs_dinode_t			*dip;
+	struct xfs_dinode			*dip;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -352,7 +352,7 @@ inode_core_nlinkv1_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dic;
+	struct xfs_dinode	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
@@ -365,7 +365,7 @@ inode_core_nlinkv2_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dic;
+	struct xfs_dinode	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
@@ -378,7 +378,7 @@ inode_core_onlink_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dic;
+	struct xfs_dinode	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
@@ -391,7 +391,7 @@ inode_core_projid_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dic;
+	struct xfs_dinode	*dic;
 
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
@@ -466,7 +466,7 @@ inode_u_offset(
 	int		startoff,
 	int		idx)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -479,7 +479,7 @@ inode_u_bmbt_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -493,7 +493,7 @@ inode_u_bmx_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -508,7 +508,7 @@ inode_u_c_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -524,7 +524,7 @@ inode_u_dev_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -538,7 +538,7 @@ inode_u_muuid_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -552,7 +552,7 @@ inode_u_sfdir2_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -568,7 +568,7 @@ inode_u_sfdir3_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -585,7 +585,7 @@ inode_u_size(
 	int		startoff,
 	int		idx)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(startoff == 0);
 	ASSERT(idx == 0);
@@ -612,7 +612,7 @@ inode_u_symlink_count(
 	void		*obj,
 	int		startoff)
 {
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 
 	ASSERT(bitoffs(startoff) == 0);
 	ASSERT(obj == iocur_top->data);
@@ -638,7 +638,7 @@ set_cur_inode(
 	xfs_agblock_t	agbno;
 	xfs_agino_t	agino;
 	xfs_agnumber_t	agno;
-	xfs_dinode_t	*dip;
+	struct xfs_dinode	*dip;
 	int		offset;
 	int		numblks = blkbb;
 	xfs_agblock_t	cluster_agbno;
diff --git a/db/metadump.c b/db/metadump.c
index 48cda88a..057a3729 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -1234,7 +1234,7 @@ generate_obfuscated_name(
 
 static void
 process_sf_dir(
-	xfs_dinode_t		*dip)
+	struct xfs_dinode		*dip)
 {
 	struct xfs_dir2_sf_hdr	*sfp;
 	xfs_dir2_sf_entry_t	*sfep;
@@ -1339,7 +1339,7 @@ obfuscate_path_components(
 
 static void
 process_sf_symlink(
-	xfs_dinode_t		*dip)
+	struct xfs_dinode		*dip)
 {
 	uint64_t		len;
 	char			*buf;
@@ -1363,7 +1363,7 @@ process_sf_symlink(
 
 static void
 process_sf_attr(
-	xfs_dinode_t			*dip)
+	struct xfs_dinode			*dip)
 {
 	/*
 	 * with extended attributes, obfuscate the names and fill the actual
@@ -2193,7 +2193,7 @@ scanfunc_bmap(
 
 static int
 process_btinode(
-	xfs_dinode_t 		*dip,
+	struct xfs_dinode 		*dip,
 	typnm_t			itype)
 {
 	xfs_bmdr_block_t	*dib;
@@ -2273,7 +2273,7 @@ process_btinode(
 
 static int
 process_exinode(
-	xfs_dinode_t 		*dip,
+	struct xfs_dinode 		*dip,
 	typnm_t			itype)
 {
 	int			whichfork;
@@ -2303,7 +2303,7 @@ process_exinode(
 
 static int
 process_inode_data(
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	typnm_t			itype)
 {
 	switch (dip->di_format) {
@@ -2333,7 +2333,7 @@ process_inode_data(
 
 static int
 process_dev_inode(
-	xfs_dinode_t		*dip)
+	struct xfs_dinode		*dip)
 {
 	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
 		if (show_warnings)
@@ -2362,7 +2362,7 @@ static int
 process_inode(
 	xfs_agnumber_t		agno,
 	xfs_agino_t 		agino,
-	xfs_dinode_t 		*dip,
+	struct xfs_dinode 		*dip,
 	bool			free_inode)
 {
 	int			success;
@@ -2534,9 +2534,9 @@ copy_inode_chunk(
 		}
 
 		for (i = 0; i < inodes_per_buf; i++) {
-			xfs_dinode_t	*dip;
+			struct xfs_dinode	*dip;
 
-			dip = (xfs_dinode_t *)((char *)iocur_top->data +
+			dip = (struct xfs_dinode *)((char *)iocur_top->data +
 					((off + i) << mp->m_sb.sb_inodelog));
 
 			/* process_inode handles free inodes, too */
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index 9e01ccec..5c7dbccd 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -214,7 +214,7 @@ ffn(const char *path, const struct stat *stb, int flags, struct FTW *f)
 		nfiles++;
 		break;
 	case S_IFLNK:			/* symbolic links */
-		if (stb->st_size >= (INODESIZE - (sizeof(xfs_dinode_t)+4)))
+		if (stb->st_size >= (INODESIZE - (sizeof(struct xfs_dinode)+4)))
 			fullblocks+=FBLOCKS(stb->st_size + blocksize-1);
 		nslinks++;
 		break;
diff --git a/libxfs/util.c b/libxfs/util.c
index 69cc477c..9f1ca907 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -336,7 +336,7 @@ libxfs_iflush_int(
 	struct xfs_buf			*bp)
 {
 	struct xfs_inode_log_item	*iip;
-	xfs_dinode_t			*dip;
+	struct xfs_dinode			*dip;
 	xfs_mount_t			*mp;
 
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 2d7057b7..347c291c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -780,7 +780,7 @@ static inline time64_t xfs_bigtime_to_unix(uint64_t ondisk_seconds)
  * padding field for v3 inodes.
  */
 #define	XFS_DINODE_MAGIC		0x494e	/* 'IN' */
-typedef struct xfs_dinode {
+struct xfs_dinode {
 	__be16		di_magic;	/* inode magic # = XFS_DINODE_MAGIC */
 	__be16		di_mode;	/* mode and type of file */
 	__u8		di_version;	/* inode version */
@@ -825,7 +825,7 @@ typedef struct xfs_dinode {
 	uuid_t		di_uuid;	/* UUID of the filesystem */
 
 	/* structure must be padded to 64 bit alignment */
-} xfs_dinode_t;
+};
 
 #define XFS_DINODE_CRC_OFF	offsetof(struct xfs_dinode, di_crc)
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 68bd5f52..e22e49a4 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -48,9 +48,9 @@ xfs_inode_buf_verify(
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
 	ni = XFS_BB_TO_FSB(mp, bp->b_length) * mp->m_sb.sb_inopblock;
 	for (i = 0; i < ni; i++) {
-		int		di_ok;
-		xfs_dinode_t	*dip;
-		xfs_agino_t	unlinked_ino;
+		struct xfs_dinode	*dip;
+		xfs_agino_t		unlinked_ino;
+		int			di_ok;
 
 		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
 		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 1a49c41f..bd581fe8 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -65,10 +65,10 @@ xfs_init_local_fork(
  */
 STATIC int
 xfs_iformat_local(
-	xfs_inode_t	*ip,
-	xfs_dinode_t	*dip,
-	int		whichfork,
-	int		size)
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
+	int			whichfork,
+	int			size)
 {
 	/*
 	 * If the size is unreasonable, then something
@@ -160,8 +160,8 @@ xfs_iformat_extents(
  */
 STATIC int
 xfs_iformat_btree(
-	xfs_inode_t		*ip,
-	xfs_dinode_t		*dip,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
 	int			whichfork)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -578,8 +578,8 @@ xfs_iextents_copy(
  */
 void
 xfs_iflush_fork(
-	xfs_inode_t		*ip,
-	xfs_dinode_t		*dip,
+	struct xfs_inode	*ip,
+	struct xfs_dinode	*dip,
 	struct xfs_inode_log_item *iip,
 	int			whichfork)
 {
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 927dd095..50c46619 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -207,7 +207,7 @@ static int
 process_shortform_attr(
 	struct xfs_mount		*mp,
 	xfs_ino_t			ino,
-	xfs_dinode_t			*dip,
+	struct xfs_dinode			*dip,
 	int				*repair)
 {
 	struct xfs_attr_shortform	*asf;
@@ -881,7 +881,7 @@ static int
 process_node_attr(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	blkmap_t	*blkmap)
 {
 	xfs_dablk_t			bno;
@@ -1205,7 +1205,7 @@ int
 process_attributes(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	blkmap_t	*blkmap,
 	int		*repair)  /* returned if we did repair */
 {
diff --git a/repair/attr_repair.h b/repair/attr_repair.h
index 2771d7eb..dc53d8a6 100644
--- a/repair/attr_repair.h
+++ b/repair/attr_repair.h
@@ -97,7 +97,7 @@ typedef struct xfs_cap_set {
  * External functions
  */
 struct blkmap;
-extern int process_attributes (xfs_mount_t *, xfs_ino_t, xfs_dinode_t *,
+extern int process_attributes (xfs_mount_t *, xfs_ino_t, struct xfs_dinode *,
 				struct blkmap *, int *);
 
 #endif /* _XR_ATTRREPAIR_H */
diff --git a/repair/da_util.h b/repair/da_util.h
index 2e26178c..587ba68b 100644
--- a/repair/da_util.h
+++ b/repair/da_util.h
@@ -19,7 +19,7 @@ typedef struct da_bt_cursor {
 	int			active;	/* highest level in tree (# levels-1) */
 	xfs_ino_t		ino;
 	xfs_dablk_t		greatest_bno;
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 	struct da_level_state	level[XFS_DA_NODE_MAXDEPTH];
 	struct blkmap		*blkmap;
 } da_bt_cursor_t;
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 51cd06f0..67f86c7a 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -27,7 +27,7 @@ check_aginode_block(xfs_mount_t	*mp,
 			xfs_agblock_t	agbno)
 {
 
-	xfs_dinode_t	*dino_p;
+	struct xfs_dinode	*dino_p;
 	int		i;
 	int		cnt = 0;
 	struct xfs_buf	*bp;
@@ -598,7 +598,7 @@ process_inode_chunk(
 	xfs_ino_t		parent;
 	ino_tree_node_t		*ino_rec;
 	struct xfs_buf		**bplist;
-	xfs_dinode_t		*dino;
+	struct xfs_dinode		*dino;
 	int			icnt;
 	int			status;
 	int			bp_found;
diff --git a/repair/dinode.c b/repair/dinode.c
index 4da39dcc..a9ab3d99 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -57,7 +57,7 @@ get_forkname(int whichfork)
  */
 
 static int
-clear_dinode_attr(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
+clear_dinode_attr(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
 {
 	ASSERT(dino->di_forkoff != 0);
 
@@ -106,7 +106,7 @@ _("would have cleared inode %" PRIu64 " attributes\n"), ino_num);
 }
 
 static void
-clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
+clear_dinode_core(struct xfs_mount *mp, struct xfs_dinode *dinoc, xfs_ino_t ino_num)
 {
 	memset(dinoc, 0, sizeof(*dinoc));
 	dinoc->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
@@ -126,7 +126,7 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
 }
 
 static void
-clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
+clear_dinode_unlinked(xfs_mount_t *mp, struct xfs_dinode *dino)
 {
 
 	dino->di_next_unlinked = cpu_to_be32(NULLAGINO);
@@ -137,7 +137,7 @@ clear_dinode_unlinked(xfs_mount_t *mp, xfs_dinode_t *dino)
  * until after the agi unlinked lists are walked in phase 3.
  */
 static void
-clear_dinode(xfs_mount_t *mp, xfs_dinode_t *dino, xfs_ino_t ino_num)
+clear_dinode(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
 {
 	clear_dinode_core(mp, dino, ino_num);
 	clear_dinode_unlinked(mp, dino);
@@ -744,7 +744,7 @@ process_btinode(
 	xfs_mount_t		*mp,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
@@ -919,7 +919,7 @@ process_exinode(
 	xfs_mount_t		*mp,
 	xfs_agnumber_t		agno,
 	xfs_agino_t		ino,
-	xfs_dinode_t		*dip,
+	struct xfs_dinode		*dip,
 	int			type,
 	int			*dirty,
 	xfs_rfsblock_t		*tot,
@@ -974,7 +974,7 @@ process_lclinode(
 	xfs_mount_t			*mp,
 	xfs_agnumber_t			agno,
 	xfs_agino_t			ino,
-	xfs_dinode_t			*dip,
+	struct xfs_dinode			*dip,
 	int				whichfork)
 {
 	struct xfs_attr_shortform	*asf;
@@ -1010,7 +1010,7 @@ process_lclinode(
 }
 
 static int
-process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, xfs_dinode_t *dino)
+process_symlink_extlist(xfs_mount_t *mp, xfs_ino_t lino, struct xfs_dinode *dino)
 {
 	xfs_fileoff_t		expected_offset;
 	xfs_bmbt_rec_t		*rp;
@@ -1324,7 +1324,7 @@ static int
 process_symlink(
 	xfs_mount_t	*mp,
 	xfs_ino_t	lino,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	blkmap_t 	*blkmap)
 {
 	char			*symlink;
@@ -1388,7 +1388,7 @@ _("found illegal null character in symlink inode %" PRIu64 "\n"),
  */
 static int
 process_misc_ino_types(xfs_mount_t	*mp,
-			xfs_dinode_t	*dino,
+			struct xfs_dinode	*dino,
 			xfs_ino_t	lino,
 			int		type)
 {
@@ -1480,14 +1480,14 @@ _("size of fifo inode %" PRIu64 " != 0 (%" PRIu64 " blocks)\n"),
 
 static inline int
 dinode_fmt(
-	xfs_dinode_t *dino)
+	struct xfs_dinode *dino)
 {
 	return be16_to_cpu(dino->di_mode) & S_IFMT;
 }
 
 static inline void
 change_dinode_fmt(
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	int		new_fmt)
 {
 	int		mode = be16_to_cpu(dino->di_mode);
@@ -1501,7 +1501,7 @@ change_dinode_fmt(
 
 static int
 check_dinode_mode_format(
-	xfs_dinode_t *dinoc)
+	struct xfs_dinode *dinoc)
 {
 	if (dinoc->di_format >= XFS_DINODE_FMT_UUID)
 		return -1;	/* FMT_UUID is not used */
@@ -1538,7 +1538,7 @@ check_dinode_mode_format(
 static int
 process_check_sb_inodes(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dinoc,
+	struct xfs_dinode	*dinoc,
 	xfs_ino_t	lino,
 	int		*type,
 	int		*dirty)
@@ -1643,7 +1643,7 @@ _("bad # of extents (%u) for realtime bitmap inode %" PRIu64 "\n"),
 static int
 process_check_inode_sizes(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_ino_t	lino,
 	int		type)
 {
@@ -1735,7 +1735,7 @@ _("realtime summary inode %" PRIu64 " has bad size %" PRId64 " (should be %d)\n"
 static int
 process_check_inode_forkoff(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_ino_t	lino)
 {
 	if (dino->di_forkoff == 0)
@@ -1773,7 +1773,7 @@ _("bad attr fork offset %d in inode %" PRIu64 ", max=%zu\n"),
  */
 static int
 process_inode_blocks_and_extents(
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_rfsblock_t	nblocks,
 	uint64_t	nextents,
 	uint64_t	anextents,
@@ -1862,7 +1862,7 @@ process_inode_data_fork(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	int		type,
 	int		*dirty,
 	xfs_rfsblock_t	*totblocks,
@@ -1971,7 +1971,7 @@ process_inode_attr_fork(
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	int		type,
 	int		*dirty,
 	xfs_rfsblock_t	*atotblocks,
@@ -2125,7 +2125,7 @@ process_inode_attr_fork(
 
 static int
 process_check_inode_nlink_version(
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_ino_t	lino)
 {
 	int		dirty = 0;
@@ -2240,7 +2240,7 @@ _("Bad extent size hint %u on inode %" PRIu64 ", "),
  */
 static int
 process_dinode_int(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
+		struct xfs_dinode *dino,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino,
 		int was_free,		/* 1 if inode is currently free */
@@ -2922,7 +2922,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 int
 process_dinode(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino,
 	int		was_free,
@@ -2954,7 +2954,7 @@ process_dinode(
 int
 verify_dinode(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino)
 {
@@ -2980,7 +2980,7 @@ verify_dinode(
 int
 verify_uncertain_dinode(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dino,
+	struct xfs_dinode	*dino,
 	xfs_agnumber_t	agno,
 	xfs_agino_t	ino)
 {
diff --git a/repair/dinode.h b/repair/dinode.h
index 1bd0e0b7..4ed8b46f 100644
--- a/repair/dinode.h
+++ b/repair/dinode.h
@@ -44,7 +44,7 @@ update_rootino(xfs_mount_t *mp);
 
 int
 process_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
+		struct xfs_dinode *dino,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino,
 		int was_free,
@@ -58,13 +58,13 @@ process_dinode(xfs_mount_t *mp,
 
 int
 verify_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
+		struct xfs_dinode *dino,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino);
 
 int
 verify_uncertain_dinode(xfs_mount_t *mp,
-		xfs_dinode_t *dino,
+		struct xfs_dinode *dino,
 		xfs_agnumber_t agno,
 		xfs_agino_t ino);
 
diff --git a/repair/dir2.c b/repair/dir2.c
index 946e729e..0b3e8e1b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -118,7 +118,7 @@ process_sf_dir2_fixi8(
 static void
 process_sf_dir2_fixoff(
 	xfs_mount_t	*mp,
-	xfs_dinode_t	*dip)
+	struct xfs_dinode	*dip)
 {
 	int			i;
 	int			offset;
@@ -147,7 +147,7 @@ static int
 process_sf_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	int		*dino_dirty,	/* out - 1 if dinode buffer dirty */
 	char		*dirname,	/* directory pathname */
@@ -566,7 +566,7 @@ static int
 process_dir2_data(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	char		*dirname,	/* directory pathname */
 	xfs_ino_t	*parent,	/* out - NULLFSINO if entry not exist */
@@ -962,7 +962,7 @@ static int
 process_block_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	int		*dino_dirty,	/* out - 1 if dinode buffer dirty */
 	char		*dirname,	/* directory pathname */
@@ -1249,7 +1249,7 @@ static int
 process_node_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	blkmap_t	*blkmap,
 	int		*repair)
 {
@@ -1309,7 +1309,7 @@ static int
 process_leaf_node_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	char		*dirname,	/* directory pathname */
 	xfs_ino_t	*parent,	/* out - NULLFSINO if entry not exist */
@@ -1407,7 +1407,7 @@ int
 process_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	int		*dino_dirty,
 	char		*dirname,
diff --git a/repair/dir2.h b/repair/dir2.h
index af4cfb1d..f3b24cc0 100644
--- a/repair/dir2.h
+++ b/repair/dir2.h
@@ -14,7 +14,7 @@ int
 process_dir2(
 	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
-	xfs_dinode_t	*dip,
+	struct xfs_dinode	*dip,
 	int		ino_discovery,
 	int		*dirty,
 	char		*dirname,
diff --git a/repair/incore.h b/repair/incore.h
index 65c03dde..c5365899 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -630,7 +630,7 @@ typedef struct bm_level_state  {
 typedef struct bm_cursor  {
 	int			num_levels;
 	xfs_ino_t		ino;
-	xfs_dinode_t		*dip;
+	struct xfs_dinode		*dip;
 	bm_level_state_t	level[XR_MAX_BMLEVELS];
 } bmap_cursor_t;
 
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 83af5bc7..a1c69612 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -350,7 +350,7 @@ pf_scanfunc_bmap(
 static void
 pf_read_btinode(
 	prefetch_args_t		*args,
-	xfs_dinode_t		*dino,
+	struct xfs_dinode		*dino,
 	int			isadir)
 {
 	xfs_bmdr_block_t	*dib;
@@ -390,7 +390,7 @@ pf_read_btinode(
 static void
 pf_read_exinode(
 	prefetch_args_t		*args,
-	xfs_dinode_t		*dino)
+	struct xfs_dinode		*dino)
 {
 	pf_read_bmbt_reclist(args, (xfs_bmbt_rec_t *)XFS_DFORK_DPTR(dino),
 			be32_to_cpu(dino->di_nextents));
@@ -401,7 +401,7 @@ pf_read_inode_dirs(
 	prefetch_args_t		*args,
 	struct xfs_buf		*bp)
 {
-	xfs_dinode_t		*dino;
+	struct xfs_dinode		*dino;
 	int			icnt = 0;
 	int			hasdir = 0;
 	int			isadir;
diff --git a/repair/rt.c b/repair/rt.c
index 793efb80..73f88316 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -154,7 +154,7 @@ check_summary(xfs_mount_t *mp)
  */
 void
 process_rtbitmap(xfs_mount_t	*mp,
-		xfs_dinode_t	*dino,
+		struct xfs_dinode	*dino,
 		blkmap_t	*blkmap)
 {
 	int		error;
@@ -239,7 +239,7 @@ process_rtbitmap(xfs_mount_t	*mp,
  */
 void
 process_rtsummary(xfs_mount_t	*mp,
-		xfs_dinode_t	*dino,
+		struct xfs_dinode	*dino,
 		blkmap_t	*blkmap)
 {
 	xfs_fsblock_t	bno;
diff --git a/repair/rt.h b/repair/rt.h
index 4558d1a2..f6cd55d2 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -21,7 +21,7 @@ check_summary(xfs_mount_t	*mp);
 
 void
 process_rtbitmap(xfs_mount_t	*mp,
-		xfs_dinode_t	*dino,
+		struct xfs_dinode	*dino,
 		struct blkmap	*blkmap);
 
 void

