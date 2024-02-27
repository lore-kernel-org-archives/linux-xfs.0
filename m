Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88401BF2A
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000702; cv=none; b=GwPse2rmM8KL3i/a8/mlAjuFtKKMUFAeB6uM56NOeNmfEHW18gTuS8BGhmONKnBPWkFFWblmKPMIC1lVBGLTU5J8Omu9NSPLOWGcB8oAXs4P4XWaTRCmlVUAVcYqA3JltubB8HDAKuyllMk5FZZnTYPUlUeYdiYeSiV3210SQg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000702; c=relaxed/simple;
	bh=HgoDdJYu9bgo5/Lk1MXnMYsfZWxgf6HXyJJZdvEzf/k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1Tz7XJopLZ12IUHxIaXd4y6YB5WxKR2zrqKqmz5iHo5juU8W0L9LEEKI18X6uAxeatZ+95TVzKRoAWqaj2qE1r+IGfvc69IFIY/X+osSYcWX9sSxai3EmSQJJmzUw7ms0hOUQsU2U4t+7bjvPOIqcMOWZY6OxwGPKIq1CBKnGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQ1aNeRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQ1aNeRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E69CC43390;
	Tue, 27 Feb 2024 02:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000702;
	bh=HgoDdJYu9bgo5/Lk1MXnMYsfZWxgf6HXyJJZdvEzf/k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uQ1aNeRcXfa4y+9Y6BbH/EWMKTyiylT+s46zLW+9YcUAWahdWB6dn2Z0g9kK1Zwap
	 NgVjWzfJ/mjEUv4rF5egEnvbMI1gBnyX5cunkN9UVPaoJ/SuTofkA78OghmZyWX5K2
	 PDJWPB/jrQbraFIgJNOuYP4xbJwxSdQLXnJJ3GrzbDcWCnuxiTgmiGMhtrKtFiZK6E
	 QRaABRqSCnLvZbtaHZo2WHlv+uMbAuskVwkA4RcD1VvxCh4TF5TQQx8EkZjI0yGjzn
	 qI8wHMHcjUvwTBPajfwXPMGULG3JPdoWQkyoSGB5kjbO5ih1s3/b/DEnQRu28CR/XH
	 08tWOuz6n5g4w==
Date: Mon, 26 Feb 2024 18:25:02 -0800
Subject: [PATCH 2/4] xfs: create temporary files and directories for online
 repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170900012248.938660.1076834138892216129.stgit@frogsfrogsfrogs>
In-Reply-To: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
References: <170900012206.938660.3603038404932438747.stgit@frogsfrogsfrogs>
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

Teach the online repair code how to create temporary files or
directories.  These temporary files can be used to stage reconstructed
information until we're ready to perform an atomic extent swap to commit
the new metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/parent.c   |    2 
 fs/xfs/scrub/scrub.c    |    3 +
 fs/xfs/scrub/scrub.h    |    4 +
 fs/xfs/scrub/tempfile.c |  251 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   28 +++++
 fs/xfs/scrub/trace.h    |   33 ++++++
 fs/xfs/xfs_inode.c      |    3 -
 fs/xfs/xfs_inode.h      |    2 
 9 files changed, 324 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 20d7dea6f5cad..1ea7cacd92a7c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -208,6 +208,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount_repair.o \
 				   repair.o \
 				   rmap_repair.o \
