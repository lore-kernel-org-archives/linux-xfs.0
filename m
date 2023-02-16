Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BF3C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBPUwS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUwR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:52:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225AF4BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:52:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC052B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED27C433EF;
        Thu, 16 Feb 2023 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580733;
        bh=FpUmytAPniEy1oYQnImTCN6lEp90tRtoqgQ2Wj4WE3E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iMzsSRHSQ9Ykd7Bkj2xal9v1gJx1m0aihfaFikGu+YVY5kZKojZYzc1SYPrfsy2Yu
         QySMkEQ6ATcYDaxSYZwm+Uyc0BpDQ31hIFbCJfMd9P4ojdhSy8TKimfpnytE6kGVGo
         YKq0Axa67Td+adX2NtLb2cioISJ1oSVU6ALEXIS4ouSsc5JcltWOotedtiaSyMtQwU
         kQR0hxGqbAnd/6oF1igUxPdQvJxj8vpxFQ3jYqUpnrNb1nJqY/Or6E+pAlKkVJzqGw
         SW+6O8x49tLkIho/Cp3y+QdriQ3qwHxc++xzJLFqUbr58jFZzWtzxcyfMY5zp9117k
         gxMMK2uuJzDbg==
Date:   Thu, 16 Feb 2023 12:52:12 -0800
Subject: [PATCH 3/5] xfs: skip the sha512 namehash when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875909.3475422.13864721417258672651.stgit@magnolia>
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

Reduce the size and performance impacts of parent pointer name hashes by
using the dirent name as the hash if the dirent name is shorter than a
sha512 hash would be.  IOWs, we only use sha512 for names longer than 63
bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |   21 +++++++++-
 fs/xfs/libxfs/xfs_parent.c    |   85 +++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_parent.h    |    8 ++--
 fs/xfs/scrub/dir.c            |   12 ++++--
 fs/xfs/scrub/dir_repair.c     |    2 -
 fs/xfs/scrub/parent.c         |   16 +++++---
 fs/xfs/scrub/parent_repair.c  |    2 -
 fs/xfs/xfs_parent_utils.c     |    2 -
 8 files changed, 101 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 386f63b262d5..275357506394 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -831,8 +831,11 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
  * Parent pointer attribute format definition
  *
  * The EA name encodes the parent inode number, generation and a collision
- * resistant hash computed from the dirent name.  The hash is defined to be the
- * sha512 of the child inode generation and the dirent name.
+ * resistant hash computed from the dirent name.  The hash is defined to be:
+ *
+ * - The dirent name if it fits within the EA name.
+ *
+ * - The sha512 of the child inode generation and the dirent name.
  *
  * The EA value contains the same name as the dirent in the parent directory.
  */
@@ -842,4 +845,18 @@ struct xfs_parent_name_rec {
 	__u8	p_namehash[XFS_PARENT_NAME_HASH_SIZE];
 } __attribute__((packed));
 
