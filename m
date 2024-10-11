Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611B123CE
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610390; cv=none; b=fj6YtQP1AdWkrF0zUr9p973R3IgO47wzCyyFbTOJP9TeFSHh4Wrdr5GsxJIxxDIPtOB43D1yM7JSQnXHrnmfoqEkkoRZYocGgcNBVYQHRoccSszHk0QiJ37pFjSr4aMyfRs3npm97ysrrhq7h/ozu1s60pKHtGf17iJ+wxjBSjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610390; c=relaxed/simple;
	bh=5zlN9z+SSRvt3zYBumfx9aa7x7W7w3BKfRCF6Y8vmTY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A6OtYAmRT9dV+AEy7filfhdqq2OMKBF3y6bO+bQ5kjYKiAu3yKei9YUc9Q01jQpl0dmZ6P0I4aaxI4kflNtCOOqpWiugwbnL3CbOHcivkxjg3HrksZzLobyTz3EeokqMOiL3Q8Zi0+15RZsfqwejPMUzWt6b2ZTaitNin67SdJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVEqBPXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVEqBPXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409DFC4CEC5;
	Fri, 11 Oct 2024 01:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610390;
	bh=5zlN9z+SSRvt3zYBumfx9aa7x7W7w3BKfRCF6Y8vmTY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVEqBPXzwmYXqFxIVSrDS38UyYvAA1daaJVwGgMFLuUzy+1t5xcstgdJQdpPeiGaK
	 ICc1M+AaF8jCIPH6j9dA1WZAfnAa6IlHJ5GCmXedvHg85IlLw3lpuQ5AGsXvrNu0Eg
	 zP0GunWoRW5BUp/+jOR+cSScIlGtjIrm3WB3ca/Ww87tsPGJGGFY78JXDwx3c8ArXa
	 3ozK4lCSV80k/4c5VvoWuOb5qbqY5mS2UCmqtOLiQQEYOsfjv+FnBdOsXsDqko02I3
	 ZxUtIAMO1DQa/Crdese8yr//imzXLAfjjzU2nyaRiQcbpsdDpa41+Y5bj5KDJ7021C
	 1Mq+mbjzS7vdw==
Date: Thu, 10 Oct 2024 18:33:09 -0700
Subject: [PATCH 33/43] xfs_io: add a command to display realtime group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655872.4184637.775532444595191535.stgit@frogsfrogsfrogs>
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

Add a new 'rginfo' command to xfs_io so that we can display realtime
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/aginfo.c       |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c  |   18 ++++++++++
 libfrog/fsgeom.h  |    4 ++
 man/man8/xfs_io.8 |   13 +++++++
 4 files changed, 132 insertions(+)


diff --git a/io/aginfo.c b/io/aginfo.c
index 6cbfcb8de35523..312a3b2d494d12 100644
--- a/io/aginfo.c
+++ b/io/aginfo.c
@@ -14,6 +14,7 @@
 #include "libfrog/fsgeom.h"
 
 static cmdinfo_t aginfo_cmd;
+static cmdinfo_t rginfo_cmd;
 
 static int
 report_aginfo(
@@ -111,9 +112,105 @@ static cmdinfo_t aginfo_cmd = {
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
+	printf(_("Length: %u\n"),	rgeo.rg_length);
+	printf(_("Capacity: %u\n"),	rgeo.rg_capacity);
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
index 9c1e9a90eb1f1b..b5220d2d6ffd22 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -214,3 +214,21 @@ xfrog_ag_geometry(
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
index df2ca2a408e78a..c571ddbcfb9b70 100644
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
index 31c81efed8f99b..59d5ddc54dcc66 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1328,6 +1328,19 @@ .SH FILESYSTEM COMMANDS
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

