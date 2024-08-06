Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88728DD1;
	Tue,  6 Aug 2024 18:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968391; cv=none; b=EdiuhSYCOo5UCXtw8ChI20IspgDnBcIgo5DWbJHdnHUBnWIqWSvIa0B2LuMKcHeRWQvmUOMD7TntobKwJ106oKN5JQZ4OCifTVkndtxCfsXuEctVOUR93zwz2j6uGFOYOFfSUL3uCKOyYjPRYAuNGx+sID34Pgn4DwQy9CDIXeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968391; c=relaxed/simple;
	bh=S39ucGh+UzX0G9XVmmKU9OvKj98sTAn/2xzgMyVBL5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBmDDuvhmBowq9Gp6oxFUwv3sYnJdO3rsYBfsEl6sBf3aYQWfp4JG/q22D3u7LAwzXfv5J08sYEJGLQX0dMU/LOq5jCSd9Q5Hn9cEJalI+G295pDyBmKJDinlrenQf8q1sJaQ9lpSsoazc3FwUDRJzWHda89Xr0SXJZ130IL+jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5+GYG7C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5+GYG7C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CFAC32786;
	Tue,  6 Aug 2024 18:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968391;
	bh=S39ucGh+UzX0G9XVmmKU9OvKj98sTAn/2xzgMyVBL5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L5+GYG7Cyh4cgioFIDvxBeY/+yAqV+K19sToO3sCrZzegQkAOKOesMb60WPfDNuVu
	 GYUh8NquWrh3I74wp9cU75Tuq8nAEAHPpB5w/0GHHzMHRRa5wtWrhpRDYiK/cHe+Yi
	 /RbEKX2FbKak6u25a/ejI/Lw/bUkvG2Djhcmu0kLjRoOmy4LmdVHkKt9uyB1xvBZ00
	 u4KinAjnynssTHH89bR9T3Hj9TKtZOsZyMu7pDC8MtiFF7P81o0EWDpwMv/7imv6tY
	 VsWB1f5zxqt7z8eOli2QZxw8fA0yDQlDK5zVI/RspkEL17TvyceTRKzk3ovyTLemJd
	 b9T4exWlikXlA==
Date: Tue, 06 Aug 2024 11:19:50 -0700
Subject: [PATCH 2/7] xfs_io: edit filesystem properties
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, hch@lst.de, dchinner@redhat.com,
 fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172296825218.3193059.5122114124530927395.stgit@frogsfrogsfrogs>
In-Reply-To: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs>
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

Add some new subcommands to xfs_io so that users can administer
filesystem properties.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>Acked-by: Dave Chinner <dchinner@redhat.com>
---
 io/Makefile       |    1 
 io/fsproperties.c |  365 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    1 
 io/io.h           |    1 
 man/man8/xfs_io.8 |   16 ++
 5 files changed, 383 insertions(+), 1 deletion(-)
 create mode 100644 io/fsproperties.c


diff --git a/io/Makefile b/io/Makefile
index 3192b813c..0bdd05b57 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -20,6 +20,7 @@ CFILES = \
 	fiemap.c \
 	file.c \
 	freeze.c \
+	fsproperties.c \
 	fsuuid.c \
 	fsync.c \
 	getrusage.c \
diff --git a/io/fsproperties.c b/io/fsproperties.c
new file mode 100644
index 000000000..79837132e
--- /dev/null
+++ b/io/fsproperties.c
@@ -0,0 +1,365 @@
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
+#include "io.h"
+#include "libfrog/fsprops.h"
+#include "libfrog/fsproperties.h"
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
+fileio_to_fsprops_handle(
+	struct fileio		*file,
+	struct fsprops_handle	*fph)
+{
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct fs_path		*fs;
+	void			*hanp = NULL;
+	size_t			hlen;
+	int			ret;
+
+	/*
+	 * Look up the mount point info for the open file, which confirms that
+	 * we were passed a mount point.
+	 */
+	fs = fs_table_lookup(file->name, FS_MOUNT_POINT);
+	if (!fs) {
+		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
+				file->name);
+		goto bad;
+	}
+
+	/*
+	 * Register the mountpoint in the fsfd cache so we can use handle
+	 * functions later.
+	 */
+	ret = path_to_fshandle(fs->fs_dir, &hanp, &hlen);
+	if (ret) {
+		perror(fs->fs_dir);
+		goto bad;
+	}
+
+	ret = -xfd_prepare_geometry(&xfd);
+	if (ret) {
+		perror(file->name);
+		goto free_handle;
+	}
+
+	ret = fsprops_open_handle(&xfd, &file->fs_path, fph);
+	if (ret) {
+		if (errno == ESRMNT)
+			fprintf(stderr, _("%s: Not a XFS mount point.\n"),
+					file->name);
+		else
+			perror(file->name);
+		goto free_handle;
+	}
+
+	free_handle(hanp, hlen);
+	return 0;
+free_handle:
+	free_handle(hanp, hlen);
+bad:
+	exitcode = 1;
+	return 1;
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
+	char			valuebuf[FSPROP_MAX_VALUELEN];
+	size_t			valuelen = FSPROP_MAX_VALUELEN;
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
+	ret = fileio_to_fsprops_handle(file, &fph);
+	if (ret)
+		return 1;
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
+	.flags		= CMD_NOMAP_OK,
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
+	ret = fileio_to_fsprops_handle(file, &fph);
+	if (ret)
+		return ret;
+
+	for (c = optind; c < argc; c++) {
+		char		valuebuf[FSPROP_MAX_VALUELEN];
+		size_t		valuelen = FSPROP_MAX_VALUELEN;
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
+	.flags		= CMD_NOMAP_OK,
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
+	ret = fileio_to_fsprops_handle(file, &fph);
+	if (ret)
+		return ret;
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
+	.flags		= CMD_NOMAP_OK,
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
+	ret = fileio_to_fsprops_handle(file, &fph);
+	if (ret)
+		return ret;
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
+	.flags		= CMD_NOMAP_OK,
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
diff --git a/io/init.c b/io/init.c
index 37e0f093c..5727f7351 100644
--- a/io/init.c
+++ b/io/init.c
@@ -89,6 +89,7 @@ init_commands(void)
 	utimes_init();
 	crc32cselftest_init();
 	exchangerange_init();
+	fsprops_init();
 }
 
 /*
diff --git a/io/io.h b/io/io.h
index fdb715ff0..8c5e59100 100644
--- a/io/io.h
+++ b/io/io.h
@@ -150,3 +150,4 @@ extern void		repair_init(void);
 extern void		crc32cselftest_init(void);
 extern void		bulkstat_init(void);
 void			exchangerange_init(void);
+void			fsprops_init(void);
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 657bdaec4..303c64478 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1578,7 +1578,21 @@ Print the sysfs or debugfs path for the mounted filesystem.
 The
 .B -d
 option selects debugfs instead of sysfs.
-
+.TP
+.BI "getfsprops " name " [ " names "... ]"
+Retrieve the values of the given filesystem properties.
+.TP
+.BI "listfsprops [ " \-v " ]"
+List all filesystem properties that have been stored in the filesystem.
+If the
+.B \-v
+flag is specified, prints the values of the properties.
+.TP
+.BI "setfsprops " name = value " [ " name = value "... ]"
+Set the given filesystem properties to the specified values.
+.TP
+.BI "removefsprops " name " [ " names "... ]"
+Remove the given filesystem properties.
 
 .SH OTHER COMMANDS
 .TP

