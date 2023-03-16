Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF1EC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjCPT0F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjCPT0E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:26:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F561A8E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:25:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63821B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CE4C4339B;
        Thu, 16 Mar 2023 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994755;
        bh=s9CXBfVtcEhEim2/JNkTDPVrku2vzPRfMopfSOZRo8s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gYPSpkOxuD5Ew5yI/iVPa1/YaWW1fxDx4kRYNvsE+RxFDmzpPHRvYa84NNHVRbYRI
         a3wJHsjEkZ2ZIqjkuOtrGUMFjywE2YVe3dBvd3Iqt2Rp9Th8WTqs6iGFIm/pG1oNDu
         keUtoQ6UiTGyPXZiv6CEri+/3txUEcRkDHzrNboXSaebY+OQxVN8pd8gRJMYYFhg36
         5yGOJebNo0krXwJYX1mMbkdidKLtkQF7xTlNMTvldwkBf7ou+Cr+mgFHFOeW2hCQFb
         9+aTP7NW17fNOXL3KU8CW1Q+WiQLlcNTHMWwGmUrNOB7wEt2lfZYDXA80ecAf8JrUW
         4eYCihBy0G+FA==
Date:   Thu, 16 Mar 2023 12:25:54 -0700
Subject: [PATCH 17/17] xfs: replace parent pointer diroffset with full dirent
 name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414594.15363.14319698721084958690.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As I've mentioned in past comments on the parent pointers patchset, the
proposed ondisk parent pointer format presents a major difficulty for
online directory repair.  This difficulty derives from encoding the
directory offset of the dirent that the parent pointer is mirroring.
Recall that parent pointers are stored in extended attributes:

    (parent_ino, parent_gen, diroffset) -> (dirent_name)

If the directory is rebuilt, the offsets of the new directory entries
must match the diroffset encoded in the parent pointer, or the
filesystem becomes inconsistent.  This is difficult to guarantee in the
process of performing a repair and in the long terms is totally
pointless because the the parent pointer code doesn't use the diroffset,
nor does the online fsck code.  IOWs, this design decision increases the
complexity of repair solely to work around the xattr code being unable
to store a full dirent name in the xattr name or match on xattr values.

However, xattrs can now perform lookups on both the name and value of an
xattr.  This means we can redefine the parent pointer format like this:

For dirent names shorter than 243 bytes:

    (parent_ino, parent_gen, dirent_name) -> NULL

For dirent names longer than 243 bytes:

    (parent_ino, parent_gen, dirent_name[0:242]) -> (dirent_name[243:255])

and this works because a parent pointer lookup uses NVLOOKUP, which will
read those last twelve bytes of the dirent name if need be.

