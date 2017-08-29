Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:55482 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751843AbdH2XvA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:00 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002bx-G9
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vd-F1
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/42] mkfs: factor data subopts parser
Date: Wed, 30 Aug 2017 09:50:16 +1000
Message-Id: <20170829235052.21050-7-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 171 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 91 insertions(+), 80 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 40de7ea9bfa8..c92abc9a6bf3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1497,6 +1497,65 @@ data_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	int			sectorlog;
+
+	switch (subopt) {
+	case D_AGCOUNT:
+		cli->agcount = getnum(value, opts, D_AGCOUNT);
+		break;
+	case D_AGSIZE:
+		cli->agsize = getstr(value, opts, D_AGSIZE);
+		break;
+	case D_FILE:
+		cli->xi->disfile = getnum(value, opts, D_FILE);
+		break;
+	case D_NAME:
+		cli->xi->dname = getstr(value, opts, D_NAME);
+		break;
+	case D_SIZE:
+		cli->dsize = getstr(value, opts, D_SIZE);
+		break;
+	case D_SUNIT:
+		cli->dsunit = getnum(value, opts, D_SUNIT);
+		break;
+	case D_SWIDTH:
+		cli->dswidth = getnum(value, opts, D_SWIDTH);
+		break;
+	case D_SU:
+		cli->dsu = getstr(value, opts, D_SU);
+		break;
+	case D_SW:
+		cli->dsw = getnum(value, opts, D_SW);
+		break;
+	case D_NOALIGN:
+		cli->sb_feat.nodalign = getnum(value, opts, D_NOALIGN);
+		break;
+	case D_SECTLOG:
+		if (cli->sectorsize)
+			conflict('d', opts->subopts, D_SECTSIZE, D_SECTLOG);
+		sectorlog = getnum(value, opts, D_SECTLOG);
+		cli->sectorsize = 1 << sectorlog;
+		break;
+	case D_SECTSIZE:
+		if (cli->sectorsize)
+			conflict('d', opts->subopts, D_SECTSIZE, D_SECTLOG);
+		cli->sectorsize = getnum(value, opts, D_SECTSIZE);
+		break;
+	case D_RTINHERIT:
+		if (getnum(value, opts, D_RTINHERIT))
+			cli->fsx.fsx_xflags |= XFS_DIFLAG_RTINHERIT;
+		break;
+	case D_PROJINHERIT:
+		cli->fsx.fsx_projid = getnum(value, opts, D_PROJINHERIT);
+		cli->fsx.fsx_xflags |= XFS_DIFLAG_PROJINHERIT;
+		break;
+	case D_EXTSZINHERIT:
+		cli->fsx.fsx_extsize = getnum(value, opts, D_EXTSZINHERIT);
+		cli->fsx.fsx_xflags |= XFS_DIFLAG_EXTSZINHERIT;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1719,7 +1778,9 @@ main(
 		.rmapbt = false,
 		.reflink = false,
 	};
-	struct cli_params	cli = {};
+	struct cli_params	cli = {
+		.xi = &xi,
+	};
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -1769,87 +1830,37 @@ main(
 			/* end temp don't break code */
 			break;
 		case 'd':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)dopts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case D_AGCOUNT:
-					agcount = getnum(value, &dopts,
-							 D_AGCOUNT);
-					daflag = 1;
-					break;
-				case D_AGSIZE:
-					agsize = getnum(value, &dopts, D_AGSIZE);
-					dasize = 1;
-					break;
-				case D_FILE:
-					xi.disfile = getnum(value, &dopts,
-							    D_FILE);
-					break;
-				case D_NAME:
-					xi.dname = getstr(value, &dopts, D_NAME);
-					break;
-				case D_SIZE:
-					dsize = getstr(value, &dopts, D_SIZE);
-					break;
-				case D_SUNIT:
-					dsunit = getnum(value, &dopts, D_SUNIT);
-					dsflag = 1;
-					break;
-				case D_SWIDTH:
-					dswidth = getnum(value, &dopts,
-							 D_SWIDTH);
-					dsflag = 1;
-					break;
-				case D_SU:
-					dsu = getnum(value, &dopts, D_SU);
-					dsflag = 1;
-					break;
-				case D_SW:
-					dsw = getnum(value, &dopts, D_SW);
-					dsflag = 1;
-					break;
-				case D_NOALIGN:
-					nodsflag = getnum(value, &dopts,
-								D_NOALIGN);
-					break;
-				case D_SECTLOG:
-					sectorlog = getnum(value, &dopts,
-							   D_SECTLOG);
-					sectorsize = 1 << sectorlog;
-					slflag = 1;
-					break;
-				case D_SECTSIZE:
-					sectorsize = getnum(value, &dopts,
-							    D_SECTSIZE);
-					sectorlog =
-						libxfs_highbit32(sectorsize);
-					ssflag = 1;
-					break;
-				case D_RTINHERIT:
-					c = getnum(value, &dopts, D_RTINHERIT);
-					if (c)
-						fsx.fsx_xflags |=
-							XFS_DIFLAG_RTINHERIT;
-					break;
-				case D_PROJINHERIT:
-					fsx.fsx_projid = getnum(value, &dopts,
-								D_PROJINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_PROJINHERIT;
-					break;
-				case D_EXTSZINHERIT:
-					fsx.fsx_extsize = getnum(value, &dopts,
-								 D_EXTSZINHERIT);
-					fsx.fsx_xflags |=
-						XFS_DIFLAG_EXTSZINHERIT;
-					break;
-				default:
-					unknown('d', value);
-				}
+			/* temp don't break code */
+			agcount = cli.agcount;
+			if (cli_opt_set(&dopts, D_AGSIZE)) {
+				agsize = getnum(cli.agsize, &dopts, D_AGSIZE);
+				dasize = 1;
+			}
+			daflag = cli_opt_set(&dopts, D_AGCOUNT);
+
+			dsunit = cli.dsunit;
+			dswidth = cli.dswidth;
+			dsw = cli.dsw;
+			if (cli_opt_set(&dopts, D_SU)) {
+				dsu = getnum(cli.dsu, &dopts, D_SU);
+				dsflag = 1;
 			}
+			dsflag |= cli_opt_set(&dopts, D_SW) ||
+				  cli_opt_set(&dopts, D_SUNIT) ||
+				  cli_opt_set(&dopts, D_SWIDTH);
+			nodsflag = cli_opt_set(&dopts, D_NOALIGN);
+
+			sectorsize = cli.sectorsize;
+			sectorlog = libxfs_highbit32(sectorsize);
+			slflag = cli_opt_set(&dopts, D_SECTLOG);
+			ssflag = cli_opt_set(&dopts, D_SECTSIZE);
+
+			fsx.fsx_xflags |= cli.fsx.fsx_xflags;
+			fsx.fsx_projid = cli.fsx.fsx_projid;
+			fsx.fsx_extsize = cli.fsx.fsx_extsize;
+			/* end temp don't break code */
 			break;
 		case 'i':
 			p = optarg;
-- 
2.13.3

