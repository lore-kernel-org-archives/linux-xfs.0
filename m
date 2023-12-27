Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40647CA46
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caxrHq+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72A7C433C8;
	Mon,  1 Jan 2024 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067267;
	bh=hYSIER6PCHmgirewCjVy3hFpVv3181aWiOckiLZ5yOA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=caxrHq+prgfhYglT+J8b3taEWXNP664+8EN8AsbI4ulhO982OuEY3MKfZ+0arzcOS
	 rgRrXsNBkE578J11FgqxZPVv6hNcer0uabJ8NTemKU0hdcjnEnBP4oKVPlhxJVfQZC
	 Y2kw3K7oOhUww1PdvBfR90igJ1BDUKFdcmqwdQVwsCqHZ3bZVO3oJFn2dyl+8dS1VD
	 RizJgCv+ibUSm3H/uh/RMKY7d0mzklF9ca4Z2ioXqX5BCoF/GyY2o0KlnES1ona1QB
	 j9r7vUE/VofOrvLH1/AE7/r0Q8I1lst3Ir9XaB7S5WEjYNXSLofOsmXAsBzL6tExlN
	 OXMiZHnAkiBLQ==
Date: Sun, 31 Dec 2023 16:01:07 +9900
Subject: [PATCH 52/52] mkfs: format realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012857.1811243.7240725352292653783.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
index 673b01cbab3..4b0d4c3b3c7 100644
--- a/libfrog/div64.h
+++ b/libfrog/div64.h
@@ -93,4 +93,10 @@ howmany_64(uint64_t x, uint32_t y)
 	return x;
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
index a3503e07984..c5dad34f3d2 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -80,6 +80,7 @@
 #define xfs_btree_update		libxfs_btree_update
 #define xfs_btree_space_to_height	libxfs_btree_space_to_height
 #define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
+#define xfs_buf_delwri_queue		libxfs_buf_delwri_queue
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4e4a51637e6..120a41e20a7 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -337,12 +337,6 @@ find_next_zero_bit(const unsigned long *addr, unsigned long size,
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
index 06013d42945..b87731820c4 100644
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
index 1af5b054947..f1174bb4bab 100644
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
index 59ba13db53e..87476c6bb6c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -418,6 +418,7 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64| \
 		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_RTGROUPS | \
 		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 587754ff95b..e0175ca04b4 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1116,6 +1116,50 @@ or logical volume containing the section.
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
index b89b114d0d6..5239f9ec413 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1001,6 +1001,46 @@ rtsummary_init(
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
+		start_rtx = xfs_rtb_to_rtx(mp, rtbno);
+
+		rtbno = xfs_rgbno_to_rtb(mp, rgno + 1, 0);
+		next_rtx = xfs_rtb_to_rtx(mp, rtbno);
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
@@ -1049,7 +1089,10 @@ rtinit(
 
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
index aab1d9130b2..66532b8c9b6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -131,6 +131,9 @@ enum {
 	R_FILE,
 	R_NAME,
 	R_NOALIGN,
+	R_RTGROUPS,
+	R_RGCOUNT,
+	R_RGSIZE,
 	R_MAX_OPTS,
 };
 
@@ -718,6 +721,9 @@ static struct opt_params ropts = {
 		[R_FILE] = "file",
 		[R_NAME] = "name",
 		[R_NOALIGN] = "noalign",
+		[R_RTGROUPS] = "rtgroups",
+		[R_RGCOUNT] = "rgcount",
+		[R_RGSIZE] = "rgsize",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -757,6 +763,27 @@ static struct opt_params ropts = {
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
 
@@ -922,6 +949,7 @@ struct cli_params {
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
+	char	*rgsize;
 	char	*dsu;
 	char	*dirblocksize;
 	char	*logsize;
@@ -943,6 +971,7 @@ struct cli_params {
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
+	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
 	int	imaxpct;
@@ -999,6 +1028,9 @@ struct mkfs_params {
 	uint64_t	agsize;
 	uint64_t	agcount;
 
+	uint64_t	rgsize;
+	uint64_t	rgcount;
+
 	int		imaxpct;
 
 	bool		loginternal;
@@ -1055,7 +1087,8 @@ usage( void )
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
-/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rtgroups=0|1,\n\
+			    rgcount=n,rgsize=n]\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -1952,6 +1985,15 @@ rtdev_opts_parser(
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
@@ -2447,6 +2489,15 @@ _("cowextsize not supported without reflink support\n"));
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
@@ -3413,6 +3464,181 @@ an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
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
@@ -3552,6 +3778,12 @@ sb_set_features(
 
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
@@ -4327,6 +4559,7 @@ main(
 	char			**argv)
 {
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	struct xfs_buf		*buf;
 	int			c;
 	int			dry_run = 0;
@@ -4536,6 +4769,7 @@ main(
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
+	calculate_rtgroup_geometry(&cfg, &cli);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -4636,6 +4870,42 @@ main(
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

