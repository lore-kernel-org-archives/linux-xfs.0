Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66BE8C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZCTI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjEZCTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:19:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE2DF7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:19:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D33861207
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06002C433D2;
        Fri, 26 May 2023 02:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067540;
        bh=4QKU+v29WBL3qPbEAnBfBdKkbqGjUlKpQK6J+2MX2Ps=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XB4QQSzVVD47s3vDeQ9Dil7rZQMeiiea4Bryoro0Mn1dejCNQ0+XtR2JoUA479p2G
         qis7WNP3dq5Xs71rzNzcS/S67zP6dEpUM/AG/eGEHqJSiTfic9wAgWDt3XvoGUgKrX
         ouYaGN242xDf8AlrQE0BTxZMd8M4xq6ELQmr5kfMqxV+5K8M33lmC+2a7Jer9c6rff
         fSWeLOGpovYjpHvOHZ+Do1b9g5fOwFPWNTol/nGr9Vx+EJnjVdFRdEIg7YxyGrA6k2
         LL1/kLHc+wIKl4Sa7XmOS5ZZHeADXZnMJve79OG7hcjrk61pzKZZWlGzaXJ+mNUCbg
         7R9N1WOI52Z0g==
Date:   Thu, 25 May 2023 19:18:59 -0700
Subject: [PATCH 17/17] xfs: actually rebuild the parent pointer xattrs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073538.3745075.4196304428643360910.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Once we've assembled all the parent pointers for a file, we need to
commit the new dataset atomically to that file.  Parent pointer records
are embedded in the xattr structure, which means that we must write a
new extended attribute structure, again, atomically.  Therefore, we must
copy the non-parent-pointer attributes from the file being repaired into
the temporary file's extended attributes and then call the atomic extent
swap mechanism to exchange the blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c          |    2 
 fs/xfs/scrub/attr_repair.c   |    4 
 fs/xfs/scrub/attr_repair.h   |    4 
 fs/xfs/scrub/dir_repair.c    |    3 
 fs/xfs/scrub/findparent.c    |   52 +++
 fs/xfs/scrub/findparent.h    |    2 
 fs/xfs/scrub/listxattr.c     |   10 +
 fs/xfs/scrub/listxattr.h     |    4 
 fs/xfs/scrub/parent.c        |    5 
 fs/xfs/scrub/parent_repair.c |  706 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h         |    2 
 11 files changed, 770 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index f213d745746f..555e1b65c78a 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -647,7 +647,7 @@ xchk_xattr(
 	 * iteration, which doesn't really follow the usual buffer
 	 * locking order.
 	 */
-	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_xattr_actor, NULL, NULL);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
 		return error;
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 23bc72773e33..71dcbe64609f 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1036,7 +1036,7 @@ xrep_xattr_reset_fork(
  * fork.  The caller must ILOCK the tempfile and join it to the transaction.
  * This function returns with the inode joined to a clean scrub transaction.
  */
-STATIC int
+int
 xrep_xattr_reset_tempfile_fork(
 	struct xfs_scrub	*sc)
 {
@@ -1360,7 +1360,7 @@ xrep_xattr_swap_prep(
 }
 
 /* Swap the temporary file's attribute fork with the one being repaired. */
-STATIC int
+int
 xrep_xattr_swap(
 	struct xfs_scrub	*sc,
 	struct xrep_tempswap	*tx)
diff --git a/fs/xfs/scrub/attr_repair.h b/fs/xfs/scrub/attr_repair.h
index 372c2d0eff68..f0f2c7edcb4c 100644
--- a/fs/xfs/scrub/attr_repair.h
+++ b/fs/xfs/scrub/attr_repair.h
@@ -6,6 +6,10 @@
 #ifndef __XFS_SCRUB_ATTR_REPAIR_H__
 #define __XFS_SCRUB_ATTR_REPAIR_H__
 
+struct xrep_tempswap;
+
+int xrep_xattr_swap(struct xfs_scrub *sc, struct xrep_tempswap *tx);
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
+int xrep_xattr_reset_tempfile_fork(struct xfs_scrub *sc);
 
 #endif /* __XFS_SCRUB_ATTR_REPAIR_H__ */
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 3a33f556616d..46ce6d06312e 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1283,7 +1283,8 @@ xrep_dir_scan_file(
 	if (!xrep_dir_want_scan(rd, ip))
 		goto scan_done;
 
-	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_parent_pointer, rd);
+	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_parent_pointer, NULL,
+			rd);
 	if (error)
 		goto scan_done;
 
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index da21792758d9..cc2ac55f57bf 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_swapext.h"
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
@@ -453,3 +455,53 @@ xrep_findparent_from_dcache(
 out:
 	return ret;
 }
+
+/* Pass back the parent inumber if this a parent pointer */
+STATIC int
+xrep_findparent_from_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xfs_parent_name_irec	pptr;
+	struct xfs_mount	*mp = sc->mp;
+	const void		*rec = name;
+	xfs_ino_t		*inop = priv;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	if (!xfs_parent_namecheck(mp, rec, namelen, attr_flags) ||
+	    !xfs_parent_valuecheck(mp, value, valuelen))
+		return -EFSCORRUPTED;
+
+	xfs_parent_irec_from_disk(&pptr, rec, value, valuelen);
+	*inop = pptr.p_ino;
+	return -ECANCELED;
+}
+
+/*
+ * Find the first parent of the inode being scrubbed by walking parent
+ * pointers.  Caller must hold sc->ip's ILOCK.
+ */
+int
+xrep_findparent_from_pptrs(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		*inop)
+{
+	int			error;
+
+	*inop = NULLFSINO;
+
+	error = xchk_xattr_walk(sc, sc->ip, xrep_findparent_from_pptr, NULL,
+			inop);
+	if (error && error != -ECANCELED)
+		return error;
+	return 0;
+}
+
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index cdd2e4405088..3abc4309f89d 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -53,4 +53,6 @@ int xrep_findparent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
 xfs_ino_t xrep_findparent_self_reference(struct xfs_scrub *sc);
 xfs_ino_t xrep_findparent_from_dcache(struct xfs_scrub *sc);
 
