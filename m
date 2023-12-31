Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1CDC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbv1tmXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A369C433C7;
	Sun, 31 Dec 2023 23:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067095;
	bh=c+f56ploWG7PcJFJG3bAJeDIrmMFizvq4LbWYJ6L8co=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fbv1tmXY8LE8l+X4np5UkiwusQI8geG+8/h0987MfICL8TlLK/HUJ7TcYAA7qsdWG
	 duX+ywPmQVvXzbCXJSiJa48MnTmo4bEx+CEurrtD6UXV6SMYUEqJwQdp09A6aFtatk
	 tciL+uwphQcK4a7qhAAEB3WYq9vhAXLTYN4/6FDe3VUIE6vcpwubkkvJIOQYvNge0U
	 rMWgBZmPcuUSSUsWGOc+Ta1cVI5rgASArfkUw5rK5q+pObpPo4plBja3IaYJW3p4xk
	 z0XuZOyOrUtFytyw+Y+04qDV1Ongk9z3YAFQ1gMpVGB0WXbaCJvpdiqbWik7zaJojb
	 g3kQZ1UgLnl3Q==
Date: Sun, 31 Dec 2023 15:58:15 -0800
Subject: [PATCH 41/52] xfs_io: add a command to display allocation group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012712.1811243.6148262402670158207.stgit@frogsfrogsfrogs>
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

Add a new 'aginfo' command to xfs_io so that we can display allocation
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |    2 -
 io/aginfo.c       |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    1 
 man/man8/xfs_io.8 |   12 +++++
 5 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 io/aginfo.c


diff --git a/io/Makefile b/io/Makefile
index 1be6ab77d87..32a40294358 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh
 HFILES = init.h io.h
-CFILES = init.c \
+CFILES = init.c aginfo.c \
 	attr.c bmap.c bulkstat.c crc32cselftest.c cowextsize.c encrypt.c \
 	file.c freeze.c fsuuid.c fsync.c getrusage.c imap.c inject.c label.c \
 	link.c mmap.c open.c parent.c pread.c prealloc.c pwrite.c reflink.c \
diff --git a/io/aginfo.c b/io/aginfo.c
new file mode 100644
index 00000000000..6cbfcb8de35
--- /dev/null
+++ b/io/aginfo.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All rights reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
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
index a6c3d0cf147..dee09b56333 100644
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
index a30b96401a7..61920fcee7f 100644
--- a/io/io.h
+++ b/io/io.h
@@ -190,3 +190,4 @@ extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
 extern void		atomicupdate_init(void);
+extern void		aginfo_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 61eed7f5aa8..36ab5f9dc11 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1239,6 +1239,18 @@ Dumps a list of pages or ranges of pages that are currently in core,
 for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
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
+
 .TP
 .BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-m ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
 Display raw stat information about a bunch of inodes in an XFS filesystem.