Replace the diroffset with this new format, thereby eliminating the need
for directory repair to update all the parent pointers after rebuilding
the directory.  We haven't merged parent pointers, so changes to the
ondisk format are easy.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  |   39 ++++++-
 fs/xfs/libxfs/xfs_fs.h         |    2 
 fs/xfs/libxfs/xfs_parent.c     |  216 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_parent.h     |   46 +++++----
 fs/xfs/libxfs/xfs_trans_resv.c |    7 +
 fs/xfs/scrub/dir.c             |   34 +-----
 fs/xfs/scrub/dir_repair.c      |   87 +++++-----------
 fs/xfs/scrub/parent.c          |   48 ++-------
 fs/xfs/scrub/parent_repair.c   |   55 +++-------
 fs/xfs/scrub/trace.h           |   65 ++----------
 fs/xfs/xfs_inode.c             |   30 ++----
 fs/xfs/xfs_ondisk.h            |    1 
 fs/xfs/xfs_parent_utils.c      |    8 +
 fs/xfs/xfs_symlink.c           |    3 -
 14 files changed, 291 insertions(+), 350 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index c07b8166e8ff..dd569286b3be 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -827,14 +827,43 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 /*
  * Parent pointer attribute format definition
  *
- * EA name encodes the parent inode number, generation and the offset of
- * the dirent that points to the child inode. The EA value contains the
- * same name as the dirent in the parent directory.
+ * The EA name encodes the parent inode number, generation and as much of the
+ * dirent name as fits.  In other words, it contains up to 243 bytes of the
+ * dirent name.
+ *
+ * The EA value contains however much of the dirent name that does not fit in
+ * the EA name.
  */
 struct xfs_parent_name_rec {
 	__be64  p_ino;
 	__be32  p_gen;
-	__be32  p_diroffset;
-};
+	__u8	p_dname[];
+} __attribute__((packed));
+
+/* Maximum size of a parent pointer EA name. */
+#define XFS_PARENT_NAME_MAX_SIZE \
+	(MAXNAMELEN - 1)
+
+/* Maximum number of dirent name bytes stored in p_dname. */
+#define XFS_PARENT_MAX_DNAME_SIZE \
+	(XFS_PARENT_NAME_MAX_SIZE - sizeof(struct xfs_parent_name_rec))
+
+/* Maximum number of dirent name bytes stored in the xattr value. */
+#define XFS_PARENT_MAX_DNAME_VALUELEN \
+	sizeof(struct xfs_parent_name_rec)
+
+static inline unsigned int
+xfs_parent_name_rec_sizeof(
+	unsigned int		dnamelen)
+{
+	return sizeof(struct xfs_parent_name_rec) + dnamelen;
+}
+
+static inline unsigned int
+xfs_parent_name_dnamelen(
+	unsigned int		rec_sizeof)
+{
+	return rec_sizeof - sizeof(struct xfs_parent_name_rec);
+}
 
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d7e061089e75..d8619479ef4a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -769,7 +769,7 @@ struct xfs_scrub_metadata {
 struct xfs_getparents_rec {
 	__u64		gpr_ino;	/* Inode number */
 	__u32		gpr_gen;	/* Inode generation */
-	__u32		gpr_diroffset;	/* Directory offset */
+	__u32		gpr_rsvd2;	/* Reserved */
 	__u64		gpr_rsvd;	/* Reserved */
 	__u8		gpr_name[];	/* File name and null terminator */
 };
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 96ce5de8508a..af412ebe65a4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -54,9 +54,12 @@ xfs_parent_namecheck(
 	unsigned int				attr_flags)
 {
 	xfs_ino_t				p_ino;
-	xfs_dir2_dataptr_t			p_diroffset;
 
-	if (reclen != sizeof(struct xfs_parent_name_rec))
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return false;
+
+	if (reclen <= sizeof(struct xfs_parent_name_rec) ||
+	    reclen > XFS_PARENT_NAME_MAX_SIZE)
 		return false;
 
 	/* Only one namespace bit allowed. */
@@ -67,10 +70,6 @@ xfs_parent_namecheck(
 	if (!xfs_verify_ino(mp, p_ino))
 		return false;
 
-	p_diroffset = be32_to_cpu(rec->p_diroffset);
-	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
-		return false;
-
 	return true;
 }
 
@@ -78,10 +77,18 @@ xfs_parent_namecheck(
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
+	    valuelen > XFS_PARENT_MAX_DNAME_VALUELEN)
 		return false;
 
 	if (value == NULL)
@@ -90,19 +97,25 @@ xfs_parent_valuecheck(
 	return true;
 }
 
-/* Initializes a xfs_parent_name_rec to be stored as an attribute name */
-static inline void
+/*
+ * Initializes a xfs_parent_name_rec to be stored as an attribute name.
+ * Returns the number of name bytes stored in p_dname.
+ */
+static inline int
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
-	const struct xfs_inode		*ip,
-	uint32_t			p_diroffset)
+	const struct xfs_inode		*dp,
+	const struct xfs_name		*name,
+	struct xfs_inode		*ip)
 {
-	xfs_ino_t			p_ino = ip->i_ino;
-	uint32_t			p_gen = VFS_IC(ip)->i_generation;
+	int				dnamelen;
 
-	rec->p_ino = cpu_to_be64(p_ino);
-	rec->p_gen = cpu_to_be32(p_gen);
-	rec->p_diroffset = cpu_to_be32(p_diroffset);
+	rec->p_ino = cpu_to_be64(dp->i_ino);
+	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
+
+	dnamelen = min_t(int, name->len, XFS_PARENT_MAX_DNAME_SIZE);
+	memcpy(rec->p_dname, name->name, dnamelen);
+	return dnamelen;
 }
 
 /*
@@ -113,53 +126,58 @@ void
 xfs_parent_irec_from_disk(
 	struct xfs_parent_name_irec	*irec,
 	const struct xfs_parent_name_rec *rec,
+	int				reclen,
 	const void			*value,
 	int				valuelen)
 {
+	int				dnamelen;
+
 	irec->p_ino = be64_to_cpu(rec->p_ino);
 	irec->p_gen = be32_to_cpu(rec->p_gen);
-	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
 
 	if (!value) {
 		irec->p_namelen = 0;
 		return;
 	}
 
-	ASSERT(valuelen > 0);
-	ASSERT(valuelen < MAXNAMELEN);
+	ASSERT(valuelen <= XFS_PARENT_MAX_DNAME_VALUELEN);
 
-	valuelen = min(valuelen, MAXNAMELEN);
-
-	irec->p_namelen = valuelen;
-	memcpy(irec->p_name, value, valuelen);
-	memset(&irec->p_name[valuelen], 0, sizeof(irec->p_name) - valuelen);
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
+	int				*reclen,
 	void				*value,
 	int				*valuelen,
 	const struct xfs_parent_name_irec *irec)
 {
+	int				dnamelen;
+
 	rec->p_ino = cpu_to_be64(irec->p_ino);
 	rec->p_gen = cpu_to_be32(irec->p_gen);
-	rec->p_diroffset = cpu_to_be32(irec->p_diroffset);
+	dnamelen = min_t(int, irec->p_namelen, XFS_PARENT_MAX_DNAME_SIZE);
+	*reclen = xfs_parent_name_rec_sizeof(dnamelen);
+	memcpy(rec->p_dname, irec->p_name, dnamelen);
 
-	if (valuelen) {
-		ASSERT(*valuelen > 0);
-		ASSERT(*valuelen >= irec->p_namelen);
-		ASSERT(*valuelen < MAXNAMELEN);
+	if (!valuelen)
+		return dnamelen;
 
-		*valuelen = irec->p_namelen;
-	}
+	*valuelen = irec->p_namelen - dnamelen;
+	if (*valuelen)
+		memcpy(value, rec->p_dname + XFS_PARENT_MAX_DNAME_SIZE,
+				*valuelen);
 
-	if (value)
-		memcpy(value, irec->p_name, irec->p_namelen);
+	return dnamelen;
 }
 
 /*
@@ -193,9 +211,10 @@ __xfs_parent_init(
 	parent->args.geo = mp->m_attr_geo;
 	parent->args.whichfork = XFS_ATTR_FORK;
 	parent->args.attr_filter = XFS_ATTR_PARENT;
-	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
+	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED |
+				XFS_DA_OP_VLOOKUP;
 	parent->args.name = (const uint8_t *)&parent->rec;
-	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	parent->args.namelen = 0;
 
 	*parentp = parent;
 	return 0;
@@ -208,20 +227,25 @@ xfs_parent_add(
 	struct xfs_parent_defer	*parent,
 	struct xfs_inode	*dp,
 	const struct xfs_name	*parent_name,
-	xfs_dir2_dataptr_t	diroffset,
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
+	int			dnamelen;
 
-	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	dnamelen = xfs_init_parent_name_rec(&parent->rec, dp, parent_name,
+			child);
+
+	args->namelen = xfs_parent_name_rec_sizeof(dnamelen);
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	args->trans = tp;
 	args->dp = child;
-	if (parent_name) {
-		parent->args.value = (void *)parent_name->name;
-		parent->args.valuelen = parent_name->len;
-	}
+
+	parent->args.valuelen = parent_name->len - dnamelen;
+	if (parent->args.valuelen > 0)
+		parent->args.value = (void *)parent_name->name + dnamelen;
+	else
+		parent->args.value = NULL;
 
 	return xfs_attr_defer_add(args);
 }
@@ -230,17 +254,27 @@ xfs_parent_add(
 int
 xfs_parent_remove(
 	struct xfs_trans	*tp,
-	struct xfs_inode	*dp,
 	struct xfs_parent_defer	*parent,
-	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
+	int			dnamelen;
 
-	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
+	dnamelen = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
+
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
 
@@ -250,26 +284,37 @@ xfs_parent_replace(
 	struct xfs_trans	*tp,
 	struct xfs_parent_defer	*new_parent,
 	struct xfs_inode	*old_dp,
-	xfs_dir2_dataptr_t	old_diroffset,
-	const struct xfs_name	*parent_name,
+	const struct xfs_name	*old_name,
 	struct xfs_inode	*new_dp,
-	xfs_dir2_dataptr_t	new_diroffset,
+	const struct xfs_name	*new_name,
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &new_parent->args;
+	int			old_dnamelen, new_dnamelen;
+
+	old_dnamelen = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
+			old_name, child);
+	new_dnamelen = xfs_init_parent_name_rec(&new_parent->rec, new_dp,
+			new_name, child);
 
-	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
-	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
 	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
-	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.namelen = xfs_parent_name_rec_sizeof(old_dnamelen);
 	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
-	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_namelen = xfs_parent_name_rec_sizeof(new_dnamelen);
 	args->trans = tp;
 	args->dp = child;
 
-	ASSERT(parent_name != NULL);
-	new_parent->args.value = (void *)parent_name->name;
-	new_parent->args.valuelen = parent_name->len;
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
@@ -299,42 +344,40 @@ xfs_pptr_calc_space_res(
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
-	int				error;
+	int				dnamelen;
+	int				reclen;
 
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
-	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
+	scr->args.namelen	= reclen;
+	scr->args.op_flags	= XFS_DA_OP_OKNOENT | XFS_DA_OP_VLOOKUP;
 	scr->args.trans		= tp;
-	scr->args.valuelen	= namelen;
-	scr->args.value		= name;
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
-	return scr->args.valuelen;
+	return xfs_attr_get_ilocked(&scr->args);
 }
 
 /*
@@ -349,18 +392,24 @@ xfs_parent_set(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	int				dnamelen;
+	int				reclen;
+
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
-	scr->args.valuelen	= pptr->p_namelen;
-	scr->args.value		= (void *)pptr->p_name;
+	scr->args.namelen	= reclen;
+	scr->args.op_flags	= XFS_DA_OP_VLOOKUP;
+	scr->args.valuelen	= pptr->p_namelen - dnamelen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
+	if (scr->args.valuelen)
+		scr->args.value	= (void *)pptr->p_name + dnamelen;
+
 	return xfs_attr_set(&scr->args);
 }
 
@@ -376,16 +425,23 @@ xfs_parent_unset(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	int				dnamelen;
+	int				reclen;
+
+	dnamelen = xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
-	scr->args.op_flags	= XFS_DA_OP_REMOVE;
+	scr->args.namelen	= reclen;
+	scr->args.op_flags	= XFS_DA_OP_REMOVE | XFS_DA_OP_VLOOKUP;
+	scr->args.valuelen	= pptr->p_namelen - dnamelen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
+	if (scr->args.valuelen)
+		scr->args.value	= (void *)pptr->p_name + dnamelen;
+
 	return xfs_attr_set(&scr->args);
 }
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index a7fc621b82c4..0b3e0b94d6cb 100644
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
@@ -23,26 +23,30 @@ struct xfs_parent_name_irec {
 	/* Key fields for looking up a particular parent pointer. */
 	xfs_ino_t		p_ino;
 	uint32_t		p_gen;
