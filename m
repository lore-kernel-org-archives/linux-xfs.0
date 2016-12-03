Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22724 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757737AbcLCBhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:39 -0500
Subject: [PATCH 17/55] xfs: create an ioctl to scrub AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:37:02 -0800
Message-ID: <148072902216.12995.8637981749325239392.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create an ioctl that can be used to scrub internal filesystem metadata.
The new ioctl takes the metadata type, an (optional) AG number, an
(optional) inode number and generation, and a flags argument.  This will
be used by the upcoming XFS online scrub tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig            |   16 ++
 fs/xfs/Makefile           |    5 +
 fs/xfs/libxfs/xfs_fs.h    |   35 ++++
 fs/xfs/repair/common.c    |  447 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/repair/common.h    |  141 ++++++++++++++
 fs/xfs/repair/xfs_scrub.h |   29 +++
 fs/xfs/xfs_ioctl.c        |   28 +++
 fs/xfs/xfs_ioctl32.c      |    1 
 fs/xfs/xfs_trace.h        |    2 
 9 files changed, 703 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/repair/common.c
 create mode 100644 fs/xfs/repair/common.h
 create mode 100644 fs/xfs/repair/xfs_scrub.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 35faf12..c08bde9 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -96,3 +96,19 @@ config XFS_DEBUG
 	  not useful unless you are debugging a particular problem.
 
 	  Say N unless you are an XFS developer, or you play one on TV.
+
+config XFS_ONLINE_REPAIR
+	bool "XFS Online Scrub and Repair"
+	depends on XFS_FS
+	help
+	  If you say Y here you will be able to use the xfs_scrub
+	  program to check and repair XFS metadata on mounted
+	  filesystems.  The online scrub feature checks all filesystem
+	  metadata for corruption and inconsistencies.  The online
+	  repair feature can correct minor problems with the filesystem
+	  metadata, though more thorough repairs still require
+	  xfs_repair.  This configure option will disappear when the
+	  feature matures and becomes a regular part of XFS.
+
+	  Say N unless are an XFS developer with good backups!
+	  This code is not yet mature!
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5c90f82..ae7dc3f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -101,6 +101,11 @@ xfs-y				+= xfs_aops.o \
 				   kmem.o \
 				   uuid.o
 
+# online scrub/repair
+xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
+				   common.o \
+				   )
+
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
 				   xfs_log_cil.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index e62996f..34fd6c1 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -554,6 +554,40 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
+/* metadata scrubbing */
+struct xfs_scrub_metadata {
+	__u32 sm_type;		/* What to check? */
+	__u32 sm_flags;		/* Flags; none defined right now. */
+	union {
+		__u32		__agno;
+		struct {
+			__u64	__ino;
+			__u32	__gen;
+		} i;
+		__u64		__reserved[7];	/* pad to 64 bytes */
+	} p;
+};
+#define sm_agno	p.__agno
+#define sm_ino	p.i.__ino
+#define sm_gen	p.i.__gen
+
+/*
+ * Metadata types and flags for scrub operation.
+ */
+#define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
+#define XFS_SCRUB_TYPE_MAX	0
+
+#define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
+#define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
+#define XFS_SCRUB_FLAG_PREEN	0x4	/* o: could be optimized */
+#define XFS_SCRUB_FLAG_XREF_FAIL 0x8	/* o: errors during cross-referencing */
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_FLAG_REPAIR)
+#define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_FLAG_CORRUPT | \
+				 XFS_SCRUB_FLAG_PREEN | \
+				 XFS_SCRUB_FLAG_XREF_FAIL)
+#define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
+
 /*
  * ioctl limits
  */
