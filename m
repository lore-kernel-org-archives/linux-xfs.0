Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE0AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiLaClu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiLaClr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:41:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0EB2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:41:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71AB6B81E11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CFCC433EF;
        Sat, 31 Dec 2022 02:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454503;
        bh=wWGAc8PwwMhT0LFXrLAVfjSYl0MYX/JYt2sKeU7bLTU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jl+gAYIfGOQ0EaB3HsXvJ/sE64kSm6bSJoo0xOXtiNAdnozCU/ELUGM+9FIv4fdJ7
         dqbyJNMLGq9teNYuMbnUIsva7kINufoO+L70FJ7czql1VxSB558gSo3MiPFR6dHLW8
         z7dFOKdV/ReNmMybwInUIBvw1HXFIWWEPq4yDi4lFK+eV5bvyO/vXsipJBSeW/OtH3
         Cjvx6z2OWltDBqEz+HT59uA9fOy/N67KR78NnQm+hcfs+Ah/R+xFp7zDtbcOr3+XUk
         htBCqW0UnmeqSKhrJpW8sZI2JahPxQfR3rWuJPpb501AoBT+t1fbG+Sr26udtOC0Tn
         cIoRNW8hYWsRw==
Subject: [PATCH 45/45] mkfs: format realtime groups
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:49 -0800
Message-ID: <167243878952.731133.10167956328943868756.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create filesystems with the realtime group feature enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/div64.h          |    6 +
 libfrog/util.c           |   12 ++
 libfrog/util.h           |    1 
 libxfs/libxfs_api_defs.h |    1 
 libxfs/libxfs_priv.h     |    6 -
 libxfs/topology.c        |   42 +++++++
 libxfs/topology.h        |    3 +
 libxfs/xfs_format.h      |    1 
 man/man8/mkfs.xfs.8.in   |   44 +++++++
 mkfs/proto.c             |   45 +++++++-
 mkfs/xfs_mkfs.c          |  272 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 425 insertions(+), 8 deletions(-)


diff --git a/libfrog/div64.h b/libfrog/div64.h
index 9317b28aad4..0ce8b747938 100644
--- a/libfrog/div64.h
+++ b/libfrog/div64.h
@@ -80,4 +80,10 @@ roundup_64(uint64_t x, uint32_t y)
 	return x * y;
 }
 
+static inline __attribute__((const))
+int is_power_of_2(unsigned long n)
+{
+	return (n != 0 && ((n & (n - 1)) == 0));
+}
+
 #endif /* LIBFROG_DIV64_H_ */
diff --git a/libfrog/util.c b/libfrog/util.c
index 46047571a55..4e130c884c1 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -36,3 +36,15 @@ memchr_inv(const void *start, int c, size_t bytes)
 
 	return NULL;
 }
+
+unsigned int
+log2_rounddown(unsigned long long i)
+{
+	int	rval;
+
+	for (rval = NBBY * sizeof(i) - 1; rval >= 0; rval--) {
+		if ((1ULL << rval) < i)
+			break;
+	}
+	return rval;
+}
diff --git a/libfrog/util.h b/libfrog/util.h
index ac2f331c93e..b0715576e8d 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -7,6 +7,7 @@
 #define __LIBFROG_UTIL_H__
 
 unsigned int	log2_roundup(unsigned int i);
+unsigned int	log2_rounddown(unsigned long long i);
 
 void *memchr_inv(const void *start, int c, size_t bytes);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index deadfe2c422..715df25f18b 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -73,6 +73,7 @@
 #define xfs_btree_update		libxfs_btree_update
 #define xfs_btree_space_to_height	libxfs_btree_space_to_height
 #define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
+#define xfs_buf_delwri_queue		libxfs_buf_delwri_queue
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 57b92ac1b99..66b9409a0b0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -334,12 +334,6 @@ find_next_zero_bit(const unsigned long *addr, unsigned long size,
 }
 #define find_first_zero_bit(addr, size) find_next_zero_bit((addr), (size), 0)
 
-static inline __attribute__((const))
-int is_power_of_2(unsigned long n)
-{
-	return (n != 0 && ((n & (n - 1)) == 0));
-}
-
 /*
  * xfs_iroundup: round up argument to next power of two
  */
