Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541B84A21
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302457; cv=none; b=Yu94FCBJX/rWFNTJ/PLH7ybgwFpNWm71e/ySatxrWYlrAr8lG/hMjXbztSFy1uEXCfeYG3AXnm0/Fl8DXP42Xn6rPkUGKYMJqx8+w3zqG8K3p90m4nYARl/jlQ69u1CKxazxWGy1Ddp14khceyHEqz9OJt+gbUohvhdyJFhz3fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302457; c=relaxed/simple;
	bh=H2zbS9qvYvD73n6+ZxrZR3UrbuumPahES/uGH5Gi7b4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XpBSM5PoDQGp+s/FHkQ2Axw0ed8l8sDeeVX92LZfH8rmQtqujfhJ1giTVC6rZ17FRzeKYzyIgglwe9KIN5YfnbevAFI29090i1fJ1aFoMk/Nrw0gAImwWfyf74zN2n6xCuk1Gsb6vvcAlkIgf/WPrvFwYo1KyDxZu8YAy4KgzgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmKd+dpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmKd+dpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC05C32786;
	Tue, 30 Jul 2024 01:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302456;
	bh=H2zbS9qvYvD73n6+ZxrZR3UrbuumPahES/uGH5Gi7b4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LmKd+dpEtT7nWPOvfa0GIHUTH7Dbh1AVn3s7ikCbPm/hx7yrOd1ysyRxuYSRoO6m4
	 e8YFvFnKC4RWmyrB0TNZF4n+NYYQsdOF8c8cA4/MOszQMoPZHXVYHgM7GzOU1ZD704
	 JazunKDsUKzfkTFR+ACT2Z9OfAD+ZSJ9e3wAqsOfqDGA9aZq1deA/d7dC3hgrf1Vbk
	 Eh7MuztN4i+FKdGhrd1iY+i6v7twfznGjfp9WT1gUKmY4BCmkapQ5eQ79KqjpQCL8h
	 yXbFgMB9/b5SwrLKiELxGjmCAhaR5U8bA54B7+JdWYtVFpe31OaDfglNKU36GO9RyZ
	 hgN+Xfr+OO5BA==
Date: Mon, 29 Jul 2024 18:20:56 -0700
Subject: [PATCH 08/24] xfs_io: Add i, n and f flags to parent command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, allison.henderson@oracle.com
Message-ID: <172229850627.1350924.1094314963378093233.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
References: <172229850491.1350924.499207407445096350.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 io/parent.c       |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |   13 ++++++++++-
 2 files changed, 70 insertions(+), 4 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 927d05d70..8db93d987 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -17,6 +17,9 @@ static char *mntpt;
 
 struct pptr_args {
 	char		*pathbuf;
+	char		*filter_name;
+	uint64_t	filter_ino;
+	bool		shortformat;
 };
 
 static int
@@ -25,12 +28,27 @@ pptr_print(
 	void			*arg)
 {
 	const struct xfs_fid	*fid = &rec->p_handle.ha_fid;
+	struct pptr_args	*args = arg;
 
 	if (rec->p_flags & PARENTREC_FILE_IS_ROOT) {
 		printf(_("Root directory.\n"));
 		return 0;
 	}
 
+	if (args->filter_ino && fid->fid_ino != args->filter_ino)
+		return 0;
+	if (args->filter_name && strcmp(args->filter_name, rec->p_name))
+		return 0;
+
+	if (args->shortformat) {
+		printf("%llu:%u:%zu:%s\n",
+				(unsigned long long)fid->fid_ino,
+				(unsigned int)fid->fid_gen,
+				strlen(rec->p_name),
+				rec->p_name);
+		return 0;
+	}
+
 	printf(_("p_ino     = %llu\n"), (unsigned long long)fid->fid_ino);
 	printf(_("p_gen     = %u\n"), (unsigned int)fid->fid_gen);
 	printf(_("p_namelen = %zu\n"), strlen(rec->p_name));
@@ -39,6 +57,21 @@ pptr_print(
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
 paths_print(
 	const char		*mntpt,
@@ -51,6 +84,12 @@ paths_print(
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
@@ -103,7 +142,7 @@ parent_f(
 	}
 	mntpt = fs->fs_dir;
 
-	while ((c = getopt(argc, argv, "b:pz")) != EOF) {
+	while ((c = getopt(argc, argv, "b:i:n:psz")) != EOF) {
 		switch (c) {
 		case 'b':
 			errno = 0;
@@ -114,9 +153,24 @@ parent_f(
 				return 1;
 			}
 			break;
+		case 'i':
+			args.filter_ino = strtoull(optarg, &p, 0);
+			if (*p != '\0' || args.filter_ino == 0) {
+				fprintf(stderr, _("Bad inode number '%s'.\n"),
+						optarg);
+				exitcode = 1;
+				return 1;
+			}
+			break;
+		case 'n':
+			args.filter_name = optarg;
+			break;
 		case 'p':
 			listpath_flag = 1;
 			break;
+		case 's':
+			args.shortformat = true;
+			break;
 		case 'z':
 			single_path = true;
 			break;
@@ -203,7 +257,10 @@ printf(_(
 " list the current file's parents and their filenames\n"
 "\n"
 " -b -- use this many bytes to hold parent pointer records\n"
+" -i -- Only show parent pointer records containing the given inode\n"
+" -n -- Only show parent pointer records containing the given filename\n"
 " -p -- list the current file's paths up to the root\n"
+" -s -- Print records in short format: ino/gen/namelen/filename\n"
 " -z -- print only the first path from the root\n"
 "\n"
 "If ino and gen are supplied, use them instead.\n"
@@ -217,7 +274,7 @@ parent_init(void)
 	parent_cmd.cfunc = parent_f;
 	parent_cmd.argmin = 0;
 	parent_cmd.argmax = -1;
-	parent_cmd.args = _("[-pz] [-b bufsize] [ino gen]");
+	parent_cmd.args = _("[-psz] [-b bufsize] [-i ino] [-n name] [ino gen]");
 	parent_cmd.flags = CMD_NOMAP_OK;
 	parent_cmd.oneline = _("print parent inodes");
 	parent_cmd.help = parent_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index b9d544770..02036e3d0 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1004,7 +1004,7 @@ and
 options behave as described above, in
 .B chproj.
 .TP
-.BR parent " [ " \-pz " ] [ " \-b " bufsize ] [" " ino gen " "]"
+.BR parent " [ " \-fpz " ] [ " \-b " bufsize ] [ " \-i " ino ] [ " \-n " name ] [" " ino gen " "]"
 By default this command prints out the parent inode numbers,
 inode generation numbers and basenames of all the hardlinks which
 point to the inode of the current file.
@@ -1023,11 +1023,20 @@ the open file.
 .TP 0.4i
 .B \-b
 Use a buffer of this size to receive parent pointer records from the kernel.
-.TP
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
 .TP
+.B \-s
+Print records in short format: ino/gen/namelen/name
+.TP
 .B \-z
 Print only the first path from the root.
 .RE

