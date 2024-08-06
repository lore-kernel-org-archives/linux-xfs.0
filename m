Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275E828DD1;
	Tue,  6 Aug 2024 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722968454; cv=none; b=PbeT1kZzFp+cWqGzoaRjf8VY8BchFXXsf0k96i518z/BApNpGbzh4aqT4JyztJV07CwrAjCKs6edKNGs/swDZUIG+eL+Z1LhX9EFzcN80EhoFXHABSVw0KkT3ROvk55WMAjCBSNb1JolgdmvHMGBWS2mVOYLeweq3yHfa+jfN44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722968454; c=relaxed/simple;
	bh=Hm7VWsZapkvuEjCdExNxDaefTI5ppztdrFz4zOwc+tw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGAD0GGe+94ywEod608mkKn/viVG5JiAQDIIvIMEslRKI1cDcrOp0ewPNVLTZz+CwBN4MHCKmNAhybUg5a/F/ymYg+2ecFIFaIQt2xcCXISHnv7g7BpEdzWRPmnQ9lpuXm7W6iqoTZr0ArodbRg5intVBj3BYdBJI78jBCEKsNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJ+4x0DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJ+4x0DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B13EC32786;
	Tue,  6 Aug 2024 18:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722968453;
	bh=Hm7VWsZapkvuEjCdExNxDaefTI5ppztdrFz4zOwc+tw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BJ+4x0DYgmLamICRXjMWMzIrDFqp3hXgQXsAx4+A/GYAkjYp0I8EaYnZ7nDogMAUn
	 Xv53Q/yDSPZ3oC4+Ecgcv8RphjI+CLpHml4od4xU1Fhd4FDtq9nkaWoliB+p6xElJz
	 Cjduwez072OjNmoDUQs54Hz7o2KNOTvmCaG9aZ9LTW9GIqH/y1JS56EePqA6MwIaQR
	 UO8laUp2/ENiCvdxu6ZW0zh9vjkjMPJ+59RDT9VpxYrEmmwSEAtTmknfbqjA3Mq/hp
	 ISA9yr0usXzdo/lyUFqeFBEySA/m1FVQoHhkaoXQLQeyOgBTAc8y4DDrG2UBlSLYog
	 vIfgPwVqjO5OQ==
Date: Tue, 06 Aug 2024 11:20:53 -0700
Subject: [PATCH 6/7] xfs_db: add a command to list xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 hch@lst.de, dchinner@redhat.com, fstests@vger.kernel.org,
 linux-xfs@vger.kernel.org
Message-ID: <172296825279.3193059.16274209837031348230.stgit@frogsfrogsfrogs>
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

Add a command to list extended attributes from xfs_db.  We'll need this
later to manage the fs properties when unmounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Dave Chinner <dchinner@redhat.com>
---
 db/attrset.c      |  201 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   28 +++++++
 2 files changed, 229 insertions(+)


diff --git a/db/attrset.c b/db/attrset.c
index 9e53e63c9..e3ffb75aa 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -18,13 +18,21 @@
 #include "malloc.h"
 #include <sys/xattr.h>
 #include "libfrog/fsproperties.h"
+#include "libxfs/listxattr.h"
 
+static int		attr_list_f(int argc, char **argv);
 static int		attr_get_f(int argc, char **argv);
 static int		attr_set_f(int argc, char **argv);
 static int		attr_remove_f(int argc, char **argv);
+
+static void		attrlist_help(void);
 static void		attrget_help(void);
 static void		attrset_help(void);
 
+static const cmdinfo_t	attr_list_cmd =
+	{ "attr_list", "alist", attr_list_f, 0, -1, 0,
+	  N_("[-r|-s|-u|-p|-Z] [-v]"),
+	  N_("list attributes on the current inode"), attrlist_help };
 static const cmdinfo_t	attr_get_cmd =
 	{ "attr_get", "aget", attr_get_f, 1, -1, 0,
 	  N_("[-r|-s|-u|-p|-Z] name"),
@@ -38,6 +46,24 @@ static const cmdinfo_t	attr_remove_cmd =
 	  N_("[-r|-s|-u|-p|-Z] [-n] name"),
 	  N_("remove the named attribute from the current inode"), attrset_help };
 
