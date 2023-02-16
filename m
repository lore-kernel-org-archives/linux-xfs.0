Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F38CC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBPVL6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjBPVL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:11:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D714C3B23C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:11:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AC51B828F3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:11:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21490C433EF;
        Thu, 16 Feb 2023 21:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581890;
        bh=aBZkQ9QXcOYWNYBfrYGmHhzfGqKS4HLU0BjeM4MY0l4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iojKR2LrFZ0hltT8ldOszBphES6a0Zb2SMaAR16E5yY6r5Tssqt4cULfE1awM+XlN
         cguowA11qoa7NIA3ZexNqJiUU8K+Ch9OENlXTWoKiGef7iB192ligojBysr2lBhdMk
         ws3EgkF7mIiiQVGZo672wd6qHw7wA0OLcXXhPrb1LKIJ5GCDOO8mV2KpM6gz0Rj0aP
         BBgjeWrKDVscMObCYRCR1NXEUYU9awOZ5+tZMxOwHeh46dzMCjUnjGBC9Uz49b6Ul+
         h70OlPTl/cTdVDaxjEdUqITZE03KiZE2XSU7nmMdzT3iYQuIoKqBki9LIjuMcEU2Va
         AQnaoYtOZbDCQ==
Date:   Thu, 16 Feb 2023 13:11:29 -0800
Subject: [PATCH 4/6] xfs: skip the sha512 namehash when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882426.3478037.5679930089622760946.stgit@magnolia>
In-Reply-To: <167657882371.3478037.12485693506644718323.stgit@magnolia>
References: <167657882371.3478037.12485693506644718323.stgit@magnolia>
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
 db/attr.c              |    8 +++--
 db/attrshort.c         |    2 +
 libxfs/xfs_da_format.h |   21 +++++++++++-
 libxfs/xfs_parent.c    |   85 ++++++++++++++++++++++++++++++++----------------
 libxfs/xfs_parent.h    |    8 +++--
 logprint/log_redo.c    |    5 ++-
 repair/pptr.c          |   10 +++---
 7 files changed, 96 insertions(+), 43 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index bacdc6d9..798a7e1a 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -309,8 +309,12 @@ __attr_leaf_name_pptr_namehashlen(
 	struct xfs_attr_leaf_entry      *e,
 	int				i)
 {
-	if (e->flags & XFS_ATTR_PARENT)
-		return XFS_PARENT_NAME_HASH_SIZE;
+	struct xfs_attr_leaf_name_local	*lname;
+
+	if (e->flags & XFS_ATTR_PARENT) {
+		lname = xfs_attr3_leaf_name_local(leaf, i);
+		return xfs_parent_name_hashlen(lname->namelen);
+	}
 	return 0;
 }
 
diff --git a/db/attrshort.c b/db/attrshort.c
index be15f4ee..2fcf44c1 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -88,7 +88,7 @@ attr_sf_entry_pptr_namehashlen(
 	ASSERT(bitoffs(startoff) == 0);
 	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
 	if (e->flags & XFS_ATTR_PARENT)
-		return XFS_PARENT_NAME_HASH_SIZE;
+		return xfs_parent_name_hashlen(e->namelen);
 	return 0;
 }
 
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 386f63b2..27535750 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
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
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 05c1e032..064f2f40 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index d3f2841e..4c310076 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index ca6b2641..339d4815 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -709,11 +709,12 @@ dump_pptr(
 {
 	struct xfs_parent_name_irec	irec;
 
-	libxfs_parent_irec_from_disk(&irec, name, value, valuelen);
+	libxfs_parent_irec_from_disk(&irec, name, namelen, value, valuelen);
 
 	printf("PPTR: %s attr_namelen %u value_namelen %u\n", tag, namelen, valuelen);
-	printf("PPTR: %s parent_ino %llu parent_gen %u namelen %u name '%.*s'\n",
+	printf("PPTR: %s parent_ino %llu parent_gen %u hashlen %u namelen %u name '%.*s'\n",
 			tag, (unsigned long long)irec.p_ino, irec.p_gen,
+			irec.hashlen,
 			irec.p_namelen, irec.p_namelen, irec.p_name);
 }
 
diff --git a/repair/pptr.c b/repair/pptr.c
index ca5fe7e3..12382ad7 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -515,6 +515,7 @@ examine_xattr(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct file_scan	*fscan = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
+	int			hashlen;
 	int			error;
 
 	/* Ignore anything that isn't a parent pointer. */
@@ -530,7 +531,7 @@ examine_xattr(
 	    !xfs_parent_valuecheck(mp, value, valuelen))
 		goto corrupt;
 
-	libxfs_parent_irec_from_disk(&irec, rec, value, valuelen);
+	libxfs_parent_irec_from_disk(&irec, rec, namelen, value, valuelen);
 
 	file_pptr.parent_ino = irec.p_ino;
 	file_pptr.parent_gen = irec.p_gen;
@@ -543,12 +544,13 @@ examine_xattr(
 	 * Does the namehash in the attr key match the name in the attr value?
 	 * If not, there's no point in checking further.
 	 */
-	error = -libxfs_parent_namehash(ip, &xname, namehash,
+	hashlen = libxfs_parent_namehash(ip, &xname, namehash,
 			sizeof(namehash));
-	if (error)
+	if (hashlen < 0)
 		goto corrupt;
 
-	if (memcmp(irec.p_namehash, namehash, sizeof(irec.p_namehash)))
+	if (namelen != xfs_parent_name_rec_sizeof(hashlen) ||
+	    memcmp(irec.p_namehash, namehash, hashlen))
 		goto corrupt;
 
 	error = store_file_pptr_name(fscan, &file_pptr, &irec);

