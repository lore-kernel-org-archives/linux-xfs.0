Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A91C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbjEZBgb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239876AbjEZBgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:36:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF23195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B27961248
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB58C433A0;
        Fri, 26 May 2023 01:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064980;
        bh=zZf+TBifqjHp09aSvmK7gZdkF5XRRkbRUqtLxI/rHZs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=R/69ZVtrKGZzcmZguaS6jOUfLXhYTqMP6Zjht4mG2GFKskKQa74C9SBS0I4uAOKY5
         ldsTdHjPyXDfLJxKwd/SsscrAc8AJJ6jmtDOTvtiytAYmQtQObJlcjzR6tbvDoR0CR
         o1s0jpFnmwwhaK1Os8mxKFGV04A4RtaHJCFub3VIaviCDxYIa0No+godI1QMqAiXNl
         5KtGpBdHLtoXSKpUrsyoyeucSJLyX4w2WfGjaQia+aCuZdS+JxdF60R+5rWvwYIQaA
         jBcPmDgIzZKO+niy+O36n0FkyuvajWr4FE4nUJzR0bLDtbPQLM/6xMn/9UKKj1rkwH
         JGDKlQ9ySJS3A==
Date:   Thu, 25 May 2023 18:36:20 -0700
Subject: [PATCH 2/3] xfs: move files to orphanage instead of letting nlinks
 drop to zero
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067672.3737779.12778846145734665766.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
References: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/nlinks.c        |   11 +++-
 fs/xfs/scrub/nlinks.h        |    6 ++
 fs/xfs/scrub/nlinks_repair.c |  129 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/repair.h        |    2 +
 fs/xfs/scrub/trace.c         |    1 
 fs/xfs/scrub/trace.h         |   26 ++++++++
 6 files changed, 167 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 69af584562ed..67e2c167fc36 100644
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
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
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
index c3c7e79efc3f..0036d62f3d6c 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -28,6 +28,12 @@ struct xchk_nlink_ctrs {
 	 * from other writer threads.
 	 */
 	struct xfs_dir_hook	hooks;
+
+	/* Orphanage reparenting request. */
+	struct xrep_adoption	adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	char			namebuf[MAXNAMELEN];
 };
 
 /*
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index f500f23f7b4f..1666871e3fba 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -24,6 +24,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
@@ -38,6 +39,59 @@
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
+ * Reattach this file to the directory tree by moving it to /lost+found per the
+ * adoption parameters that we already computed.  Returns 0 for success,
+ * -EMLINK if we cannot complete the adoption because doing so would cause a
+ * link count overflow, or the usual negative errno.
+ */
+STATIC int
+xrep_nlinks_adopt(
+	struct xchk_nlink_ctrs	*xnc)
+{
+	int			error;
+
+	/* Figure out what name we're going to use here. */
+	error = xrep_adoption_compute_name(&xnc->adoption, xnc->namebuf);
+	if (error)
+		return error;
+
+	/*
+	 * Create the new name in the orphanage, and bump the link
+	 * count of the orphanage if we just added a directory.  Then
+	 * we can set the correct nlink.
+	 */
+	return xrep_adoption_commit(&xnc->adoption);
+}
+
 /* Remove an inode from the unlinked list. */
 STATIC int
 xrep_nlinks_iunlink_remove(
@@ -66,6 +120,8 @@ xrep_nlinks_repair_inode(
 	struct xfs_inode	*ip = sc->ip;
 	uint64_t		total_links;
 	uint64_t		actual_nlink;
+	bool			orphanage_available = false;
+	bool			adoption_performed = false;
 	bool			dirty = false;
 	int			error;
 
@@ -77,14 +133,38 @@ xrep_nlinks_repair_inode(
 	if (xrep_is_tempfile(ip))
 		return 0;
 
-	xchk_ilock(sc, XFS_IOLOCK_EXCL);
+	if (sc->orphanage && sc->ip != sc->orphanage) {
+		/*
+		 * Allocate a transaction for the adoption.  We'll reserve
+		 * space for the transaction in the adoption preparation step.
+		 */
+		error = xrep_adoption_init(sc, &xnc->adoption);
+		if (!error) {
+			orphanage_available = true;
+
+			/* Take IOLOCK of the orphanage and the child. */
+			error = xrep_orphanage_iolock_two(sc);
+			if (error)
+				return error;
+		}
+	}
+	if (!orphanage_available)
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, 0, 0, 0, &sc->tp);
 	if (error)
 		goto out_iolock;
 
-	xchk_ilock(sc, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(sc->tp, ip, 0);
+	if (orphanage_available) {
+		error = xrep_adoption_prep(&xnc->adoption);
+		if (error) {
+			xchk_trans_cancel(sc);
+			goto out_iolock;
+		}
+	} else {
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(sc->tp, ip, 0);
+	}
 
 	mutex_lock(&xnc->lock);
 
@@ -122,6 +202,29 @@ xrep_nlinks_repair_inode(
 		goto out_trans;
 	}
 
+	/*
+	 * Decide if we're going to move this file to the orphanage, and fix
+	 * up the incore link counts if we are.
+	 */
+	if (orphanage_available &&
+	    xrep_nlinks_is_orphaned(sc, ip, actual_nlink, &obs)) {
+		error = xrep_nlinks_adopt(xnc);
+		if (error)
+			goto out_trans;
+		adoption_performed = true;
+
+		/* Re-read the link counts. */
+		mutex_lock(&xnc->lock);
+		error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_trans;
+
+		total_links = xchk_nlink_total(ip, &obs);
+		actual_nlink = VFS_I(ip)->i_nlink;
+		dirty = true;
+	}
+
 	/*
 	 * If this inode is linked from the directory tree and on the unlinked
 	 * list, remove it from the unlinked list.
@@ -167,6 +270,11 @@ xrep_nlinks_repair_inode(
 		goto out_ilock;
 
 	xchk_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	if (orphanage_available) {
+		xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+		if (!adoption_performed)
+			xrep_adoption_cancel(&xnc->adoption, 0);
+	}
 	return 0;
 
 out_scanlock:
@@ -175,8 +283,15 @@ xrep_nlinks_repair_inode(
 	xchk_trans_cancel(sc);
 out_ilock:
 	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	if (orphanage_available && (sc->orphanage_ilock_flags & XFS_ILOCK_EXCL))
+		xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
 out_iolock:
 	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+	if (orphanage_available) {
+		xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+		if (!adoption_performed)
+			xrep_adoption_cancel(&xnc->adoption, error);
+	}
 	return error;
 }
 
@@ -209,10 +324,10 @@ xrep_nlinks(
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
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index d845997ed60b..0798e580589e 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -86,6 +86,7 @@ int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
 int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
+int xrep_setup_nlinks(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -195,6 +196,7 @@ xrep_setup_nothing(
 #define xrep_setup_xattr		xrep_setup_nothing
 #define xrep_setup_directory		xrep_setup_nothing
 #define xrep_setup_parent		xrep_setup_nothing
+#define xrep_setup_nlinks		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index e7672264714c..18a1a3d1cbef 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -22,6 +22,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/orphanage.h"
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
 #include "scrub/xfbtree.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index abf8d1fad537..cbac347b4a79 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2567,6 +2567,32 @@ DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
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
 
 

