Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001B3C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B195F20747
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:32:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a45PB2YH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406456AbgJZXcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:32:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53478 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406455AbgJZXco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:32:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOWDo164617;
        Mon, 26 Oct 2020 23:32:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=6aB/zvFqqmKQ3JTWVxXw1qKvNwtJKM/0ZdOPVf+Zze0=;
 b=a45PB2YHlOg8Tx5dpvJhUeWf5l2rsGyFuteFogd1hmgj76strjcfxNeJ974L4e5REK4J
 Trn/ouZg7KN5tvfSgAsBlzAYbYykgJnbEWSiaxlAKa8YNE5C5m7R+gl4FGHlL1sz6WSt
 P3PXHuIpdewBx+Ejk/HhXk7tBJ26offjkcgQyqPestjFjlnlYiF9hQ95nf0aGfUhk2bG
 zlWOyvjH6gFCgKkPJjXrE3O1nk1/KaWdL3bc814/9knnfEFjHPtx2xnv46YdU0TfJJo7
 47aaEy+Pluy0i2HveQMRv72MrYykOXradS6rastlbEtwRXwZ9ZoF4ZsgKZaotCyyFFXi uQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm3vuhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:32:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNQF3F032580;
        Mon, 26 Oct 2020 23:32:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1q2aag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:32:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNWeCh011810;
        Mon, 26 Oct 2020 23:32:40 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:32:35 -0700
Subject: [PATCH 1/2] xfs_db: add a directory path lookup command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:32:34 -0700
Message-ID: <160375515483.880118.8069916247570952970.stgit@magnolia>
In-Reply-To: <160375514873.880118.10145241423813965771.stgit@magnolia>
References: <160375514873.880118.10145241423813965771.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a command to xfs_db so that we can navigate to inodes by path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile       |    2 
 db/command.c      |    1 
 db/command.h      |    1 
 db/namei.c        |  228 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    4 +
 5 files changed, 235 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c


diff --git a/db/Makefile b/db/Makefile
index 9bd9bf514f5d..67908a2c3c98 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h logformat.h malloc.h metadump.h output.h print.h quit.h sb.h \
 	sig.h strvec.h text.h type.h write.h attrset.h symlink.h fsmap.h \
 	fuzz.h
-CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c
+CFILES = $(HFILES:.h=.c) btdump.c btheight.c convert.c info.c namei.c
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
diff --git a/db/command.c b/db/command.c
index 0fb44efaec59..053097742b12 100644
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
index b8499de0be17..bf130e63c85c 100644
--- a/db/command.h
+++ b/db/command.h
@@ -32,3 +32,4 @@ extern void		convert_init(void);
 extern void		btdump_init(void);
 extern void		info_init(void);
 extern void		btheight_init(void);
+extern void		namei_init(void);
diff --git a/db/namei.c b/db/namei.c
new file mode 100644
index 000000000000..3c9889d62338
--- /dev/null
+++ b/db/namei.c
@@ -0,0 +1,228 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2020 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+	int		ret = 0;
+
+	if (*p == '/') {
+		/* Absolute path, start from the root inode. */
+		p++;
+	} else {
+		/* Relative path, start from current dir. */
+		if (iocur_top->typ != &typtab[TYP_INODE]) {
+			dbprintf(_("current object is not an inode.\n"));
+			return -1;
+		}
+
+		if (!S_ISDIR(iocur_top->mode)) {
+			dbprintf(_("current inode %llu is not a directory.\n"),
+					(unsigned long long)iocur_top->ino);
+			return -1;
+		}
+		rootino = iocur_top->ino;
+	}
+
+	dirpath = path_parse(p);
+	if (!dirpath) {
+		dbprintf(_("%s: not enough memory to parse.\n"), path);
+		return -1;
+	}
+
+	ret = path_navigate(mp, rootino, dirpath);
+	if (ret) {
+		dbprintf(_("%s: %s\n"), path, strerror(ret));
+		ret = -1;
+	}
+
+	path_free(dirpath);
+	return ret;
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
+
+	while ((c = getopt(argc, argv, "")) != -1) {
+		switch (c) {
+		default:
+			path_help();
+			return 0;
+		}
+	}
+
+	if (path_walk(argv[optind]))
+		exitcode = 1;
+	return 0;
+}
+
+static const cmdinfo_t path_cmd = {
+	.name		= "path",
+	.altname	= NULL,
+	.cfunc		= path_f,
+	.argmin		= 1,
+	.argmax		= 1,
+	.canpush	= 0,
+	.args		= "",
+	.oneline	= N_("navigate to an inode by path"),
+	.help		= path_help,
+};
+
+void
+namei_init(void)
+{
+	add_command(&path_cmd);
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 7f73d458cf76..d67e108a706a 100644
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

