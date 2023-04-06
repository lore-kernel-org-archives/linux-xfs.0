Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790ACC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237377AbjDFTiX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237372AbjDFTiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:38:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86E5186
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:38:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7835A60FB3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E8CC433EF;
        Thu,  6 Apr 2023 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809884;
        bh=EGhYFd5UWcgR0vkBKdctpQM4ZNC1H6js8T6ty6Qjb8w=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=syZuLFJIfzKiQ8fh+8LyqpVx2bP1JXYzj+J9UmXNzAYyCRrm//cS7AzlZNd1Tm5ob
         jMkjxEYYBSIBYU3GpZg6oBxyroFb/A9n2kYTf4zrUBzGctIWmcdljJSRUddp9jBRN+
         Xxn6KgsdjvLR/8boQ5Fe6yN5hQoEmzNNR6uoLAP+v3G1OXnp7CGOsnAr08PUAc0jxk
         73Tlk8lEzPKwvNPDPeswRVSp+Q30vDZp7kQ/Nu+Nnm9NL3c+0oy5+hcpFZ0c0sYdOo
         7+x7VQDWL8s6znZNxrmOTOHv8cGZwdCn3mygOBvssWRXJvD27E4dcTg0LanVJR1OBh
         ns8Zci3erWhnQ==
Date:   Thu, 06 Apr 2023 12:38:04 -0700
Subject: [PATCH 25/32] xfs_db: obfuscate dirent and parent pointer names
 consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827886.616793.2247932828058405961.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When someone wants to perform an obfuscated metadump of a filesystem
where parent pointers are enabled, we have to use the *exact* same
obfuscated name for both the directory entry and the parent pointer.

Create a name remapping table so that when we obfuscate a dirent name or
a parent pointer name, we can apply the same obfuscation when we find
the corresponding parent pointer or dirent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c            |  313 ++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/libxfs_api_defs.h |    2 
 2 files changed, 304 insertions(+), 11 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 27d1df432..b413ef5b3 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -20,6 +20,14 @@
 #include "field.h"
 #include "dir2.h"
 
+#undef REMAP_DEBUG
+
+#ifdef REMAP_DEBUG
+# define remap_debug		printf
+#else
+# define remap_debug(...)	((void)0)
+#endif
+
 #define DEFAULT_MAX_EXT_SIZE	XFS_MAX_BMBT_EXTLEN
 
 /* copy all metadata structures to/from a file */
@@ -736,6 +744,111 @@ nametable_add(xfs_dahash_t hash, int namelen, unsigned char *name)
 	return ent;
 }
 
+/*
+ * Obfuscated name remapping table for parent pointer-enabled filesystems.
+ * When this feature is enabled, we have to maintain consistency between the
+ * names that appears in the dirent and the corresponding parent pointer.
+ */
+
+struct remap_ent {
+	struct remap_ent	*next;
+	xfs_ino_t		dir_ino;
+	xfs_dahash_t		namehash;
+	uint8_t			namelen;
+
+	uint8_t			names[];
+};
+
+static inline uint8_t *remap_ent_before(struct remap_ent *ent)
+{
+	return &ent->names[0];
+}
+
+static inline uint8_t *remap_ent_after(struct remap_ent *ent)
+{
+	return &ent->names[ent->namelen];
+}
+
+#define REMAP_TABLE_SIZE		4096
+
+static struct remap_ent		*remaptable[REMAP_TABLE_SIZE];
+
+static void
+remaptable_clear(void)
+{
+	int			i;
+	struct remap_ent	*ent, *next;
+
+	for (i = 0; i < REMAP_TABLE_SIZE; i++) {
+		ent = remaptable[i];
+
+		while (ent) {
+			next = ent->next;
+			free(ent);
+			ent = next;
+		}
+	}
+}
+
+/* Try to find a remapping table entry. */
+static struct remap_ent *
+remaptable_find(
+	xfs_ino_t		dir_ino,
+	xfs_dahash_t		namehash,
+	const unsigned char	*name,
+	unsigned int		namelen)
+{
+	struct remap_ent	*ent = remaptable[namehash % REMAP_TABLE_SIZE];
+
+	remap_debug("REMAP FIND: 0x%lx hash 0x%x '%.*s'\n",
+			dir_ino, namehash, namelen, name);
+
+	while (ent) {
+		remap_debug("REMAP ENT: 0x%lx hash 0x%x '%.*s'\n",
+				ent->dir_ino, ent->namehash, ent->namelen,
+				remap_ent_before(ent));
+
+		if (ent->dir_ino == dir_ino &&
+		    ent->namehash == namehash &&
+		    ent->namelen == namelen &&
+		    !memcmp(remap_ent_before(ent), name, namelen))
+			return ent;
+		ent = ent->next;
+	}
+
+	return NULL;
+}
+
+/* Remember the remapping for a particular dirent that we obfuscated. */
+static struct remap_ent *
+remaptable_add(
+	xfs_ino_t		dir_ino,
+	xfs_dahash_t		namehash,
+	const unsigned char	*old_name,
+	unsigned int		namelen,
+	const unsigned char	*new_name)
+{
+	struct remap_ent	*ent;
+
+	ent = malloc(sizeof(struct remap_ent) + (namelen * 2));
+	if (!ent)
+		return NULL;
+
+	ent->dir_ino = dir_ino;
+	ent->namehash = namehash;
+	ent->namelen = namelen;
+	memcpy(remap_ent_before(ent), old_name, namelen);
+	memcpy(remap_ent_after(ent), new_name, namelen);
+	ent->next = remaptable[namehash % REMAP_TABLE_SIZE];
+
+	remaptable[namehash % REMAP_TABLE_SIZE] = ent;
+
+	remap_debug("REMAP ADD: 0x%lx hash 0x%x '%.*s' -> '%.*s'\n",
+			dir_ino, namehash, namelen, old_name, namelen,
+			new_name);
+	return ent;
+}
+
 #define is_invalid_char(c)	((c) == '/' || (c) == '\0')
 #define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
 
