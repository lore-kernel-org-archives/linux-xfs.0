Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FB6C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjBPUwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPUwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:52:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7314BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:52:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E8DEB826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B9CC433D2;
        Thu, 16 Feb 2023 20:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580717;
        bh=1QQ4YKVV3q3epL//tNJthSQ5tN/ABhaEBLd7Kyb7l7E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=E6RJT/7ggF9IUO3pG8L6JFdHNOm5GNQqTyA/foqqifnx6WfjQzaUWq2bU8NsJMSXn
         NbDAeLf/AVRag+SGEQlDcmIy3qujNxBSPA11gw3PA46i3+2JnCFz6o789V8rdq7hqn
         vqxnYZStt+Y7Qmq8NlNBRRYTp7TIIBn172cwfqGg5VYry1m2PJE07o8bnRjka1nOrS
         tcrZA9NrZAoZN+2i5TKA5wCJ5oLj9GJShI2rbsIVVoS3KbbQFiAxOtYGOcAP4MSQY8
         CqrJza91nikGoyatT5Udgiuo1YxZwOtqVg3alyLEPB9jkAMdTERa+wWX1gcqZTDLmS
         taaOSUxWpN2Bg==
Date:   Thu, 16 Feb 2023 12:51:57 -0800
Subject: [PATCH 2/5] xfs: replace parent pointer diroffset with sha512 hash of
 name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875894.3475422.15148689769962427834.stgit@magnolia>
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

Replace the diroffset with the sha512 hash of the dirent name, thereby
eliminating the need for directory repair to update all the parent
pointers after rebuilding the directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   15 +++--
 fs/xfs/libxfs/xfs_fs.h        |    4 +
 fs/xfs/libxfs/xfs_parent.c    |  125 +++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_parent.h    |   21 ++++---
 fs/xfs/scrub/dir.c            |   12 +++-
 fs/xfs/scrub/dir_repair.c     |   83 ++++++++-------------------
 fs/xfs/scrub/parent.c         |   43 ++++++++++----
 fs/xfs/scrub/parent_repair.c  |   27 ++++-----
 fs/xfs/scrub/trace.h          |   48 +++++-----------
 fs/xfs/xfs_inode.c            |   30 ++++------
 fs/xfs/xfs_ondisk.h           |    4 +
 fs/xfs/xfs_parent_utils.c     |    2 -
 fs/xfs/xfs_sha512.h           |   42 ++++++++++++++
 fs/xfs/xfs_symlink.c          |    3 -
 14 files changed, 271 insertions(+), 188 deletions(-)
 create mode 100644 fs/xfs/xfs_sha512.h


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index c07b8166e8ff..386f63b262d5 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -824,17 +824,22 @@ static inline unsigned int xfs_dir2_dirblock_bytes(struct xfs_sb *sbp)
 xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 				      struct xfs_da3_blkinfo *hdr3);
 