-	xfs_dir2_dataptr_t	p_diroffset;
-
-	/* Attributes of a parent pointer. */
 	uint8_t			p_namelen;
 	unsigned char		p_name[MAXNAMELEN];
 };
 
 void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
-		const struct xfs_parent_name_rec *rec,
+		const struct xfs_parent_name_rec *rec, int reclen,
 		const void *value, int valuelen);
-void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, void *value,
-		int *valuelen, const struct xfs_parent_name_irec *irec);
+int xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
+		void *value, int *valuelen,
+		const struct xfs_parent_name_irec *irec);
 
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
  * the defer ops machinery
  */
 struct xfs_parent_defer {
-	struct xfs_parent_name_rec	rec;
-	struct xfs_parent_name_rec	old_rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
+	union {
+		struct xfs_parent_name_rec	old_rec;
+		__u8			dummy2[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 	bool				have_log;
 };
@@ -79,15 +83,14 @@ xfs_parent_start_locked(
 
 int xfs_parent_add(struct xfs_trans *tp, struct xfs_parent_defer *parent,
 		struct xfs_inode *dp, const struct xfs_name *parent_name,
-		xfs_dir2_dataptr_t diroffset, struct xfs_inode *child);
+		struct xfs_inode *child);
 int xfs_parent_replace(struct xfs_trans *tp,
 		struct xfs_parent_defer *new_parent, struct xfs_inode *old_dp,
-		xfs_dir2_dataptr_t old_diroffset,
-		const struct xfs_name *parent_name, struct xfs_inode *new_ip,
-		xfs_dir2_dataptr_t new_diroffset, struct xfs_inode *child);
-int xfs_parent_remove(struct xfs_trans *tp, struct xfs_inode *dp,
-		struct xfs_parent_defer *parent, xfs_dir2_dataptr_t diroffset,
-		struct xfs_inode *child);
+		const struct xfs_name *old_name, struct xfs_inode *new_ip,
+		const struct xfs_name *new_name, struct xfs_inode *child);
+int xfs_parent_remove(struct xfs_trans *tp,
+		struct xfs_parent_defer *parent, struct xfs_inode *dp,
+		const struct xfs_name *name, struct xfs_inode *child);
 
 void __xfs_parent_cancel(struct xfs_mount *mp, struct xfs_parent_defer *parent);
 
@@ -105,13 +108,16 @@ unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 
 /* Scratchpad memory so that raw parent operations don't burn stack space. */
 struct xfs_parent_scratch {
-	struct xfs_parent_name_rec	rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 };
 
 int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
-		const struct xfs_parent_name_irec *pptr, unsigned char *name,
-		unsigned int namelen, struct xfs_parent_scratch *scratch);
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
 
 int xfs_parent_set(struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f5d5cb48f78a..3ad1bc57a107 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -427,19 +427,20 @@ static inline unsigned int xfs_calc_pptr_link_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_replace_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE) +
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 
 /*
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 3f3223e563ae..23cb7519c8f0 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -78,7 +78,7 @@ struct xchk_dir {
 	/* If we've cycled the ILOCK, we must revalidate deferred dirents. */
 	bool			need_revalidate;
 
