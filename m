Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9751854
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309631; cv=none; b=kkAq8wmdfGkzWKg3xSS424GQ2UbVJYdUyP/PnUnkqzvlh0l8akg/KwrBLJt7neXgREkBMuQHXmztGbTSWeioV/EZw0rBvLhSA8iiGF6LXoMcI//ZbbyHSQJW6czLuL1cG/Ly4ZxDIMcssUrVEU7OW/d0eWXkqSr5k+CczyqI8lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309631; c=relaxed/simple;
	bh=MI5M3brHZLVaIe0G5kLB2cY+WI+ix0LEg3Uwe7YEq5k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UY6biqFw3TDzhoyFmuY8/juZm67FMcgnNv53L3A7cPEy+sSUy/f8LWzIKOxIi39cN7BEpbkLsih1SWP3V/DbzjUgSmtL7UxQN32s2j7I3S9siymy20sS8WPkAvPrBvoSszAa7vqQcRkt98rS5DfFAizjLiUBoC9RggD94KtofnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHFk4QGm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHFk4QGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4932C4AF0A;
	Tue, 30 Jul 2024 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309630;
	bh=MI5M3brHZLVaIe0G5kLB2cY+WI+ix0LEg3Uwe7YEq5k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WHFk4QGmAa7xghga7lEjfB9uo35Ao0sDnyiYbNLfRxO8igJBjACu9u8A1b/RZXjJP
	 1EvdsroJYAKX0h4RgJ70qKh7oEZeblbvwXo160D8OSk5A5nXNjsQ3hmt90suFwn18J
	 5yzY9AvV6nkvCKymi4dCuJf6NZ1T8Uyd2B72RcXwy7G5wU36S1+K3TjY1N6aY5HwA7
	 52zo3aJzH7QKJBPDXojhlvbNR3bV7EIrHVIaa90Cse7b+IZfIlvahr9jOcNESOFugO
	 ZIDcAeUkJHCXgBsRmtWTZ0iV3XwgTZ5GOpXwpjIB/bYD5liuR4ISn+nH3xaCajpSav
	 jUkqv8Ei9Es/A==
Date: Mon, 29 Jul 2024 20:20:30 -0700
Subject: [PATCH 3/7] xfs_db: improve getting and setting extended attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172230940616.1543753.12935781628377990063.stgit@frogsfrogsfrogs>
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

Add an attr_get command to retrieve the value of an xattr from a file;
and extend the attr_set command to allow passing of string values.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c      |  262 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   40 ++++++++
 2 files changed, 293 insertions(+), 9 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 81d530055193..4e7cca450322 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -17,20 +17,44 @@
 #include "inode.h"
 #include "malloc.h"
 #include <sys/xattr.h>
+#include "libfrog/fsproperties.h"
 
+static int		attr_get_f(int argc, char **argv);
 static int		attr_set_f(int argc, char **argv);
 static int		attr_remove_f(int argc, char **argv);
+static void		attrget_help(void);
 static void		attrset_help(void);
 
+static const cmdinfo_t	attr_get_cmd =
+	{ "attr_get", "aget", attr_get_f, 1, -1, 0,
+	  N_("[-r|-s|-u|-p|-Z] name"),
+	  N_("get the named attribute on the current inode"), attrget_help };
 static const cmdinfo_t	attr_set_cmd =
 	{ "attr_set", "aset", attr_set_f, 1, -1, 0,
-	  N_("[-r|-s|-u|-p] [-n] [-R|-C] [-v n] name"),
+	  N_("[-r|-s|-u|-p|-Z] [-n] [-R|-C] [-v n] name"),
 	  N_("set the named attribute on the current inode"), attrset_help };
 static const cmdinfo_t	attr_remove_cmd =
 	{ "attr_remove", "aremove", attr_remove_f, 1, -1, 0,
-	  N_("[-r|-s|-u|-p] [-n] name"),
+	  N_("[-r|-s|-u|-p|-Z] [-n] name"),
 	  N_("remove the named attribute from the current inode"), attrset_help };
 