+/* We use sha512 for the parent pointer name hash. */
+#define XFS_PARENT_NAME_HASH_SIZE	(64)
+
 /*
  * Parent pointer attribute format definition
  *
- * EA name encodes the parent inode number, generation and the offset of
- * the dirent that points to the child inode. The EA value contains the
- * same name as the dirent in the parent directory.
+ * The EA name encodes the parent inode number, generation and a collision
+ * resistant hash computed from the dirent name.  The hash is defined to be the
+ * sha512 of the child inode generation and the dirent name.
+ *
+ * The EA value contains the same name as the dirent in the parent directory.
  */
 struct xfs_parent_name_rec {
 	__be64  p_ino;
 	__be32  p_gen;
-	__be32  p_diroffset;
-};
+	__u8	p_namehash[XFS_PARENT_NAME_HASH_SIZE];
+} __attribute__((packed));
 
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 9e59a1fdfb0c..c65345d2ba7a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -770,8 +770,8 @@ struct xfs_scrub_metadata {
 struct xfs_parent_ptr {
 	__u64		xpp_ino;			/* Inode */
 	__u32		xpp_gen;			/* Inode generation */
-	__u32		xpp_diroffset;			/* Directory offset */
-	__u64		xpp_rsvd;			/* Reserved */
+	__u32		xpp_rsvd;			/* Reserved */
+	__u64		xpp_rsvd2;			/* Reserved */
 	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
 };
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index a2575bf44c89..a28dcf18cb4d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -26,6 +26,7 @@
 #include "xfs_xattr.h"
 #include "xfs_parent.h"
 #include "xfs_trans_space.h"
+#include "xfs_sha512.h"
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
@@ -54,7 +55,6 @@ xfs_parent_namecheck(
 	unsigned int				attr_flags)
 {
 	xfs_ino_t				p_ino;
-	xfs_dir2_dataptr_t			p_diroffset;
 
 	if (reclen != sizeof(struct xfs_parent_name_rec))
 		return false;
@@ -67,10 +67,6 @@ xfs_parent_namecheck(
 	if (!xfs_verify_ino(mp, p_ino))
 		return false;
 
-	p_diroffset = be32_to_cpu(rec->p_diroffset);
-	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
-		return false;
-
 	return true;
 }
 
@@ -91,18 +87,17 @@ xfs_parent_valuecheck(
 }
 
 /* Initializes a xfs_parent_name_rec to be stored as an attribute name */
-static inline void
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
-
-	rec->p_ino = cpu_to_be64(p_ino);
-	rec->p_gen = cpu_to_be32(p_gen);
-	rec->p_diroffset = cpu_to_be32(p_diroffset);
+	rec->p_ino = cpu_to_be64(dp->i_ino);
+	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
+	return xfs_parent_namehash(ip, name, rec->p_namehash,
+			sizeof(rec->p_namehash));
 }
 
 /*
@@ -118,7 +113,7 @@ xfs_parent_irec_from_disk(
 {
 	irec->p_ino = be64_to_cpu(rec->p_ino);
 	irec->p_gen = be32_to_cpu(rec->p_gen);
-	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+	memcpy(irec->p_namehash, rec->p_namehash, sizeof(irec->p_namehash));
 
 	if (!value) {
 		irec->p_namelen = 0;
@@ -148,7 +143,7 @@ xfs_parent_irec_to_disk(
 {
 	rec->p_ino = cpu_to_be64(irec->p_ino);
 	rec->p_gen = cpu_to_be32(irec->p_gen);
-	rec->p_diroffset = cpu_to_be32(irec->p_diroffset);
+	memcpy(rec->p_namehash, irec->p_namehash, sizeof(rec->p_namehash));
 
 	if (valuelen) {
 		ASSERT(*valuelen > 0);
@@ -208,12 +203,15 @@ xfs_parent_add(
 	struct xfs_parent_defer	*parent,
 	struct xfs_inode	*dp,
 	const struct xfs_name	*parent_name,
-	xfs_dir2_dataptr_t	diroffset,
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
+	int			error;
+
+	error = xfs_init_parent_name_rec(&parent->rec, dp, parent_name, child);
+	if (error)
+		return error;
 
-	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	args->trans = tp;
@@ -230,14 +228,18 @@ xfs_parent_add(
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
+	int			error;
+
+	error = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
+	if (error)
+		return error;
 
-	xfs_init_parent_name_rec(&parent->rec, dp, diroffset);
 	args->trans = tp;
 	args->dp = child;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -250,16 +252,23 @@ xfs_parent_replace(
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
+	int			error;
+
+	error = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
+			old_name, child);
+	if (error)
+		return error;
+	error = xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_name,
+			child);
+	if (error)
+		return error;
 
-	xfs_init_parent_name_rec(&new_parent->old_rec, old_dp, old_diroffset);
-	xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_diroffset);
 	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
 	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
 	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
@@ -267,9 +276,8 @@ xfs_parent_replace(
 	args->trans = tp;
 	args->dp = child;
 
-	ASSERT(parent_name != NULL);
-	new_parent->args.value = (void *)parent_name->name;
-	new_parent->args.valuelen = parent_name->len;
+	new_parent->args.value = (void *)new_name->name;
+	new_parent->args.valuelen = new_name->len;
 
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return xfs_attr_defer_replace(args);
@@ -388,3 +396,62 @@ xfs_parent_unset(
 
 	return xfs_attr_set(&scr->args);
 }
+
+/*
+ * Compute the parent pointer namehash for the given child file and dirent
+ * name.
+ */
+int
+xfs_parent_namehash(
+	struct xfs_inode	*ip,
+	const struct xfs_name	*name,
+	void			*namehash,
+	unsigned int		namehash_len)
+{
+	SHA512_DESC_ON_STACK(ip->i_mount, shash);
+	__be32			gen = cpu_to_be32(VFS_I(ip)->i_generation);
+	int			error;
+
+	ASSERT(SHA512_DIGEST_SIZE ==
+			crypto_shash_digestsize(ip->i_mount->m_sha512));
+
+	if (namehash_len != SHA512_DIGEST_SIZE) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	error = sha512_init(&shash);
+	if (error)
+		goto out;
+
+	error = sha512_process(&shash, (const u8 *)&gen, sizeof(gen));
+	if (error)
+		goto out;
+
+	error = sha512_process(&shash, name->name, name->len);
+	if (error)
+		goto out;
+
+	error = sha512_done(&shash, namehash);
+	if (error)
+		goto out;
+
+out:
+	sha512_erase(&shash);
+	return error;
+}
+
+/* Recalculate the name hash of this parent pointer. */
+int
+xfs_parent_irec_hash(
+	struct xfs_inode		*ip,
+	struct xfs_parent_name_irec	*pptr)
+{
+	struct xfs_name			xname = {
+		.name			= pptr->p_name,
+		.len			= pptr->p_namelen,
+	};
+
+	return xfs_parent_namehash(ip, &xname, &pptr->p_namehash,
+			sizeof(pptr->p_namehash));
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index a7fc621b82c4..d3f2841e0f6e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,7 +23,7 @@ struct xfs_parent_name_irec {
 	/* Key fields for looking up a particular parent pointer. */
 	xfs_ino_t		p_ino;
 	uint32_t		p_gen;
-	xfs_dir2_dataptr_t	p_diroffset;
+	uint8_t			p_namehash[XFS_PARENT_NAME_HASH_SIZE];
 
 	/* Attributes of a parent pointer. */
 	uint8_t			p_namelen;
@@ -79,15 +79,14 @@ xfs_parent_start_locked(
 
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
 
@@ -100,6 +99,12 @@ xfs_parent_finish(
 		__xfs_parent_cancel(mp, p);
 }
 
+int xfs_parent_namehash(struct xfs_inode *ip, const struct xfs_name *name,
+		void *namehash, unsigned int namehash_len);
+
+int xfs_parent_irec_hash(struct xfs_inode *ip,
+		struct xfs_parent_name_irec *pptr);
+
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 3f3223e563ae..2494947a0c93 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -139,16 +139,20 @@ xchk_dir_lock_child(
 STATIC int
 xchk_dir_parent_pointer(
 	struct xchk_dir		*sd,
-	xfs_dir2_dataptr_t	dapos,
 	const struct xfs_name	*name,
 	struct xfs_inode	*ip)
 {
 	struct xfs_scrub	*sc = sd->sc;
 	int			pptr_namelen;
+	int			error;
 
 	sd->pptr.p_ino = sc->ip->i_ino;
 	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
-	sd->pptr.p_diroffset = dapos;
+
+	error = xfs_parent_namehash(ip, name, &sd->pptr.p_namehash,
+			sizeof(sd->pptr.p_namehash));
+	if (error)
+		return error;
 
 	pptr_namelen = xfs_parent_lookup(sc->tp, ip, &sd->pptr, sd->namebuf,
 			MAXNAMELEN, &sd->pptr_scratch);
@@ -216,7 +220,7 @@ xchk_dir_check_pptr_fast(
 		return 0;
 	}
 
-	error = xchk_dir_parent_pointer(sd, dapos, name, ip);
+	error = xchk_dir_parent_pointer(sd, name, ip);
 	xfs_iunlock(ip, lockmode);
 	return error;
 }
@@ -1041,7 +1045,7 @@ xchk_dir_slow_dirent(
 		goto out_unlock;
 
 check_pptr:
-	error = xchk_dir_parent_pointer(sd, dirent->diroffset, &xname, ip);
+	error = xchk_dir_parent_pointer(sd, &xname, ip);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 out_rele:
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index ec48b3268809..c0b2b78da277 100644
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
@@ -773,7 +761,6 @@ xrep_dir_dump_tempdir(
 	struct xrep_dir		*rd = priv;
 	xfs_ino_t		child_ino;
 	bool			child = true;
-	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
 	int			error;
 
 	/*
@@ -800,7 +787,7 @@ xrep_dir_dump_tempdir(
 		ino = sc->ip->i_ino;
 	}
 
-	trace_xrep_dir_dumpname(sc->tempip, name, ino, dapos);
+	trace_xrep_dir_dumpname(sc->tempip, name, ino);
 
 	if (!child)
 		return 0;
@@ -812,17 +799,15 @@ xrep_dir_dump_tempdir(
 	 * and reap it responsibly, but I didn't feel like porting all that.
 	 */
 	mutex_lock(&rd->lock);
-	error = xrep_dir_remove_dirent(rd, name, ino, dapos);
+	error = xrep_dir_remove_dirent(rd, name, ino);
 	mutex_unlock(&rd->lock);
 	if (error)
 		return error;
 
 	/* Check that the dir being repaired has the same entry. */
-	error = xchk_dir_lookup(sc, sc->ip, name, &child_ino,
-			&child_diroffset);
+	error = xchk_dir_lookup(sc, sc->ip, name, &child_ino, NULL);
 	if (error == -ENOENT) {
-		trace_xrep_dir_checkname(sc->ip, name, NULLFSINO,
-				XFS_DIR2_NULL_DATAPTR);
+		trace_xrep_dir_checkname(sc->ip, name, NULLFSINO);
 		ASSERT(error != -ENOENT);
 		return -EFSCORRUPTED;
 	}
@@ -830,18 +815,11 @@ xrep_dir_dump_tempdir(
 		return error;
 
 	if (ino != child_ino) {
-		trace_xrep_dir_checkname(sc->ip, name, child_ino,
-				child_diroffset);
+		trace_xrep_dir_checkname(sc->ip, name, child_ino);
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
 
@@ -860,7 +838,6 @@ xrep_dir_dump_baddir(
 	void			*priv)
 {
 	xfs_ino_t		child_ino;
-	xfs_dir2_dataptr_t	child_diroffset = XFS_DIR2_NULL_DATAPTR;
 	int			error;
 
 	/* Ignore the directory's dot and dotdot entries. */
@@ -868,14 +845,12 @@ xrep_dir_dump_baddir(
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
@@ -883,18 +858,11 @@ xrep_dir_dump_baddir(
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
 
@@ -1011,11 +979,10 @@ xrep_dir_live_update(
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
@@ -1030,12 +997,12 @@ xrep_dir_live_update(
 		mutex_lock(&rd->lock);
 		if (p->delta > 0) {
 			trace_xrep_dir_add_dirent(sc->tempip, &xfs_name_dotdot,
-					p->dp->i_ino, 0);
+					p->dp->i_ino);
 
 			rd->parent_ino = p->dp->i_ino;
 		} else {
 			trace_xrep_dir_remove_dirent(sc->tempip,
-					&xfs_name_dotdot, NULLFSINO, 0);
+					&xfs_name_dotdot, NULLFSINO);
 
 			rd->parent_ino = NULLFSINO;
 		}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 14f16fefd1b0..53872a7be942 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -323,7 +323,6 @@ struct xchk_pptr {
 	/* Parent pointer attr key. */
 	xfs_ino_t			p_ino;
 	uint32_t			p_gen;
-	xfs_dir2_dataptr_t		p_diroffset;
 
 	/* Length of the pptr name. */
 	uint8_t				namelen;
@@ -350,6 +349,9 @@ struct xchk_pptrs {
 	/* xattr key and da args for parent pointer revalidation. */
 	struct xfs_parent_scratch pptr_scratch;
 
+	/* Name hashes */
+	uint8_t			child_namehash[XFS_PARENT_NAME_HASH_SIZE];
+
 	/* Name buffer for revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
 };
@@ -426,14 +428,13 @@ xchk_parent_dirent(
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
@@ -447,15 +448,6 @@ xchk_parent_dirent(
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
@@ -534,6 +526,7 @@ xchk_parent_scan_attr(
 	unsigned int		valuelen,
 	void			*priv)
 {
+	struct xfs_name		xname = { };
 	struct xchk_pptrs	*pp = priv;
 	struct xfs_inode	*dp = NULL;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
@@ -561,6 +554,26 @@ xchk_parent_scan_attr(
 
 	xfs_parent_irec_from_disk(&pp->pptr, rec, value, valuelen);
 
+	xname.name = pp->pptr.p_name;
+	xname.len = pp->pptr.p_namelen;
+
+	/*
+	 * Does the namehash in the parent pointer match the actual name?
+	 * If not, there's no point in checking further.
+	 */
+	error = xfs_parent_namehash(sc->ip, &xname, pp->child_namehash,
+			sizeof(pp->child_namehash));
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	if (memcmp(pp->pptr.p_namehash, pp->child_namehash,
+				sizeof(pp->pptr.p_namehash))) {
+		trace_xchk_parent_bad_namehash(sc->ip, pp->pptr.p_ino,
+				xname.name, xname.len);
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
 	error = xchk_parent_iget(pp, &dp);
 	if (error)
 		return error;
@@ -573,7 +586,6 @@ xchk_parent_scan_attr(
 		struct xchk_pptr	save_pp = {
 			.p_ino		= pp->pptr.p_ino,
 			.p_gen		= pp->pptr.p_gen,
-			.p_diroffset	= pp->pptr.p_diroffset,
 			.namelen	= pp->pptr.p_namelen,
 		};
 
@@ -655,7 +667,6 @@ xchk_parent_slow_pptr(
 	/* Restore the saved parent pointer into the irec. */
 	pp->pptr.p_ino = pptr->p_ino;
 	pp->pptr.p_gen = pptr->p_gen;
-	pp->pptr.p_diroffset = pptr->p_diroffset;
 
 	error = xfblob_load(pp->pptr_names, pptr->name_cookie, pp->pptr.p_name,
 			pptr->namelen);
@@ -664,6 +675,10 @@ xchk_parent_slow_pptr(
 	pp->pptr.p_name[MAXNAMELEN - 1] = 0;
 	pp->pptr.p_namelen = pptr->namelen;
 
+	error = xfs_parent_irec_hash(sc->ip, &pp->pptr);
+	if (error)
+		return error;
+
 	/* Check that the deferred parent pointer still exists. */
 	if (pp->need_revalidate) {
 		error = xchk_parent_revalidate_pptr(pp);
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 56b47bf2807b..51432ab61c94 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -95,7 +95,6 @@ struct xrep_pptr {
 	/* Parent pointer attr key. */
 	xfs_ino_t			p_ino;
 	uint32_t			p_gen;
-	xfs_dir2_dataptr_t		p_diroffset;
 
 	/* Length of the pptr name. */
 	uint8_t				namelen;
@@ -183,12 +182,16 @@ xrep_pptr_replay_update(
 	const struct xrep_pptr	*pptr)
 {
 	struct xfs_scrub	*sc = rp->sc;
+	int			error;
 
 	rp->pptr.p_ino = pptr->p_ino;
 	rp->pptr.p_gen = pptr->p_gen;
-	rp->pptr.p_diroffset = pptr->p_diroffset;
 	rp->pptr.p_namelen = pptr->namelen;
 
+	error = xfs_parent_irec_hash(sc->ip, &rp->pptr);
+	if (error)
+		return error;
+
 	if (pptr->action == XREP_PPTR_ADD) {
 		/* Create parent pointer. */
 		trace_xrep_pptr_createname(sc->tempip, &rp->pptr);
@@ -261,19 +264,17 @@ STATIC int
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
@@ -291,19 +292,17 @@ STATIC int
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
@@ -352,7 +351,7 @@ xrep_pptr_scan_dirent(
 	 * addition to the temporary file.
 	 */
 	mutex_lock(&rp->lock);
-	error = xrep_pptr_add_pointer(rp, name, dp, dapos);
+	error = xrep_pptr_add_pointer(rp, name, dp);
 	mutex_unlock(&rp->lock);
 	return error;
 }
@@ -646,11 +645,9 @@ xrep_pptr_live_update(
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
index 911d947db787..1af148d7617e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -897,35 +897,28 @@ TRACE_EVENT(xchk_nlinks_live_update,
 		  __get_str(name))
 );
 
-TRACE_EVENT(xchk_parent_bad_dapos,
-	TP_PROTO(struct xfs_inode *ip, unsigned int p_diroffset,
-		 xfs_ino_t parent_ino, unsigned int dapos,
-		 const char *name, unsigned int namelen),
-	TP_ARGS(ip, p_diroffset, parent_ino, dapos, name, namelen),
+TRACE_EVENT(xchk_parent_bad_namehash,
+	TP_PROTO(struct xfs_inode *ip, xfs_ino_t parent_ino, const char *name,
+		unsigned int namelen),
+	TP_ARGS(ip, parent_ino, name, namelen),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(unsigned int, p_diroffset)
 		__field(xfs_ino_t, parent_ino)
-		__field(unsigned int, dapos)
 		__field(unsigned int, namelen)
 		__dynamic_array(char, name, namelen)
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->p_diroffset = p_diroffset;
 		__entry->parent_ino = parent_ino;
-		__entry->dapos = dapos;
 		__entry->namelen = namelen;
 		memcpy(__get_str(name), name, namelen);
 	),
-	TP_printk("dev %d:%d ino 0x%llx p_diroff 0x%x parent_ino 0x%llx parent_diroff 0x%x name '%.*s'",
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->p_diroffset,
 		  __entry->parent_ino,
-		  __entry->dapos,
 		  __entry->namelen,
 		  __get_str(name))
 );
@@ -1253,8 +1246,8 @@ TRACE_EVENT(xrep_tempfile_create,
 
 DECLARE_EVENT_CLASS(xrep_dirent_class,
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name,
-		 xfs_ino_t ino, unsigned int diroffset),
-	TP_ARGS(dp, name, ino, diroffset),
+		 xfs_ino_t ino),
+	TP_ARGS(dp, name, ino),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, dir_ino)
@@ -1262,7 +1255,6 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 		__dynamic_array(char, name, name->len)
 		__field(xfs_ino_t, ino)
 		__field(uint8_t, ftype)
-		__field(unsigned int, diroffset)
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
@@ -1271,12 +1263,10 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
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
@@ -1285,8 +1275,8 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
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
@@ -1329,7 +1319,6 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 		__field(xfs_ino_t, ino)
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
-		__field(unsigned int, parent_diroffset)
 		__field(unsigned int, namelen)
 		__dynamic_array(char, name, pptr->p_namelen)
 	),
@@ -1338,16 +1327,14 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
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
@@ -1362,14 +1349,13 @@ DEFINE_XREP_PPTR_CLASS(xrep_pptr_checkname);
 
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
@@ -1378,24 +1364,22 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
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
index 09b0ac6b99cb..4cd9a4fea5e0 100644
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
index 6a6bd05c2a68..2dc1eef63d96 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_ONDISK_H
 #define __XFS_ONDISK_H
 
+#include <crypto/sha2.h>
+
 #define XFS_CHECK_STRUCT_SIZE(structname, size) \
 	BUILD_BUG_ON_MSG(sizeof(structname) != (size), "XFS: sizeof(" \
 		#structname ") is wrong, expected " #size)
@@ -114,6 +116,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	76);
+	BUILD_BUG_ON(XFS_PARENT_NAME_HASH_SIZE != SHA512_DIGEST_SIZE);
 
 	/* log structures */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_buf_log_format,	88);
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 5ff7d38bc375..65bec3875308 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -83,7 +83,7 @@ xfs_getparent_listent(
 	pptr = &ppi->pi_parents[ppi->pi_ptrs_used++];
 	pptr->xpp_ino = irec->p_ino;
 	pptr->xpp_gen = irec->p_gen;
-	pptr->xpp_diroffset = irec->p_diroffset;
+	pptr->xpp_rsvd2 = 0;
 	pptr->xpp_rsvd = 0;
 
 	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
diff --git a/fs/xfs/xfs_sha512.h b/fs/xfs/xfs_sha512.h
new file mode 100644
index 000000000000..d9756db63aa6
--- /dev/null
+++ b/fs/xfs/xfs_sha512.h
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SHA512_H__
+#define __XFS_SHA512_H__
+
+struct sha512_state {
+	union {
+		struct shash_desc desc;
+		char __desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE];
+	};
+};
+
+#define SHA512_DESC_ON_STACK(mp, name) \
+	struct sha512_state name = { .desc.tfm = (mp)->m_sha512 }
+
+#define SHA512_DIGEST_SIZE	64
+
+static inline int sha512_init(struct sha512_state *md)
+{
+	return crypto_shash_init(&md->desc);
+}
+
+static inline int sha512_done(struct sha512_state *md, unsigned char *out)
+{
+	return crypto_shash_final(&md->desc, out);
+}
+
+static inline int sha512_process(struct sha512_state *md,
+		const unsigned char *in, unsigned long inlen)
+{
+	return crypto_shash_update(&md->desc, in, inlen);
+}
+
+static inline void sha512_erase(struct sha512_state *md)
+{
+	memset(md, 0, sizeof(*md));
+}
+
+#endif /* __XFS_SHA512_H__ */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 63e68e832551..327c805815dc 100644
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

