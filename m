Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:27944 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751869AbdH2XvE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:04 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002cQ-LW
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vs-Jq
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/42] mkfs: factor rt subopts parser
Date: Wed, 30 Aug 2017 09:50:21 +1000
Message-Id: <20170829235052.21050-12-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 55 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e3ee1f1c87fc..87505c61aa79 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1725,6 +1725,26 @@ rtdev_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	switch (subopt) {
+	case R_EXTSIZE:
+		cli->rtextsize = getstr(value, &ropts, R_EXTSIZE);
+		break;
+	case R_FILE:
+		cli->xi->risfile = getnum(value, &ropts, R_FILE);
+		break;
+	case R_NAME:
+	case R_DEV:
+		cli->xi->rtname = getstr(value, &ropts, R_NAME);
+		break;
+	case R_SIZE:
+		cli->rtsize = getstr(value, &ropts, R_SIZE);
+		break;
+	case R_NOALIGN:
+		cli->sb_feat.nortalign = getnum(value, &ropts, R_NOALIGN);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -2062,36 +2082,13 @@ main(
 			qflag = 1;
 			break;
 		case 'r':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)ropts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case R_EXTSIZE:
-					rtextsize = getstr(value, &ropts,
-							   R_EXTSIZE);
-					break;
-				case R_FILE:
-					xi.risfile = getnum(value, &ropts,
-							    R_FILE);
-					break;
-				case R_NAME:
-				case R_DEV:
-					xi.rtname = getstr(value, &ropts,
-							   R_NAME);
-					break;
-				case R_SIZE:
-					rtsize = getstr(value, &ropts, R_SIZE);
-					break;
-				case R_NOALIGN:
-					norsflag = getnum(value, &ropts,
-								R_NOALIGN);
-					break;
-				default:
-					unknown('r', value);
-				}
-			}
+			/* temp don't break code */
+			rtextsize = cli.rtextsize;
+			rtsize = cli.rtsize;
+			norsflag = cli.sb_feat.nortalign;
+			/* end temp don't break code */
 			break;
 		case 's':
 			p = optarg;
-- 
2.13.3

