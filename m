Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945E5188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992579; cv=none; b=I4xoYTV7H+tDzL3SMYxi7Z1t5a4TCX1JJX2gDQSit/1rgO8he2t6cmpVyxVRanwiNpJ/6zN2Ab1py2ab1PwjSfnSY5t2j2ac/9ffEkahoiLLTruHsOcFtp8E2EjvAMN+ktMZptxTlSRxf/sWpak0xfw/XXsiIbNMISj0utZxtKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992579; c=relaxed/simple;
	bh=yPslgJDIRCHIV79TljwiN69IKfj63KHF5QNZLRJbBdo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cIZ5EPa6qRaqYma8Sv1zf8SevAXdEYMpqDmdcMOySnGQUUmw7OwwWQxV9oSobQfEwDefehx29nhB4L86ox8zMENsbpVvybA1Tn4ukcluTW5jdpwk0TSHBTgazhJQImvpoW05tK5s455xu3Vwpe4BHxLp2+Sb6/anSdAaRZQwedE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yf4xazSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yf4xazSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71253C4CED3;
	Mon, 23 Dec 2024 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992579;
	bh=yPslgJDIRCHIV79TljwiN69IKfj63KHF5QNZLRJbBdo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Yf4xazSU0J5ytiaTq4w/8Kvnu7a0rZUZJslBc+5S1oV3tFHDlv2tuwqkcHo2+6kM9
	 pe+MV/V3VZ3TlXl4D0wkxmK7Xw7jsi+hM9d+a3/VscGrF4Rl+SeE79EVWTLQ82oi8H
	 Uktc+LZ5YHLBRfDS+aPwyzJloR4oqlB0hjgvPFJ7duUo+aQfBBDzyQ3DD+m0vM1g2W
	 +TA6xNwO5Tp6WtcLuGhthKA4PP2IUDr9nw/afQG8WmX0TYBqnyEzRWmoNAw7/v4BwB
	 ww6HqokNoTk654DKNEnzqId3Sm9TctwGUp4MZMoDe8iwbm6yQDfqQeh9VKXF4FGzkR
	 t/kwL0rVEZ3+w==
Date: Mon, 23 Dec 2024 14:22:58 -0800
Subject: [PATCH 43/51] xfs_spaceman: report on realtime group health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944462.2297565.5532810486834524461.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the realtime group status to the health reporting done by
xfs_spaceman.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_spaceman.8 |    5 +++-
 spaceman/health.c       |   63 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 65 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 0d299132a7881b..7d2d1ff94eeb55 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -91,7 +91,7 @@ .SH COMMANDS
 .BR "xfs_info" "(8)"
 prints when querying a filesystem.
 .TP
-.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-n ] [ \-q ] [ paths ]"
+.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-n ] [ \-q ] [ \-r rgno ] [ paths ]"
 Reports the health of the given group of filesystem metadata.
 .RS 1.0i
 .PD 0
@@ -119,6 +119,9 @@ .SH COMMANDS
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
index c4d570363fbbf1..4281589324cd44 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -132,6 +132,22 @@ static const struct flag_map ag_flags[] = {
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
+	{
+		.mask = XFS_RTGROUP_GEOM_SICK_SUMMARY,
+		.descr = "realtime summary",
+	},
+	{0},
+};
+
 static const struct flag_map inode_flags[] = {
 	{
 		.mask = XFS_BS_SICK_INODE,
@@ -216,6 +232,25 @@ report_ag_sick(
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
@@ -342,7 +377,7 @@ report_bulkstat_health(
 	return error;
 }
 
-#define OPT_STRING ("a:cfi:nq")
+#define OPT_STRING ("a:cfi:nqr:")
 
 /* Report on health problems in XFS filesystem. */
 static int
@@ -352,6 +387,7 @@ health_f(
 {
 	unsigned long long	x;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	bool			default_report = true;
 	int			c;
 	int			ret;
@@ -399,6 +435,17 @@ health_f(
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
@@ -434,6 +481,12 @@ health_f(
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
@@ -455,6 +508,11 @@ health_f(
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
@@ -485,6 +543,7 @@ health_help(void)
 " -i inum  -- Report health of a given inode number.\n"
 " -n       -- Try to report file names.\n"
 " -q       -- Only report unhealthy metadata.\n"
+" -r rgno  -- Report health of the given realtime group.\n"
 " paths    -- Report health of the given file path.\n"
 "\n"));
 
@@ -495,7 +554,7 @@ static cmdinfo_t health_cmd = {
 	.cfunc = health_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [paths]",
+	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [-r rgno] [paths]",
 	.flags = CMD_FLAG_ONESHOT,
 	.help = health_help,
 };

