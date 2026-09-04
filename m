Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68672367F3A
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485512; cv=none; b=XfTyHB/d0qegA1vrfQbjGgKMz98CrtrZ8D7PN5XbZ7oAIOE5gDVkrx3ygpsOV9Y/JfW1AwvXm5Q08EtlJMjE1zO5oTovaJwO+IjV5sMdBqwfVWqHdYZmk8z6MH+oQKRDuSGkLf5J0RPjgFHWPWb95+EEjwllr7NQjs6XF9dHBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485512; c=relaxed/simple;
	bh=yRD2LKyykRDk3wqOuhn8V2j9qhqZiW3Sz+iHoNzauJc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sh800dipVaJzHtN+eNRNcHWfLqWZxq7my/LhKmiD34EU4hZVh8mI8HY+tqw9+PTx+uytEdwzNDp8S6HwsF7RsTetWNo5QY0AG0Mr0Cw7/E3qjMzcqWvAyrUtCaKB4YQS8hxzrCEWGhT0nQY5WOSnZfCjpssgxp60H+002v5fC58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TclHJEaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TclHJEaU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12A321F000E9;
	Fri,  4 Sep 2026 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485511;
	bh=ApeTq/c2bh8MxlPAbwqyxCpj7evJre/XoK84QqnjMao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=TclHJEaUWR7y4s4nLOiILXc7xyHDr8uwJj/GwwLII7KiOWBTCA3YM82yu8X1HnCfo
	 8t+sUNH38PaRw2Et7Bsd3bD9B6uVgquyTg33CPBHKJkC1oMDWRJzr1gEqbzP7k3mbO
	 QG/LsYQFUjOQmt5d3rc5WvLlo1Cwk5939PLueUM4FxI5+R1+c4R9oWI9MtoiPHcejI
	 6p3mSt2OEGFW5cENXfapvv0TysT6VJv3e/caJhh2SJfVoAOewTuD30H7LcFaHRky1w
	 zixFhDxT94o8bDLFZPQGXnsW7H7qNKZFg2yh94K2/MmYTp4tgmAcYbTdfJ2mrOG0HL
	 ZeBSNY8ISqyrg==
Date: Thu, 03 Sep 2026 18:31:50 -0700
Subject: [PATCH 8/8] mkfs: allow specification of default options via
 configuration file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@infradead.org, tytso@mit.edu, linux-xfs@vger.kernel.org
Message-ID: <178848535005.1052910.13292787681188923824.stgit@frogsfrogsfrogs>
In-Reply-To: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
References: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Ted asked for the ability to set default mkfs options, but to retain the
ability respecify options via a separate configuration file or cli
options.  This would be useful for running fstests with the default
featureset of (say) Linux 5.15 LTS, while still allowing individual
testcases to provide their own overrides.  It's certainly less messy
than what Ted does today, which is a bash script that copies the desired
config file and changes things.

Cc: tytso@mit.edu
Cc: hch@infradead.org
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in |   16 ++++-
 mkfs/xfs_mkfs.c        |  160 ++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 153 insertions(+), 23 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index f28f668a1e7e68..521b73bed8c747 100644
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
 .BI makecfg= path
 Write a configuration file to the file specified by the
 .I path
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5c45e0248d1de6..7c81f5a975532e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -62,6 +62,7 @@ enum {
 enum {
 	C_OPTFILE = 0,
 	C_MAKECFG,
+	C_DEFOPTFILE,
 	C_MAX_OPTS,
 };
 
@@ -314,6 +315,7 @@ static struct opt_params copts = {
 	.subopts = {
 		[C_OPTFILE] = "options",
 		[C_MAKECFG] = "makecfg",
+		[C_DEFOPTFILE] = "defaults",
 		[C_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -325,6 +327,10 @@ static struct opt_params copts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .defaultval = 1,
 		},
+		{ .index = C_DEFOPTFILE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
 	},
 };
 
@@ -1077,6 +1083,7 @@ struct cli_params {
 	int	blocksize;
 
 	char	*cfgfile;
+	char	*defcfgfile;
 	char	*protofile;
 	char	*makecfg;
 
@@ -1214,7 +1221,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* config file */	[-c options=path,makecfg=path\n\
+/* config file */	[-c options=path,makecfg=path,defaults=path\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
 			    inobtcount=0|1,bigtime=0|1,autofsck=xxx,\n\
 			    metadir=0|1]\n\
@@ -1800,6 +1807,30 @@ cfgfile_opts_parser(
 		else
 			cli->makecfg = getstr(value, opts, subopt);
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
+	case C_MAKECFG:
+		/* will be processed by cfgfile_opts_parser; ignored */
+		break;
+	case C_DEFOPTFILE:
+		cli->defcfgfile = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2266,13 +2297,15 @@ sector_opts_parser(
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
@@ -2286,15 +2319,21 @@ static struct subopts {
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
@@ -2306,7 +2345,8 @@ parse_subopts(
 	if (!sop->opts)
 		return;
 
-	p = arg;
+	/* getsubopt modifies duparg */
+	p = duparg = strdup(arg);
 	while (*p != '\0') {
 		char	**subopts = (char **)sop->opts->subopts;
 		char	*value;
@@ -2318,19 +2358,20 @@ parse_subopts(
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
@@ -5789,6 +5830,64 @@ cfgfile_parse(
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
@@ -5938,6 +6037,17 @@ check_rt_meta_prealloc(
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
@@ -6044,8 +6154,16 @@ main(
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
@@ -6063,7 +6181,7 @@ main(
 		case 'p':
 		case 'r':
 		case 's':
-			parse_subopts(c, optarg, &cli);
+			parse_subopts(c, optarg, subopt_tab, &cli);
 			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))