-	/* Name buffer for pptr validation and dirent revalidation. */
+	/* Name buffer for dirent revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
 
 };
@@ -139,38 +139,20 @@ xchk_dir_lock_child(
 STATIC int
 xchk_dir_parent_pointer(
 	struct xchk_dir		*sd,
-	xfs_dir2_dataptr_t	dapos,
 	const struct xfs_name	*name,
 	struct xfs_inode	*ip)
 {
 	struct xfs_scrub	*sc = sd->sc;
-	int			pptr_namelen;
+	int			error;
 
 	sd->pptr.p_ino = sc->ip->i_ino;
 	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
-	sd->pptr.p_diroffset = dapos;
+	sd->pptr.p_namelen = name->len;
+	memcpy(sd->pptr.p_name, name->name, name->len);
 
-	pptr_namelen = xfs_parent_lookup(sc->tp, ip, &sd->pptr, sd->namebuf,
-			MAXNAMELEN, &sd->pptr_scratch);
-	if (pptr_namelen == -ENOATTR) {
+	error = xfs_parent_lookup(sc->tp, ip, &sd->pptr, &sd->pptr_scratch);
+	if (error == -ENOATTR)
 		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
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
-		xchk_fblock_xref_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
-	}
 
 	return 0;
 }
@@ -216,7 +198,7 @@ xchk_dir_check_pptr_fast(
 		return 0;
 	}
 
-	error = xchk_dir_parent_pointer(sd, dapos, name, ip);
+	error = xchk_dir_parent_pointer(sd, name, ip);
 	xfs_iunlock(ip, lockmode);
 	return error;
 }
@@ -1041,7 +1023,7 @@ xchk_dir_slow_dirent(
 		goto out_unlock;
 
 check_pptr:
-	error = xchk_dir_parent_pointer(sd, dirent->diroffset, &xname, ip);
+	error = xchk_dir_parent_pointer(sd, &xname, ip);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 out_rele:
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 70fb98c75c23..e15149d1945c 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -93,9 +93,6 @@ struct xrep_dirent {
 	/* Child inode number. */
 	xfs_ino_t		ino;
 
-	/* Directory offset that we want.  We're not going to get it. */
-	xfs_dir2_dataptr_t	diroffset;
-
 	/* Length of the dirent name. */
 	uint8_t			namelen;
 
@@ -261,8 +258,7 @@ xrep_dir_createname(
 	struct xrep_dir		*rd,
 	const struct xfs_name	*name,
 	xfs_ino_t		inum,
-	xfs_extlen_t		total,
-	xfs_dir2_dataptr_t	diroffset)
+	xfs_extlen_t		total)
 {
 	struct xfs_scrub	*sc = rd->sc;
 	struct xfs_inode	*dp = rd->args.dp;
@@ -275,7 +271,7 @@ xrep_dir_createname(
 	if (error)
 		return error;
 
-	trace_xrep_dir_createname(dp, name, inum, diroffset);
+	trace_xrep_dir_createname(dp, name, inum);
 
 	/* reset cmpresult as if we haven't done a lookup */
 	rd->args.cmpresult = XFS_CMP_DIFFERENT;
@@ -307,8 +303,7 @@ STATIC int
 xrep_dir_removename(
 	struct xrep_dir		*rd,
 	const struct xfs_name	*name,
-	xfs_extlen_t		total,
-	xfs_dir2_dataptr_t	diroffset)
+	xfs_extlen_t		total)
 {
 	struct xfs_inode	*dp = rd->args.dp;
 	bool			is_block, is_leaf;
@@ -321,7 +316,7 @@ xrep_dir_removename(
 	rd->args.op_flags = 0;
 	rd->args.total = total;
 
-	trace_xrep_dir_removename(dp, name, rd->args.inumber, diroffset);
+	trace_xrep_dir_removename(dp, name, rd->args.inumber);
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_removename(&rd->args);
@@ -385,8 +380,7 @@ xrep_dir_replay_update(
 			goto out_cancel;
 		}
 
-		error = xrep_dir_removename(rd, &xname, resblks,
-				dirent->diroffset);
+		error = xrep_dir_removename(rd, &xname, resblks);
 	} else {
 		/* Add this dirent.  The lookup must not succeed. */
 		if (error == 0)
@@ -394,8 +388,7 @@ xrep_dir_replay_update(
 		if (error != -ENOENT)
 			goto out_cancel;
 
-		error = xrep_dir_createname(rd, &xname, dirent->ino, resblks,
-				dirent->diroffset);
+		error = xrep_dir_createname(rd, &xname, dirent->ino, resblks);
 	}
 	if (error)
 		goto out_cancel;
@@ -465,19 +458,17 @@ STATIC int
 xrep_dir_add_dirent(
 	struct xrep_dir		*rd,
 	const struct xfs_name	*name,
-	xfs_ino_t		ino,
-	xfs_dir2_dataptr_t	diroffset)
+	xfs_ino_t		ino)
 {
 	struct xrep_dirent	dirent = {
 		.action		= XREP_DIRENT_ADD,
 		.ino		= ino,
 		.namelen	= name->len,
 		.ftype		= name->type,
-		.diroffset	= diroffset,
 	};
 	int			error;
 
-	trace_xrep_dir_add_dirent(rd->sc->tempip, name, ino, diroffset);
+	trace_xrep_dir_add_dirent(rd->sc->tempip, name, ino);
 
 	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
 			name->len);
@@ -495,19 +486,17 @@ STATIC int
 xrep_dir_remove_dirent(
 	struct xrep_dir		*rd,
 	const struct xfs_name	*name,
-	xfs_ino_t		ino,
-	xfs_dir2_dataptr_t	diroffset)
+	xfs_ino_t		ino)
 {
 	struct xrep_dirent	dirent = {
 		.action		= XREP_DIRENT_REMOVE,
 		.ino		= ino,
 		.namelen	= name->len,
 		.ftype		= name->type,
-		.diroffset	= diroffset,
 	};
 	int			error;
 
-	trace_xrep_dir_remove_dirent(rd->sc->tempip, name, ino, diroffset);
+	trace_xrep_dir_remove_dirent(rd->sc->tempip, name, ino);
 
 	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
 			name->len);
@@ -548,10 +537,10 @@ xrep_dir_scan_parent_pointer(
 
 	/* Does the ondisk parent pointer structure make sense? */
 	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags) ||
-	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
+	    !xfs_parent_valuecheck(sc->mp, namelen, value, valuelen))
 		return -EFSCORRUPTED;
 
