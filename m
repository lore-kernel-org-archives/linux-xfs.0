Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878B3C64E7B
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 252BE207BB
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Nov 2020 20:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hMbsiqVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730247AbgKYUik (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Nov 2020 15:38:40 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58626 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKYUik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 15:38:40 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKPITk136712;
        Wed, 25 Nov 2020 20:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s4IBQ3HM7PnPBFol378LMlrcL9DbOmy/u6asYo9Jt30=;
 b=hMbsiqVSX/GEd19AqHLgezjRk0y5KPRruOR518P3YniIb7VxzBEtGQTuKnpixQl44LBz
 2oNJl5Sq5nwPxxMG2fAgqSk/mJ1l637gYV/uIfKxugVqXKmT5vaejCtB7OXkVrDZuMjK
 F0/nhP+tcqBUQSre5ziRgFuyKDHpsqHEdGs85Nnk4GHKvcMeUPHZg/25tsHNooK2o8RT
 v06WXP/UpqcNuc5rSBV5GGN1cCtHoOF941fM4PYZyLB5XkXEZLWZjxD9XjEl1zmkDCxT
 RrMyZGg/hFbZ/tiPC0B/9RDVR9dDe/D4ddKiKrI5b/CKGFDs/eOXKo2j1H8xSaKpHgn6 qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 351kwhbau4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 25 Nov 2020 20:38:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0APKPm2j189317;
        Wed, 25 Nov 2020 20:38:38 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 351kweqkqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Nov 2020 20:38:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0APKcbtX029180;
        Wed, 25 Nov 2020 20:38:37 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 25 Nov 2020 12:38:37 -0800
Subject: [PATCH 1/2] xfs_db: add a directory path lookup command
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 25 Nov 2020 12:38:36 -0800
Message-ID: <160633671661.635630.4898407665487829.stgit@magnolia>
In-Reply-To: <160633671056.635630.15067741092455507598.stgit@magnolia>
References: <160633671056.635630.15067741092455507598.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9816 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=2 adultscore=0 impostorscore=0 mlxscore=0
 spamscore=0 phishscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011250127
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a command to xfs_db so that we can navigate to inodes by path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/Makefile       |    3 -
 db/command.c      |    1 
 db/command.h      |    1 
 db/namei.c        |  223 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    4 +
 5 files changed, 231 insertions(+), 1 deletion(-)
 create mode 100644 db/namei.c


diff --git a/db/Makefile b/db/Makefile
index 9d502bf0d0d6..beafb1058269 100644
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
index 438283699b2e..02f778b9316b 100644
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
index 6913c8171fe1..498983ff92fa 100644
--- a/db/command.h
+++ b/db/command.h
@@ -33,3 +33,4 @@ extern void		btdump_init(void);
 extern void		info_init(void);
 extern void		btheight_init(void);
 extern void		timelimit_init(void);
+extern void		namei_init(void);
diff --git a/db/namei.c b/db/namei.c
new file mode 100644
index 000000000000..13ae7f7d116b
--- /dev/null
+++ b/db/namei.c
@@ -0,0 +1,223 @@
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
index 55388be68b93..4df265ecd59e 100644
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

