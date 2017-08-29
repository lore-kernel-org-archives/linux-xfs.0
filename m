Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36957 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751935AbdH2XvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:10 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cG-KP
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vp-Ih
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/42] mkfs: factor naming subopts parser
Date: Wed, 30 Aug 2017 09:50:20 +1000
Message-Id: <20170829235052.21050-11-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 68 +++++++++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7b967ffe6893..e3ee1f1c87fc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1693,6 +1693,28 @@ naming_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	switch (subopt) {
+	case N_LOG:
+		cli->dirblocklog = getnum(value, opts, N_LOG);
+		break;
+	case N_SIZE:
+		cli->dirblocksize = getstr(value, opts, N_SIZE);
+		break;
+	case N_VERSION:
+		value = getstr(value, &nopts, N_VERSION);
+		if (!strcasecmp(value, "ci")) {
+			/* ASCII CI mode */
+			cli->sb_feat.nci = true;
+		} else {
+			cli->sb_feat.dir_version = getnum(value, opts, N_VERSION);
+		}
+		break;
+	case N_FTYPE:
+		cli->sb_feat.dirftype = getnum(value, opts, N_FTYPE);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -2015,45 +2037,15 @@ main(
 			/* end temp don't break code */
 			break;
 		case 'n':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)nopts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case N_LOG:
-					dirblocklog = getnum(value, &nopts,
-							     N_LOG);
-					dirblocksize = 1 << dirblocklog;
-					nlflag = 1;
-					break;
-				case N_SIZE:
-					dirblocksize = getnum(value, &nopts,
-							      N_SIZE);
-					dirblocklog =
-						libxfs_highbit32(dirblocksize);
-					nsflag = 1;
-					break;
-				case N_VERSION:
-					value = getstr(value, &nopts, N_VERSION);
-					if (!strcasecmp(value, "ci")) {
-						/* ASCII CI mode */
-						sb_feat.nci = true;
-					} else {
-						sb_feat.dir_version =
-							getnum(value, &nopts,
-							       N_VERSION);
-					}
-					nvflag = 1;
-					break;
-				case N_FTYPE:
-					sb_feat.dirftype = getnum(value, &nopts,
-								  N_FTYPE);
-					break;
-				default:
-					unknown('n', value);
-				}
-			}
+			/* temp don't break code */
+			if ((nsflag = cli_opt_set(&nopts, N_SIZE)))
+				dirblocksize = getnum(cli.dirblocksize, &nopts, N_SIZE);
+			dirblocklog = cli.dirblocklog;
+
+			nlflag = cli_opt_set(&nopts, N_LOG);
+			/* end temp don't break code */
 			break;
 		case 'N':
 			Nflag = 1;
-- 
2.13.3