+int xrep_findparent_from_pptrs(struct xfs_scrub *sc, xfs_ino_t *inop);
+
 #endif /* __XFS_SCRUB_FINDPARENT_H__ */
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 322715b2fd68..3dbf1a2f8bc9 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -220,6 +220,7 @@ xchk_xattr_walk_node(
 	struct xfs_scrub		*sc,
 	struct xfs_inode		*ip,
 	xchk_xattr_fn			attr_fn,
+	xchk_xattrleaf_fn		leaf_fn,
 	void				*priv)
 {
 	struct xfs_attr3_icleaf_hdr	leafhdr;
@@ -251,6 +252,12 @@ xchk_xattr_walk_node(
 
 		xfs_trans_brelse(sc->tp, leaf_bp);
 
+		if (leaf_fn) {
+			error = leaf_fn(sc, priv);
+			if (error)
+				goto out_bitmap;
+		}
+
 		/* Make sure we haven't seen this new leaf already. */
 		len = 1;
 		if (xbitmap_test(&seen_blocks, leafhdr.forw, &len))
@@ -285,6 +292,7 @@ xchk_xattr_walk(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip,
 	xchk_xattr_fn		attr_fn,
+	xchk_xattrleaf_fn	leaf_fn,
 	void			*priv)
 {
 	int			error;
@@ -305,5 +313,5 @@ xchk_xattr_walk(
 	if (xfs_attr_is_leaf(ip))
 		return xchk_xattr_walk_leaf(sc, ip, attr_fn, priv);
 
-	return xchk_xattr_walk_node(sc, ip, attr_fn, priv);
+	return xchk_xattr_walk_node(sc, ip, attr_fn, leaf_fn, priv);
 }
diff --git a/fs/xfs/scrub/listxattr.h b/fs/xfs/scrub/listxattr.h
index fce419255dc0..0cebeecd49ae 100644
--- a/fs/xfs/scrub/listxattr.h
+++ b/fs/xfs/scrub/listxattr.h
@@ -11,7 +11,9 @@ typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
 		unsigned int namelen, const void *value, unsigned int valuelen,
 		void *priv);
 
+typedef int (*xchk_xattrleaf_fn)(struct xfs_scrub *sc, void *priv);
+
 int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
-		xchk_xattr_fn attr_fn, void *priv);
+		xchk_xattr_fn attr_fn, xchk_xattrleaf_fn leaf_fn, void *priv);
 
 #endif /* __XFS_SCRUB_LISTXATTR_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 8daf08a627b7..05ff3896db15 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -701,7 +701,8 @@ xchk_parent_count_pptrs(
 	 */
 	if (pp->need_revalidate) {
 		pp->pptrs_found = 0;
-		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr, pp);
+		error = xchk_xattr_walk(sc, sc->ip, xchk_parent_count_pptr,
+				NULL, pp);
 		if (error == -ECANCELED)
 			return 0;
 		if (error)
