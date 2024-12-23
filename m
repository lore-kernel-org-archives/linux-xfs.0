Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FA0433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992704; cv=none; b=R4aiGIZXUvQFkP4ijeDOJV5ifqTa7BTZYeKNFRZLrjfKTiuv6WJKiMocdw1AwiCdJGjQxOmjmacE9CTeSqHnulSrHbgBj0G75nSrYAcymm8P+I5c6hi+6Jd0cm6nEX134kshoWN8QmJhByBS/mgFZjFR2ridiJd01n19vAIGmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992704; c=relaxed/simple;
	bh=0fBIJJXlPTrIcMkNDVTg+IdO3zncwFQZ+/of1X0exhM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CtzEn2Kuz90ulTKiUQ8DBurjRgLaem22w5dqGI+Z9p2BKwqjJWlBYToN6o5qmRdIwEY2bUmPIxnbqI7zNEh8FPSU1mGaComytMUKfiw8yOv9uc3DJPEgbdwGs5tl7/VHDLCM/sAlSpptT4v0K9Bgtv2uiwaP4M9l0/oJQKHVjW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJMm2Uso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJMm2Uso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70801C4CED3;
	Mon, 23 Dec 2024 22:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992704;
	bh=0fBIJJXlPTrIcMkNDVTg+IdO3zncwFQZ+/of1X0exhM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kJMm2UsoZDj3C7J7+SqcPkbk17FmDi3Z93LkDhVZXCb4j+2Ef6oOy6elM0zvr6kwc
	 wwfJY1iir4Y35jM8pEkjYF40ZOMGjbRDOJpoqW9B5HmGw7MSv1djfBQAUTk/mwEV/P
	 hzYyKax4nUE4s7ui9cfcdkFsR8AJ3+jG91HfFPFnGG6g0TzWLWiAx4gHPENXvxkIDr
	 PI9EN4qTg6H0ylj6Uy+UXUJAm+AAIyqhDcG41MPcZBD9oUE5P6bY7eoggN17iaLqaK
	 VBvvHeYindsUiJtRyAgKkXsDOJ3yOMg7D9MkYka7dIoetbtBBjA+Imd7ImGdnfEV86
	 ssvML7G52Kt0w==
Date: Mon, 23 Dec 2024 14:25:04 -0800
Subject: [PATCH 51/51] mkfs: format realtime groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944584.2297565.1780017668106157588.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/div64.h          |    6 +
 libfrog/util.c           |   12 ++
 libfrog/util.h           |    1 
 libxfs/libxfs_api_defs.h |    2 
 libxfs/libxfs_priv.h     |    6 -
 libxfs/topology.c        |   42 +++++++
 libxfs/topology.h        |    3 
 man/man8/mkfs.xfs.8.in   |   31 +++++
 mkfs/proto.c             |   88 ++++++++++++--
 mkfs/xfs_mkfs.c          |  286 +++++++++++++++++++++++++++++++++++++++++++++-
 10 files changed, 448 insertions(+), 29 deletions(-)


diff --git a/libfrog/div64.h b/libfrog/div64.h
index 673b01cbab34de..4b0d4c3b3c704d 100644
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
index 46047571a5531f..4e130c884c17a2 100644
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
index 8b4ee7c1333b6b..d1c4dd40fc926c 100644
--- a/libfrog/util.h
+++ b/libfrog/util.h
@@ -9,6 +9,7 @@
 #include <sys/types.h>
 
 unsigned int	log2_roundup(unsigned int i);
+unsigned int	log2_rounddown(unsigned long long i);
 
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index dbdf5d100ec8e9..a8416dfbb27f59 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -94,6 +94,7 @@
 #define xfs_btree_stage_afakeroot	libxfs_btree_stage_afakeroot
 #define xfs_btree_stage_ifakeroot	libxfs_btree_stage_ifakeroot
 #define xfs_btree_visit_blocks		libxfs_btree_visit_blocks
+#define xfs_buf_delwri_queue		libxfs_buf_delwri_queue
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
 #define xfs_buf_get_uncached		libxfs_buf_get_uncached
@@ -302,6 +303,7 @@
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_update_rtsb			libxfs_update_rtsb
 #define xfs_sb_from_disk		libxfs_sb_from_disk
+#define xfs_sb_mount_rextsize		libxfs_sb_mount_rextsize
 #define xfs_sb_quota_from_disk		libxfs_sb_quota_from_disk
 #define xfs_sb_read_secondary		libxfs_sb_read_secondary
 #define xfs_sb_to_disk			libxfs_sb_to_disk
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index dd24bdc2d169d9..a1401b2c1e409b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -307,12 +307,6 @@ find_next_zero_bit(const unsigned long *addr, unsigned long size,
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
index 94adb5be7bdcae..8c6affb4c4e436 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -87,6 +87,48 @@ calc_default_ag_geometry(
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
index fa0a23b7738624..207a8a7f150556 100644
--- a/libxfs/topology.h
+++ b/libxfs/topology.h
@@ -37,6 +37,9 @@ calc_default_ag_geometry(
 	uint64_t	*agsize,
 	uint64_t	*agcount);
 
+void calc_default_rtgroup_geometry(int blocklog, uint64_t rblocks,
+		uint64_t *rgsize, uint64_t *rgcount);
+
 extern int
 check_overwrite(
 	const char	*device);
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index de5f6baf59df95..0c0cf1dc151e4f 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1141,6 +1141,37 @@ .SH OPTIONS
 .BI noalign
 This option disables stripe size detection, enforcing a realtime device with no
 stripe geometry.
+.TP
+.BI rgcount= value
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
index 846b1c9a9e8a21..4e9e28d4eea1ca 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1008,8 +1008,8 @@ create_sb_metadata_file(
 }
 
 /*
- * Free the whole realtime area using transactions.
- * Do one transaction per bitmap block.
+ * Free the whole realtime area using transactions.  Each transaction may clear
+ * up to 32 rtbitmap blocks.
  */
 static void
 rtfreesp_init(
@@ -1017,8 +1017,8 @@ rtfreesp_init(
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_trans	*tp;
-	xfs_rtxnum_t		rtx;
-	xfs_rtxnum_t		ertx;
+	const xfs_rtxnum_t	max_rtx = mp->m_rtx_per_rbmblock * 32;
+	xfs_rtxnum_t		start_rtx = 0;
 	int			error;
 
 	/*
@@ -1034,37 +1034,56 @@ rtfreesp_init(
 	if (error)
 		fail(_("Initialization of rtsummary inode failed"), error);
 
+	if (!mp->m_sb.sb_rbmblocks)
+		return;
+
 	/*
 	 * Then free the blocks into the allocator, one bitmap block at a time.
 	 */
-	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx = ertx) {
+	while (start_rtx < rtg->rtg_extents) {
+		xfs_rtxlen_t	nr = min(rtg->rtg_extents - start_rtx, max_rtx);
+
+		/*
+		 * The rt superblock, if present, must not be marked free.
+		 * This may be the only rtx in the entire volume.
+		 */
+		if (xfs_has_rtsb(mp) && rtg_rgno(rtg) == 0 && start_rtx == 0) {
+			start_rtx++;
+			nr--;
+
+			if (start_rtx == rtg->rtg_extents)
+				break;
+		}
+
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
 		if (error)
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP], 0);
-		ertx = min(mp->m_sb.sb_rextents,
-			   rtx + NBBY * mp->m_sb.sb_blocksize);
-
-		error = -libxfs_rtfree_extent(tp, rtg, rtx,
-				(xfs_rtxlen_t)(ertx - rtx));
+		error = -libxfs_rtfree_extent(tp, rtg, start_rtx, nr);
 		if (error) {
-			fail(_("Error initializing the realtime space"),
-				error);
+			fprintf(stderr,
+ _("Error initializing the realtime free space near rgno %u rtx %lld-%lld (max %lld): %s\n"),
+					rtg_rgno(rtg),
+					(unsigned long long)start_rtx,
+					(unsigned long long)start_rtx + nr - 1,
+					(unsigned long long)rtg->rtg_extents,
+					strerror(error));
+			exit(1);
 		}
+
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Initialization of the realtime space failed"),
 					error);
+
+		start_rtx += nr;
 	}
 }
 
-/*
- * Allocate the realtime bitmap and summary inodes, and fill in data if any.
- */
 static void
