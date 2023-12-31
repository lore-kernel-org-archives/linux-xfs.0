Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A43DC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAL5eYTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCD9C433C8;
	Sun, 31 Dec 2023 23:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067158;
	bh=P105lhgVsp285v72A1gmLnInF6FcBVAWx3yfAoqigSE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TAL5eYTLmdmJKVzXu7lY4GCAgkvRozySXYCgzIWhLWnklJkcXAtXFyYodXtB89tpv
	 ydm6DdKxGNB5rrZTCghzoUcglUKRmXB3COq2Fxhg4f+QvGmCU3MJ31Jdp/Rhp85kbq
	 e60eKXh6LVOOSO6IMbep2crYT1eQuLF45bM+F34qDi8kxrsQuiqmeFBoQ3hgGehYDk
	 +GsC9B6lQmXjMJrkdjCgwYOmPZuE6Q9B/Mj1gZWuvIPbFH2nax32c+erkpd4H5Ujvn
	 MtsArgCjqSDsoOEA6m3qrTXoJ9mOGv+2AKMs6SLY2BgVo3fDHaL3hv3sdfBuF97NEP
	 ksNpq4XK/Rmxg==
Date: Sun, 31 Dec 2023 15:59:17 -0800
Subject: [PATCH 45/52] xfs_spaceman: report on realtime group health
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012765.1811243.2168684012414453279.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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
 spaceman/health.c       |   59 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 0d299132a78..7d2d1ff94ee 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -91,7 +91,7 @@ The output will have the same format that
 .BR "xfs_info" "(8)"
 prints when querying a filesystem.
 .TP
-.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-n ] [ \-q ] [ paths ]"
+.BI "health [ \-a agno] [ \-c ] [ \-f ] [ \-i inum ] [ \-n ] [ \-q ] [ \-r rgno ] [ paths ]"
 Reports the health of the given group of filesystem metadata.
 .RS 1.0i
 .PD 0
@@ -119,6 +119,9 @@ This option is disabled by default to minimize runtime.
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
index 47cf9099492..d9a18fcc3b4 100644
--- a/spaceman/health.c
+++ b/spaceman/health.c
@@ -136,6 +136,18 @@ static const struct flag_map ag_flags[] = {
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
@@ -220,6 +232,25 @@ report_ag_sick(
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
@@ -346,7 +377,7 @@ report_bulkstat_health(
 	return error;
 }
 
-#define OPT_STRING ("a:cfi:nq")
+#define OPT_STRING ("a:cfi:nqr:")
 
 /* Report on health problems in XFS filesystem. */
 static int
@@ -356,6 +387,7 @@ health_f(
 {
 	unsigned long long	x;
 	xfs_agnumber_t		agno;
+	xfs_rgnumber_t		rgno;
 	bool			default_report = true;
 	int			c;
 	int			ret;
@@ -403,6 +435,17 @@ health_f(
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
@@ -438,6 +481,12 @@ health_f(
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
@@ -459,6 +508,11 @@ health_f(
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
@@ -489,6 +543,7 @@ health_help(void)
 " -i inum  -- Report health of a given inode number.\n"
 " -n       -- Try to report file names.\n"
 " -q       -- Only report unhealthy metadata.\n"
+" -r rgno  -- Report health of the given realtime group.\n"
 " paths    -- Report health of the given file path.\n"
 "\n"));
 
@@ -499,7 +554,7 @@ static cmdinfo_t health_cmd = {
 	.cfunc = health_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [paths]",
+	.args = "[-a agno] [-c] [-f] [-i inum] [-n] [-q] [-r rgno] [paths]",
 	.flags = CMD_FLAG_ONESHOT,
 	.help = health_help,
 };

