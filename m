Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EC9433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992501; cv=none; b=lSmwZBRZCXgb80c7ndZiJ7mazZbL3mtTLzeNhLjbaDyJmDV+DRztaUrkgLHWgQqeHFbjQkhQOa5dG3bLcT5+ERf42lHOdY3eHX4Pryxl5LhSJ6UCWQw6zPW4LlNJ4loK6NbsDpxLJLTkqclf6VWFFopuyo3bCZSXwFcymdywKTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992501; c=relaxed/simple;
	bh=jTOGc5ZY9M+WbXpMlAF4wtl+oYHGruqk026jnOULdqk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IaXLBbQmd/Yqu//WxB6ZcKvVF+XodM9h59W1NPBHJpNGUxPiR/cNuwWSNbY1AtVFIh53MzBw0YS5YgjkKvX4qGLJUkc3fZmg9qKkBmivlisVEi7D3yTf1KQZqqVmeqE1LIUBQ0wO8wRingniYNRmA6HSCyJtAGfO2oylAYrpJJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2HPMnzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2HPMnzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52875C4CED3;
	Mon, 23 Dec 2024 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992501;
	bh=jTOGc5ZY9M+WbXpMlAF4wtl+oYHGruqk026jnOULdqk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l2HPMnzTS8it4exWT2i4y8ve4wfSdGvD4u35FA7/UwIn7X8Yo8BLwThDxwRlljEjx
	 K6ILHCf4juSf0Pd1oG3MbCgm6fwNyPkGPthwup8GjLvYuaDcqMabZuJQMta2J6LBQ/
	 Zu0AwM67fQnJXo6hwY4vcGAo4qTA2gj6GQgxP6J/tDIlvYTi1DEe71M97JBWgw50S0
	 Hf2ZEsHHsOUDkR55jqx22BwRuVYh05qP1ZWDAGsR6AiYcsqxRNbenPUztoDSncu9kW
	 CxiG5te1jXGKRz1xpBOtTrOjhFUTR4HzvgzwS77t+Iexn/NsbJC8khKDkcJVbOqk63
	 ifZhQGTHhDRiQ==
Date: Mon, 23 Dec 2024 14:21:40 -0800
Subject: [PATCH 38/51] xfs_io: add a command to display realtime group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944385.2297565.1160370708767559300.stgit@frogsfrogsfrogs>
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

Add a new 'rginfo' command to xfs_io so that we can display realtime
group geometry.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/aginfo.c       |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c  |   18 ++++++++++
 libfrog/fsgeom.h  |    4 ++
 man/man8/xfs_io.8 |   13 +++++++
 4 files changed, 131 insertions(+)


diff --git a/io/aginfo.c b/io/aginfo.c
index 6cbfcb8de35523..f81986f0df4df3 100644
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
+	printf(_("RTG: %u\n"),		rgeo.rg_number);
+	printf(_("Length: %u\n"),	rgeo.rg_length);
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

