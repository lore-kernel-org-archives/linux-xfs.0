Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EE4C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjBPVAx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjBPVAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:00:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05B1505E5
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:00:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AE2CCE2BC8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C23DC433EF;
        Thu, 16 Feb 2023 21:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581248;
        bh=l6ozBx4os0zEJBk3YDZ1sivlG4DR1Z3n5PaD/KEF224=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=RFONiytu/BrnGAJky49aw6Q8QtQDGrp4xoSaysekPXoqSOqNm4WZVwx9SavlMQhlo
         oxFDhipL93TfLR1DISxT82o3VQqrr1A+cHahZi6Bt9Kw7I7FfZAuyJqLKp0vcU48jy
         iAcn9gZl+tddxk+RVmTbfvN/oLciwAlaKMFLVJ6i2aL5tzj72NfXWdmRCecQ8TLm79
         7T2k7nk1uD3TNOSSCh39XLb54bmJxx0oD7QjdDNqGwH/oYO3623XcZiTicQXEm2h0j
         OgGEg6iyuIdKN7mmL/ESoeM7xIh22zF6ULS+NxSV/fENz2TtfRn5x2X/RkExLvXnVs
         fel2kgh25YKDA==
Date:   Thu, 16 Feb 2023 13:00:48 -0800
Subject: [PATCH 3/6] xfs: move/add parent pointer validators to xfs_parent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879574.3476725.2132610983551662772.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
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
 libxfs/xfs_attr.c   |   61 +++++++++++----------------------------------------
 libxfs/xfs_attr.h   |    2 +-
 libxfs/xfs_parent.c |   44 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.h |    7 ++++++
 4 files changed, 65 insertions(+), 49 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 0cb76f8f..9afa0fef 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_parent.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -1575,62 +1576,26 @@ xfs_attr_node_get(
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 98576126..d6d23cf1 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -551,7 +551,7 @@ int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
 bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
-			int flags);
+		unsigned int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 47ea6b89..654eaec7 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -56,6 +56,50 @@ xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 13040b9d..4ffcb81d 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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