+				   tempfile.o \
 				   )
 
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 7db8736721461..5da10ed1fe8ce 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -143,7 +143,7 @@ xchk_parent_validate(
 	}
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
-	if (dp == sc->ip || !S_ISDIR(VFS_I(dp)->i_mode)) {
+	if (dp == sc->ip || dp == sc->tempip || !S_ISDIR(VFS_I(dp)->i_mode)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		goto out_rele;
 	}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 20fac9723c08c..d9012e9a6afd2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -17,6 +17,7 @@
 #include "xfs_scrub.h"
 #include "xfs_buf_mem.h"
 #include "xfs_rmap.h"
+#include "xfs_exchrange.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -24,6 +25,7 @@
 #include "scrub/health.h"
 #include "scrub/stats.h"
 #include "scrub/xfile.h"
+#include "scrub/tempfile.h"
 
 /*
  * Online Scrub and Repair
@@ -211,6 +213,7 @@ xchk_teardown(
 		sc->buf = NULL;
 	}
 
+	xrep_tempfile_rele(sc);
 	xchk_fsgates_disable(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 9ad65b604fe12..e37d8599718e2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -105,6 +105,10 @@ struct xfs_scrub {
 	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
+	/* A temporary file on this filesystem, for staging new metadata. */
+	struct xfs_inode		*tempip;
+	uint				temp_ilock_flags;
+
 	/* See the XCHK/XREP state flags below. */
 	unsigned int			flags;
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
new file mode 100644
index 0000000000000..68d245749bc1e
--- /dev/null
+++ b/fs/xfs/scrub/tempfile.c
@@ -0,0 +1,251 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_ialloc.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_dir2.h"
+#include "xfs_exchrange.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/tempfile.h"
+
+/*
+ * Create a temporary file for reconstructing metadata, with the intention of
+ * atomically exchanging the temporary file's contents with the file that's
+ * being repaired.
+ */
+int
+xrep_tempfile_create(
+	struct xfs_scrub	*sc,
+	uint16_t		mode)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_trans	*tp = NULL;
+	struct xfs_dquot	*udqp = NULL;
+	struct xfs_dquot	*gdqp = NULL;
+	struct xfs_dquot	*pdqp = NULL;
+	struct xfs_trans_res	*tres;
+	struct xfs_inode	*dp = mp->m_rootip;
+	xfs_ino_t		ino;
+	unsigned int		resblks;
+	bool			is_dir = S_ISDIR(mode);
+	int			error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+	if (xfs_is_readonly(mp))
+		return -EROFS;
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(sc->tempip == NULL);
+
+	/*
+	 * Make sure that we have allocated dquot(s) on disk.  The temporary
+	 * inode should be completely root owned so that we don't fail due to
+	 * quota limits.
+	 */
+	error = xfs_qm_vop_dqalloc(dp, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	if (is_dir) {
+		resblks = XFS_MKDIR_SPACE_RES(mp, 0);
+		tres = &M_RES(mp)->tr_mkdir;
+	} else {
+		resblks = XFS_IALLOC_SPACE_RES(mp);
+		tres = &M_RES(mp)->tr_create_tmpfile;
+	}
+
+	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
+			&tp);
+	if (error)
+		goto out_release_dquots;
+
+	/* Allocate inode, set up directory. */
+	error = xfs_dialloc(&tp, dp->i_ino, mode, &ino);
+	if (error)
+		goto out_trans_cancel;
+	error = xfs_init_new_inode(&nop_mnt_idmap, tp, dp, ino, mode, 0, 0,
+			0, false, &sc->tempip);
+	if (error)
+		goto out_trans_cancel;
+
+	/* Change the ownership of the inode to root. */
+	VFS_I(sc->tempip)->i_uid = GLOBAL_ROOT_UID;
+	VFS_I(sc->tempip)->i_gid = GLOBAL_ROOT_GID;
+	sc->tempip->i_diflags &= ~(XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT);
+	xfs_trans_log_inode(tp, sc->tempip, XFS_ILOG_CORE);
+
+	/*
+	 * Mark our temporary file as private so that LSMs and the ACL code
+	 * don't try to add their own metadata or reason about these files.
+	 * The file should never be exposed to userspace.
+	 */
+	VFS_I(sc->tempip)->i_flags |= S_PRIVATE;
+	VFS_I(sc->tempip)->i_opflags &= ~IOP_XATTR;
+
+	if (is_dir) {
+		error = xfs_dir_init(tp, sc->tempip, dp);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/*
+	 * Attach the dquot(s) to the inodes and modify them incore.
+	 * These ids of the inode couldn't have changed since the new
+	 * inode has been locked ever since it was created.
+	 */
+	xfs_qm_vop_create_dqattach(tp, sc->tempip, udqp, gdqp, pdqp);
+
+	/*
+	 * Put our temp file on the unlinked list so it's purged automatically.
+	 * All file-based metadata being reconstructed using this file must be
+	 * atomically exchanged with the original file because the contents
+	 * here will be purged when the inode is dropped or log recovery cleans
+	 * out the unlinked list.
+	 */
+	error = xfs_iunlink(tp, sc->tempip);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_release_inode;
+
+	trace_xrep_tempfile_create(sc);
+
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	/* Finish setting up the incore / vfs context. */
+	xfs_setup_iops(sc->tempip);
+	xfs_finish_inode_setup(sc->tempip);
+
+	sc->temp_ilock_flags = 0;
+	return error;
+
+out_trans_cancel:
+	xfs_trans_cancel(tp);
+out_release_inode:
+	/*
+	 * Wait until after the current transaction is aborted to finish the
+	 * setup of the inode and release the inode.  This prevents recursive
+	 * transactions and deadlocks from xfs_inactive.
+	 */
+	if (sc->tempip) {
+		xfs_finish_inode_setup(sc->tempip);
+		xchk_irele(sc, sc->tempip);
+	}
+out_release_dquots:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+
+	return error;
+}
+
+/* Take IOLOCK_EXCL on the temporary file, maybe. */
+bool
+xrep_tempfile_iolock_nowait(
+	struct xfs_scrub	*sc)
+{
+	if (xfs_ilock_nowait(sc->tempip, XFS_IOLOCK_EXCL)) {
+		sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * Take the temporary file's IOLOCK while holding a different inode's IOLOCK.
+ * In theory nobody else should hold the tempfile's IOLOCK, but we use trylock
+ * to avoid deadlocks and lockdep complaints.
+ */
+int
+xrep_tempfile_iolock_polled(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	while (!xrep_tempfile_iolock_nowait(sc)) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		delay(1);
+	}
+
+	return 0;
+}
+
+/* Release IOLOCK_EXCL on the temporary file. */
+void
+xrep_tempfile_iounlock(
+	struct xfs_scrub	*sc)
+{
+	xfs_iunlock(sc->tempip, XFS_IOLOCK_EXCL);
+	sc->temp_ilock_flags &= ~XFS_IOLOCK_EXCL;
+}
+
+/* Prepare the temporary file for metadata updates by grabbing ILOCK_EXCL. */
+void
+xrep_tempfile_ilock(
+	struct xfs_scrub	*sc)
+{
+	sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+	xfs_ilock(sc->tempip, XFS_ILOCK_EXCL);
+}
+
+/* Try to grab ILOCK_EXCL on the temporary file. */
+bool
+xrep_tempfile_ilock_nowait(
+	struct xfs_scrub	*sc)
+{
+	if (xfs_ilock_nowait(sc->tempip, XFS_ILOCK_EXCL)) {
+		sc->temp_ilock_flags |= XFS_ILOCK_EXCL;
+		return true;
+	}
+
+	return false;
+}
+
+/* Unlock ILOCK_EXCL on the temporary file after an update. */
+void
+xrep_tempfile_iunlock(
+	struct xfs_scrub	*sc)
+{
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
+	sc->temp_ilock_flags &= ~XFS_ILOCK_EXCL;
+}
+
+/* Release the temporary file. */
+void
+xrep_tempfile_rele(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->tempip)
+		return;
+
+	if (sc->temp_ilock_flags) {
+		xfs_iunlock(sc->tempip, sc->temp_ilock_flags);
+		sc->temp_ilock_flags = 0;
+	}
+
+	xchk_irele(sc, sc->tempip);
+	sc->tempip = NULL;
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
new file mode 100644
index 0000000000000..e165e0a3faf63
--- /dev/null
+++ b/fs/xfs/scrub/tempfile.h
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_TEMPFILE_H__
+#define __XFS_SCRUB_TEMPFILE_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int xrep_tempfile_create(struct xfs_scrub *sc, uint16_t mode);
+void xrep_tempfile_rele(struct xfs_scrub *sc);
+
+bool xrep_tempfile_iolock_nowait(struct xfs_scrub *sc);
+int xrep_tempfile_iolock_polled(struct xfs_scrub *sc);
+void xrep_tempfile_iounlock(struct xfs_scrub *sc);
+
+void xrep_tempfile_ilock(struct xfs_scrub *sc);
+bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
+void xrep_tempfile_iunlock(struct xfs_scrub *sc);
+#else
+static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
+{
+	xchk_ilock(sc, XFS_IOLOCK_EXCL);
+}
+# define xrep_tempfile_rele(sc)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_TEMPFILE_H__ */
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5b294be52c558..c583599a75bf0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2273,6 +2273,39 @@ TRACE_EVENT(xrep_rmap_live_update,
 		  __entry->flags)
 );
 
+TRACE_EVENT(xrep_tempfile_create,
+	TP_PROTO(struct xfs_scrub *sc),
+	TP_ARGS(sc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, type)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, inum)
+		__field(unsigned int, gen)
+		__field(unsigned int, flags)
+		__field(xfs_ino_t, temp_inum)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->file ? XFS_I(file_inode(sc->file))->i_ino : 0;
+		__entry->type = sc->sm->sm_type;
+		__entry->agno = sc->sm->sm_agno;
+		__entry->inum = sc->sm->sm_ino;
+		__entry->gen = sc->sm->sm_gen;
+		__entry->flags = sc->sm->sm_flags;
+		__entry->temp_inum = sc->tempip->i_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx type %s inum 0x%llx gen 0x%x flags 0x%x temp_inum 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
+		  __entry->inum,
+		  __entry->gen,
+		  __entry->flags,
+		  __entry->temp_inum)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 440e9c0ebd6b8..1eee2f9ad265e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -42,7 +42,6 @@
 
 struct kmem_cache *xfs_inode_cache;
 
-STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 	struct xfs_inode *);
 
@@ -2162,7 +2161,7 @@ xfs_iunlink_insert_inode(
  * We place the on-disk inode on a list in the AGI.  It will be pulled from this
  * list when the inode is freed.
  */
-STATIC int
+int
 xfs_iunlink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7b238e88f23a..c6e0590c39b67 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -612,6 +612,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+
 void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);

