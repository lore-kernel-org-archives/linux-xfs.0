Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA270C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbjDFTlP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237338AbjDFTlO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:41:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B5D7AA6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:41:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A6FF60EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F18C433EF;
        Thu,  6 Apr 2023 19:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680810071;
        bh=S4KCYA/eeKX6+eurUd2K4fEOd0Dc/G90sxdYwxz6+kM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iWEnaaIIC44LmGY0JmosTCv0oplL3m02WA+BBpi+ssJsV1WLkdyYRFyUKShiFN92M
         zjlzrIRY3cjJZZur4au1i1Awt1zL/NbI4QHcHqfbBTsYJDBg4Lk21LuuMFnVt8QlmF
         L9CXqpkQd0/aBEADdREBUy3Wdlta95ZIT4fTqHc2+j526v3tOLdEGBNceTvKvhilAw
         2d6/0z43KpVRXdwT1eCDzEvuQuI/qWzB5M7H8+pMQLiugxNj0p2bkgnC8stzJWO/dz
         yFUAm4tn9CJ53Ajnm8y38NCc5lg+AyFcNW90z8MpE7M81c4d0WT06Vg+MCZWoHYQhg
         X7l259x29UI8w==
Date:   Thu, 06 Apr 2023 12:41:11 -0700
Subject: [PATCH 5/7] xfs_repair: dump garbage parent pointer attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080828325.617551.10344958690625878823.stgit@frogsfrogsfrogs>
In-Reply-To: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
References: <168080828258.617551.4008600376507330925.stgit@frogsfrogsfrogs>
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
 repair/pptr.c |  142 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 140 insertions(+), 2 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index 8aab94d74..8506405a1 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -191,6 +191,29 @@ struct file_scan {
 
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
@@ -375,6 +398,78 @@ add_parent_ptr(
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
@@ -386,6 +481,14 @@ record_garbage_xattr(
 	const void		*value,
 	unsigned int		valuelen)
 {
+	struct garbage_xattr	garbage_xattr = {
+		.attr_filter	= attr_filter,
+		.attrnamelen	= namelen,
+		.attrvaluelen	= valuelen,
+	};
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
 	if (no_modify) {
 		if (!fscan->have_garbage)
 			do_warn(
@@ -396,13 +499,45 @@ record_garbage_xattr(
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
@@ -922,6 +1057,9 @@ check_file_parent_ptrs(
 		goto out_free;
 	}
 
+	if (!no_modify && fscan->have_garbage)
+		remove_garbage_xattrs(ip, fscan);
+
 	crosscheck_file_parent_ptrs(ip, fscan);
 
 out_free:

