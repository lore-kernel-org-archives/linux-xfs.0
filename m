Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63733C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjBPVJQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjBPVJO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B833A528AE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 521B860A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26D2C433EF;
        Thu, 16 Feb 2023 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581749;
        bh=kgUZXWN6Fg1ay1mmf46HAskb5uQXTRxNALfhqD8J3Z4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=duMQ/Ac+NNgJWc7dAcBHysK2W0rGH3uY/Gja3Nv/CBqqZJFwW6PH0X4mX+f/Jhlj5
         aImbhObwnbZ7b2vl9S7jE/Ps0HaDC9KjiRNZCApHbQED8Cbsy/ZA2uKXuRTkB7RGDY
         3vZf/eDetWY0phXdK2qt7Wu3SaoTgrg1/tAnI+xNCVmB2efMEUDjvAcObPK6+NZEUo
         Y62L8dxV4Wqhj4LsdKVuf4ZlCm3fGRaCODsA6HI51pz4eoLOfcQc+RyiidSsE7s7Ob
         KllJfs+rksICikVyQd/MwrWnCgMK/R605ul1gYoml8rGvRog7QDd8QCVo7ZYVLFIdQ
         Dr6fRoDhgIASg==
Date:   Thu, 16 Feb 2023 13:09:09 -0800
Subject: [PATCH 3/8] xfs_repair: dump garbage parent pointer attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882005.3477807.6914142822313284703.stgit@magnolia>
In-Reply-To: <167657881963.3477807.5005383731904631094.stgit@magnolia>
References: <167657881963.3477807.5005383731904631094.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Delete xattrs that have ATTR_PARENT set but are so garbage that they
clearly aren't parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 3 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index d1e7f5ee..695177ce 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -174,6 +174,23 @@ struct file_scan {
 
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
+	/* cookie for the attribute name */
+	xfblob_cookie		attrname_cookie;
 };
 
 /* Global names storage file. */
@@ -330,7 +347,63 @@ add_parent_ptr(
 			(unsigned long long)ag_pptr.name_cookie);
 }
 
-/* Schedule this extended attribute for deletion. */
+/* Remove garbage extended attributes that have ATTR_PARENT set. */
+static void
+remove_garbage_xattrs(
+	struct xfs_inode	*ip,
+	struct file_scan	*fscan)
+{
+	struct xfs_slab_cursor	*cur;
+	struct garbage_xattr	*ga;
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
+		};
+		void			*buf;
+
+		buf = malloc(ga->attrnamelen);
+		if (!buf)
+			do_error(
+ _("allocating %u bytes to remove ino %llu garbage xattr failed: %s\n"),
+					ga->attrnamelen,
+					(unsigned long long)ip->i_ino,
+					strerror(errno));
+
+		error = -xfblob_load(fscan->garbage_xattr_names,
+				ga->attrname_cookie, buf, ga->attrnamelen);
+		if (error)
+			do_error(
+ _("loading garbage xattr name failed: %s\n"),
+					strerror(error));
+
+		args.name = buf;
+		error = -libxfs_attr_set(&args);
+		if (error)
+			do_error(
+ _("removing ino %llu garbage xattr failed: %s\n"),
+					(unsigned long long)ip->i_ino,
+					strerror(error));
+
+		free(buf);
+	}
+
+	free_slab_cursor(&cur);
+
+	free_slab(&fscan->garbage_xattr_recs);
+	xfblob_destroy(fscan->garbage_xattr_names);
+	fscan->garbage_xattr_names = NULL;
+}
+
+/* Schedule this ATTR_PARENT extended attribute for deletion. */
 static void
 record_garbage_xattr(
 	struct xfs_inode	*ip,
@@ -339,6 +412,13 @@ record_garbage_xattr(
 	const void		*name,
 	unsigned int		namelen)
 {
+	struct garbage_xattr	garbage_xattr = {
+		.attr_filter	= attr_filter,
+		.attrnamelen	= namelen,
+	};
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
 	if (no_modify) {
 		if (!fscan->have_garbage)
 			do_warn(
@@ -349,13 +429,38 @@ record_garbage_xattr(
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
+	error = -xfblob_create(mp, "garbage xattr names",
+			&fscan->garbage_xattr_names);
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
+	error = -slab_add(fscan->garbage_xattr_recs, &garbage_xattr);
+	if (error)
+		do_error(_("storing ino %llu garbage xattr rec failed: %s\n"),
+				(unsigned long long)ip->i_ino,
+				strerror(error));
 }
 
 /* Decide if this is a directory parent pointer and stash it if so. */
@@ -763,6 +868,9 @@ check_file_parent_ptrs(
 		goto out_free;
 	}
 
+	if (!no_modify && fscan->have_garbage)
+		remove_garbage_xattrs(ip, fscan);
+
 	crosscheck_file_parent_ptrs(ip, fscan);
 
 out_free:

