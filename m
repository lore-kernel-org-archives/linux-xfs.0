Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19A1C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjBPUqb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBPUqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:46:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3B84ECDC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88E9C60C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A8CC433D2;
        Thu, 16 Feb 2023 20:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580388;
        bh=Jpix4l79uxEyef4a3ARIWN8HGKLLJ5nb2yWdUnHIPBk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=CDEOLvJ9niXoyDabls869CHtEXblwQK0ugIefBiH7v6oGxEVMTNnGkPdkTWJYQHz0
         oDuHxl8VpU+fLu+pRizksREuylECGMpUt7vo2yzDchxLUNbQqtJ3NJnfae0ntnqjFj
         RoZoa/Y0x/lBSD3ptfRzAL7ufi0qUqMevEcKYy8X4c11j71IU1OzhmRPGPvVRMQBgP
         Mz1j5wILbFzlmB3I52HVTS0kbx4DuaHd3mJCqvWOhM0blBu1HBSLFh3dcy4RFvW2lv
         lDNTMOjCtXIvd4+7CNtDktOs+9u5wUF8cx/Fq6TEsv4Pa4gUW77V0nOcKRJok6ODjf
         c/HLJCELWo52Q==
Date:   Thu, 16 Feb 2023 12:46:27 -0800
Subject: [PATCH 18/23] xfs: create temporary files and directories for online
 repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874092.3474338.7391157200912655441.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the online repair code how to create temporary files or
directories.  These temporary files can be used to stage reconstructed
information until we're ready to perform an atomic extent swap to commit
the new metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/common.c   |    1 
 fs/xfs/scrub/scrub.c    |    2 
 fs/xfs/scrub/scrub.h    |    4 +
 fs/xfs/scrub/tempfile.c |  230 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   27 ++++++
 fs/xfs/scrub/trace.h    |   33 +++++++
 fs/xfs/xfs_inode.c      |    3 -
 fs/xfs/xfs_inode.h      |    2 
 9 files changed, 301 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9a6ef1f7c27b..2562c852db7f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -178,6 +178,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   repair.o \
+				   tempfile.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a4cfe5653880..2874da088e8d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -33,6 +33,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/tempfile.h"
 
 /* Common code for the metadata scrubbers. */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 871a72e22a8a..a19ea7fdd510 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -22,6 +22,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/tempfile.h"
 
 /*
  * Online Scrub and Repair
@@ -193,6 +194,7 @@ xchk_teardown(
 		sc->buf = NULL;
 	}
 
+	xrep_tempfile_rele(sc);
 	xchk_fshooks_disable(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 484e5fb7fe7a..20e814a53850 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -80,6 +80,10 @@ struct xfs_scrub {
 	void				*buf;
 	uint				ilock_flags;
 
+	/* A temporary file on this filesystem, for staging new metadata. */
+	struct xfs_inode		*tempip;
+	uint				temp_ilock_flags;
+
 	/* See the XCHK/XREP state flags below. */
 	unsigned int			flags;
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
new file mode 100644
index 000000000000..8f80f1c2555c
--- /dev/null
+++ b/fs/xfs/scrub/tempfile.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/tempfile.h"
+
+/*
+ * Create a temporary file for reconstructing metadata, with the intention of
+ * atomically swapping the temporary file's contents with the file that's
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
+	error = xfs_init_new_inode(&init_user_ns, tp, dp, ino, mode, 0, 0,
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
+	 * Anything being reconstructed using this file must be atomically
+	 * swapped with the original file because the contents here will be
+	 * purged when the inode is dropped or log recovery cleans out the
+	 * unlinked list.
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
index 000000000000..f00a9ce43a32
--- /dev/null
+++ b/fs/xfs/scrub/tempfile.h
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
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
index 4a6f0f1b0881..0c27eb197f83 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1149,6 +1149,39 @@ TRACE_EVENT(xrep_ialloc_insert,
 		  __entry->freemask)
 )
 
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
index b17e4ba3622b..8ad646beee75 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -48,7 +48,6 @@ struct kmem_cache *xfs_inode_cache;
  */
 #define	XFS_ITRUNC_MAX_EXTENTS	2
 
-STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 	struct xfs_inode *);
 
@@ -2187,7 +2186,7 @@ xfs_iunlink_insert_inode(
  * We place the on-disk inode on a list in the AGI.  It will be pulled from this
  * list when the inode is freed.
  */
-STATIC int
+int
 xfs_iunlink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7a16642a8c3..94a1490fb7b0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -570,6 +570,8 @@ extern struct kmem_cache	*xfs_inode_cache;
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+
 void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);

