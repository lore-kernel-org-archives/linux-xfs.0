Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751843AbdH2Xu6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:50:58 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002c4-Hk
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vj-GX
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/42] mkfs: factor log subopts parser
Date: Wed, 30 Aug 2017 09:50:18 +1000
Message-Id: <20170829235052.21050-9-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 127 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 62 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d702010c2854..8e42fe0301fb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1607,6 +1607,48 @@ log_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	int			lsectorlog;
+
+	switch (subopt) {
+	case L_AGNUM:
+		cli->logagno = getnum(value, &lopts, L_AGNUM);
+		break;
+	case L_FILE:
+		cli->xi->lisfile = getnum(value, &lopts, L_FILE);
+		break;
+	case L_INTERNAL:
+		cli->loginternal = getnum(value, &lopts, L_INTERNAL);
+		break;
+	case L_SU:
+		cli->lsu = getstr(value, &lopts, L_SU);
+		break;
+	case L_SUNIT:
+		cli->lsunit = getnum(value, &lopts, L_SUNIT);
+		break;
+	case L_NAME:
+	case L_DEV:
+		cli->xi->logname = getstr(value, &lopts, L_NAME);
+		cli->loginternal = 0;
+		break;
+	case L_VERSION:
+		cli->sb_feat.log_version = getnum(value, &lopts, L_VERSION);
+		break;
+	case L_SIZE:
+		cli->logsize = getstr(value, &lopts, L_SIZE);
+		break;
+	case L_SECTLOG:
+		lsectorlog = getnum(value, &lopts, L_SECTLOG);
+		cli->lsectorsize = 1 << lsectorlog;
+		break;
+	case L_SECTSIZE:
+		cli->lsectorsize = getnum(value, &lopts, L_SECTSIZE);
+		break;
+	case L_LAZYSBCNTR:
+		cli->sb_feat.lazy_sb_counters = getnum(value, &lopts, L_LAZYSBCNTR);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1910,70 +1952,31 @@ main(
 			/* end temp don't break code */
 			break;
 		case 'l':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)lopts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case L_AGNUM:
-					logagno = getnum(value, &lopts, L_AGNUM);
-					laflag = 1;
-					break;
-				case L_FILE:
-					xi.lisfile = getnum(value, &lopts,
-							    L_FILE);
-					break;
-				case L_INTERNAL:
-					loginternal = getnum(value, &lopts,
-							     L_INTERNAL);
-					liflag = 1;
-					break;
-				case L_SU:
-					lsu = getnum(value, &lopts, L_SU);
-					lsuflag = 1;
-					break;
-				case L_SUNIT:
-					lsunit = getnum(value, &lopts, L_SUNIT);
-					lsunitflag = 1;
-					break;
-				case L_NAME:
-				case L_DEV:
-					logfile = getstr(value, &lopts, L_NAME);
-					xi.logname = logfile;
-					ldflag = 1;
-					loginternal = 0;
-					break;
-				case L_VERSION:
-					sb_feat.log_version =
-						getnum(value, &lopts, L_VERSION);
-					lvflag = 1;
-					break;
-				case L_SIZE:
-					logsize = getstr(value, &lopts, L_SIZE);
-					break;
-				case L_SECTLOG:
-					lsectorlog = getnum(value, &lopts,
-							    L_SECTLOG);
-					lsectorsize = 1 << lsectorlog;
-					lslflag = 1;
-					break;
-				case L_SECTSIZE:
-					lsectorsize = getnum(value, &lopts,
-							     L_SECTSIZE);
-					lsectorlog =
-						libxfs_highbit32(lsectorsize);
-					lssflag = 1;
-					break;
-				case L_LAZYSBCNTR:
-					sb_feat.lazy_sb_counters =
-							getnum(value, &lopts,
-							       L_LAZYSBCNTR);
-					break;
-				default:
-					unknown('l', value);
-				}
+			/* temp don't break code */
+			logagno = cli.logagno;
+			loginternal = cli.loginternal;
+			logfile = xi.logname;
+			logsize = cli.logsize;
+			lsectorsize = cli.lsectorsize;
+			lsectorlog = libxfs_highbit32(lsectorsize);
+
+			lsunit = cli.lsunit;
+			lsunitflag = cli_opt_set(&lopts, L_SUNIT);
+			if (cli_opt_set(&lopts, L_SU)) {
+				lsu = getnum(cli.lsu, &lopts, L_SU);
+				lsuflag = 1;
 			}
+
+			laflag = cli_opt_set(&lopts, L_AGNUM);
+			liflag = cli_opt_set(&lopts, L_INTERNAL);
+			ldflag = cli_opt_set(&lopts, L_NAME) ||
+				 cli_opt_set(&lopts, L_DEV);
+			lvflag = cli_opt_set(&lopts, L_VERSION);
+			lslflag = cli_opt_set(&lopts, L_SECTLOG);
+			lssflag = cli_opt_set(&lopts, L_SECTSIZE);
+			/* end temp don't break code */
 			break;
 		case 'L':
 			if (strlen(optarg) > sizeof(sbp->sb_fname))
-- 
2.13.3

