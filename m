Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751820AbdH2XvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:00 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002bu-Ea
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005VX-DV
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/42] mkfs: add generic subopt parsing table
Date: Wed, 30 Aug 2017 09:50:14 +1000
Message-Id: <20170829235052.21050-5-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Abstract out the common subopt parsing code into a common function
and type table so we can factor the parsing code. Add the function
stubs in preparation for factoring.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2b264ec32974..022fb84016f6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1467,6 +1467,136 @@ getstr(
 	return str;
 }
 
+static int
+block_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+data_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+inode_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+log_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+meta_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+naming_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+rtdev_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+static int
+sector_opts_parser(
+	struct opt_params	*opts,
+	int			subopt,
+	char			*value,
+	struct cli_params	*cli)
+{
+	return 0;
+}
+
+struct subopts {
+	char		opt;
+	struct opt_params *opts;
+	int		(*parser)();
+} subopt_tab[] = {
+	{ 'b', &bopts, block_opts_parser },
+	{ 'd', &dopts, data_opts_parser },
+	{ 'i', &iopts, inode_opts_parser },
+	{ 'l', &lopts, log_opts_parser },
+	{ 'm', &mopts, meta_opts_parser },
+	{ 'n', &nopts, naming_opts_parser },
+	{ 'r', &ropts, rtdev_opts_parser },
+	{ 's', &sopts, sector_opts_parser },
+	{ '\0', NULL, NULL },
+};
+
+static void
+parse_subopts(
+	char		opt,
+	char		*arg,
+	struct cli_params *cli)
+{
+	struct subopts	*sop = &subopt_tab[0];
+	char		*p;
+	int		ret = 0;
+
+	while (sop->opts) {
+		if (sop->opt == opt)
+			break;
+		sop++;
+	}
+
+	/* should never happen */
+	if (!sop->opts)
+		return;
+
+	p = arg;
+	while (*p != '\0') {
+		char	**subopts = (char **)sop->opts->subopts;
+		char	*value;
+		int	subopt;
+
+		subopt = getsubopt(&p, subopts, &value);
+
+		ret = (sop->parser)(sop->opts, subopt, value, cli);
+		if (ret)
+			unknown(opt, value);
+	}
+}
+
 int
 main(
 	int			argc,
-- 
2.13.3

