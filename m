Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50424128816
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423439; cv=none; b=HOWV/HQT0+Piltt3GjIcToEYyzK4iD5pIoRYB2Fnhx7+K/tIOa5y/LSj1ZjTjTTk2h+Nk0rrYEUdTzon07KoKbBSElgbelhsWmlFNovRS8sSVulzkgG86g0LIMNhj2GJiDlgxHrm3ueJYFYa4MDUWmWaw0NoCAodKkml5zco2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423439; c=relaxed/simple;
	bh=3QVK3+BuCn/LKnfh/nGoWnaFGkXXqLTPmUFFOgUat84=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mrDcA2fENxwPO150pbUUIgDOsR9UUJ/bImFl0l1uMydu2WpfOo+UAZoQkRFWzpFtPOdoswYDlU4JUmlGnhMgssyHLBzOkkOntMZNkNnucqQGPJiSrIqnH6HGJHArO4Puej9xBoswF/gEtp9Cjp8YIFMtz9rl9AlN1ViA0r+ayA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KB6AWTdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB6AWTdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07A6C433F1;
	Tue, 26 Mar 2024 03:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423438;
	bh=3QVK3+BuCn/LKnfh/nGoWnaFGkXXqLTPmUFFOgUat84=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KB6AWTdhUe+IGquzQ8C3doMlMRTpi3QVQYGUzX6c0ynWNC+Mcst/1+T06deu+ybA1
	 X6ky4WosCKwqfxTvLc2XpFFWXCsudHENls4V5/C72zSgAtUDMcpRwgmahlnpNCiynj
	 KPoUBaHVrIiOyoBvfkq2IcO7UbtU8zJJ2X0EMUOwoaxz3DQnunx9URvw+r7WSdLZwp
	 5fONM5RaQiEaN7N7J7RT0Ba4iOWDMcSBrxaEoX8Q6iQC1IsaWQUuu8gYlmPvVzKnFS
	 +KUqKCQC9K+Xd+xamlAQb/K51g/X135cu42Aj0zsJgW85LM0id2etF4wLFaQrPWrI2
	 OJs+HBBrk1suA==
Date: Mon, 25 Mar 2024 20:23:58 -0700
Subject: [PATCH 2/2] mkfs: allow sizing internal logs for concurrency
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142129352.2214436.10995524273270045851.stgit@frogsfrogsfrogs>
In-Reply-To: <171142129320.2214436.15874795221168392835.stgit@frogsfrogsfrogs>
References: <171142129320.2214436.15874795221168392835.stgit@frogsfrogsfrogs>
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

Add a -l option to mkfs so that sysadmins can configure the filesystem
so that the log can handle a certain number of transactions (front and
backend) without any threads contending for log grant space.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 man/man8/mkfs.xfs.8.in |   19 +++++++++
 mkfs/xfs_mkfs.c        |  101 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 118 insertions(+), 2 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index b18daa233959..8060d342c2a4 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -795,6 +795,25 @@ if you want to disable this feature for older kernels which don't support
 it.
 .IP
 This option is only tunable on the deprecated V4 format.
+.TP
+.BI concurrency= value
+Allocate a log that is estimated to be large enough to handle the desired level
+of concurrency without userspace program threads contending for log space.
+This scheme will neither create a log smaller than the minimum required,
+nor create a log larger than the maximum possible.
+This option is only valid for internal logs and is not compatible with the
+size option.
+This option is not compatible with the
+.B logdev
+or
+.B size
+options.
+The magic value
+.I nr_cpus
+or
+.I 1
+or no value at all will set this parameter to the number of active processors
+in the system.
 .RE
 .PP
 .PD 0
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f69a4a1dac9b..f4a9bf20f391 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -105,6 +105,7 @@ enum {
 	L_FILE,
 	L_NAME,
 	L_LAZYSBCNTR,
+	L_CONCURRENCY,
 	L_MAX_OPTS,
 };
 
