Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D4FC7EE2D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjCCRMd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbjCCRMc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AC630285
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:12:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C4DFB81992
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C7CC433D2;
        Fri,  3 Mar 2023 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863541;
        bh=YPf5vIXwMTWiRgfkV6w1FNaxOyyhR3eR/hj/qxkhZg0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jLMVWiW3p0QWii9LSvw3OHUR2RpWvAIL/itqdrOtU8kdEmTY1rPRLeDdFL058SD9i
         rICFFZSQ0uGbbkQkapRsgIUjK/HTmXivI2uVfYjUvGinZr+FaZg3XFIFUMxl4Sbkh/
         EGg+z9yNBddP9c+lbmVJOR1/yTvlfVesdZiFANritNCRd8EZt2jsds0oN8q3UNaj2S
         dJE/+X/yov7Cif8LP97W47r3bWLWT4h4AMysfY7Pr+gVVamblUUNslLwrn5GlCBiUN
         8UQ2lkZLdj78rutyb5PC1XnRpc9OqKNrQ4x4ZE77m1k2dD0YVVyI/4wTUjwfQ7iaXM
         AJ/dhxsJ/RQig==
Subject: [PATCH 11/13] xfs: use VLOOKUP mode to avoid hashing parent pointer
 names
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:12:20 -0800
Message-ID: <167786354052.1543331.13941648758151757902.stgit@magnolia>
In-Reply-To: <167786347827.1543331.2803518928321606576.stgit@magnolia>
References: <167786347827.1543331.2803518928321606576.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hashing the parent pointer name is fugly because no hashing function can
be collision proof.  Since we store as much of the dirent name as we can
in the xattr name and spill the rest to the xattr value, use VLOOKUP
mode so that we can match on name and value.  Then we can get rid of the
hashing stuff.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  |   34 ++--
 fs/xfs/libxfs/xfs_parent.c     |  303 +++++++++++++---------------------------
 fs/xfs/libxfs/xfs_parent.h     |   16 --
 fs/xfs/libxfs/xfs_trans_resv.c |    1 
 fs/xfs/scrub/dir.c             |   38 +----
 fs/xfs/scrub/parent.c          |   61 +-------
 fs/xfs/scrub/parent_repair.c   |   34 +---
 fs/xfs/xfs_ondisk.h            |    3 
 8 files changed, 136 insertions(+), 354 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 55f510f82e8d..dd569286b3be 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -824,22 +824,12 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
-/* We use sha512 for the parent pointer name hash. */
-#define XFS_PARENT_NAME_SHA512_SIZE	(64)
-
 /*
  * Parent pointer attribute format definition
  *
- * The EA name encodes the parent inode number, generation and a collision
- * resistant hash computed from the dirent name.  The hash is defined to be
- * one of the following:
- *
- * - The dirent name, as long as it does not use the last possible byte of the
- *   EA name space.
- *
- * - The truncated dirent name, with the sha512 hash of the child inode
- *   generation number and dirent name.  The hash is written at the end of the
- *   EA name.
+ * The EA name encodes the parent inode number, generation and as much of the
+ * dirent name as fits.  In other words, it contains up to 243 bytes of the
+ * dirent name.
  *
  * The EA value contains however much of the dirent name that does not fit in
  * the EA name.
@@ -847,30 +837,30 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 struct xfs_parent_name_rec {
 	__be64  p_ino;
 	__be32  p_gen;
-	__u8	p_namehash[];
+	__u8	p_dname[];
 } __attribute__((packed));
 
 /* Maximum size of a parent pointer EA name. */
 #define XFS_PARENT_NAME_MAX_SIZE \
 	(MAXNAMELEN - 1)
 
-/* Maximum size of a parent pointer name hash. */
-#define XFS_PARENT_NAME_MAX_HASH_SIZE \
+/* Maximum number of dirent name bytes stored in p_dname. */
+#define XFS_PARENT_MAX_DNAME_SIZE \
 	(XFS_PARENT_NAME_MAX_SIZE - sizeof(struct xfs_parent_name_rec))
 
