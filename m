Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672E9441
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883205; cv=none; b=GxoCyFcV5TQCOHoOowmImhoXPVD9pIaKiladLdDAn6Tpm+dfowx5ycO4mqRFGPSTnmYOYUG5RjTV+xqNKkPtHBInrvrnH+pIDLz7UtNeEH3bAVfqmOvrq0tkz9P1SXTs9y9tz9Q5RDSMKA2/l9gU7Cg85yv2x7sXShhc6zSOohw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883205; c=relaxed/simple;
	bh=2q0J+hoE8GFWQYfY0bryUKQ4yWyuGKJV5KJ8D1wVsuA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sdq1zgMqBW5IZQQHKgrhEnkf6R9v3d5mxl8Qq2LZ+xBWPCuApnb/zRCKgA/RdmEa/wH/KhRI42DVOiPr138HqJ5GxHr6hEuCfKtslEwj8Bb4V0qz7Okpe50qqahIGHutDyA9rs7fJ5at21VC6LWdRaHvyIGTZLA+Qn8wFrIDKkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TO3YeAlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TO3YeAlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298CFC116B1;
	Tue,  2 Jul 2024 01:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719883205;
	bh=2q0J+hoE8GFWQYfY0bryUKQ4yWyuGKJV5KJ8D1wVsuA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TO3YeAlWWfnY/pCxz4Uiv6pAvopKehwoW7LPNKHXRfLnlWNw5I0ENxvKE+eRFZ2kp
	 DkAQqL4WcONqbnnq6h7Ht9tGWj5Wx6zbKfTleMhqaAkG3Io2PtUqXb0hjJSn+a/mXG
	 mE7cgPlT9zqIUry5lplaPPwp7jpK5POap55qjApKIoFvqZqLXoUgdvDjLOgi8FNrDN
	 0jbjchH4foqxgqO8aZALyfXykogT5VogvOj3+qYrdzOTnT5oTLFCv88bAZ8dRx6dKG
	 qWMFtY7pGU3ElGRtZ6Tdc+48Qg29XztGCTAKG+DBV3KfhbAeucl6YWsl5cjkNQRHrw
	 8xHQdLGmUnoAg==
Date: Mon, 01 Jul 2024 18:20:04 -0700
Subject: [PATCH 10/12] xfs_repair: dump garbage parent pointer attributes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988122321.2010218.4681521171948051075.stgit@frogsfrogsfrogs>
In-Reply-To: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs>
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
 libxfs/libxfs_api_defs.h |    1 
 repair/pptr.c            |  149 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 148 insertions(+), 2 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d3611e05bade..e12f0a40b00a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -46,6 +46,7 @@
 #define xfs_attr_is_leaf		libxfs_attr_is_leaf
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 #define xfs_attr_namecheck		libxfs_attr_namecheck
+#define xfs_attr_removename		libxfs_attr_removename
 #define xfs_attr_set			libxfs_attr_set
 #define xfs_attr_sethash		libxfs_attr_sethash
 #define xfs_attr_sf_firstentry		libxfs_attr_sf_firstentry
diff --git a/repair/pptr.c b/repair/pptr.c
index bd9bb6f8bf36..61466009d88b 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -198,6 +198,29 @@ struct file_scan {
 
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
@@ -392,6 +415,82 @@ add_parent_ptr(
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
+			.owner		= ip->i_ino,
+			.geo		= ip->i_mount->m_attr_geo,
+			.whichfork	= XFS_ATTR_FORK,
+			.op_flags	= XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED,
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
+		libxfs_attr_sethash(&args);
+		error = -libxfs_attr_set(&args, XFS_ATTRUPDATE_REMOVE, true);
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
@@ -403,6 +502,15 @@ record_garbage_xattr(
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
@@ -413,13 +521,47 @@ record_garbage_xattr(
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
+	descr = kasprintf(GFP_KERNEL, "xfs_repair (%s): garbage xattr names",
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
@@ -968,6 +1110,9 @@ check_file_parent_ptrs(
 		goto out_free;
 	}
 
+	if (!no_modify && fscan->have_garbage)
+		remove_garbage_xattrs(ip, fscan);
+
 	crosscheck_file_parent_ptrs(ip, fscan);
 
 out_free:

