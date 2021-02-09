Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3D6C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5166764EB1
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBIEN7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhBIEKn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C04664EB1;
        Tue,  9 Feb 2021 04:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843796;
        bh=Ombxv7QEh+RQSPH528NcL2y2ehYbXT9pJvi89Q+kAfU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f2uopyOPJzvZD9TuiY/oCImrsV+wzKaMM3rA1OB5ZAXOMjLS8MAhebt/6YOO9q+4d
         5gakUWZIB2Y1s2NAbWWUh81d/7yE/1d4Zw79TO4GdnP6uty/TQAnkvgFaUstV/2F+5
         /Na4wGPf/kLQPfrewHTntHoNKv02kqK452WXdz9sE4829XgC6UQKCVAkGDHPWmU43J
         VWbDRQ6Tk1I5xjpMkwT84gdsx5qno2g12OCzwXfKLt5b0jvrKKYphdyGGXBLdvqHvT
         60VlSfXe6INr8w4F4kh40xqM74xnknJFTZDug0WSBQf5m+ifs9chqeT5a3Skt2QyJO
         rhEqep8XjXFVg==
Subject: [PATCH 1/2] xfs_db: add a directory path lookup command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, chandanrlinux@gmail.com
Date:   Mon, 08 Feb 2021 20:09:56 -0800
Message-ID: <161284379615.3056690.1394366028989837229.stgit@magnolia>
In-Reply-To: <161284379028.3056690.9453785606632527710.stgit@magnolia>
References: <161284379028.3056690.9453785606632527710.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a command to xfs_db so that we can navigate to inodes by path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 db/Makefile       |    3 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/namei.c        |  220 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    4 +
 5 files changed, 228 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c


diff --git a/db/Makefile b/db/Makefile
index 9d502bf0..beafb105 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,8 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c timelimit.c
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c \
+	timelimit.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index 43828369..02f778b9 100644
--- a/db/command.c
+++ b/db/command.c
@@ -131,6 +131,7 @@ init_commands(void)
 	logformat_init();
 	io_init();
 	metadump_init();
+	namei_init();
 	output_init();
 	print_init();
 	quit_init();
diff --git a/db/command.h b/db/command.h
index 6913c817..498983ff 100644
--- a/db/command.h
+++ b/db/command.h
@@ -33,3 +33,4 @@ extern void		btdump_init(void);
 extern void		info_init(void);
 extern void		btheight_init(void);
 extern void		timelimit_init(void);
