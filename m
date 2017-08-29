Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11621 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751935AbdH2XvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 19:51:08 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0002c9-J9
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1dmqHW-0005Vm-HL
        for linux-xfs@vger.kernel.org; Wed, 30 Aug 2017 09:50:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/42] mkfs: factor meta subopts parser
Date: Wed, 30 Aug 2017 09:50:19 +1000
Message-Id: <20170829235052.21050-10-david@fromorbit.com>
In-Reply-To: <20170829235052.21050-1-david@fromorbit.com>
References: <20170829235052.21050-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 61 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8e42fe0301fb..7b967ffe6893 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1659,6 +1659,30 @@ meta_opts_parser(
 	char			*value,
 	struct cli_params	*cli)
 {
+	switch (subopt) {
+	case M_CRC:
+		cli->sb_feat.crcs_enabled = getnum(value, &mopts, M_CRC);
+		if (cli->sb_feat.crcs_enabled)
+			cli->sb_feat.dirftype = true;
+		break;
+	case M_FINOBT:
+		cli->sb_feat.finobt = getnum(value, &mopts, M_FINOBT);
+		break;
+	case M_UUID:
+		if (!value || *value == '\0')
+			reqval('m', opts->subopts, M_UUID);
+		if (platform_uuid_parse(value, &cli->uuid))
+			illegal(value, "m uuid");
+		break;
+	case M_RMAPBT:
+		cli->sb_feat.rmapbt = getnum(value, &mopts, M_RMAPBT);
+		break;
+	case M_REFLINK:
+		cli->sb_feat.reflink = getnum(value, &mopts, M_REFLINK);
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1984,40 +2008,11 @@ main(
 			label = optarg;
 			break;
 		case 'm':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)mopts.subopts;
-				char	*value;
+			parse_subopts(c, optarg, &cli);
 
-				switch (getsubopt(&p, subopts, &value)) {
-				case M_CRC:
-					sb_feat.crcs_enabled =
-						getnum(value, &mopts, M_CRC);
-					if (sb_feat.crcs_enabled)
-						sb_feat.dirftype = true;
-					break;
-				case M_FINOBT:
-					sb_feat.finobt = getnum(
-						value, &mopts, M_FINOBT);
-					break;
-				case M_UUID:
-					if (!value || *value == '\0')
-						reqval('m', (const char **)subopts, M_UUID);
-					if (platform_uuid_parse(value, &uuid))
-						illegal(optarg, "m uuid");
-					break;
-				case M_RMAPBT:
-					sb_feat.rmapbt = getnum(
-						value, &mopts, M_RMAPBT);
-					break;
-				case M_REFLINK:
-					sb_feat.reflink = getnum(
-						value, &mopts, M_REFLINK);
-					break;
-				default:
-					unknown('m', value);
-				}
-			}
+			/* temp don't break code */
+			platform_uuid_copy(&uuid, &cli.uuid);
+			/* end temp don't break code */
 			break;
 		case 'n':
 			p = optarg;
-- 
2.13.3

