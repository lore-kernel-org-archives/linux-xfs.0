Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BA12C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234575AbjEZC0f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjEZC0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:26:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E67B2
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3A7B64C4C
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6E0C433D2;
        Fri, 26 May 2023 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067992;
        bh=B3egwM7GlJVDCiUAozeNem6XHbsksUwzx0LIvWM/7v0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QQfUKHToGC5ukYLAa1ph5P4I9ryGC3Klz0WKrtTt5iVC10I/MYBHY8IhsEAYj9ENv
         CeQWpqvrDs2j5/fvvtrgZA/zaesG3uVEonL7+yLKckL+J+r8Sd40qDBhE/0xh8/p2V
         Y8P8BPFebtNCJ0QE3713fox8SMC7/qHavGZLE7s9DmDQCCc+YPhyROB0K87yYeV0XG
         FTvDt6eZ493ydVEt05n/6Wn1a18AYq/n7QyXve/YQmX8xpvOsbmvrF9N9fmfja1WDd
         jTq3p/wx+VefVcOxnCZEvzpkHaSG3ZAaBBWcqp7QKyQNK67wDb+htR5rnK+TZsgH44
         /yAT9RqofRMIg==
Date:   Thu, 25 May 2023 19:26:31 -0700
Subject: [PATCH 18/30] xfs_io: Add i, n and f flags to parent command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078132.3749421.10237359376930581514.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds the flags i, n, and f to the parent command. These flags add
filtering options that are used by the new parent pointer tests in xfstests, and
help to improve the test run time.  The flags are:

-i: Only show parent pointer records containing the given inode
-n: Only show parent pointer records containing the given filename
-f: Print records in short format: ino/gen/namelen/name

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: adapt to new getparents ioctl]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c       |   89 +++++++++++++++++++++++++++++++++++++++++++++++------
 man/man8/xfs_io.8 |   11 ++++++-
 2 files changed, 89 insertions(+), 11 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 65fd892bffc..6bb7571e1bd 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -15,11 +15,18 @@
 static cmdinfo_t parent_cmd;
 static char *mntpt;
 
