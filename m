Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239693FE65D
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 15:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778771215; cv=none; b=rf3IkFTd/dSRbrHVg/NgVtJwIRF/QL9coaP+sc8OR5ALWU2/Tg0A/jeHuyc+Ko9ETYPTsXnls+FTsan5WHqbvJlc2v8O7OD0SAHZmUVho/nxEZ6xVTjbnwEI2uV0YvYfwbw2gTnuelnu/FfzfAkNSkS+85Y6AYslldjSju/LESw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778771215; c=relaxed/simple;
	bh=qgRgxo6+ng4u9EOm+aim6Nh/f2yEaB5qvM5hRq2lXks=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DUnhg8tSkxUwfOkf2CrBQRw5JrDZ5cWFCrKx8+ioT+hfPB7PMrCwcNXFTy16meXVHALfDEmzLZwSxbQBFmnpR3te69/kzt0LKjuuuyC4M5rO3w3uVdCE+GSTLhboThxBvDAFamy8Nhvx7fvkT8wYiXvzVyFAaHTNAHR9pwHEJmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JsYtasy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JsYtasy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EF2C2BCB3;
	Thu, 14 May 2026 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778771214;
	bh=qgRgxo6+ng4u9EOm+aim6Nh/f2yEaB5qvM5hRq2lXks=;
	h=Date:From:To:Cc:Subject:From;
	b=JsYtasy8hbYtv/mHeK0NpYxHjvabXyBjFpF8HZD7c+y2DXJgH53eGS2d+LbQcMP2H
	 1kCIYKQcH1kwRSqaeTE6qrWwo2io1O8DklDqfjfhW09uwOgS7UmKwn4jILXy/4HnkP
	 nkdIWSd7ErlYnsnGAEVroHrfA2vDc434vGD4rBwoMjYF5mDMyE+qfQzFH9+ZcLqHOk
	 bD46OMsXE4YXMyRJvdSMT+AFZi+QteVX5PLOnBZYIABgJvDvzLngIbjqv0ydOyW7B0
	 ZxDn/gc0ohtJ+N+VFnax66VvhyoZIZsyn6piSZmVbKw8CXnjYe/xVUfcTKKMq1A3J1
	 X4ngAqCWuJFeg==
Date: Thu, 14 May 2026 08:06:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, linux-xfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
Subject: [RFC PATCH] mkfs: allow specification of default options via
 configuration file
Message-ID: <20260514150653.GW9555@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Ted asked for the ability to set default mkfs options, but to retain the
ability respecify options via a separate configuration file or cli
options.  This would be useful for running fstests with the default
featureset of (say) Linux 5.15 LTS, while still allowing individual
testcases to provide their own overrides.  It's certainly less messy
than what Ted does today, which is a bash script that copies the desired
config file and changes things.

Cc: tytso@mit.edu
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   16 ++++-
 mkfs/xfs_mkfs.c        |  159 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 152 insertions(+), 23 deletions(-)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index fbafc5c79e02de..a564e6c2b15210 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -152,10 +152,22 @@ .SH OPTIONS
 .BI \-c " configuration_file_option"
 This option specifies the files that mkfs configuration will be obtained from.
 The valid
-.I configuration_file_option
-is:
+.I configuration_file_options
+are:
 .RS 1.2i
 .TP