@@ -597,6 +631,7 @@ typedef struct xfs_swapext
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 #define XFS_IOC_GETFSMAP	_IOWR('X', 59, struct fsmap_head)
+#define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
new file mode 100644
index 0000000..8a835a8
--- /dev/null
+++ b/fs/xfs/repair/common.c
@@ -0,0 +1,447 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ialloc.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_log.h"
+#include "xfs_trans_priv.h"
+#include "repair/xfs_scrub.h"
+#include "repair/common.h"
+
+/*
+ * Online Scrub and Repair
+ *
+ * Traditionally, XFS (the kernel driver) did not know how to check or
+ * repair on-disk data structures.  That task was left to the xfs_check
+ * and xfs_repair tools, both of which require taking the filesystem
+ * offline for a thorough but time consuming examination.  Online
+ * scrub & repair, on the other hand, enables us to check the metadata
+ * for obvious errors while carefully stepping around the filesystem's
+ * ongoing operations, locking rules, etc.
+ *
+ * Given that most XFS metadata consist of records stored in a btree,
+ * most of the checking functions iterate the btree blocks themselves
+ * looking for irregularities.  When a record block is encountered, each
+ * record can be checked for obviously bad values.  Record values can
+ * also be cross-referenced against other btrees to look for potential
+ * misunderstandings between pieces of metadata.
+ *
+ * It is expected that the checkers responsible for per-AG metadata
+ * structures will lock the AG headers (AGI, AGF, AGFL), iterate the
+ * metadata structure, and perform any relevant cross-referencing before
+ * unlocking the AG and returning the results to userspace.  These
+ * scrubbers must not keep an AG locked for too long to avoid tying up
+ * the block and inode allocators.
+ *
+ * Block maps and b-trees rooted in an inode present a special challenge
+ * because they can involve extents from any AG.  The general scrubber
+ * structure of lock -> check -> xref -> unlock still holds, but AG
+ * locking order rules /must/ be obeyed to avoid deadlocks.  The
+ * ordering rule, of course, is that we must lock in increasing AG
+ * order.  Helper functions are provided to track which AG headers we've
+ * already locked.  If we detect an imminent locking order violation, we
+ * can signal a potential deadlock, in which case the scrubber can jump
+ * out to the top level, lock all the AGs in order, and retry the scrub.
+ *
+ * For file data (directories, extended attributes, symlinks) scrub, we
+ * can simply lock the inode and walk the data.  For btree data
+ * (directories and attributes) we follow the same btree-scrubbing
+ * strategy outlined previously to check the records.
+ *
+ * We use a bit of trickery with transactions to avoid buffer deadlocks
+ * if there is a cycle in the metadata.  The basic problem is that
+ * travelling down a btree involves locking the current buffer at each
+ * tree level.  If a pointer should somehow point back to a buffer that
+ * we've already examined, we will deadlock due to the second buffer
+ * locking attempt.  Note however that grabbing a buffer in transaction
+ * context links the locked buffer to the transaction.  If we try to
+ * re-grab the buffer in the context of the same transaction, we avoid
+ * the second lock attempt and continue.  Between the verifier and the
+ * scrubber, something will notice that something is amiss and report
+ * the corruption.  Therefore, each scrubber will allocate an empty
+ * transaction, attach buffers to it, and cancel the transaction at the
+ * end of the scrub run.  Cancelling a non-dirty transaction simply
+ * unlocks the buffers.
+ *
+ * There are four pieces of data that scrub can communicate to
+ * userspace.  The first is the error code (errno), which can be used to
+ * communicate operational errors in performing the scrub.  There are
+ * also three flags that can be set in the scrub context.  If the data
+ * structure itself is corrupt, the "corrupt" flag should be set.  If
+ * the metadata is correct but otherwise suboptimal, there's a "preen"
+ * flag to signal that.  Finally, if we were unable to access a data
+ * structure to perform cross-referencing, we can signal that as well.
+ */
+
+/* Check for operational errors. */
+bool
+xfs_scrub_op_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			bno,
+	const char			*type,
+	int				*error,
+	const char			*func,
+	int				line)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+
+	if (*error == 0)
+		return true;
+
+	trace_xfs_scrub_op_error(mp, agno, bno, type, *error, func, line);
+	if (*error == -EFSBADCRC || *error == -EFSCORRUPTED) {
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		*error = 0;
+	}
+	return false;
+}
+
+/* Check for operational errors for a file offset. */
+bool
+xfs_scrub_file_op_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	const char			*type,
+	int				*error,
+	const char			*func,
+	int				line)
+{
+	if (*error == 0)
+		return true;
+
+	trace_xfs_scrub_file_op_error(sc->ip, whichfork, offset, type, *error,
+			func, line);
+	if (*error == -EFSBADCRC || *error == -EFSCORRUPTED) {
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		*error = 0;
+	}
+	return false;
+}
+
+/* Check for metadata block optimization possibilities. */
+bool
+xfs_scrub_block_preen(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	trace_xfs_scrub_block_preen(mp, agno, bno, type, check, func, line);
+	return fs_ok;
+}
+
+/* Check for metadata block corruption. */
+bool
+xfs_scrub_block_ok(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	trace_xfs_scrub_block_error(mp, agno, bno, type, check, func, line);
+	return fs_ok;
+}
+
+/* Check for inode metadata corruption. */
+bool
+xfs_scrub_ino_ok(
+	struct xfs_scrub_context	*sc,
+	xfs_ino_t			ino,
+	struct xfs_buf			*bp,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	if (bp) {
+		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	}
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	trace_xfs_scrub_ino_error(mp, ino, agno, bno, type, check, func, line);
+	return fs_ok;
+}
+
+/* Check for inode metadata optimization possibilities. */
+bool
+xfs_scrub_ino_preen(
+	struct xfs_scrub_context	*sc,
+	struct xfs_buf			*bp,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_mount		*mp = ip->i_mount;
+	xfs_fsblock_t			fsbno;
+	xfs_agnumber_t			agno;
+	xfs_agblock_t			bno;
+
+	if (fs_ok)
+		return fs_ok;
+
+	if (bp) {
+		fsbno = XFS_DADDR_TO_FSB(mp, bp->b_bn);
+		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+		bno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	} else {
+		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+		bno = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	}
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	trace_xfs_scrub_ino_preen(mp, ip->i_ino, agno, bno, type, check,
+			func, line);
+	return fs_ok;
+}
+
+/* Check for file data block corruption. */
+bool
+xfs_scrub_data_ok(
+	struct xfs_scrub_context	*sc,
+	int				whichfork,
+	xfs_fileoff_t			offset,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	trace_xfs_scrub_data_error(sc->ip, whichfork, offset, type, check,
+			func, line);
+	return fs_ok;
+}
+
+/* Dummy scrubber */
+
+STATIC int
+xfs_scrub_dummy(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_CORRUPT)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_PREEN)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_XREF_FAIL)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_XREF_FAIL;
+	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* Scrub setup and teardown. */
+
+/* Free all the resources and finish the transactions. */
+STATIC int
+xfs_scrub_teardown(
+	struct xfs_scrub_context	*sc,
+	int				error)
+{
+	xfs_trans_cancel(sc->tp);
+	sc->tp = NULL;
+	return error;
+}
+
+/* Set us up with a transaction and an empty context. */
+STATIC int
+xfs_scrub_setup(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+
+	memset(sc, 0, sizeof(*sc));
+	sc->sm = sm;
+	return xfs_scrub_trans_alloc(sm, mp, &M_RES(mp)->tr_itruncate,
+			0, 0, 0, &sc->tp);
+}
+
+/* Scrubbing dispatch. */
+
+struct xfs_scrub_meta_fns {
+	int	(*setup)(struct xfs_scrub_context *, struct xfs_inode *,
+			 struct xfs_scrub_metadata *, bool);
+	int	(*scrub)(struct xfs_scrub_context *);
+	int	(*repair)(struct xfs_scrub_context *);
+	bool	(*has)(struct xfs_sb *);
+};
+
+static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
+	{xfs_scrub_setup, xfs_scrub_dummy, NULL, NULL},
+};
+
+/* Dispatch metadata scrubbing. */
+int
+xfs_scrub_metadata(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm)
+{
+	struct xfs_scrub_context	sc;
+	struct xfs_mount		*mp = ip->i_mount;
+	const struct xfs_scrub_meta_fns	*fns;
+	bool				deadlocked = false;
+	int				error = 0;
+
+	trace_xfs_scrub(ip, sm->sm_type, sm->sm_agno, sm->sm_ino, sm->sm_gen,
+			sm->sm_flags, error);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -ESHUTDOWN;
+
+	/* Check our inputs. */
+	error = -EINVAL;
+	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
+		goto out;
+	if (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)
+		goto out;
+	error = -ENOTTY;
+	if (sm->sm_type > XFS_SCRUB_TYPE_MAX)
+		goto out;
+	fns = &meta_scrub_fns[sm->sm_type];
+
+	/* Do we even have this type of metadata? */
+	error = -ENOENT;
+	if (fns->has && !fns->has(&mp->m_sb))
+		goto out;
+
+	/* This isn't a stable feature.  Use with care. */
+	{
+		static bool warned;
+
+		if (!warned)
+			xfs_alert(mp,
+	"EXPERIMENTAL online scrub feature in use. Use at your own risk!");
+		warned = true;
+	}
+
+retry_op:
+	/* Push everything out of the log onto disk prior to checking. */
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	if (error)
+		goto out;
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/* Set up for the operation. */
+	error = fns->setup(&sc, ip, sm, deadlocked);
+	if (error)
+		goto out;
+
+	/* Scrub for errors. */
+	error = fns->scrub(&sc);
+	if (!deadlocked && error == -EDEADLOCK) {
+		deadlocked = true;
+		error = xfs_scrub_teardown(&sc, error);
+		if (error != -EDEADLOCK)
+			goto out;
+		goto retry_op;
+	} else if (error)
+		goto out_teardown;
+
+	if (sm->sm_flags & XFS_SCRUB_FLAG_CORRUPT)
+		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+
+out_teardown:
+	error = xfs_scrub_teardown(&sc, error);
+out:
+	trace_xfs_scrub_done(ip, sm->sm_type, sm->sm_agno, sm->sm_ino,
+			sm->sm_gen, sm->sm_flags, error);
+	return error;
+}
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
new file mode 100644
index 0000000..0f04a06
--- /dev/null
+++ b/fs/xfs/repair/common.h
@@ -0,0 +1,141 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_REPAIR_COMMON_H__
+#define __XFS_REPAIR_COMMON_H__
+
+struct xfs_scrub_context {
+	/* General scrub state. */
+	struct xfs_scrub_metadata	*sm;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+};
+
+/* Should we end the scrub early? */
+static inline bool
+xfs_scrub_should_terminate(
+	int		*error)
+{
+	if (fatal_signal_pending(current)) {
+		if (*error == 0)
+			*error = -EAGAIN;
+		return true;
+	}
+	return false;
+}
+
+/*
+ * Grab a transaction.  If we're going to repair something, we need to
+ * ensure there's enough reservation to make all the changes.  If not,
+ * we can use an empty transaction.
+ */
+static inline int
+xfs_scrub_trans_alloc(
+	struct xfs_scrub_metadata	*sm,
+	struct xfs_mount		*mp,
+	struct xfs_trans_res		*resp,
+	uint				blocks,
+	uint				rtextents,
+	uint				flags,
+	struct xfs_trans		**tpp)
+{
+	return xfs_trans_alloc_empty(mp, tpp);
+}
+
+/* Check for operational errors. */
+bool xfs_scrub_op_ok(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
+		     xfs_agblock_t bno, const char *type, int *error,
+		     const char	*func, int line);
+#define XFS_SCRUB_OP_ERROR_GOTO(sc, agno, bno, type, error, label) \
+	do { \
+		if (!xfs_scrub_op_ok((sc), (agno), (bno), (type), \
+				(error), __func__, __LINE__)) \
+			goto label; \
+	} while (0)
+
+/* Check for operational errors for a file offset. */
+bool xfs_scrub_file_op_ok(struct xfs_scrub_context *sc, int whichfork,
+			  xfs_fileoff_t offset, const char *type,
+			  int *error, const char *func, int line);
+#define XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, which, off, type, error, label) \
+	do { \
+		if (!xfs_scrub_file_op_ok((sc), (which), (off), (type), \
+				(error), __func__, __LINE__)) \
+			goto label; \
+	} while (0)
+
+/* Check for metadata block optimization possibilities. */
+bool xfs_scrub_block_preen(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			   const char *type, bool fs_ok, const char *check,
+			   const char *func, int line);
+#define XFS_SCRUB_PREEN(sc, bp, type, fs_ok) \
+	xfs_scrub_block_preen((sc), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__)
+
+/* Check for inode metadata optimization possibilities. */
+bool xfs_scrub_ino_preen(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+		      const char *type, bool fs_ok, const char *check,
+		      const char *func, int line);
+#define XFS_SCRUB_INO_PREEN(sc, bp, type, fs_ok) \
+	xfs_scrub_ino_preen((sc), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__)
+
+/* Check for metadata block corruption. */
+bool xfs_scrub_block_ok(struct xfs_scrub_context *sc, struct xfs_buf *bp,
+			const char *type, bool fs_ok, const char *check,
+			const char *func, int line);
+#define XFS_SCRUB_CHECK(sc, bp, type, fs_ok) \
+	xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__)
+#define XFS_SCRUB_GOTO(sc, bp, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_block_ok((sc), (bp), (type), (fs_ok), \
+				#fs_ok, __func__, __LINE__)) \
+			goto label; \
+	} while (0)
+
+/* Check for inode metadata corruption. */
+bool xfs_scrub_ino_ok(struct xfs_scrub_context *sc, xfs_ino_t ino,
+		      struct xfs_buf *bp, const char *type, bool fs_ok,
+		      const char *check, const char *func, int line);
+#define XFS_SCRUB_INO_CHECK(sc, ino, bp, type, fs_ok) \
+	xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__)
+#define XFS_SCRUB_INO_GOTO(sc, ino, bp, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_ino_ok((sc), (ino), (bp), (type), (fs_ok), \
+				#fs_ok, __func__, __LINE__)) \
+			goto label; \
+	} while(0)
+
+/* Check for file data block corruption. */
+bool xfs_scrub_data_ok(struct xfs_scrub_context *sc, int whichfork,
+		       xfs_fileoff_t offset, const char *type, bool fs_ok,
+		       const char *check, const char *func, int line);
+#define XFS_SCRUB_DATA_CHECK(sc, whichfork, offset, type, fs_ok) \
+	xfs_scrub_data_ok((sc), (whichfork), (offset), (type), (fs_ok), \
+			#fs_ok, __func__, __LINE__)
+#define XFS_SCRUB_DATA_GOTO(sc, whichfork, offset, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_data_ok((sc), (whichfork), (offset), \
+				(type), (fs_ok), #fs_ok, __func__, __LINE__)) \
+			goto label; \
+	} while(0)
+
+#endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/xfs_scrub.h b/fs/xfs/repair/xfs_scrub.h
new file mode 100644
index 0000000..604a308
--- /dev/null
+++ b/fs/xfs/repair/xfs_scrub.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_SCRUB_H__
+#define __XFS_SCRUB_H__
+
+#ifndef CONFIG_XFS_ONLINE_REPAIR
+# define xfs_scrub_metadata(ip, sm)	(-ENOTTY)
+#else
+int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f4307d0..2193053 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include "xfs_acl.h"
 #include "xfs_btree.h"
 #include "xfs_fsmap.h"
+#include "repair/xfs_scrub.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1706,6 +1707,30 @@ xfs_ioc_getfsmap(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_scrub_metadata(
+	struct xfs_inode		*ip,
+	void				__user *arg)
+{
+	struct xfs_scrub_metadata	scrub;
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&scrub, arg, sizeof(scrub)))
+		return -EFAULT;
+
+	error = xfs_scrub_metadata(ip, &scrub);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &scrub, sizeof(scrub)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1891,6 +1916,9 @@ xfs_file_ioctl(
 			return -EPERM;
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUB_METADATA:
+		return xfs_ioc_scrub_metadata(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 9491bc8..58ed5e3 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -555,6 +555,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 	case XFS_IOC_GETFSMAP:
+	case XFS_IOC_SCRUB_METADATA:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ddbba0f..00aab19 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3462,7 +3462,7 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
-	{ 0, NULL }
+	{ XFS_SCRUB_TYPE_TEST,		"dummy" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

