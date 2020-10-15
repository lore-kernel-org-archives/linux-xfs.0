Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986E6C43457
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBB922243
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgJOD3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:29:32 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37380 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgJOD3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 23:29:32 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4D7D858C59F
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 14:29:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-000ecw-VK
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-006bfv-No
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] mkfs: hook up suboption parsing to ini files
Date:   Thu, 15 Oct 2020 14:29:24 +1100
Message-Id: <20201015032925.1574739-5-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015032925.1574739-1-david@fromorbit.com>
References: <20201015032925.1574739-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=2FpHqcZwl124cjZJcQMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now we have the config file parsing hooked up and feeding in
parameters to mkfs, wire the parameters up to the existing CLI
option parsing functions. THis gives the config file exactly the
same capabilities and constraints as the command line option
specification.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 95 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 80 insertions(+), 15 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 99ce0dc48d3b..370ac6194e2f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -143,6 +143,13 @@ enum {
  * name MANDATORY
  *   Name is a single char, e.g., for '-d file', name is 'd'.
  *
+ * ini_name MANDATORY
+ *   Name is a string, not longer than MAX_INI_NAME_LEN, that is used as the
+ *   section name for this option set in INI format config files. The only
+ *   option set this is not required for is the command line config file
+ *   specification options, everything else must be configurable via config
+ *   files.
+ *
  * subopts MANDATORY
  *   Subopts is a list of strings naming suboptions. In the example above,
  *   it would contain "file". The last entry of this list has to be NULL.
@@ -201,6 +208,8 @@ enum {
  */
 struct opt_params {
 	const char	name;
+#define MAX_INI_NAME_LEN	32
+	const char	ini_name[MAX_INI_NAME_LEN];
 	const char	*subopts[MAX_SUBOPTS];
 
 	struct subopt_param {
@@ -228,6 +237,7 @@ static struct opt_params sopts;
 
 static struct opt_params bopts = {
 	.name = 'b',
+	.ini_name = "block",
 	.subopts = {
 		[B_SIZE] = "size",
 	},
@@ -267,6 +277,7 @@ static struct opt_params copts = {
 
 static struct opt_params dopts = {
 	.name = 'd',
+	.ini_name = "data",
 	.subopts = {
 		[D_AGCOUNT] = "agcount",
 		[D_FILE] = "file",
@@ -411,6 +422,7 @@ static struct opt_params dopts = {
 
 static struct opt_params iopts = {
 	.name = 'i',
+	.ini_name = "inode",
 	.subopts = {
 		[I_ALIGN] = "align",
 		[I_MAXPCT] = "maxpct",
@@ -472,6 +484,7 @@ static struct opt_params iopts = {
 
 static struct opt_params lopts = {
 	.name = 'l',
+	.ini_name = "log",
 	.subopts = {
 		[L_AGNUM] = "agnum",
 		[L_INTERNAL] = "internal",
@@ -571,6 +584,7 @@ static struct opt_params lopts = {
 
 static struct opt_params nopts = {
 	.name = 'n',
+	.ini_name = "naming",
 	.subopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
@@ -602,6 +616,7 @@ static struct opt_params nopts = {
 
 static struct opt_params ropts = {
 	.name = 'r',
+	.ini_name = "realtime",
 	.subopts = {
 		[R_EXTSIZE] = "extsize",
 		[R_SIZE] = "size",
@@ -652,6 +667,7 @@ static struct opt_params ropts = {
 
 static struct opt_params sopts = {
 	.name = 's',
+	.ini_name = "sector",
 	.subopts = {
 		[S_SIZE] = "size",
 		[S_SECTSIZE] = "sectsize",
@@ -682,6 +698,7 @@ static struct opt_params sopts = {
 
 static struct opt_params mopts = {
 	.name = 'm',
+	.ini_name = "metadata",
 	.subopts = {
 		[M_CRC] = "crc",
 		[M_FINOBT] = "finobt",
@@ -982,6 +999,17 @@ unknown(
 	usage();
 }
 
+static void
+invalid_cfgfile_opt(
+	const char	*filename,
+	const char	*section,
+	const char	*name,
+	const char	*value)
+{
+	fprintf(stderr, _("%s: invalid config file option: [%s]:%s=%s\n"),
+		filename, section, name, value);
+}
+
 static void
 check_device_type(
 	const char	*name,
@@ -1696,23 +1724,22 @@ sector_opts_parser(
 }
 
 static struct subopts {
-	char		opt;
 	struct opt_params *opts;
 	int		(*parser)(struct opt_params	*opts,
 				  int			subopt,
 				  const char		*value,
 				  struct cli_params	*cli);
 } subopt_tab[] = {
-	{ 'b', &bopts, block_opts_parser },
-	{ 'c', &copts, cfgfile_opts_parser },
-	{ 'd', &dopts, data_opts_parser },
-	{ 'i', &iopts, inode_opts_parser },
-	{ 'l', &lopts, log_opts_parser },
-	{ 'm', &mopts, meta_opts_parser },
-	{ 'n', &nopts, naming_opts_parser },
-	{ 'r', &ropts, rtdev_opts_parser },
-	{ 's', &sopts, sector_opts_parser },
-	{ '\0', NULL, NULL },
+	{ &bopts, block_opts_parser },
+	{ &copts, cfgfile_opts_parser },
+	{ &dopts, data_opts_parser },
+	{ &iopts, inode_opts_parser },
+	{ &lopts, log_opts_parser },
+	{ &mopts, meta_opts_parser },
+	{ &nopts, naming_opts_parser },
+	{ &ropts, rtdev_opts_parser },
+	{ &sopts, sector_opts_parser },
+	{ NULL, NULL },
 };
 
 static void
@@ -1726,7 +1753,7 @@ parse_subopts(
 	int		ret = 0;
 
 	while (sop->opts) {
-		if (sop->opt == opt)
+		if (opt && sop->opts->name == opt)
 			break;
 		sop++;
 	}
@@ -1749,6 +1776,45 @@ parse_subopts(
 	}
 }
 
+static bool
+parse_cfgopt(
+	const char	*section,
+	const char	*name,
+	const char	*value,
+	struct cli_params *cli)
+{
+	struct subopts	*sop = &subopt_tab[0];
+	char		**subopts;
+	int		ret = 0;
+	int		i;
+
+	while (sop->opts) {
+		if (sop->opts->ini_name[0] != '\0' &&
+		    strcasecmp(section, sop->opts->ini_name) == 0)
+			break;
+		sop++;
+	}
+
+	/* Config files with unknown sections get caught here. */
+	if (!sop->opts)
+		goto invalid_opt;
+
+	subopts = (char **)sop->opts->subopts;
+	for (i = 0; i < MAX_SUBOPTS; i++) {
+		if (!subopts[i])
+			break;
+		if (strcasecmp(name, subopts[i]) == 0) {
+			ret = (sop->parser)(sop->opts, i, value, cli);
+			if (ret)
+				goto invalid_opt;
+			return true;
+		}
+	}
+invalid_opt:
+	invalid_cfgfile_opt(cli->cfgfile, section, name, value);
+	return false;
+}
+
 static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
@@ -3630,9 +3696,8 @@ cfgfile_parse_ini(
 {
 	struct cli_params	*cli = user;
 
-	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
-		cli->cfgfile, section, name, value);
-
+	if (!parse_cfgopt(section, name, value, cli))
+		return 0;
 	return 1;
 }
 
-- 
2.28.0

