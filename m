Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE7B85C46
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929138; cv=none; b=iTJDP+jXWXOQdPN6XSZ0Z8jVW30Fb80QOKwhq5qZpKlDe9Lxr8APatDLEXUuSfhQBSa596rhPi3AvcrpGNtKaU7Nerz3ra89KesyRjKF1z6qBpKt0nvuqBnpSv65R8elarcG0MqA75PAYln/jTU7eCb4PXw6BVSgLGAkYhXzdvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929138; c=relaxed/simple;
	bh=eeskZ1EbSDu9w28QJyc1K9Y3kiE+HFNbWc4u/EaSduo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TxgsVSblVjRzBhn5k8tRx4dHLTYPCCaqNL67Nc5iQgG7IcFeYyAHZjbTbaI6Tcvb8xut5eeywvuBi75ereM16RSOsh1BdYbEzr8dpSwX9Ig2vesTeZJD9ipiA/zNjPtR1dIp8ywGCi3uLcwFF16FoEVTjSzn4ELMT1t6RohUkfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u/cnnGQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u/cnnGQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2901C116B1;
	Wed, 24 Apr 2024 03:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929138;
	bh=eeskZ1EbSDu9w28QJyc1K9Y3kiE+HFNbWc4u/EaSduo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u/cnnGQRv7lF9mKc0T3vDg7b2xbwUG3Z8TZwUhhouwGxwa0xkFs44/vSbNc+kdaSV
	 JjvgMImiMPI2C2Qx7+AhtQKvyJdvUuRvGbShqq+WH9y9oBPmphOOsWIhRDzK671pJ+
	 j3bBs0BGTsIWC8YSrv7GTW4vsievUKZ+UB/BvrzN5KQAgFKxkqVVD9Lj8bAo6nNZSC
	 FvTesrOq/jeLZukFIJ8aXvcUZrqWHKJfVIIgE/3/4QLVXIeaXatbcCtyqa//yipYjR
	 zG2gRixNBOmgQhU6SWbqX/EtojgzrrUE9TIehvdpVUNMPAYjiTF6ByV2s9bXGrsVQu
	 XweHIfGxx16Zw==
Date: Tue, 23 Apr 2024 20:25:38 -0700
Subject: [PATCH 13/16] xfs: actually rebuild the parent pointer xattrs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784872.1906420.16252603149343334215.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Once we've assembled all the parent pointers for a file, we need to
commit the new dataset atomically to that file.  Parent pointer records
are embedded in the xattr structure, which means that we must write a
new extended attribute structure, again, atomically.  Therefore, we must
copy the non-parent-pointer attributes from the file being repaired into
the temporary file's extended attributes and then call the atomic extent
swap mechanism to exchange the blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c     |    2 
 fs/xfs/libxfs/xfs_attr.h     |    1 
 fs/xfs/scrub/attr_repair.c   |    4 
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/findparent.c    |    2 
 fs/xfs/scrub/parent_repair.c |  709 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h         |    2 
 7 files changed, 701 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ab6ec2f15d76..1c2a27fce08a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -948,7 +948,7 @@ xfs_attr_lookup(
 	return error;
 }
 
