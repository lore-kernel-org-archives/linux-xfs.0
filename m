Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3631CBE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngbzq0Iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C330AC433C8;
	Sun, 31 Dec 2023 22:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060294;
	bh=Ou/c6s4JR8xItBjNG8GnDGmLsM9aP0ncSPHcVparYB4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ngbzq0IvITZ91qQoE9BW3bEZ6d/RSlwXK8+z/jKQRsYXM823T+eT+DptM4+/RyP7N
	 kz3z4t3HeKg2ADCH9cjtzjuwFiw6CJvrcyt57mBeNOSDE8321QZahvi1wH1UxiGySz
	 V5Idj1vmS9hDMu0rvQ8YfbnlcMIjBhTdxqG7jEQrh8cOU72h5T90+HdJBnAQ22wDnA
	 qK8lAoKhunphLevc7BvtvGgMT0b9rEDiHZjTOLy5xxObvA6lSk+8ZArWrnY2jZ5z3W
	 1MBne6HPx/duuhOQxPq/3zJOdj69QT7ku2FOp3ogNhaA2qCOuUVbtCez/fAMIWJ8yM
	 ueXHNCw6kc6hA==
Date: Sun, 31 Dec 2023 14:04:54 -0800
Subject: [PATCH 1/2] mkfs: allow sizing allocation groups for concurrency
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404989437.1791433.58561592257201816.stgit@frogsfrogsfrogs>
In-Reply-To: <170404989423.1791433.6933477036695309956.stgit@frogsfrogsfrogs>
References: <170404989423.1791433.6933477036695309956.stgit@frogsfrogsfrogs>
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

Add a -d concurrency= option to mkfs so that sysadmins can configure the
filesystem so that there are enough allocation groups that the specified
number of threads can (in theory) can find an uncontended group to
allocate space from.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   27 +++++++++
 mkfs/xfs_mkfs.c        |  150 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 173 insertions(+), 4 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index c152546a47d..b18daa23395 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -504,6 +504,33 @@ directories.
 By default,
 .B mkfs.xfs
 will not enable DAX mode.
+.TP
+.BI concurrency= value
+Create enough allocation groups to handle the desired level of concurrency.
+The goal of this calculation scheme is to set the number of allocation groups
+to an integer multiple of the number of writer threads desired, to minimize
+contention of AG locks.
+This scheme will neither create fewer AGs than would be created by the default
+configuration, nor will it create AGs smaller than 4GB.
+This option is not compatible with the
+.B agcount
+or
+.B agsize
+options.
+The magic value
+.I nr_cpus
+or
+.I 1
+or no value at all will set this parameter to the number of active processors
+in the system.
+If the kernel advertises that the data device is a non-mechanical storage
+device,
+.B mkfs.xfs
+will use this new geometry calculation scheme.
+The magic value of
+.I 0
+forces use of the older AG geometry calculations that is used for mechanical
+storage.
 .RE
 .TP
 .B \-f
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f29f902982d..fbe40b7edf1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -77,6 +77,7 @@ enum {
 	D_EXTSZINHERIT,
 	D_COWEXTSIZE,
 	D_DAXINHERIT,
+	D_CONCURRENCY,
 	D_MAX_OPTS,
 };
 
