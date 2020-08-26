Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0E6C433E3
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261312074A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHZB4j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:56:39 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:39128 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726611AbgHZB4i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 21:56:38 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 51E111AAC7B
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 11:56:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-0000zZ-La
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-00Gg2I-4G
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] mkfs: add initial ini format config file parsing support
Date:   Wed, 26 Aug 2020 11:56:33 +1000
Message-Id: <20200826015634.3974785-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826015634.3974785-1-david@fromorbit.com>
References: <20200826015634.3974785-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=ESCU3tP0QEuBFU1X8cMA:9
        a=UkpAeztolKXzgNgk:21 a=dQNmy5Gwqz53z-xt:21
Sender: linux-xfs-owner@vger.kernel.org
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
 mkfs/xfs_mkfs.c | 101 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 2 deletions(-)

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
index 2e6cd280e388..6a373d614a56 100644
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
+	C_FILE = 0,
+	C_MAX_OPTS,
+};
+
 enum {
 	D_AGCOUNT = 0,
 	D_FILE,
@@ -236,6 +242,28 @@ static struct opt_params bopts = {
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
+		[C_FILE] = "file",
+	},
+	.subopt_params = {
+		{ .index = C_FILE,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .defaultval = SUBOPT_NEEDS_VAL,
+		},
+	},
+};
+
 static struct opt_params dopts = {
 	.name = 'd',
 	.subopts = {
@@ -740,6 +768,8 @@ struct cli_params {
 	int	sectorsize;
 	int	blocksize;
 
+	char	*cfgfile;
+
 	/* parameters that depend on sector/block size being validated. */
 	char	*dsize;
 	char	*agsize;
@@ -854,6 +884,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
+/* config file */	[-c file=xxx]\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
@@ -1377,6 +1408,23 @@ block_opts_parser(
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
+	case C_FILE:
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
@@ -1642,6 +1690,7 @@ static struct subopts {
 				  struct cli_params	*cli);
 } subopt_tab[] = {
 	{ 'b', &bopts, block_opts_parser },
+	{ 'c', &copts, cfgfile_opts_parser },
 	{ 'd', &dopts, data_opts_parser },
 	{ 'i', &iopts, inode_opts_parser },
 	{ 'l', &lopts, log_opts_parser },
@@ -3552,6 +3601,47 @@ check_root_ino(
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
+	if (!cli->cfgfile)
+		return;
+
+	if (ini_parse(cli->cfgfile, cfgfile_parse_ini, cli) < 0) {
+		fprintf(stderr, _("Error parsing config file %s. Aborting\n"),
+			cli->cfgfile);
+		exit(1);
+	}
+	printf(_("Parameters parsed from config file %s successfully\n"),
+		cli->cfgfile);
+}
+
 int
 main(
 	int			argc,
@@ -3638,13 +3728,14 @@ main(
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
@@ -3688,6 +3779,14 @@ main(
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