+static void
+attrlist_help(void)
+{
+	dbprintf(_(
+"\n"
+" The attr_list command provide interfaces for listing all extended attributes\n"
+" attached to an inode.\n"
+" There are 4 namespace flags:\n"
+"  -r -- 'root'\n"
+"  -u -- 'user'		(default)\n"
+"  -s -- 'secure'\n"
+"  -p -- 'parent'\n"
+"  -Z -- fs property\n"
+"\n"
+"  -v -- print the value of the attributes\n"
+"\n"));
+}
+
 static void
 attrget_help(void)
 {
@@ -87,6 +113,7 @@ attrset_init(void)
 	if (!expert_mode)
 		return;
 
+	add_command(&attr_list_cmd);
 	add_command(&attr_get_cmd);
 	add_command(&attr_set_cmd);
 	add_command(&attr_remove_cmd);
@@ -650,3 +677,177 @@ attr_get_f(
 		free((void *)args.name);
 	return 0;
 }
+
+struct attrlist_ctx {
+	unsigned int		attr_filter;
+	bool			print_values;
+	bool			fsprop;
+};
+
+static int
+attrlist_print(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct attrlist_ctx	*ctx = priv;
+	struct xfs_da_args	args = {
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.dp		= ip,
+		.owner		= ip->i_ino,
+		.trans		= tp,
+		.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.name		= name,
+		.namelen	= namelen,
+	};
+	char			namebuf[MAXNAMELEN + 1];
+	const char		*print_name = namebuf;
+	int			error;
+
+	if ((attr_flags & XFS_ATTR_NSP_ONDISK_MASK) != ctx->attr_filter)
+		return 0;
+
+	/* Make sure the name is null terminated. */
+	memcpy(namebuf, name, namelen);
+	namebuf[MAXNAMELEN] = 0;
+
+	if (ctx->fsprop) {
+		const char	*p = attr_name_to_fsprop_name(namebuf);
+
+		if (!p)
+			return 0;
+
+		namelen -= (p - namebuf);
+		print_name = p;
+	}
+
+	if (!ctx->print_values) {
+		printf("%.*s\n", namelen, print_name);
+		return 0;
+	}
+
+	if (value) {
+		printf("%.*s=%.*s\n", namelen, print_name, valuelen,
+				(char *)value);
+		return 0;
+	}
+
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
+				args.name, (unsigned long long)iocur_top->ino,
+				strerror(error));
+		return error;
+	}
+
+	printf("%.*s=%.*s\n", namelen, print_name, args.valuelen,
+			(char *)args.value);
+	kfree(args.value);
+
+	return 0;
+}
+
+static int
+attr_list_f(
+	int			argc,
+	char			**argv)
+{
+	struct attrlist_ctx	ctx = { };
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
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
+	while ((c = getopt(argc, argv, "ruspvZ")) != EOF) {
+		switch (c) {
+		/* namespaces */
+		case 'Z':
+			ctx.fsprop = true;
+			fallthrough;
+		case 'r':
+			ctx.attr_filter &= ~LIBXFS_ATTR_NS;
+			ctx.attr_filter |= LIBXFS_ATTR_ROOT;
+			break;
+		case 'u':
+			ctx.attr_filter &= ~LIBXFS_ATTR_NS;
+			break;
+		case 's':
+			ctx.attr_filter &= ~LIBXFS_ATTR_NS;
+			ctx.attr_filter |= LIBXFS_ATTR_SECURE;
+			break;
+		case 'p':
+			ctx.attr_filter &= ~LIBXFS_ATTR_NS;
+			ctx.attr_filter |= XFS_ATTR_PARENT;
+			break;
+
+		case 'v':
+			ctx.print_values = true;
+			break;
+		default:
+			dbprintf(_("bad option for attr_list command\n"));
+			return 0;
+		}
+	}
+
+	if (ctx.fsprop &&
+	    (ctx.attr_filter & LIBXFS_ATTR_NS) != LIBXFS_ATTR_ROOT) {
+		dbprintf(_("fs properties must be ATTR_ROOT\n"));
+		return false;
+	}
+
+	if (optind != argc) {
+		dbprintf(_("too many options for attr_list (no name needed)\n"));
+		return 0;
+	}
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error) {
+		dbprintf(_("failed to allocate empty transaction\n"));
+		return 0;
+	}
+
+	error = -libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip);
+	if (error) {
+		dbprintf(_("failed to iget inode %llu: %s\n"),
+				(unsigned long long)iocur_top->ino,
+				strerror(error));
+		goto out_trans;
+	}
+
+	error = xattr_walk(tp, ip, attrlist_print, &ctx);
+	if (error) {
+		dbprintf(_("walking inode %llu xattrs: %s\n"),
+				(unsigned long long)iocur_top->ino,
+				strerror(error));
+		goto out_inode;
+	}
+
+out_inode:
+	libxfs_irele(ip);
+out_trans:
+	libxfs_trans_cancel(tp);
+	return 0;
+}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f0865b2df..291ec1c58 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -212,6 +212,34 @@ Only one namespace option can be specified.
 Read the name from this file.
 .RE
 .TP
+.BI "attr_list [\-p|\-r|\-u|\-s|\-Z] [\-v] "
+Lists the extended attributes of the current file.
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
+.B \-v
+Print the extended attribute values too.
+.RE
+.TP
 .BI "attr_remove [\-p|\-r|\-u|\-s|\-Z] [\-n] [\-N " namefile "|" name "] "
 Remove the specified extended attribute from the current file.
 .RS 1.0i

