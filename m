Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE6C146590
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 21:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736890902; cv=none; b=BJbmCMw9ifDyKQS7F9dDPX86jtcu3+LvUsoceaTcdzPdcMQrFZcEzH/TKkz5Nrv1Qqrt2LuBNTcZ9AQbUVVY2Yi0KiKvwj6GvOjDuE7Rq00YakHX7AY7+HQIH29jHEpmxGvJCeKc6nKqrSE5oe70m80XBeQuFhORz90e5I1N4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736890902; c=relaxed/simple;
	bh=oEESqqLibXrBoToFC6oJ31G9N7N0ZcZnCJmilDX4qvw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+qUDsUvs4YITLeehCNvJTjvdfIrdJPXgmKmVFEVDIeXDpVOHL4w4Kv/l+BmmSySg3wEX4BLbgooEE69rkaSj/UAl15u+X5RWNLcn19sQbOi3wpyzAtyJL7KiWUB4UGroYub6k9tMJCfx4JPd8sBqjCAQ51Bvutx5R2w22yYcvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Squz5NUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Squz5NUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A09C4CEE3;
	Tue, 14 Jan 2025 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736890901;
	bh=oEESqqLibXrBoToFC6oJ31G9N7N0ZcZnCJmilDX4qvw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Squz5NUvIUlc1fgAP0W+bNTvJNTrzukxsacCHnlfmsQGBeXRVtqgj+XsAi/BeLKSu
	 f18SKnADV+HtiGPbLyvOV+oRgWA+FT8Jle0y0h431MY8+QvDhcG/gDS1xr71Qk8Rzp
	 Ee/Ac6QkN8RBR3TF6fJV/EN2j9R6EdCmZTbEeHjVX39mHThHfIXBWERq4ei8EcBSC9
	 ShJW3WGD5YDzhuqXBFd68KNjF0iOuZyqKBmRoiLn9UwvjpCyP9A9zgkJaOwcdiQz/t
	 IR1d0PgpkvoyxpsZme03ZMayPSFAIl34rzqHylMFZQdYi0AD8wqjkAN3X1JRUfMiqb
	 SjH1Wroh7lZyw==
Date: Tue, 14 Jan 2025 13:41:40 -0800
Subject: [PATCH 5/5] mkfs: allow sizing realtime allocation groups for
 concurrency
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173689081956.3476119.7466311188976179968.stgit@frogsfrogsfrogs>
In-Reply-To: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
References: <173689081879.3476119.15344563789813181160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a -r concurrency= option to mkfs so that sysadmins can configure the
filesystem so that there are enough rtgroups that the specified number
of threads can (in theory) can find an uncontended rtgroup from which to
allocate space.  This has the exact same purpose as the -d concurrency
switch that was added for the data device.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   28 ++++++++++
 mkfs/xfs_mkfs.c        |  140 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 165 insertions(+), 3 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 32361cf973fcf8..37e3a88e7ac777 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1220,6 +1220,34 @@ .SH OPTIONS
 and
 .B rgsize
 suboptions are mutually exclusive.
+.TP
+.BI concurrency= value
+Create enough realtime allocation groups to handle the desired level of
+concurrency.
+The goal of this calculation scheme is to set the number of rtgroups to an
+integer multiple of the number of writer threads desired, to minimize
+contention of rtgroup locks.
+This scheme will neither create fewer rtgroups than would be created by the
+default configuration, nor will it create rtgroups smaller than 4GB.
+This option is not compatible with the
+.B rgcount
+or
+.B rgsize
+options.
+The magic value
+.I nr_cpus
+or
+.I 1
+or no value at all will set this parameter to the number of active processors
+in the system.
+If the kernel advertises that the realtime device is a non-mechanical storage
+device,
+.B mkfs.xfs
+will use this new geometry calculation scheme.
+The magic value of
+.I 0
+forces use of the older rtgroups geometry calculations that is used for
+mechanical storage.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index deaac2044b94dd..073e79ac58303c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -134,6 +134,7 @@ enum {
 	R_NOALIGN,
 	R_RGCOUNT,
 	R_RGSIZE,
+	R_CONCURRENCY,
 	R_MAX_OPTS,
 };
 
