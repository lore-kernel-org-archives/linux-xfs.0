Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C46200C1
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505075; cv=none; b=cBkj4EMG2+skXX35jluy08rl2XTDuTaVwKJAA/SjJfGtoki/s50N+RY7X2Zbfk0R/HuRvlceAzrzUrmUvxLHLNM39o8TKFZ379I7rVv66bE32wg4HyInJULKkg7AiemKuKOc/C4ap4e4KAMvk7MxmVQ/PwCqmovYVe5GvythBWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505075; c=relaxed/simple;
	bh=5f5a9tYqqLqCkKJFbs7OC8i0y69z6wGl9fFjUjq7iBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QT/xjFdEtJmbaBD6/W67XxM1LJvWTXkBV+wbKLK5e5kUFNs8GEdb/DzrYGKkM+Hl4i0qS0f9f1XzIX1/EFfGVgTU02fgAkLe26YMoTOByx9D4j71iIiWZ08aX+mpBV9FDSQWnGT/wQeYeUNlPXz23MlrZK+xNoytDIFxZgc9ulQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/KbBp9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/KbBp9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3C6C433F1;
	Wed, 27 Mar 2024 02:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505075;
	bh=5f5a9tYqqLqCkKJFbs7OC8i0y69z6wGl9fFjUjq7iBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q/KbBp9nnR+k3aZRCt+NAM/C8uvbnFA2evvsGd6oo+AHwMqfY4GJZp7MD0YFDjXBN
	 0VP4vw0UTi8ChZLK/6viY/0yc0bpQgVZMZCZb9idWO0LPDAaHPozayndN+i3iTtxYc
	 VOzHeBS00j/QKI1S2hCMu1QxfH4li/O2tnpWDmoP8PPS/5ZqTPUKx+2XSF7bfItkAX
	 kEChziFzaLQHGz5gM7v73S0CfVLzzd5BPPiOCp2dFSEA2gUqmb0ULsC6wHZ+h93WpX
	 wyuJUgtMXc6x1wvymn9RYTYhpjdw7emSL7pxMxIQ1LZf4b3pRcGWnD3+w8qniTfyiT
	 Woy86wRk1wF5A==
Date: Tue, 26 Mar 2024 19:04:34 -0700
Subject: [PATCH 4/5] xfs: online repair of parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383596.3217994.9360311574286825912.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
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

