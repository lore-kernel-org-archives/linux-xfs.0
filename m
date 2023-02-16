Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC4AC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjBPVLp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBPVLo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:11:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F84553833
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C5D60C6D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4992C4339E;
        Thu, 16 Feb 2023 21:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581859;
        bh=0mVR2VMLDwP2AXhxaW1XKeQM0BSanP9RxhLIIFGPhQo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TvwqD7suC+jw1nnoH3FQKAj1u/Ng4lBuPn+3yqusUICaGGWbJPFVTMXImDhhpraYL
         jVtM/VVybQW5XAmYlKpBXTtG0JB32JOf6bQWSRjkBouoawYe7f/iPvs2PZ1kNpFOb2
         lvNAfiymu/MuyMHr/hXGkALxaNAE17fGHocalclRuElpnNGyG3peoOn40EjhbzOj9a
         Ua26wq2a9p0pyhyEDesmFl25yc9Z1FNcAvcc+zjW9prDUwTlvoNpcbr4UMiO3jnYaf
         vQLkwQPFCf49sZFz72qlMf/kkdLk23mXGz0fVKUAQ/l2UoW/8ycZOE1mFScawoIaoa
         +clKrfZzzrcrg==
Date:   Thu, 16 Feb 2023 13:10:58 -0800
Subject: [PATCH 2/6] xfs: replace parent pointer diroffset with sha512 hash of
 name
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882399.3478037.4841161260073966252.stgit@magnolia>
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

Replace the diroffset with the sha512 hash of the dirent name, thereby
eliminating the need for directory repair to update all the parent
pointers after rebuilding the directory.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attr.c                |   25 +++++-
 db/attrshort.c           |   19 ++++-
 db/field.c               |    2 
 db/field.h               |    1 
 db/fprint.c              |   31 +++++++
 db/fprint.h              |    2 
 db/metadump.c            |   39 ++++-----
 libxfs/libxfs_api_defs.h |    2 
 libxfs/libxfs_priv.h     |    1 
 libxfs/xfs_da_format.h   |   15 ++--
 libxfs/xfs_fs.h          |    4 -
 libxfs/xfs_parent.c      |  124 +++++++++++++++++++++++-------
 libxfs/xfs_parent.h      |   21 +++--
 logprint/log_redo.c      |   15 +---
 man/man3/xfsctl.3        |    1 
 mkfs/proto.c             |    7 +-
 repair/phase6.c          |   13 +--
 repair/pptr.c            |  193 +++++++++++++++++++++++++++++++---------------
 repair/pptr.h            |    2 
 19 files changed, 358 insertions(+), 159 deletions(-)


diff --git a/db/attr.c b/db/attr.c
index 8ea7b36e..bacdc6d9 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -20,6 +20,7 @@ static int	attr_leaf_hdr_count(void *obj, int startoff);
 static int	attr_leaf_name_local_count(void *obj, int startoff);
 static int	attr_leaf_name_local_name_count(void *obj, int startoff);
 static int	attr_leaf_name_pptr_count(void *obj, int startoff);
+static int	attr_leaf_name_pptr_namehashlen(void *obj, int startoff);
 static int	attr_leaf_name_local_value_count(void *obj, int startoff);
 static int	attr_leaf_name_local_value_offset(void *obj, int startoff,
 						  int idx);
@@ -125,8 +126,8 @@ const field_t	attr_leaf_name_flds[] = {
 	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_INODE },
 	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)),
 	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
-	{ "parent_diroffset", FLDT_UINT32D, OI(PPOFF(p_diroffset)),
-	  attr_leaf_name_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_HEXSTRING, OI(PPOFF(p_namehash)),
+	  attr_leaf_name_pptr_namehashlen, FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_leaf_name_local_value_offset,
 	  attr_leaf_name_local_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ "valueblk", FLDT_UINT32X, OI(LVOFF(valueblk)),
@@ -302,6 +303,26 @@ attr_leaf_name_pptr_count(
 			__attr_leaf_name_pptr_count);
 }
 