+static void
+attrget_help(void)
+{
+	dbprintf(_(
+"\n"
+" The attr_get command provide interfaces for retrieving the values of extended\n"
+" attributes of a file.  This command requires attribute names to be specified.\n"
+" There are 4 namespace flags:\n"
+"  -r -- 'root'\n"
+"  -u -- 'user'		(default)\n"
+"  -s -- 'secure'\n"
+"  -p -- 'parent'\n"
+"  -f -- 'fs-verity'\n"
+"  -Z -- fs property\n"
+"\n"));
+}
+
 static void
 attrset_help(void)
 {
@@ -45,10 +69,15 @@ attrset_help(void)
 "  -u -- 'user'		(default)\n"
 "  -s -- 'secure'\n"
 "  -p -- 'parent'\n"
+"  -Z -- fs property\n"
 "\n"
 " For attr_set, these options further define the type of set operation:\n"
 "  -C -- 'create'    - create attribute, fail if it already exists\n"
 "  -R -- 'replace'   - replace attribute, fail if it does not exist\n"
+"\n"
+" If the attribute value is a string, it can be specified after the\n"
+" attribute name.\n"
+"\n"
 " The backward compatibility mode 'noattr2' can be emulated (-n) also.\n"
 "\n"));
 }
@@ -59,6 +88,7 @@ attrset_init(void)
 	if (!expert_mode)
 		return;
 
+	add_command(&attr_get_cmd);
 	add_command(&attr_set_cmd);
 	add_command(&attr_remove_cmd);
 }
@@ -106,6 +136,57 @@ get_buf_from_file(
 				 LIBXFS_ATTR_ROOT | \
 				 LIBXFS_ATTR_PARENT)
 