+static inline unsigned int
+xfs_parent_name_rec_sizeof(
+	unsigned int		hashlen)
+{
+	return offsetof(struct xfs_parent_name_rec, p_namehash) + hashlen;
+}
+
+static inline unsigned int
+xfs_parent_name_hashlen(
+	unsigned int		rec_sizeof)
+{
+	return rec_sizeof - offsetof(struct xfs_parent_name_rec, p_namehash);
+}
+
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index a28dcf18cb4d..32235a0e9e0d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -56,7 +56,8 @@ xfs_parent_namecheck(
 {
 	xfs_ino_t				p_ino;
 
-	if (reclen != sizeof(struct xfs_parent_name_rec))
+	if (reclen <= xfs_parent_name_rec_sizeof(0) ||
+	    reclen > xfs_parent_name_rec_sizeof(XFS_PARENT_NAME_HASH_SIZE))
 		return false;
 
 	/* Only one namespace bit allowed. */
@@ -108,12 +109,16 @@ void
 xfs_parent_irec_from_disk(
 	struct xfs_parent_name_irec	*irec,
 	const struct xfs_parent_name_rec *rec,
+	int				reclen,
 	const void			*value,
 	int				valuelen)
 {
 	irec->p_ino = be64_to_cpu(rec->p_ino);
 	irec->p_gen = be32_to_cpu(rec->p_gen);
-	memcpy(irec->p_namehash, rec->p_namehash, sizeof(irec->p_namehash));
+	irec->hashlen = xfs_parent_name_hashlen(reclen);
+	memcpy(irec->p_namehash, rec->p_namehash, irec->hashlen);
+	memset(irec->p_namehash + irec->hashlen, 0,
+			sizeof(irec->p_namehash) - irec->hashlen);
 
 	if (!value) {
 		irec->p_namelen = 0;
@@ -137,13 +142,15 @@ xfs_parent_irec_from_disk(
 void
 xfs_parent_irec_to_disk(
 	struct xfs_parent_name_rec	*rec,
+	int				*reclen,
 	void				*value,
 	int				*valuelen,
 	const struct xfs_parent_name_irec *irec)
 {
 	rec->p_ino = cpu_to_be64(irec->p_ino);
 	rec->p_gen = cpu_to_be32(irec->p_gen);
-	memcpy(rec->p_namehash, irec->p_namehash, sizeof(rec->p_namehash));
+	*reclen = xfs_parent_name_rec_sizeof(irec->hashlen);
+	memcpy(rec->p_namehash, irec->p_namehash, irec->hashlen);
 
 	if (valuelen) {
 		ASSERT(*valuelen > 0);
@@ -206,12 +213,14 @@ xfs_parent_add(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
-	int			error;
+	int			hashlen;
 
-	error = xfs_init_parent_name_rec(&parent->rec, dp, parent_name, child);
-	if (error)
-		return error;
+	hashlen = xfs_init_parent_name_rec(&parent->rec, dp, parent_name,
+			child);
+	if (hashlen < 0)
+		return hashlen;
 
+	args->namelen = xfs_parent_name_rec_sizeof(hashlen);
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 
 	args->trans = tp;
@@ -234,12 +243,13 @@ xfs_parent_remove(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &parent->args;
-	int			error;
+	int			hashlen;
 
-	error = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
-	if (error)
-		return error;
+	hashlen = xfs_init_parent_name_rec(&parent->rec, dp, name, child);
+	if (hashlen < 0)
+		return hashlen;
 
+	args->namelen = xfs_parent_name_rec_sizeof(hashlen);
 	args->trans = tp;
 	args->dp = child;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -258,21 +268,21 @@ xfs_parent_replace(
 	struct xfs_inode	*child)
 {
 	struct xfs_da_args	*args = &new_parent->args;
-	int			error;
+	int			old_hashlen, new_hashlen;
 
-	error = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
+	old_hashlen = xfs_init_parent_name_rec(&new_parent->old_rec, old_dp,
 			old_name, child);
-	if (error)
-		return error;
-	error = xfs_init_parent_name_rec(&new_parent->rec, new_dp, new_name,
-			child);
-	if (error)
-		return error;
+	if (old_hashlen < 0)
+		return old_hashlen;
+	new_hashlen = xfs_init_parent_name_rec(&new_parent->rec, new_dp,
+			new_name, child);
+	if (new_hashlen < 0)
+		return new_hashlen;
 
 	new_parent->args.name = (const uint8_t *)&new_parent->old_rec;
-	new_parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.namelen = xfs_parent_name_rec_sizeof(old_hashlen);
 	new_parent->args.new_name = (const uint8_t *)&new_parent->rec;
-	new_parent->args.new_namelen = sizeof(struct xfs_parent_name_rec);
+	new_parent->args.new_namelen = xfs_parent_name_rec_sizeof(new_hashlen);
 	args->trans = tp;
 	args->dp = child;
 
@@ -320,16 +330,17 @@ xfs_parent_lookup(
 	unsigned int			namelen,
 	struct xfs_parent_scratch	*scr)
 {
+	int				reclen;
 	int				error;
 
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.namelen	= reclen;
 	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
 	scr->args.trans		= tp;
 	scr->args.valuelen	= namelen;
@@ -357,14 +368,16 @@ xfs_parent_set(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	int				reclen;
+
+	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.namelen	= reclen;
 	scr->args.valuelen	= pptr->p_namelen;
 	scr->args.value		= (void *)pptr->p_name;
 	scr->args.whichfork	= XFS_ATTR_FORK;
@@ -384,14 +397,16 @@ xfs_parent_unset(
 	const struct xfs_parent_name_irec *pptr,
 	struct xfs_parent_scratch	*scr)
 {
-	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+	int				reclen;
+
+	xfs_parent_irec_to_disk(&scr->rec, &reclen, NULL, NULL, pptr);
 
 	memset(&scr->args, 0, sizeof(struct xfs_da_args));
 	scr->args.attr_filter	= XFS_ATTR_PARENT;
 	scr->args.dp		= ip;
 	scr->args.geo		= ip->i_mount->m_attr_geo;
 	scr->args.name		= (const unsigned char *)&scr->rec;
-	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.namelen	= reclen;
 	scr->args.whichfork	= XFS_ATTR_FORK;
 
 	return xfs_attr_set(&scr->args);
@@ -399,7 +414,7 @@ xfs_parent_unset(
 
 /*
  * Compute the parent pointer namehash for the given child file and dirent
- * name.
+ * name.  Returns the length of the hash in bytes, or a negative errno.
  */
 int
 xfs_parent_namehash(
@@ -420,6 +435,12 @@ xfs_parent_namehash(
 		return -EINVAL;
 	}
 
+	if (name->len < namehash_len) {
+		memcpy(namehash, name->name, name->len);
+		memset(namehash + name->len, 0, namehash_len - name->len);
+		return name->len;
+	}
+
 	error = sha512_init(&shash);
 	if (error)
 		goto out;
@@ -436,6 +457,7 @@ xfs_parent_namehash(
 	if (error)
 		goto out;
 
+	error = SHA512_DIGEST_SIZE;
 out:
 	sha512_erase(&shash);
 	return error;
@@ -451,7 +473,12 @@ xfs_parent_irec_hash(
 		.name			= pptr->p_name,
 		.len			= pptr->p_namelen,
 	};
+	int				hashlen;
 
-	return xfs_parent_namehash(ip, &xname, &pptr->p_namehash,
+	hashlen = xfs_parent_namehash(ip, &xname, &pptr->p_namehash,
 			sizeof(pptr->p_namehash));
+	if (hashlen < 0)
+		return hashlen;
+	pptr->hashlen = hashlen;
+	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index d3f2841e0f6e..4c3100760bba 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -23,6 +23,7 @@ struct xfs_parent_name_irec {
 	/* Key fields for looking up a particular parent pointer. */
 	xfs_ino_t		p_ino;
 	uint32_t		p_gen;
+	uint8_t			hashlen;
 	uint8_t			p_namehash[XFS_PARENT_NAME_HASH_SIZE];
 
 	/* Attributes of a parent pointer. */
@@ -31,10 +32,11 @@ struct xfs_parent_name_irec {
 };
 
 void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
-		const struct xfs_parent_name_rec *rec,
+		const struct xfs_parent_name_rec *rec, int reclen,
 		const void *value, int valuelen);
-void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, void *value,
-		int *valuelen, const struct xfs_parent_name_irec *irec);
+void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
+		void *value, int *valuelen,
+		const struct xfs_parent_name_irec *irec);
 
 /*
  * Dynamically allocd structure used to wrap the needed data to pass around
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 2494947a0c93..87cff40b15f1 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -144,15 +144,19 @@ xchk_dir_parent_pointer(
 {
 	struct xfs_scrub	*sc = sd->sc;
 	int			pptr_namelen;
-	int			error;
+	int			hashlen;
 
 	sd->pptr.p_ino = sc->ip->i_ino;
 	sd->pptr.p_gen = VFS_I(sc->ip)->i_generation;
 
-	error = xfs_parent_namehash(ip, name, &sd->pptr.p_namehash,
+	hashlen = xfs_parent_namehash(ip, name, &sd->pptr.p_namehash,
 			sizeof(sd->pptr.p_namehash));
-	if (error)
-		return error;
+	if (hashlen < 0) {
+		xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+				&hashlen);
+		return hashlen;
+	}
+	sd->pptr.hashlen = hashlen;
 
 	pptr_namelen = xfs_parent_lookup(sc->tp, ip, &sd->pptr, sd->namebuf,
 			MAXNAMELEN, &sd->pptr_scratch);
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index c0b2b78da277..b12548787321 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -540,7 +540,7 @@ xrep_dir_scan_parent_pointer(
 	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
 		return -EFSCORRUPTED;
 
-	xfs_parent_irec_from_disk(&rd->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&rd->pptr, rec, namelen, value, valuelen);
 
 	/* Ignore parent pointers that point back to a different dir. */
 	if (rd->pptr.p_ino != sc->ip->i_ino ||
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 53872a7be942..b47f0bcef690 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -531,6 +531,7 @@ xchk_parent_scan_attr(
 	struct xfs_inode	*dp = NULL;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
 	unsigned int		lockmode;
+	int			hashlen;
 	int			error;
 
 	/* Ignore incomplete xattrs */
@@ -552,7 +553,7 @@ xchk_parent_scan_attr(
 		return -ECANCELED;
 	}
 
-	xfs_parent_irec_from_disk(&pp->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&pp->pptr, rec, namelen, value, valuelen);
 
 	xname.name = pp->pptr.p_name;
 	xname.len = pp->pptr.p_namelen;
@@ -561,13 +562,16 @@ xchk_parent_scan_attr(
 	 * Does the namehash in the parent pointer match the actual name?
 	 * If not, there's no point in checking further.
 	 */
-	error = xfs_parent_namehash(sc->ip, &xname, pp->child_namehash,
+	hashlen = xfs_parent_namehash(sc->ip, &xname, pp->child_namehash,
 			sizeof(pp->child_namehash));
-	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
-		return error;
+	if (hashlen < 0) {
+		xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &hashlen);
+		return hashlen;
+	}
 
-	if (memcmp(pp->pptr.p_namehash, pp->child_namehash,
-				sizeof(pp->pptr.p_namehash))) {
+	if (hashlen != pp->pptr.hashlen ||
+	    memcmp(pp->pptr.p_namehash, pp->child_namehash,
+				pp->pptr.hashlen)) {
 		trace_xchk_parent_bad_namehash(sc->ip, pp->pptr.p_ino,
 				xname.name, xname.len);
 		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 51432ab61c94..7d3b9c82bd05 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -522,7 +522,7 @@ xrep_pptr_dump_tempptr(
 	else
 		return -EFSCORRUPTED;
 
-	xfs_parent_irec_from_disk(&rp->pptr, rec, value, valuelen);
+	xfs_parent_irec_from_disk(&rp->pptr, rec, namelen, value, valuelen);
 
 	trace_xrep_pptr_dumpname(sc->tempip, &rp->pptr);
 
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 65bec3875308..284ca3c14a0f 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -74,7 +74,7 @@ xfs_getparent_listent(
 		return;
 	}
 
-	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, value,
+	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, namelen, value,
 			valuelen);
 
 	trace_xfs_getparent_listent(context->dp, ppi, irec);