-/* Offset of the sha512 hash, if used. */
-#define XFS_PARENT_NAME_SHA512_OFFSET \
-	(XFS_PARENT_NAME_MAX_HASH_SIZE - XFS_PARENT_NAME_SHA512_SIZE)
+/* Maximum number of dirent name bytes stored in the xattr value. */
+#define XFS_PARENT_MAX_DNAME_VALUELEN \
+	sizeof(struct xfs_parent_name_rec)
 
 static inline unsigned int
 xfs_parent_name_rec_sizeof(
-	unsigned int		hashlen)
+	unsigned int		dnamelen)
 {
-	return sizeof(struct xfs_parent_name_rec) + hashlen;
+	return sizeof(struct xfs_parent_name_rec) + dnamelen;
 }
 
 static inline unsigned int
-xfs_parent_name_hashlen(
+xfs_parent_name_dnamelen(
 	unsigned int		rec_sizeof)
 {
 	return rec_sizeof - sizeof(struct xfs_parent_name_rec);
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 387f3c65287f..af412ebe65a4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -26,7 +26,6 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
-#include "xfs_sha512.h"
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
@@ -56,8 +55,11 @@ xfs_parent_namecheck(
 {
 	xfs_ino_t				p_ino;
 
-	if (reclen <= xfs_parent_name_rec_sizeof(0) ||
-	    reclen > xfs_parent_name_rec_sizeof(XFS_PARENT_NAME_MAX_HASH_SIZE))
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return false;
+
+	if (reclen <= sizeof(struct xfs_parent_name_rec) ||
+	    reclen > XFS_PARENT_NAME_MAX_SIZE)
 		return false;
 
 	/* Only one namespace bit allowed. */
@@ -86,7 +88,7 @@ xfs_parent_valuecheck(
 		return false;
 
 	if (namelen == XFS_PARENT_NAME_MAX_SIZE &&
-	    valuelen >= MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET)
+	    valuelen > XFS_PARENT_MAX_DNAME_VALUELEN)
 		return false;
 
 	if (value == NULL)
@@ -95,7 +97,10 @@ xfs_parent_valuecheck(
 	return true;
 }
 
-/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
+/*
+ * Initializes a xfs_parent_name_rec to be stored as an attribute name.
+ * Returns the number of name bytes stored in p_dname.
+ */
 static inline int
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
@@ -103,23 +108,14 @@ xfs_init_parent_name_rec(
 	const struct xfs_name		*name,
 	struct xfs_inode		*ip)
 {
+	int				dnamelen;
+
 	rec->p_ino = cpu_to_be64(dp->i_ino);
 	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
-	return xfs_parent_namehash(ip, name, rec->p_namehash,
-			XFS_PARENT_NAME_MAX_HASH_SIZE);
-}
 
-/* Compute the number of name bytes that can be encoded in the namehash. */
-static inline unsigned int
-xfs_parent_valuelen_adj(
-	int			hashlen)
-{
-	ASSERT(hashlen > 0);
-
-	if (hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
-		return XFS_PARENT_NAME_SHA512_OFFSET;
-
-	return hashlen;
+	dnamelen = min_t(int, name->len, XFS_PARENT_MAX_DNAME_SIZE);
+	memcpy(rec->p_dname, name->name, dnamelen);
+	return dnamelen;
 }
 
 /*
@@ -134,48 +130,30 @@ xfs_parent_irec_from_disk(
 	const void			*value,
 	int				valuelen)
 {
+	int				dnamelen;
+
 	irec->p_ino = be64_to_cpu(rec->p_ino);
 	irec->p_gen = be32_to_cpu(rec->p_gen);
-	irec->hashlen = xfs_parent_name_hashlen(reclen);
-	memcpy(irec->p_namehash, rec->p_namehash, irec->hashlen);
-	memset(irec->p_namehash + irec->hashlen, 0,
-			sizeof(irec->p_namehash) - irec->hashlen);
 
 	if (!value) {
 		irec->p_namelen = 0;
 		return;
 	}
 
-	ASSERT(valuelen < MAXNAMELEN);
+	ASSERT(valuelen <= XFS_PARENT_MAX_DNAME_VALUELEN);
 
-	if (irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE) {
-		ASSERT(valuelen > 0);
-		ASSERT(valuelen <= MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET);
-
-		valuelen = min_t(int, valuelen,
-				MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET);
-
-		memcpy(irec->p_name, irec->p_namehash,
-				XFS_PARENT_NAME_SHA512_OFFSET);
-		memcpy(&irec->p_name[XFS_PARENT_NAME_SHA512_OFFSET],
-				value, valuelen);
-		irec->p_namelen = XFS_PARENT_NAME_SHA512_OFFSET + valuelen;
-	} else {
-		ASSERT(valuelen == 0);
-
-		memcpy(irec->p_name, irec->p_namehash, irec->hashlen);
-		irec->p_namelen = irec->hashlen;
-	}
-
-	memset(&irec->p_name[irec->p_namelen], 0,
-			sizeof(irec->p_name) - irec->p_namelen);
+	dnamelen = xfs_parent_name_dnamelen(reclen);
+	irec->p_namelen = dnamelen + valuelen;
+	memcpy(irec->p_name, rec->p_dname, dnamelen);
+	if (valuelen > 0)
+		memcpy(irec->p_name + dnamelen, value, valuelen);
 }
 
 /*
- * Convert an incore parent_name record to its ondisk format.  If @value or
- * @valuelen are NULL, they will not be written to.
+ * Convert an incore parent_name record to its ondisk format.  If @valuelen is
+ * NULL, neither it nor @value will be written to.
  */
-void
+int
 xfs_parent_irec_to_disk(
 	struct xfs_parent_name_rec	*rec,
 	int				*reclen,
@@ -183,25 +161,23 @@ xfs_parent_irec_to_disk(
 	int				*valuelen,
 	const struct xfs_parent_name_irec *irec)
 {
+	int				dnamelen;
+
 	rec->p_ino = cpu_to_be64(irec->p_ino);
 	rec->p_gen = cpu_to_be32(irec->p_gen);
-	*reclen = xfs_parent_name_rec_sizeof(irec->hashlen);
-	memcpy(rec->p_namehash, irec->p_namehash, irec->hashlen);
+	dnamelen = min_t(int, irec->p_namelen, XFS_PARENT_MAX_DNAME_SIZE);
+	*reclen = xfs_parent_name_rec_sizeof(dnamelen);
+	memcpy(rec->p_dname, irec->p_name, dnamelen);
 
-	if (valuelen) {
-		ASSERT(*valuelen > 0);
-		ASSERT(*valuelen >= irec->p_namelen);
-		ASSERT(*valuelen < MAXNAMELEN);
+	if (!valuelen)
+		return dnamelen;
 
-		if (irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
-			*valuelen = irec->p_namelen - XFS_PARENT_NAME_SHA512_OFFSET;
-		else
-			*valuelen = 0;
-	}
+	*valuelen = irec->p_namelen - dnamelen;
+	if (*valuelen)
+		memcpy(value, rec->p_dname + XFS_PARENT_MAX_DNAME_SIZE,
+				*valuelen);
 
-	if (value && irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
-		memcpy(value, irec->p_name + XFS_PARENT_NAME_SHA512_OFFSET,
-			      irec->p_namelen - XFS_PARENT_NAME_SHA512_OFFSET);
+	return dnamelen;
 }
 
 /*
@@ -235,7 +211,8 @@ __xfs_parent_init(
 	parent->args.geo = mp->m_attr_geo;
 	parent->args.whichfork = XFS_ATTR_FORK;
 	parent->args.attr_filter = XFS_ATTR_PARENT;
-	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED |
+				XFS_DA_OP_VLOOKUP;
 	parent->args.name = (const uint8_t *)&parent->rec;
 	parent->args.namelen = 0;
 
@@ -253,25 +230,22 @@ xfs_parent_add(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
-	int			hashlen;
-	unsigned int		name_adj;
+	int			dnamelen;
 
-	hashlen = xfs_init_parent_name_rec(&parent->rec, dp, parent_name,
+	dnamelen = xfs_init_parent_name_rec(&parent->rec, dp, parent_name,
 			child);
-	if (hashlen < 0)
-		return hashlen;
 
-	args->namelen = xfs_parent_name_rec_sizeof(hashlen);
+	args->namelen = xfs_parent_name_rec_sizeof(dnamelen);
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
-	name_adj = xfs_parent_valuelen_adj(hashlen);
-
 	args->trans = tp;
 	args->dp = child;
-	if (parent_name) {
-		parent->args.value = (void *)parent_name->name + name_adj;
-		parent->args.valuelen = parent_name->len - name_adj;
-	}
+
+	parent->args.valuelen = parent_name->len - dnamelen;
+	if (parent->args.valuelen > 0)
+		parent->args.value = (void *)parent_name->name + dnamelen;
+	else
+		parent->args.value = NULL;
 
 	return xfs_attr_defer_add(args);
 }
@@ -286,16 +260,21 @@ xfs_parent_remove(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
-	int			hashlen;
+	int			dnamelen;
 
-	hashlen = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
-	if (hashlen < 0)
-		return hashlen;
+	dnamelen = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
 
-	args->namelen = xfs_parent_name_rec_sizeof(hashlen);
+	args->namelen = xfs_parent_name_rec_sizeof(dnamelen);
 	args->trans = tp;
 	args->dp = child;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+
+	parent->args.valuelen = name->len - dnamelen;
+	if (parent->args.valuelen > 0)
+		parent->args.value = (void *)name->name + dnamelen;
+	else
+		parent->args.value = NULL;
+
 	return xfs_attr_defer_remove(args);
 }
 
@@ -311,29 +290,31 @@ xfs_parent_replace(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &new_parent->args;
-	int			old_hashlen, new_hashlen;
-	int			new_name_adj;
+	int			old_dnamelen, new_dnamelen;
 
-	old_hashlen = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
+	old_dnamelen = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
 			old_name, child);
-	if (old_hashlen < 0)
-		return old_hashlen;
-	new_hashlen = xfs_init_parent_name_rec(&new_parent->rec, new_dp,
+	new_dnamelen = xfs_init_parent_name_rec(&new_parent->rec, new_dp,
 			new_name, child);
-	if (new_hashlen < 0)
-		return new_hashlen;
-
-	new_name_adj = xfs_parent_valuelen_adj(new_hashlen);
 
 	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
-	new_parent->args.namelen = xfs_parent_name_rec_sizeof(old_hashlen);
+	new_parent->args.namelen = xfs_parent_name_rec_sizeof(old_dnamelen);
 	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
-	new_parent->args.new_namelen = xfs_parent_name_rec_sizeof(new_hashlen);
+	new_parent->args.new_namelen = xfs_parent_name_rec_sizeof(new_dnamelen);
 	args->trans = tp;
 	args->dp = child;
 
-	new_parent->args.value = (void *)new_name->name + new_name_adj;
-	new_parent->args.valuelen = new_name->len - new_name_adj;
+	new_parent->args.new_valuelen = new_name->len - new_dnamelen;
+	if (new_parent->args.new_valuelen > 0)
+		new_parent->args.new_value = (void *)new_name->name + new_dnamelen;
+	else
+		new_parent->args.new_value = NULL;
+
+	new_parent->args.valuelen = old_name->len - old_dnamelen;
+	if (new_parent->args.valuelen > 0)
+		new_parent->args.value = (void *)old_name->name + old_dnamelen;
+	else
+		new_parent->args.value = NULL;
 
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return xfs_attr_defer_replace(args);
@@ -363,26 +344,22 @@ xfs_pptr_calc_space_res(
 }
 
 /*
- * Look up the @name associated with the parent pointer (@pptr) of @ip.  Caller
- * must hold at least ILOCK_SHARED.  Returns the length of the dirent name, or
- * a negative errno.  The scratchpad need not be initialized.
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.
+ * Caller must hold at least ILOCK_SHARED.  Returns 0 if the pointer is found,
+ * -ENOATTR if there is no match, or a negative errno.  The scratchpad need not
+ *  be initialized.
  */
 int
 xfs_parent_lookup(
 	struct xfs_trans		*tp,
 	struct xfs_inode		*ip,
 	const struct xfs_parent_name_irec *pptr,
-	unsigned char			*name,
-	unsigned int			namelen,
 	struct xfs_parent_scratch	*scr)
 {
+	int				dnamelen;
 	int				reclen;
-	int				name_adj;
-	int				error;
 
-	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
-
-	name_adj = xfs_parent_valuelen_adj(pptr->hashlen);
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
@@ -390,20 +367,17 @@ xfs_parent_lookup(
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
 	scr->args.namelen	= reclen;
-	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
+	scr->args.op_flags	= XFS_DA_OP_OKNOENT | XFS_DA_OP_VLOOKUP;
 	scr->args.trans		= tp;
-	scr->args.valuelen	= namelen - name_adj;
-	scr->args.value		= name + name_adj;
+	scr->args.valuelen	= pptr->p_namelen - dnamelen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
+	if (scr->args.valuelen)
+		scr->args.value	= (void *)pptr->p_name + dnamelen;
+
 	scr->args.hashval = xfs_da_hashname(scr->args.name, scr->args.namelen);
 
-	error = xfs_attr_get_ilocked(&scr->args);
-	if (error)
-		return error;
-
-	memcpy(name, pptr->p_namehash, name_adj);
-	return scr->args.valuelen + name_adj;
+	return xfs_attr_get_ilocked(&scr->args);
 }
 
 /*
@@ -418,12 +392,10 @@ xfs_parent_set(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
+	int				dnamelen;
 	int				reclen;
-	int				name_adj;
 
-	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
-
-	name_adj = xfs_parent_valuelen_adj(pptr->hashlen);
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
@@ -431,10 +403,13 @@ xfs_parent_set(
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
 	scr->args.namelen	= reclen;
-	scr->args.valuelen	= pptr->p_namelen - name_adj;
-	scr->args.value		= (void *)pptr->p_name + name_adj;
+	scr->args.op_flags	= XFS_DA_OP_VLOOKUP;
+	scr->args.valuelen	= pptr->p_namelen - dnamelen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
+	if (scr->args.valuelen)
+		scr->args.value	= (void *)pptr->p_name + dnamelen;
+
 	return xfs_attr_set(&scr->args);
 }
 
@@ -450,9 +425,10 @@ xfs_parent_unset(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
+	int				dnamelen;
 	int				reclen;
 
-	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
@@ -460,89 +436,12 @@ xfs_parent_unset(
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
 	scr->args.namelen	= reclen;
-	scr->args.op_flags	= XFS_DA_OP_REMOVE;
+	scr->args.op_flags	= XFS_DA_OP_REMOVE | XFS_DA_OP_VLOOKUP;
+	scr->args.valuelen	= pptr->p_namelen - dnamelen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
+	if (scr->args.valuelen)
+		scr->args.value	= (void *)pptr->p_name + dnamelen;
+
 	return xfs_attr_set(&scr->args);
 }
-
-/*
- * Compute the parent pointer namehash for the given child file and dirent
- * name.  Returns the length of the hash in bytes, or a negative errno.
- */
-int
-xfs_parent_namehash(
-	struct xfs_inode	*ip,
-	const struct xfs_name	*name,
-	void			*namehash,
-	unsigned int		namehash_len)
-{
-	SHA512_DESC_ON_STACK(ip->i_mount, shash);
-	__be32			gen = cpu_to_be32(VFS_I(ip)->i_generation);
-	int			error;
-
-	ASSERT(SHA512_DIGEST_SIZE ==
-			crypto_shash_digestsize(ip->i_mount->m_sha512));
-
-	if (namehash_len != XFS_PARENT_NAME_MAX_HASH_SIZE) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-
-	if (name->len < XFS_PARENT_NAME_MAX_HASH_SIZE) {
-		/*
-		 * If the dirent name is shorter than the size of the namehash
-		 * field, write it directly into the namehash field.
-		 */
-		memcpy(namehash, name->name, name->len);
-		memset(namehash + name->len, 0, namehash_len - name->len);
-		return name->len;
-	}
-
-	error = sha512_init(&shash);
-	if (error)
-		goto out;
-
-	error = sha512_process(&shash, (const u8 *)&gen, sizeof(gen));
-	if (error)
-		goto out;
-
-	error = sha512_process(&shash, name->name, name->len);
-	if (error)
-		goto out;
-
-	/*
-	 * The sha512 hash of the child gen and dirent name is placed at the
-	 * end of the namehash, and as many bytes as will fit are copied from
-	 * the dirent name to the start of the namehash.
-	 */
-	error = sha512_done(&shash, namehash + XFS_PARENT_NAME_SHA512_OFFSET);
-	if (error)
-		goto out;
-
-	memcpy(namehash, name->name, XFS_PARENT_NAME_SHA512_OFFSET);
-	error = XFS_PARENT_NAME_MAX_HASH_SIZE;
-out:
-	sha512_erase(&shash);
-	return error;
-}
-
-/* Recalculate the name hash of this parent pointer. */
-int
-xfs_parent_irec_hash(
-	struct xfs_inode		*ip,
-	struct xfs_parent_name_irec	*pptr)
-{
-	struct xfs_name			xname = {
-		.name			= pptr->p_name,
-		.len			= pptr->p_namelen,
-	};
-	int				hashlen;
-
-	hashlen = xfs_parent_namehash(ip, &xname, &pptr->p_namehash,
-			sizeof(pptr->p_namehash));
-	if (hashlen < 0)
-		return hashlen;
-	pptr->hashlen = hashlen;
-	return 0;
-}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6f6136165efe..0b3e0b94d6cb 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,10 +23,6 @@ struct xfs_parent_name_irec {
 	/* Key fields for looking up a particular parent pointer. */
 	xfs_ino_t		p_ino;
 	uint32_t		p_gen;
-	uint8_t			hashlen;
-	uint8_t			p_namehash[XFS_PARENT_NAME_MAX_HASH_SIZE];
-
-	/* Attributes of a parent pointer. */
 	uint8_t			p_namelen;
 	unsigned char		p_name[MAXNAMELEN];
 };
@@ -34,7 +30,7 @@ struct xfs_parent_name_irec {
 void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
 		const struct xfs_parent_name_rec *rec, int reclen,
 		const void *value, int valuelen);
-void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
+int xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
 		void *value, int *valuelen,
 		const struct xfs_parent_name_irec *irec);
 
@@ -107,12 +103,6 @@ xfs_parent_finish(
 		__xfs_parent_cancel(mp, p);
 }
 
-int xfs_parent_namehash(struct xfs_inode *ip, const struct xfs_name *name,
-		void *namehash, unsigned int namehash_len);
-
-int xfs_parent_irec_hash(struct xfs_inode *ip,
-		struct xfs_parent_name_irec *pptr);
-
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
 
@@ -126,8 +116,8 @@ struct xfs_parent_scratch {
 };
 
 int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
-		const struct xfs_parent_name_irec *pptr, unsigned char *name,
-		unsigned int namelen, struct xfs_parent_scratch *scratch);
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
 
 int xfs_parent_set(struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 0e625c6b0153..a8afe2333194 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -439,6 +439,7 @@ static inline unsigned int xfs_calc_pptr_replace_overhead(void)
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE) +
 			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 87cff40b15f1..23cb7519c8f0 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -78,7 +78,7 @@ struct xchk_dir {
 	/* If we've cycled the ILOCK, we must revalidate deferred dirents. */
 	bool			need_revalidate;
 
-	/* Name buffer for pptr validation and dirent revalidation. */
+	/* Name buffer for dirent revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
 
 };
@@ -143,42 +143,16 @@ xchk_dir_parent_pointer(
 	struct xfs_inode	*ip)
 {
 	struct xfs_scrub	*sc = sd->sc;
-	int			pptr_namelen;
-	int			hashlen;
+	int			error;
 
 	sd->pptr.p_ino = sc->ip->i_ino;
 	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
+	sd->pptr.p_namelen = name->len;
+	memcpy(sd->pptr.p_name, name->name, name->len);
 
-	hashlen = xfs_parent_namehash(ip, name, &sd->pptr.p_namehash,
-			sizeof(sd->pptr.p_namehash));
-	if (hashlen < 0) {
-		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
-				&hashlen);
-		return hashlen;
-	}
-	sd->pptr.hashlen = hashlen;
-
-	pptr_namelen = xfs_parent_lookup(sc->tp, ip, &sd->pptr, sd->namebuf,
-			MAXNAMELEN, &sd->pptr_scratch);
-	if (pptr_namelen == -ENOATTR) {
-		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
-	}
-	if (pptr_namelen < 0) {
-		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
-				&pptr_namelen);
-		return pptr_namelen;
-	}
-
-	if (pptr_namelen != name->len) {
-		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
-	}
-
-	if (memcmp(sd->namebuf, name->name, name->len)) {
+	error = xfs_parent_lookup(sc->tp, ip, &sd->pptr, &sd->pptr_scratch);
+	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
-	}
 
 	return 0;
 }
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index f3b1d7cbe415..fbe6fb709e2e 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -348,12 +348,6 @@ struct xchk_pptrs {
 
 	/* xattr key and da args for parent pointer revalidation. */
 	struct xfs_parent_scratch pptr_scratch;
-
-	/* Name hashes */
-	uint8_t			child_namehash[XFS_PARENT_NAME_MAX_HASH_SIZE];
-
-	/* Name buffer for revalidation. */
-	uint8_t			namebuf[MAXNAMELEN];
 };
 
 /* Look up the dotdot entry so that we can check it as we walk the pptrs. */
@@ -526,12 +520,10 @@ xchk_parent_scan_attr(
 	unsigned int		valuelen,
 	void			*priv)
 {
-	struct xfs_name		xname = { };
 	struct xchk_pptrs	*pp = priv;
 	struct xfs_inode	*dp = NULL;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
 	unsigned int		lockmode;
-	int			hashlen;
 	int			error;
 
 	/* Ignore incomplete xattrs */
@@ -555,29 +547,6 @@ xchk_parent_scan_attr(
 
 	xfs_parent_irec_from_disk(&pp->pptr, rec, namelen, value, valuelen);
 
-	xname.name = pp->pptr.p_name;
-	xname.len = pp->pptr.p_namelen;
-
-	/*
-	 * Does the namehash in the parent pointer match the actual name?
-	 * If not, there's no point in checking further.
-	 */
-	hashlen = xfs_parent_namehash(sc->ip, &xname, pp->child_namehash,
-			sizeof(pp->child_namehash));
-	if (hashlen < 0) {
-		xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &hashlen);
-		return hashlen;
-	}
-
-	if (hashlen != pp->pptr.hashlen ||
-	    memcmp(pp->pptr.p_namehash, pp->child_namehash,
-				pp->pptr.hashlen)) {
-		trace_xchk_parent_bad_namehash(sc->ip, pp->pptr.p_ino,
-				xname.name, xname.len);
-		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return 0;
-	}
-
 	error = xchk_parent_iget(pp, &dp);
 	if (error)
 		return error;
@@ -630,28 +599,16 @@ xchk_parent_revalidate_pptr(
 	struct xchk_pptrs	*pp)
 {
 	struct xfs_scrub	*sc = pp->sc;
-	int			namelen;
+	int			error;
 
-	namelen = xfs_parent_lookup(sc->tp, sc->ip, &pp->pptr, pp->namebuf,
-			MAXNAMELEN, &pp->pptr_scratch);
-	if (namelen == -ENOATTR) {
-		/*  Parent pointer went away, nothing to revalidate. */
+	error = xfs_parent_lookup(sc->tp, sc->ip, &pp->pptr,
+			&pp->pptr_scratch);
+	if (error == -ENOATTR) {
+		/* Parent pointer went away, nothing to revalidate. */
 		return -ENOENT;
 	}
-	if (namelen < 0 && namelen != -EEXIST)
-		return namelen;
 
-	/*
-	 * The dirent name changed length while we were unlocked.  No need
-	 * to revalidate this.
-	 */
-	if (namelen != pp->pptr.p_namelen)
-		return -ENOENT;
-
-	/* The dirent name itself changed; there's nothing to revalidate. */
-	if (memcmp(pp->namebuf, pp->pptr.p_name, pp->pptr.p_namelen))
-		return -ENOENT;
-	return 0;
+	return error;
 }
 
 /*
@@ -679,10 +636,6 @@ xchk_parent_slow_pptr(
 	pp->pptr.p_name[MAXNAMELEN - 1] = 0;
 	pp->pptr.p_namelen = pptr->namelen;
 
-	error = xfs_parent_irec_hash(sc->ip, &pp->pptr);
-	if (error)
-		return error;
-
 	/* Check that the deferred parent pointer still exists. */
 	if (pp->need_revalidate) {
 		error = xchk_parent_revalidate_pptr(pp);
@@ -714,7 +667,7 @@ xchk_parent_slow_pptr(
 	xchk_iunlock(sc, sc->ilock_flags);
 	pp->need_revalidate = true;
 
-	trace_xchk_parent_slowpath(sc->ip, pp->namebuf, pptr->namelen,
+	trace_xchk_parent_slowpath(sc->ip, pp->pptr.p_name, pptr->namelen,
 			dp->i_ino);
 
 	while (true) {
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 14647e3da8c1..b55ef1506dd2 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -126,9 +126,6 @@ struct xrep_pptrs {
 
 	/* Parent pointer names. */
 	struct xfblob		*pptr_names;
-
-	/* Buffer for validation. */
-	unsigned char		namebuf[MAXNAMELEN];
 };
 
 /* Tear down all the incore stuff we created. */
@@ -182,16 +179,11 @@ xrep_pptr_replay_update(
 	const struct xrep_pptr	*pptr)
 {
 	struct xfs_scrub	*sc = rp->sc;
-	int			error;
 
 	rp->pptr.p_ino = pptr->p_ino;
 	rp->pptr.p_gen = pptr->p_gen;
 	rp->pptr.p_namelen = pptr->namelen;
 
-	error = xfs_parent_irec_hash(sc->ip, &rp->pptr);
-	if (error)
-		return error;
-
 	if (pptr->action == XREP_PPTR_ADD) {
 		/* Create parent pointer. */
 		trace_xrep_pptr_createname(sc->tempip, &rp->pptr);
@@ -510,7 +502,7 @@ xrep_pptr_dump_tempptr(
 	struct xrep_pptrs	*rp = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
 	struct xfs_inode	*other_ip;
-	int			pptr_namelen;
+	int			error;
 
 	if (!(attr_flags & XFS_ATTR_PARENT))
 		return 0;
@@ -526,29 +518,15 @@ xrep_pptr_dump_tempptr(
 
 	trace_xrep_pptr_dumpname(sc->tempip, &rp->pptr);
 
-	pptr_namelen = xfs_parent_lookup(sc->tp, other_ip, &rp->pptr,
-			rp->namebuf, MAXNAMELEN, &rp->pptr_scratch);
-	if (pptr_namelen == -ENOATTR) {
+	error = xfs_parent_lookup(sc->tp, other_ip, &rp->pptr,
+			&rp->pptr_scratch);
+	if (error == -ENOATTR) {
 		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
-		ASSERT(pptr_namelen != -ENOATTR);
+		ASSERT(error != -ENOATTR);
 		return -EFSCORRUPTED;
 	}
-	if (pptr_namelen < 0)
-		return pptr_namelen;
 
-	if (pptr_namelen != rp->pptr.p_namelen) {
-		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
-		ASSERT(pptr_namelen == rp->pptr.p_namelen);
-		return -EFSCORRUPTED;
-	}
-
-	if (memcmp(rp->namebuf, rp->pptr.p_name, rp->pptr.p_namelen)) {
-		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-
-	return 0;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index b7f29b4acac3..a78a3077b41a 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -117,9 +117,6 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	12);
-	BUILD_BUG_ON(XFS_PARENT_NAME_MAX_HASH_SIZE < SHA512_DIGEST_SIZE);
-	BUILD_BUG_ON(XFS_PARENT_NAME_MAX_HASH_SIZE !=           243);
-	BUILD_BUG_ON(XFS_PARENT_NAME_SHA512_OFFSET !=           179);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

