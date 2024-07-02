Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825006FCB
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882767; cv=none; b=P8tEcXaEu2tkVwKWwfDnGU1EV7muNuup80QEa7vnyS2Kb3S4iAKr0nLNDpdQ42lh/dPV25tFLL2G4mM0XhV3HYjI/dt7fOSyR74M9/sakiB/HYUF6kTukMt2X2F9Q8LinkhlDC+0G95AxQDTbInGbWCZkO2bRjbmMRzT0YWRPMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882767; c=relaxed/simple;
	bh=LCcWDjxTgvVnIzW8Xj7JafJCfBgAovgIlGnKXCFbF2U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LSA57d365oNiFtIfht+fTqH7zZrwf0duF0PS0HAnAlcBnSxjTy+HInJlS+gH4X3OrwegFflCr+vOYfkwCuI4nMOgM6TRj1GGx3AoMfIbZG3Hbd3WD2tgwupp9/1Rya5d27bzx3YzFlitR2NXomkQ9vUT4S3IuXTXmUF2ucQ70o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jeoltbar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jeoltbar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227C3C116B1;
	Tue,  2 Jul 2024 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882767;
	bh=LCcWDjxTgvVnIzW8Xj7JafJCfBgAovgIlGnKXCFbF2U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jeoltbarkhR3gsyBnn2xm6bHdMMJMDi343RwtUNDJUXfbnhuJxzPEmx9LbpZ8g1fq
	 VhvYtdWuNl3Q4/3lYqTWOj+IIQm02UULhsZvwMLYSUc23GjrV0E1BolzBK1cJNhazv
	 JkAPUVr2Rwpg8mYIhaUljphmFVxwXKHEl4Tm4q+drbHRPXhcAO7BUHZdCyyRir/cqn
	 CQLZU3EQDp9UvO5fFRWMu8kCBHIvtV5g8BCO9qjGS+S4q7IlojIrzg6s2yjiiLAW/V
	 s/XCxwNMFCSWiY5VStRXgHvCX01P3IMSMmvyXaDIgto6FLn0/MUsa65Hxf7OcFf0PB
	 A/IBZP0Nsi0Gw==
Date: Mon, 01 Jul 2024 18:12:46 -0700
Subject: [PATCH 08/24] xfs_io: Add i, n and f flags to parent command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121186.2009260.9875037290460504464.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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
---
 io/parent.c       |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |   13 ++++++++++-
 2 files changed, 70 insertions(+), 4 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 927d05d70b0c..8db93d987552 100644
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
index b9d5447703fc..02036e3d093b 100644
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