@@ -318,11 +319,13 @@ static struct opt_params dopts = {
 		[D_EXTSZINHERIT] = "extszinherit",
 		[D_COWEXTSIZE] = "cowextsize",
 		[D_DAXINHERIT] = "daxinherit",
+		[D_CONCURRENCY] = "concurrency",
 		[D_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
 		{ .index = D_AGCOUNT,
 		  .conflicts = { { &dopts, D_AGSIZE },
+				 { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 1,
 		  .maxval = XFS_MAX_AGNUMBER,
@@ -365,6 +368,7 @@ static struct opt_params dopts = {
 		},
 		{ .index = D_AGSIZE,
 		  .conflicts = { { &dopts, D_AGCOUNT },
+				 { &dopts, D_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = XFS_AG_MIN_BYTES,
@@ -440,6 +444,14 @@ static struct opt_params dopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = D_CONCURRENCY,
+		  .conflicts = { { &dopts, D_AGCOUNT },
+				 { &dopts, D_AGSIZE },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = INT_MAX,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -891,6 +903,7 @@ struct cli_params {
 	int	lsunit;
 	int	is_supported;
 	int	proto_slashes_are_spaces;
+	int	data_concurrency;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -993,7 +1006,7 @@ usage( void )
 			    inobtcount=0|1,bigtime=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
-			    sectsize=num\n\
+			    sectsize=num,concurrency=num]\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
 			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
@@ -1090,6 +1103,19 @@ invalid_cfgfile_opt(
 		filename, section, name, value);
 }
 
+static int
+nr_cpus(void)
+{
+	static long	cpus = -1;
+
+	if (cpus < 0)
+		cpus = sysconf(_SC_NPROCESSORS_ONLN);
+	if (cpus < 0)
+		return 0;
+
+	return min(INT_MAX, cpus);
+}
+
 static void
 check_device_type(
 	struct libxfs_dev	*dev,
@@ -1544,6 +1570,30 @@ cfgfile_opts_parser(
 	return 0;
 }
 
+static void
+set_data_concurrency(
+	struct opt_params	*opts,
+	int			subopt,
+	struct cli_params	*cli,
+	const char		*value)
+{
+	long long		optnum;
+
+	/*
+	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
+	 * If this cannot be determined, fall back to the default AG geometry.
+	 */
+	if (!strcmp(value, "nr_cpus"))
+		optnum = 1;
+	else
+		optnum = getnum(value, opts, subopt);
+
+	if (optnum == 1)
+		cli->data_concurrency = nr_cpus();
+	else
+		cli->data_concurrency = optnum;
+}
+
 static int
 data_opts_parser(
 	struct opt_params	*opts,
@@ -1615,6 +1665,9 @@ data_opts_parser(
 		else
 			cli->fsx.fsx_xflags &= ~FS_XFLAG_DAX;
 		break;
+	case D_CONCURRENCY:
+		set_data_concurrency(opts, subopt, cli, value);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -3034,12 +3087,98 @@ _("cannot have an rt subvolume with zero extents\n"));
 						NBBY * cfg->blocksize);
 }
 
+static bool
+ddev_is_solidstate(
+	struct libxfs_init	*xi)
+{
+	unsigned short		rotational = 1;
+	int			error;
+
+	error = ioctl(xi->data.fd, BLKROTATIONAL, &rotational);
+	if (error)
+		return false;
+
+	return rotational == 0;
+}
+
+static void
+calc_concurrency_ag_geometry(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct libxfs_init	*xi)
+{
+	uint64_t		try_agsize;
+	uint64_t		def_agsize;
+	uint64_t		def_agcount;
+	int			nr_threads = cli->data_concurrency;
+	int			try_threads;
+
+	calc_default_ag_geometry(cfg->blocklog, cfg->dblocks, cfg->dsunit,
+			&def_agsize, &def_agcount);
+	try_agsize = def_agsize;
+
+	/*
+	 * If the caller doesn't have a particular concurrency level in mind,
+	 * set it to the number of CPUs in the system.
+	 */
+	if (nr_threads < 0)
+		nr_threads = nr_cpus();
+
+	/*
+	 * Don't create fewer AGs than what we would create with the default
+	 * geometry calculation.
+	 */
+	if (!nr_threads || nr_threads < def_agcount)
+		goto out;
+
+	/*
+	 * Let's try matching the number of AGs to the number of CPUs.  If the
+	 * proposed geometry results in AGs smaller than 4GB, reduce the AG
+	 * count until we have 4GB AGs.  Don't let the thread count go below
+	 * the default geometry calculation.
+	 */
+	try_threads = nr_threads;
+	try_agsize = cfg->dblocks / try_threads;
+	if (try_agsize < GIGABYTES(4, cfg->blocklog)) {
+		do {
+			try_threads--;
+			if (try_threads <= def_agcount) {
+				try_agsize = def_agsize;
+				goto out;
+			}
+
+			try_agsize = cfg->dblocks / try_threads;
+		} while (try_agsize < GIGABYTES(4, cfg->blocklog));
+		goto out;
+	}
+
+	/*
+	 * For large filesystems we try to ensure that the AG count is a
+	 * multiple of the desired thread count.  Specifically, if the proposed
+	 * AG size is larger than both the maximum AG size and the AG size we
+	 * would have gotten with the defaults, add the thread count to the AG
+	 * count until we get an AG size below both of those factors.
+	 */
+	while (try_agsize > XFS_AG_MAX_BLOCKS(cfg->blocklog) &&
+	       try_agsize > def_agsize) {
+		try_threads += nr_threads;
+		try_agsize = cfg->dblocks / try_threads;
+	}
+
+out:
+	cfg->agsize = try_agsize;
+	cfg->agcount = howmany(cfg->dblocks, cfg->agsize);
+}
+
 static void
 calculate_initial_ag_geometry(
 	struct mkfs_params	*cfg,
-	struct cli_params	*cli)
+	struct cli_params	*cli,
+	struct libxfs_init	*xi)
 {
-	if (cli->agsize) {		/* User-specified AG size */
+	if (cli->data_concurrency > 0) {
+		calc_concurrency_ag_geometry(cfg, cli, xi);
+	} else if (cli->agsize) {	/* User-specified AG size */
 		cfg->agsize = getnum(cli->agsize, &dopts, D_AGSIZE);
 
 		/*
@@ -3059,6 +3198,8 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
 		cfg->agcount = cli->agcount;
 		cfg->agsize = cfg->dblocks / cfg->agcount +
 				(cfg->dblocks % cfg->agcount != 0);
+	} else if (cli->data_concurrency == -1 && ddev_is_solidstate(xi)) {
+		calc_concurrency_ag_geometry(cfg, cli, xi);
 	} else {
 		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
 					 cfg->dsunit, &cfg->agsize,
@@ -4060,6 +4201,7 @@ main(
 		.xi = &xi,
 		.loginternal = 1,
 		.is_supported	= 1,
+		.data_concurrency = -1, /* auto detect non-mechanical storage */
 	};
 	struct mkfs_params	cfg = {};
 
@@ -4244,7 +4386,7 @@ main(
 	 * dependent on device sizes. Once calculated, make sure everything
 	 * aligns to device geometry correctly.
 	 */
-	calculate_initial_ag_geometry(&cfg, &cli);
+	calculate_initial_ag_geometry(&cfg, &cli, &xi);
 	align_ag_geometry(&cfg);
 
 	calculate_imaxpct(&cfg, &cli);

