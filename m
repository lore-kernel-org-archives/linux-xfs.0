Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70575C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2678622241
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 03:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgJOD3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Oct 2020 23:29:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58359 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726696AbgJOD3b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Oct 2020 23:29:31 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 000123AB3D1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 14:29:26 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-000ecu-UQ
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kStxF-006bfs-Mz
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 14:29:25 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] mkfs: constify various strings
Date:   Thu, 15 Oct 2020 14:29:23 +1100
Message-Id: <20201015032925.1574739-4-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015032925.1574739-1-david@fromorbit.com>
References: <20201015032925.1574739-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=YDoY5Q6TbSLZV4WViUwA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because the ini parser uses const strings and so the opt parsing
needs to be told about it to avoid compiler warnings.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux.h |  2 +-
 mkfs/xfs_mkfs.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

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
index e84be74fb100..99ce0dc48d3b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -975,8 +975,8 @@ respec(
 
 static void
 unknown(
-	char		opt,
-	char		*s)
+	const char	opt,
+	const char	*s)
 {
 	fprintf(stderr, _("unknown option -%c %s\n"), opt, s);
 	usage();
@@ -1387,7 +1387,7 @@ getnum(
  */
 static char *
 getstr(
-	char			*str,
+	const char		*str,
 	struct opt_params	*opts,
 	int			index)
 {
@@ -1396,14 +1396,14 @@ getstr(
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
@@ -1420,7 +1420,7 @@ static int
 cfgfile_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1437,7 +1437,7 @@ static int
 data_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1506,7 +1506,7 @@ static int
 inode_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1541,7 +1541,7 @@ static int
 log_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1587,7 +1587,7 @@ static int
 meta_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1621,7 +1621,7 @@ static int
 naming_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1650,7 +1650,7 @@ static int
 rtdev_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1680,7 +1680,7 @@ static int
 sector_opts_parser(
 	struct opt_params	*opts,
 	int			subopt,
-	char			*value,
+	const char		*value,
 	struct cli_params	*cli)
 {
 	switch (subopt) {
@@ -1700,7 +1700,7 @@ static struct subopts {
 	struct opt_params *opts;
 	int		(*parser)(struct opt_params	*opts,
 				  int			subopt,
-				  char			*value,
+				  const char		*value,
 				  struct cli_params	*cli);
 } subopt_tab[] = {
 	{ 'b', &bopts, block_opts_parser },
-- 
2.28.0

