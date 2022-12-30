Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9511AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiLaCPy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:15:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiLaCPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:15:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6E02DD5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ED1C5CE1A8E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31325C433D2;
        Sat, 31 Dec 2022 02:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452947;
        bh=AJZ0gNZo4OV20TBRkD8feBasdr/4SPHr8JbaDdPH7rs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kdqNjGHX57o1lmiPRc+RpvI2/g7u+flkwW8VKSc3V2LBCcRlMqN2aCfG+0PcL/wpx
         FfK4ZnE1ETuR7t6WW64eZpELDg9yENyKJtUhAk67xF/g1kGbdC3PUziuk1wYeOrHPi
         kT9f2ZiK9mCI6OvKdVFLj8/hqkyBBMT28xiQDsxALLd7ksuZSojwnLIU3gc9Ettg6W
         x2UIpdGQF/fQSJwOIjrO7dlrjzIxFHLkk1nMtJiqO3kTUNfX6hYZ9Sf1g085QpkpJ8
         fgUR6XZNMlKtwcGInX5jw35LFR+E3XOkkuIvWhE6bKe0lLynduc/nY1SlBFoIvxN+W
         /hX+TqDPm1WYA==
Subject: [PATCH 23/46] xfs_db: support metadata directories in the path
 command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:22 -0800
Message-ID: <167243876237.725900.11095686664824379022.stgit@magnolia>
In-Reply-To: <167243875924.725900.7061782826830118387.stgit@magnolia>
References: <167243875924.725900.7061782826830118387.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the path command to traverse the metadata directory tree by
passing a '\' as the first letter in the path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c        |   43 +++++++++++++++++++++++++++++++++++++------
 man/man8/xfs_db.8 |   11 +++++++++--
 2 files changed, 46 insertions(+), 8 deletions(-)


diff --git a/db/namei.c b/db/namei.c
index dc3cbbeda38..a3d917db5c6 100644
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
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 43c7db5e225..a7e42e1a333 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -835,7 +835,7 @@ This makes it easier to find discrepancies in the reservation calculations
 between xfsprogs and the kernel, which will help when diagnosing minimum
 log size calculation errors.
 .TP
-.BI "ls [\-i] [" paths "]..."
+.BI "ls [\-im] [" paths "]..."
 List the contents of a directory.
 If a path resolves to a directory, the directory will be listed.
 If no paths are supplied and the IO cursor points at a directory inode,
@@ -849,6 +849,9 @@ directory cookie, inode number, file type, hash, name length, name.
 Resolve each of the given paths to an inode number and print that number.
 If no paths are given and the IO cursor points to an inode, print the inode
 number.
+.TP
+.B \-m
+Absolute paths should be walked from the root of the metadata directory tree.
 .RE
 .TP
 .BI "metadump [\-egow] " filename
@@ -876,9 +879,13 @@ See the
 .B print
 command.
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

