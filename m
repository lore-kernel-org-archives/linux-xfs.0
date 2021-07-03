Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053B8C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E0661424
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhGCDBB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:01:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGCDBA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:01:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C337D613EB;
        Sat,  3 Jul 2021 02:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281107;
        bh=zSlEzxEgCyOt2ZzeOJUaqNrD6fpzt7xQi2bC8ejj+LM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I6iH2BVGf/jc8QUipGO6U6wHoOwUj81il8i/3pK4FgibKGmRR/wHq8lP261z6nFLs
         DyjX6wnu3HSiBQZay5ILqkbnXpVfQKPHxSaSwFs3BoKjx85URhwQKlfot3eYncGw3i
         /F8Fv0rQzpkjOgVwxUDs+ajQySSrJDB6HSmfJUxXaQXfevr5tg2hIe9n3+O8kVwEp9
         /rmm+PX4QqZ3exSNpZ6aA6kckvJJWD11E4+w3zdlLyXimFXPGeoSYrIs4nMQ4LR4Lv
         FhpdN1OjxllYPOCG4HolmQ4G+xe6lEtPUff4NL1gLwMMq1NRZXW83uMalr+CLUxa1v
         Aob9g7UbpDHzg==
Subject: [PATCH 1/1] xfs_io: allow callers to dump fs stats individually
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:27 -0700
Message-ID: <162528110744.38907.9770913472348824425.stgit@locust>
In-Reply-To: <162528110197.38907.6647015481710886949.stgit@locust>
References: <162528110197.38907.6647015481710886949.stgit@locust>
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
 io/stat.c         |  149 +++++++++++++++++++++++++++++++++++++++--------------
 man/man8/xfs_io.8 |   17 ++++++
 2 files changed, 127 insertions(+), 39 deletions(-)


diff --git a/io/stat.c b/io/stat.c
index 49c4c27c..1993247c 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -171,6 +171,26 @@ stat_f(
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
+" -a -- Print statfs, geometry, and fs summary count data.\n"
+" -c -- Print fs summary count data.\n"
+" -g -- Print fs geometry data.\n"
+" -s -- Print statfs data.\n"
+"\n"));
+}
+
+#define REPORT_STATFS		(1 << 0)
+#define REPORT_GEOMETRY		(1 << 1)
+#define REPORT_FSCOUNTS		(1 << 2)
+#define REPORT_DEFAULT		(1 << 31)
+
 static int
 statfs_f(
 	int			argc,
@@ -179,55 +199,102 @@ statfs_f(
 	struct xfs_fsop_counts	fscounts;
 	struct xfs_fsop_geom	fsgeo;
 	struct statfs		st;
+	unsigned int		flags = REPORT_DEFAULT;
+	int			c;
 	int			ret;
 
+	while ((c = getopt(argc, argv, "acgs")) != EOF) {
+		switch (c) {
+		case 'a':
+			flags = REPORT_STATFS | REPORT_GEOMETRY |
+				REPORT_FSCOUNTS;
+			break;
+		case 'c':
+			flags &= ~REPORT_DEFAULT;
+			flags |= REPORT_FSCOUNTS;
+			break;
+		case 'g':
+			flags &= ~REPORT_GEOMETRY;
+			flags |= REPORT_FSCOUNTS;
+			break;
+		case 's':
+			flags &= ~REPORT_STATFS;
+			flags |= REPORT_FSCOUNTS;
+			break;
+		default:
+			exitcode = 1;
+			return command_usage(&statfs_cmd);
+		}
+	}
+
+	if (flags & REPORT_DEFAULT)
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
 
@@ -407,9 +474,13 @@ stat_init(void)
 
 	statfs_cmd.name = "statfs";
 	statfs_cmd.cfunc = statfs_f;
+	statfs_cmd.argmin = 0;
+	statfs_cmd.argmax = -1;
+	statfs_cmd.args = _("[-a] [-c] [-g] [-s]");
 	statfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	statfs_cmd.oneline =
 		_("statistics on the filesystem of the currently open file");
+	statfs_cmd.help = statfs_help;
 
 	add_command(&stat_cmd);
 	add_command(&statx_cmd);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 1103dc42..32bdd866 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1240,6 +1240,23 @@ Selected statistics from
 .BR statfs (2)
 and the XFS_IOC_FSGEOMETRY
 system call on the filesystem where the current file resides.
+.RS 1.0i
+.PD 0
+.TP
+.BI \-a
+Display statfs, geometry, and fs summary counter data.
+.TP
+.BI \-c
+Display fs summary counter data.
+.TP
+.BI \-g
+Display geometry data.
+.TP
+.BI \-s
+Display statfs data.
+.TP
+.RE
+.PD
 .TP
 .BI "inode  [ [ -n ] " number " ] [ -v ]"
 The inode command queries physical information about an inode. With