+extern void		namei_init(void);
diff --git a/db/namei.c b/db/namei.c
new file mode 100644
index 00000000..6fddbc4a
--- /dev/null
+++ b/db/namei.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs.h"
+#include "command.h"
+#include "output.h"
+#include "init.h"
+#include "io.h"
+#include "type.h"
+#include "input.h"
+#include "faddr.h"
+#include "fprint.h"
+#include "field.h"
+#include "inode.h"
+
+/* Path lookup */
+
+/* Key for looking up metadata inodes. */
+struct dirpath {
+	/* Array of string pointers. */
+	char		**path;
+
+	/* Number of strings in path. */
+	unsigned int	depth;
+};
+
+static void
+path_free(
+	struct dirpath	*dirpath)
+{
+	unsigned int	i;
+
+	for (i = 0; i < dirpath->depth; i++)
+		free(dirpath->path[i]);
+	free(dirpath->path);
+	free(dirpath);
+}
+
+/* Chop a freeform string path into a structured path. */
+static struct dirpath *
+path_parse(
+	const char	*path)
+{
+	struct dirpath	*dirpath;
+	const char	*p = path;
+	const char	*endp = path + strlen(path);
+
+	dirpath = calloc(sizeof(*dirpath), 1);
+	if (!dirpath)
+		return NULL;
+
+	while (p < endp) {
+		char		**new_path;
+		const char	*next_slash;
+
+		next_slash = strchr(p, '/');
+		if (next_slash == p) {
+			p++;
+			continue;
+		}
+		if (!next_slash)
+			next_slash = endp;
+
+		new_path = realloc(dirpath->path,
+				(dirpath->depth + 1) * sizeof(char *));
+		if (!new_path) {
+			path_free(dirpath);
+			return NULL;
+		}
+
+		dirpath->path = new_path;
+		dirpath->path[dirpath->depth] = strndup(p, next_slash - p);
+		dirpath->depth++;
+
+		p = next_slash + 1;
+	}
+
+	return dirpath;
+}
+
+/* Given a directory and a structured path, walk the path and set the cursor. */
+static int
+path_navigate(
+	struct xfs_mount	*mp,
+	xfs_ino_t		rootino,
+	struct dirpath		*dirpath)
+{
+	struct xfs_inode	*dp;
+	xfs_ino_t		ino = rootino;
+	unsigned int		i;
+	int			error;
+
+	error = -libxfs_iget(mp, NULL, ino, 0, &dp);
+	if (error)
+		return error;
+
+	for (i = 0; i < dirpath->depth; i++) {
+		struct xfs_name	xname = {
+			.name	= dirpath->path[i],
+			.len	= strlen(dirpath->path[i]),
+		};
+
+		if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+			error = ENOTDIR;
+			goto rele;
+		}
+
+		error = -libxfs_dir_lookup(NULL, dp, &xname, &ino, NULL);
+		if (error)
+			goto rele;
+		if (!xfs_verify_ino(mp, ino)) {
+			error = EFSCORRUPTED;
+			goto rele;
+		}
+
+		libxfs_irele(dp);
+		dp = NULL;
+
+		error = -libxfs_iget(mp, NULL, ino, 0, &dp);
+		switch (error) {
+		case EFSCORRUPTED:
+		case EFSBADCRC:
+		case 0:
+			break;
+		default:
+			return error;
+		}
+	}
+
+	set_cur_inode(ino);
+rele:
+	if (dp)
+		libxfs_irele(dp);
+	return error;
+}
+
+/* Walk a directory path to an inode and set the io cursor to that inode. */
+static int
+path_walk(
+	char		*path)
+{
+	struct dirpath	*dirpath;
+	char		*p = path;
+	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
+	int		error = 0;
+
+	if (*p == '/') {
+		/* Absolute path, start from the root inode. */
+		p++;
+	} else {
+		/* Relative path, start from current dir. */
+		if (iocur_top->typ != &typtab[TYP_INODE] ||
+		    !S_ISDIR(iocur_top->mode))
+			return ENOTDIR;
+
+		rootino = iocur_top->ino;
+	}
+
+	dirpath = path_parse(p);
+	if (!dirpath)
+		return ENOMEM;
+
+	error = path_navigate(mp, rootino, dirpath);
+	path_free(dirpath);
+	return error;
+}
+
+static void
+path_help(void)
+{
+	dbprintf(_(
+"\n"
+" Navigate to an inode via directory path.\n"
+	));
+}
+
+static int
+path_f(
+	int		argc,
+	char		**argv)
+{
+	int		c;
+	int		error;
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			path_help();
+			return 0;
+		}
+	}
+
+	error = path_walk(argv[optind]);
+	if (error) {
+		dbprintf("%s: %s\n", argv[optind], strerror(error));
+		exitcode = 1;
+	}
+
+	return 0;
+}
+
+static struct cmdinfo path_cmd = {
+	.name		= "path",
+	.altname	= NULL,
+	.cfunc		= path_f,
+	.argmin		= 1,
+	.argmax		= 1,
+	.canpush	= 0,
+	.args		= "",
+	.help		= path_help,
+};
+
+void
+namei_init(void)
+{
+	path_cmd.oneline = _("navigate to an inode by path");
+	add_command(&path_cmd);
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 55388be6..4df265ec 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -831,6 +831,10 @@ See the
 .B print
 command.
 .TP
+.BI "path " dir_path
+Walk the directory tree to an inode using the supplied path.
+Absolute and relative paths are supported.
+.TP
 .B pop
 Pop location from the stack.
 .TP

