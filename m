Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F24C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D0B460462
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhG1VQl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhG1VQk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCB2461039;
        Wed, 28 Jul 2021 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506999;
        bh=fdKxmL0ew+fUc7A8Poam3GpmS3fMn8nBxVlP7/C6KFs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MFeoKHTVDXIo84dwdUbEL197geW3wdiCdxRsO1+/hKQDe/3YXkxp5pX/Cl48e6H8k
         avk4xgkBdVh18CzuBKGKu+x3SfQkNy9tKMwcrA5W6caR5ZT2EAiLYpqAu2kmZr/nnI
         nxJYUbOjpaGnsnVaIoi8ZqtsZhNqQAnW3UU65cD0Z+jZI0zgwOHkXJr1kjEX5+Ki42
         WMeGOaQPCj2w/HOSvLtEaAiOP8+EOMvDsXkt06wIs4xO0boBLPF7FbW3Stig/6oLu5
         xKg4qdHOhcC4xEvvKnEatHOxpJqmoTUp+98eI1B4sgJZ7XVcUZtblmU9kkXG7lU970
         xDXEEX7hixrPQ==
Subject: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 28 Jul 2021 14:16:38 -0700
Message-ID: <162750699859.45983.16505496110971663895.stgit@magnolia>
In-Reply-To: <162750699314.45983.15238050911081991698.stgit@magnolia>
References: <162750699314.45983.15238050911081991698.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Enable callers to decide if they want to see statfs, fscounts, or
geometry information (or any combination) from the xfs_io statfs
command.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/stat.c         |  140 ++++++++++++++++++++++++++++++++++++++---------------
 man/man8/xfs_io.8 |   26 ++++++++--
 2 files changed, 123 insertions(+), 43 deletions(-)


diff --git a/io/stat.c b/io/stat.c
index 49c4c27c..b57f9eef 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -171,6 +171,24 @@ stat_f(
 	return 0;
 }
 
