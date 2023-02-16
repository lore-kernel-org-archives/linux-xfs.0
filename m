Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798B7C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBPUkd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPUkc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:40:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2171CF49
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:40:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A88FB829AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58FDC433EF;
        Thu, 16 Feb 2023 20:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580028;
        bh=5DS0NDOe3iIG075TKvvXgdPOR5zw49ao6Smz0XB3UwY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=akmveWpTTyqJ6wspB8kn/jd9tasMeFL3Ca2lp6EoSx/8s6A1su5geITu51yKA3ULn
         h0yShli7vK9HGd2ykOvW5kFsYEV48jPl61TNaOJ2Uj3KVPgPPJ8/rIvaCVaGjTjHhL
         iRKq9svJ+HVb+4qQmh8A4pVEUnLm/Utr8P6OLWWtTQKMWiyiqOES5rqYUmnhbm/Wnc
         X4GIGjBxjRhxYmW+kHjkHOOiFkTgYSHlXJmX13TptkoOrnBGz/Te5WBTzDlZDVPP1g
         xl13henXIbfaFzXti0FLszHPj+liHlt9sGZyq0svaDZUe9k6zFgTGOddG3GF65pXe+
         uCGnupl3CG54w==
Date:   Thu, 16 Feb 2023 12:40:28 -0800
Subject: [PATCH 2/3] xfs: move/add parent pointer validators to xfs_parent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657873121.3474076.2978424746322208247.stgit@magnolia>
In-Reply-To: <167657873091.3474076.6801004934386808232.stgit@magnolia>
References: <167657873091.3474076.6801004934386808232.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move the parent pointer xattr name validator to xfs_parent.c, and add a
new function to check the xattr value.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c   |   61 +++++++++-----------------------------------
 fs/xfs/libxfs/xfs_attr.h   |    2 +
 fs/xfs/libxfs/xfs_parent.c |   44 ++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h |    7 +++++
 4 files changed, 65 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 57080ea4c869..3065dd622102 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
 #include "xfs_xattr.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1577,62 +1578,26 @@ xfs_attr_node_get(
 	return error;
 }
 
-/*
- * Verify parent pointer attribute is valid.
- * Return true on success or false on failure
- */
-STATIC bool
-xfs_verify_pptr(
-	struct xfs_mount			*mp,
-	const struct xfs_parent_name_rec	*rec)
-{
-	xfs_ino_t				p_ino;
-	xfs_dir2_dataptr_t			p_diroffset;
-
-	p_ino = be64_to_cpu(rec->p_ino);
-	p_diroffset = be32_to_cpu(rec->p_diroffset);
-
-	if (!xfs_verify_ino(mp, p_ino))
-		return false;
-
-	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
-		return false;
-
-	return true;
-}
-
-/* Returns true if the string attribute entry name is valid. */
-static bool
-xfs_str_attr_namecheck(
-	const void	*name,
-	size_t		length)
-{
-	/*
-	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
-	 * out, so use >= for the length check.
-	 */
-	if (length >= MAXNAMELEN)
-		return false;
-
-	/* There shouldn't be any nulls here */
-	return !memchr(name, 0, length);
-}
-
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
 	struct xfs_mount	*mp,
 	const void		*name,
 	size_t			length,
-	int			flags)
+	unsigned int		flags)
 {
-	if (flags & XFS_ATTR_PARENT) {
-		if (length != sizeof(struct xfs_parent_name_rec))
-			return false;
-		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
-	}
+	if (flags & XFS_ATTR_PARENT)
+		return xfs_parent_namecheck(mp, name, length, flags);
 
-	return xfs_str_attr_namecheck(name, length);
+	/*
+	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
+	 * out, so use >= for the length check.
+	 */
+	if (length >= MAXNAMELEN)
+		return false;
+
+	/* There shouldn't be any nulls here */
+	return !memchr(name, 0, length);
 }
 
 int __init
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 985761264d1f..d6d23cf19ade 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -551,7 +551,7 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
-			int flags);
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 9176adfaa9e8..8cc264baf6c7 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -55,6 +55,50 @@ xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
  * occurring.
  */
 
+/* Return true if parent pointer EA name is valid. */
+bool
+xfs_parent_namecheck(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec,
+	size_t					reclen,
+	unsigned int				attr_flags)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	if (reclen != sizeof(struct xfs_parent_name_rec))
+		return false;
+
+	/* Only one namespace bit allowed. */
+	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		return false;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Return true if parent pointer EA value is valid. */
+bool
+xfs_parent_valuecheck(
+	struct xfs_mount		*mp,
+	const void			*value,
+	size_t				valuelen)
+{
+	if (valuelen == 0 || valuelen >= MAXNAMELEN)
+		return false;
+
+	if (value == NULL)
+		return false;
+
+	return true;
+}
 
 /* Initializes a xfs_parent_name_rec to be stored as an attribute name */
 void
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 13040b9d8b08..4ffcb81d399c 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -8,6 +8,13 @@
 
 extern struct kmem_cache	*xfs_parent_intent_cache;
 
+/* Metadata validators */
+bool xfs_parent_namecheck(struct xfs_mount *mp,
+		const struct xfs_parent_name_rec *rec, size_t reclen,
+		unsigned int attr_flags);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
+		size_t valuelen);
+
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
  * the defer ops machinery

