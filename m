Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86B623C8A1
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556786; cv=none; b=Qrm68DEuPWFB93mAyajawgMZGz8nBti1Stfh9k8LZ9y4eoxlER5rufjfKnIYNABiYzKgxFPaTXmVR1KJl2DLOZp59Go1STFNtZ9Wp/MWwkVR14ZrSqR3GW8OEu9Eehkcm4w8drcXsX2CQOIVRkfOMIHqr4CC5hAvZ3ETCTuftKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556786; c=relaxed/simple;
	bh=n6jkCbWAkT/op772pEYqehlqV/Vs9fUiwrwo0E8pgcw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egbHLhH8cc6oApWQAQeE9zCCLkqUHZDBPdGeYAKj/V1adGnxSbTty6uYewNCsvqz8QvM0RyEqXM3RkYM8q2sp1jkQ5gDsINKsZV6Bsx3+8J9QN31bVfZmHVHdUXwLFc+WECJ9OaubuIkuOOuVV0bl9p/AULmiMF1XmxAnbVv2cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FTPWQYgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FTPWQYgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CC5C4CEE3;
	Tue, 15 Jul 2025 05:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556786;
	bh=n6jkCbWAkT/op772pEYqehlqV/Vs9fUiwrwo0E8pgcw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FTPWQYgv5JCz/5OH2KePsIOqDIeD31n80LgHDuyXTNIAs1n2V64fBR0kY1FtVChmE
	 8KOI5FAgQ9xpMeRcDZwXuE73KZss3yljGP0A7H4agScvZihBx07GZGlB7tbsNNLGOi
	 WKRjfUsdkS9cfmoplWW2B7XwrkNIJiEenv0xzyszobx8Eb80zm2iGMo5azMaZ0uAN8
	 duUpTcNpgxj9KLzCVT5W2rCl73Nf5LvLzWj1zFroEgiJ/X0wVL/n7beRq7zJordH6A
	 Y/JYQxj91UZJMiVQJ0oC2ejlbfP0EqcSeDqkZytGFI+rRCoBktz9WQ3XjjrVcY+P5t
	 PDBcS3casrbQQ==
Date: Mon, 14 Jul 2025 22:19:46 -0700
Subject: [PATCH 7/7] mkfs: allow users to configure the desired maximum atomic
 write size
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652583.1831001.14041627191136969376.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
References: <175255652424.1831001.9800800142745344742.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow callers of mkfs.xfs to specify a desired maximum atomic write
size.  This value will cause the log size to be adjusted to support
software atomic writes, and the AG size to be aligned to support
hardware atomic writes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 include/bitops.h         |   12 +++
 libxfs/libxfs_api_defs.h |    1 
 man/man8/mkfs.xfs.8.in   |    7 ++
 mkfs/xfs_mkfs.c          |  194 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 213 insertions(+), 1 deletion(-)


diff --git a/include/bitops.h b/include/bitops.h
index 1f1adceccf5d2b..d0c55827044e54 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -113,4 +113,16 @@ static inline int lowbit64(uint64_t v)
 	return n - 1;
 }
 
+/**
+ * __rounddown_pow_of_two() - round down to nearest power of two
+ * @n: value to round down
+ */
+static inline __attribute__((const))
+unsigned long __rounddown_pow_of_two(unsigned long n)
+{
+	return 1UL << (fls_long(n) - 1);
+}
+
+#define rounddown_pow_of_two(n) __rounddown_pow_of_two(n)
+
 #endif
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 4bd02c57b496e6..fe00e19bada9d8 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -107,6 +107,7 @@
 #define xfs_buftarg_drain		libxfs_buftarg_drain
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bwrite			libxfs_bwrite
+#define xfs_calc_atomic_write_log_geometry	libxfs_calc_atomic_write_log_geometry
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
 #define xfs_calc_finish_bui_reservation	libxfs_calc_finish_bui_reservation
 #define xfs_calc_finish_cui_reservation	libxfs_calc_finish_cui_reservation
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index bc80493187f6f9..5f59d4b2da6e02 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -742,6 +742,13 @@ .SH OPTIONS
 directories, symbolic links, and realtime metadata files.
 This feature is disabled by default.
 This feature is only available for filesystems formatted with -m crc=1.
+.TP
+.BI max_atomic_write[= value]
+When enabled, application programs can use the RWF_ATOMIC write flag to
+persist changes of up to this size without tearing.
+The default is chosen to allow a reasonable amount of scalability.
+This value must also be passed via mount option.
+This feature is only available for filesystems formatted with reflink.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d2080804a21470..b889c0de9c0d46 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -94,6 +94,7 @@ enum {
 	I_SPINODES,
 	I_NREXT64,
 	I_EXCHANGE,
+	I_MAX_ATOMIC_WRITE,
 	I_MAX_OPTS,
 };
 