@@ -1184,6 +1297,7 @@ generate_obfuscated_name(
 	int			namelen,
 	unsigned char		*name)
 {
+	unsigned char		*old_name = NULL;
 	xfs_dahash_t		hash;
 
 	/*
@@ -1205,8 +1319,32 @@ generate_obfuscated_name(
 		name++;
 
 	/* Obfuscate the name (if possible) */
-
 	hash = libxfs_da_hashname(name, namelen);
+
+	/*
+	 * If we're obfuscating a dirent name on a pptrs filesystem, see if we
+	 * already processed the parent pointer and use the same name.
+	 */
+	if (xfs_has_parent(mp) && ino) {
+		struct remap_ent	*remap;
+
+		remap = remaptable_find(cur_ino, hash, name, namelen);
+		if (remap) {
+			remap_debug("found obfuscated dir 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+					cur_ino, namelen,
+					remap_ent_before(remap), ino, namelen,
+					remap_ent_after(remap));
+			memcpy(name, remap_ent_after(remap), namelen);
+			return;
+		}
+
+		/*
+		 * If we haven't procesed this dirent name before, save the
+		 * old name for a remap table entry.  Obfuscate the name.
+		 */
+		old_name = alloca(namelen);
+		memcpy(old_name, name, namelen);
+	}
 	obfuscate_name(hash, namelen, name);
 
 	/*
@@ -1230,6 +1368,23 @@ generate_obfuscated_name(
 				"in dir inode %llu\n",
 			(unsigned long long) ino,
 			(unsigned long long) cur_ino);
+
+	/*
+	 * We've obfuscated a name in the directory entry.  Remember this
+	 * remapping for when we come across the parent pointer later.
+	 */
+	if (!old_name)
+		return;
+
+	remap_debug("obfuscating dir 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+			cur_ino, namelen, old_name, ino, namelen,
+			name);
+
+	if (!remaptable_add(cur_ino, hash, old_name, namelen, name))
+		print_warning("unable to record remapped dirent name for inode %llu "
+				"in dir inode %llu\n",
+			(unsigned long long) ino,
+			(unsigned long long) cur_ino);
 }
 
 static void
@@ -1361,6 +1516,123 @@ process_sf_symlink(
 		memset(&buf[len], 0, XFS_DFORK_DSIZE(dip, mp) - len);
 }
 
