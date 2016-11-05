Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17721 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753021AbcKEAUM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:20:12 -0400
Subject: [PATCH 10/41] xfs: create an ioctl to scrub AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:20:09 -0700
Message-ID: <147830520929.2155.14700097847467190958.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
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
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   35 ++++
 fs/xfs/xfs_ioctl.c     |   28 +++
 fs/xfs/xfs_ioctl32.c   |    1 
 fs/xfs/xfs_scrub.c     |  458 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_scrub.h     |   25 +++
 fs/xfs/xfs_trace.h     |    2 
 7 files changed, 549 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_scrub.c
 create mode 100644 fs/xfs/xfs_scrub.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0e7ee30..8d72396 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -93,6 +93,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_reflink.o \
+				   xfs_scrub.o \
 				   xfs_stats.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ad49e2c..76f3e47 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -43,6 +43,7 @@
 #include "xfs_acl.h"
 #include "xfs_btree.h"
 #include "xfs_fsmap.h"
+#include "xfs_scrub.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -1708,6 +1709,30 @@ xfs_ioc_getfsmap(
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
@@ -1893,6 +1918,9 @@ xfs_file_ioctl(
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
diff --git a/fs/xfs/xfs_scrub.c b/fs/xfs/xfs_scrub.c
new file mode 100644
index 0000000..501e369
--- /dev/null
+++ b/fs/xfs/xfs_scrub.c
@@ -0,0 +1,458 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#include "xfs_scrub.h"
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
+struct xfs_scrub_context {
+	/* General scrub state. */
+	struct xfs_scrub_metadata	*sm;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+};
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
+/* Check for operational errors. */
+static inline bool
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
+#define XFS_SCRUB_OP_ERROR_GOTO(sc, agno, bno, type, error, label) \
+	do { \
+		if (!xfs_scrub_op_ok((sc), (agno), (bno), (type), \
+				(error), __func__, __LINE__)) \
+			goto label; \
+	} while (0)
+
+/* Check for operational errors for a file offset. */
+static inline bool
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
+#define XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, which, off, type, error, label) \
+	do { \
+		if (!xfs_scrub_file_op_ok((sc), (which), (off), (type), \
+				(error), __func__, __LINE__)) \
+			goto label; \
+	} while (0)
+
+/* Check for metadata block corruption. */
+static inline bool
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
+static inline bool
+xfs_scrub_ino_ok(
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
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	trace_xfs_scrub_ino_error(ip, agno, bno, type, check, func, line);
+	return fs_ok;
+}
+#define XFS_SCRUB_INO_CHECK(sc, bp, type, fs_ok) \
+	xfs_scrub_ino_ok((sc), (bp), (type), (fs_ok), #fs_ok, \
+			__func__, __LINE__)
+#define XFS_SCRUB_INO_GOTO(sc, bp, type, fs_ok, label) \
+	do { \
+		if (!xfs_scrub_ino_ok((sc), (bp), (type), (fs_ok), \
+				#fs_ok, __func__, __LINE__)) \
+			goto label; \
+	} while(0)
+
+/* Check for file data block corruption. */
+static inline bool
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
+		return -EIO;
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
+	/* Push everything out of the log onto disk prior to checking. */
+	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
+	if (error)
+		goto out;
+	xfs_ail_push_all_sync(mp->m_ail);
+
+retry_op:
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
diff --git a/fs/xfs/xfs_scrub.h b/fs/xfs/xfs_scrub.h
new file mode 100644
index 0000000..f4bb021
--- /dev/null
+++ b/fs/xfs/xfs_scrub.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
+
+#endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba61ca6..f004784 100644
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