Teach the online repair code to fix parent pointers for directories.
For now, this means correcting the dotdot entry of an existing directory
that is otherwise consistent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/parent.c        |   10 ++
 fs/xfs/scrub/parent_repair.c |  221 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    4 +
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |    1 
 6 files changed, 238 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/parent_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3c754777ec288..d48646f86563f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -205,6 +205,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   parent_repair.o \
 				   rcbag_btree.o \
 				   rcbag.o \
 				   reap.o \
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 050a8e8914f6e..acb6282c3d148 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
@@ -18,12 +19,21 @@
 #include "scrub/common.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub parents. */
 int
 xchk_setup_parent(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_parent(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
new file mode 100644
index 0000000000000..0a9651bb0b057
--- /dev/null
+++ b/fs/xfs/scrub/parent_repair.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_trans_space.h"
+#include "xfs_health.h"
+#include "xfs_exchmaps.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/iscan.h"
+#include "scrub/findparent.h"
+#include "scrub/readdir.h"
+
+/*
+ * Repairing The Directory Parent Pointer
+ * ======================================
+ *
+ * Currently, only directories support parent pointers (in the form of '..'
+ * entries), so we simply scan the filesystem and update the '..' entry.
+ *
+ * Note that because the only parent pointer is the dotdot entry, we won't
+ * touch an unhealthy directory, since the directory repair code is perfectly
+ * capable of rebuilding a directory with the proper parent inode.
+ *
+ * See the section on locking issues in dir_repair.c for more information about
+ * conflicts with the VFS.  The findparent code wll keep our incore parent
+ * inode up to date.
+ */
+
+struct xrep_parent {
+	struct xfs_scrub	*sc;
+
+	/*
+	 * Information used to scan the filesystem to find the inumber of the
+	 * dotdot entry for this directory.
+	 */
+	struct xrep_parent_scan_info pscan;
+};
+
+/* Tear down all the incore stuff we created. */
+static void
+xrep_parent_teardown(
+	struct xrep_parent	*rp)
+{
+	xrep_findparent_scan_teardown(&rp->pscan);
+}
+
+/* Set up for a parent repair. */
+int
+xrep_setup_parent(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_parent	*rp;
+
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
+	rp = kvzalloc(sizeof(struct xrep_parent), XCHK_GFP_FLAGS);
+	if (!rp)
+		return -ENOMEM;
+	rp->sc = sc;
+	sc->buf = rp;
+
+	return 0;
+}
+
+/*
+ * Scan all files in the filesystem for a child dirent that we can turn into
+ * the dotdot entry for this directory.
+ */
+STATIC int
+xrep_parent_find_dotdot(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	xfs_ino_t		ino;
+	unsigned int		sick, checked;
+	int			error;
+
+	/*
+	 * Avoid sick directories.  There shouldn't be anyone else clearing the
+	 * directory's sick status.
+	 */
+	xfs_inode_measure_sickness(sc->ip, &sick, &checked);
+	if (sick & XFS_SICK_INO_DIR)
+		return -EFSCORRUPTED;
+
+	ino = xrep_findparent_self_reference(sc);
+	if (ino != NULLFSINO) {
+		xrep_findparent_scan_finish_early(&rp->pscan, ino);
+		return 0;
+	}
+
+	/*
+	 * Drop the ILOCK on this directory so that we can scan for the dotdot
+	 * entry.  Figure out who is going to be the parent of this directory,
+	 * then retake the ILOCK so that we can salvage directory entries.
+	 */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	error = xrep_findparent_scan(&rp->pscan);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+
+	return error;
+}
+
+/* Reset a directory's dotdot entry, if needed. */
+STATIC int
+xrep_parent_reset_dotdot(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	xfs_ino_t		ino;
+	unsigned int		spaceres;
+	int			error = 0;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &ino);
+	if (error || ino == rp->pscan.parent_ino)
+		return error;
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	trace_xrep_parent_reset_dotdot(sc->ip, rp->pscan.parent_ino);
+
+	/*
+	 * Reserve more space just in case we have to expand the dir.  We're
+	 * allowed to exceed quota to repair inconsistent metadata.
+	 */
+	spaceres = XFS_RENAME_SPACE_RES(sc->mp, xfs_name_dotdot.len);
+	error = xfs_trans_reserve_more_inode(sc->tp, sc->ip, spaceres, 0,
+			true);
+	if (error)
+		return error;
+
+	error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+			rp->pscan.parent_ino, spaceres);
+	if (error)
+		return error;
+
+	/*
+	 * Roll transaction to detach the inode from the transaction but retain
+	 * ILOCK_EXCL.
+	 */
+	return xfs_trans_roll(&sc->tp);
+}
+
+/*
+ * Commit the new parent pointer structure (currently only the dotdot entry) to
+ * the file that we're repairing.
+ */
+STATIC int
+xrep_parent_rebuild_tree(
+	struct xrep_parent	*rp)
+{
+	if (rp->pscan.parent_ino == NULLFSINO) {
+		/* Cannot fix orphaned directories yet. */
+		return -EFSCORRUPTED;
+	}
+
+	return xrep_parent_reset_dotdot(rp);
+}
+
+/* Set up the filesystem scan so we can look for parents. */
+STATIC int
+xrep_parent_setup_scan(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+
+	return xrep_findparent_scan_start(sc, &rp->pscan);
+}
+
+int
+xrep_parent(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_parent	*rp = sc->buf;
+	int			error;
+
+	error = xrep_parent_setup_scan(rp);
+	if (error)
+		return error;
+
+	error = xrep_parent_find_dotdot(rp);
+	if (error)
+		goto out_teardown;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		goto out_teardown;
+
+	error = xrep_parent_rebuild_tree(rp);
+	if (error)
+		goto out_teardown;
+
+out_teardown:
+	xrep_parent_teardown(rp);
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 4e25aa95753a9..e53374fa54308 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -92,6 +92,7 @@ int xrep_setup_ag_rmapbt(struct xfs_scrub *sc);
 int xrep_setup_ag_refcountbt(struct xfs_scrub *sc);
 int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
+int xrep_setup_parent(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -127,6 +128,7 @@ int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
+int xrep_parent(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -198,6 +200,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
 #define xrep_setup_xattr		xrep_setup_nothing
 #define xrep_setup_directory		xrep_setup_nothing
+#define xrep_setup_parent		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -225,6 +228,7 @@ xrep_setup_nothing(
 #define xrep_rtsummary			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
 #define xrep_directory			xrep_notsupported
+#define xrep_parent			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8e9e2bf121c2b..520d83db193c3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -343,7 +343,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_parent,
 		.scrub	= xchk_parent,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_parent,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8a254180de4f9..a7cefe6c252e9 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2544,6 +2544,7 @@ DEFINE_EVENT(xrep_dir_class, name, \
 	TP_ARGS(dp, parent_ino))
 DEFINE_XREP_DIR_EVENT(xrep_dir_rebuild_tree);
 DEFINE_XREP_DIR_EVENT(xrep_dir_reset_fork);
+DEFINE_XREP_DIR_EVENT(xrep_parent_reset_dotdot);
 
 DECLARE_EVENT_CLASS(xrep_dirent_class,
 	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name,

