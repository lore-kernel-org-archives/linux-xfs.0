Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751875AbdH2XvF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:05 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002ca-Ml
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vv-L5
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/42] mkfs: factor sector subopts parser
Date: Wed, 30 Aug 2017 09:50:22 +1000
Message-Id: <20170829235052.21050-13-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 69 +++++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 87505c61aa79..5a646b89cd0f 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1755,6 +1755,27 @@ sector_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	int			sectorlog;
+
+	switch (subopt) {
+	case S_LOG:
+	case S_SECTLOG:
+		if (cli->sectorsize)
+			conflict('s', opts->subopts, S_SECTSIZE, S_SECTLOG);
+		sectorlog = getnum(value, &sopts, S_SECTLOG);
+		cli->sectorsize = 1 << sectorlog;
+		cli->lsectorsize = cli->sectorsize;
+		break;
+	case S_SIZE:
+	case S_SECTSIZE:
+		if (cli->sectorsize)
+			conflict('s', opts->subopts, S_SECTLOG, S_SECTSIZE);
+		cli->sectorsize = getnum(value, &sopts, S_SECTSIZE);
+		cli->lsectorsize = cli->sectorsize;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1881,7 +1902,6 @@ main(
 	int			nvflag;
 	int			Nflag;
 	int			discard = 1;
-	char			*p;
 	char			*protofile;
 	char			*protostring;
 	int			qflag;
@@ -2091,41 +2111,18 @@ main(
 			/* end temp don't break code */
 			break;
 		case 's':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)sopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case S_LOG:
-				case S_SECTLOG:
-					if (lssflag)
-						conflict('s', (const char **)subopts,
-							 S_SECTSIZE, S_SECTLOG);
-					sectorlog = getnum(value, &sopts,
-							   S_SECTLOG);
-					lsectorlog = sectorlog;
-					sectorsize = 1 << sectorlog;
-					lsectorsize = sectorsize;
-					lslflag = slflag = 1;
-					break;
-				case S_SIZE:
-				case S_SECTSIZE:
-					if (lslflag)
-						conflict('s', (const char **)subopts, S_SECTLOG,
-							 S_SECTSIZE);
-					sectorsize = getnum(value, &sopts,
-							    S_SECTSIZE);
-					lsectorsize = sectorsize;
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					lsectorlog = sectorlog;
-					lssflag = ssflag = 1;
-					break;
-				default:
-					unknown('s', value);
-				}
-			}
+			parse_subopts(c, optarg, &cli);
+
+			/* temp don't break code */
+			sectorsize = cli.sectorsize;
+			lsectorlog = libxfs_highbit32(sectorsize);
+			lsectorsize = cli.lsectorsize;
+			lsectorlog = libxfs_highbit32(lsectorsize);
+			lslflag = slflag = cli_opt_set(&sopts, S_LOG) ||
+					   cli_opt_set(&sopts, S_SECTLOG);
+
+			lssflag = ssflag = cli_opt_set(&sopts, S_SIZE) ||
+					   cli_opt_set(&sopts, S_SECTSIZE);
 			break;
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
-- 
2.13.3

