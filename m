Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE6C14A85
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610437; cv=none; b=EHfiWjWlQhV+feXN7Gto7eNryvJM0WB2fRvtST2g5TXfP+hZTNumazPtRHC7P7MNMn0mNx/dnyhi7ENsyYC6/A5xhZF4fOeIPbXRp7pYsvErvkXKuLyT/Iifl9zO4ZkLbOdJtOfZXXcVdeCI8U9wOKSiGcCrLOgD6AWOkE2sICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610437; c=relaxed/simple;
	bh=HMqY5oVh0vhl6GgC4yCVRY6jexExDCXyicotrIaCok0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7bZYcHjmx9ufidFr5W9uvAl1PXxp9XQNr28IqAB50++LggdhzbI0DEnI+T/3AmS9avmW3uTs9Esf3/Yf6eep7it8987mwvvxk/2DTzkQ92Qw/Unxg6xDHsM8ePrGWQmLCpvrw6C2AtmZ3TqNV8qARd3ISK/bHS5fBlIbwJ65qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTYijLhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTYijLhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A18C4CEC5;
	Fri, 11 Oct 2024 01:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610437;
	bh=HMqY5oVh0vhl6GgC4yCVRY6jexExDCXyicotrIaCok0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tTYijLhrF1WdQ31crNzKiHzjRDE2GsV5mtXQeigUhXWwSo0Ora+jGIajaRLa4O74U
	 jr5YjxBMJSr/o5dvLKl9RzaZXoGOs5qxtMLyTq0wE1FlRqjE4oa2M1qXxzEQicJOyr
	 I3tK0SNHANaGZe9peeEoa+ZPgxKmFOfPgIT+bFJUR6G6SbvXg58bD9y+DF5C6JrXoD
	 61BhAqyjIjVZ97bjqFb493sFz+dqjtHdow7v0pgBXHiXlhAXEoGL7m3iy2UGsVGAIB
	 0/4CG2nHRQdVL0pNyJqv+zvuxnPqbmAd+Nlsdar8y2HBhBEGDPtMbn1TOXv32AYmHn
	 0shljS0IGNYLw==
Date: Thu, 10 Oct 2024 18:33:56 -0700
Subject: [PATCH 36/43] xfs_spaceman: report on realtime group health
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655918.4184637.14275220356581301589.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