+.BI defaults= name
+Default configuration options will be sourced from the file specified by the
+.I name
+option string.
+This option can be use either an absolute or relative path to the configuration
+file to be read.
+Sample configuration files can be found in @mkfs_cfg_dir@.
+Options specified through the default configuration file can be overridden by
+a configuration file specified via
+.B options=
+or command line arguments, in that order.
+.TP
 .BI options= name
 The configuration options will be sourced from the file specified by the
 .I name
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd8a48c3633ef0..a3973c5aa1e3f0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -62,6 +62,7 @@ enum {
 
 enum {
 	C_OPTFILE = 0,
+	C_DEFOPTFILE,
 	C_MAX_OPTS,
 };
 
@@ -313,6 +314,7 @@ static struct opt_params copts = {
 	.name = 'c',
 	.subopts = {
 		[C_OPTFILE] = "options",
+		[C_DEFOPTFILE] = "defaults",
 		[C_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -320,6 +322,10 @@ static struct opt_params copts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = C_DEFOPTFILE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1072,6 +1078,7 @@ struct cli_params {
 	int	blocksize;
 
 	char	*cfgfile;
+	char	*defcfgfile;
 	char	*protofile;
 
 	enum fsprop_autofsck autofsck;
@@ -1208,7 +1215,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* config file */	[-c options=xxx]\n\
+/* config file */	[-c defaults=xxx,options=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
 			    inobtcount=0|1,bigtime=0|1,autofsck=xxx,\n\
 			    metadir=0|1]\n\
@@ -1788,6 +1795,29 @@ cfgfile_opts_parser(
 	case C_OPTFILE:
 		cli->cfgfile = getstr(value, opts, subopt);
 		break;
+	case C_DEFOPTFILE:
+		/* already processed by defcfgfile_opts_parser; ignored */
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int
+defcfgfile_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	const char		*value,
+	struct cli_params	*cli)
+{
+	switch (subopt) {
+	case C_OPTFILE:
+		/* will be processed by cfgfile_opts_parser; ignored */
+		break;
+	case C_DEFOPTFILE:
+		cli->defcfgfile = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2254,13 +2284,15 @@ sector_opts_parser(
 	return 0;
 }
 
-static struct subopts {
+struct subopts {
 	struct opt_params *opts;
 	int		(*parser)(struct opt_params	*opts,
 				  int			subopt,
 				  const char		*value,
 				  struct cli_params	*cli);
-} subopt_tab[] = {
+};
+
+static const struct subopts subopt_tab[] = {
 	{ &bopts, block_opts_parser },
 	{ &copts, cfgfile_opts_parser },
 	{ &dopts, data_opts_parser },
@@ -2274,15 +2306,21 @@ static struct subopts {
 	{ NULL, NULL },
 };
 
+static const struct subopts defcfg_subopt_tab[] = {
+	{ &copts, defcfgfile_opts_parser },
+	{ NULL, NULL },
+};
+
 static void
 parse_subopts(
-	char		opt,
-	char		*arg,
-	struct cli_params *cli)
+	char			opt,
+	char			*arg,
+	const struct subopts	*stab,
+	struct cli_params	*cli)
 {
-	struct subopts	*sop = &subopt_tab[0];
-	char		*p;
-	int		ret = 0;
+	const struct subopts	*sop = stab;
+	char			*p, *duparg;
+	int			ret = 0;
 
 	while (sop->opts) {
 		if (sop->opts->name == opt)
@@ -2294,7 +2332,8 @@ parse_subopts(
 	if (!sop->opts)
 		return;
 
-	p = arg;
+	/* getsubopt modifies duparg */
+	p = duparg = strdup(arg);
 	while (*p != '\0') {
 		char	**subopts = (char **)sop->opts->subopts;
 		char	*value;
@@ -2306,19 +2345,20 @@ parse_subopts(
 		if (ret)
 			unknown(opt, value);
 	}
+	free(duparg);
 }
 
 static bool
 parse_cfgopt(
-	const char	*section,
-	const char	*name,
-	const char	*value,
-	struct cli_params *cli)
+	const char		*section,
+	const char		*name,
+	const char		*value,
+	struct cli_params	*cli)
 {
-	struct subopts	*sop = &subopt_tab[0];
-	char		**subopts;
-	int		ret = 0;
-	int		i;
+	const struct subopts	*sop = &subopt_tab[0];
+	char			**subopts;
+	int			ret = 0;
+	int			i;
 
 	while (sop->opts) {
 		if (sop->opts->ini_section[0] != '\0' &&
@@ -5777,6 +5817,64 @@ cfgfile_parse(
 		cli->cfgfile);
 }
 
+static void
+reset_seen(
+	struct opt_params	*opts)
+{
+	unsigned int		i;
+
+	for (i = 0; i < MAX_SUBOPTS; i++) {
+		opts->subopt_params[i].seen = false;
+		opts->subopt_params[i].str_seen = false;
+	}
+}
+
+static void
+defcfgfile_parse(
+	struct cli_params	*cli)
+{
+	int			error;
+
+	if (!cli->defcfgfile)
+		return;
+
+	error = ini_parse(cli->defcfgfile, cfgfile_parse_ini, cli);
+	if (error) {
+		if (error > 0) {
+			fprintf(stderr,
+		_("%s: Unrecognised input on line %d. Aborting.\n"),
+				cli->defcfgfile, error);
+		} else if (error == -1) {
+			fprintf(stderr,
+		_("Unable to open defaults config file %s. Aborting.\n"),
+				cli->defcfgfile);
+		} else if (error == -2) {
+			fprintf(stderr,
+		_("Memory allocation failure parsing %s. Aborting.\n"),
+				cli->defcfgfile);
+		} else {
+			fprintf(stderr,
+		_("Unknown error %d opening defaults config file %s. Aborting.\n"),
+				error, cli->defcfgfile);
+		}
+		exit(1);
+	}
+	printf(_("Parameters parsed from defaults config file %s successfully\n"),
+		cli->defcfgfile);
+
+	/* Now make it look like we haven't seen any cli options. */
+	reset_seen(&bopts);
+	reset_seen(&copts);
+	reset_seen(&dopts);
+	reset_seen(&iopts);
+	reset_seen(&lopts);
+	reset_seen(&mopts);
+	reset_seen(&nopts);
+	reset_seen(&popts);
+	reset_seen(&ropts);
+	reset_seen(&sopts);
+}
+
 static void
 set_autofsck(
 	struct xfs_mount	*mp,
@@ -5926,6 +6024,17 @@ check_rt_meta_prealloc(
 	mp->m_finobt_nores = false;
 }
 
+static inline int
+getopt_mkfs(
+	int			argc,
+	char *const		argv[],
+	const struct option	*longopts,
+	int			*longindex)
+{
+	return getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+			longopts, longindex);
+}
+
 int
 main(
 	int			argc,
@@ -6032,8 +6141,16 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
-					long_options, &option_index)) != EOF) {
+	/* Load default configuration, if specified */
+	while ((c = getopt_mkfs(argc, argv, long_options, &option_index)) != EOF) {
+		if (c == 'c') {
+			parse_subopts(c, optarg, defcfg_subopt_tab, &cli);
+		}
+	}
+	defcfgfile_parse(&cli);
+	optind = 1;
+
+	while ((c = getopt_mkfs(argc, argv, long_options, &option_index)) != EOF) {
 		switch (c) {
 		case 0:
 			break;
@@ -6051,7 +6168,7 @@ main(
 		case 'p':
 		case 'r':
 		case 's':
-			parse_subopts(c, optarg, &cli);
+			parse_subopts(c, optarg, subopt_tab, &cli);
 			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))
