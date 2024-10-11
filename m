Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C922114
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609360; cv=none; b=ZdLfxWL8lSVQZO523y/YD/LQzCe2y+i4KPDLKtGiqQiLXNn4GviV2c4SQ5CzR46ElXDvdGHZVoDIXB9+XLUEoqNWrYKWufrjjBOmU0xoC4W8gksgRtArWl7v3KDZYk+LB7tPh9AlBDIBbo4cby/XKQgrhhCn70sU8uUA38OGHb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609360; c=relaxed/simple;
	bh=dfVGQx5dvAxQTa/FaYnO5DyYE6s9giqguqR+DVdZBt0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mnEoOp4Be41SMlMHZvW58yZmwg47angE6pp8ZPAVLr89D83Li+D442BNs3FiGYgml4TCWF5Uy2OdDvTqyLDazj0JPOoIHuLMLW6a2LZJKyRXNlKe8ucQ2QL0B40WpjChoIyH2w6ztaiG0RqmIxwIUwX3ZEm/XFxDmyJDiva8Vxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BG7AUsWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BG7AUsWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F9C4CEC5;
	Fri, 11 Oct 2024 01:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609360;
	bh=dfVGQx5dvAxQTa/FaYnO5DyYE6s9giqguqR+DVdZBt0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BG7AUsWKEV2s9vjQLH/4mhElTI8+hJEhLOsHSfq4TDLOLULBMaR30sq1gF9A9+KyW
	 0Mtx95Y/27+hmfQWsssEt40cZkAR+IAPHNTtYftfNfi0OibzIOTEjKF1+wo1Lx10hH
	 nugrDS/V48gJ+nxug1rwo5oFoLgnCbDlJa8oHQbxuTQKAKI2MbxWbtX2d/vlZu6y4K
	 h3yYHf32vEeIVqt20gN5mFkEQZMhC3WM7g+SLF2mVx0xn+AIK7Md8RRuBM76Ma+AB8
	 JZgDpL5Bd5zpOZk7WqvgpQdZqKQgt49wJE04ByDYlHn6KONvyrAUuioZtL1qranTIG
	 wn8X5h073T8nA==