@@ -737,6 +738,7 @@ static struct opt_params ropts = {
 		[R_NOALIGN] = "noalign",
 		[R_RGCOUNT] = "rgcount",
 		[R_RGSIZE] = "rgsize",
+		[R_CONCURRENCY] = "concurrency",
 		[R_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -778,6 +780,7 @@ static struct opt_params ropts = {
 		},
 		{ .index = R_RGCOUNT,
 		  .conflicts = { { &ropts, R_RGSIZE },
+				 { &ropts, R_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 1,
 		  .maxval = XFS_MAX_RGNUMBER,
@@ -785,12 +788,22 @@ static struct opt_params ropts = {
 		},
 		{ .index = R_RGSIZE,
 		  .conflicts = { { &ropts, R_RGCOUNT },
+				 { &ropts, R_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = 0,
 		  .maxval = (unsigned long long)XFS_MAX_RGBLOCKS << XFS_MAX_BLOCKSIZE_LOG,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = R_CONCURRENCY,
+		  .conflicts = { { &ropts, R_RGCOUNT },
+				 { &ropts, R_RGSIZE },
+				 { NULL, LAST_CONFLICT } },
+		  .convert = true,
+		  .minval = 0,
+		  .maxval = INT_MAX,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -1034,6 +1047,7 @@ struct cli_params {
 	int	proto_slashes_are_spaces;
 	int	data_concurrency;
 	int	log_concurrency;
+	int	rtvol_concurrency;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -1157,7 +1171,8 @@ usage( void )
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
-/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n]\n\
+/* realtime subvol */	[-r extsize=num,size=num,rtdev=xxx,rgcount=n,rgsize=n,\n\
+			    concurrency=num]\n\
 /* sectorsize */	[-s size=num]\n\
 /* version */		[-V]\n\
 			devicename\n\
@@ -2071,6 +2086,31 @@ proto_opts_parser(
 	return 0;
 }
 
+static void
+set_rtvol_concurrency(
+	struct opt_params	*opts,
+	int			subopt,
+	struct cli_params	*cli,
+	const char		*value)
+{
+	long long		optnum;
+
+	/*
+	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
+	 * If this cannot be determined, fall back to the default rtgroup
+	 * geometry.
+	 */
+	if (!value || !strcmp(value, "nr_cpus"))
+		optnum = 1;
+	else
+		optnum = getnum(value, opts, subopt);
+
+	if (optnum == 1)
+		cli->rtvol_concurrency = nr_cpus();
+	else
+		cli->rtvol_concurrency = optnum;
+}
+
 static int
 rtdev_opts_parser(
 	struct opt_params	*opts,
@@ -2101,6 +2141,9 @@ rtdev_opts_parser(
 	case R_RGSIZE:
 		cli->rgsize = getstr(value, opts, subopt);
 		break;
+	case R_CONCURRENCY:
+		set_rtvol_concurrency(opts, subopt, cli, value);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -3740,10 +3783,97 @@ _("realtime group size (%llu) not at all congruent with extent size (%llu)\n"),
 	return 0;
 }
 
+static bool
+rtdev_is_solidstate(
+	struct libxfs_init	*xi)
+{
+	unsigned short		rotational = 1;
+	int			error;
+
+	error = ioctl(xi->rt.fd, BLKROTATIONAL, &rotational);
+	if (error)
+		return false;
+
+	return rotational == 0;
+}
+
+static void
+calc_concurrency_rtgroup_geometry(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct libxfs_init	*xi)
+{
+	uint64_t		try_rgsize;
+	uint64_t		def_rgsize;
+	uint64_t		def_rgcount;
+	int			nr_threads = cli->rtvol_concurrency;
+	int			try_threads;
+
+	if (is_power_of_2(cfg->rtextblocks))
+		def_rgsize = calc_rgsize_extsize_power(cfg);
+	else
+		def_rgsize = calc_rgsize_extsize_nonpower(cfg);
+	def_rgcount = howmany(cfg->rtblocks, def_rgsize);
+	try_rgsize = def_rgsize;
+
+	/*
+	 * If the caller doesn't have a particular concurrency level in mind,
+	 * set it to the number of CPUs in the system.
+	 */
+	if (nr_threads < 0)
+		nr_threads = nr_cpus();
+
+	/*
+	 * Don't create fewer rtgroups than what we would create with the
+	 * default geometry calculation.
+	 */
+	if (!nr_threads || nr_threads < def_rgcount)
+		goto out;
+
+	/*
+	 * Let's try matching the number of rtgroups to the number of CPUs.  If
+	 * the proposed geometry results in rtgroups smaller than 4GB, reduce
+	 * the rtgroup count until we have 4GB rtgroups.  Don't let the thread
+	 * count go below the default geometry calculation.
+	 */
+	try_threads = nr_threads;
+	try_rgsize = cfg->rtblocks / try_threads;
+	if (try_rgsize < GIGABYTES(4, cfg->blocklog)) {
+		do {
+			try_threads--;
+			if (try_threads <= def_rgcount) {
+				try_rgsize = def_rgsize;
+				goto out;
+			}
+
+			try_rgsize = cfg->rtblocks / try_threads;
+		} while (try_rgsize < GIGABYTES(4, cfg->blocklog));
+		goto out;
+	}
+
+	/*
+	 * For large filesystems we try to ensure that the rtgroup count is a
+	 * multiple of the desired thread count.  Specifically, if the proposed
+	 * rtgroup size is larger than both the maximum rtgroup size and the
+	 * rtgroup size we would have gotten with the defaults, add the thread
+	 * count to the rtgroup count until we get an rtgroup size below both
+	 * of those factors.
+	 */
+	while (try_rgsize > XFS_MAX_RGBLOCKS && try_rgsize > def_rgsize) {
+		try_threads += nr_threads;
+		try_rgsize = cfg->dblocks / try_threads;
+	}
+
+out:
+	cfg->rgsize = try_rgsize;
+	cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
+}
+
 static void
 calculate_rtgroup_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli)
+	struct cli_params	*cli,
+	struct libxfs_init	*xi)
 {
 	if (!cli->sb_feat.metadir) {
 		cfg->rgcount = 0;
@@ -3783,6 +3913,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 		/* too small even for a single group */
 		cfg->rgsize = cfg->rtblocks;
 		cfg->rgcount = 0;
+	} else if (cli->rtvol_concurrency > 0 ||
+		   (cli->data_concurrency == -1 && rtdev_is_solidstate(xi))) {
+		calc_concurrency_rtgroup_geometry(cfg, cli, xi);
 	} else if (is_power_of_2(cfg->rtextblocks)) {
 		cfg->rgsize = calc_rgsize_extsize_power(cfg);
 		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
@@ -4890,6 +5023,7 @@ main(
 		.is_supported	= 1,
 		.data_concurrency = -1, /* auto detect non-mechanical storage */
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
+		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
 		.autofsck = FSPROP_AUTOFSCK_UNSET,
 	};
 	struct mkfs_params	cfg = {};
@@ -5077,7 +5211,7 @@ main(
 	 */
 	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
-	calculate_rtgroup_geometry(&cfg, &cli);
+	calculate_rtgroup_geometry(&cfg, &cli, &xi);
 
 	calculate_imaxpct(&cfg, &cli);
 