+static inline bool
+want_obfuscate_pptr(
+	unsigned int	nsp_flags,
+	const void	*name,
+	unsigned int	namelen,
+	const void	*value,
+	unsigned int	valuelen)
+{
+	if (!obfuscate)
+		return false;
+
+	/* Ignore if parent pointers aren't enabled. */
+	if (!xfs_has_parent(mp))
+		return false;
+
+	/* Ignore anything not claiming to be a parent pointer. */
+	if (!(nsp_flags & XFS_ATTR_PARENT))
+		return false;
+
+	/* Obfuscate this parent pointer if it passes basic checks. */
+	if (libxfs_parent_namecheck(mp, name, namelen, nsp_flags) &&
+	    libxfs_parent_valuecheck(mp, value, valuelen))
+		return true;
+
+	/* Ignore otherwise. */
+	return false;
+}
+
+static void
+obfuscate_parent_pointer(
+	const struct xfs_parent_name_rec *rec,
+	unsigned char			*value,
+	unsigned int			valuelen)
+{
+	struct xfs_parent_name_irec	irec;
+	struct remap_ent		*remap;
+	char				*old_name = irec.p_name;
+	xfs_dahash_t			hash;
+	xfs_ino_t			child_ino = cur_ino;
+
+	libxfs_parent_irec_from_disk(&irec, rec, value, valuelen);
+
+	/*
+	 * We don't obfuscate "lost+found" or any orphan files
+	 * therein.  If When the name table is used for extended
+	 * attributes, the inode number provided is 0, in which
+	 * case we don't need to make this check.
+	 */
+	cur_ino = irec.p_ino;
+	if (in_lost_found(child_ino, valuelen, value)) {
+		cur_ino = child_ino;
+		return;
+	}
+	cur_ino = child_ino;
+
+	/*
+	 * If the name starts with a slash, just skip over it.  It isn't
+	 * included in the hash and we don't record it in the name table.
+	 */
+	if (*value == '/') {
+		old_name++;
+		value++;
+		valuelen--;
+	}
+
+	hash = libxfs_da_hashname(value, valuelen);
+
+	/*
+	 * If we already processed the dirent, use the same name for the parent
+	 * pointer.
+	 */
+	remap = remaptable_find(irec.p_ino, hash, value, valuelen);
+	if (remap) {
+		remap_debug("found obfuscated pptr 0x%lx '%.*s' -> 0x%lx -> '%.*s' \n",
+				irec.p_ino, valuelen, remap_ent_before(remap),
+				cur_ino, valuelen, remap_ent_after(remap));
+		memcpy(value, remap_ent_after(remap), valuelen);
+		return;
+	}
+
+	/*
+	 * Obfuscate the parent pointer name and remember this for later
+	 * in case we encounter the dirent and need to reuse the name there.
+	 */
+	obfuscate_name(hash, valuelen, value);
+
+	remap_debug("obfuscated pptr 0x%lx '%.*s' -> 0x%lx -> '%.*s'\n",
+			irec.p_ino, valuelen, old_name, cur_ino, valuelen,
+			value);
+	if (!remaptable_add(irec.p_ino, hash, old_name, valuelen, value))
+		print_warning("unable to record remapped pptr name for inode %llu "
+				"in dir inode %llu\n",
+			(unsigned long long) cur_ino,
+			(unsigned long long) irec.p_ino);
+}
+
+static inline bool
+want_obfuscate_attr(
+	unsigned int	nsp_flags,
+	const void	*name,
+	unsigned int	namelen,
+	const void	*value,
+	unsigned int	valuelen)
+{
+	if (!obfuscate)
+		return false;
+
+	/*
+	 * If we didn't already obfuscate the parent pointer, it's probably
+	 * corrupt.  Leave it intact for analysis.
+	 */
+	if (nsp_flags & XFS_ATTR_PARENT)
+		return false;
+
+	return true;
+}
+
 static void
 process_sf_attr(
 	struct xfs_dinode		*dip)
@@ -1390,7 +1662,7 @@ process_sf_attr(
 	asfep = &asfp->list[0];
 	for (i = 0; (i < asfp->hdr.count) &&
 			((char *)asfep - (char *)asfp < ino_attr_size); i++) {
-
+		void	*name, *value;
 		int	namelen = asfep->namelen;
 
 		if (namelen == 0) {
@@ -1406,11 +1678,16 @@ process_sf_attr(
 			break;
 		}
 
-		if (obfuscate) {
-			generate_obfuscated_name(0, asfep->namelen,
-						 &asfep->nameval[0]);
-			memset(&asfep->nameval[asfep->namelen], 'v',
-			       asfep->valuelen);
+		name = &asfep->nameval[0];
+		value = &asfep->nameval[asfep->namelen];
+
+		if (want_obfuscate_pptr(asfep->flags, name, namelen, value,
+					asfep->valuelen)) {
+			obfuscate_parent_pointer(name, value, asfep->valuelen);
+		} else if (want_obfuscate_attr(asfep->flags, name, namelen,
+					value, asfep->valuelen)) {
+			generate_obfuscated_name(0, asfep->namelen, name);
+			memset(value, 'v', asfep->valuelen);
 		}
 
 		asfep = (struct xfs_attr_sf_entry *)((char *)asfep +
@@ -1777,6 +2054,9 @@ process_attr_block(
 			break;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
+			void *name, *value;
+			unsigned int valuelen;
+
 			local = xfs_attr3_leaf_name_local(leaf, i);
 			if (local->namelen == 0) {
 				if (show_warnings)
@@ -1785,11 +2065,21 @@ process_attr_block(
 						(long long)cur_ino);
 				break;
 			}
-			if (obfuscate) {
+
+			name = &local->nameval[0];
+			value = &local->nameval[local->namelen];
+			valuelen = be16_to_cpu(local->valuelen);
+
+			if (want_obfuscate_pptr(entry->flags, name,
+						local->namelen, value,
+						valuelen)) {
+				obfuscate_parent_pointer(name, value, valuelen);
+			} else if (want_obfuscate_attr(entry->flags, name,
+						local->namelen, value,
+						valuelen)) {
 				generate_obfuscated_name(0, local->namelen,
-					&local->nameval[0]);
-				memset(&local->nameval[local->namelen], 'v',
-					be16_to_cpu(local->valuelen));
+						name);
+				memset(value, 'v', valuelen);
 			}
 			/* zero from end of nameval[] to next name start */
 			nlen = local->namelen;
@@ -3166,6 +3456,7 @@ metadump_f(
 		pop_cur();
 out:
 	free(metablock);
+	remaptable_clear();
 
 	return 0;
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 092934935..11bde3073 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -143,6 +143,8 @@
 #define xfs_parent_finish		libxfs_parent_finish
 #define xfs_parent_irec_from_disk	libxfs_parent_irec_from_disk
 #define xfs_parent_start		libxfs_parent_start
+#define xfs_parent_namecheck		libxfs_parent_namecheck
+#define xfs_parent_valuecheck		libxfs_parent_valuecheck
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks

