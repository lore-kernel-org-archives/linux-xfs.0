Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50132C433E6
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AFC23A69
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbhAIG2d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:28:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39738 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbhAIG2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:28:33 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 109695dl110583;
        Sat, 9 Jan 2021 06:27:51 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35y4ekg8h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:27:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096AaIf033319;
        Sat, 9 Jan 2021 06:27:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35y2h9nhmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:27:50 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1096Ro35027308;
        Sat, 9 Jan 2021 06:27:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Jan 2021 22:27:50 -0800
Subject: [PATCH 1/2] xfs_db: add a directory path lookup command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:27:48 -0800
Message-ID: <161017366883.1141395.10618385129377975380.stgit@magnolia>
In-Reply-To: <161017366263.1141395.6702925907212907016.stgit@magnolia>
References: <161017366263.1141395.6702925907212907016.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1034
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a command to xfs_db so that we can navigate to inodes by path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/Makefile       |    3 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/namei.c        |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    4 +
 5 files changed, 231 insertions(+), 1 deletion(-)
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
index 00000000..eebebe15
--- /dev/null
+++ b/db/namei.c
@@ -0,0 +1,223 @@
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
+	if (error)
+		return error;
+
+	path_free(dirpath);
+	return 0;
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