+static void
+statfs_help(void)
+{
+        printf(_(
+"\n"
+" Display file system status.\n"
+"\n"
+" Options:\n"
+" -c -- Print fs summary count data.\n"
+" -g -- Print fs geometry data.\n"
+" -s -- Print statfs data.\n"
+"\n"));
+}
+
+#define REPORT_STATFS		(1 << 0)
+#define REPORT_GEOMETRY		(1 << 1)
+#define REPORT_FSCOUNTS		(1 << 2)
+
 static int
 statfs_f(
 	int			argc,
@@ -179,55 +197,95 @@ statfs_f(
 	struct xfs_fsop_counts	fscounts;
 	struct xfs_fsop_geom	fsgeo;
 	struct statfs		st;
+	unsigned int		flags = 0;
+	int			c;
 	int			ret;
 
+	while ((c = getopt(argc, argv, "cgs")) != EOF) {
+		switch (c) {
+		case 'c':
+			flags |= REPORT_FSCOUNTS;
+			break;
+		case 'g':
+			flags |= REPORT_GEOMETRY;
+			break;
+		case 's':
+			flags |= REPORT_STATFS;
+			break;
+		default:
+			exitcode = 1;
+			return command_usage(&statfs_cmd);
+		}
+	}
+
+	if (!flags)
+		flags = REPORT_STATFS | REPORT_GEOMETRY | REPORT_FSCOUNTS;
+
 	printf(_("fd.path = \"%s\"\n"), file->name);
-	if (platform_fstatfs(file->fd, &st) < 0) {
-		perror("fstatfs");
-		exitcode = 1;
-	} else {
-		printf(_("statfs.f_bsize = %lld\n"), (long long) st.f_bsize);
-		printf(_("statfs.f_blocks = %lld\n"), (long long) st.f_blocks);
-		printf(_("statfs.f_bavail = %lld\n"), (long long) st.f_bavail);
-		printf(_("statfs.f_files = %lld\n"), (long long) st.f_files);
-		printf(_("statfs.f_ffree = %lld\n"), (long long) st.f_ffree);
+	if (flags & REPORT_STATFS) {
+		ret = platform_fstatfs(file->fd, &st);
+		if (ret < 0) {
+			perror("fstatfs");
+			exitcode = 1;
+		} else {
+			printf(_("statfs.f_bsize = %lld\n"),
+					(long long) st.f_bsize);
+			printf(_("statfs.f_blocks = %lld\n"),
+					(long long) st.f_blocks);
+			printf(_("statfs.f_bavail = %lld\n"),
+					(long long) st.f_bavail);
+			printf(_("statfs.f_files = %lld\n"),
+					(long long) st.f_files);
+			printf(_("statfs.f_ffree = %lld\n"),
+					(long long) st.f_ffree);
 #ifdef HAVE_STATFS_FLAGS
-		printf(_("statfs.f_flags = 0x%llx\n"), (long long) st.f_flags);
+			printf(_("statfs.f_flags = 0x%llx\n"),
+					(long long) st.f_flags);
 #endif
+		}
 	}
+
 	if (file->flags & IO_FOREIGN)
 		return 0;
-	ret = -xfrog_geometry(file->fd, &fsgeo);
-	if (ret) {
-		xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
-		exitcode = 1;
-	} else {
-		printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
-		printf(_("geom.agcount = %u\n"), fsgeo.agcount);
-		printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
-		printf(_("geom.datablocks = %llu\n"),
-			(unsigned long long) fsgeo.datablocks);
-		printf(_("geom.rtblocks = %llu\n"),
-			(unsigned long long) fsgeo.rtblocks);
-		printf(_("geom.rtextents = %llu\n"),
-			(unsigned long long) fsgeo.rtextents);
-		printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
-		printf(_("geom.sunit = %u\n"), fsgeo.sunit);
-		printf(_("geom.swidth = %u\n"), fsgeo.swidth);
+
+	if (flags & REPORT_GEOMETRY) {
+		ret = -xfrog_geometry(file->fd, &fsgeo);
+		if (ret) {
+			xfrog_perror(ret, "XFS_IOC_FSGEOMETRY");
+			exitcode = 1;
+		} else {
+			printf(_("geom.bsize = %u\n"), fsgeo.blocksize);
+			printf(_("geom.agcount = %u\n"), fsgeo.agcount);
+			printf(_("geom.agblocks = %u\n"), fsgeo.agblocks);
+			printf(_("geom.datablocks = %llu\n"),
+				(unsigned long long) fsgeo.datablocks);
+			printf(_("geom.rtblocks = %llu\n"),
+				(unsigned long long) fsgeo.rtblocks);
+			printf(_("geom.rtextents = %llu\n"),
+				(unsigned long long) fsgeo.rtextents);
+			printf(_("geom.rtextsize = %u\n"), fsgeo.rtextsize);
+			printf(_("geom.sunit = %u\n"), fsgeo.sunit);
+			printf(_("geom.swidth = %u\n"), fsgeo.swidth);
+		}
 	}
-	if ((xfsctl(file->name, file->fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
-		perror("XFS_IOC_FSCOUNTS");
-		exitcode = 1;
-	} else {
-		printf(_("counts.freedata = %llu\n"),
-			(unsigned long long) fscounts.freedata);
-		printf(_("counts.freertx = %llu\n"),
-			(unsigned long long) fscounts.freertx);
-		printf(_("counts.freeino = %llu\n"),
-			(unsigned long long) fscounts.freeino);
-		printf(_("counts.allocino = %llu\n"),
-			(unsigned long long) fscounts.allocino);
+
+	if (flags & REPORT_FSCOUNTS) {
+		ret = ioctl(file->fd, XFS_IOC_FSCOUNTS, &fscounts);
+		if (ret < 0) {
+			perror("XFS_IOC_FSCOUNTS");
+			exitcode = 1;
+		} else {
+			printf(_("counts.freedata = %llu\n"),
+				(unsigned long long) fscounts.freedata);
+			printf(_("counts.freertx = %llu\n"),
+				(unsigned long long) fscounts.freertx);
+			printf(_("counts.freeino = %llu\n"),
+				(unsigned long long) fscounts.freeino);
+			printf(_("counts.allocino = %llu\n"),
+				(unsigned long long) fscounts.allocino);
+		}
 	}
+
 	return 0;
 }
 
@@ -407,9 +465,13 @@ stat_init(void)
 
 	statfs_cmd.name = "statfs";
 	statfs_cmd.cfunc = statfs_f;
+	statfs_cmd.argmin = 0;
+	statfs_cmd.argmax = -1;
+	statfs_cmd.args = _("[-c] [-g] [-s]");
 	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	statfs_cmd.oneline =
 		_("statistics on the filesystem of the currently open file");
+	statfs_cmd.help = statfs_help;
 
 	add_command(&stat_cmd);
 	add_command(&statx_cmd);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 1103dc42..e3c5d3ea 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1235,11 +1235,29 @@ down, matching XFS behavior when critical corruption is encountered.
 .PD
 .RE
 .TP
-.B statfs
-Selected statistics from
+.B statfs [ -c ] [ -g ] [ -s ]
+Report selected statistics on the filesystem where the current file resides.
+The default behavior is to enable all three reporting options:
+.RS 1.0i
+.PD 0
+.TP
+.BI \-c
+Display
+.B XFS_IOC_FSCOUNTERS
+summary counter data.
+.TP
+.BI \-g
+Display
+.B XFS_IOC_FSGEOMETRY
+filesystem geometry data.
+.TP
+.BI \-s
+Display
 .BR statfs (2)
-and the XFS_IOC_FSGEOMETRY
-system call on the filesystem where the current file resides.
+data.
+.TP
+.RE
+.PD
 .TP
 .BI "inode  [ [ -n ] " number " ] [ -v ]"
 The inode command queries physical information about an inode. With