+static int
+__attr_leaf_name_pptr_namehashlen(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	if (e->flags & XFS_ATTR_PARENT)
+		return XFS_PARENT_NAME_HASH_SIZE;
+	return 0;
+}
+
+static int
+attr_leaf_name_pptr_namehashlen(
+	void				*obj,
+	int				startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+			__attr_leaf_name_pptr_namehashlen);
+}
+
 static int
 __attr_leaf_name_local_name_count(
 	struct xfs_attr_leafblock	*leaf,
diff --git a/db/attrshort.c b/db/attrshort.c
index 7c8ac485..be15f4ee 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -14,6 +14,7 @@
 
 static int	attr_sf_entry_name_count(void *obj, int startoff);
 static int	attr_sf_entry_pptr_count(void *obj, int startoff);
+static int	attr_sf_entry_pptr_namehashlen(void *obj, int startoff);
 static int	attr_sf_entry_value_count(void *obj, int startoff);
 static int	attr_sf_entry_value_offset(void *obj, int startoff, int idx);
 static int	attr_shortform_list_count(void *obj, int startoff);
@@ -56,8 +57,8 @@ const field_t	attr_sf_entry_flds[] = {
 	  FLD_COUNT, TYP_INODE },
 	{ "parent_gen", FLDT_UINT32D, OI(PPOFF(p_gen)), attr_sf_entry_pptr_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "parent_diroffset", FLDT_UINT32D, OI(PPOFF(p_diroffset)),
-	   attr_sf_entry_pptr_count, FLD_COUNT, TYP_NONE },
+	{ "parent_namehash", FLDT_HEXSTRING, OI(PPOFF(p_namehash)),
+	   attr_sf_entry_pptr_namehashlen, FLD_COUNT, TYP_NONE },
 	{ "value", FLDT_CHARNS, attr_sf_entry_value_offset,
 	  attr_sf_entry_value_count, FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
@@ -77,6 +78,20 @@ attr_sf_entry_pptr_count(
 	return 0;
 }
 
+static int
+attr_sf_entry_pptr_namehashlen(
+	void				*obj,
+	int				startoff)
+{
+	struct xfs_attr_sf_entry	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	e = (struct xfs_attr_sf_entry *)((char *)obj + byteize(startoff));
+	if (e->flags & XFS_ATTR_PARENT)
+		return XFS_PARENT_NAME_HASH_SIZE;
+	return 0;
+}
+
 static int
 attr_sf_entry_name_count(
 	void				*obj,
diff --git a/db/field.c b/db/field.c
index a3e47ee8..afadfdb4 100644
--- a/db/field.c
+++ b/db/field.c
@@ -144,6 +144,8 @@ const ftattr_t	ftattrtab[] = {
 	{ FLDT_CHARNS, "charns", fp_charns, NULL, SI(bitsz(char)), 0, NULL,
 	  NULL },
 	{ FLDT_CHARS, "chars", fp_num, "%c", SI(bitsz(char)), 0, NULL, NULL },
+	{ FLDT_HEXSTRING, "hexstring", fp_hexstring, NULL, SI(bitsz(char)), 0, NULL,
+	  NULL },
 	{ FLDT_REXTLEN, "rextlen", fp_num, "%u", SI(RMAPBT_BLOCKCOUNT_BITLEN),
 	  0, NULL, NULL },
 	{ FLDT_RFILEOFFD, "rfileoffd", fp_num, "%llu", SI(RMAPBT_OFFSET_BITLEN),
diff --git a/db/field.h b/db/field.h
index 634742a5..d756e04a 100644
--- a/db/field.h
+++ b/db/field.h
@@ -64,6 +64,7 @@ typedef enum fldt	{
 	FLDT_CFSBLOCK,
 	FLDT_CHARNS,
 	FLDT_CHARS,
+	FLDT_HEXSTRING,
 	FLDT_REXTLEN,
 	FLDT_RFILEOFFD,
 	FLDT_REXTFLG,
diff --git a/db/fprint.c b/db/fprint.c
index 65accfda..c4462fb6 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -54,6 +54,37 @@ fp_charns(
 	return 1;
 }
 
+int
+fp_hexstring(
+	void	*obj,
+	int	bit,
+	int	count,
+	char	*fmtstr,
+	int	size,
+	int	arg,
+	int	base,
+	int	array)
+{
+	int	i;
+	char	*p;
+
+	ASSERT(bitoffs(bit) == 0);
+	ASSERT(size == bitsz(char));
+	dbprintf("\"");
+	for (i = 0, p = (char *)obj + byteize(bit);
+	     i < count && !seenint();
+	     i++, p++) {
+		char c = *p & 0xff;
+
+		if (isalnum(c))
+			dbprintf("%c", c);
+		else
+			dbprintf("\\x%02x", c);
+	}
+	dbprintf("\"");
+	return 1;
+}
+
 int
 fp_num(
 	void		*obj,
diff --git a/db/fprint.h b/db/fprint.h
index a1ea935c..c07240c6 100644
--- a/db/fprint.h
+++ b/db/fprint.h
@@ -9,6 +9,8 @@ typedef int (*prfnc_t)(void *obj, int bit, int count, char *fmtstr, int size,
 
 extern int	fp_charns(void *obj, int bit, int count, char *fmtstr, int size,
 			  int arg, int base, int array);
+extern int	fp_hexstring(void *obj, int bit, int count, char *fmtstr,
+			  int size, int arg, int base, int array);
 extern int	fp_num(void *obj, int bit, int count, char *fmtstr, int size,
 		       int arg, int base, int array);
 extern int	fp_sarray(void *obj, int bit, int count, char *fmtstr, int size,
diff --git a/db/metadump.c b/db/metadump.c
index 4be23993..e56acdcc 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -740,14 +740,12 @@ nametable_add(xfs_dahash_t hash, int namelen, unsigned char *name)
 #define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
 
 static inline unsigned char
-random_filename_char(xfs_ino_t	ino)
+random_filename_char(void)
 {
 	static unsigned char filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 						"abcdefghijklmnopqrstuvwxyz"
 						"0123456789-_";
 
-	if (ino)
-		return filename_alphabet[ino % (sizeof filename_alphabet - 1)];
 	return filename_alphabet[random() % (sizeof filename_alphabet - 1)];
 }
 
@@ -817,7 +815,6 @@ in_lost_found(
  */
 static void
 obfuscate_name(
-	xfs_ino_t	ino,
 	xfs_dahash_t	hash,
 	size_t		name_len,
 	unsigned char	*name)
@@ -845,7 +842,7 @@ obfuscate_name(
 	 * Accumulate its new hash value as we go.
 	 */
 	for (i = 0; i < name_len - 5; i++) {
-		*newp = random_filename_char(ino);
+		*newp = random_filename_char();
 		new_hash = *newp ^ rol32(new_hash, 7);
 		newp++;
 	}
@@ -1210,10 +1207,14 @@ generate_obfuscated_name(
 	/* Obfuscate the name (if possible) */
 
 	hash = libxfs_da_hashname(name, namelen);
-	if (xfs_has_parent(mp))
-		obfuscate_name(ino, hash, namelen, name);
+	if (xfs_has_parent(mp) && ino)
+		/*
+		 * XXX: no good way to obfuscate dirent names now that we
+		 * hash them into the pptr key
+		 * obfuscate_name(ino, hash, namelen, name)
+		 */ ;
 	else
-		obfuscate_name(0, hash, namelen, name);
+		obfuscate_name(hash, namelen, name);
 
 	/*
 	 * Make sure the name is not something already seen.  If we
@@ -1326,7 +1327,7 @@ obfuscate_path_components(
 			/* last (or single) component */
 			namelen = strnlen((char *)comp, len);
 			hash = libxfs_da_hashname(comp, namelen);
-			obfuscate_name(0, hash, namelen, comp);
+			obfuscate_name(hash, namelen, comp);
 			break;
 		}
 		namelen = slash - (char *)comp;
@@ -1337,7 +1338,7 @@ obfuscate_path_components(
 			continue;
 		}
 		hash = libxfs_da_hashname(comp, namelen);
-		obfuscate_name(0, hash, namelen, comp);
+		obfuscate_name(hash, namelen, comp);
 		comp += namelen + 1;
 		len -= namelen + 1;
 	}
@@ -1412,16 +1413,11 @@ process_sf_attr(
 			break;
 		}
 
-		if (obfuscate) {
-			if (asfep->flags & XFS_ATTR_PARENT) {
-				generate_obfuscated_name(cur_ino, asfep->valuelen,
-					 &asfep->nameval[asfep->namelen]);
-			} else {
-				generate_obfuscated_name(0, asfep->namelen,
-							 &asfep->nameval[0]);
-				memset(&asfep->nameval[asfep->namelen], 'v',
-				       asfep->valuelen);
-			}
+		if (obfuscate && !(asfep->flags & XFS_ATTR_PARENT)) {
+			generate_obfuscated_name(0, asfep->namelen,
+					&asfep->nameval[0]);
+			memset(&asfep->nameval[asfep->namelen], 'v',
+					asfep->valuelen);
 		}
 
 		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
@@ -1808,9 +1804,6 @@ process_attr_block(
 			zlen = xfs_attr_leaf_entsize_local(nlen, vlen) -
 				(sizeof(xfs_attr_leaf_name_local_t) - 1 +
 				 nlen + vlen);
-			if (obfuscate && (entry->flags & XFS_ATTR_PARENT))
-				generate_obfuscated_name(cur_ino, vlen,
-						&local->nameval[nlen]);
 			if (zero_stale_data)
 				memset(&local->nameval[nlen + vlen], 0, zlen);
 		} else {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ab8bdc1c..a28e604d 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -147,6 +147,8 @@
 #define xfs_parent_add			libxfs_parent_add
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
+#define xfs_parent_irec_hash		libxfs_parent_irec_hash
+#define xfs_parent_namehash		libxfs_parent_namehash
 #define xfs_parent_set			libxfs_parent_set
 #define xfs_parent_start		libxfs_parent_start
 #define xfs_parent_unset		libxfs_parent_unset
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index ad21a25d..d5a9fec2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -56,6 +56,7 @@
 
 #include "xfs_fs.h"
 #include "libfrog/crc32c.h"
+#include "libfrog/sha512.h"
 
 #include <sys/xattr.h>
 
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index c07b8166..386f63b2 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
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
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 9e59a1fd..c65345d2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
 
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index a7c5974c..05c1e032 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -55,7 +55,6 @@ xfs_parent_namecheck(
 	unsigned int				attr_flags)
 {
 	xfs_ino_t				p_ino;
-	xfs_dir2_dataptr_t			p_diroffset;
 
 	if (reclen != sizeof(struct xfs_parent_name_rec))
 		return false;
@@ -68,10 +67,6 @@ xfs_parent_namecheck(
 	if (!xfs_verify_ino(mp, p_ino))
 		return false;
 
-	p_diroffset = be32_to_cpu(rec->p_diroffset);
-	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
-		return false;
-
 	return true;
 }
 
@@ -92,18 +87,17 @@ xfs_parent_valuecheck(
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
@@ -119,7 +113,7 @@ xfs_parent_irec_from_disk(
 {
 	irec->p_ino = be64_to_cpu(rec->p_ino);
 	irec->p_gen = be32_to_cpu(rec->p_gen);
-	irec->p_diroffset = be32_to_cpu(rec->p_diroffset);
+	memcpy(irec->p_namehash, rec->p_namehash, sizeof(irec->p_namehash));
 
 	if (!value) {
 		irec->p_namelen = 0;
@@ -149,7 +143,7 @@ xfs_parent_irec_to_disk(
 {
 	rec->p_ino = cpu_to_be64(irec->p_ino);
 	rec->p_gen = cpu_to_be32(irec->p_gen);
-	rec->p_diroffset = cpu_to_be32(irec->p_diroffset);
+	memcpy(rec->p_namehash, irec->p_namehash, sizeof(rec->p_namehash));
 
 	if (valuelen) {
 		ASSERT(*valuelen > 0);
@@ -209,12 +203,15 @@ xfs_parent_add(
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
@@ -231,14 +228,18 @@ xfs_parent_add(
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
@@ -251,16 +252,23 @@ xfs_parent_replace(
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
@@ -268,9 +276,8 @@ xfs_parent_replace(
 	args->trans = tp;
 	args->dp = child;
 
-	ASSERT(parent_name != NULL);
-	new_parent->args.value = (void *)parent_name->name;
-	new_parent->args.valuelen = parent_name->len;
+	new_parent->args.value = (void *)new_name->name;
+	new_parent->args.valuelen = new_name->len;
 
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return xfs_attr_defer_replace(args);
@@ -389,3 +396,62 @@ xfs_parent_unset(
 
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
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index a7fc621b..d3f2841e 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
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
 
diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index f7e9c9ad..1ac0536a 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -805,9 +805,8 @@ xlog_print_trans_attri_name(
 	}
 	memmove((char*)src_f, *ptr, src_len);
 
-	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u, p_diroffset: %u\n"),
-		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen),
-				be32_to_cpu(src_f->p_diroffset));
+	printf(_("ATTRI:  #p_ino: %llu	p_gen: %u\n"),
+		be64_to_cpu(src_f->p_ino), be32_to_cpu(src_f->p_gen));
 
 	free(src_f);
 out:
@@ -898,9 +897,8 @@ xlog_recover_print_attri(
 				goto out;
 			}
 
-			printf(_("ATTRI:  #inode: %llu     gen: %u, offset: %u\n"),
-				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
-				be32_to_cpu(rec->p_diroffset));
+			printf(_("ATTRI:  #inode: %llu     gen: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen));
 
 			free(rec);
 		}
@@ -929,9 +927,8 @@ xlog_recover_print_attri(
 				goto out;
 			}
 
-			printf(_("ATTRI:  new #inode: %llu     gen: %u, offset: %u\n"),
-				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen),
-				be32_to_cpu(rec->p_diroffset));
+			printf(_("ATTRI:  new #inode: %llu     gen: %u\n"),
+				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen));
 
 			free(rec);
 		}
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 7cc97499..42ba3bba 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -367,7 +367,6 @@ int main() {
 			p = xfs_ppinfo_to_pp(pi, i);
 			printf("inode		= %llu\\n", (unsigned long long)p->xpp_ino);
 			printf("generation	= %u\\n", (unsigned int)p->xpp_gen);
-			printf("diroffset	= %u\\n", (unsigned int)p->xpp_diroffset);
 			printf("name		= \\"%s\\"\\n\\n", (char *)p->xpp_name);
 		}
 	} while (!pi->pi_flags & XFS_PPTR_OFLAG_DONE);
diff --git a/mkfs/proto.c b/mkfs/proto.c
index b8d7ac96..445fbefb 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -509,7 +509,7 @@ parseproto(
 		libxfs_trans_log_inode(tp, ip, flags);
 		if (parent) {
 			error = -libxfs_parent_add(tp, parent, pip, &xname,
-					offset, ip);
+					ip);
 			if (error)
 				fail(_("committing parent pointers failed."),
 						error);
@@ -602,7 +602,7 @@ parseproto(
 		libxfs_trans_log_inode(tp, ip, flags);
 		if (parent) {
 			error = -libxfs_parent_add(tp, parent, pip, &xname,
-					offset, ip);
+					ip);
 			if (error)
 				fail(_("committing parent pointers failed."),
 						error);
@@ -636,8 +636,7 @@ parseproto(
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
 	if (parent) {
-		error = -libxfs_parent_add(tp, parent, pip, &xname, offset,
-				ip);
+		error = -libxfs_parent_add(tp, parent, pip, &xname, ip);
 		if (error)
 			fail(_("committing parent pointers failed."), error);
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 1994162a..3fb11df9 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -68,7 +68,6 @@ struct dir_hash_ent {
 	struct dir_hash_ent	*nextbyorder;	/* next in order added */
 	xfs_dahash_t		hashval;	/* hash value of name */
 	uint32_t		address;	/* offset of data entry */
-	uint32_t		new_address;	/* new address, if we rebuild */
 	xfs_ino_t		inum;		/* inode num of entry */
 	short			junkit;		/* name starts with / */
 	short			seen;		/* have seen leaf entry */
@@ -226,7 +225,6 @@ dir_hash_add(
 	p->address = addr;
 	p->inum = inum;
 	p->seen = 0;
-	p->new_address = addr;
 
 	/* Set up the name in the region trailing the hash entry. */
 	memcpy(p->namebuf, name, namelen);
@@ -979,7 +977,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
-	add_parent_ptr(ip->i_ino, ORPHANAGE, diroffset, pip);
+	add_parent_ptr(ip->i_ino, ORPHANAGE, pip);
 
 	/*
 	 * bump up the link count in the root directory to account
@@ -1169,8 +1167,7 @@ mv_orphanage(
 	}
 
 	if (xfs_has_parent(mp))
-		add_parent_ptr(ino_p->i_ino, xname.name, diroffset,
-				orphanage_ip);
+		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip);
 
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
@@ -1341,8 +1338,8 @@ longform_dir2_rebuild(
 
 		libxfs_trans_ijoin(tp, ip, 0);
 
-		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum,
-						nres, &p->new_address);
+		error = -libxfs_dir_createname(tp, ip, &p->name, p->inum, nres,
+				NULL);
 		if (error) {
 			do_warn(
 _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
@@ -2819,7 +2816,7 @@ dir_hash_add_parent_ptrs(
 						p->name.name[1] == '.'))))
 			continue;
 
-		add_parent_ptr(p->inum, p->name.name, p->new_address, dp);
+		add_parent_ptr(p->inum, p->name.name, dp);
 	}
 }
 
diff --git a/repair/pptr.c b/repair/pptr.c
index a5cf89b9..ca5fe7e3 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -119,9 +119,6 @@ struct ag_pptr {
 	xfs_ino_t		parent_ino;
 	unsigned int		parent_gen;
 
-	/* dirent offset */
-	xfs_dir2_dataptr_t	diroffset;
-
 	/* dirent name length */
 	unsigned int		namelen;
 
@@ -140,9 +137,6 @@ struct file_pptr {
 	unsigned long long	parent_ino:63;
 	unsigned int		parent_gen;
 
-	/* dirent offset */
-	xfs_dir2_dataptr_t	diroffset;
-
 	/* parent pointer name length */
 	unsigned int		namelen;
 
@@ -220,9 +214,9 @@ cmp_ag_pptr(
 	if (pa->parent_ino > pb->parent_ino)
 		return 1;
 
-	if (pa->diroffset < pb->diroffset)
+	if (pa->name_cookie < pb->name_cookie)
 		return -1;
-	if (pa->diroffset > pb->diroffset)
+	if (pa->name_cookie > pb->name_cookie)
 		return 1;
 
 	return 0;
@@ -241,9 +235,18 @@ cmp_file_pptr(
 	if (pa->parent_ino > pb->parent_ino)
 		return 1;
 
-	if (pa->diroffset < pb->diroffset)
+	/*
+	 * Push the parent pointer names that we didn't find in the dirent scan
+	 * towards the front of the list so that we delete them first.
+	 */
+	if (!pa->name_in_nameblobs && pb->name_in_nameblobs)
 		return -1;
-	if (pa->diroffset > pb->diroffset)
+	if (pa->name_in_nameblobs && !pb->name_in_nameblobs)
+		return 1;
+
+	if (pa->name_cookie < pb->name_cookie)
+		return -1;
+	if (pa->name_cookie > pb->name_cookie)
 		return 1;
 
 	return 0;
@@ -308,12 +311,11 @@ parent_ptr_init(
 	}
 }
 
-/* Remember that @dp has a dirent (@fname, @ino) at @diroffset. */
+/* Remember that @dp has a dirent (@fname, @ino). */
 void
 add_parent_ptr(
 	xfs_ino_t		ino,
 	const unsigned char	*fname,
-	xfs_dir2_dataptr_t	diroffset,
 	struct xfs_inode	*dp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -321,7 +323,6 @@ add_parent_ptr(
 		.child_agino	= XFS_INO_TO_AGINO(mp, ino),
 		.parent_ino	= dp->i_ino,
 		.parent_gen	= VFS_I(dp)->i_generation,
-		.diroffset	= diroffset,
 		.namelen	= strlen(fname),
 	};
 	struct ag_pptrs		*ag_pptrs;
@@ -348,9 +349,9 @@ add_parent_ptr(
 				fname, strerror(error));
 
 	dbg_printf(
- _("%s: dp %llu fname '%s' diroffset %u ino %llu cookie 0x%llx\n"),
+ _("%s: dp %llu fname '%s' ino %llu cookie 0x%llx\n"),
 			__func__, (unsigned long long)dp->i_ino, fname,
-			diroffset, (unsigned long long)ino,
+			(unsigned long long)ino,
 			(unsigned long long)ag_pptr.name_cookie);
 }
 
@@ -509,6 +510,8 @@ examine_xattr(
 {
 	struct file_pptr	file_pptr = { };
 	struct xfs_parent_name_irec irec;
+	struct xfs_name		xname;
+	uint8_t			namehash[XFS_PARENT_NAME_HASH_SIZE];
 	struct xfs_mount	*mp = ip->i_mount;
 	struct file_scan	*fscan = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
@@ -531,9 +534,23 @@ examine_xattr(
 
 	file_pptr.parent_ino = irec.p_ino;
 	file_pptr.parent_gen = irec.p_gen;
-	file_pptr.diroffset = irec.p_diroffset;
 	file_pptr.namelen = irec.p_namelen;
 
+	xname.name = irec.p_name;
+	xname.len = irec.p_namelen;
+
+	/*
+	 * Does the namehash in the attr key match the name in the attr value?
+	 * If not, there's no point in checking further.
+	 */
+	error = -libxfs_parent_namehash(ip, &xname, namehash,
+			sizeof(namehash));
+	if (error)
+		goto corrupt;
+
+	if (memcmp(irec.p_namehash, namehash, sizeof(irec.p_namehash)))
+		goto corrupt;
+
 	error = store_file_pptr_name(fscan, &file_pptr, &irec);
 	if (error)
 		do_error(
@@ -547,10 +564,10 @@ examine_xattr(
 				(unsigned long long)ip->i_ino, strerror(error));
 
 	dbg_printf(
- _("%s: dp %llu fname '%.*s' namelen %u diroffset %u ino %llu cookie 0x%llx\n"),
+ _("%s: dp %llu fname '%.*s' namelen %u ino %llu cookie 0x%llx\n"),
 			__func__, (unsigned long long)irec.p_ino,
 			irec.p_namelen, (const char *)irec.p_name,
-			irec.p_namelen, irec.p_diroffset,
+			irec.p_namelen,
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)file_pptr.name_cookie);
 	fscan->nr_file_pptrs++;
@@ -570,13 +587,17 @@ add_file_pptr(
 	struct xfs_parent_name_irec	pptr_rec = {
 		.p_ino			= ag_pptr->parent_ino,
 		.p_gen			= ag_pptr->parent_gen,
-		.p_diroffset		= ag_pptr->diroffset,
 		.p_namelen		= ag_pptr->namelen,
 	};
 	struct xfs_parent_scratch	scratch;
+	int				error;
 
 	memcpy(pptr_rec.p_name, name, ag_pptr->namelen);
 
+	error = -libxfs_parent_irec_hash(ip, &pptr_rec);
+	if (error)
+		return error;
+
 	return -libxfs_parent_set(ip, &pptr_rec, &scratch);
 }
 
@@ -584,14 +605,22 @@ add_file_pptr(
 static int
 remove_file_pptr(
 	struct xfs_inode		*ip,
-	const struct file_pptr		*file_pptr)
+	const struct file_pptr		*file_pptr,
+	const unsigned char		*name)
 {
 	struct xfs_parent_name_irec	pptr_rec = {
 		.p_ino			= file_pptr->parent_ino,
 		.p_gen			= file_pptr->parent_gen,
-		.p_diroffset		= file_pptr->diroffset,
+		.p_namelen		= file_pptr->namelen,
 	};
 	struct xfs_parent_scratch	scratch;
+	int				error;
+
+	memcpy(pptr_rec.p_name, name, file_pptr->namelen);
+
+	error = -libxfs_parent_irec_hash(ip, &pptr_rec);
+	if (error)
+		return error;
 
 	return -libxfs_parent_unset(ip, &pptr_rec, &scratch);
 }
@@ -637,13 +666,25 @@ clear_all_pptrs(
 				strerror(error));
 
 	while ((file_pptr = pop_slab_cursor(cur)) != NULL) {
-		error = remove_file_pptr(ip, file_pptr);
+		unsigned char	name[MAXNAMELEN];
+
+		error = load_file_pptr_name(fscan, file_pptr, name);
 		if (error)
 			do_error(
- _("wiping ino %llu pptr (ino %llu gen 0x%x diroffset %u) failed: %s\n"),
+  _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
+					(unsigned long long)ip->i_ino,
+					(unsigned long long)file_pptr->parent_ino,
+					file_pptr->parent_gen,
+					(unsigned long long)file_pptr->name_cookie,
+					strerror(error));
+
+		error = remove_file_pptr(ip, file_pptr, name);
+		if (error)
+			do_error(
+ _("wiping ino %llu pptr (ino %llu gen 0x%x) failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->parent_ino,
-				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->parent_gen,
 				strerror(error));
 	}
 
@@ -664,37 +705,37 @@ add_missing_parent_ptr(
 			ag_pptr->namelen);
 	if (error)
 		do_error(
- _("loading missing name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx) failed: %s\n"),
+ _("loading missing name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)ag_pptr->parent_ino,
-				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->parent_gen,
 				(unsigned long long)ag_pptr->name_cookie,
 				strerror(error));
 
 	if (no_modify) {
 		do_warn(
- _("would add missing ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("would add missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)ag_pptr->parent_ino,
-				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->parent_gen,
 				ag_pptr->namelen, name);
 		return;
 	}
 
 	do_warn(
- _("adding missing ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("adding missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)ag_pptr->parent_ino,
-			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->parent_gen,
 			ag_pptr->namelen, name);
 
 	error = add_file_pptr(ip, ag_pptr, name);
 	if (error)
 		do_error(
- _("adding ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+ _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)ag_pptr->parent_ino,
-			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->parent_gen,
 			ag_pptr->namelen, name, strerror(error));
 }
 
@@ -711,37 +752,37 @@ remove_incorrect_parent_ptr(
 	error = load_file_pptr_name(fscan, file_pptr, name);
 	if (error)
 		do_error(
- _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx) failed: %s\n"),
+ _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->parent_ino,
-				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->parent_gen,
 				(unsigned long long)file_pptr->name_cookie,
 				strerror(error));
 
 	if (no_modify) {
 		do_warn(
- _("would remove bad ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("would remove bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->parent_ino,
-				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->parent_gen,
 				file_pptr->namelen, name);
 		return;
 	}
 
 	do_warn(
- _("removing bad ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("removing bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)file_pptr->parent_ino,
-			file_pptr->parent_gen, file_pptr->diroffset,
+			file_pptr->parent_gen,
 			file_pptr->namelen, name);
 
-	error = remove_file_pptr(ip, file_pptr);
+	error = remove_file_pptr(ip, file_pptr, name);
 	if (error)
 		do_error(
- _("removing ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+ _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)file_pptr->parent_ino,
-			file_pptr->parent_gen, file_pptr->diroffset,
+			file_pptr->parent_gen,
 			file_pptr->namelen, name, strerror(error));
 }
 
@@ -764,20 +805,20 @@ compare_parent_pointers(
 			ag_pptr->namelen);
 	if (error)
 		do_error(
- _("loading master-list name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx namelen %u) failed: %s\n"),
+ _("loading master-list name for ino %llu parent pointer (ino %llu gen 0x%x  namecookie 0x%llx namelen %u) failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)ag_pptr->parent_ino,
-				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->parent_gen,
 				(unsigned long long)ag_pptr->name_cookie,
 				ag_pptr->namelen, strerror(error));
 
 	error = load_file_pptr_name(fscan, file_pptr, name2);
 	if (error)
 		do_error(
- _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x diroffset %u namecookie 0x%llx namelen %u) failed: %s\n"),
+ _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx namelen %u) failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->parent_ino,
-				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->parent_gen,
 				(unsigned long long)file_pptr->name_cookie,
 				ag_pptr->namelen, strerror(error));
 
@@ -793,42 +834,67 @@ compare_parent_pointers(
 reset:
 	if (no_modify) {
 		do_warn(
- _("would update ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("would update ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)ag_pptr->parent_ino,
-				ag_pptr->parent_gen, ag_pptr->diroffset,
+				ag_pptr->parent_gen,
 				ag_pptr->namelen, name1);
 		return;
 	}
 
 	do_warn(
- _("updating ino %llu parent pointer (ino %llu gen 0x%x diroffset %u name '%.*s')\n"),
+ _("updating ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)ag_pptr->parent_ino,
-			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->parent_gen,
 			ag_pptr->namelen, name1);
 
 	if (ag_pptr->parent_gen != file_pptr->parent_gen) {
-		error = remove_file_pptr(ip, file_pptr);
+		error = remove_file_pptr(ip, file_pptr, name2);
 		if (error)
 			do_error(
- _("erasing ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+ _("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->parent_ino,
-				file_pptr->parent_gen, file_pptr->diroffset,
+				file_pptr->parent_gen,
 				file_pptr->namelen, name2, strerror(error));
 	}
 
 	error = add_file_pptr(ip, ag_pptr, name1);
 	if (error)
 		do_error(
- _("updating ino %llu pptr (ino %llu gen 0x%x diroffset %u name '%.*s') failed: %s\n"),
+ _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
 			(unsigned long long)ip->i_ino,
 			(unsigned long long)ag_pptr->parent_ino,
-			ag_pptr->parent_gen, ag_pptr->diroffset,
+			ag_pptr->parent_gen,
 			ag_pptr->namelen, name1, strerror(error));
 }
 
+static int
+cmp_file_to_ag_pptr(
+	const struct file_pptr	*fp,
+	const struct ag_pptr	*ap)
+{
+	if (fp->parent_ino > ap->parent_ino)
+		return 1;
+	if (fp->parent_ino < ap->parent_ino)
+		return -1;
+
+	/*
+	 * If this parent pointer wasn't found in the dirent scan, we know it
+	 * should be removed.
+	 */
+	if (!fp->name_in_nameblobs)
+		return -1;
+
+	if (fp->name_cookie < ap->name_cookie)
+		return -1;
+	if (fp->name_cookie > ap->name_cookie)
+		return 1;
+
+	return 0;
+}
+
 /*
  * Make sure that the parent pointers we observed match the ones ondisk.
  *
@@ -894,26 +960,26 @@ crosscheck_file_parent_ptrs(
 				(unsigned long long)ip->i_ino, strerror(error));
 
 	do {
+		int	cmp_result;
+
 		file_pptr = peek_slab_cursor(fscan->file_pptr_recs_cur);
 
 		dbg_printf(
- _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (master)\n"),
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (master)\n"),
 				__func__,
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				ag_pptr->namelen,
-				ag_pptr->diroffset,
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)ag_pptr->name_cookie);
 
 		if (file_pptr) {
 			dbg_printf(
- _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (file)\n"),
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (file)\n"),
 					__func__,
 					(unsigned long long)file_pptr->parent_ino,
 					file_pptr->parent_gen,
 					file_pptr->namelen,
-					file_pptr->diroffset,
 					(unsigned long long)ip->i_ino,
 					(unsigned long long)file_pptr->name_cookie);
 		} else {
@@ -923,9 +989,8 @@ crosscheck_file_parent_ptrs(
 					(unsigned long long)ip->i_ino);
 		}
 
-		if (!file_pptr ||
-		    file_pptr->parent_ino > ag_pptr->parent_ino ||
-		    file_pptr->diroffset > ag_pptr->diroffset) {
+		cmp_result = file_pptr ? cmp_file_to_ag_pptr(file_pptr, ag_pptr) : 1;
+		if (cmp_result > 0) {
 			/*
 			 * The master pptr list knows about pptrs that are not
 			 * in the ondisk metadata.  Add the missing pptr and
@@ -933,8 +998,7 @@ crosscheck_file_parent_ptrs(
 			 */
 			add_missing_parent_ptr(ip, fscan, ag_pptr);
 			advance_slab_cursor(fscan->ag_pptr_recs_cur);
-		} else if (file_pptr->parent_ino < ag_pptr->parent_ino ||
-			   file_pptr->diroffset < ag_pptr->diroffset) {
+		} else if (cmp_result < 0) {
 			/*
 			 * The ondisk pptrs mention a link that is not in the
 			 * master list.  Delete the extra pptr and advance only
@@ -958,12 +1022,11 @@ crosscheck_file_parent_ptrs(
 
 	while ((file_pptr = pop_slab_cursor(fscan->file_pptr_recs_cur))) {
 		dbg_printf(
- _("%s: dp %llu dp_gen 0x%x namelen %u diroffset %u ino %llu namecookie 0x%llx (excess)\n"),
+ _("%s: dp %llu dp_gen 0x%x namelen %u ino %llu namecookie 0x%llx (excess)\n"),
 				__func__,
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				file_pptr->namelen,
-				file_pptr->diroffset,
 				(unsigned long long)ip->i_ino,
 				(unsigned long long)file_pptr->name_cookie);
 
diff --git a/repair/pptr.h b/repair/pptr.h
index d72c1ac2..1cf3444c 100644
--- a/repair/pptr.h
+++ b/repair/pptr.h
@@ -10,7 +10,7 @@ void parent_ptr_free(struct xfs_mount *mp);
 void parent_ptr_init(struct xfs_mount *mp);
 
 void add_parent_ptr(xfs_ino_t ino, const unsigned char *fname,
-		xfs_dir2_dataptr_t diroffset, struct xfs_inode *dp);
+		struct xfs_inode *dp);
 
 void check_parent_ptrs(struct xfs_mount *mp);
 

