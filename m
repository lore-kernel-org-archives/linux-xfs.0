Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB5CC433E5
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE9F2074A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 01:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHZB4l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 21:56:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49629 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726619AbgHZB4l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 21:56:41 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 75BEF824A20
        for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2020 11:56:36 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-0000zc-N2
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1kAkfz-00Gg2N-6g
        for linux-xfs@vger.kernel.org; Wed, 26 Aug 2020 11:56:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] mkfs: hook up suboption parsing to ini files
Date:   Wed, 26 Aug 2020 11:56:34 +1000
Message-Id: <20200826015634.3974785-4-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826015634.3974785-1-david@fromorbit.com>
References: <20200826015634.3974785-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=tU66eNk6EksZVk4BCOgA:9
Sender: linux-xfs-owner@vger.kernel.org
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
 include/linux.h |   2 +-
 mkfs/xfs_mkfs.c | 121 +++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 95 insertions(+), 28 deletions(-)

diff --git a/include/linux.h b/include/linux.h
index 57726bb12b74..03b3278bb895 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -92,7 +92,7 @@ static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 	uuid_unparse(*uu, buffer);
 }
 
-static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
+static __inline__ int platform_uuid_parse(const char *buffer, uuid_t *uu)
 {
 	return uuid_parse(buffer, *uu);
 }
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6a373d614a56..deaed551b6d1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -142,6 +142,13 @@ enum {
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
@@ -200,6 +207,8 @@ enum {
  */
 struct opt_params {
 	const char	name;
+#define MAX_INI_NAME_LEN	32
+	const char	ini_name[MAX_INI_NAME_LEN];
 	const char	*subopts[MAX_SUBOPTS];
 
 	struct subopt_param {
@@ -227,6 +236,7 @@ static struct opt_params sopts;
 
 static struct opt_params bopts = {
 	.name = 'b',
+	.ini_name = "block",
 	.subopts = {
 		[B_SIZE] = "size",
 	},
@@ -266,6 +276,7 @@ static struct opt_params copts = {
 
 static struct opt_params dopts = {
 	.name = 'd',
+	.ini_name = "data",
 	.subopts = {
 		[D_AGCOUNT] = "agcount",
 		[D_FILE] = "file",
@@ -403,6 +414,7 @@ static struct opt_params dopts = {
 
 static struct opt_params iopts = {
 	.name = 'i',
+	.ini_name = "inode",
 	.subopts = {
 		[I_ALIGN] = "align",
 		[I_MAXPCT] = "maxpct",
@@ -464,6 +476,7 @@ static struct opt_params iopts = {
 
 static struct opt_params lopts = {
 	.name = 'l',
+	.ini_name = "log",
 	.subopts = {
 		[L_AGNUM] = "agnum",
 		[L_INTERNAL] = "internal",
@@ -563,6 +576,7 @@ static struct opt_params lopts = {
 
 static struct opt_params nopts = {
 	.name = 'n',
+	.ini_name = "naming",
 	.subopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
@@ -594,6 +608,7 @@ static struct opt_params nopts = {
 
 static struct opt_params ropts = {
 	.name = 'r',
+	.ini_name = "realtime",
 	.subopts = {
 		[R_EXTSIZE] = "extsize",
 		[R_SIZE] = "size",
@@ -644,6 +659,7 @@ static struct opt_params ropts = {
 
 static struct opt_params sopts = {
 	.name = 's',
+	.ini_name = "sector",
 	.subopts = {
 		[S_SIZE] = "size",
 		[S_SECTSIZE] = "sectsize",
@@ -674,6 +690,7 @@ static struct opt_params sopts = {
 
 static struct opt_params mopts = {
 	.name = 'm',
+	.ini_name = "metadata",
 	.subopts = {
 		[M_CRC] = "crc",
 		[M_FINOBT] = "finobt",
@@ -967,13 +984,24 @@ respec(
 
 static void
 unknown(
-	char		opt,
-	char		*s)
+	const char	opt,
+	const char	*s)
 {
 	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
 	usage();
 }
 
+static void
+unknown_cfgfile_opt(
+	const char	*section,
+	const char	*name,
+	const char	*value)
+{
+	fprintf(stderr, _("unknown config file option: [%s]:%s=%s\n"),
+		section, name, value);
+	usage();
+}
+
 static void
 check_device_type(
 	const char	*name,
@@ -1379,7 +1407,7 @@ getnum(
  */
 static char *
 getstr(
-	char			*str,
+	const char		*str,
 	struct opt_params	*opts,
 	int			index)
 {
@@ -1388,14 +1416,14 @@ getstr(
 	/* empty strings for string options are not valid */
 	if (!str || *str == '\0')
 		reqval(opts->name, opts->subopts, index);
-	return str;
+	return (char *)str;
 }
 
 static int
 block_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1412,7 +1440,7 @@ static int
 cfgfile_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1429,7 +1457,7 @@ static int
 data_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1492,7 +1520,7 @@ static int
 inode_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1527,7 +1555,7 @@ static int
 log_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1573,7 +1601,7 @@ static int
 meta_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1607,7 +1635,7 @@ static int
 naming_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1636,7 +1664,7 @@ static int
 rtdev_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1666,7 +1694,7 @@ static int
 sector_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1682,23 +1710,22 @@ sector_opts_parser(
 }
 
 static struct subopts {
-	char		opt;
 	struct opt_params *opts;
 	int		(*parser)(struct opt_params	*opts,
 				  int			subopt,
-				  char			*value,
+				  const char		*value,
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
@@ -1712,12 +1739,12 @@ parse_subopts(
 	int		ret = 0;
 
 	while (sop->opts) {
-		if (sop->opt == opt)
+		if (opt && sop->opts->name == opt)
 			break;
 		sop++;
 	}
 
-	/* should never happen */
+	/* Should not happen */
 	if (!sop->opts)
 		return;
 
@@ -1735,6 +1762,44 @@ parse_subopts(
 	}
 }
 
+static void
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
+		goto unknown_opt;
+
+	subopts = (char **)sop->opts->subopts;
+	for (i = 0; i < MAX_SUBOPTS; i++) {
+		if (!subopts[i])
+			break;
+		if (strcasecmp(name, subopts[i]) == 0) {
+			ret = (sop->parser)(sop->opts, i, value, cli);
+			if (ret)
+				goto unknown_opt;
+			return;
+		}
+	}
+unknown_opt:
+	unknown_cfgfile_opt(section, name, value);
+}
+
 static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
@@ -3623,6 +3688,8 @@ cfgfile_parse_ini(
 	fprintf(stderr, "Ini debug: file %s, section %s, name %s, value %s\n",
 		cli->cfgfile, section, name, value);
 
+	parse_cfgopt(section, name, value, cli);
+
 	return 1;
 }
 
-- 
2.28.0