+static bool
+adjust_fsprop_attr_name(
+	struct xfs_da_args	*args,
+	bool			*free_name)
+{
+	const char		*o = args->name;
+	char			*p;
+	int			ret;
+
+	if ((args->attr_filter & LIBXFS_ATTR_NS) != LIBXFS_ATTR_ROOT) {
+		dbprintf(_("fs properties must be ATTR_ROOT\n"));
+		return false;
+	}
+
+	ret = fsprop_name_to_attr_name(o, &p);
+	if (ret < 0) {
+		dbprintf(_("could not allocate fs property name string\n"));
+		return false;
+	}
+	args->namelen = ret;
+	args->name = p;
+
+	if (*free_name)
+		free((void *)o);
+	*free_name = true;
+
+	if (args->namelen > MAXNAMELEN) {
+		dbprintf(_("%s: name too long\n"), args->name);
+		return false;
+	}
+
+	if (args->valuelen > ATTR_MAX_VALUELEN) {
+		dbprintf(_("%s: value too long\n"), args->name);
+		return false;
+	}
+
+	return true;
+}
+
+static void
+print_fsprop(
+	struct xfs_da_args	*args)
+{
+	const char		*p = attr_name_to_fsprop_name(args->name);
+
+	if (p)
+		printf("%s=%.*s\n", p, args->valuelen, (char *)args->value);
+	else
+		fprintf(stderr, _("%s: not a fs property?\n"), args->name);
+}
+
 static int
 attr_set_f(
 	int			argc,
@@ -119,7 +200,9 @@ attr_set_f(
 	char			*sp;
 	char			*name_from_file = NULL;
 	char			*value_from_file = NULL;
+	bool			free_name = false;
 	enum xfs_attr_update	op = XFS_ATTRUPDATE_UPSERT;
+	bool			fsprop = false;
 	int			c;
 	int			error;
 
@@ -132,9 +215,12 @@ attr_set_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "ruspCRnN:v:V:")) != EOF) {
+	while ((c = getopt(argc, argv, "ruspCRnN:v:V:Z")) != EOF) {
 		switch (c) {
 		/* namespaces */
+		case 'Z':
+			fsprop = true;
+			fallthrough;
 		case 'r':
 			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_ROOT;
@@ -213,9 +299,10 @@ attr_set_f(
 		if (!args.name)
 			return 0;
 
+		free_name = true;
 		args.namelen = namelen;
 	} else {
-		if (optind != argc - 1) {
+		if (optind != argc - 1 && optind != argc - 2) {
 			dbprintf(_("too few options for attr_set (no name given)\n"));
 			return 0;
 		}
@@ -250,6 +337,25 @@ attr_set_f(
 			goto out;
 		}
 		memset(args.value, 'v', args.valuelen);
+	} else if (optind == argc - 2) {
+		args.valuelen = strlen(argv[optind + 1]);
+		args.value = strdup(argv[optind + 1]);
+		if (!args.value) {
+			dbprintf(_("cannot allocate buffer (%d)\n"),
+					args.valuelen);
+			goto out;
+		}
+	}
+
+	if (fsprop) {
+		if (!fsprop_validate(args.name, args.value)) {
+			dbprintf(_("%s: invalid value \"%s\"\n"),
+					args.name, args.value);
+			goto out;
+		}
+
+		if (!adjust_fsprop_attr_name(&args, &free_name))
+			goto out;
 	}
 
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
@@ -269,6 +375,9 @@ attr_set_f(
 		goto out;
 	}
 
+	if (fsprop)
+		print_fsprop(&args);
+
 	/* refresh with updated inode contents */
 	set_cur_inode(iocur_top->ino);
 
@@ -277,7 +386,7 @@ attr_set_f(
 		libxfs_irele(args.dp);
 	if (args.value)
 		free(args.value);
-	if (name_from_file)
+	if (free_name)
 		free((void *)args.name);
 	return 0;
 }
@@ -293,6 +402,8 @@ attr_remove_f(
 		.op_flags	= XFS_DA_OP_OKNOENT,
 	};
 	char			*name_from_file = NULL;
+	bool			free_name = false;
+	bool			fsprop = false;
 	int			c;
 	int			error;
 
@@ -305,9 +416,12 @@ attr_remove_f(
 		return 0;
 	}
 
-	while ((c = getopt(argc, argv, "ruspnN:")) != EOF) {
+	while ((c = getopt(argc, argv, "ruspnN:Z")) != EOF) {
 		switch (c) {
 		/* namespaces */
+		case 'Z':
+			fsprop = true;
+			fallthrough;
 		case 'r':
 			args.attr_filter &= ~LIBXFS_ATTR_NS;
 			args.attr_filter |= LIBXFS_ATTR_ROOT;
@@ -354,6 +468,7 @@ attr_remove_f(
 		if (!args.name)
 			return 0;
 
+		free_name = true;
 		args.namelen = namelen;
 	} else {
 		if (optind != argc - 1) {
@@ -374,6 +489,9 @@ attr_remove_f(
 		}
 	}
 
+	if (fsprop && !adjust_fsprop_attr_name(&args, &free_name))
+		goto out;
+
 	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
@@ -398,7 +516,137 @@ attr_remove_f(
 out:
 	if (args.dp)
 		libxfs_irele(args.dp);
-	if (name_from_file)
+	if (free_name)
+		free((void *)args.name);
+	return 0;
+}
+
+static int
+attr_get_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
+	char			*name_from_file = NULL;
+	bool			free_name = false;
+	bool			fsprop = false;
+	int			c;
+	int			error;
+
+	if (cur_typ == NULL) {
+		dbprintf(_("no current type\n"));
+		return 0;
+	}
+	if (cur_typ->typnm != TYP_INODE) {
+		dbprintf(_("current type is not inode\n"));
+		return 0;
+	}
+
+	while ((c = getopt(argc, argv, "ruspN:Z")) != EOF) {
+		switch (c) {
+		/* namespaces */
+		case 'Z':
+			fsprop = true;
+			fallthrough;
+		case 'r':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			args.attr_filter |= LIBXFS_ATTR_ROOT;
+			break;
+		case 'u':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			break;
+		case 's':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			args.attr_filter |= LIBXFS_ATTR_SECURE;
+			break;
+		case 'p':
+			args.attr_filter &= ~LIBXFS_ATTR_NS;
+			args.attr_filter |= XFS_ATTR_PARENT;
+			break;
+
+		case 'N':
+			name_from_file = optarg;
+			break;
+		default:
+			dbprintf(_("bad option for attr_get command\n"));
+			return 0;
+		}
+	}
+
+	if (name_from_file) {
+		int namelen;
+
+		if (optind != argc) {
+			dbprintf(_("too many options for attr_get (no name needed)\n"));
+			return 0;
+		}
+
+		args.name = get_buf_from_file(name_from_file, MAXNAMELEN,
+				&namelen);
+		if (!args.name)
+			return 0;
+
+		free_name = true;
+		args.namelen = namelen;
+	} else {
+		if (optind != argc - 1) {
+			dbprintf(_("too few options for attr_get (no name given)\n"));
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
+			goto out;
+		}
+	}
+
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp)) {
+		dbprintf(_("failed to iget inode %llu\n"),
+			(unsigned long long)iocur_top->ino);
+		goto out;
+	}
+
+	if (fsprop && !adjust_fsprop_attr_name(&args, &free_name))
+		goto out;
+
+	args.owner = iocur_top->ino;
+	libxfs_attr_sethash(&args);
+
+	/*
+	 * Look up attr value with a maximally long length and a null buffer
+	 * to return the value and the correct length.
+	 */
+	args.valuelen = XATTR_SIZE_MAX;
+	error = -libxfs_attr_get(&args);
+	if (error) {
+		dbprintf(_("failed to get attr %s on inode %llu: %s\n"),
+			args.name, (unsigned long long)iocur_top->ino,
+			strerror(error));
+		goto out;
+	}
+
+	if (fsprop)
+		print_fsprop(&args);
+	else
+		printf("%.*s\n", args.valuelen, (char *)args.value);
+
+out:
+	if (args.dp)
+		libxfs_irele(args.dp);
+	if (args.value)
+		free(args.value);
+	if (free_name)
 		free((void *)args.name);
 	return 0;
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 9f6fea5748d4..f0865b2df4ec 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -184,7 +184,35 @@ Displays the length, free block count, per-AG reservation size, and per-AG
 reservation usage for a given AG.
 If no argument is given, display information for all AGs.
 .TP
-.BI "attr_remove [\-p|\-r|\-u|\-s] [\-n] [\-N " namefile "|" name "] "
+.BI "attr_get [\-p|\-r|\-u|\-s|\-Z] [\-N " namefile "|" name "] "
+Print the value of the specified extended attribute from the current file.
+.RS 1.0i
+.TP 0.4i
+.B \-p
+Sets the attribute in the parent namespace.
+Only one namespace option can be specified.
+.TP
+.B \-r
+Sets the attribute in the root namespace.
+Only one namespace option can be specified.
+.TP
+.B \-u
+Sets the attribute in the user namespace.
+Only one namespace option can be specified.
+.TP
+.B \-s
+Sets the attribute in the secure namespace.
+Only one namespace option can be specified.
+.TP
+.B \-Z
+Sets a filesystem property in the root namespace.
+Only one namespace option can be specified.
+.TP
+.B \-N
+Read the name from this file.
+.RE
+.TP
+.BI "attr_remove [\-p|\-r|\-u|\-s|\-Z] [\-n] [\-N " namefile "|" name "] "
 Remove the specified extended attribute from the current file.
 .RS 1.0i
 .TP 0.4i
@@ -204,6 +232,10 @@ Only one namespace option can be specified.
 Sets the attribute in the secure namespace.
 Only one namespace option can be specified.
 .TP
+.B \-Z
+Sets a filesystem property in the root namespace.
+Only one namespace option can be specified.
+.TP
 .B \-N
 Read the name from this file.
 .TP
@@ -211,7 +243,7 @@ Read the name from this file.
 Do not enable 'noattr2' mode on V4 filesystems.
 .RE
 .TP
-.BI "attr_set [\-p\-r|\-u|\-s] [\-n] [\-R|\-C] [\-v " valuelen "|\-V " valuefile "] [\-N " namefile "|" name "] "
+.BI "attr_set [\-p\-r|\-u|\-s|\-Z] [\-n] [\-R|\-C] [\-v " valuelen "|\-V " valuefile "] [\-N " namefile "|" name "] [" value "]"
 Sets an extended attribute on the current file with the given name.
 .RS 1.0i
 .TP 0.4i
@@ -231,6 +263,10 @@ Only one namespace option can be specified.
 Sets the attribute in the secure namespace.
 Only one namespace option can be specified.
 .TP
+.B \-Z
+Sets a filesystem property in the root namespace.
+Only one namespace option can be specified.
+.TP
 .B \-N
 Read the name from this file.
 .TP

