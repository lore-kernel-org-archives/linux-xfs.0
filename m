Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F74C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236263AbiLaCj1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiLaCj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:39:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84731BC95
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:39:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AEDFB81E04
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2588C433D2;
        Sat, 31 Dec 2022 02:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454363;
        bh=TG5EGXuWwqgE0qA/pHaDpR3uRd3djMy9AJeBCDPNK84=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q+XdMTFKjZDuFuixTh2DMG2sGq2vy0bX/l9OYnUsKn7bXQSAys74eZZ2SqpyQ6CZJ
         LirTw6T+wgUD8+TqAhbLCkALjN9sH+8OswH0O14KKmE/CuiIohtD6CIWQZDgvwZD/h
         98elND7FXi60H5jrP+qr88pxjPd8FBHBCUXDbAceb7dm1T4ng6ru4WN/RrjEqcfYw3
         feYCUebH0yCXmDHh/3/+Hedl4hD+ZVXhrpxxY3bqgWX+USyyq3DGHYzLEwYZFOzvP9
         PNcDse5UoBREBtBqcvx7hoc/+wZbAxNRP6hEAP/cdwvitcn7PLbSjhza9f9gTHCVnc
         SvjH0f/QS3MmQ==
Subject: [PATCH 36/45] xfs_io: add a command to display allocation group
 information
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878834.731133.914666716081594964.stgit@magnolia>
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

Add a new 'aginfo' command to xfs_io so that we can display allocation
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |    2 -
 io/aginfo.c       |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    1 
 man/man8/xfs_io.8 |   12 +++++
 5 files changed, 133 insertions(+), 2 deletions(-)
 create mode 100644 io/aginfo.c


diff --git a/io/Makefile b/io/Makefile
index aa0d216b25f..2b7748bfc13 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
-CFILES = init.c \
+CFILES = init.c aginfo.c \
 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
 	file.c freeze.c fsync.c getrusage.c imap.c inject.c label.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
diff --git a/io/aginfo.c b/io/aginfo.c
new file mode 100644
index 00000000000..06e1cb7ba88
--- /dev/null
+++ b/io/aginfo.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022 Oracle.
+ * All Rights Reserved.
+ */
+#include "platform_defs.h"
+#include "libxfs.h"
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+#include "libfrog/logging.h"
+#include "libfrog/paths.h"
+#include "libfrog/fsgeom.h"
+
+static cmdinfo_t aginfo_cmd;
+
+static int
+report_aginfo(
+	struct xfs_fd		*xfd,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_ag_geometry	ageo = { 0 };
+	int			ret;
+
+	ret = -xfrog_ag_geometry(xfd->fd, agno, &ageo);
+	if (ret) {
+		xfrog_perror(ret, "aginfo");
+		return 1;
+	}
+
+	printf(_("AG: %u\n"),		ageo.ag_number);
+	printf(_("Blocks: %u\n"),	ageo.ag_length);
+	printf(_("Free Blocks: %u\n"),	ageo.ag_freeblks);
+	printf(_("Inodes: %u\n"),	ageo.ag_icount);
+	printf(_("Free Inodes: %u\n"),	ageo.ag_ifree);
+	printf(_("Sick: 0x%x\n"),	ageo.ag_sick);
+	printf(_("Checked: 0x%x\n"),	ageo.ag_checked);
+	printf(_("Flags: 0x%x\n"),	ageo.ag_flags);
+
+	return 0;
+}
+
+/* Display AG status. */
+static int
+aginfo_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	unsigned long long	x;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
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
+	while ((c = getopt(argc, argv, "a:")) != EOF) {
+		switch (c) {
+		case 'a':
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (!errno && x >= NULLAGNUMBER)
+				errno = ERANGE;
+			if (errno) {
+				perror("aginfo");
+				return 1;
+			}
+			agno = x;
+			break;
+		default:
+			return command_usage(&aginfo_cmd);
+		}
+	}
+
+	if (agno != NULLAGNUMBER) {
+		ret = report_aginfo(&xfd, agno);
+	} else {
+		for (agno = 0; !ret && agno < xfd.fsgeom.agcount; agno++) {
+			ret = report_aginfo(&xfd, agno);
+		}
+	}
+
+	return ret;
+}
+
+static void
+aginfo_help(void)
+{
+	printf(_(
+"\n"
+"Report allocation group geometry.\n"
+"\n"
+" -a agno  -- Report on the given allocation group.\n"
+"\n"));
+
+}
+
+static cmdinfo_t aginfo_cmd = {
+	.name = "aginfo",
+	.cfunc = aginfo_f,
+	.argmin = 0,
+	.argmax = -1,
+	.args = "[-a agno]",
+	.flags = CMD_NOMAP_OK,
+	.help = aginfo_help,
+};
+
+void
+aginfo_init(void)
+{
+	aginfo_cmd.oneline = _("Get XFS allocation group state.");
+	add_command(&aginfo_cmd);
+}
diff --git a/io/init.c b/io/init.c
index 96536a25a1f..78d7d04e7a6 100644
--- a/io/init.c
+++ b/io/init.c
@@ -44,6 +44,7 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	aginfo_init();
 	atomicupdate_init();
 	attr_init();
 	bmap_init();
diff --git a/io/io.h b/io/io.h
index 1cfe8edc2db..77bedf5159d 100644
--- a/io/io.h
+++ b/io/io.h
@@ -189,3 +189,4 @@ extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
 extern void		atomicupdate_init(void);
+extern void		aginfo_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 0c0b00b5712..95c63f32a2a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1545,7 +1545,17 @@ This option is not compatible with the
 flag.
 .RE
 .PD
-
+.TP
+.BI "aginfo [ \-a " agno " ]"
+Show information about or update the state of allocation groups.
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI \-a
+Act only on a specific allocation group.
+.PD
+.RE
 
 .SH OTHER COMMANDS
 .TP

