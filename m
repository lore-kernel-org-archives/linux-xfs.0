Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C51C4363A
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3C7522241
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbgJOD3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:29:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37900 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgJOD3g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 23:29:36 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5C46058C5EC
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 14:29:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-000ecs-Td
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-006bfp-M1
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] mkfs: add initial ini format config file parsing support
Date:   Thu, 15 Oct 2020 14:29:22 +1100
Message-Id: <20201015032925.1574739-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015032925.1574739-1-david@fromorbit.com>
References: <20201015032925.1574739-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=ESCU3tP0QEuBFU1X8cMA:9
        a=k_fhcxyYy9mc_jaK:21 a=3rwEqbBk306j5-Ny:21
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Add the framework that will allow the config file to be supplied on
the CLI and passed to the library that will parse it. This does not
yet do any option parsing from the config file.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/Makefile   |   2 +-
 mkfs/xfs_mkfs.c | 115 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/mkfs/Makefile b/mkfs/Makefile
index 31482b08d559..b8805f7e1ea1 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,7 +11,7 @@ HFILES =
 CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID)
+	$(LIBUUID) $(LIBINIH)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8fe149d74b0a..e84be74fb100 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -11,6 +11,7 @@
 #include "libfrog/fsgeom.h"
 #include "libfrog/topology.h"
 #include "libfrog/convert.h"
+#include <ini.h>
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
@@ -44,6 +45,11 @@ enum {
 	B_MAX_OPTS,
 };
 
+enum {
+	C_OPTFILE = 0,
+	C_MAX_OPTS,
+};
+
 enum {
 	D_AGCOUNT = 0,
 	D_FILE,
@@ -237,6 +243,28 @@ static struct opt_params bopts = {
 	},
 };
 
+/*
+ * Config file specification. Usage is:
+ *
+ * mkfs.xfs -c file=<name>
+ *
+ * A subopt is used for the filename so in future we can extend the behaviour
+ * of the config file (e.g. specified defaults rather than options) if we ever
+ * have a need to do that sort of thing.
+ */
+static struct opt_params copts = {
+	.name = 'c',
+	.subopts = {
+		[C_OPTFILE] = "options",
+	},
+	.subopt_params = {
+		{ .index = C_OPTFILE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+	},
+};
+
 static struct opt_params dopts = {
 	.name = 'd',
 	.subopts = {
@@ -748,6 +776,8 @@ struct cli_params {
 	int	sectorsize;
 	int	blocksize;
 
+	char	*cfgfile;
+
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
@@ -862,6 +892,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
+/* config file */	[-c file=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
@@ -1385,6 +1416,23 @@ block_opts_parser(
 	return 0;
 }
 
+static int
+cfgfile_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	switch (subopt) {
+	case C_OPTFILE:
+		cli->cfgfile = getstr(value, opts, subopt);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 data_opts_parser(
 	struct opt_params	*opts,
@@ -1656,6 +1704,7 @@ static struct subopts {
 				  struct cli_params	*cli);
 } subopt_tab[] = {
 	{ 'b', &bopts, block_opts_parser },
+	{ 'c', &copts, cfgfile_opts_parser },
 	{ 'd', &dopts, data_opts_parser },
 	{ 'i', &iopts, inode_opts_parser },
 	{ 'l', &lopts, log_opts_parser },
@@ -3562,6 +3611,61 @@ check_root_ino(
 	}
 }
 
+/*
+ * INI file format option parser.
+ *
+ * This is called by the file parser library for every valid option it finds in
+ * the config file. The option is already broken down into a
+ * {section,name,value} tuple, so all we need to do is feed it to the correct
+ * suboption parser function and translate the return value.
+ *
+ * Returns 0 on failure, 1 for success.
+ */
+static int
+cfgfile_parse_ini(
+	void			*user,
+	const char		*section,
+	const char		*name,
+	const char		*value)
+{
+	struct cli_params	*cli = user;
+
+	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
+		cli->cfgfile, section, name, value);
+
+	return 1;
+}
+
+void
+cfgfile_parse(
+	struct cli_params	*cli)
+{
+	int			error;
+
+	if (!cli->cfgfile)
+		return;
+
+	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
+	if (error) {
+		if (error > 0) {
+			fprintf(stderr,
+		_("%s: Unrecognised input on line %d. Aborting.\n"),
+				cli->cfgfile, error);
+		} else if (error == -2) {
+			fprintf(stderr,
+		_("Memory allocation failure parsing %s. Aborting.\n"),
+				cli->cfgfile);
+		} else {
+			fprintf(stderr,
+		_("Unable to open config file %s. Aborting.\n"),
+				cli->cfgfile);
+		}
+		exit(1);
+	}
+	printf(_("Parameters parsed from config file %s successfully\n"),
+		cli->cfgfile);
+}
+
 int
 main(
 	int			argc,
@@ -3648,13 +3752,14 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
 			break;
 		case 'b':
+		case 'c':
 		case 'd':
 		case 'i':
 		case 'l':
@@ -3698,6 +3803,14 @@ main(
 	} else
 		dfile = xi.dname;
 
+	/*
+	 * Now we have all the options parsed, we can read in the option file
+	 * specified on the command line via "-c file=xxx". Once we have all the
+	 * options from this file parsed, we can then proceed with parameter
+	 * and bounds checking and making the filesystem.
+	 */
+	cfgfile_parse(&cli);
+
 	protostring = setup_proto(protofile);
 
 	/*
-- 
2.28.0