@@ -541,6 +542,7 @@ static struct opt_params lopts = {
 		[L_FILE] = "file",
 		[L_NAME] = "name",
 		[L_LAZYSBCNTR] = "lazy-count",
+		[L_CONCURRENCY] = "concurrency",
 		[L_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -561,7 +563,8 @@ static struct opt_params lopts = {
 		  .defaultval = 1,
 		},
 		{ .index = L_SIZE,
-		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .conflicts = { { &lopts, L_CONCURRENCY },
+				 { NULL, LAST_CONFLICT } },
 		  .convert = true,
 		  .minval = 2 * 1024 * 1024LL,	/* XXX: XFS_MIN_LOG_BYTES */
 		  .maxval = XFS_MAX_LOG_BYTES,
@@ -592,6 +595,7 @@ static struct opt_params lopts = {
 		  .conflicts = { { &lopts, L_AGNUM },
 				 { &lopts, L_NAME },
 				 { &lopts, L_INTERNAL },
+				 { &lopts, L_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
@@ -606,6 +610,7 @@ static struct opt_params lopts = {
 		},
 		{ .index = L_FILE,
 		  .conflicts = { { &lopts, L_INTERNAL },
+				 { &lopts, L_CONCURRENCY },
 				 { NULL, LAST_CONFLICT } },
 		  .minval = 0,
 		  .maxval = 1,
@@ -624,6 +629,15 @@ static struct opt_params lopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = L_CONCURRENCY,
+		  .conflicts = { { &lopts, L_SIZE },
+				 { &lopts, L_FILE },
+				 { &lopts, L_DEV },
+				 { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = INT_MAX,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -904,6 +918,7 @@ struct cli_params {
 	int	is_supported;
 	int	proto_slashes_are_spaces;
 	int	data_concurrency;
+	int	log_concurrency;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -1012,7 +1027,8 @@ usage( void )
 			    projid32bit=0|1,sparse=0|1,nrext64=0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
-			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
+			    sunit=value|su=num,sectsize=num,lazy-count=0|1,\n\
+			    concurrency=num]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
 /* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
 /* no-op info only */	[-N]\n\
@@ -1712,6 +1728,30 @@ inode_opts_parser(
 	return 0;
 }
 
+static void
+set_log_concurrency(
+	struct opt_params	*opts,
+	int			subopt,
+	const char		*value,
+	struct cli_params	*cli)
+{
+	long long		optnum;
+
+	/*
+	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
+	 * this cannot be determined, fall back to the default computation.
+	 */
+	if (!strcmp(value, "nr_cpus"))
+		optnum = 1;
+	else
+		optnum = getnum(value, opts, subopt);
+
+	if (optnum == 1)
+		cli->log_concurrency = nr_cpus();
+	else
+		cli->log_concurrency = optnum;
+}
+
 static int
 log_opts_parser(
 	struct opt_params	*opts,
@@ -1752,6 +1792,9 @@ log_opts_parser(
 	case L_LAZYSBCNTR:
 		cli->sb_feat.lazy_sb_counters = getnum(value, opts, subopt);
 		break;
+	case L_CONCURRENCY:
+		set_log_concurrency(opts, subopt, value, cli);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -3602,6 +3645,48 @@ _("internal log size %lld too large, must be less than %d\n"),
 	cfg->logblocks = min(cfg->logblocks, *max_logblocks);
 }
 
+static uint64_t
+calc_concurrency_logblocks(
+	struct mkfs_params	*cfg,
+	struct cli_params	*cli,
+	struct libxfs_init	*xi,
+	unsigned int		max_tx_bytes)
+{
+	uint64_t		log_bytes;
+	uint64_t		logblocks = cfg->logblocks;
+	unsigned int		new_logblocks;
+
+	if (cli->log_concurrency < 0) {
+		if (!ddev_is_solidstate(xi))
+			goto out;
+
+		cli->log_concurrency = nr_cpus();
+	}
+	if (cli->log_concurrency == 0)
+		goto out;
+
+	/*
+	 * If this filesystem is smaller than a gigabyte, there's little to be
+	 * gained from making the log larger.
+	 */
+	if (cfg->dblocks < GIGABYTES(1, cfg->blocklog))
+		goto out;
+
+	/*
+	 * Create a log that is large enough to handle simultaneous maximally
+	 * sized transactions at the concurrency level specified by the user
+	 * without blocking for space.  Increase the figure by 50% so that
+	 * background threads can also run.
+	 */
+	log_bytes = max_tx_bytes * 3 * cli->log_concurrency / 2;
+	new_logblocks = min(XFS_MAX_LOG_BYTES >> cfg->blocklog,
+				log_bytes >> cfg->blocklog);
+
+	logblocks = max(logblocks, new_logblocks);
+out:
+	return logblocks;
+}
+
 static void
 calculate_log_size(
 	struct mkfs_params	*cfg,
@@ -3612,6 +3697,7 @@ calculate_log_size(
 	struct xfs_sb		*sbp = &mp->m_sb;
 	int			min_logblocks;	/* absolute minimum */
 	int			max_logblocks;	/* absolute max for this AG */
+	unsigned int		max_tx_bytes = 0;
 	struct xfs_mount	mount;
 	struct libxfs_init	dummy_init = { };
 
@@ -3620,6 +3706,12 @@ calculate_log_size(
 	mount.m_sb = *sbp;
 	libxfs_mount(&mount, &mp->m_sb, &dummy_init, 0);
 	min_logblocks = libxfs_log_calc_minimum_size(&mount);
+	if (cli->log_concurrency != 0) {
+		struct xfs_trans_res	res;
+
+		libxfs_log_get_max_trans_res(&mount, &res);
+		max_tx_bytes = res.tr_logres * res.tr_logcount;
+	}
 	libxfs_umount(&mount);
 
 	ASSERT(min_logblocks);
@@ -3682,6 +3774,10 @@ _("max log size %d smaller than min log size %d, filesystem is too small\n"),
 		cfg->logblocks = (cfg->dblocks << cfg->blocklog) / 2048;
 		cfg->logblocks = cfg->logblocks >> cfg->blocklog;
 
+		if (cli->log_concurrency != 0)
+			cfg->logblocks = calc_concurrency_logblocks(cfg, cli,
+							xi, max_tx_bytes);
+
 		/* But don't go below a reasonable size */
 		cfg->logblocks = max(cfg->logblocks,
 				XFS_MIN_REALISTIC_LOG_BLOCKS(cfg->blocklog));
@@ -4203,6 +4299,7 @@ main(
 		.loginternal = 1,
 		.is_supported	= 1,
 		.data_concurrency = -1, /* auto detect non-mechanical storage */
+		.log_concurrency = -1, /* auto detect non-mechanical ddev */
 	};
 	struct mkfs_params	cfg = {};
 

