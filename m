Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EE21854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309615; cv=none; b=KY3I7NQH2mfbI2e0J1ZKQ7CAgVIoyxCq1QBa2u4bt/Hi4zDNz3d6kDk/NdMrZX4OY29SiHlKomoy8KLF7I0iPD0x5qfSFd8mVg8rg7svRB8x+KQR3ajmv7FZoZ6P3cw6CZx71lQ+7EJHwz+hwzVtFRj/eNnusSaNQJ84QA/TEsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309615; c=relaxed/simple;
	bh=bm5sYLxHQGsqGuAGJpVZnDcbed6Sa1JWty2LH0JqlvM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RB/sHZFX0GPgKGcO01b0BRYVMI+g3NR2bmMJYu/XWvaswZo4Q/LuVwue1tVm0xykcGAg+lzDwnpGa8Yv7dVxyP5u4XPhSVum1pWe3J54FKwB5ICuX47teN94ix+OoFQ4h3fbIs+B3Tb4KhCn87MdL4w7YttdObGT5UBjbPxjvfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B60rTDwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B60rTDwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE06C32786;
	Tue, 30 Jul 2024 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309615;
	bh=bm5sYLxHQGsqGuAGJpVZnDcbed6Sa1JWty2LH0JqlvM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B60rTDweVniMD7VOGVSg95LvK3jvEKU5o7xWFrrJmysy7LKmcKaVjlPR62u81HBTO
	 tdZAQ3ZZdHR9Ta/WNRTC9mvlV9IEJSQUer1PYymMR3SZXZn7i/row2zajZvfg0iYu/
	 GXUFD7IUHRxo7vyr+qHL22MjYwYW8Jyvgr9k5f0V/WmZ+UffygCDkiTpFSLwaIlhfz
	 qq3eCKZcfLbYCwVs9N1FU3Jee3QuFAUQ1+t/PDPMTOBQODse1H55NI+0A3RW1s54Ja
	 r+ZriAcIWZZAmeDamH8ocIV1HQ5BWQMwV5r3N/MKStoay/FLj8QTQBqFM6EGaMwQst
	 NfZ7HLa/m1J7w==
Date: Mon, 29 Jul 2024 20:20:14 -0700
Subject: [PATCH 2/7] xfs_spaceman: edit filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940600.1543753.11770032596501355577.stgit@frogsfrogsfrogs>
In-Reply-To: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
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

Add some new subcommands to xfs_spaceman so that we can examine
filesystem properties.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_spaceman.8 |   27 ++++
 spaceman/Makefile       |    4 +
 spaceman/init.c         |    1 
 spaceman/properties.c   |  342 +++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/space.h        |    1 
 5 files changed, 375 insertions(+)
 create mode 100644 spaceman/properties.c


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 0d299132a788..4615774de59e 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -217,3 +217,30 @@ Do not trim free space extents shorter than this length.
 Units can be appended to this argument.
 .PD
 .RE
+
+.SH FILESYSTEM PROPERTIES
+If the opened file is the root directory of a filesystem, the following
+commands can be used to read and write filesystem properties.
+These properties allow system administrators to express their preferences for
+the filesystem in question.
+.TP
+.BI "getfsprops name [ " names "... ]"
+Retrieve the values of the given filesystem properties.
+.TP
+.BI "listfsprops"
+List all filesystem properties that have been stored in the filesystem.
+.TP
+.BI "setfsprops " name = value " [ " name = value "... ]"
+Set the given filesystem properties to the specified values.
+.TP
+.BI "removefsprops name [ " names "... ]"
+Remove the given filesystem properties.
+
+.RE
+Currently supported filesystem properties are:
+.TP
+.B self_healing
+See the
+.BR xfs_scrub (8)
+manual for more information.
+.RE
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 358db9edf5cb..2688b37c770d 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -30,6 +30,10 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += freesp.c
 endif
 
+ifeq ($(HAVE_LIBATTR),yes)
+CFILES += properties.c
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cbb0ee..aff666cdb670 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -35,6 +35,7 @@ init_commands(void)
 	trim_init();
 	freesp_init();
 	health_init();
+	fsprops_init();
 }
 
 static int