-STATIC int
+int
 xfs_attr_add_fork(
 	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 43dee4cbaab2..088cb7b30168 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -648,5 +648,6 @@ int __init xfs_attr_intent_init_cache(void);
 void xfs_attr_intent_destroy_cache(void);
 
 int xfs_attr_sf_totsize(struct xfs_inode *dp);
+int xfs_attr_add_fork(struct xfs_inode *ip, int size, int rsvd);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 87f6c9cb54eb..e059813b92b7 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1030,7 +1030,7 @@ xrep_xattr_reset_fork(
  * fork.  The caller must ILOCK the tempfile and join it to the transaction.
  * This function returns with the inode joined to a clean scrub transaction.
  */
-STATIC int
+int
 xrep_xattr_reset_tempfile_fork(
 	struct xfs_scrub	*sc)
 {
@@ -1336,7 +1336,7 @@ xrep_xattr_swap_prep(
 }
 
 /* Exchange the temporary file's attribute fork with the one being repaired. */
-STATIC int
+int
 xrep_xattr_swap(
 	struct xfs_scrub	*sc,
 	struct xrep_tempexch	*tx)
diff --git a/fs/xfs/scrub/attr_repair.h b/fs/xfs/scrub/attr_repair.h
index 0a9ffa7cfa90..979729bd4a5f 100644
--- a/fs/xfs/scrub/attr_repair.h
+++ b/fs/xfs/scrub/attr_repair.h
@@ -6,6 +6,10 @@
 #ifndef __XFS_SCRUB_ATTR_REPAIR_H__
 #define __XFS_SCRUB_ATTR_REPAIR_H__
 
+struct xrep_tempexch;
+
+int xrep_xattr_swap(struct xfs_scrub *sc, struct xrep_tempexch *tx);
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
+int xrep_xattr_reset_tempfile_fork(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_ATTR_REPAIR_H__ */
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index c78422ad757b..01766041ba2c 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_exchmaps.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -33,6 +34,7 @@
 #include "scrub/findparent.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
+#include "scrub/listxattr.h"
 
 /*
  * Finding the Parent of a Directory
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 311bc7990d7c..28e9746c0663 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -25,6 +25,8 @@
 #include "xfs_health.h"
 #include "xfs_exchmaps.h"
 #include "xfs_parent.h"
+#include "xfs_attr.h"
+#include "xfs_bmap.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -34,10 +36,13 @@
 #include "scrub/findparent.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
+#include "scrub/tempexch.h"
 #include "scrub/orphanage.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/xfblob.h"
+#include "scrub/attr_repair.h"
+#include "scrub/listxattr.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -65,9 +70,9 @@
  *
  * When salvaging completes, the remaining stashed entries are replayed to the
  * temporary file.  All non-parent pointer extended attributes are copied to
- * the temporary file's extended attributes.  An atomic extent swap is used to
- * commit the new directory blocks to the directory being repaired.  This will
- * disrupt attrmulti cursors.
+ * the temporary file's extended attributes.  An atomic file mapping exchange
+ * is used to commit the new xattr blocks to the file being repaired.  This
+ * will disrupt attrmulti cursors.
  */
 
 /* Create a parent pointer in the tempfile. */
@@ -106,6 +111,23 @@ struct xrep_parent {
 	/* Blobs containing parent pointer names. */
 	struct xfblob		*pptr_names;
 
+	/* xattr keys */
+	struct xfarray		*xattr_records;
+
+	/* xattr values */
+	struct xfblob		*xattr_blobs;
+
+	/* Scratch buffers for saving extended attributes */
+	unsigned char		*xattr_name;
+	void			*xattr_value;
+	unsigned int		xattr_value_sz;
+
+	/*
+	 * Information used to exchange the attr fork mappings, if the fs
+	 * supports parent pointers.
+	 */
+	struct xrep_tempexch	tx;
+
 	/*
 	 * Information used to scan the filesystem to find the inumber of the
 	 * dotdot entry for this directory.  On filesystems without parent
@@ -117,6 +139,8 @@ struct xrep_parent {
 	 * @pscan.lock coordinates access to pptr_recs, pptr_names, pptr, and
 	 * pptr_scratch.  This reduces the memory requirements of this
 	 * structure.
+	 *
+	 * The lock also controls access to xattr_records and xattr_blobs(?)
 	 */
 	struct xrep_parent_scan_info pscan;
 
@@ -129,14 +153,48 @@ struct xrep_parent {
 
 	/* Scratch buffer for scanning pptr xattrs */
 	struct xfs_da_args	pptr_args;
+
+	/* Have we seen any live updates of parent pointers recently? */
+	bool			saw_pptr_updates;
 };
 
+struct xrep_parent_xattr {
+	/* Cookie for retrieval of the xattr name. */
+	xfblob_cookie		name_cookie;
+
+	/* Cookie for retrieval of the xattr value. */
+	xfblob_cookie		value_cookie;
+
+	/* XFS_ATTR_* flags */
+	int			flags;
+
+	/* Length of the value and name. */
+	uint32_t		valuelen;
+	uint16_t		namelen;
+};
+
+/*
+ * Stash up to 8 pages of attrs in xattr_records/xattr_blobs before we write
+ * them to the temp file.
+ */
+#define XREP_PARENT_XATTR_MAX_STASH_BYTES	(PAGE_SIZE * 8)
+
 /* Tear down all the incore stuff we created. */
 static void
 xrep_parent_teardown(
 	struct xrep_parent	*rp)
 {
 	xrep_findparent_scan_teardown(&rp->pscan);
+	kvfree(rp->xattr_name);
+	rp->xattr_name = NULL;
+	kvfree(rp->xattr_value);
+	rp->xattr_value = NULL;
+	if (rp->xattr_blobs)
+		xfblob_destroy(rp->xattr_blobs);
+	rp->xattr_blobs = NULL;
+	if (rp->xattr_records)
+		xfarray_destroy(rp->xattr_records);
+	rp->xattr_records = NULL;
 	if (rp->pptr_names)
 		xfblob_destroy(rp->pptr_names);
 	rp->pptr_names = NULL;
@@ -556,10 +614,11 @@ xrep_parent_scan_dirtree(
 	}
 
 	/*
-	 * Cancel the empty transaction so that we can (later) use the atomic
-	 * extent swap helpers to lock files and commit the new directory.
+	 * Retake sc->ip's ILOCK now that we're done flushing stashed parent
+	 * pointers.  We end this function with an empty transaction and the
+	 * ILOCK.
 	 */
-	xchk_trans_cancel(rp->sc);
+	xchk_ilock(rp->sc, XFS_ILOCK_EXCL);
 	return 0;
 }
 
@@ -594,6 +653,8 @@ xrep_parent_live_update(
 		else
 			error = xrep_parent_stash_parentremove(rp, p->name,
 					p->dp);
+		if (!error)
+			rp->saw_pptr_updates = true;
 		mutex_unlock(&rp->pscan.lock);
 		if (error)
 			goto out_abort;
@@ -648,6 +709,55 @@ xrep_parent_reset_dotdot(
 	return xfs_trans_roll(&sc->tp);
 }
 
+/* Pass back the parent inumber if this a parent pointer */
+STATIC int
+xrep_parent_lookup_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	xfs_ino_t		*inop = priv;
+	xfs_ino_t		parent_ino;
+	int			error;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	error = xfs_parent_from_attr(sc->mp, attr_flags, name, namelen, value,
+			valuelen, &parent_ino, NULL);
+	if (error)
+		return error;
+
+	*inop = parent_ino;
+	return -ECANCELED;
+}
+
+/*
+ * Find the first parent of the scrub target by walking parent pointers for
+ * the purpose of deciding if we're going to move it to the orphanage.
+ * We don't care if the attr fork is zapped.
+ */
+STATIC int
+xrep_parent_lookup_pptrs(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		*inop)
+{
+	int			error;
+
+	*inop = NULLFSINO;
+
+	error = xchk_xattr_walk(sc, sc->ip, xrep_parent_lookup_pptr, NULL,
+			inop);
+	if (error && error != -ECANCELED)
+		return error;
+	return 0;
+}
+
 /*
  * Move the current file to the orphanage.
  *
@@ -664,14 +774,26 @@ xrep_parent_move_to_orphanage(
 	xfs_ino_t		orig_parent, new_parent;
 	int			error;
 
-	/*
-	 * We are about to drop the ILOCK on sc->ip to lock the orphanage and
-	 * prepare for the adoption.  Therefore, look up the old dotdot entry
-	 * for sc->ip so that we can compare it after we re-lock sc->ip.
-	 */
-	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &orig_parent);
-	if (error)
-		return error;
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		/*
+		 * We are about to drop the ILOCK on sc->ip to lock the
+		 * orphanage and prepare for the adoption.  Therefore, look up
+		 * the old dotdot entry for sc->ip so that we can compare it
+		 * after we re-lock sc->ip.
+		 */
+		error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot,
+				&orig_parent);
+		if (error)
+			return error;
+	} else {
+		/*
+		 * We haven't dropped the ILOCK since we committed the new
+		 * xattr structure (and hence the new parent pointer records),
+		 * which means that the file cannot have been moved in the
+		 * directory tree, and there are no parents.
+		 */
+		orig_parent = NULLFSINO;
+	}
 
 	/*
 	 * Drop the ILOCK on the scrub target and commit the transaction.
@@ -704,9 +826,14 @@ xrep_parent_move_to_orphanage(
 	 * Now that we've reacquired the ILOCK on sc->ip, look up the dotdot
 	 * entry again.  If the parent changed or the child was unlinked while
 	 * the child directory was unlocked, we don't need to move the child to
-	 * the orphanage after all.
+	 * the orphanage after all.  For a non-directory, we have to scan for
+	 * the first parent pointer to see if one has been added.
 	 */
-	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &new_parent);
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
+		error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot,
+				&new_parent);
+	else
+		error = xrep_parent_lookup_pptrs(sc, &new_parent);
 	if (error)
 		return error;
 