@@ -489,6 +490,7 @@ static struct opt_params iopts = {
 		[I_SPINODES] = "sparse",
 		[I_NREXT64] = "nrext64",
 		[I_EXCHANGE] = "exchange",
+		[I_MAX_ATOMIC_WRITE] = "max_atomic_write",
 		[I_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -550,6 +552,13 @@ static struct opt_params iopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = I_MAX_ATOMIC_WRITE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 1,
+		  .maxval = 1ULL << 30, /* 1GiB */
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1069,6 +1078,7 @@ struct cli_params {
 	char	*rtsize;
 	char	*rtstart;
 	uint64_t rtreserved;
+	char	*max_atomic_write;
 
 	/* parameters where 0 is a valid CLI value */
 	int	dsunit;
@@ -1157,6 +1167,8 @@ struct mkfs_params {
 	struct sb_feat_args	sb_feat;
 	uint64_t	rtstart;
 	uint64_t	rtreserved;
+
+	uint64_t	max_atomic_write;
 };
 
 /*
@@ -1197,7 +1209,7 @@ usage( void )
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1,nrext64=0|1,\n\
-			    exchange=0|1]\n\
+			    exchange=0|1,max_atomic_write=n]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1,\n\
@@ -1927,6 +1939,9 @@ inode_opts_parser(
 	case I_EXCHANGE:
 		cli->sb_feat.exchrange = getnum(value, opts, subopt);
 		break;
+	case I_MAX_ATOMIC_WRITE:
+		cli->max_atomic_write = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -4093,6 +4108,18 @@ align_ag_geometry(
 		dsunit = max(DTOBT(ft->data.awu_max, cfg->blocklog),
 				dsunit);
 
+	/*
+	 * If the user gave us a maximum atomic write size that is less than
+	 * a whole AG, try to align the AG size to that value.
+	 */
+	if (cfg->max_atomic_write > 0) {
+		xfs_extlen_t	max_atomic_fsbs =
+			cfg->max_atomic_write >> cfg->blocklog;
+
+		if (max_atomic_fsbs < cfg->agsize)
+			dsunit = max(dsunit, max_atomic_fsbs);
+	}
+
 	if (!dsunit)
 		goto validate;
 
@@ -4972,6 +4999,140 @@ calc_concurrency_logblocks(
 	return logblocks;
 }
 
+#define MAX_RW_COUNT (INT_MAX & ~(getpagesize() - 1))
+
+/* Maximum atomic write IO size that the kernel allows. */
+static inline xfs_extlen_t calc_atomic_write_max(struct mkfs_params *cfg)
+{
+	return rounddown_pow_of_two(MAX_RW_COUNT >> cfg->blocklog);
+}
+
+static inline unsigned int max_pow_of_two_factor(const unsigned int nr)
+{
+	return 1 << (ffs(nr) - 1);
+}
+
+/*
+ * If the data device advertises atomic write support, limit the size of data
+ * device atomic writes to the greatest power-of-two factor of the AG size so
+ * that every atomic write unit aligns with the start of every AG.  This is
+ * required so that the per-AG allocations for an atomic write will always be
+ * aligned compatibly with the alignment requirements of the storage.
+ *
+ * If the data device doesn't advertise atomic writes, then there are no
+ * alignment restrictions and the largest out-of-place write we can do
+ * ourselves is the number of blocks that user files can allocate from any AG.
+ */
+static inline xfs_extlen_t
+calc_perag_awu_max(
+	struct mkfs_params	*cfg,
+	struct fs_topology	*ft)
+{
+	if (ft->data.awu_min > 0)
+		return max_pow_of_two_factor(cfg->agsize);
+	return cfg->agsize;
+}
+
+/*
+ * Reflink on the realtime device requires rtgroups, and atomic writes require
+ * reflink.
+ *
+ * If the realtime device advertises atomic write support, limit the size of
+ * data device atomic writes to the greatest power-of-two factor of the rtgroup
+ * size so that every atomic write unit aligns with the start of every rtgroup.
+ * This is required so that the per-rtgroup allocations for an atomic write
+ * will always be aligned compatibly with the alignment requirements of the
+ * storage.
+ *
+ * If the rt device doesn't advertise atomic writes, then there are no
+ * alignment restrictions and the largest out-of-place write we can do
+ * ourselves is the number of blocks that user files can allocate from any
+ * rtgroup.
+ */
+static inline xfs_extlen_t
+calc_rtgroup_awu_max(
+	struct mkfs_params	*cfg,
+	struct fs_topology	*ft)
+{
+	if (ft->rt.awu_min > 0)
+		return max_pow_of_two_factor(cfg->rgsize);
+	return cfg->rgsize;
+}
+
+/*
+ * Validate the maximum atomic out of place write size passed in by the user.
+ */
+static void
+validate_max_atomic_write(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct fs_topology	*ft,
+	struct xfs_mount	*mp)
+{
+	const xfs_extlen_t	max_write = calc_atomic_write_max(cfg);
+	xfs_filblks_t		max_atomic_fsbcount;
+
+	cfg->max_atomic_write = getnum(cli->max_atomic_write, &iopts,
+			I_MAX_ATOMIC_WRITE);
+	max_atomic_fsbcount = cfg->max_atomic_write >> cfg->blocklog;
+
+	/* generic_atomic_write_valid enforces power of two length */
+	if (!is_power_of_2(cfg->max_atomic_write)) {
+		fprintf(stderr,
+ _("Max atomic write size of %llu bytes is not a power of 2\n"),
+			(unsigned long long)cfg->max_atomic_write);
+		exit(1);
+	}
+
+	if (cfg->max_atomic_write % cfg->blocksize) {
+		fprintf(stderr,
+ _("Max atomic write size of %llu bytes not aligned with fsblock.\n"),
+			(unsigned long long)cfg->max_atomic_write);
+		exit(1);
+	}
+
+	if (max_atomic_fsbcount > max_write) {
+		fprintf(stderr,
+ _("Max atomic write size of %lluk cannot be larger than max write size %lluk.\n"),
+			(unsigned long long)cfg->max_atomic_write >> 10,
+			(unsigned long long)max_write << (cfg->blocklog - 10));
+		exit(1);
+	}
+}
+
+/*
+ * Validate the maximum atomic out of place write size passed in by the user
+ * actually works with the allocation groups sizes.
+ */
+static void
+validate_max_atomic_write_ags(
+	struct mkfs_params	*cfg,
+	struct fs_topology	*ft,
+	struct xfs_mount	*mp)
+{
+	const xfs_extlen_t	max_group = max(cfg->agsize, cfg->rgsize);
+	const xfs_extlen_t	max_group_write =
+		max(calc_perag_awu_max(cfg, ft), calc_rtgroup_awu_max(cfg, ft));
+	xfs_filblks_t		max_atomic_fsbcount =
+		XFS_B_TO_FSBT(mp, cfg->max_atomic_write);
+
+	if (max_atomic_fsbcount > max_group) {
+		fprintf(stderr,
+ _("Max atomic write size of %lluk cannot be larger than allocation group size %lluk.\n"),
+			(unsigned long long)cfg->max_atomic_write >> 10,
+			(unsigned long long)XFS_FSB_TO_B(mp, max_group) >> 10);
+		exit(1);
+	}
+
+	if (max_atomic_fsbcount > max_group_write) {
+		fprintf(stderr,
+ _("Max atomic write size of %lluk cannot be larger than max allocation group write size %lluk.\n"),
+			(unsigned long long)cfg->max_atomic_write >> 10,
+			(unsigned long long)XFS_FSB_TO_B(mp, max_group_write) >> 10);
+		exit(1);
+	}
+}
+
 static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
@@ -4997,6 +5158,22 @@ calculate_log_size(
 		libxfs_log_get_max_trans_res(&mount, &res);
 		max_tx_bytes = res.tr_logres * res.tr_logcount;
 	}
+	if (cfg->max_atomic_write > 0) {
+		unsigned int	dontcare;
+		xfs_extlen_t	atomic_min_logblocks =
+			libxfs_calc_atomic_write_log_geometry(&mount,
+					cfg->max_atomic_write >> cfg->blocklog,
+					&dontcare);
+
+		if (!atomic_min_logblocks) {
+			fprintf(stderr,
+ _("atomic write size %lluk is too big for the log to handle.\n"),
+				(unsigned long long)cfg->max_atomic_write >> 10);
+			exit(1);
+		}
+
+		min_logblocks = max(min_logblocks, atomic_min_logblocks);
+	}
 	libxfs_umount(&mount);
 
 	ASSERT(min_logblocks);
@@ -5924,6 +6101,13 @@ main(
 	validate_rtdev(&cfg, &cli, &zt);
 	calc_stripe_factors(&cfg, &cli, &ft);
 
+	/*
+	 * Now that we have basic geometry set up, we can validate the CLI
+	 * max atomic write parameter.
+	 */
+	if (cli.max_atomic_write)
+		validate_max_atomic_write(&cfg, &cli, &ft, mp);
+
 	/*
 	 * At this point when know exactly what size all the devices are,
 	 * so we can start validating and calculating layout options that are
@@ -5947,6 +6131,14 @@ main(
 	start_superblock_setup(&cfg, mp, sbp);
 	initialise_mount(mp, sbp);
 
+	/*
+	 * Now that we have computed the allocation group geometry, we can
+	 * continue validating the maximum software atomic write parameter, if
+	 * one was given.
+	 */
+	if (cfg.max_atomic_write)
+		validate_max_atomic_write_ags(&cfg, &ft, mp);
+
 	/*
 	 * With the mount set up, we can finally calculate the log size
 	 * constraints and do default size calculations and final validation