-	xfs_parent_irec_from_disk(&rd->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&rd->pptr, rec, namelen, value, valuelen);
 
 	/* Ignore parent pointers that point back to a different dir. */
 	if (rd->pptr.p_ino != sc->ip->i_ino ||
@@ -567,8 +556,7 @@ xrep_dir_scan_parent_pointer(
 	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
 
 	mutex_lock(&rd->lock);
-	error = xrep_dir_add_dirent(rd, &xname, ip->i_ino,
-			rd->pptr.p_diroffset);
+	error = xrep_dir_add_dirent(rd, &xname, ip->i_ino);
 	mutex_unlock(&rd->lock);
 	return error;
 }
@@ -605,7 +593,7 @@ xrep_dir_scan_dirent(
 	    xrep_dir_samename(name, &xfs_name_dot))
 		return 0;
 
-	trace_xrep_dir_replacename(sc->tempip, &xfs_name_dotdot, dp->i_ino, 0);
+	trace_xrep_dir_replacename(sc->tempip, &xfs_name_dotdot, dp->i_ino);
 
 	mutex_lock(&rd->lock);
 	rd->parent_ino = dp->i_ino;
@@ -774,7 +762,6 @@ xrep_dir_dump_tempdir(
 	xfs_ino_t		child_ino;
 	bool			child_dirent = true;
 	bool			compare_dirent = true;
-	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
 	int			error;
 
 	/*
@@ -802,15 +789,13 @@ xrep_dir_dump_tempdir(
 		ino = sc->ip->i_ino;
 	}
 
-	trace_xrep_dir_dumpname(sc->tempip, name, ino, dapos);
+	trace_xrep_dir_dumpname(sc->tempip, name, ino);
 
 	/* Check that the dir being repaired has the same entry. */
 	if (compare_dirent) {
-		error = xchk_dir_lookup(sc, sc->ip, name, &child_ino,
-				&child_diroffset);
+		error = xchk_dir_lookup(sc, sc->ip, name, &child_ino, NULL);
 		if (error == -ENOENT) {
-			trace_xrep_dir_checkname(sc->ip, name, NULLFSINO,
-					XFS_DIR2_NULL_DATAPTR);
+			trace_xrep_dir_checkname(sc->ip, name, NULLFSINO);
 			ASSERT(error != -ENOENT);
 			return -EFSCORRUPTED;
 		}
@@ -818,17 +803,10 @@ xrep_dir_dump_tempdir(
 			return error;
 
 		if (ino != child_ino) {
-			trace_xrep_dir_checkname(sc->ip, name, child_ino,
-					child_diroffset);
+			trace_xrep_dir_checkname(sc->ip, name, child_ino);
 			ASSERT(ino == child_ino);
 			return -EFSCORRUPTED;
 		}
-
-		if (dapos != child_diroffset) {
-			trace_xrep_dir_badposname(sc->ip, name, child_ino,
-					child_diroffset);
-			/* We have no way to update this, so it. */
-		}
 	}
 
 	/*
@@ -839,7 +817,7 @@ xrep_dir_dump_tempdir(
 	 */
 	if (child_dirent) {
 		mutex_lock(&rd->lock);
-		error = xrep_dir_remove_dirent(rd, name, ino, dapos);
+		error = xrep_dir_remove_dirent(rd, name, ino);
 		mutex_unlock(&rd->lock);
 	}
 
@@ -861,7 +839,6 @@ xrep_dir_dump_baddir(
 	void			*priv)
 {
 	xfs_ino_t		child_ino;
-	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
 	int			error;
 
 	/* Ignore the directory's dot and dotdot entries. */
@@ -869,14 +846,12 @@ xrep_dir_dump_baddir(
 	    xrep_dir_samename(name, &xfs_name_dot))
 		return 0;
 
-	trace_xrep_dir_dumpname(sc->ip, name, ino, dapos);
+	trace_xrep_dir_dumpname(sc->ip, name, ino);
 
 	/* Check that the tempdir has the same entry. */
-	error = xchk_dir_lookup(sc, sc->tempip, name, &child_ino,
-			&child_diroffset);
+	error = xchk_dir_lookup(sc, sc->tempip, name, &child_ino, NULL);
 	if (error == -ENOENT) {
-		trace_xrep_dir_checkname(sc->tempip, name, NULLFSINO,
-				XFS_DIR2_NULL_DATAPTR);
+		trace_xrep_dir_checkname(sc->tempip, name, NULLFSINO);
 		ASSERT(error != -ENOENT);
 		return -EFSCORRUPTED;
 	}
@@ -884,18 +859,11 @@ xrep_dir_dump_baddir(
 		return error;
 
 	if (ino != child_ino) {
-		trace_xrep_dir_checkname(sc->tempip, name, child_ino,
-				child_diroffset);
+		trace_xrep_dir_checkname(sc->tempip, name, child_ino);
 		ASSERT(ino == child_ino);
 		return -EFSCORRUPTED;
 	}
 
-	if (dapos != child_diroffset) {
-		trace_xrep_dir_badposname(sc->ip, name, child_ino,
-				child_diroffset);
-		/* We have no way to update this, so we just leave it. */
-	}
-
 	return 0;
 }
 
@@ -1027,11 +995,10 @@ xrep_dir_live_update(
 	    xchk_iscan_want_live_update(&rd->iscan, p->ip->i_ino)) {
 		mutex_lock(&rd->lock);
 		if (p->delta > 0)
-			error = xrep_dir_add_dirent(rd, p->name, p->ip->i_ino,
-					p->diroffset);
+			error = xrep_dir_add_dirent(rd, p->name, p->ip->i_ino);
 		else
 			error = xrep_dir_remove_dirent(rd, p->name,
-					p->ip->i_ino, p->diroffset);
+					p->ip->i_ino);
 		mutex_unlock(&rd->lock);
 		if (error)
 			goto out_abort;
@@ -1047,14 +1014,14 @@ xrep_dir_live_update(
 	    xchk_iscan_want_live_update(&rd->iscan, p->dp->i_ino)) {
 		if (p->delta > 0) {
 			trace_xrep_dir_add_dirent(sc->tempip, &xfs_name_dotdot,
-					p->dp->i_ino, 0);
+					p->dp->i_ino);
 
 			mutex_lock(&rd->lock);
 			rd->parent_ino = p->dp->i_ino;
 			mutex_unlock(&rd->lock);
 		} else {
 			trace_xrep_dir_remove_dirent(sc->tempip,
-					&xfs_name_dotdot, NULLFSINO, 0);
+					&xfs_name_dotdot, NULLFSINO);
 
 			mutex_lock(&rd->lock);
 			rd->parent_ino = NULLFSINO;
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 14f16fefd1b0..fbe6fb709e2e 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -323,7 +323,6 @@ struct xchk_pptr {
 	/* Parent pointer attr key. */
 	xfs_ino_t			p_ino;
 	uint32_t			p_gen;
-	xfs_dir2_dataptr_t		p_diroffset;
 
 	/* Length of the pptr name. */
 	uint8_t				namelen;
@@ -349,9 +348,6 @@ struct xchk_pptrs {
 
 	/* xattr key and da args for parent pointer revalidation. */
 	struct xfs_parent_scratch pptr_scratch;
-
-	/* Name buffer for revalidation. */
-	uint8_t			namebuf[MAXNAMELEN];
 };
 
 /* Look up the dotdot entry so that we can check it as we walk the pptrs. */
@@ -426,14 +422,13 @@ xchk_parent_dirent(
 	};
 	struct xfs_scrub	*sc = pp->sc;
 	xfs_ino_t		child_ino;
-	xfs_dir2_dataptr_t	child_diroffset;
 	int			error;
 
 	/*
 	 * Use the name attached to this parent pointer to look up the
 	 * directory entry in the alleged parent.
 	 */
-	error = xchk_dir_lookup(sc, dp, &xname, &child_ino, &child_diroffset);
+	error = xchk_dir_lookup(sc, dp, &xname, &child_ino, NULL);
 	if (error == -ENOENT) {
 		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
 		return 0;
@@ -447,15 +442,6 @@ xchk_parent_dirent(
 		return 0;
 	}
 
-	/* Does the directory offset match? */
-	if (pp->pptr.p_diroffset != child_diroffset) {
-		trace_xchk_parent_bad_dapos(sc->ip, pp->pptr.p_diroffset,
-				dp->i_ino, child_diroffset, xname.name,
-				xname.len);
-		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
-		return 0;
-	}
-
 	/*
 	 * If we're scanning a directory, we should only ever encounter a
 	 * single parent pointer, and it should match the dotdot entry.  We set
@@ -554,12 +540,12 @@ xchk_parent_scan_attr(
 		return -ECANCELED;
 	}
 
-	if (!xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+	if (!xfs_parent_valuecheck(sc->mp, namelen, value, valuelen)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
 		return -ECANCELED;
 	}
 
-	xfs_parent_irec_from_disk(&pp->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&pp->pptr, rec, namelen, value, valuelen);
 
 	error = xchk_parent_iget(pp, &dp);
 	if (error)
@@ -573,7 +559,6 @@ xchk_parent_scan_attr(
 		struct xchk_pptr	save_pp = {
 			.p_ino		= pp->pptr.p_ino,
 			.p_gen		= pp->pptr.p_gen,
-			.p_diroffset	= pp->pptr.p_diroffset,
 			.namelen	= pp->pptr.p_namelen,
 		};
 
@@ -614,28 +599,16 @@ xchk_parent_revalidate_pptr(
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
@@ -655,7 +628,6 @@ xchk_parent_slow_pptr(
 	/* Restore the saved parent pointer into the irec. */
 	pp->pptr.p_ino = pptr->p_ino;
 	pp->pptr.p_gen = pptr->p_gen;
-	pp->pptr.p_diroffset = pptr->p_diroffset;
 
 	error = xfblob_load(pp->pptr_names, pptr->name_cookie, pp->pptr.p_name,
 			pptr->namelen);
@@ -695,7 +667,7 @@ xchk_parent_slow_pptr(
 	xchk_iunlock(sc, sc->ilock_flags);
 	pp->need_revalidate = true;
 
-	trace_xchk_parent_slowpath(sc->ip, pp->namebuf, pptr->namelen,
+	trace_xchk_parent_slowpath(sc->ip, pp->pptr.p_name, pptr->namelen,
 			dp->i_ino);
 
 	while (true) {
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 05c72bfd40e8..c650a9e2bd0c 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -95,7 +95,6 @@ struct xrep_pptr {
 	/* Parent pointer attr key. */
 	xfs_ino_t			p_ino;
 	uint32_t			p_gen;
-	xfs_dir2_dataptr_t		p_diroffset;
 
 	/* Length of the pptr name. */
 	uint8_t				namelen;
@@ -127,9 +126,6 @@ struct xrep_pptrs {
 
 	/* Parent pointer names. */
 	struct xfblob		*pptr_names;
-
-	/* Buffer for validation. */
-	unsigned char		namebuf[MAXNAMELEN];
 };
 
 /* Tear down all the incore stuff we created. */
@@ -186,7 +182,6 @@ xrep_pptr_replay_update(
 
 	rp->pptr.p_ino = pptr->p_ino;
 	rp->pptr.p_gen = pptr->p_gen;
-	rp->pptr.p_diroffset = pptr->p_diroffset;
 	rp->pptr.p_namelen = pptr->namelen;
 
 	if (pptr->action == XREP_PPTR_ADD) {
@@ -261,19 +256,17 @@ STATIC int
 xrep_pptr_add_pointer(
 	struct xrep_pptrs	*rp,
 	const struct xfs_name	*name,
-	const struct xfs_inode	*dp,
-	xfs_dir2_dataptr_t	diroffset)
+	const struct xfs_inode	*dp)
 {
 	struct xrep_pptr	pptr = {
 		.action		= XREP_PPTR_ADD,
 		.namelen	= name->len,
 		.p_ino		= dp->i_ino,
 		.p_gen		= VFS_IC(dp)->i_generation,
-		.p_diroffset	= diroffset,
 	};
 	int			error;
 
-	trace_xrep_pptr_add_pointer(rp->sc->tempip, dp, diroffset, name);
+	trace_xrep_pptr_add_pointer(rp->sc->tempip, dp, name);
 
 	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
 			name->len);
@@ -291,19 +284,17 @@ STATIC int
 xrep_pptr_remove_pointer(
 	struct xrep_pptrs	*rp,
 	const struct xfs_name	*name,
-	const struct xfs_inode	*dp,
-	xfs_dir2_dataptr_t	diroffset)
+	const struct xfs_inode	*dp)
 {
 	struct xrep_pptr	pptr = {
 		.action		= XREP_PPTR_REMOVE,
 		.namelen	= name->len,
 		.p_ino		= dp->i_ino,
 		.p_gen		= VFS_IC(dp)->i_generation,
-		.p_diroffset	= diroffset,
 	};
 	int			error;
 
-	trace_xrep_pptr_remove_pointer(rp->sc->tempip, dp, diroffset, name);
+	trace_xrep_pptr_remove_pointer(rp->sc->tempip, dp, name);
 
 	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
 			name->len);
@@ -352,7 +343,7 @@ xrep_pptr_scan_dirent(
 	 * addition to the temporary file.
 	 */
 	mutex_lock(&rp->lock);
-	error = xrep_pptr_add_pointer(rp, name, dp, dapos);
+	error = xrep_pptr_add_pointer(rp, name, dp);
 	mutex_unlock(&rp->lock);
 	return error;
 }
@@ -511,13 +502,13 @@ xrep_pptr_dump_tempptr(
 	struct xrep_pptrs	*rp = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
 	struct xfs_inode	*other_ip;
-	int			pptr_namelen;
+	int			error;
 
 	if (!(attr_flags & XFS_ATTR_PARENT))
 		return 0;
 
 	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags) ||
-	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
+	    !xfs_parent_valuecheck(sc->mp, namelen, value, valuelen))
 		return -EFSCORRUPTED;
 
 	if (ip == sc->ip)
@@ -527,33 +518,19 @@ xrep_pptr_dump_tempptr(
 	else
 		return -EFSCORRUPTED;
 
-	xfs_parent_irec_from_disk(&rp->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&rp->pptr, rec, namelen, value, valuelen);
 
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
@@ -669,11 +646,9 @@ xrep_pptr_live_update(
 	    xchk_iscan_want_live_update(&rp->iscan, p->dp->i_ino)) {
 		mutex_lock(&rp->lock);
 		if (p->delta > 0)
-			error = xrep_pptr_add_pointer(rp, p->name, p->dp,
-					p->diroffset);
+			error = xrep_pptr_add_pointer(rp, p->name, p->dp);
 		else
-			error = xrep_pptr_remove_pointer(rp, p->name, p->dp,
-					p->diroffset);
+			error = xrep_pptr_remove_pointer(rp, p->name, p->dp);
 		mutex_unlock(&rp->lock);
 		if (error)
 			goto out_abort;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 911d947db787..189ef1ea207d 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -897,39 +897,6 @@ TRACE_EVENT(xchk_nlinks_live_update,
 		  __get_str(name))
 );
 
-TRACE_EVENT(xchk_parent_bad_dapos,
-	TP_PROTO(struct xfs_inode *ip, unsigned int p_diroffset,
-		 xfs_ino_t parent_ino, unsigned int dapos,
-		 const char *name, unsigned int namelen),
-	TP_ARGS(ip, p_diroffset, parent_ino, dapos, name, namelen),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(unsigned int, p_diroffset)
-		__field(xfs_ino_t, parent_ino)
-		__field(unsigned int, dapos)
-		__field(unsigned int, namelen)
-		__dynamic_array(char, name, namelen)
-	),
-	TP_fast_assign(
-		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->p_diroffset = p_diroffset;
-		__entry->parent_ino = parent_ino;
-		__entry->dapos = dapos;
-		__entry->namelen = namelen;
-		memcpy(__get_str(name), name, namelen);
-	),
-	TP_printk("dev %d:%d ino 0x%llx p_diroff 0x%x parent_ino 0x%llx parent_diroff 0x%x name '%.*s'",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->p_diroffset,
-		  __entry->parent_ino,
-		  __entry->dapos,
-		  __entry->namelen,
-		  __get_str(name))
-);
-
 DECLARE_EVENT_CLASS(xchk_pptr_class,
 	TP_PROTO(struct xfs_inode *ip, const unsigned char *name,
 		 unsigned int namelen, xfs_ino_t parent_ino),
@@ -1253,8 +1220,8 @@ TRACE_EVENT(xrep_tempfile_create,
 
 DECLARE_EVENT_CLASS(xrep_dirent_class,
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name,
-		 xfs_ino_t ino, unsigned int diroffset),
-	TP_ARGS(dp, name, ino, diroffset),
+		 xfs_ino_t ino),
+	TP_ARGS(dp, name, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, dir_ino)
@@ -1262,7 +1229,6 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 		__dynamic_array(char, name, name->len)
 		__field(xfs_ino_t, ino)
 		__field(uint8_t, ftype)
-		__field(unsigned int, diroffset)
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
@@ -1271,12 +1237,10 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 		memcpy(__get_str(name), name->name, name->len);
 		__entry->ino = ino;
 		__entry->ftype = name->type;
-		__entry->diroffset = diroffset;
 	),
-	TP_printk("dev %d:%d dir 0x%llx dapos 0x%x ftype %s name '%.*s' ino 0x%llx",
+	TP_printk("dev %d:%d dir 0x%llx ftype %s name '%.*s' ino 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->dir_ino,
-		  __entry->diroffset,
 		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
 		  __entry->namelen,
 		  __get_str(name),
@@ -1285,8 +1249,8 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 #define DEFINE_XREP_DIRENT_CLASS(name) \
 DEFINE_EVENT(xrep_dirent_class, name, \
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name, \
-		 xfs_ino_t ino, unsigned int diroffset), \
-	TP_ARGS(dp, name, ino, diroffset))
+		 xfs_ino_t ino), \
+	TP_ARGS(dp, name, ino))
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_add_dirent);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_remove_dirent);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_createname);
@@ -1294,7 +1258,6 @@ DEFINE_XREP_DIRENT_CLASS(xrep_dir_removename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_replacename);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_dumpname);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_checkname);
-DEFINE_XREP_DIRENT_CLASS(xrep_dir_badposname);
 
 DECLARE_EVENT_CLASS(xrep_dir_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),
@@ -1329,7 +1292,6 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 		__field(xfs_ino_t, ino)
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
-		__field(unsigned int, parent_diroffset)
 		__field(unsigned int, namelen)
 		__dynamic_array(char, name, pptr->p_namelen)
 	),
@@ -1338,16 +1300,14 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 		__entry->ino = ip->i_ino;
 		__entry->parent_ino = pptr->p_ino;
 		__entry->parent_gen = pptr->p_gen;
-		__entry->parent_diroffset = pptr->p_diroffset;
 		__entry->namelen = pptr->p_namelen;
 		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
 	),
-	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x parent_dapos 0x%x name '%.*s'",
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->parent_ino,
 		  __entry->parent_gen,
-		  __entry->parent_diroffset,
 		  __entry->namelen,
 		  __get_str(name))
 )
