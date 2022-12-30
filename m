Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAB1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbiLaCjk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbiLaCjk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:39:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F51A2DED
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:39:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EA7B61CC2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:39:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892D2C433D2;
        Sat, 31 Dec 2022 02:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454378;
        bh=pzTidaFlatay0CJAF24UCRmTVsR6QzSsvS2mb5SwDiI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eZxM60SWmWNoTDhDVBEpTZwR+0Y1aXypBsUx0F9T8kr/SVDu9D0BFGpKoVm02xJsp
         LxJReAPRk2mJK7H95GVAnRZ4dnCAD6m23KRL3fC9eQ1bWen2LR1SE+AifJ0wiY5vBV
         cIwRGNh8b65NvN1ewbkz5P9JHh0a9n8GlAZyfexxSXQkRGLIRpOCsSQVEiIoq3LpTf
         St7fOSV8eEa4FTI8OPlulVo0Q9PWk/akus96iHtrNAVAydVPRvbOZwxWauCsxf8UnJ
         PY7zt1+UOdwVPtiVUKB7Fx3JQgwFDOSYleBKXNzyfXo+qOdFju+d0VuH5QlsdrFBQJ
         0KvTNFxjmlM4A==
Subject: [PATCH 37/45] xfs_io: add a command to display realtime group
 information
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878846.731133.13158073002533445714.stgit@magnolia>
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

Add a new 'rginfo' command to xfs_io so that we can display realtime
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/aginfo.c       |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/fsgeom.c  |   18 ++++++++++
 libfrog/fsgeom.h  |    2 +
 man/man8/xfs_io.8 |   11 ++++++
 4 files changed, 127 insertions(+)


diff --git a/io/aginfo.c b/io/aginfo.c
index 06e1cb7ba88..037af54b60c 100644
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
index 66e813a863f..5a89c3e3ca3 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -210,3 +210,21 @@ xfrog_ag_geometry(
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
index bef864fce63..8c21b240bb2 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -9,6 +9,8 @@ void xfs_report_geom(struct xfs_fsop_geom *geo, const char *mntpoint,
 		const char *logname, const char *rtname);
 int xfrog_geometry(int fd, struct xfs_fsop_geom *fsgeo);
 int xfrog_ag_geometry(int fd, unsigned int agno, struct xfs_ag_geometry *ageo);
+int xfrog_rtgroup_geometry(int fd, unsigned int rgno,
+		struct xfs_rtgroup_geometry *rgeo);
 
 /*
  * Structure for recording whatever observations we want about the level of
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 95c63f32a2a..16768275b5c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1556,6 +1556,17 @@ Show information about or update the state of allocation groups.
 Act only on a specific allocation group.
 .PD
 .RE
+.TP
+.BI "rginfo [ \-r " rgno " ]"
+Show information about or update the state of realtime allocation groups.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-a
+Act only on a specific realtime group.
+.PD
+.RE
 
 .SH OTHER COMMANDS
 .TP

