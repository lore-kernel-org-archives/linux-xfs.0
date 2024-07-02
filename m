Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DFC38B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882939; cv=none; b=cVtGVIDX76xcJfG4wDIgrgpas2xnrkQXQNxLbGTFJ8fRaH9nvTxfMsn+bE/zpU8ei2pppwrNTU9t8uQcbv0hSmMuUDwjX4LqFwP8LCedhEeEhug3kQTMtWlBUdoGBUaUZlmy7Do/ZU9axyT++zo4w4ur8QrmX1hY3aOVQmHZPWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882939; c=relaxed/simple;
	bh=/QMzyBdU4LzVZTPUJYR7RdCek1zglB/kXGCSulx9Yx4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lC7dqo9EQm9TgZxJDeqrgwDgWV23+tQQJdb25882Iv3SEqVfuibj0LgR/fe1QB5/JU4EAZkdifkFAvlgotStW5mCRbpPJZRjCZoaoJ6Ps6mKPgpY0tvD3v7YMg6Hpq5OQakk0DO9jsZUWetL1glt1cBWzKFpRWZmWrWsiWXqBJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WL7K8nsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WL7K8nsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28412C116B1;
	Tue,  2 Jul 2024 01:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882939;
	bh=/QMzyBdU4LzVZTPUJYR7RdCek1zglB/kXGCSulx9Yx4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WL7K8nsSxZG9vxXxxn+K256i2FusPgZ4UPWNRHBZxRDgV/64Rvp+x0192742JMXl0
	 ms6nRsOLj/pp26ImugIPc+f7t1PUxsJWGofZaurRvzOgnEaBASvZHp9UkosZvalwPI
	 mxAX5nsHCyQSWgBbIxTuNQVGJI44ZHWj2HeC96nymOxLBNzOW43BQi5N9EnDH+fYU9
	 SBXxgk4P/lkfOiQ/QtgWlS+IdeLtGHY2+HdKYDYM2a957fWmhetHJCOIMxY9w5C6ug
	 xhzy3fjdxg524sR0tQPeWpW6zLeSvKhjHN9uz2pGKy9ja+Z4wpP1weROGhLB1jEFCh
	 RkuCisWkKyOWA==
Date: Mon, 01 Jul 2024 18:15:38 -0700
Subject: [PATCH 19/24] xfs_db: make attr_set and attr_remove handle parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121357.2009260.1818577364230485511.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Make it so that xfs_db can load up the filesystem (somewhat uselessly)
with parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c             |  202 +++++++++++++++++++++++++++++++++++++---------
 libxfs/libxfs_api_defs.h |    1 
 man/man8/xfs_db.8        |   21 ++++-
 3 files changed, 181 insertions(+), 43 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 3b5db7c2aedb..d9ab79fa7849 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -24,11 +24,11 @@ static void		attrset_help(void);
 
 static const cmdinfo_t	attr_set_cmd =
 	{ "attr_set", "aset", attr_set_f, 1, -1, 0,
-	  N_("[-r|-s|-u] [-n] [-R|-C] [-v n] name"),
+	  N_("[-r|-s|-u|-p] [-n] [-R|-C] [-v n] name"),
 	  N_("set the named attribute on the current inode"), attrset_help };
 static const cmdinfo_t	attr_remove_cmd =
 	{ "attr_remove", "aremove", attr_remove_f, 1, -1, 0,
-	  N_("[-r|-s|-u] [-n] name"),
+	  N_("[-r|-s|-u|-p] [-n] name"),
 	  N_("remove the named attribute from the current inode"), attrset_help };
 
 static void
@@ -44,6 +44,7 @@ attrset_help(void)
 "  -r -- 'root'\n"
 "  -u -- 'user'		(default)\n"
 "  -s -- 'secure'\n"
+"  -p -- 'parent'\n"
 "\n"
 " For attr_set, these options further define the type of set operation:\n"
 "  -C -- 'create'    - create attribute, fail if it already exists\n"
@@ -62,6 +63,49 @@ attrset_init(void)
 	add_command(&attr_remove_cmd);
 }
 