@@ -1362,14 +1322,13 @@ DEFINE_XREP_PPTR_CLASS(xrep_pptr_checkname);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
-		 unsigned int diroffset, const struct xfs_name *name),
-	TP_ARGS(ip, dp, diroffset, name),
+		 const struct xfs_name *name),
+	TP_ARGS(ip, dp, name),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
-		__field(unsigned int, parent_diroffset)
 		__field(unsigned int, namelen)
 		__dynamic_array(char, name, name->len)
 	),
@@ -1378,24 +1337,22 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 		__entry->ino = ip->i_ino;
 		__entry->parent_ino = dp->i_ino;
 		__entry->parent_gen = VFS_IC(dp)->i_generation;
-		__entry->parent_diroffset = diroffset;
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
 	),
-	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x parent_dapos 0x%x name '%.*s'",
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->parent_ino,
 		  __entry->parent_gen,
-		  __entry->parent_diroffset,
 		  __entry->namelen,
 		  __get_str(name))
 )
 #define DEFINE_XREP_PPTR_SCAN_CLASS(name) \
 DEFINE_EVENT(xrep_pptr_scan_class, name, \
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp, \
-		 unsigned int diroffset, const struct xfs_name *name), \
-	TP_ARGS(ip, dp, diroffset, name))
+		 const struct xfs_name *name), \
+	TP_ARGS(ip, dp, name))
 DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_add_pointer);
 DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_remove_pointer);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c90b0a67c2b3..144955377d99 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1202,8 +1202,7 @@ xfs_create(
 	 * the parent information now.
 	 */
 	if (parent) {
-		error = xfs_parent_add(tp, parent, dp, name, diroffset,
-					     ip);
+		error = xfs_parent_add(tp, parent, dp, name, ip);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -1477,8 +1476,7 @@ xfs_link(
 	 * the parent to the inode.
 	 */
 	if (parent) {
-		error = xfs_parent_add(tp, parent, tdp, target_name,
-					     diroffset, sip);
+		error = xfs_parent_add(tp, parent, tdp, target_name, sip);
 		if (error)
 			goto error_return;
 	}
@@ -2750,7 +2748,7 @@ xfs_remove(
 	}
 
 	if (parent) {
-		error = xfs_parent_remove(tp, dp, parent, dir_offset, ip);
+		error = xfs_parent_remove(tp, parent, dp, name, ip);
 		if (error)
 			goto out_trans_cancel;
 	}
@@ -3061,13 +3059,13 @@ xfs_cross_rename(
 	}
 
 	if (xfs_has_parent(mp)) {
-		error = xfs_parent_replace(tp, ip1_pptr, dp1,
-				old_diroffset, name2, dp2, new_diroffset, ip1);
+		error = xfs_parent_replace(tp, ip1_pptr, dp1, name1, dp2,
+				name2, ip1);
 		if (error)
 			goto out_trans_abort;
 
-		error = xfs_parent_replace(tp, ip2_pptr, dp2,
-				new_diroffset, name1, dp1, old_diroffset, ip2);
+		error = xfs_parent_replace(tp, ip2_pptr, dp2, name2, dp1,
+				name1, ip2);
 		if (error)
 			goto out_trans_abort;
 	}
@@ -3540,25 +3538,21 @@ xfs_rename(
 		goto out_trans_cancel;
 
 	if (wip_pptr) {
-		error = xfs_parent_add(tp, wip_pptr,
-					     src_dp, src_name,
-					     old_diroffset, wip);
+		error = xfs_parent_add(tp, wip_pptr, src_dp, src_name, wip);
 		if (error)
 			goto out_trans_cancel;
 	}
 
 	if (src_ip_pptr) {
-		error = xfs_parent_replace(tp, src_ip_pptr, src_dp,
-				old_diroffset, target_name, target_dp,
-				new_diroffset, src_ip);
+		error = xfs_parent_replace(tp, src_ip_pptr, src_dp, src_name,
+				target_dp, target_name, src_ip);
 		if (error)
 			goto out_trans_cancel;
 	}
 
 	if (tgt_ip_pptr) {
-		error = xfs_parent_remove(tp, target_dp,
-						tgt_ip_pptr,
-						new_diroffset, target_ip);
+		error = xfs_parent_remove(tp, tgt_ip_pptr, target_dp,
+				target_name, target_ip);
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 88f9ec393c3d..aa07858a6a6d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -114,6 +114,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	12);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 5a4f72cd5711..0c1dcd726472 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -67,12 +67,14 @@ xfs_getparent_listent(
 	 * pointer.  The attr list functions filtered out INCOMPLETE attrs.
 	 */
 	if (XFS_IS_CORRUPT(mp, !xfs_parent_namecheck(mp, rec, namelen, flags)) ||
-	    XFS_IS_CORRUPT(mp, !xfs_parent_valuecheck(mp, value, valuelen))) {
+	    XFS_IS_CORRUPT(mp, !xfs_parent_valuecheck(mp, namelen, value,
+						      valuelen))) {
 		context->seen_enough = -EFSCORRUPTED;
 		return;
 	}
 
-	xfs_parent_irec_from_disk(&gp->pptr_irec, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&gp->pptr_irec, rec, namelen, value,
+			valuelen);
 
 	/*
 	 * We found a parent pointer, but we've filled up the buffer.  Signal
@@ -93,7 +95,7 @@ xfs_getparent_listent(
 	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
 	pptr->gpr_ino = irec->p_ino;
 	pptr->gpr_gen = irec->p_gen;
-	pptr->gpr_diroffset = irec->p_diroffset;
+	pptr->gpr_rsvd2 = 0;
 	pptr->gpr_rsvd = 0;
 
 	memcpy(pptr->gpr_name, irec->p_name, irec->p_namelen);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7fc58bee231d..e6995a44cce2 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -348,8 +348,7 @@ xfs_symlink(
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 
 	if (parent) {
-		error = xfs_parent_add(tp, parent, dp, link_name,
-					     diroffset, ip);
+		error = xfs_parent_add(tp, parent, dp, link_name, ip);
 		if (error)
 			goto out_trans_cancel;
 	}