+struct pptr_args {
+	uint64_t	filter_ino;
+	char		*filter_name;
+	bool		shortformat;
+};
+
 static int
 pptr_print(
 	const struct parent_rec	*rec,
 	void			*arg)
 {
+	struct pptr_args	*args = arg;
 	const char		*name = (char *)rec->p_name;
 	unsigned int		namelen;
 
@@ -28,7 +35,22 @@ pptr_print(
 		return 0;
 	}
 
+	if (args->filter_ino && rec->p_ino != args->filter_ino)
+		return 0;
+	if (args->filter_name && strcmp(args->filter_name, name))
+		return 0;
+
 	namelen = strlen(name);
+
+	if (args->shortformat) {
+		printf("%llu/%u/%u/%s\n",
+				(unsigned long long)rec->p_ino,
+				(unsigned int)rec->p_gen,
+				namelen,
+				rec->p_name);
+		return 0;
+	}
+
 	printf(_("p_ino     = %llu\n"), (unsigned long long)rec->p_ino);
 	printf(_("p_gen     = %u\n"), (unsigned int)rec->p_gen);
 	printf(_("p_namelen = %u\n"), namelen);
@@ -39,32 +61,55 @@ pptr_print(
 
 static int
 print_parents(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	struct pptr_args	*args)
 {
 	int			ret;
 
 	if (handle)
 		ret = handle_walk_parents(handle, sizeof(*handle), pptr_print,
-				NULL);
+				args);
 	else
-		ret = fd_walk_parents(file->fd, pptr_print, NULL);
+		ret = fd_walk_parents(file->fd, pptr_print, args);
 	if (ret)
 		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
 
 	return 0;
 }
 
+static int
+filter_path_components(
+	const char		*name,
+	uint64_t		ino,
+	void			*arg)
+{
+	struct pptr_args	*args = arg;
+
+	if (args->filter_ino && ino == args->filter_ino)
+		return ECANCELED;
+	if (args->filter_name && !strcmp(args->filter_name, name))
+		return ECANCELED;
+	return 0;
+}
+
 static int
 path_print(
 	const char		*mntpt,
 	const struct path_list	*path,
 	void			*arg)
 {
+	struct pptr_args	*args = arg;
 	char			buf[PATH_MAX];
 	size_t			len = PATH_MAX;
 	int			mntpt_len = strlen(mntpt);
 	int			ret;
 
+	if (args->filter_ino || args->filter_name) {
+		ret = path_walk_components(path, filter_path_components, args);
+		if (ret != ECANCELED)
+			return 0;
+	}
+
 	/* Trim trailing slashes from the mountpoint */
 	while (mntpt_len > 0 && mntpt[mntpt_len - 1] == '/')
 		mntpt_len--;
@@ -83,15 +128,16 @@ path_print(
 
 static int
 print_paths(
-	struct xfs_handle	*handle)
+	struct xfs_handle	*handle,
+	struct pptr_args	*args)
 {
 	int			ret;
 
 	if (handle)
 		ret = handle_walk_parent_paths(handle, sizeof(*handle),
-				path_print, NULL);
+				path_print, args);
 	else
-		ret = fd_walk_parent_paths(file->fd, path_print, NULL);
+		ret = fd_walk_parent_paths(file->fd, path_print, args);
 	if (ret)
 		fprintf(stderr, "%s: %s\n", file->name, strerror(ret));
 	return 0;
@@ -103,6 +149,7 @@ parent_f(
 	char			**argv)
 {
 	struct xfs_handle	handle;
+	struct pptr_args	args = { 0 };
 	void			*hanp = NULL;
 	size_t			hlen;
 	struct fs_path		*fs;
@@ -127,11 +174,27 @@ parent_f(
 	}
 	mntpt = fs->fs_dir;
 
-	while ((c = getopt(argc, argv, "p")) != EOF) {
+	while ((c = getopt(argc, argv, "pfi:n:")) != EOF) {
 		switch (c) {
 		case 'p':
 			listpath_flag = 1;
 			break;
+		case 'i':
+	                args.filter_ino = strtoull(optarg, &p, 0);
+	                if (*p != '\0' || args.filter_ino == 0) {
+	                        fprintf(stderr,
+	                                _("Bad inode number '%s'.\n"),
+	                                optarg);
+	                        return 0;
+			}
+
+			break;
+		case 'n':
+			args.filter_name = optarg;
+			break;
+		case 'f':
+			args.shortformat = true;
+			break;
 		default:
 			return command_usage(&parent_cmd);
 		}
@@ -175,9 +238,9 @@ parent_f(
 	}
 
 	if (listpath_flag)
-		exitcode = print_paths(ino ? &handle : NULL);
+		exitcode = print_paths(ino ? &handle : NULL, &args);
 	else
-		exitcode = print_parents(ino ? &handle : NULL);
+		exitcode = print_parents(ino ? &handle : NULL, &args);
 
 	if (hanp)
 		free_handle(hanp, hlen);
@@ -195,6 +258,12 @@ printf(_(
 " -p -- list the current file's paths up to the root\n"
 "\n"
 "If ino and gen are supplied, use them instead.\n"
+"\n"
+" -i -- Only show parent pointer records containing the given inode\n"
+"\n"
+" -n -- Only show parent pointer records containing the given filename\n"
+"\n"
+" -f -- Print records in short format: ino/gen/namelen/filename\n"
 "\n"));
 }
 
@@ -205,7 +274,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-p] [ino gen]");
+	parent_cmd.args = _("[-p] [ino gen] [-i ino] [-n name] [-f]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 8b2ad588ebc..c8ccf6ddce4 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1013,7 +1013,7 @@ and
 options behave as described above, in
 .B chproj.
 .TP
-.BR parent " [ " \-p " ] [" " ino gen " "]"
+.BR parent " [ " \-fp " ] [-i " ino "] [-n " name "] [" " ino gen " "]"
 By default this command prints out the parent inode numbers,
 inode generation numbers and basenames of all the hardlinks which
 point to the inode of the current file.
@@ -1030,6 +1030,15 @@ the open file.
 .RS 1.0i
 .PD 0
 .TP 0.4i
+.B \-f
+Print records in short format: ino/gen/namelen/name
+.TP 0.4i
+.B \-i
+Only show parent pointer records containing this inode number.
+.TP 0.4i
+.B \-n
+Only show parent pointer records containing this directory entry name.
+.TP 0.4i
 .B \-p
 the output is similar to the default output except pathnames up to
 the mount-point are printed out instead of the component name.

