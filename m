Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA5C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pk7dxP25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA73C433C7;
	Sun, 31 Dec 2023 23:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065829;
	bh=w+qr40siuZmQsqNI3VFds+3NnrnU9eNEBafYLxQTANc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Pk7dxP25YDSyKyu5MrRJaFeYHfeVuiYVyhzen+atCIKwp6ooIt7ZjCeZ8Xyb5UIjM
	 MvlIOWsrUIBIn9a/yPfEdUFMCUpqe7Sp/mN46c6QTHPgCRxJO3wQf+k5RJb/DPfKUC
	 FHN5s2J/Mt+LGkPaeCNO8Sn0zCeIPQ81tLv5GPak5u18EwHNSLOuCCSKyCeeHGw6tA
	 9jjmYhwg+ATh/DZpMmmcUHpd/r6nji3y8FCq1W3cTMAMY2YtgFJ0U3k1X9sGZ2t61A
	 lpM7OHWmXQYU3QF6UFN9vYLiVpJ482p63AWd+acLx3AB7qNLZYhr+Yye63mV8pAyWm
	 746VGbuTxOaFQ==
Date: Sun, 31 Dec 2023 15:37:08 -0800
Subject: [PATCH 29/58] xfs_db: support metadata directories in the path
 command
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010334.1809361.8685129977917604647.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Teach the path command to traverse the metadata directory tree by
passing a '\' as the first letter in the path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++---------
 man/man8/xfs_db.8 |   23 ++++++++++++++---
 2 files changed, 78 insertions(+), 16 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index e75179b2c67..db467141f13 100644
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
@@ -521,6 +540,7 @@ ls_help(void)
 " Options:\n"
 "   -i -- Resolve the given paths to their corresponding inode numbers.\n"
 "         If no paths are given, display the current inode number.\n"
+"   -m -- Walk an absolute path down the metadata directory tree.\n"
 "\n"
 " Directory contents will be listed in the format:\n"
 " dir_cookie	inode_number	type	hash	name_length	name\n"
@@ -532,15 +552,26 @@ ls_f(
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
@@ -563,7 +594,7 @@ ls_f(
 	for (c = optind; c < argc; c++) {
 		push_cur();
 
-		error = path_walk(argv[c]);
+		error = path_walk(rootino, argv[c]);
 		if (error)
 			goto err_cur;
 
@@ -874,11 +905,22 @@ parent_f(
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
@@ -898,7 +940,7 @@ parent_f(
 	for (c = optind; c < argc; c++) {
 		push_cur();
 
-		error = path_walk(argv[c]);
+		error = path_walk(rootino, argv[c]);
 		if (error)
 			goto err_cur;
 
@@ -926,7 +968,7 @@ static struct cmdinfo parent_cmd = {
 	.argmin		= 0,
 	.argmax		= -1,
 	.canpush	= 0,
-	.args		= "[paths...]",
+	.args		= "[-m] [paths...]",
 	.help		= parent_help,
 };
 
@@ -940,6 +982,7 @@ link_help(void)
 "\n"
 " Options:\n"
 "   -i   -- Point to this specific inode number.\n"
+"   -m   -- Select the metadata directory tree.\n"
 "   -p   -- Point to the inode given by this path.\n"
 "   -t   -- Set the file type to this value.\n"
 "   name -- Create this directory entry with this name.\n"
@@ -1051,11 +1094,12 @@ link_f(
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
@@ -1066,9 +1110,12 @@ link_f(
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
@@ -1138,7 +1185,7 @@ static struct cmdinfo link_cmd = {
 	.argmin		= 0,
 	.argmax		= -1,
 	.canpush	= 0,
-	.args		= "[-i ino] [-p path] [-t ftype] name",
+	.args		= "[-i ino] [-m] [-p path] [-t ftype] name",
 	.help		= link_help,
 };
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 638a8dc9352..b1712a92f76 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -884,7 +884,7 @@ will result in truncation and a warning will be issued. If no
 .I label
 is given, the current filesystem label is printed.
 .TP
-.BI "link [-i " ino "] [-p " path "] [-t " ftype "] name"
+.BI "link [-i " ino "] [-m] [-p " path "] [-t " ftype "] name"
 In the current directory, create a directory entry with the given
 .I name
 pointing to a file.
@@ -897,6 +897,10 @@ The file type in the directory entry will be determined from the mode of the
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
@@ -917,7 +921,7 @@ This makes it easier to find discrepancies in the reservation calculations
 between xfsprogs and the kernel, which will help when diagnosing minimum
 log size calculation errors.
 .TP
-.BI "ls [\-i] [" paths "]..."
+.BI "ls [\-im] [" paths "]..."
 List the contents of a directory.
 If a path resolves to a directory, the directory will be listed.
 If no paths are supplied and the IO cursor points at a directory inode,
@@ -931,6 +935,9 @@ directory cookie, inode number, file type, hash, name length, name.
 Resolve each of the given paths to an inode number and print that number.
 If no paths are given and the IO cursor points to an inode, print the inode
 number.
+.TP
+.B \-m
+Absolute paths should be walked from the root of the metadata directory tree.
 .RE
 .TP
 .BI "metadump [\-egow] " filename
@@ -958,18 +965,26 @@ See the
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

