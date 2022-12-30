Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C92C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiLaACZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiLaACY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:02:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22D41E3CA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBC061CAD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA757C433EF;
        Sat, 31 Dec 2022 00:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444941;
        bh=jeDO0OrQVi2j0mRiCpmZdxY/hkO6U2ymvzLOhqT4c5E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Yw01RsQ88uNoYmfWSDayIEOdKPdKQrUu3o8+USS408mN9MrD0rdL0QsHsQZRIsVj2
         /rjUoeKaAl4qlew5qD4JJUIIsOdRGpdMfa59RBqmOr58MVnH+Iwvcjs2z+Bhi6/pRX
         dzJtt2MdrTWdRdi08b55HhDZSnr9lwAjsgRSfa42hR249hDbP3C+Tf5RShSvFp3IeO
         NM7PtJeU+0UB1TmOvkWRHWmEJ0fw9K5O07kuwK6yg909qswY4vRG7mFY4oylJ6lB/S
         /aIQnwe1FPV7SQ655gqO1yz5Obvp89f1n0ZseCEctCCuKoTOoQJCvpOG7KPWY8QID0
         HRpdNY3k5UoLQ==
Subject: [PATCH 2/3] xfs: move files to orphanage instead of letting nlinks
 drop to zero
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:20 -0800
Message-ID: <167243845997.700780.344208408610659929.stgit@magnolia>
In-Reply-To: <167243845965.700780.5558696077743355523.stgit@magnolia>
References: <167243845965.700780.5558696077743355523.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we encounter an inode with a nonzero link count but zero observed
links, move it to the orphanage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/nlinks.c        |   11 ++
 fs/xfs/scrub/nlinks.h        |    6 +
 fs/xfs/scrub/nlinks_repair.c |  250 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   26 ++++
 6 files changed, 290 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 54aa3dc4dc89..dca759d27ac4 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -24,6 +24,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/readdir.h"
@@ -44,9 +45,17 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
 	xchk_fshooks_enable(sc, XCHK_FSHOOKS_NLINKS);
 
-	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_nlinks(sc);
+		if (error)
+			return error;
+	}
+
+	sc->buf = kvzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
 
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 46baef3c2237..f5108369cc2b 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -28,6 +28,12 @@ struct xchk_nlink_ctrs {
 	 * from other writer threads.
 	 */
 	struct xfs_nlink_hook	hooks;
+
+	/* Orphanage reparinting request. */
+	struct xrep_orphanage_req adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	char			namebuf[MAXNAMELEN];
 };
 
 /*
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 4723b015a1c1..f881e5dbd432 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -23,6 +23,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
@@ -37,6 +38,242 @@
  * inode is locked.
  */
 
