Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20F32C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjBPVKa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjBPVK3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:10:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54DF3B233
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:10:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5141E60C0D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF81AC433D2;
        Thu, 16 Feb 2023 21:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581827;
        bh=ycq5naSFWC8fEbYYk82YgIhMkm7FhUqOQsEMuy6hqXc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=JL1vgYMDdw81+4nDr8TJORfT4bqVEFVXD3K6l6PBHjGEEQZmReLAT3kn1ZMBI1A7w
         3y8ZaOSoaB3dRHaXRrq3bSEou3Fpkdyayvx3p2fsFI5zmMNYEW9nT1U2E+kXce5bVZ
         2O8pla/pdDb6syQbTG1nrjnQMXP+isd7nc0Q3tu+hbELi2gaMk/xRjVb6JpPDzlgsw
         Gx/SNWwpLq3qH/9ku8SiMEYDgixFiKjUTvnW1i9jH0T3ujU9GfIfl2uHnA/ueUQkUx
         KFGY4rv84QUcwJPB1SvSiwXaBW0tSxq0L+irJDZG/VMKg6vGghWh5IUangKtI9CeQx
         NIhfYlTfKIlYw==
Date:   Thu, 16 Feb 2023 13:10:27 -0800
Subject: [PATCH 8/8] xfs_repair: try to reuse nameblob names for file pptr
 scan names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882071.3477807.2425230947352621618.stgit@magnolia>
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

When we're scanning a file's parent pointers, see if the name already
exists in the nameblobs structure to save memory.  If not, we'll
continue to use the file scan xfblob, because we don't want to pollute
the nameblob structure with names we didn't see in the directory walk.

Each of the parent pointer scanner threads can access the nameblob
structure locklessly since they don't modify the nameblob.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/pptr.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 7 deletions(-)


diff --git a/repair/pptr.c b/repair/pptr.c
index c1cd9060..a5cf89b9 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -133,8 +133,11 @@ struct ag_pptr {
 };
 
 struct file_pptr {
+	/* Is the name stored in the global nameblobs structure? */
+	unsigned int		name_in_nameblobs:1;
+
 	/* parent directory handle */
-	xfs_ino_t		parent_ino;
+	unsigned long long	parent_ino:63;
 	unsigned int		parent_gen;
 
 	/* dirent offset */
@@ -467,6 +470,32 @@ record_garbage_xattr(
 				strerror(error));
 }
 
+/*
+ * Store this file parent pointer's name in the file scan namelist unless it's
+ * already in the global list.
+ */
+static int
+store_file_pptr_name(
+	struct file_scan			*fscan,
+	struct file_pptr			*file_pptr,
+	const struct xfs_parent_name_irec	*irec)
+{
+	int					error;
+
+	error = strblobs_lookup(nameblobs, &file_pptr->name_cookie,
+			irec->p_name, irec->p_namelen);
+	if (!error) {
+		file_pptr->name_in_nameblobs = true;
+		return 0;
+	}
+	if (error != ENOENT)
+		return error;
+
+	file_pptr->name_in_nameblobs = false;
+	return -xfblob_store(fscan->file_pptr_names, &file_pptr->name_cookie,
+			irec->p_name, irec->p_namelen);
+}
+
 /* Decide if this is a directory parent pointer and stash it if so. */
 static int
 examine_xattr(
@@ -505,8 +534,7 @@ examine_xattr(
 	file_pptr.diroffset = irec.p_diroffset;
 	file_pptr.namelen = irec.p_namelen;
 
-	error = -xfblob_store(fscan->file_pptr_names,
-			&file_pptr.name_cookie, irec.p_name, irec.p_namelen);
+	error = store_file_pptr_name(fscan, &file_pptr, &irec);
 	if (error)
 		do_error(
  _("storing ino %llu parent pointer '%.*s' failed: %s\n"),
@@ -568,6 +596,21 @@ remove_file_pptr(
 	return -libxfs_parent_unset(ip, &pptr_rec, &scratch);
 }
 
+/* Load a file parent pointer name from wherever we stored it. */
+static int
+load_file_pptr_name(
+	struct file_scan	*fscan,
+	const struct file_pptr	*file_pptr,
+	unsigned char		*name)
+{
+	if (file_pptr->name_in_nameblobs)
+		return strblobs_load(nameblobs, file_pptr->name_cookie,
+				name, file_pptr->namelen);
+
+	return -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
+			name, file_pptr->namelen);
+}
+
 /* Remove all pptrs from @ip. */
 static void
 clear_all_pptrs(
@@ -665,8 +708,7 @@ remove_incorrect_parent_ptr(
 	unsigned char		name[MAXNAMELEN] = { };
 	int			error;
 
-	error = -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
-			name, file_pptr->namelen);
+	error = load_file_pptr_name(fscan, file_pptr, name);
 	if (error)
 		do_error(
  _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx) failed: %s\n"),
@@ -729,8 +771,7 @@ compare_parent_pointers(
 				(unsigned long long)ag_pptr->name_cookie,
 				ag_pptr->namelen, strerror(error));
 
-	error = -xfblob_load(fscan->file_pptr_names, file_pptr->name_cookie,
-			name2, file_pptr->namelen);
+	error = load_file_pptr_name(fscan, file_pptr, name2);
 	if (error)
 		do_error(
  _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx namelen %u) failed: %s\n"),
@@ -1051,6 +1092,13 @@ check_parent_ptrs(
 	struct workqueue	wq;
 	xfs_agnumber_t		agno;
 
+	/*
+	 * We only store the lower 63 bits of the inode number in struct
+	 * file_pptr to save space, so we must guarantee that we'll never
+	 * encounter an inumber with the top bit set.
+	 */
+	BUILD_BUG_ON((1ULL << 63) & XFS_MAXINUMBER);
+
 	if (!xfs_has_parent(mp))
 		return;
 