diff --git a/spaceman/properties.c b/spaceman/properties.c
new file mode 100644
index 000000000000..dbe628c1184a
--- /dev/null
+++ b/spaceman/properties.c
@@ -0,0 +1,342 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "input.h"
+#include "libfrog/fsgeom.h"
+#include "handle.h"
+#include "space.h"
+#include "libfrog/fsprops.h"
+#include "libfrog/fsproperties.h"
+
+#include <attr/attributes.h>
+
+static void
+listfsprops_help(void)
+{
+	printf(_(
+"Print the names of the filesystem properties stored in this filesystem.\n"
+"\n"));
+}
+
+static int
+print_fsprop(
+	struct fsprops_handle	*fph,
+	const char		*name,
+	size_t			unused,
+	void			*priv)
+{
+	bool			*print_values = priv;
+	char			valuebuf[ATTR_MAX_VALUELEN];
+	size_t			valuelen = ATTR_MAX_VALUELEN;
+	int			ret;
+
+	if (!(*print_values)) {
+		printf("%s\n", name);
+		return 0;
+	}
+
+	ret = fsprops_get(fph, name, valuebuf, &valuelen);
+	if (ret)
+		return ret;
+
+	printf("%s=%.*s\n", name, (int)valuelen, valuebuf);
+	return 0;
+}
+
+static int
+listfsprops_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsprops_handle	fph = { };
+	bool			print_values = false;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "v")) != EOF) {
+		switch (c) {
+		case 'v':
+			print_values = true;
+			break;
+		default:
+			exitcode = 1;
+			listfsprops_help();
+			return 0;
+		}
+	}
+
+	ret = fsprops_open_handle(&file->xfd, &file->fs_path, &fph);
+	if (ret) {
+		if (errno == ESRMNT)
+			fprintf(stderr,
+ _("%s: Cannot find alleged XFS mount point %s.\n"),
+					file->name, file->fs_path.fs_dir);
+		else
+			perror(file->name);
+		exitcode = 1;
+		return 0;
+	}
+
+	ret = fsprops_walk_names(&fph, print_fsprop, &print_values);
+	if (ret) {
+		perror(file->name);
+		exitcode = 1;
+	}
+
+	fsprops_free_handle(&fph);
+	return 0;
+}
+
+static struct cmdinfo listfsprops_cmd = {
+	.name		= "listfsprops",
+	.cfunc		= listfsprops_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT,
+	.args		= "",
+	.help		= listfsprops_help,
+};
+
+static void
+getfsprops_help(void)
+{
+	printf(_(
+"Print the values of filesystem properties stored in this filesystem.\n"
+"\n"
+"Pass property names as the arguments.\n"
+"\n"));
+}
+
+static int
+getfsprops_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsprops_handle	fph = { };
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			exitcode = 1;
+			getfsprops_help();
+			return 0;
+		}
+	}
+
+	ret = fsprops_open_handle(&file->xfd, &file->fs_path, &fph);
+	if (ret) {
+		if (errno == ESRMNT)
+			fprintf(stderr,
+ _("%s: Cannot find alleged XFS mount point %s.\n"),
+					file->name, file->fs_path.fs_dir);
+		else
+			perror(file->name);
+		exitcode = 1;
+		return 0;
+	}
+
+	for (c = optind; c < argc; c++) {
+		char		valuebuf[ATTR_MAX_VALUELEN];
+		size_t		valuelen = ATTR_MAX_VALUELEN;
+
+		ret = fsprops_get(&fph, argv[c], valuebuf, &valuelen);
+		if (ret) {
+			perror(argv[c]);
+			exitcode = 1;
+			break;
+		}
+
+		printf("%s=%.*s\n", argv[c], (int)valuelen, valuebuf);
+	}
+
+	fsprops_free_handle(&fph);
+	return 0;
+}
+
+static struct cmdinfo getfsprops_cmd = {
+	.name		= "getfsprops",
+	.cfunc		= getfsprops_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT,
+	.args		= "",
+	.help		= getfsprops_help,
+};
+
+static void
+setfsprops_help(void)
+{
+	printf(_(
+"Set values of filesystem properties stored in this filesystem.\n"
+"\n"
+" -f    Do not try to validate property value.\n"
+"\n"
+"Provide name=value tuples as the arguments.\n"
+"\n"));
+}
+
+static int
+setfsprops_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsprops_handle	fph = { };
+	bool			force = false;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "f")) != EOF) {
+		switch (c) {
+		case 'f':
+			force = true;
+			break;
+		default:
+			exitcode = 1;
+			getfsprops_help();
+			return 0;
+		}
+	}
+
+	ret = fsprops_open_handle(&file->xfd, &file->fs_path, &fph);
+	if (ret) {
+		if (errno == ESRMNT)
+			fprintf(stderr,
+ _("%s: Cannot find alleged XFS mount point %s.\n"),
+					file->name, file->fs_path.fs_dir);
+		else
+			perror(file->name);
+		exitcode = 1;
+		return 0;
+	}
+
+	for (c = optind; c < argc; c ++) {
+		char	*equals = strchr(argv[c], '=');
+
+		if (!equals) {
+			fprintf(stderr, _("%s: property value required.\n"),
+					argv[c]);
+			exitcode = 1;
+			break;
+		}
+
+		*equals = 0;
+
+		if (!force && !fsprop_validate(argv[c], equals + 1)) {
+			fprintf(stderr, _("%s: invalid value \"%s\".\n"),
+					argv[c], equals + 1);
+			*equals = '=';
+			exitcode = 1;
+			break;
+		}
+
+		ret = fsprops_set(&fph, argv[c], equals + 1,
+				strlen(equals + 1));
+		if (ret) {
+			perror(argv[c]);
+			*equals = '=';
+			exitcode = 1;
+			break;
+		}
+
+		printf("%s=%s\n", argv[c], equals + 1);
+		*equals = '=';
+	}
+
+	fsprops_free_handle(&fph);
+	return 0;
+}
+
+static struct cmdinfo setfsprops_cmd = {
+	.name		= "setfsprops",
+	.cfunc		= setfsprops_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT,
+	.args		= "",
+	.help		= setfsprops_help,
+};
+
+static void
+removefsprops_help(void)
+{
+	printf(_(
+"Unset a filesystem property.\n"
+"\n"
+"Pass property names as the arguments.\n"
+"\n"));
+}
+
+static int
+removefsprops_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsprops_handle	fph = { };
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			exitcode = 1;
+			getfsprops_help();
+			return 0;
+		}
+	}
+
+	ret = fsprops_open_handle(&file->xfd, &file->fs_path, &fph);
+	if (ret) {
+		if (errno == ESRMNT)
+			fprintf(stderr,
+ _("%s: Cannot find alleged XFS mount point %s.\n"),
+					file->name, file->fs_path.fs_dir);
+		else
+			perror(file->name);
+		exitcode = 1;
+		return 0;
+	}
+
+	for (c = optind; c < argc; c++) {
+		ret = fsprops_remove(&fph, argv[c]);
+		if (ret) {
+			perror(argv[c]);
+			exitcode = 1;
+			break;
+		}
+	}
+
+	fsprops_free_handle(&fph);
+	return 0;
+}
+
+static struct cmdinfo removefsprops_cmd = {
+	.name		= "removefsprops",
+	.cfunc		= removefsprops_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT,
+	.args		= "",
+	.help		= removefsprops_help,
+};
+
+void
+fsprops_init(void)
+{
+	listfsprops_cmd.oneline = _("list file system properties");
+	getfsprops_cmd.oneline = _("print file system properties");
+	setfsprops_cmd.oneline = _("set file system properties");
+	removefsprops_cmd.oneline = _("unset file system properties");
+
+	add_command(&listfsprops_cmd);
+	add_command(&getfsprops_cmd);
+	add_command(&setfsprops_cmd);
+	add_command(&removefsprops_cmd);
+}
diff --git a/spaceman/space.h b/spaceman/space.h
index 28fa35a30479..c4beb5f489ff 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -36,5 +36,6 @@ extern void	freesp_init(void);
 #endif
 extern void	info_init(void);
 extern void	health_init(void);
+void		fsprops_init(void);
 
 #endif /* XFS_SPACEMAN_SPACE_H_ */