+/* Set up to repair inode link counts. */
+int
+xrep_setup_nlinks(
+	struct xfs_scrub	*sc)
+{
+	return xrep_orphanage_try_create(sc);
+}
+
+/* Update incore link count information.  Caller must hold the xnc lock. */
+STATIC int
+xrep_nlinks_set_record(
+	struct xchk_nlink_ctrs	*xnc,
+	xfs_ino_t		ino,
+	const struct xchk_nlink	*nl)
+{
+	int			error;
+
+	trace_xrep_nlinks_set_record(xnc->sc->mp, ino, nl);
+
+	error = xfarray_store(xnc->nlinks, ino, nl);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  This should be impossible since we
+		 * presumably already stored an nlink count, but we still need
+		 * to fail gracefully.
+		 */
+		return -ECANCELED;
+	}
+
+	return error;
+}
+
+/*
+ * Inodes that aren't the root directory or the orphanage, have a nonzero link
+ * count, and no observed parents should be moved to the orphanage.
+ */
+static inline bool
+xrep_nlinks_is_orphaned(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		actual_nlink,
+	const struct xchk_nlink	*obs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (obs->parents != 0)
+		return false;
+	if (ip == mp->m_rootip || ip == sc->orphanage)
+		return false;
+	return actual_nlink != 0;
+}
+
+/*
+ * Correct the link count of the given inode or move it to the orphanage.
+ * Because we have to grab locks and resources in a certain order, it's
+ * possible that this will be a no-op.
+ */
+STATIC int
+xrep_nlinks_repair_and_relink_inode(
+	struct xchk_nlink_ctrs		*xnc)
+{
+	struct xchk_nlink		obs;
+	struct xfs_scrub		*sc = xnc->sc;
+	struct xfs_mount		*mp = sc->mp;
+	struct xfs_inode		*ip = sc->ip;
+	uint64_t			total_links;
+	unsigned int			actual_nlink;
+	bool				orphan = false;
+	int				error;
+
+	/*
+	 * Ignore temporary files being used to stage repairs, since we assume
+	 * they're correct for non-directories, and the directory repair code
+	 * doesn't bump the link counts for the children.
+	 */
+	if (xrep_is_tempfile(ip))
+		return 0;
+
+	/* Grab the IOLOCK of the orphanage and the child directory. */
+	error = xrep_orphanage_iolock_two(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Allocate a transaction for the adoption.  We'll reserve space for
+	 * the transaction in the adoption preparation step.
+	 */
+	xrep_orphanage_compute_blkres(sc, &xnc->adoption);
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
+	if (error)
+		goto out_iolock;
+
+	/*
+	 * Before we take the ILOCKs, compute the name of the potential
+	 * orphanage directory entry.
+	 */
+	error = xrep_orphanage_compute_name(&xnc->adoption, xnc->namebuf);
+	if (error)
+		goto out_trans;
+
+	error = xrep_orphanage_adoption_prep(&xnc->adoption);
+	if (error)
+		goto out_trans;
+
+	mutex_lock(&xnc->lock);
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		error = -ECANCELED;
+		goto out_scanlock;
+	}
+
+	error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+	if (error)
+		goto out_scanlock;
+
+	total_links = xchk_nlink_total(&obs);
+	actual_nlink = VFS_I(ip)->i_nlink;
+
+	/* Cannot set more than the maxiumum possible link count. */
+	if (total_links > U32_MAX) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/*
+	 * Linked directories should have at least one "child" (the dot entry)
+	 * pointing up to them.
+	 */
+	if (S_ISDIR(VFS_I(ip)->i_mode) && actual_nlink > 0 &&
+					  obs.children == 0) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/* Non-directories cannot have directories pointing up to them. */
+	if (!S_ISDIR(VFS_I(ip)->i_mode) && obs.children > 0) {
+		trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/*
+	 * Decide if we're going to move this file to the orphanage, and fix
+	 * up the incore link counts if we are.
+	 */
+	if (xrep_nlinks_is_orphaned(sc, ip, actual_nlink, &obs)) {
+		obs.parents++;
+		total_links++;
+
+		error = xrep_nlinks_set_record(xnc, ip->i_ino, &obs);
+		if (error)
+			goto out_scanlock;
+
+		orphan = true;
+	}
+
+	/*
+	 * We did not find any links to this inode and we're not planning to
+	 * move it to the orphanage.  If the inode link count is also zero, we
+	 * have nothing further to do.  Otherwise, the situation is unfixable.
+	 */
+	if (total_links == 0) {
+		if (actual_nlink != 0)
+			trace_xrep_nlinks_unfixable_inode(mp, ip, &obs);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/* If the inode has the correct link count and isn't orphaned, exit. */
+	if (total_links == actual_nlink && !orphan) {
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/* Commit the new link count. */
+	trace_xrep_nlinks_update_inode(mp, ip, &obs);
+
+	/*
+	 * If this is an orphan, create the new name in the orphanage, and bump
+	 * the link count of the orphanage if we just added a directory.  Then
+	 * we can set the correct nlink.
+	 */
+	if (orphan) {
+		error = xrep_orphanage_adopt(&xnc->adoption);
+		if (error)
+			goto out_scanlock;
+
+		/*
+		 * If the child is a directory, we need to bump the incore link
+		 * count of the orphanage to account for the new orphan's
+		 * child subdirectory entry.
+		 */
+		if (S_ISDIR(VFS_I(ip)->i_mode)) {
+			error = xfarray_load_sparse(xnc->nlinks,
+					sc->orphanage->i_ino, &obs);
+			if (error)
+				goto out_scanlock;
+
+			obs.flags |= XCHK_NLINK_WRITTEN;
+			obs.children++;
+
+			error = xrep_nlinks_set_record(xnc,
+					sc->orphanage->i_ino, &obs);
+			if (error)
+				goto out_scanlock;
+		}
+	}
+	set_nlink(VFS_I(ip), total_links);
+	xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	mutex_unlock(&xnc->lock);
+
+	error = xrep_trans_commit(sc);
+	if (error)
+		goto out_ilock;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	return 0;
+
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+out_trans:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+out_iolock:
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	return error;
+}
+
 /*
  * Correct the link count of the given inode.  Because we have to grab locks
  * and resources in a certain order, it's possible that this will be a no-op.
@@ -185,10 +422,10 @@ xrep_nlinks(
 	/*
 	 * We need ftype for an accurate count of the number of child
 	 * subdirectory links.  Child subdirectories with a back link (dotdot
-	 * entry) but no forward link are unfixable, so we cannot repair the
-	 * link count of the parent directory based on the back link count
-	 * alone.  Filesystems without ftype support are rare (old V4) so we
-	 * just skip out here.
+	 * entry) but no forward link are moved to the orphanage, so we cannot
+	 * repair the link count of the parent directory based on the back link
+	 * count alone.  Filesystems without ftype support are rare (old V4) so
+	 * we just skip out here.
 	 */
 	if (!xfs_has_ftype(sc->mp))
 		return -EOPNOTSUPP;
@@ -209,7 +446,10 @@ xrep_nlinks(
 		 */
 		xchk_trans_cancel(sc);
 
-		error = xrep_nlinks_repair_inode(xnc);
+		if (sc->orphanage && sc->ip != sc->orphanage)
+			error = xrep_nlinks_repair_and_relink_inode(xnc);
+		else
+			error = xrep_nlinks_repair_inode(xnc);
 		xchk_iscan_mark_visited(&xnc->compare_iscan, sc->ip);
 		xchk_irele(sc, sc->ip);
 		sc->ip = NULL;
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 596993b06256..5a7787e3d3a1 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -85,6 +85,7 @@ int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
 int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
+int xrep_setup_nlinks(struct xfs_scrub *sc);
 
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
 
@@ -196,6 +197,7 @@ xrep_setup_nothing(
 #define xrep_setup_xattr		xrep_setup_nothing
 #define xrep_setup_directory		xrep_setup_nothing
 #define xrep_setup_parent		xrep_setup_nothing
+#define xrep_setup_nlinks		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index f8f50c5a02c0..2e36fcc12e40 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -23,6 +23,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
 #include "scrub/xfbtree.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ae8a5852e258..116f03c2fe48 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2538,6 +2538,32 @@ DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_dirent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_from_dcache);
 
+TRACE_EVENT(xrep_nlinks_set_record,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
+		 const struct xchk_nlink *obs),
+	TP_ARGS(mp, ino, obs),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_nlink_t, parents)
+		__field(xfs_nlink_t, backrefs)
+		__field(xfs_nlink_t, children)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->parents = obs->parents;
+		__entry->backrefs = obs->backrefs;
+		__entry->children = obs->children;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parents %u backrefs %u children %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parents,
+		  __entry->backrefs,
+		  __entry->children)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