@@ -760,7 +761,7 @@ xchk_parent_pptr(
 	if (error)
 		goto out_entries;
 
-	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, NULL, pp);
 	if (error == -ECANCELED) {
 		error = 0;
 		goto out_names;
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index b87eb389e45e..c5cda42e53ad 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -25,6 +25,8 @@
 #include "xfs_health.h"
 #include "xfs_swapext.h"
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
+#include "scrub/tempswap.h"
 #include "scrub/orphanage.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/xfblob.h"
+#include "scrub/attr_repair.h"
+#include "scrub/listxattr.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -107,6 +112,23 @@ struct xrep_parent {
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
+	 * Information used to swap the attr fork, if the fs supports parent
+	 * pointers.
+	 */
+	struct xrep_tempswap	tx;
+
 	/*
 	 * Information used to scan the filesystem to find the inumber of the
 	 * dotdot entry for this directory.  On filesystems without parent
@@ -118,12 +140,17 @@ struct xrep_parent {
 	 * @pscan.lock coordinates access to pptr_recs, pptr_names, pptr, and
 	 * pptr_scratch.  This reduces the memory requirements of this
 	 * structure.
+	 *
+	 * The lock also controls access to xattr_records and xattr_blobs(?)
 	 */
 	struct xrep_parent_scan_info pscan;
 
 	/* Orphanage reparenting request. */
 	struct xrep_adoption	adoption;
 
+	/* Have we seen any live updates of parent pointers recently? */
+	bool			saw_pptr_updates;
+
 	/* xattr key and da args for parent pointer replay. */
 	struct xfs_parent_scratch pptr_scratch;
 
@@ -135,12 +162,45 @@ struct xrep_parent {
 	struct xfs_parent_name_irec pptr;
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
+	if (rp->xattr_name)
+		kvfree(rp->xattr_name);
+	rp->xattr_name = NULL;
+	if (rp->xattr_value)
+		kvfree(rp->xattr_value);
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
@@ -565,10 +625,11 @@ xrep_parent_scan_dirtree(
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
 
@@ -603,6 +664,8 @@ xrep_parent_live_update(
 		else
 			error = xrep_parent_stash_parentremove(rp, p->name,
 					p->dp);
+		if (!error)
+			rp->saw_pptr_updates = true;
 		mutex_unlock(&rp->pscan.lock);
 		if (error)
 			goto out_abort;
@@ -669,14 +732,25 @@ xrep_parent_move_to_orphanage(
 	if (!sc->orphanage)
 		return -EFSCORRUPTED;
 
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
+		 * We haven't dropped the ILOCK since we swapped in the new
+		 * parent pointers, which means that the file cannot have been
+		 * moved in the directory tree, and there are no parents.
+		 */
+		orig_parent = NULLFSINO;
+	}
 
 	/*
 	 * Because the orphanage is just another directory in the filesystem,
@@ -711,9 +785,14 @@ xrep_parent_move_to_orphanage(
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
+		error = xrep_findparent_from_pptrs(sc, &new_parent);
 	if (error)
 		goto err_adoption;
 	if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0) {
@@ -727,6 +806,546 @@ xrep_parent_move_to_orphanage(
 	return error;
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
+		.op_flags	= XFS_DA_OP_NOTIME,
+		.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
+		.geo		= sc->mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.dp		= ip,
+		.name		= name,
+		.namelen	= namelen,
+		.hashval	= xfs_da_hashname(name, namelen),
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
+		.op_flags		= XFS_DA_OP_NOTIME,
+		.owner			= rp->sc->ip->i_ino,
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
+	error = xfs_attr_set(&args);
+	if (error) {
+		ASSERT(error != -EEXIST);
+		return error;
+	}
+
+	return 0;
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
+	 * file in preparation for swapping the xattr structures at the end.
+	 * Updating the temporary file requires a transaction, so we commit the
+	 * scrub transaction and drop the ILOCK so that xfs_attr_set can
+	 * allocate whatever transaction it wants.
+	 *
+	 * We still hold IOLOCK_EXCL on the inode being repaired, which
+	 * prevents anyone from adding non-parent pointer xattrs while we're
+	 * flushing.  However, the VFS can add parent pointers as part of
+	 * moving a child directory because it doesn't take i_rwsem; see the
+	 * locking issue comment in dir_repair.c.
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
+/* Do we have any attrs (or parent pointers) at all? */
+STATIC int
+xrep_parent_has_xattr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	return -ECANCELED;
+}
+
+/*
+ * Ensure that the file being repaired has an attr fork if it needs one.
+ * Returns 0 if we're ready to swap; -ENOATTR if there's nothing to swap;
+ * or a negative errno.  In the case of -ENOATTR we leave sc->ip ILOCKed
+ * to the scrub transaction.
+ */
+STATIC int
+xrep_parent_ensure_attr_fork(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	bool			tempfile_has_attr = false;
+	int			error;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	xrep_tempfile_ilock_both(sc);
+
+	ASSERT(xfs_ifork_ptr(sc->tempip, XFS_ATTR_FORK) != NULL);
+
+	/* If the file being repaired has an attr fork, we're done. */
+	if (xfs_ifork_ptr(sc->ip, XFS_ATTR_FORK) != NULL) {
+		error = 0;
+		goto out_cancel;
+	}
+
+	/* Does the tempfile have any xattrs or parent pointers? */
+	error = xchk_xattr_walk(sc, sc->tempip, xrep_parent_has_xattr, NULL,
+			NULL);
+	if (error == -ECANCELED) {
+		tempfile_has_attr = true;
+		error = 0;
+	}
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * The file does not have an attr fork.  If the tempfile has no xattrs
+	 * or parent pointers, there's nothing to swap right now.  Drop the
+	 * ILOCK on the temporary file, but leave the transaction and sc->ip's
+	 * ILOCK held.  Return -ENOATTR to signal to the caller that we can
+	 * skip the swap.
+	 */
+	if (!tempfile_has_attr) {
+		xrep_tempfile_iunlock(sc);
+		return -ENOATTR;
+	}
+
+	/*
+	 * The tempfile has xattrs (or parent pointers).  Cancel the
+	 * transaction that we created above and initialize the attr fork so
+	 * that we can swap the attr forks.
+	 */
+	xchk_trans_cancel(sc);
+	xrep_tempfile_iunlock_both(sc);
+
+	return xfs_bmap_add_attrfork(sc->ip, sizeof(struct xfs_attr_sf_hdr), 1);
+
+out_cancel:
+	xchk_trans_cancel(sc);
+	xrep_tempfile_iunlock_both(sc);
+	return error;
+}
+
+/*
+ * Finish replaying stashed parent pointer updates, allocate a transaction for
+ * swapping extents, and take the ILOCKs of both files before we commit the new
+ * attribute structure.
+ */
+STATIC int
+xrep_parent_finalize_tempfile(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	do {
+		error = xrep_parent_replay_updates(rp);
+		if (error)
+			return error;
+
+		error = xrep_parent_ensure_attr_fork(rp);
+		if (error)
+			return error;
+
+		error = xrep_tempswap_trans_alloc(sc, XFS_ATTR_FORK, &rp->tx);
+		if (error)
+			return error;
+
+		/*
+		 * We rely on the ILOCK to quiesce all parent pointer updates
+		 * because the VFS does not take the IOLOCK when moving a
+		 * directory child during a rename.
+		 */
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
+ * and swap the extents atomically.
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
+	error = xrep_parent_finalize_tempfile(rp);
+	if (error == -ENOATTR)
+		goto out_findparents;
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
+	 * Swap the attr fork and junk the old attr fork contents, which are
+	 * now in the tempfile.
+	 */
+	error = xrep_xattr_swap(sc, &rp->tx);
+	if (error)
+		return error;
+	error = xrep_xattr_reset_tempfile_fork(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Roll transaction to detach both inodes from the transaction, then
+	 * drop the ILOCK of the temporary file since we no longer need it.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+	xrep_tempfile_iunlock(sc);
+
+out_findparents:
+	/*
+	 * We've committed the new parent pointers.  Find at least one parent
+	 * so that we can decide if we're moving this file to the orphanage.
+	 * For this purpose, root directories are their own parents.
+	 */
+	if (sc->ip == sc->mp->m_rootip) {
+		xrep_findparent_scan_found(&rp->pscan, sc->ip->i_ino);
+	} else {
+		error = xrep_findparent_from_pptrs(sc, &parent_ino);
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
@@ -735,9 +1354,20 @@ STATIC int
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
 	if (rp->pscan.parent_ino == NULLFSINO)
 		return xrep_parent_move_to_orphanage(rp);
 
+	if (!S_ISDIR(VFS_I(rp->sc->ip)->i_mode))
+		return 0;
+
 	return xrep_parent_reset_dotdot(rp);
 }
 
@@ -747,34 +1377,78 @@ xrep_parent_setup_scan(
 	struct xrep_parent	*rp)
 {
 	struct xfs_scrub	*sc = rp->sc;
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
 	error = xfarray_create(sc->mp, "parent pointer entries", 0,
 			sizeof(struct xrep_pptr), &rp->pptr_recs);
 	if (error)
-		return error;
+		goto out_xattr_value;
 
 	error = xfblob_create(sc->mp, "parent pointer names", &rp->pptr_names);
 	if (error)
 		goto out_recs;
 
+	/* Set up some storage for copying attrs before the swap */
+	error = xfarray_create(sc->mp, "parent pointer xattr names", 0,
+			sizeof(struct xrep_parent_xattr), &rp->xattr_records);
+	if (error)
+		goto out_names;
+
+	error = xfblob_create(sc->mp, "parent pointer xattr values",
+			&rp->xattr_blobs);
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
 
@@ -796,7 +1470,7 @@ xrep_parent(
 	if (error)
 		goto out_teardown;
 
-	/* Last chance to abort before we start committing fixes. */
+	/* Last chance to abort before we start committing dotdot fixes. */
 	if (xchk_should_terminate(sc, &error))
 		goto out_teardown;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cc164c34d853..4136bb342326 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2482,6 +2482,8 @@ DEFINE_EVENT(xrep_xattr_salvage_class, name, \
 	TP_ARGS(ip, flags, name, namelen, valuelen))
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_salvage_rec);
 DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_xattr_insert_rec);
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_parent_stash_xattr);
+DEFINE_XREP_XATTR_SALVAGE_EVENT(xrep_parent_insert_xattr);
 
 DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned int flags, const void *name,