-rtinit(
+rtinit_nogroups(
 	struct xfs_mount	*mp)
 {
 	struct xfs_rtgroup	*rtg = NULL;
@@ -1079,6 +1098,43 @@ rtinit(
 	}
 }
 
+static void
+rtinit_groups(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg = NULL;
+	unsigned int		i;
+	int			error;
+
+	error = -libxfs_rtginode_mkdir_parent(mp);
+	if (error)
+		fail(_("rtgroup directory allocation failed"), error);
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		for (i = 0; i < XFS_RTGI_MAX; i++) {
+			error = -libxfs_rtginode_create(rtg, i, true);
+			if (error)
+				fail(_("rt group inode creation failed"),
+						error);
+		}
+
+		rtfreesp_init(rtg);
+	}
+}
+
+/*
+ * Allocate the realtime bitmap and summary inodes, and fill in data if any.
+ */
+static void
+rtinit(
+	struct xfs_mount	*mp)
+{
+	if (xfs_has_rtgroups(mp))
+		rtinit_groups(mp);
+	else
+		rtinit_nogroups(mp);
+}
+
 static off_t
 filesize(
 	int		fd)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5b9fd0e92f7aba..cd94cfd0b93706 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -132,6 +132,8 @@ enum {
 	R_FILE,
 	R_NAME,
 	R_NOALIGN,
+	R_RGCOUNT,
+	R_RGSIZE,
 	R_MAX_OPTS,
 };
 
