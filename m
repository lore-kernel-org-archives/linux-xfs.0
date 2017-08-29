Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751942AbdH2XvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:09 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002c0-H5
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vg-Fl
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/42] mkfs: factor inode subopts parser
Date: Wed, 30 Aug 2017 09:50:17 +1000
Message-Id: <20170829235052.21050-8-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 94 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c92abc9a6bf3..d702010c2854 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1566,6 +1566,37 @@ inode_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	int			inodelog;
+
+	switch (subopt) {
+	case I_ALIGN:
+		cli->sb_feat.inode_align = getnum(value, &iopts, I_ALIGN);
+		break;
+	case I_LOG:
+		inodelog = getnum(value, &iopts, I_LOG);
+		cli->inodesize = 1 << inodelog;
+		break;
+	case I_MAXPCT:
+		cli->imaxpct = getnum(value, &iopts, I_MAXPCT);
+		break;
+	case I_PERBLOCK:
+		cli->inopblock = getnum(value, &iopts, I_PERBLOCK);
+		break;
+	case I_SIZE:
+		cli->inodesize = getnum(value, &iopts, I_SIZE);
+		break;
+	case I_ATTR:
+		cli->sb_feat.attr_version = getnum(value, &iopts, I_ATTR);
+		break;
+	case I_PROJID32BIT:
+		cli->sb_feat.projid16bit = !getnum(value, &iopts, I_PROJID32BIT);
+		break;
+	case I_SPINODES:
+		cli->sb_feat.spinodes = getnum(value, &iopts, I_SPINODES);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1780,6 +1811,7 @@ main(
 	};
 	struct cli_params	cli = {
 		.xi = &xi,
+		.sb_feat = sb_feat,
 	};
 
 	platform_uuid_generate(&uuid);
@@ -1863,53 +1895,19 @@ main(
 			/* end temp don't break code */
 			break;
 		case 'i':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)iopts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case I_ALIGN:
-					sb_feat.inode_align = getnum(value,
-								&iopts, I_ALIGN);
-					break;
-				case I_LOG:
-					inodelog = getnum(value, &iopts, I_LOG);
-					isize = 1 << inodelog;
-					ilflag = 1;
-					break;
-				case I_MAXPCT:
-					imaxpct = getnum(value, &iopts,
-							 I_MAXPCT);
-					imflag = 1;
-					break;
-				case I_PERBLOCK:
-					inopblock = getnum(value, &iopts,
-							   I_PERBLOCK);
-					ipflag = 1;
-					break;
-				case I_SIZE:
-					isize = getnum(value, &iopts, I_SIZE);
-					inodelog = libxfs_highbit32(isize);
-					isflag = 1;
-					break;
-				case I_ATTR:
-					sb_feat.attr_version =
-						getnum(value, &iopts, I_ATTR);
-					break;
-				case I_PROJID32BIT:
-					sb_feat.projid16bit =
-						!getnum(value, &iopts,
-							I_PROJID32BIT);
-					break;
-				case I_SPINODES:
-					sb_feat.spinodes = getnum(value,
-							&iopts, I_SPINODES);
-					break;
-				default:
-					unknown('i', value);
-				}
-			}
+			/* temp don't break code */
+			isize = cli.inodesize;
+			inodelog = libxfs_highbit32(isize);
+			inopblock = cli.inopblock;
+			ilflag = cli_opt_set(&iopts, I_LOG);
+			isflag = cli_opt_set(&iopts, I_SIZE);
+			ipflag = cli_opt_set(&iopts, I_PERBLOCK);
+
+			imaxpct = cli.imaxpct;
+			imflag = cli_opt_set(&iopts, I_MAXPCT);
+			/* end temp don't break code */
 			break;
 		case 'l':
 			p = optarg;
@@ -2157,6 +2155,10 @@ main(
 	} else
 		dfile = xi.dname;
 
+	/* temp don't break code */
+	sb_feat = cli.sb_feat;
+	/* end temp don't break code */
+
 	/*
 	 * Blocksize and sectorsize first, other things depend on them
 	 * For RAID4/5/6 we want to align sector size and block size,
-- 
2.13.3

