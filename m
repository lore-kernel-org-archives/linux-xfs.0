Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B537AC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBPUwu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBPUwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F64B53D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:52:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 030FBB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FF5C433D2;
        Thu, 16 Feb 2023 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580764;
        bh=NY6Z/LF5ttDWJLpQfZDfqpBwKiZKHvqnONySXsGAFxg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jEKIm4KacnQg/7YO3efIo/6vbkLGNXiSRLIn2elzW7bPoaEszMre6+PERu3BlDNKD
         w1+QZ91S5dJ88KqT2l32YkvEvrwEZzzaWKY7qTdGz5Z863a/1wQzXC8czYINt4MyXl
         3branEVpnaUUn9PtMLE/qBuXMMy8jLz/TSF5pWyZkltnmgnVIghlDPDahqi6ZLvCJX
         kpKV890gSv9NBiV22lyVMeHva58ho1Re8RkM8I2HCJgZ6lkpe3rWDRRHkGFV10Foit
         LuP77X1pNpiy/h5JAPuOn7O2LlioJECVCe/MLZO8YXFYsT6HTUKG74zS89gWB4JE1p
         eER/D0UEEjXNA==
Date:   Thu, 16 Feb 2023 12:52:44 -0800
Subject: [PATCH 5/5] xfs: use parent pointer xattr space more efficiently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875939.3475422.16922640784869505922.stgit@magnolia>
In-Reply-To: <167657875861.3475422.10929602650869169128.stgit@magnolia>
References: <167657875861.3475422.10929602650869169128.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Amend the parent pointer xattr format even more.  Now we put as much of
the dirent name in the namehash as we can.  For names that don't fit,
the namehash is the truncated dirent name with the sha512 of the entire
name at the end of the namehash.  The EA value is then truncated to
whatever doesn't fit in the namehash.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   26 +++++++---
 fs/xfs/libxfs/xfs_parent.c    |  111 ++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_parent.h    |    6 +-
 fs/xfs/scrub/dir_repair.c     |    2 -
 fs/xfs/scrub/parent.c         |    4 +
 fs/xfs/xfs_attr_item.c        |    4 +
 fs/xfs/xfs_ondisk.h           |    4 +
 7 files changed, 118 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 4d85830785ae..55f510f82e8d 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -825,19 +825,24 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
 /* We use sha512 for the parent pointer name hash. */