@@ -727,6 +729,8 @@ static struct opt_params ropts = {
 		[R_FILE] = "file",
 		[R_NAME] = "name",
 		[R_NOALIGN] = "noalign",
+		[R_RGCOUNT] = "rgcount",
+		[R_RGSIZE] = "rgsize",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -766,6 +770,21 @@ static struct opt_params ropts = {
 		  .defaultval = 1,
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		},
+		{ .index = R_RGCOUNT,
+		  .conflicts = { { &ropts, R_RGSIZE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 1,
+		  .maxval = XFS_MAX_RGNUMBER,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+		{ .index = R_RGSIZE,
+		  .conflicts = { { &ropts, R_RGCOUNT },
+				 { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = (unsigned long long)XFS_MAX_RGBLOCKS << XFS_MAX_BLOCKSIZE_LOG,
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -940,6 +959,7 @@ struct cli_params {
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
+	char	*rgsize;
 	char	*dsu;
 	char	*dirblocksize;
 	char	*logsize;
@@ -961,6 +981,7 @@ struct cli_params {
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
+	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
 	int	imaxpct;
@@ -1017,6 +1038,9 @@ struct mkfs_params {
 	uint64_t	agsize;
 	uint64_t	agcount;
 
+	uint64_t	rgsize;
+	uint64_t	rgcount;
+
 	int		imaxpct;
 
 	bool		loginternal;
@@ -1075,7 +1099,7 @@ usage( void )
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
-/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx]\n\
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n]\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -1989,6 +2013,12 @@ rtdev_opts_parser(
 	case R_NOALIGN:
 		cli->sb_feat.nortalign = getnum(value, opts, subopt);
 		break;
+	case R_RGCOUNT:
+		cli->rgcount = getnum(value, opts, subopt);
+		break;
+	case R_RGSIZE:
+		cli->rgsize = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2531,6 +2561,20 @@ _("cowextsize not supported without reflink support\n"));
 		cli->sb_feat.exchrange = true;
 	}
 
+	/*
+	 * Exchange-range will be needed for space reorganization on filesystems
+	 * with realtime rmap or realtime reflink enabled, and there is no good
+	 * reason to ever disable it on a file system with new enough features.
+	 */
+	if (cli->sb_feat.metadir && !cli->sb_feat.exchrange) {
+		if (cli_opt_set(&iopts, I_EXCHANGE)) {
+			fprintf(stderr,
+_("metadir not supported without exchange-range support\n"));
+			usage();
+		}
+		cli->sb_feat.exchrange = true;
+	}
+
 	/*
 	 * Copy features across to config structure now.
 	 */
@@ -3210,7 +3254,6 @@ validate_rtdev(
 	struct cli_params	*cli)
 {
 	struct libxfs_init	*xi = cli->xi;
-	unsigned int		rbmblocksize = cfg->blocksize;
 
 	if (!xi->rt.dev) {
 		if (cli->rtsize) {
@@ -3254,10 +3297,13 @@ reported by the device (%u).\n"),
 _("cannot have an rt subvolume with zero extents\n"));
 		usage();
 	}
-	if (cfg->sb_feat.metadir)
-		rbmblocksize -= sizeof(struct xfs_rtbuf_blkinfo);
+
+	/*
+	 * Note for rtgroup file systems this will be overriden in
+	 * calculate_rtgroup_geometry.
+	 */
 	cfg->rtbmblocks = (xfs_extlen_t)howmany(cfg->rtextents,
-						NBBY * rbmblocksize);
+						NBBY * cfg->blocksize);
 }
 
 static bool
@@ -3498,6 +3544,189 @@ an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
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
+	if (!cli->sb_feat.metadir) {
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
+	} else if (cfg->rtblocks < cfg->rtextblocks * 2) {
+		/* too small even for a single group */
+		cfg->rgsize = cfg->rtblocks;
+		cfg->rgcount = 0;
+	} else if (is_power_of_2(cfg->rtextblocks)) {
+		cfg->rgsize = calc_rgsize_extsize_power(cfg);
+		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
+				(cfg->rtblocks % cfg->rgsize != 0);
+	} else {
+		cfg->rgsize = calc_rgsize_extsize_nonpower(cfg);
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
+
+	if (cfg->rtextents)
+		cfg->rtbmblocks = howmany(cfg->rgsize / cfg->rtextblocks,
+			NBBY * (cfg->blocksize - sizeof(struct xfs_rtbuf_blkinfo)));
+}
+
 static void
 calculate_imaxpct(
 	struct mkfs_params	*cfg,
@@ -3651,8 +3880,13 @@ sb_set_features(
 		 */
 		sbp->sb_versionnum |= XFS_SB_VERSION_ATTRBIT;
 	}
-	if (fp->metadir)
+	if (fp->metadir) {
 		sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_METADIR;
+		sbp->sb_rgcount = cfg->rgcount;
+		sbp->sb_rgextents = cfg->rgsize / cfg->rtextblocks;
+		sbp->sb_rgblklog = libxfs_compute_rgblklog(sbp->sb_rgextents,
+							   cfg->rtextblocks);
+	}
 }
 
 /*
@@ -4046,6 +4280,7 @@ start_superblock_setup(
 	sbp->sb_rblocks = cfg->rtblocks;
 	sbp->sb_rextsize = cfg->rtextblocks;
 	mp->m_features |= libxfs_sb_version_to_features(sbp);
+	libxfs_sb_mount_rextsize(mp, sbp);
 }
 
 static void
@@ -4106,7 +4341,7 @@ finish_superblock_setup(
 	sbp->sb_unit = cfg->dsunit;
 	sbp->sb_width = cfg->dswidth;
 	mp->m_features |= libxfs_sb_version_to_features(sbp);
-
+	libxfs_sb_mount_rextsize(mp, sbp);
 }
 
 /* Prepare an uncached buffer, ready to write something out. */
@@ -4488,6 +4723,39 @@ set_autofsck(
 	libxfs_irele(args.dp);
 }
 
+/* Write the realtime superblock */
+static void
+write_rtsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*rtsb_bp;
+	struct xfs_buf		*sb_bp = libxfs_getsb(mp);
+	int			error;
+
+	if (!sb_bp) {
+		fprintf(stderr,
+  _("%s: couldn't grab primary superblock buffer\n"), progname);
+		exit(1);
+	}
+
+	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
+				XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR,
+				&rtsb_bp);
+	if (error) {
+		fprintf(stderr,
+ _("%s: couldn't grab realtime superblock buffer\n"), progname);
+			exit(1);
+	}
+
+	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+	libxfs_update_rtsb(rtsb_bp, sb_bp);
+	libxfs_buf_mark_dirty(rtsb_bp);
+	libxfs_buf_relse(rtsb_bp);
+	libxfs_buf_relse(sb_bp);
+}
+
 int
 main(
 	int			argc,
@@ -4704,6 +4972,7 @@ main(
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
+	calculate_rtgroup_geometry(&cfg, &cli);
 
 	calculate_imaxpct(&cfg, &cli);
 
@@ -4804,6 +5073,9 @@ main(
 		exit(1);
 	}
 
+	if (xfs_has_rtsb(mp) && cfg.rtblocks > 0)
+		write_rtsb(mp);
+
 	/*
 	 * Initialise the freespace freelists (i.e. AGFLs) in each AG.
 	 */