Date: Thu, 10 Oct 2024 18:15:59 -0700
Subject: [PATCH 07/38] xfs_db: support metadata directories in the path
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654085.4183231.11611400721232549629.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Teach various directory tree debugger commands to traverse the metadata
directory tree by adding a -m switch to select that tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++---------
 man/man8/xfs_db.8 |   23 ++++++++++++++---
 2 files changed, 78 insertions(+), 16 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index 8c7f4932fce4a3..4eae4e8fd3232c 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -139,11 +139,11 @@ path_navigate(
 /* Walk a directory path to an inode and set the io cursor to that inode. */
 static int
 path_walk(
+	xfs_ino_t	rootino,
 	char		*path)
 {
 	struct dirpath	*dirpath;
 	char		*p = path;
-	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
 	int		error = 0;
 
 	if (*p == '/') {
@@ -173,6 +173,9 @@ path_help(void)
 	dbprintf(_(
 "\n"
 " Navigate to an inode via directory path.\n"
+"\n"
+" Options:\n"
+"   -m -- Walk an absolute path down the metadata directory tree.\n"
 	));
 }
 
@@ -181,18 +184,34 @@ path_f(
 	int		argc,
 	char		**argv)
 {
+	xfs_ino_t	rootino = mp->m_sb.sb_rootino;
 	int		c;
 	int		error;
 
-	while ((c = getopt(argc, argv, "")) != -1) {
+	while ((c = getopt(argc, argv, "m")) != -1) {
 		switch (c) {
+		case 'm':
+			/* Absolute path, start from metadata rootdir. */
+			if (!xfs_has_metadir(mp)) {
+				dbprintf(
+	_("filesystem does not support metadata directories.\n"));
+				exitcode = 1;
+				return 0;
+			}
+			rootino = mp->m_sb.sb_metadirino;
+			break;
 		default:
 			path_help();
 			return 0;
 		}
 	}
 
-	error = path_walk(argv[optind]);
+	if (argc == optind || argc > optind + 1) {
+		dbprintf(_("Only supply one path.\n"));
+		return -1;
+	}
+
+	error = path_walk(rootino, argv[optind]);
 	if (error) {
 		dbprintf("%s: %s\n", argv[optind], strerror(error));
 		exitcode = 1;
@@ -206,7 +225,7 @@ static struct cmdinfo path_cmd = {
 	.altname	= NULL,
 	.cfunc		= path_f,
 	.argmin		= 1,
-	.argmax		= 1,
+	.argmax		= -1,
 	.canpush	= 0,
 	.args		= "",
 	.help		= path_help,
@@ -519,6 +538,7 @@ ls_help(void)
 " Options:\n"
 "   -i -- Resolve the given paths to their corresponding inode numbers.\n"
 "         If no paths are given, display the current inode number.\n"
+"   -m -- Walk an absolute path down the metadata directory tree.\n"
 "\n"
 " Directory contents will be listed in the format:\n"
 " dir_cookie	inode_number	type	hash	name_length	name\n"
@@ -530,15 +550,26 @@ ls_f(
 	int			argc,
 	char			**argv)
 {
+	xfs_ino_t		rootino = mp->m_sb.sb_rootino;
 	bool			inum_only = false;
 	int			c;
 	int			error = 0;
 
-	while ((c = getopt(argc, argv, "i")) != -1) {
+	while ((c = getopt(argc, argv, "im")) != -1) {
 		switch (c) {
 		case 'i':
 			inum_only = true;
 			break;
+		case 'm':
+			/* Absolute path, start from metadata rootdir. */
+			if (!xfs_has_metadir(mp)) {
+				dbprintf(
+	_("filesystem does not support metadata directories.\n"));
+				exitcode = 1;
+				return 0;
+			}
+			rootino = mp->m_sb.sb_metadirino;
+			break;
 		default:
 			ls_help();
 			return 0;
@@ -561,7 +592,7 @@ ls_f(
 	for (c = optind; c < argc; c++) {
 		push_cur();
 
-		error = path_walk(argv[c]);
+		error = path_walk(rootino, argv[c]);
 		if (error)
 			goto err_cur;
 
@@ -860,11 +891,22 @@ parent_f(
 	int			argc,
 	char			**argv)
 {
+	xfs_ino_t		rootino = mp->m_sb.sb_rootino;
 	int			c;
 	int			error = 0;
 
-	while ((c = getopt(argc, argv, "")) != -1) {
+	while ((c = getopt(argc, argv, "m")) != -1) {
 		switch (c) {
+		case 'm':
+			/* Absolute path, start from metadata rootdir. */
+			if (!xfs_has_metadir(mp)) {
+				dbprintf(
+	_("filesystem does not support metadata directories.\n"));
+				exitcode = 1;
+				return 0;
+			}
+			rootino = mp->m_sb.sb_metadirino;
+			break;
 		default:
 			ls_help();
 			return 0;
@@ -884,7 +926,7 @@ parent_f(
 	for (c = optind; c < argc; c++) {
 		push_cur();
 
-		error = path_walk(argv[c]);
+		error = path_walk(rootino, argv[c]);
 		if (error)
 			goto err_cur;
 
@@ -912,7 +954,7 @@ static struct cmdinfo parent_cmd = {
 	.argmin		= 0,
 	.argmax		= -1,
 	.canpush	= 0,
-	.args		= "[paths...]",
+	.args		= "[-m] [paths...]",
 	.help		= parent_help,
 };
 
@@ -926,6 +968,7 @@ link_help(void)
 "\n"
 " Options:\n"
 "   -i   -- Point to this specific inode number.\n"
+"   -m   -- Select the metadata directory tree.\n"
 "   -p   -- Point to the inode given by this path.\n"
 "   -t   -- Set the file type to this value.\n"
 "   name -- Create this directory entry with this name.\n"
@@ -1039,11 +1082,12 @@ link_f(
 {
 	xfs_ino_t		child_ino = NULLFSINO;
 	int			ftype = XFS_DIR3_FT_UNKNOWN;
+	xfs_ino_t		rootino = mp->m_sb.sb_rootino;
 	unsigned int		i;
 	int			c;
 	int			error = 0;
 
-	while ((c = getopt(argc, argv, "i:p:t:")) != -1) {
+	while ((c = getopt(argc, argv, "i:mp:t:")) != -1) {
 		switch (c) {
 		case 'i':
 			errno = 0;
@@ -1054,9 +1098,12 @@ link_f(
 				return 0;
 			}
 			break;
+		case 'm':
+			rootino = mp->m_sb.sb_metadirino;
+			break;
 		case 'p':
 			push_cur();
-			error = path_walk(optarg);
+			error = path_walk(rootino, optarg);
 			if (error) {
 				printf("%s: %s\n", optarg, strerror(error));
 				exitcode = 1;
@@ -1126,7 +1173,7 @@ static struct cmdinfo link_cmd = {
 	.argmin		= 0,
 	.argmax		= -1,
 	.canpush	= 0,
-	.args		= "[-i ino] [-p path] [-t ftype] name",
+	.args		= "[-i ino] [-m] [-p path] [-t ftype] name",
 	.help		= link_help,
 };
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index c2f06191cfd29d..ab58a147fd9e23 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -992,7 +992,7 @@ .SH COMMANDS
 .I label
 is given, the current filesystem label is printed.
 .TP
-.BI "link [-i " ino "] [-p " path "] [-t " ftype "] name"
+.BI "link [-i " ino "] [-m] [-p " path "] [-t " ftype "] name"
 In the current directory, create a directory entry with the given
 .I name
 pointing to a file.
@@ -1005,6 +1005,10 @@ .SH COMMANDS
 child file unless the
 .I ftype
 option is given.
+The
+.B -m
+option specifies that the path lookup should be done in the metadata directory
+tree.
 The file being targetted must not be on the iunlink list.
 .TP
 .BI "log [stop | start " filename ]
@@ -1039,7 +1043,7 @@ .SH COMMANDS
 between xfsprogs and the kernel, which will help when diagnosing minimum
 log size calculation errors.
 .TP
-.BI "ls [\-i] [" paths "]..."
+.BI "ls [\-im] [" paths "]..."
 List the contents of a directory.
 If a path resolves to a directory, the directory will be listed.
 If no paths are supplied and the IO cursor points at a directory inode,
@@ -1053,6 +1057,9 @@ .SH COMMANDS
 Resolve each of the given paths to an inode number and print that number.
 If no paths are given and the IO cursor points to an inode, print the inode
 number.
+.TP
+.B \-m
+Absolute paths should be walked from the root of the metadata directory tree.
 .RE
 .TP
 .BI "metadump [\-egow] " filename
@@ -1080,18 +1087,26 @@ .SH COMMANDS
 .B print
 command.
 .TP
-.BI "parent [" paths "]..."
+.BI "parent [\-m] [" paths "]..."
 List the parents of a file.
 If a path resolves to a file, the parents of that file will be listed.
 If no paths are supplied and the IO cursor points at an inode, the parents of
 that file will be listed.
+The
+.B \-m
+option causes absolute paths to be walked from the root of the metadata
+directory tree.
 
 The output format is:
 inode number, inode generation, ondisk namehash, namehash, name length, name.
 .TP
-.BI "path " dir_path
+.BI "path [\-m] " dir_path
 Walk the directory tree to an inode using the supplied path.
 Absolute and relative paths are supported.
+The
+.B \-m
+option causes absolute paths to be walked from the root of the metadata
+directory tree.
 .TP
 .B pop
 Pop location from the stack.