-#define XFS_PARENT_NAME_HASH_SIZE	(64)
+#define XFS_PARENT_NAME_SHA512_SIZE	(64)
 
 /*
  * Parent pointer attribute format definition
  *
  * The EA name encodes the parent inode number, generation and a collision
- * resistant hash computed from the dirent name.  The hash is defined to be:
+ * resistant hash computed from the dirent name.  The hash is defined to be
+ * one of the following:
  *
- * - The dirent name if it fits within the EA name.
+ * - The dirent name, as long as it does not use the last possible byte of the
+ *   EA name space.
  *
- * - The sha512 of the child inode generation and the dirent name.
+ * - The truncated dirent name, with the sha512 hash of the child inode
+ *   generation number and dirent name.  The hash is written at the end of the
+ *   EA name.
  *
- * The EA value contains the same name as the dirent in the parent directory.
+ * The EA value contains however much of the dirent name that does not fit in
+ * the EA name.
  */
 struct xfs_parent_name_rec {
 	__be64  p_ino;
@@ -845,8 +850,17 @@ struct xfs_parent_name_rec {
 	__u8	p_namehash[];
 } __attribute__((packed));
 
+/* Maximum size of a parent pointer EA name. */
 #define XFS_PARENT_NAME_MAX_SIZE \
-	(sizeof(struct xfs_parent_name_rec) + XFS_PARENT_NAME_HASH_SIZE)
+	(MAXNAMELEN - 1)
+
+/* Maximum size of a parent pointer name hash. */
+#define XFS_PARENT_NAME_MAX_HASH_SIZE \
+	(XFS_PARENT_NAME_MAX_SIZE - sizeof(struct xfs_parent_name_rec))
+
+/* Offset of the sha512 hash, if used. */
+#define XFS_PARENT_NAME_SHA512_OFFSET \
+	(XFS_PARENT_NAME_MAX_HASH_SIZE - XFS_PARENT_NAME_SHA512_SIZE)
 
 static inline unsigned int
 xfs_parent_name_rec_sizeof(
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 6520e35178a0..f7fecee93894 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -57,7 +57,7 @@ xfs_parent_namecheck(
 	xfs_ino_t				p_ino;
 
 	if (reclen <= xfs_parent_name_rec_sizeof(0) ||
-	    reclen > xfs_parent_name_rec_sizeof(XFS_PARENT_NAME_HASH_SIZE))
+	    reclen > xfs_parent_name_rec_sizeof(XFS_PARENT_NAME_MAX_HASH_SIZE))
 		return false;
 
 	/* Only one namespace bit allowed. */
@@ -75,10 +75,18 @@ xfs_parent_namecheck(
 bool
 xfs_parent_valuecheck(
 	struct xfs_mount		*mp,
+	size_t				namelen,
 	const void			*value,
 	size_t				valuelen)
 {
-	if (valuelen == 0 || valuelen >= MAXNAMELEN)
+	if (namelen > XFS_PARENT_NAME_MAX_SIZE)
+		return false;
+
+	if (namelen < XFS_PARENT_NAME_MAX_SIZE && valuelen != 0)
+		return false;
+
+	if (namelen == XFS_PARENT_NAME_MAX_SIZE &&
+	    valuelen >= MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET)
 		return false;
 
 	if (value == NULL)
@@ -98,7 +106,20 @@ xfs_init_parent_name_rec(
 	rec->p_ino = cpu_to_be64(dp->i_ino);
 	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
 	return xfs_parent_namehash(ip, name, rec->p_namehash,
-			XFS_PARENT_NAME_HASH_SIZE);
+			XFS_PARENT_NAME_MAX_HASH_SIZE);
+}
+
+/* Compute the number of name bytes that can be encoded in the namehash. */
+static inline unsigned int
+xfs_parent_valuelen_adj(
+	int			hashlen)
+{
+	ASSERT(hashlen > 0);
+
+	if (hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
+		return XFS_PARENT_NAME_SHA512_OFFSET;
+
+	return hashlen;
 }
 
 /*
@@ -125,14 +146,29 @@ xfs_parent_irec_from_disk(
 		return;
 	}
 
-	ASSERT(valuelen > 0);
 	ASSERT(valuelen < MAXNAMELEN);
 
-	valuelen = min(valuelen, MAXNAMELEN);
+	if (irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE) {
+		ASSERT(valuelen > 0);
+		ASSERT(valuelen <= MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET);
 
-	irec->p_namelen = valuelen;
-	memcpy(irec->p_name, value, valuelen);
-	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
+		valuelen = min_t(int, valuelen,
+				MAXNAMELEN - XFS_PARENT_NAME_SHA512_OFFSET);
+
+		memcpy(irec->p_name, irec->p_namehash,
+				XFS_PARENT_NAME_SHA512_OFFSET);
+		memcpy(&irec->p_name[XFS_PARENT_NAME_SHA512_OFFSET],
+				value, valuelen);
+		irec->p_namelen = XFS_PARENT_NAME_SHA512_OFFSET + valuelen;
+	} else {
+		ASSERT(valuelen == 0);
+
+		memcpy(irec->p_name, irec->p_namehash, irec->hashlen);
+		irec->p_namelen = irec->hashlen;
+	}
+
+	memset(&irec->p_name[irec->p_namelen], 0,
+			sizeof(irec->p_name) - irec->p_namelen);
 }
 
 /*
@@ -157,11 +193,15 @@ xfs_parent_irec_to_disk(
 		ASSERT(*valuelen >= irec->p_namelen);
 		ASSERT(*valuelen < MAXNAMELEN);
 
-		*valuelen = irec->p_namelen;
+		if (irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
+			*valuelen = irec->p_namelen - XFS_PARENT_NAME_SHA512_OFFSET;
+		else
+			*valuelen = 0;
 	}
 
-	if (value)
-		memcpy(value, irec->p_name, irec->p_namelen);
+	if (value && irec->hashlen == XFS_PARENT_NAME_MAX_HASH_SIZE)
+		memcpy(value, irec->p_name + XFS_PARENT_NAME_SHA512_OFFSET,
+			      irec->p_namelen - XFS_PARENT_NAME_SHA512_OFFSET);
 }
 
 /*
@@ -214,6 +254,7 @@ xfs_parent_add(
 {
 	struct xfs_da_args	*args = &parent->args;
 	int			hashlen;
+	unsigned int		name_adj;
 
 	hashlen = xfs_init_parent_name_rec(&parent->rec, dp, parent_name,
 			child);
@@ -223,11 +264,13 @@ xfs_parent_add(
 	args->namelen = xfs_parent_name_rec_sizeof(hashlen);
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
+	name_adj = xfs_parent_valuelen_adj(hashlen);
+
 	args->trans = tp;
 	args->dp = child;
 	if (parent_name) {
-		parent->args.value = (void *)parent_name->name;
-		parent->args.valuelen = parent_name->len;
+		parent->args.value = (void *)parent_name->name + name_adj;
+		parent->args.valuelen = parent_name->len - name_adj;
 	}
 
 	return xfs_attr_defer_add(args);
@@ -269,6 +312,7 @@ xfs_parent_replace(
 {
 	struct xfs_da_args	*args = &new_parent->args;
 	int			old_hashlen, new_hashlen;
+	int			new_name_adj;
 
 	old_hashlen = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
 			old_name, child);
@@ -279,6 +323,8 @@ xfs_parent_replace(
 	if (new_hashlen < 0)
 		return new_hashlen;
 
+	new_name_adj = xfs_parent_valuelen_adj(new_hashlen);
+
 	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
 	new_parent->args.namelen = xfs_parent_name_rec_sizeof(old_hashlen);
 	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
@@ -286,8 +332,8 @@ xfs_parent_replace(
 	args->trans = tp;
 	args->dp = child;
 
-	new_parent->args.value = (void *)new_name->name;
-	new_parent->args.valuelen = new_name->len;
+	new_parent->args.value = (void *)new_name->name + new_name_adj;
+	new_parent->args.valuelen = new_name->len - new_name_adj;
 
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return xfs_attr_defer_replace(args);
@@ -331,10 +377,13 @@ xfs_parent_lookup(
 	struct xfs_parent_scratch	*scr)
 {
 	int				reclen;
+	int				name_adj;
 	int				error;
 
 	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
+	name_adj = xfs_parent_valuelen_adj(pptr->hashlen);
+
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
@@ -343,8 +392,8 @@ xfs_parent_lookup(
 	scr->args.namelen	= reclen;
 	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
 	scr->args.trans		= tp;
-	scr->args.valuelen	= namelen;
-	scr->args.value		= name;
+	scr->args.valuelen	= namelen - name_adj;
+	scr->args.value		= name + name_adj;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
 	scr->args.hashval = xfs_da_hashname(scr->args.name, scr->args.namelen);
@@ -353,7 +402,8 @@ xfs_parent_lookup(
 	if (error)
 		return error;
 
-	return scr->args.valuelen;
+	memcpy(name, pptr->p_namehash, name_adj);
+	return scr->args.valuelen + name_adj;
 }
 
 /*
@@ -369,17 +419,20 @@ xfs_parent_set(
 	struct xfs_parent_scratch	*scr)
 {
 	int				reclen;
+	int				name_adj;
 
 	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
+	name_adj = xfs_parent_valuelen_adj(pptr->hashlen);
+
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
 	scr->args.namelen	= reclen;
-	scr->args.valuelen	= pptr->p_namelen;
-	scr->args.value		= (void *)pptr->p_name;
+	scr->args.valuelen	= pptr->p_namelen - name_adj;
+	scr->args.value		= (void *)pptr->p_name + name_adj;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
 	return xfs_attr_set(&scr->args);
@@ -430,12 +483,16 @@ xfs_parent_namehash(
 	ASSERT(SHA512_DIGEST_SIZE ==
 			crypto_shash_digestsize(ip->i_mount->m_sha512));
 
-	if (namehash_len != SHA512_DIGEST_SIZE) {
+	if (namehash_len != XFS_PARENT_NAME_MAX_HASH_SIZE) {
 		ASSERT(0);
 		return -EINVAL;
 	}
 
-	if (name->len < namehash_len) {
+	if (name->len < XFS_PARENT_NAME_MAX_HASH_SIZE) {
+		/*
+		 * If the dirent name is shorter than the size of the namehash
+		 * field, write it directly into the namehash field.
+		 */
 		memcpy(namehash, name->name, name->len);
 		memset(namehash + name->len, 0, namehash_len - name->len);
 		return name->len;
@@ -453,11 +510,17 @@ xfs_parent_namehash(
 	if (error)
 		goto out;
 
-	error = sha512_done(&shash, namehash);
+	/*
+	 * The sha512 hash of the child gen and dirent name is placed at the
+	 * end of the namehash, and as many bytes as will fit are copied from
+	 * the dirent name to the start of the namehash.
+	 */
+	error = sha512_done(&shash, namehash + XFS_PARENT_NAME_SHA512_OFFSET);
 	if (error)
 		goto out;
 
-	error = SHA512_DIGEST_SIZE;
+	memcpy(namehash, name->name, XFS_PARENT_NAME_SHA512_OFFSET);
+	error = XFS_PARENT_NAME_MAX_HASH_SIZE;
 out:
 	sha512_erase(&shash);
 	return error;
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 3431aac75e92..6f6136165efe 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -12,8 +12,8 @@ extern struct kmem_cache	*xfs_parent_intent_cache;
 bool xfs_parent_namecheck(struct xfs_mount *mp,
 		const struct xfs_parent_name_rec *rec, size_t reclen,
 		unsigned int attr_flags);
-bool xfs_parent_valuecheck(struct xfs_mount *mp, const void *value,
-		size_t valuelen);
+bool xfs_parent_valuecheck(struct xfs_mount *mp, size_t namelen,
+		const void *value, size_t valuelen);
 
 /*
  * Incore version of a parent pointer, also contains dirent name so callers
@@ -24,7 +24,7 @@ struct xfs_parent_name_irec {
 	xfs_ino_t		p_ino;
 	uint32_t		p_gen;
 	uint8_t			hashlen;
-	uint8_t			p_namehash[XFS_PARENT_NAME_HASH_SIZE];
+	uint8_t			p_namehash[XFS_PARENT_NAME_MAX_HASH_SIZE];
 
 	/* Attributes of a parent pointer. */
 	uint8_t			p_namelen;
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index b12548787321..76953575f0b2 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -537,7 +537,7 @@ xrep_dir_scan_parent_pointer(
 
 	/* Does the ondisk parent pointer structure make sense? */
 	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags) ||
-	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
+	    !xfs_parent_valuecheck(sc->mp, namelen, value, valuelen))
 		return -EFSCORRUPTED;
 
 	xfs_parent_irec_from_disk(&rd->pptr, rec, namelen, value, valuelen);
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index b47f0bcef690..f3b1d7cbe415 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -350,7 +350,7 @@ struct xchk_pptrs {
 	struct xfs_parent_scratch pptr_scratch;
 
 	/* Name hashes */
-	uint8_t			child_namehash[XFS_PARENT_NAME_HASH_SIZE];
+	uint8_t			child_namehash[XFS_PARENT_NAME_MAX_HASH_SIZE];
 
 	/* Name buffer for revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
@@ -548,7 +548,7 @@ xchk_parent_scan_attr(
 		return -ECANCELED;
 	}
 
-	if (!xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+	if (!xfs_parent_valuecheck(sc->mp, namelen, value, valuelen)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
 		return -ECANCELED;
 	}
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index da807f286a09..792c01a49749 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -769,7 +769,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		if (item->ri_total != 3) {
+		if (item->ri_total != 3 && item->ri_total != 2) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -783,7 +783,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
-		if (item->ri_total != 4) {
+		if (item->ri_total != 3 && item->ri_total != 4) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 24361ae0fd48..5f32dea26221 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -117,7 +117,9 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	12);
-	BUILD_BUG_ON(XFS_PARENT_NAME_HASH_SIZE != SHA512_DIGEST_SIZE);
+	BUILD_BUG_ON(XFS_PARENT_NAME_MAX_HASH_SIZE < SHA512_DIGEST_SIZE);
+	BUILD_BUG_ON(XFS_PARENT_NAME_MAX_HASH_SIZE !=           243);
+	BUILD_BUG_ON(XFS_PARENT_NAME_SHA512_OFFSET !=           179);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);