+static unsigned char *
+get_buf_from_file(
+	const char	*fname,
+	size_t		bufsize,
+	int		*namelen)
+{
+	FILE		*fp;
+	unsigned char	*buf;
+	size_t		sz;
+
+	buf = malloc(bufsize + 1);
+	if (!buf) {
+		perror("malloc");
+		return NULL;
+	}
+
+	fp = fopen(fname, "r");
+	if (!fp) {
+		perror(fname);
+		goto out_free;
+	}
+
+	sz = fread(buf, sizeof(char), bufsize, fp);
+	if (sz == 0) {
+		printf("%s: Could not read anything from file\n", fname);
+		goto out_fp;
+	}
+
+	fclose(fp);
+
+	*namelen = sz;
+	return buf;
+out_fp:
+	fclose(fp);
+out_free:
+	free(buf);
+	return NULL;
+}
+
+#define LIBXFS_ATTR_NS		(LIBXFS_ATTR_SECURE | \
+				 LIBXFS_ATTR_ROOT | \
+				 LIBXFS_ATTR_PARENT)
+
 static int
 attr_set_f(
 	int			argc,
@@ -69,6 +113,8 @@ attr_set_f(
 {
 	struct xfs_da_args	args = { };
 	char			*sp;
+	char			*name_from_file = NULL;
+	char			*value_from_file = NULL;
 	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERT;
 	int			c;
 
@@ -81,20 +127,23 @@ attr_set_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "rusCRnv:")) != EOF) {
+	while ((c = getopt(argc, argv, "ruspCRnN:v:V:")) != EOF) {
 		switch (c) {
 		/* namespaces */
 		case 'r':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_ROOT;
-			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
-					      LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			break;
 		case 's':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_SECURE;
-			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
+			break;
+		case 'p':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			args.attr_filter |= XFS_ATTR_PARENT;
 			break;
 
 		/* modifiers */
@@ -105,6 +154,10 @@ attr_set_f(
 			op = XFS_ATTRUPDATE_REPLACE;
 			break;
 
+		case 'N':
+			name_from_file = optarg;
+			break;
+
 		case 'n':
 			/*
 			 * We never touch attr2 these days; leave this here to
@@ -114,6 +167,11 @@ attr_set_f(
 
 		/* value length */
 		case 'v':
+			if (value_from_file) {
+				dbprintf(_("already set value file\n"));
+				return 0;
+			}
+
 			args.valuelen = strtol(optarg, &sp, 0);
 			if (*sp != '\0' ||
 			    args.valuelen < 0 || args.valuelen > 64 * 1024) {
@@ -122,30 +180,64 @@ attr_set_f(
 			}
 			break;
 
+		case 'V':
+			if (args.valuelen != 0) {
+				dbprintf(_("already set valuelen\n"));
+				return 0;
+			}
+
+			value_from_file = optarg;
+			break;
+
 		default:
 			dbprintf(_("bad option for attr_set command\n"));
 			return 0;
 		}
 	}
 
-	if (optind != argc - 1) {
-		dbprintf(_("too few options for attr_set (no name given)\n"));
-		return 0;
-	}
+	if (name_from_file) {
+		int namelen;
 
-	args.name = (const unsigned char *)argv[optind];
-	if (!args.name) {
-		dbprintf(_("invalid name\n"));
-		return 0;
-	}
+		if (optind != argc) {
+			dbprintf(_("too many options for attr_set (no name needed)\n"));
+			return 0;
+		}
+
+		args.name = get_buf_from_file(name_from_file, MAXNAMELEN,
+				&namelen);
+		if (!args.name)
+			return 0;
+
+		args.namelen = namelen;
+	} else {
+		if (optind != argc - 1) {
+			dbprintf(_("too few options for attr_set (no name given)\n"));
+			return 0;
+		}
 
-	args.namelen = strlen(argv[optind]);
-	if (args.namelen >= MAXNAMELEN) {
-		dbprintf(_("name too long\n"));
-		return 0;
+		args.name = (const unsigned char *)argv[optind];
+		if (!args.name) {
+			dbprintf(_("invalid name\n"));
+			return 0;
+		}
+
+		args.namelen = strlen(argv[optind]);
+		if (args.namelen >= MAXNAMELEN) {
+			dbprintf(_("name too long\n"));
+			goto out;
+		}
 	}
 
-	if (args.valuelen) {
+	if (value_from_file) {
+		int valuelen;
+
+		args.value = get_buf_from_file(value_from_file,
+				XFS_XATTR_SIZE_MAX, &valuelen);
+		if (!args.value)
+			goto out;
+
+		args.valuelen = valuelen;
+	} else if (args.valuelen) {
 		args.value = memalign(getpagesize(), args.valuelen);
 		if (!args.value) {
 			dbprintf(_("cannot allocate buffer (%d)\n"),
@@ -175,6 +267,8 @@ attr_set_f(
 		libxfs_irele(args.dp);
 	if (args.value)
 		free(args.value);
+	if (name_from_file)
+		free((void *)args.name);
 	return 0;
 }
 
@@ -184,6 +278,7 @@ attr_remove_f(
 	char			**argv)
 {
 	struct xfs_da_args	args = { };
+	char			*name_from_file = NULL;
 	int			c;
 
 	if (cur_typ == NULL) {
@@ -195,20 +290,27 @@ attr_remove_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "rusn")) != EOF) {
+	while ((c = getopt(argc, argv, "ruspnN:")) != EOF) {
 		switch (c) {
 		/* namespaces */
 		case 'r':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_ROOT;
-			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
-					      LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			break;
 		case 's':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_SECURE;
-			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
+			break;
+		case 'p':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			args.attr_filter |= XFS_ATTR_PARENT;
+			break;
+
+		case 'N':
+			name_from_file = optarg;
 			break;
 
 		case 'n':
@@ -224,21 +326,37 @@ attr_remove_f(
 		}
 	}
 
-	if (optind != argc - 1) {
-		dbprintf(_("too few options for attr_remove (no name given)\n"));
-		return 0;
-	}
-
-	args.name = (const unsigned char *)argv[optind];
-	if (!args.name) {
-		dbprintf(_("invalid name\n"));
-		return 0;
-	}
-
-	args.namelen = strlen(argv[optind]);
-	if (args.namelen >= MAXNAMELEN) {
-		dbprintf(_("name too long\n"));
-		return 0;
+	if (name_from_file) {
+		int namelen;
+
+		if (optind != argc) {
+			dbprintf(_("too many options for attr_set (no name needed)\n"));
+			return 0;
+		}
+
+		args.name = get_buf_from_file(name_from_file, MAXNAMELEN,
+				&namelen);
+		if (!args.name)
+			return 0;
+
+		args.namelen = namelen;
+	} else {
+		if (optind != argc - 1) {
+			dbprintf(_("too few options for attr_remove (no name given)\n"));
+			return 0;
+		}
+
+		args.name = (const unsigned char *)argv[optind];
+		if (!args.name) {
+			dbprintf(_("invalid name\n"));
+			return 0;
+		}
+
+		args.namelen = strlen(argv[optind]);
+		if (args.namelen >= MAXNAMELEN) {
+			dbprintf(_("name too long\n"));
+			return 0;
+		}
 	}
 
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
@@ -260,5 +378,7 @@ attr_remove_f(
 out:
 	if (args.dp)
 		libxfs_irele(args.dp);
+	if (name_from_file)
+		free((void *)args.name);
 	return 0;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5713e5221fe6..bceaab8baa8c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -15,6 +15,7 @@
  */
 #define LIBXFS_ATTR_ROOT		XFS_ATTR_ROOT
 #define LIBXFS_ATTR_SECURE		XFS_ATTR_SECURE
+#define LIBXFS_ATTR_PARENT		XFS_ATTR_PARENT
 
 #define xfs_agfl_size			libxfs_agfl_size
 #define xfs_agfl_walk			libxfs_agfl_walk
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 937b17e79a35..a561bdc492d4 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -184,10 +184,14 @@ Displays the length, free block count, per-AG reservation size, and per-AG
 reservation usage for a given AG.
 If no argument is given, display information for all AGs.
 .TP
-.BI "attr_remove [\-r|\-u|\-s] [\-n] " name
+.BI "attr_remove [\-p|\-r|\-u|\-s] [\-n] [\-N " namefile "|" name "] "
 Remove the specified extended attribute from the current file.
 .RS 1.0i
 .TP 0.4i
+.B \-p
+Sets the attribute in the parent namespace.
+Only one namespace option can be specified.
+.TP
 .B \-r
 Sets the attribute in the root namespace.
 Only one namespace option can be specified.
@@ -200,14 +204,21 @@ Only one namespace option can be specified.
 Sets the attribute in the secure namespace.
 Only one namespace option can be specified.
 .TP
+.B \-N
+Read the name from this file.
+.TP
 .B \-n
 Do not enable 'noattr2' mode on V4 filesystems.
 .RE
 .TP
-.BI "attr_set [\-r|\-u|\-s] [\-n] [\-R|\-C] [\-v " namelen "] " name
+.BI "attr_set [\-p\-r|\-u|\-s] [\-n] [\-R|\-C] [\-v " valuelen "|\-V " valuefile "] [\-N " namefile "|" name "] "
 Sets an extended attribute on the current file with the given name.
 .RS 1.0i
 .TP 0.4i
+.B \-p
+Sets the attribute in the parent namespace.
+Only one namespace option can be specified.
+.TP
 .B \-r
 Sets the attribute in the root namespace.
 Only one namespace option can be specified.
@@ -220,6 +231,9 @@ Only one namespace option can be specified.
 Sets the attribute in the secure namespace.
 Only one namespace option can be specified.
 .TP
+.B \-N
+Read the name from this file.
+.TP
 .B \-n
 Do not enable 'noattr2' mode on V4 filesystems.
 .TP
@@ -231,6 +245,9 @@ The command will fail if the attribute does not already exist.
 Create the attribute.
 The command will fail if the attribute already exists.
 .TP
+.B \-V
+Read the value from this file.
+.TP
 .B \-v
 Set the attribute value to a string of this length containing the letter 'v'.
 .RE

