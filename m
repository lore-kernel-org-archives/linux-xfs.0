Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A918E35D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992485; cv=none; b=uWOc5ot9gPxMyLzowZyCp8gnAgEF9jMYE8HY2Wzguiky8Lad4nGYXhcj1RsebMsPoIYyFgjgCnVZjYyXUsil/sP4wcnMQLDelbW6EO69APbxbmxmAASUoH+A3Q6woHA+FNiZpGqsiSzAiER9mFlr6Mbw9eUaNFfW0dOyh2ogSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992485; c=relaxed/simple;
	bh=NwukFBwFaWIeCMhGHfVgsB/DoLOithbElAIlu0RzIDw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eYoAqILcw9qexHte+45RRaLOQ9WOY6nJUZIboxNzy4ThIbHWGPRjsAeLeshfXn4dWTS8ukcCciObzlbDk8IPFM5Ls4UMvsVuQIF/5A3+g7w/S1+czTDzJfsvSIrLfJw2aLEYesGKh+pvG/ke3rvK9MY7Doq6CdNpQuzicaQ1wk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uk0Hy5az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uk0Hy5az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A6AC4CEDF;
	Mon, 23 Dec 2024 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992485;
	bh=NwukFBwFaWIeCMhGHfVgsB/DoLOithbElAIlu0RzIDw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uk0Hy5az4T0kgP4JWKhp3XWfBZ9qmnB5zhqZLapsfVq0F4seu/irZOmeCQozQKKJ9
	 Q5vkMtrO65GPkYI66yR9Bei2vAv3wRRpFyc5E7UPxMThJSN+DJORA9Rb1/w3kN8o+4
	 J33ODNtyr8uv2a5aTQj1x2BDJv5gQdZ+uX7Rqh1BD0un8tA5/ibzpn3Bb+OZSz+F+7
	 mBmb7BkIYrXYLGeoH9HyaO4Op3tg+ZHjraHzu0JG/Wr7FI8zxfJsDnEwNi5VomKQbP
	 P6+rORiNhOhhFLWzv7N0UQABRkBqSjCdFYWs0epDqB+rzQA0WDoiDQGXtirs0JV9pv
	 IFARwfRU3lIrQ==
Date: Mon, 23 Dec 2024 14:21:24 -0800
Subject: [PATCH 37/51] xfs_io: add a command to display allocation group
 information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944370.2297565.1566357439077109702.stgit@frogsfrogsfrogs>
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

Add a new 'aginfo' command to xfs_io so that we can display allocation
group geometry.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

