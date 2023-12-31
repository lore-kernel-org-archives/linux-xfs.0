Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FC0C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qOsUKBA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3284FC433C8;
	Sun, 31 Dec 2023 23:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067111;
	bh=bm8enZDGt87JjnBmX17zPQU/aFn4OixsKDicJD5i5zQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qOsUKBA4HtixJalfFVmcXPayWSAJQTRQJGa7PPPstm/us1UwY7sclCjKhTDMXoWdR
	 6IRKkw5Qwfqjm2rFrYxEd5kqyoTwR+Yn0BoyPurW0KihzCe98kYm2EYBEy9OZLUJ7F
	 j0xkPQQ/XX7PjV8vyblz6ibEynmnFa3AbiIhoCUNrzbBWfHEUHKFRTz09vOaITZ6Pu
	 NrdJqtdVVnav1/kWeB6Ajj3mCKmXZEoUMJbr4/7lNEltvykbEA9un2LLFh5JW7m/K/
	 RaAD/Qsec/pi32In0d26Ekh8mwhgn+tqL9kcCuV9ulczFQARB/HxLuTzAbS3/ZpX/t
	 lgt7qoey1K/Sw==
Date: Sun, 31 Dec 2023 15:58:30 -0800
Subject: [PATCH 42/52] xfs_io: add a command to display realtime group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012725.1811243.8409566037215380839.stgit@frogsfrogsfrogs>
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

Add a new 'rginfo' command to xfs_io so that we can display realtime
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/aginfo.c       |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c  |   18 ++++++++++
 libfrog/fsgeom.h  |    4 ++
 man/man8/xfs_io.8 |   14 +++++++-
 4 files changed, 131 insertions(+), 1 deletion(-)


diff --git a/io/aginfo.c b/io/aginfo.c
index 6cbfcb8de35..43e0e9c21b8 100644
--- a/io/aginfo.c
+++ b/io/aginfo.c
@@ -14,6 +14,7 @@
 #include "libfrog/fsgeom.h"
 
 static cmdinfo_t aginfo_cmd;
+static cmdinfo_t rginfo_cmd;
 
 static int
 report_aginfo(
@@ -111,9 +112,104 @@ static cmdinfo_t aginfo_cmd = {
 	.help = aginfo_help,
 };
 
+static int
+report_rginfo(
+	struct xfs_fd		*xfd,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup_geometry	rgeo = { 0 };
+	int			ret;
+
+	ret = -xfrog_rtgroup_geometry(xfd->fd, rgno, &rgeo);
+	if (ret) {
+		xfrog_perror(ret, "rginfo");
+		return 1;
+	}
+
+	printf(_("RG: %u\n"),		rgeo.rg_number);
+	printf(_("Blocks: %u\n"),	rgeo.rg_length);
+	printf(_("Sick: 0x%x\n"),	rgeo.rg_sick);
+	printf(_("Checked: 0x%x\n"),	rgeo.rg_checked);
+	printf(_("Flags: 0x%x\n"),	rgeo.rg_flags);
+
+	return 0;
+}
+
+/* Display rtgroup status. */
+static int
+rginfo_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	unsigned long long	x;
+	xfs_rgnumber_t		rgno = NULLRGNUMBER;
+	int			c;
+	int			ret = 0;
+
+	ret = -xfd_prepare_geometry(&xfd);
+	if (ret) {
+		xfrog_perror(ret, "xfd_prepare_geometry");
+		exitcode = 1;
+		return 1;
+	}
+
+	while ((c = getopt(argc, argv, "r:")) != EOF) {
+		switch (c) {
+		case 'r':
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (!errno && x >= NULLRGNUMBER)
+				errno = ERANGE;
+			if (errno) {
+				perror("rginfo");
+				return 1;
+			}
+			rgno = x;
+			break;
+		default:
+			return command_usage(&rginfo_cmd);
+		}
+	}
+
+	if (rgno != NULLRGNUMBER) {
+		ret = report_rginfo(&xfd, rgno);
+	} else {
+		for (rgno = 0; !ret && rgno < xfd.fsgeom.rgcount; rgno++) {
+			ret = report_rginfo(&xfd, rgno);
+		}
+	}
+
+	return ret;
+}
+
+static void
+rginfo_help(void)
+{
+	printf(_(
+"\n"
+"Report realtime group geometry.\n"
+"\n"
+" -r rgno  -- Report on the given realtime group.\n"
+"\n"));
+
+}
+
+static cmdinfo_t rginfo_cmd = {
+	.name = "rginfo",
+	.cfunc = rginfo_f,
+	.argmin = 0,
+	.argmax = -1,
+	.args = "[-r rgno]",
+	.flags = CMD_NOMAP_OK,
+	.help = rginfo_help,
+};
+
 void
 aginfo_init(void)
 {
 	aginfo_cmd.oneline = _("Get XFS allocation group state.");
 	add_command(&aginfo_cmd);
+	rginfo_cmd.oneline = _("Get XFS realtime group state.");
+	add_command(&rginfo_cmd);
 }
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index b9618661427..63393f0442f 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -212,3 +212,21 @@ xfrog_ag_geometry(
 		return -errno;
 	return 0;
 }
+
+/*
+ * Try to obtain a rt group's geometry.  Returns zero or a negative error code.
+ */
+int
+xfrog_rtgroup_geometry(
+	int			fd,
+	unsigned int		rgno,
+	struct xfs_rtgroup_geometry	*rgeo)
+{
+	int			ret;
+
+	rgeo->rg_number = rgno;
+	ret = ioctl(fd, XFS_IOC_RTGROUP_GEOMETRY, rgeo);
+	if (ret)
+		return -errno;
+	return 0;
+}
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 4f3542eafec..e5d43695901 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -5,10 +5,14 @@
 #ifndef __LIBFROG_FSGEOM_H__
 #define __LIBFROG_FSGEOM_H__
 
+struct xfs_rtgroup_geometry;
+
 void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
 		const char *logname, const char *rtname);
 int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
 int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
+int xfrog_rtgroup_geometry(int fd, unsigned int rgno,
+		struct xfs_rtgroup_geometry *rgeo);
 
 /*
  * Structure for recording whatever observations we want about the level of
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 36ab5f9dc11..6cf4b9e32e5 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1325,6 +1325,19 @@ specific points under adverse conditions. Without the
 .I tag
 argument, displays the list of error tags available.
 Only available in expert mode and requires privileges.
+
+.TP
+.BI "rginfo [ \-r " rgno " ]"
+Show information about or update the state of realtime allocation groups.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-r
+Act only on a specific realtime group.
+.PD
+.RE
+
 .TP
 .BI "resblks [ " blocks " ]"
 Get and/or set count of reserved filesystem blocks using the
@@ -1626,7 +1639,6 @@ flag.
 .B fsuuid
 Print the mounted filesystem UUID.
 
-
 .SH OTHER COMMANDS
 .TP
 .BR "help [ " command " ]"