diff --git a/libxfs/topology.c b/libxfs/topology.c
index a17c19691a4..75c6164887f 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -89,6 +89,48 @@ calc_default_ag_geometry(
 	*agcount = dblocks / blocks + (dblocks % blocks != 0);
 }
 
+void
+calc_default_rtgroup_geometry(
+	int		blocklog,
+	uint64_t	rblocks,
+	uint64_t	*rgsize,
+	uint64_t	*rgcount)
+{
+	uint64_t	blocks = 0;
+	int		shift = 0;
+
+	/*
+	 * For a single underlying storage device over 4TB in size use the
+	 * maximum rtgroup size.  Between 128MB and 4TB, just use 4 rtgroups
+	 * and scale up smoothly between min/max rtgroup sizes.
+	 */
+	if (rblocks >= TERABYTES(4, blocklog)) {
+		blocks = XFS_MAX_RGBLOCKS;
+		goto done;
+	}
+	if (rblocks >= MEGABYTES(128, blocklog)) {
+		shift = XFS_NOMULTIDISK_AGLOG;
+		goto calc_blocks;
+	}
+
+	/*
+	 * If rblocks is not evenly divisible by the number of desired rt
+	 * groups, round "blocks" up so we don't lose the last bit of the
+	 * filesystem. The same principle applies to the rt group count, so we
+	 * don't lose the last rt group!
+	 */
+calc_blocks:
+	ASSERT(shift >= 0 && shift <= XFS_MULTIDISK_AGLOG);
+	blocks = rblocks >> shift;
+	if (rblocks & xfs_mask32lo(shift)) {
+		if (blocks < XFS_MAX_RGBLOCKS)
+		    blocks++;
+	}
+done:
+	*rgsize = blocks;
+	*rgcount = rblocks / blocks + (rblocks % blocks != 0);
+}
+
 /*
  * Check for existing filesystem or partition table on device.
  * Returns:
diff --git a/libxfs/topology.h b/libxfs/topology.h
index 1a0fe24c09d..81843cbb803 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -32,6 +32,9 @@ calc_default_ag_geometry(
 	uint64_t	*agsize,
 	uint64_t	*agcount);
 
+void calc_default_rtgroup_geometry(int blocklog, uint64_t rblocks,
+		uint64_t *rgsize, uint64_t *rgcount);
+
 extern int
 check_overwrite(
 	const char	*device);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7e76bedda68..e4f3b2c5c05 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -416,6 +416,7 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
+		 XFS_SB_FEAT_INCOMPAT_RTGROUPS | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 8cdfe9a7ff1..1735caecca7 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1083,6 +1083,50 @@ or logical volume containing the section.
 .BI noalign
 This option disables stripe size detection, enforcing a realtime device with no
 stripe geometry.
+.TP
+.BI rtgroups= value
+This feature breaks the realtime section into multiple allocation groups for
+improved scalability.
+This feature is only available if the metadata directory tree feature is
+enabled.
+.IP
+By default,
+.B mkfs.xfs
+will not enable this feature.
+If the option
+.B \-r rtgroups=0
+is used, the rt group feature is not supported and is disabled.
+.TP
+.BI rgcount=
+This is used to specify the number of allocation groups in the realtime
+section.
+The realtime section of the filesystem can be divided into allocation groups to
+improve the performance of XFS.
+More allocation groups imply that more parallelism can be achieved when
+allocating blocks.
+The minimum allocation group size is 2 realtime extents; the maximum size is
+2^31 blocks.
+The rt section of the filesystem is divided into
+.I value
+allocation groups (default value is scaled automatically based
+on the underlying device size).
+.TP
+.BI rgsize= value
+This is an alternative to using the
+.B rgcount
+suboption. The
+.I value
+is the desired size of the realtime allocation group expressed in bytes
+(usually using the
+.BR m " or " g
+suffixes).
+This value must be a multiple of the realtime extent size,
+must be at least two realtime extents, and no more than 2^31 blocks.
+The
+.B rgcount
+and
+.B rgsize
+suboptions are mutually exclusive.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 846b48ec789..e734269864e 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -963,6 +963,46 @@ rtsummary_init(
 	}
 }
 
+static void
+rtfreesp_init_groups(
+	struct xfs_mount	*mp)
+{
+	xfs_rgnumber_t		rgno;
+	int			error;
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		struct xfs_trans	*tp;
+		xfs_rtblock_t	rtbno;
+		xfs_rtxnum_t	start_rtx;
+		xfs_rtxnum_t	next_rtx;
+
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, mp->m_sb.sb_rextsize);
+		start_rtx = xfs_rtb_to_rtxt(mp, rtbno);
+
+		rtbno = xfs_rgbno_to_rtb(mp, rgno + 1, 0);
+		next_rtx = xfs_rtb_to_rtxt(mp, rtbno);
+		next_rtx = min(next_rtx, mp->m_sb.sb_rextents);
+
+		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+				0, 0, 0, &tp);
+		if (error)
+			res_failed(error);
+
+		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
+		error = -libxfs_rtfree_extent(tp, start_rtx,
+				next_rtx - start_rtx);
+		if (error) {
+			fail(_("Error initializing the realtime space"),
+				error);
+		}
+		error = -libxfs_trans_commit(tp);
+		if (error)
+			fail(_("Initialization of the realtime space failed"),
+					error);
+
+	}
+}
+
 /*
  * Free the whole realtime area using transactions.
  * Do one transaction per bitmap block.
@@ -1011,7 +1051,10 @@ rtinit(
 
 	rtbitmap_init(mp);
 	rtsummary_init(mp);
-	rtfreesp_init(mp);
+	if (xfs_has_rtgroups(mp))
+		rtfreesp_init_groups(mp);
+	else
+		rtfreesp_init(mp);
 }
 
 static long
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 826f9e53309..4f96e436d32 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -123,6 +123,9 @@ enum {
 	R_FILE,
 	R_NAME,
 	R_NOALIGN,
+	R_RTGROUPS,
+	R_RGCOUNT,
+	R_RGSIZE,
 	R_MAX_OPTS,
 };
 
@@ -679,6 +682,9 @@ static struct opt_params ropts = {
 		[R_FILE] = "file",
 		[R_NAME] = "name",
 		[R_NOALIGN] = "noalign",
+		[R_RTGROUPS] = "rtgroups",
+		[R_RGCOUNT] = "rgcount",
+		[R_RGSIZE] = "rgsize",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -718,6 +724,27 @@ static struct opt_params ropts = {
 		  .defaultval = 1,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		},
+		{ .index = R_RTGROUPS,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
+		{ .index = R_RGCOUNT,
+		  .conflicts = { { &dopts, R_RGSIZE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 1,
+		  .maxval = XFS_MAX_RGNUMBER,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+		{ .index = R_RGSIZE,
+		  .conflicts = { { &dopts, R_RGCOUNT },
+				 { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = (unsigned long long)XFS_MAX_RGBLOCKS << XFS_MAX_BLOCKSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -882,6 +909,7 @@ struct cli_params {
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
+	char	*rgsize;
 	char	*dsu;
 	char	*dirblocksize;
 	char	*logsize;
@@ -902,6 +930,7 @@ struct cli_params {
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
+	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
 	int	imaxpct;
@@ -958,6 +987,9 @@ struct mkfs_params {
 	uint64_t	agsize;
 	uint64_t	agcount;
 
+	uint64_t	rgsize;
+	uint64_t	rgcount;
+
 	int		imaxpct;
 
 	bool		loginternal;
@@ -1014,7 +1046,8 @@ usage( void )
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
-/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rtgroups=0|1,\n\
+			    rgcount=n,rgsize=n]\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -1884,6 +1917,15 @@ rtdev_opts_parser(
 	case R_NOALIGN:
 		cli->sb_feat.nortalign = getnum(value, opts, subopt);
 		break;
+	case R_RTGROUPS:
+		cli->sb_feat.rtgroups = getnum(value, opts, subopt);
+		break;
+	case R_RGCOUNT:
+		cli->rgcount = getnum(value, opts, subopt);
+		break;
+	case R_RGSIZE:
+		cli->rgsize = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2365,6 +2407,15 @@ _("cowextsize not supported without reflink support\n"));
 		usage();
 	}
 
+	if (cli->sb_feat.rtgroups && !cli->sb_feat.metadir) {
+		if (cli_opt_set(&mopts, M_METADIR)) {
+			fprintf(stderr,
+_("realtime groups not supported without metadata directory support\n"));
+			usage();
+		}
+		cli->sb_feat.metadir = true;
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
@@ -3362,6 +3413,181 @@ an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
 			     cfg->agsize, cfg->agcount);
 }
 
+static uint64_t
+calc_rgsize_extsize_nonpower(
+	struct mkfs_params	*cfg)
+{
+	uint64_t		try_rgsize, rgsize, rgcount;
+
+	/*
+	 * For non-power-of-two rt extent sizes, round the rtgroup size down to
+	 * the nearest extent.
+	 */
+	calc_default_rtgroup_geometry(cfg->blocklog, cfg->rtblocks, &rgsize,
+			&rgcount);
+	rgsize -= rgsize % cfg->rtextblocks;
+	rgsize = min(XFS_MAX_RGBLOCKS, rgsize);
+
+	/*
+	 * If we would be left with a too-small rtgroup, increase or decrease
+	 * the size of the group until we have a working geometry.
+	 */
+	for (try_rgsize = rgsize;
+	     try_rgsize <= XFS_MAX_RGBLOCKS - cfg->rtextblocks;
+	     try_rgsize += cfg->rtextblocks) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+	for (try_rgsize = rgsize;
+	     try_rgsize > (2 * cfg->rtextblocks);
+	     try_rgsize -= cfg->rtextblocks) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+
+	fprintf(stderr,
+_("realtime group size (%llu) not at all congruent with extent size (%llu)\n"),
+			(unsigned long long)rgsize,
+			(unsigned long long)cfg->rtextblocks);
+	usage();
+	return 0;
+}
+
+static uint64_t
+calc_rgsize_extsize_power(
+	struct mkfs_params	*cfg)
+{
+	uint64_t		try_rgsize, rgsize, rgcount;
+	unsigned int		rgsizelog;
+
+	/*
+	 * Find the rt group size that is both a power of two and yields at
+	 * least as many rt groups as the default geometry specified.
+	 */
+	calc_default_rtgroup_geometry(cfg->blocklog, cfg->rtblocks, &rgsize,
+			&rgcount);
+	rgsizelog = log2_rounddown(rgsize);
+	rgsize = min(XFS_MAX_RGBLOCKS, 1U << rgsizelog);
+
+	/*
+	 * If we would be left with a too-small rtgroup, increase or decrease
+	 * the size of the group by powers of 2 until we have a working
+	 * geometry.  If that doesn't work, try bumping by the extent size.
+	 */
+	for (try_rgsize = rgsize;
+	     try_rgsize <= XFS_MAX_RGBLOCKS - cfg->rtextblocks;
+	     try_rgsize <<= 2) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+	for (try_rgsize = rgsize;
+	     try_rgsize > (2 * cfg->rtextblocks);
+	     try_rgsize >>= 2) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+	for (try_rgsize = rgsize;
+	     try_rgsize <= XFS_MAX_RGBLOCKS - cfg->rtextblocks;
+	     try_rgsize += cfg->rtextblocks) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+	for (try_rgsize = rgsize;
+	     try_rgsize > (2 * cfg->rtextblocks);
+	     try_rgsize -= cfg->rtextblocks) {
+		if (cfg->rtblocks % try_rgsize >= (2 * cfg->rtextblocks))
+			return try_rgsize;
+	}
+
+	fprintf(stderr,
+_("realtime group size (%llu) not at all congruent with extent size (%llu)\n"),
+			(unsigned long long)rgsize,
+			(unsigned long long)cfg->rtextblocks);
+	usage();
+	return 0;
+}
+
+static void
+calculate_rtgroup_geometry(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli)
+{
+	if (!cli->sb_feat.rtgroups) {
+		cfg->rgcount = 0;
+		cfg->rgsize = 0;
+		return;
+	}
+
+	if (cli->rgsize) {	/* User-specified rtgroup size */
+		cfg->rgsize = getnum(cli->rgsize, &ropts, R_RGSIZE);
+
+		/*
+		 * Check specified agsize is a multiple of blocksize.
+		 */
+		if (cfg->rgsize % cfg->blocksize) {
+			fprintf(stderr,
+_("rgsize (%s) not a multiple of fs blk size (%d)\n"),
+				cli->rgsize, cfg->blocksize);
+			usage();
+		}
+		cfg->rgsize /= cfg->blocksize;
+		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+				(cfg->rtblocks % cfg->rgsize != 0);
+
+	} else if (cli->rgcount) {	/* User-specified rtgroup count */
+		cfg->rgcount = cli->rgcount;
+		cfg->rgsize = cfg->rtblocks / cfg->rgcount +
+				(cfg->rtblocks % cfg->rgcount != 0);
+	} else if (cfg->rtblocks == 0) {
+		/*
+		 * If nobody specified a realtime device or the rtgroup size,
+		 * try 1TB, rounded down to the nearest rt extent.
+		 */
+		cfg->rgsize = TERABYTES(1, cfg->blocklog);
+		cfg->rgsize -= cfg->rgsize % cfg->rtextblocks;
+		cfg->rgcount = 0;
+	} else if (!is_power_of_2(cfg->rtextblocks)) {
+		cfg->rgsize = calc_rgsize_extsize_nonpower(cfg);
+		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+				(cfg->rtblocks % cfg->rgsize != 0);
+	} else {
+		cfg->rgsize = calc_rgsize_extsize_power(cfg);
+		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+				(cfg->rtblocks % cfg->rgsize != 0);
+	}
+
+	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgsize,
+				XFS_MAX_RGBLOCKS);
+		usage();
+	}
+
+	if (cfg->rgsize % cfg->rtextblocks != 0) {
+		fprintf(stderr,
+_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
+				(unsigned long long)cfg->rgsize,
+				(unsigned long long)cfg->rtextblocks);
+		usage();
+	}
+
+	if (cfg->rgsize <= cfg->rtextblocks) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be at least two realtime extents\n"),
+				(unsigned long long)cfg->rgsize);
+		usage();
+	}
+
+	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
+		fprintf(stderr,
+_("realtime group count (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgcount,
+				XFS_MAX_RGNUMBER);
+		usage();
+	}
+}
+
 static void
 calculate_imaxpct(
 	struct mkfs_params	*cfg,
@@ -3499,6 +3725,12 @@ sb_set_features(
 
 	if (fp->nrext64)
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NREXT64;
+
+	if (fp->rtgroups) {
+		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_RTGROUPS;
+		sbp->sb_rgcount = cfg->rgcount;
+		sbp->sb_rgblocks = cfg->rgsize;
+	}
 }
 
 /*
@@ -4274,6 +4506,7 @@ main(
 	char			**argv)
 {
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	struct xfs_buf		*buf;
 	int			c;
 	char			*dfile = NULL;
@@ -4494,6 +4727,7 @@ main(
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
+	calculate_rtgroup_geometry(&cfg, &cli);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -4587,6 +4821,42 @@ main(
 		exit(1);
 	}
 
+	/* Write all the realtime group superblocks. */
+	for (rgno = 0; rgno < cfg.rgcount; rgno++) {
+		struct xfs_buf	*rtsb_bp;
+		struct xfs_buf	*sb_bp = libxfs_getsb(mp);
+
+		if (!sb_bp) {
+			fprintf(stderr,
+ _("%s: couldn't grab buffers to write primary rt superblock\n"), progname);
+			exit(1);
+		}
+
+		error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
+				XFS_FSB_TO_BB(mp, 1), 0,
+				&rtsb_bp);
+		if (error) {
+			fprintf(stderr,
+ _("%s: couldn't grab primary rt superblock\n"), progname);
+			exit(1);
+		}
+		rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+		rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+		libxfs_rtgroup_update_super(rtsb_bp, sb_bp);
+		libxfs_buf_mark_dirty(rtsb_bp);
+		libxfs_buf_relse(rtsb_bp);
+		libxfs_buf_relse(sb_bp);
+
+		error = -libxfs_rtgroup_update_secondary_sbs(mp);
+		if (error) {
+			fprintf(stderr,
+	_("%s: writing secondary rtgroup headers failed, err=%d\n"),
+					progname, error);
+			exit(1);
+		}
+	}
+
 	/*
 	 * Initialise the freespace freelists (i.e. AGFLs) in each AG.
 	 */

