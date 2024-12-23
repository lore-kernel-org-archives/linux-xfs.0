Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B31D1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990578; cv=none; b=imTtlmJRZjGrxArOF72DNL2n+AfaPUMt5MuBpDnqnse9Mgr1gqqBc1zrVyd/PIlrB4XSKbm12nEIjRULqvvxMC0hXDSm6P7IZLF9+WAahsfS2YYhAr/EN50OsezHH/e0HJEYoIc75AzbwR78VwIEY94cXBiZoHe9CsQNKEDb1Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990578; c=relaxed/simple;
	bh=2/LpO6eeGlLSzIXJagOneP9csxmrYp+BLRLF/BCLbu8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gMNT6VK4u9ii5YlUYwzkBzEEiavxdm1tRrYMVOSmoYGp3XaiM+NiDlazaW4fCQ3vsIbqsuUWmab9g2Vkrf/vHyumvwndH8EhVySH7Mf5tN9i1Fkdnvv0NlFPltGl1sjIRYpOp7D6PGW+kcdLADGdf4J/aPTvmaopqhazVrNgtnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIcjmuHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIcjmuHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002CEC4CED3;
	Mon, 23 Dec 2024 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990578;
	bh=2/LpO6eeGlLSzIXJagOneP9csxmrYp+BLRLF/BCLbu8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QIcjmuHBmDlnXaAQ2ORghF3uetENH7DUHF3k3tA2YH2ZssPx+5JfydiDLnVvn8l09
	 w/YK9ONsEFKFneN2C0wZvb34jTW6vmLydFmKDTy0kDKrliFyhGc4nxWkd7L+Dri6hu
	 oxsMxTMYOmi2XaD/aXRIhTP7EtfV/4+mmcr1grFYCDKkTtQxjPRdKymI2uJ/EGXEnI
	 w83WghjxdnZkJpH8ehfPkreBa9aYIuGiqjy7Ns6xdLW1G9Mid03KIS7bPaPVUJGm+6
	 nmHyV8VSqVcRjjvTRh2/STYB+qW5HZaAqi6WayxDWWhb79wmyBk2kprv+IOjPRp2QF
	 wfYUEoRKzNQ4Q==
Date: Mon, 23 Dec 2024 13:49:37 -0800
Subject: [PATCH 12/41] xfs_db: support metadata directories in the path
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941152.2294268.1905536511412544802.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 998553684586c7..066f124458b286 100644
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