@@ -733,6 +860,488 @@ xrep_parent_move_to_orphanage(
 	return 0;
 }
 
+/* Ensure that the xattr value buffer is large enough. */
+STATIC int
+xrep_parent_alloc_xattr_value(
+	struct xrep_parent	*rp,
+	size_t			bufsize)
+{
+	void			*new_val;
+
+	if (rp->xattr_value_sz >= bufsize)
+		return 0;
+
+	if (rp->xattr_value) {
+		kvfree(rp->xattr_value);
+		rp->xattr_value = NULL;
+		rp->xattr_value_sz = 0;
+	}
+
+	new_val = kvmalloc(bufsize, XCHK_GFP_FLAGS);
+	if (!new_val)
+		return -ENOMEM;
+
+	rp->xattr_value = new_val;
+	rp->xattr_value_sz = bufsize;
+	return 0;
+}
+
+/* Retrieve the (remote) value of a non-pptr xattr. */
+STATIC int
+xrep_parent_fetch_xattr_remote(
+	struct xrep_parent	*rp,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	unsigned int		valuelen)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	struct xfs_da_args	args = {
+		.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.geo		= sc->mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.dp		= ip,
+		.name		= name,
+		.namelen	= namelen,
+		.trans		= sc->tp,
+		.valuelen	= valuelen,
+		.owner		= ip->i_ino,
+	};
+	int			error;
+
+	/*
+	 * If we need a larger value buffer, try to allocate one.  If that
+	 * fails, return with -EDEADLOCK to try harder.
+	 */
+	error = xrep_parent_alloc_xattr_value(rp, valuelen);
+	if (error == -ENOMEM)
+		return -EDEADLOCK;
+	if (error)
+		return error;
+
+	args.value = rp->xattr_value;
+	xfs_attr_sethash(&args);
+	return xfs_attr_get_ilocked(&args);
+}
+
+/* Stash non-pptr attributes for later replay into the temporary file. */
+STATIC int
+xrep_parent_stash_xattr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xrep_parent_xattr key = {
+		.valuelen	= valuelen,
+		.namelen	= namelen,
+		.flags		= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+	};
+	struct xrep_parent	*rp = priv;
+	int			error;
+
+	if (attr_flags & (XFS_ATTR_INCOMPLETE | XFS_ATTR_PARENT))
+		return 0;
+
+	if (!value) {
+		error = xrep_parent_fetch_xattr_remote(rp, ip, attr_flags,
+				name, namelen, valuelen);
+		if (error)
+			return error;
+
+		value = rp->xattr_value;
+	}
+
+	trace_xrep_parent_stash_xattr(rp->sc->tempip, key.flags, (void *)name,
+			key.namelen, key.valuelen);
+
+	error = xfblob_store(rp->xattr_blobs, &key.name_cookie, name,
+			key.namelen);
+	if (error)
+		return error;
+
+	error = xfblob_store(rp->xattr_blobs, &key.value_cookie, value,
+			key.valuelen);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->xattr_records, &key);
+}
+
+/* Insert one xattr key/value. */
+STATIC int
+xrep_parent_insert_xattr(
+	struct xrep_parent		*rp,
+	const struct xrep_parent_xattr	*key)
+{
+	struct xfs_da_args		args = {
+		.dp			= rp->sc->tempip,
+		.attr_filter		= key->flags,
+		.namelen		= key->namelen,
+		.valuelen		= key->valuelen,
+		.owner			= rp->sc->ip->i_ino,
+		.geo			= rp->sc->mp->m_attr_geo,
+		.whichfork		= XFS_ATTR_FORK,
+		.op_flags		= XFS_DA_OP_OKNOENT,
+	};
+	int				error;
+
+	ASSERT(!(key->flags & XFS_ATTR_PARENT));
+
+	/*
+	 * Grab pointers to the scrub buffer so that we can use them to insert
+	 * attrs into the temp file.
+	 */
+	args.name = rp->xattr_name;
+	args.value = rp->xattr_value;
+
+	/*
+	 * The attribute name is stored near the end of the in-core buffer,
+	 * though we reserve one more byte to ensure null termination.
+	 */
+	rp->xattr_name[XATTR_NAME_MAX] = 0;
+
+	error = xfblob_load(rp->xattr_blobs, key->name_cookie, rp->xattr_name,
+			key->namelen);
+	if (error)
+		return error;
+
+	error = xfblob_free(rp->xattr_blobs, key->name_cookie);
+	if (error)
+		return error;
+
+	error = xfblob_load(rp->xattr_blobs, key->value_cookie, args.value,
+			key->valuelen);
+	if (error)
+		return error;
+
+	error = xfblob_free(rp->xattr_blobs, key->value_cookie);
+	if (error)
+		return error;
+
+	rp->xattr_name[key->namelen] = 0;
+
+	trace_xrep_parent_insert_xattr(rp->sc->tempip, key->flags,
+			rp->xattr_name, key->namelen, key->valuelen);
+
+	xfs_attr_sethash(&args);
+	return xfs_attr_set(&args, XFS_ATTRUPDATE_UPSERT, false);
+}
+
+/*
+ * Periodically flush salvaged attributes to the temporary file.  This is done
+ * to reduce the memory requirements of the xattr rebuild because files can
+ * contain millions of attributes.
+ */
+STATIC int
+xrep_parent_flush_xattrs(
+	struct xrep_parent	*rp)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	/*
+	 * Entering this function, the scrub context has a reference to the
+	 * inode being repaired, the temporary file, and the empty scrub
+	 * transaction that we created for the xattr scan.  We hold ILOCK_EXCL
+	 * on the inode being repaired.
+	 *
+	 * To constrain kernel memory use, we occasionally flush salvaged
+	 * xattrs from the xfarray and xfblob structures into the temporary
+	 * file in preparation for exchanging the xattr structures at the end.
+	 * Updating the temporary file requires a transaction, so we commit the
+	 * scrub transaction and drop the ILOCK so that xfs_attr_set can
+	 * allocate whatever transaction it wants.
+	 *
+	 * We still hold IOLOCK_EXCL on the inode being repaired, which
+	 * prevents anyone from adding xattrs (or parent pointers) while we're
+	 * flushing.
+	 */
+	xchk_trans_cancel(rp->sc);
+	xchk_iunlock(rp->sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Take the IOLOCK of the temporary file while we modify xattrs.  This
+	 * isn't strictly required because the temporary file is never revealed
+	 * to userspace, but we follow the same locking rules.  We still hold
+	 * sc->ip's IOLOCK.
+	 */
+	error = xrep_tempfile_iolock_polled(rp->sc);
+	if (error)
+		return error;
+
+	/* Add all the salvaged attrs to the temporary file. */
+	foreach_xfarray_idx(rp->xattr_records, array_cur) {
+		struct xrep_parent_xattr	key;
+
+		error = xfarray_load(rp->xattr_records, array_cur, &key);
+		if (error)
+			return error;
+
+		error = xrep_parent_insert_xattr(rp, &key);
+		if (error)
+			return error;
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rp->xattr_records);
+	xfblob_truncate(rp->xattr_blobs);
+
+	xrep_tempfile_iounlock(rp->sc);
+
+	/* Recreate the empty transaction and relock the inode. */
+	error = xchk_trans_alloc_empty(rp->sc);
+	if (error)
+		return error;
+	xchk_ilock(rp->sc, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/* Decide if we've stashed too much xattr data in memory. */
+static inline bool
+xrep_parent_want_flush_xattrs(
+	struct xrep_parent	*rp)
+{
+	unsigned long long	bytes;
+
+	bytes = xfarray_bytes(rp->xattr_records) +
+		xfblob_bytes(rp->xattr_blobs);
+	return bytes > XREP_PARENT_XATTR_MAX_STASH_BYTES;
+}
+
+/* Flush staged attributes to the temporary file if we're over the limit. */
+STATIC int
+xrep_parent_try_flush_xattrs(
+	struct xfs_scrub	*sc,
+	void			*priv)
+{
+	struct xrep_parent	*rp = priv;
+	int			error;
+
+	if (!xrep_parent_want_flush_xattrs(rp))
+		return 0;
+
+	error = xrep_parent_flush_xattrs(rp);
+	if (error)
+		return error;
+
+	/*
+	 * If there were any parent pointer updates to the xattr structure
+	 * while we dropped the ILOCK, the xattr structure is now stale.
+	 * Signal to the attr copy process that we need to start over, but
+	 * this time without opportunistic attr flushing.
+	 *
+	 * This is unlikely to happen, so we're ok with restarting the copy.
+	 */
+	mutex_lock(&rp->pscan.lock);
+	if (rp->saw_pptr_updates)
+		error = -ESTALE;
+	mutex_unlock(&rp->pscan.lock);
+	return error;
+}
+
+/* Copy all the non-pptr extended attributes into the temporary file. */
+STATIC int
+xrep_parent_copy_xattrs(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	/*
+	 * Clear the pptr updates flag.  We hold sc->ip ILOCKed, so there
+	 * can't be any parent pointer updates in progress.
+	 */
+	mutex_lock(&rp->pscan.lock);
+	rp->saw_pptr_updates = false;
+	mutex_unlock(&rp->pscan.lock);
+
+	/* Copy xattrs, stopping periodically to flush the incore buffers. */
+	error = xchk_xattr_walk(sc, sc->ip, xrep_parent_stash_xattr,
+			xrep_parent_try_flush_xattrs, rp);
+	if (error && error != -ESTALE)
+		return error;
+
+	if (error == -ESTALE) {
+		/*
+		 * The xattr copy collided with a parent pointer update.
+		 * Restart the copy, but this time hold the ILOCK all the way
+		 * to the end to lock out any directory parent pointer updates.
+		 */
+		error = xchk_xattr_walk(sc, sc->ip, xrep_parent_stash_xattr,
+				NULL, rp);
+		if (error)
+			return error;
+	}
+
+	/* Flush any remaining stashed xattrs to the temporary file. */
+	if (xfarray_bytes(rp->xattr_records) == 0)
+		return 0;
+
+	return xrep_parent_flush_xattrs(rp);
+}
+
+/*
+ * Ensure that @sc->ip and @sc->tempip both have attribute forks before we head
+ * into the attr fork exchange transaction.  All files on a filesystem with
+ * parent pointers must have an attr fork because the parent pointer code does
+ * not itself add attribute forks.
+ *
+ * Note: Unlinkable unlinked files don't need one, but the overhead of having
+ * an unnecessary attr fork is not justified by the additional code complexity
+ * that would be needed to track that state correctly.
+ */
+STATIC int
+xrep_parent_ensure_attr_fork(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	error = xfs_attr_add_fork(sc->tempip,
+			sizeof(struct xfs_attr_sf_hdr), 1);
+	if (error)
+		return error;
+	return xfs_attr_add_fork(sc->ip, sizeof(struct xfs_attr_sf_hdr), 1);
+}
+
+/*
+ * Finish replaying stashed parent pointer updates, allocate a transaction for
+ * exchanging extent mappings, and take the ILOCKs of both files before we
+ * commit the new attribute structure.
+ */
+STATIC int
+xrep_parent_finalize_tempfile(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	/*
+	 * Repair relies on the ILOCK to quiesce all possible xattr updates.
+	 * Replay all queued parent pointer updates into the tempfile before
+	 * exchanging the contents, even if that means dropping the ILOCKs and
+	 * the transaction.
+	 */
+	do {
+		error = xrep_parent_replay_updates(rp);
+		if (error)
+			return error;
+
+		error = xrep_parent_ensure_attr_fork(rp);
+		if (error)
+			return error;
+
+		error = xrep_tempexch_trans_alloc(sc, XFS_ATTR_FORK, &rp->tx);
+		if (error)
+			return error;
+
+		if (xfarray_length(rp->pptr_recs) == 0)
+			break;
+
+		xchk_trans_cancel(sc);
+		xrep_tempfile_iunlock_both(sc);
+	} while (!xchk_should_terminate(sc, &error));
+	return error;
+}
+
+/*
+ * Replay all the stashed parent pointers into the temporary file, copy all
+ * the non-pptr xattrs from the file being repaired into the temporary file,
+ * and exchange the attr fork contents atomically.
+ */
+STATIC int
+xrep_parent_rebuild_pptrs(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	xfs_ino_t		parent_ino = NULLFSINO;
+	int			error;
+
+	/*
+	 * Copy non-ppttr xattrs from the file being repaired into the
+	 * temporary file's xattr structure.  We hold sc->ip's IOLOCK, which
+	 * prevents setxattr/removexattr calls from occurring, but renames
+	 * update the parent pointers without holding IOLOCK.  If we detect
+	 * stale attr structures, we restart the scan but only flush at the
+	 * end.
+	 */
+	error = xrep_parent_copy_xattrs(rp);
+	if (error)
+		return error;
+
+	/*
+	 * Cancel the empty transaction that we used to walk and copy attrs,
+	 * and drop the ILOCK so that we can take the IOLOCK on the temporary
+	 * file.  We still hold sc->ip's IOLOCK.
+	 */
+	xchk_trans_cancel(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	error = xrep_tempfile_iolock_polled(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Allocate transaction, lock inodes, and make sure that we've replayed
+	 * all the stashed pptr updates to the tempdir.  After this point,
+	 * we're ready to exchange the attr fork mappings.
+	 */
+	error = xrep_parent_finalize_tempfile(rp);
+	if (error)
+		return error;
+
+	/* Last chance to abort before we start committing pptr fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	if (xchk_iscan_aborted(&rp->pscan.iscan))
+		return -ECANCELED;
+
+	/*
+	 * Exchange the attr fork contents and junk the old attr fork contents,
+	 * which are now in the tempfile.
+	 */
+	error = xrep_xattr_swap(sc, &rp->tx);
+	if (error)
+		return error;
+	error = xrep_xattr_reset_tempfile_fork(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Roll to get a transaction without any inodes joined to it.  Then we
+	 * can drop the tempfile's ILOCK and IOLOCK before doing more work on
+	 * the scrub target file.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+	xrep_tempfile_iunlock(sc);
+	xrep_tempfile_iounlock(sc);
+
+	/*
+	 * We've committed the new parent pointers.  Find at least one parent
+	 * so that we can decide if we're moving this file to the orphanage.
+	 * For this purpose, root directories are their own parents.
+	 */
+	if (sc->ip == sc->mp->m_rootip) {
+		xrep_findparent_scan_found(&rp->pscan, sc->ip->i_ino);
+	} else {
+		error = xrep_parent_lookup_pptrs(sc, &parent_ino);
+		if (error)
+			return error;
+		if (parent_ino != NULLFSINO)
+			xrep_findparent_scan_found(&rp->pscan, parent_ino);
+	}
+	return 0;
+}
+
 /*
  * Commit the new parent pointer structure (currently only the dotdot entry) to
  * the file that we're repairing.
@@ -741,13 +1350,24 @@ STATIC int
 xrep_parent_rebuild_tree(
 	struct xrep_parent	*rp)
 {
+	int			error;
+
+	if (xfs_has_parent(rp->sc->mp)) {
+		error = xrep_parent_rebuild_pptrs(rp);
+		if (error)
+			return error;
+	}
+
 	if (rp->pscan.parent_ino == NULLFSINO) {
 		if (xrep_orphanage_can_adopt(rp->sc))
 			return xrep_parent_move_to_orphanage(rp);
 		return -EFSCORRUPTED;
 	}
 
-	return xrep_parent_reset_dotdot(rp);
+	if (S_ISDIR(VFS_I(rp->sc->ip)->i_mode))
+		return xrep_parent_reset_dotdot(rp);
+
+	return 0;
 }
 
 /* Set up the filesystem scan so we can look for parents. */
@@ -757,18 +1377,39 @@ xrep_parent_setup_scan(
 {
 	struct xfs_scrub	*sc = rp->sc;
 	char			*descr;
+	struct xfs_da_geometry	*geo = sc->mp->m_attr_geo;
+	int			max_len;
 	int			error;
 
 	if (!xfs_has_parent(sc->mp))
 		return xrep_findparent_scan_start(sc, &rp->pscan);
 
+	/* Buffers for copying non-pptr attrs to the tempfile */
+	rp->xattr_name = kvmalloc(XATTR_NAME_MAX + 1, XCHK_GFP_FLAGS);
+	if (!rp->xattr_name)
+		return -ENOMEM;
+
+	/*
+	 * Allocate enough memory to handle loading local attr values from the
+	 * xfblob data while flushing stashed attrs to the temporary file.
+	 * We only realloc the buffer when salvaging remote attr values, so
+	 * TRY_HARDER means we allocate the maximal attr value size.
+	 */
+	if (sc->flags & XCHK_TRY_HARDER)
+		max_len = XATTR_SIZE_MAX;
+	else
+		max_len = xfs_attr_leaf_entsize_local_max(geo->blksize);
+	error = xrep_parent_alloc_xattr_value(rp, max_len);
+	if (error)
+		goto out_xattr_name;
+
 	/* Set up some staging memory for logging parent pointer updates. */
 	descr = xchk_xfile_ino_descr(sc, "parent pointer entries");
 	error = xfarray_create(descr, 0, sizeof(struct xrep_pptr),
 			&rp->pptr_recs);
 	kfree(descr);
 	if (error)
-		return error;
+		goto out_xattr_value;
 
 	descr = xchk_xfile_ino_descr(sc, "parent pointer names");
 	error = xfblob_create(descr, &rp->pptr_names);
@@ -776,19 +1417,47 @@ xrep_parent_setup_scan(
 	if (error)
 		goto out_recs;
 
+	/* Set up some storage for copying attrs before the mapping exchange */
+	descr = xchk_xfile_ino_descr(sc,
+				"parent pointer retained xattr entries");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_parent_xattr),
+			&rp->xattr_records);
+	kfree(descr);
+	if (error)
+		goto out_names;
+
+	descr = xchk_xfile_ino_descr(sc,
+				"parent pointer retained xattr values");
+	error = xfblob_create(descr, &rp->xattr_blobs);
+	kfree(descr);
+	if (error)
+		goto out_attr_keys;
+
 	error = __xrep_findparent_scan_start(sc, &rp->pscan,
 			xrep_parent_live_update);
 	if (error)
-		goto out_names;
+		goto out_attr_values;
 
 	return 0;
 
+out_attr_values:
+	xfblob_destroy(rp->xattr_blobs);
+	rp->xattr_blobs = NULL;
+out_attr_keys:
+	xfarray_destroy(rp->xattr_records);
+	rp->xattr_records = NULL;
 out_names:
 	xfblob_destroy(rp->pptr_names);
 	rp->pptr_names = NULL;
 out_recs:
 	xfarray_destroy(rp->pptr_recs);
 	rp->pptr_recs = NULL;
+out_xattr_value:
+	kvfree(rp->xattr_value);
+	rp->xattr_value = NULL;
+out_xattr_name:
+	kvfree(rp->xattr_name);
+	rp->xattr_name = NULL;
 	return error;
 }
 
@@ -818,7 +1487,7 @@ xrep_parent(
 	if (error)
 		goto out_teardown;
 
-	/* Last chance to abort before we start committing fixes. */
+	/* Last chance to abort before we start committing dotdot fixes. */
 	if (xchk_should_terminate(sc, &error))
 		goto out_teardown;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3e0cd482379c..ecfaa4b88910 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2539,6 +2539,8 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
 	TP_ARGS(ip, flags, name, namelen, valuelen))
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_salvage_rec);
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_insert_rec);
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_parent_stash_xattr);
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_parent_insert_xattr);
 
 DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name,

