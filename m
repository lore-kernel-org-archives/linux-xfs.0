Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3469F507
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610374; cv=none; b=JGHKDOWcwFojg0EXOrZ40Vlejjl45yH3IrDD2o8ZPZ5tABDlHcAEngraX9Oq+eHAWWeg3VLAqcL/orwke7K4/JOIhretBQ3Z+EssbGC5E5tDszsHV7OmKVBg8ZrQuKxWZHRBo8Vd+U47Nv5vX+HIJG58KllD4egwUTwOu1f0YJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610374; c=relaxed/simple;
	bh=tl51vnEgRmwpZAECKNfC/hNKjkpw9HzE4Uc9iVjfqXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uIZ1IqTxU0iG3KtbqJ/ZFNZAdDcbLroDSAUNu2092j+SZmLWIfjNhF2BbAqba7Es4HsucSy3vF1kP11yL8JxwXL8N6XnEBM1CAcd/SmvPTddIEc6AFeCP3yvJQur6Zo6ginjk+A7yExQ5Z43H1HA8r8vBJA147ymSThxAsLtHN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYoTbA3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYoTbA3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A212FC4CEC5;
	Fri, 11 Oct 2024 01:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610374;
	bh=tl51vnEgRmwpZAECKNfC/hNKjkpw9HzE4Uc9iVjfqXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DYoTbA3+0B7B0c7JfuTWmWIo1MwOnI8pukv++YzeYlBqWlIVZqivpgsHiXIAZonrI
	 oZi0EFcs9LJK+PmHzzYRgBpXLf2fn51f6lGR61M6sqNfg5AQ8+KEZ0zbowRZHE5ymN
	 NR+CPU/u/+4lXSH4ZfDtJqmxPnykYCHFAvhOtEH1JVFHbd22bToUDfJOisBLKil3KP
	 rN2gqbh80JcVrYxFVq5JEVbKvIb2zjGn59f14/ws6Fxk466QZJ12xbGoipM2tVcjdC
	 LC116rHp8cAKv+slLDuas+dzVOb8/dD0lXaM+Ff31D/5mCNJdsEaKWh+j+BwmxmItS
	 R6brY/l1zEEcw==
Date: Thu, 10 Oct 2024 18:32:54 -0700
Subject: [PATCH 32/43] xfs_io: add a command to display allocation group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655856.4184637.1638688618830136545.stgit@frogsfrogsfrogs>
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

Add a new 'aginfo' command to xfs_io so that we can display allocation
group geometry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/Makefile       |    1 
 io/aginfo.c       |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    1 
 man/man8/xfs_io.8 |   12 +++++
 5 files changed, 134 insertions(+)
 create mode 100644 io/aginfo.c


diff --git a/io/Makefile b/io/Makefile
index c33d57f5e10b8f..8f835ec71fd768 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -9,6 +9,7 @@ LTCOMMAND = xfs_io
 LSRCFILES = xfs_bmap.sh xfs_freeze.sh xfs_mkfile.sh xfs_property
 HFILES = init.h io.h
 CFILES = \
+	aginfo.c \
 	attr.c \
 	bmap.c \
 	bulkstat.c \
diff --git a/io/aginfo.c b/io/aginfo.c
new file mode 100644
index 00000000000000..6cbfcb8de35523
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
index 5727f73515a6a2..4831deae1b2683 100644
--- a/io/init.c
+++ b/io/init.c
@@ -44,6 +44,7 @@ init_cvtnum(
 static void
 init_commands(void)
 {
+	aginfo_init();
 	attr_init();
 	bmap_init();
 	bulkstat_init();
diff --git a/io/io.h b/io/io.h
index 4daedac06419ae..d99065582057de 100644
--- a/io/io.h
+++ b/io/io.h
@@ -155,3 +155,4 @@ extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
 void			exchangerange_init(void);
 void			fsprops_init(void);
+void			aginfo_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 4673b071901c28..31c81efed8f99b 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1242,6 +1242,18 @@ .SH MEMORY MAPPED I/O COMMANDS
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

