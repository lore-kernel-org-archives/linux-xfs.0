Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42302C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tkmzr7Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD3CC433C7;
	Sun, 31 Dec 2023 23:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064626;
	bh=nrgYqZUuqYzdpIGcPfylcFPKdKyiWjLVFLeUHjI0Y1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tkmzr7MbjmoBTDvq1N9NQQJEB3zHv6Di386epefP8ZcMUdmBiVXzt0+nbGyXGPQXH
	 wpBpYJREl0PsRfDwQu/DgAOpHfsroC7CH694PJ2vv3xfJ2vXnvDzfO0I9JTIiA9kL5
	 DCxg13JN9AvuDZgRhJ2VPRHazWcCbqMakocdJk2b87pHnPqztle14tXxpImTWfBEkv
	 FWLjv0y63La5dCcmxOJvJ0iNW1ajk98t/2ejT3gy90CpF6b4g60/oxG415fh/K+6r1
	 xbJMJQPwwgUhX0/tWkPjcr8me9R+ba1zrTxcNQgQycPB0egHNibQOExSKCtFw8scj8
	 9cG4wUZKpmwGQ==
Date: Sun, 31 Dec 2023 15:17:05 -0800
Subject: [PATCH 14/18] xfs_repair: dump garbage parent pointer attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405007049.1805510.13334389199605845708.stgit@frogsfrogsfrogs>
In-Reply-To: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
References: <170405006850.1805510.11145262768706358018.stgit@frogsfrogsfrogs>
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

Delete xattrs that have ATTR_PARENT set but are so garbage that they
clearly aren't parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c |  145 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 2 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 11aa8d4e322..21b15ab80ea 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -192,6 +192,29 @@ struct file_scan {
 
 	/* Does this file have garbage xattrs with ATTR_PARENT set? */
 	bool			have_garbage;
+
+	/* xattrs that we have to remove from this file */
+	struct xfs_slab		*garbage_xattr_recs;
+
+	/* attr names associated with garbage_xattr_recs */
+	struct xfblob		*garbage_xattr_names;
+};
+
+struct garbage_xattr {
+	/* xfs_da_args.attr_filter for the attribute being removed */
+	unsigned int		attr_filter;
+
+	/* attribute name length */
+	unsigned int		attrnamelen;
+
+	/* attribute value length */
+	unsigned int		attrvaluelen;
+
+	/* cookie for the attribute name */
+	xfblob_cookie		attrname_cookie;
+
+	/* cookie for the attribute value */
+	xfblob_cookie		attrvalue_cookie;
 };
 
 /* Global names storage file. */
@@ -381,6 +404,78 @@ add_parent_ptr(
 			(unsigned long long)ag_pptr.name_cookie);
 }
 
+/* Remove garbage extended attributes that have ATTR_PARENT set. */
+static void
+remove_garbage_xattrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	struct xfs_slab_cursor	*cur;
+	struct garbage_xattr	*ga;
+	void			*buf = NULL;
+	size_t			bufsize = 0;
+	int			error;
+
+	error = -init_slab_cursor(fscan->garbage_xattr_recs, NULL, &cur);
+	if (error)
+		do_error(_("init garbage xattr cursor failed: %s\n"),
+				strerror(error));
+
+	while ((ga = pop_slab_cursor(cur)) != NULL) {
+		struct xfs_da_args	args = {
+			.dp		= ip,
+			.attr_filter	= ga->attr_filter,
+			.namelen	= ga->attrnamelen,
+			.valuelen	= ga->attrvaluelen,
+			.op_flags	= XFS_DA_OP_REMOVE | XFS_DA_OP_NVLOOKUP,
+		};
+		size_t		desired = ga->attrnamelen + ga->attrvaluelen;
+
+		if (desired > bufsize) {
+			free(buf);
+			buf = malloc(desired);
+			if (!buf)
+				do_error(
+ _("allocating %zu bytes to remove ino %llu garbage xattr failed: %s\n"),
+						desired,
+						(unsigned long long)ip->i_ino,
+						strerror(errno));
+			bufsize = desired;
+		}
+
+		args.name = buf;
+		args.value = buf + ga->attrnamelen;
+
+		error = -xfblob_load(fscan->garbage_xattr_names,
+				ga->attrname_cookie, buf, ga->attrnamelen);
+		if (error)
+			do_error(
+ _("loading garbage xattr name failed: %s\n"),
+					strerror(error));
+
+		error = -xfblob_load(fscan->garbage_xattr_names,
+				ga->attrvalue_cookie, args.value,
+				ga->attrvaluelen);
+		if (error)
+			do_error(
+ _("loading garbage xattr value failed: %s\n"),
+					strerror(error));
+
+		error = -libxfs_attr_set(&args);
+		if (error)
+			do_error(
+ _("removing ino %llu garbage xattr failed: %s\n"),
+					(unsigned long long)ip->i_ino,
+					strerror(error));
+	}
+
+	free(buf);
+	free_slab_cursor(&cur);
+	free_slab(&fscan->garbage_xattr_recs);
+	xfblob_destroy(fscan->garbage_xattr_names);
+	fscan->garbage_xattr_names = NULL;
+}
+
 /* Schedule this ATTR_PARENT extended attribute for deletion. */
 static void
 record_garbage_xattr(
@@ -392,6 +487,15 @@ record_garbage_xattr(
 	const void		*value,
 	unsigned int		valuelen)
 {
+	struct garbage_xattr	garbage_xattr = {
+		.attr_filter	= attr_filter,
+		.attrnamelen	= namelen,
+		.attrvaluelen	= valuelen,
+	};
+	struct xfs_mount	*mp = ip->i_mount;
+	char			*descr;
+	int			error;
+
 	if (no_modify) {
 		if (!fscan->have_garbage)
 			do_warn(
@@ -402,13 +506,47 @@ record_garbage_xattr(
 	}
 
 	if (fscan->have_garbage)
-		return;
+		goto stuffit;
 	fscan->have_garbage = true;
 
 	do_warn(
  _("deleting garbage parent pointer extended attributes in ino %llu\n"),
 			(unsigned long long)ip->i_ino);
-	/* XXX do the work */
+
+	error = -init_slab(&fscan->garbage_xattr_recs,
+			sizeof(struct garbage_xattr));
+	if (error)
+		do_error(_("init garbage xattr recs failed: %s\n"),
+				strerror(error));
+
+	descr = kasprintf("xfs_repair (%s): garbage xattr names",
+			mp->m_fsname);
+	error = -xfblob_create(descr, &fscan->garbage_xattr_names);
+	kfree(descr);
+	if (error)
+		do_error("init garbage xattr names failed: %s\n",
+				strerror(error));
+
+stuffit:
+	error = -xfblob_store(fscan->garbage_xattr_names,
+			&garbage_xattr.attrname_cookie, name, namelen);
+	if (error)
+		do_error(_("storing ino %llu garbage xattr failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	error = -xfblob_store(fscan->garbage_xattr_names,
+			&garbage_xattr.attrvalue_cookie, value, valuelen);
+	if (error)
+		do_error(_("storing ino %llu garbage xattr failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
+
+	error = -slab_add(fscan->garbage_xattr_recs, &garbage_xattr);
+	if (error)
+		do_error(_("storing ino %llu garbage xattr rec failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
 }
 
 /*
@@ -931,6 +1069,9 @@ check_file_parent_ptrs(
 		goto out_free;
 	}
 
+	if (!no_modify && fscan->have_garbage)
+		remove_garbage_xattrs(ip, fscan);
+
 	crosscheck_file_parent_ptrs(ip, fscan);
 
 out_free:

