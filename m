Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751856AbdH2Xu7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:50:59 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002bv-FL
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Va-EG
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/42] mkfs: factor block subopts parser
Date: Wed, 30 Aug 2017 09:50:15 +1000
Message-Id: <20170829235052.21050-6-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 022fb84016f6..40de7ea9bfa8 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1474,6 +1474,19 @@ block_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	int			blocklog;
+
+	switch (subopt) {
+	case B_LOG:
+		blocklog = getnum(value, opts, B_LOG);
+		cli->blocksize = 1 << blocklog;
+		break;
+	case B_SIZE:
+		cli->blocksize = getnum(value, opts, B_SIZE);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1706,6 +1719,7 @@ main(
 		.rmapbt = false,
 		.reflink = false,
 	};
+	struct cli_params	cli = {};
 
 	platform_uuid_generate(&uuid);
 	progname = basename(argv[0]);
@@ -1745,27 +1759,14 @@ main(
 			force_overwrite = 1;
 			break;
 		case 'b':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)bopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case B_LOG:
-					blocklog = getnum(value, &bopts, B_LOG);
-					blocksize = 1 << blocklog;
-					blflag = 1;
-					break;
-				case B_SIZE:
-					blocksize = getnum(value, &bopts,
-							   B_SIZE);
-					blocklog = libxfs_highbit32(blocksize);
-					bsflag = 1;
-					break;
-				default:
-					unknown('b', value);
-				}
-			}
+			parse_subopts(c, optarg, &cli);
+
+			/* temp don't break code */
+			blocksize = cli.blocksize;
+			blocklog = libxfs_highbit32(blocksize);
+			blflag = cli_opt_set(&bopts, B_LOG);
+			bsflag = cli_opt_set(&bopts, B_SIZE);
+			/* end temp don't break code */
 			break;
 		case 'd':
 			p = optarg;
-- 
2.13.3

