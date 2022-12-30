Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7948BC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiLaCk3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:40:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbiLaCk2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:40:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5F92DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:40:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C80B81E0C
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE68C433D2;
        Sat, 31 Dec 2022 02:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454425;
        bh=MWq86jyz4sFGWuwt1u9pH+YewCNsCkr1EPh6kjhrFnE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bHtCjIYCy4TSEWO3r3drwHUTJGhjG1x9x2+MNwt2kiTlQkxal6rrBUIPOhbC2Sk7M
         N8t2/sLaaBWegXklhNb7IzEy8/9YsM/mNQN1gvO/+kO13c5jchUj6ZRtUbdv+Ldfe0
         Spji+c3tNR/WUlobM1bU7ZR1Jq2tAn59KozBP2pmVPx2vsaMDkITRwSpIuQWrtNsST
         tOZcLgijV3yxTo3yjCqK+mlTW1BQf5xFNDbk3RqotATIeMnsBIDAZ8zOZNOJaAjqSz
         bD0NnBOYJ7VQNnxFM8EbfTOBBA2YnID6p34LmwS6+ZoffxAhIopYOX+Tcwo5JvHr1+
         0Vlij9O5E64PA==
Subject: [PATCH 40/45] xfs_spaceman: report on realtime group health
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878885.731133.6486251123997724666.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add the realtime group status to the health reporting done by
xfs_spaceman.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_spaceman.8 |    5 +++-
 spaceman/health.c       |   59 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index ece840d7300..837fc497f27 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -91,7 +91,7 @@ The output will have the same format that
 .BR "xfs_info" "(8)"
 prints when querying a filesystem.
 .TP
-.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-q ] [ paths ]"
+.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-q ] [ \-r rgno ] [ paths ]"
 Reports the health of the given group of filesystem metadata.
 .RS 1.0i
 .PD 0
@@ -114,6 +114,9 @@ Report on the health of a specific inode.
 .B \-q
 Report only unhealthy metadata.
 .TP
+.B \-r
+Report on the health of the given realtime group.
+.TP
 .B paths
 Report on the health of the files at the given path.
 .PD
diff --git a/spaceman/health.c b/spaceman/health.c
index 12fb67bab28..928d92abb8c 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -134,6 +134,18 @@ static const struct flag_map ag_flags[] = {
 	{0},
 };
 
+static const struct flag_map rtgroup_flags[] = {
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_SUPER,
+		.descr = "superblock",
+	},
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_BITMAP,
+		.descr = "realtime bitmap",
+	},
+	{0},
+};
+
 static const struct flag_map inode_flags[] = {
 	{
 		.mask = XFS_BS_SICK_INODE,
@@ -214,6 +226,25 @@ report_ag_sick(
 	return 0;
 }
 
+/* Report on a rt group's health. */
+static int
+report_rtgroup_sick(
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup_geometry rgeo = { 0 };
+	char			descr[256];
+	int			ret;
+
+	ret = -xfrog_rtgroup_geometry(file->xfd.fd, rgno, &rgeo);
+	if (ret) {
+		xfrog_perror(ret, "rtgroup_geometry");
+		return 1;
+	}
+	snprintf(descr, sizeof(descr) - 1, _("rtgroup %u"), rgno);
+	report_sick(descr, rtgroup_flags, rgeo.rg_sick, rgeo.rg_checked);
+	return 0;
+}
+
 /* Report on an inode's health. */
 static int
 report_inode_health(
@@ -312,7 +343,7 @@ report_bulkstat_health(
 	return error;
 }
 
-#define OPT_STRING ("a:cfi:q")
+#define OPT_STRING ("a:cfi:qr:")
 
 /* Report on health problems in XFS filesystem. */
 static int
@@ -322,6 +353,7 @@ health_f(
 {
 	unsigned long long	x;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	bool			default_report = true;
 	int			c;
 	int			ret;
@@ -365,6 +397,17 @@ health_f(
 		case 'q':
 			quiet = true;
 			break;
+		case 'r':
+			default_report = false;
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (!errno && x >= NULLRGNUMBER)
+				errno = ERANGE;
+			if (errno) {
+				perror("rtgroup health");
+				return 1;
+			}
+			break;
 		default:
 			return command_usage(&health_cmd);
 		}
@@ -400,6 +443,12 @@ health_f(
 			if (ret)
 				return 1;
 			break;
+		case 'r':
+			rgno = strtoll(optarg, NULL, 10);
+			ret = report_rtgroup_sick(rgno);
+			if (ret)
+				return 1;
+			break;
 		default:
 			break;
 		}
@@ -421,6 +470,11 @@ health_f(
 			if (ret)
 				return 1;
 		}
+		for (rgno = 0; rgno < file->xfd.fsgeom.rgcount; rgno++) {
+			ret = report_rtgroup_sick(rgno);
+			if (ret)
+				return 1;
+		}
 		if (comprehensive) {
 			ret = report_bulkstat_health(NULLAGNUMBER);
 			if (ret)
@@ -450,6 +504,7 @@ health_help(void)
 " -f       -- Report health of the overall filesystem.\n"
 " -i inum  -- Report health of a given inode number.\n"
 " -q       -- Only report unhealthy metadata.\n"
+" -r rgno  -- Report health of the given realtime group.\n"
 " paths    -- Report health of the given file path.\n"
 "\n"));
 
@@ -460,7 +515,7 @@ static cmdinfo_t health_cmd = {
 	.cfunc = health_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno] [-c] [-f] [-i inum] [-q] [paths]",
+	.args = "[-a agno] [-c] [-f] [-i inum] [-q] [-r rgno] [paths]",
 	.flags = CMD_FLAG_ONESHOT,
 	.help = health_help,
 };

