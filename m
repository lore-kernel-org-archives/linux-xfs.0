Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49452 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbdGUEiu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:38:50 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4cnmV029555
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:38:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4cnm1026828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:38:49 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v6L4cnAe018605
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:38:49 GMT
Subject: [PATCH 03/22] xfs: create an ioctl to scrub AG metadata
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:38:47 -0700
Message-ID: <150061192762.14732.9274339959944172701.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create an ioctl that can be used to scrub internal filesystem metadata.
The new ioctl takes the metadata type, an (optional) AG number, an
(optional) inode number and generation, and a flags argument.  This will
be used by the upcoming XFS online scrub tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig           |   17 +
 fs/xfs/Makefile          |    7 +
 fs/xfs/libxfs/xfs_fs.h   |   41 ++++
 fs/xfs/scrub/common.c    |  533 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h    |  179 +++++++++++++++
 fs/xfs/scrub/xfs_scrub.h |   29 +++
 fs/xfs/xfs_ioctl.c       |   28 ++
 fs/xfs/xfs_ioctl32.c     |    1 
 fs/xfs/xfs_trace.h       |    7 +
 9 files changed, 841 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/common.c
 create mode 100644 fs/xfs/scrub/common.h
 create mode 100644 fs/xfs/scrub/xfs_scrub.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 1b98cfa..f42fcf1 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -71,6 +71,23 @@ config XFS_RT
 
 	  If unsure, say N.
 
+config XFS_ONLINE_SCRUB
+	bool "XFS online metadata check support"
+	default n
+	depends on XFS_FS
+	help
+	  If you say Y here you will be able to check metadata on a
+	  mounted XFS filesystem.  This feature is intended to reduce
+	  filesystem downtime by supplementing xfs_repair.  The key
+	  advantage here is to look for problems proactively so that
+	  they can be dealt with in a controlled manner.
+
+	  This feature is considered EXPERIMENTAL.  Use with caution!
+
+	  See the xfs_scrub man page in section 8 for additional information.
+
+	  If unsure, say N.
+
 config XFS_WARN
 	bool "XFS Verbose Warnings"
 	depends on XFS_FS && !XFS_DEBUG
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5b959ee..c4fdaa2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -136,3 +136,10 @@ xfs-$(CONFIG_XFS_POSIX_ACL)	+= xfs_acl.o
 xfs-$(CONFIG_SYSCTL)		+= xfs_sysctl.o
 xfs-$(CONFIG_COMPAT)		+= xfs_ioctl32.o
 xfs-$(CONFIG_EXPORTFS_BLOCK_OPS)	+= xfs_pnfs.o
+
+# online scrub/repair
+ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
+xfs-y				+= $(addprefix scrub/, \
+				   common.o \
+				   )
+endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5dedab9..aeccc99 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -468,6 +468,46 @@ typedef struct xfs_swapext
 #define XFS_FSOP_GOING_FLAGS_LOGFLUSH		0x1	/* flush log but not data */
 #define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH		0x2	/* don't flush log nor data */
 
+/* metadata scrubbing */
+struct xfs_scrub_metadata {
+	__u32 sm_type;		/* What to check? */
+	__u32 sm_flags;		/* flags; see below. */
+	__u64 sm_ino;		/* inode number. */
+	__u32 sm_gen;		/* inode generation. */
+	__u32 sm_agno;		/* ag number. */
+	__u64 sm_reserved[5];	/* pad to 64 bytes */
+};
+
+/*
+ * Metadata types and flags for scrub operation.
+ */
+#define XFS_SCRUB_TYPE_TEST	0	/* dummy to test ioctl */
+#define XFS_SCRUB_TYPE_MAX	0
+
+/* i: repair this metadata */
+#define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
+/* o: metadata object needs repair */
+#define XFS_SCRUB_FLAG_CORRUPT		(1 << 1)
+/* o: metadata object could be optimized */
+#define XFS_SCRUB_FLAG_PREEN		(1 << 2)
+/* o: cross-referencing failed */
+#define XFS_SCRUB_FLAG_XFAIL		(1 << 3)
+/* o: metadata object disagrees with cross-referenced metadata */
+#define XFS_SCRUB_FLAG_XCORRUPT		(1 << 4)
+/* o: scan was not complete */
+#define XFS_SCRUB_FLAG_INCOMPLETE	(1 << 5)
+/* o: metadata object looked funny but isn't corrupt */
+#define XFS_SCRUB_FLAG_WARNING		(1 << 6)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_FLAG_REPAIR)
+#define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_FLAG_CORRUPT | \
+				 XFS_SCRUB_FLAG_PREEN | \
+				 XFS_SCRUB_FLAG_XFAIL | \
+				 XFS_SCRUB_FLAG_XCORRUPT | \
+				 XFS_SCRUB_FLAG_INCOMPLETE | \
+				 XFS_SCRUB_FLAG_WARNING)
+#define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
+
 /*
  * AG reserved block counters
  */
@@ -520,6 +560,7 @@ struct xfs_fsop_ag_resblks {
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
+#define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
new file mode 100644
index 0000000..6931793
--- /dev/null
+++ b/fs/xfs/scrub/common.c
@@ -0,0 +1,533 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+#include "scrub/xfs_scrub.h"
+#include "scrub/common.h"
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
+ * structure itself is corrupt, the CORRUPT flag will be set.  If
+ * the metadata is correct but otherwise suboptimal, the PREEN flag
+ * will be set.
+ */
+
+struct xfs_scrub_meta_fns {
+	int		(*setup)(struct xfs_scrub_context *,
+				 struct xfs_inode *);
+	int		(*scrub)(struct xfs_scrub_context *);
+	bool		(*has)(struct xfs_sb *);
+};
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
+	struct xfs_mount		*mp = sc->mp;
+
+	switch (*error) {
+	case 0:
+		return true;
+	case -EDEADLOCK:
+		/* Used to restart an op with deadlock avoidance. */
+		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Note the badness but don't abort. */
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		*error = 0;
+		/* fall through */
+	default:
+		trace_xfs_scrub_op_error(mp, agno, bno, type, *error, func,
+				line);
+		break;
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
+	switch (*error) {
+	case 0:
+		return true;
+	case -EDEADLOCK:
+		/* Used to restart an op with deadlock avoidance. */
+		trace_xfs_scrub_deadlock_retry(sc->ip, sc->sm, *error);
+		break;
+	case -EFSBADCRC:
+	case -EFSCORRUPTED:
+		/* Note the badness but don't abort. */
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+		*error = 0;
+		/* fall through */
+	default:
+		trace_xfs_scrub_file_op_error(sc->ip, whichfork, offset, type,
+				*error, func, line);
+		break;
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
+	struct xfs_mount		*mp = sc->mp;
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
+	struct xfs_mount		*mp = sc->mp;
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
+	struct xfs_mount		*mp = sc->mp;
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
+	struct xfs_mount		*mp = sc->mp;
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
+/* Check for file data block non-corruption problems. */
+bool
+xfs_scrub_data_warn_ok(
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
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_WARNING;
+	trace_xfs_scrub_data_warning(sc->ip, whichfork, offset, type, check,
+			func, line);
+	return fs_ok;
+}
+
+/* Signal an incomplete scrub. */
+bool
+xfs_scrub_incomplete(
+	struct xfs_scrub_context	*sc,
+	const char			*type,
+	bool				fs_ok,
+	const char			*check,
+	const char			*func,
+	int				line)
+{
+	if (fs_ok)
+		return fs_ok;
+
+	sc->sm->sm_flags |= XFS_SCRUB_FLAG_INCOMPLETE;
+	trace_xfs_scrub_incomplete(sc->mp, type, check, func, line);
+	return fs_ok;
+}
+
+/* Dummy scrubber */
+
+int
+xfs_scrub_dummy(
+	struct xfs_scrub_context	*sc)
+{
+	if (sc->sm->sm_ino || sc->sm->sm_agno)
+		return -EINVAL;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_CORRUPT)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_CORRUPT;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_PREEN)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_PREEN;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_XFAIL)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_XFAIL;
+	if (sc->sm->sm_gen & XFS_SCRUB_FLAG_XCORRUPT)
+		sc->sm->sm_flags |= XFS_SCRUB_FLAG_XCORRUPT;
+	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* Per-scrubber setup functions */
+
+/* Set us up with a transaction and an empty context. */
+int
+xfs_scrub_setup_fs(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	return xfs_scrub_trans_alloc(sc->sm, sc->mp,
+			&M_RES(sc->mp)->tr_itruncate, 0, 0, 0, &sc->tp);
+}
+
+/* Scrub setup and teardown */
+
+/* Free all the resources and finish the transactions. */
+STATIC int
+xfs_scrub_teardown(
+	struct xfs_scrub_context	*sc,
+	int				error)
+{
+	if (sc->tp) {
+		xfs_trans_cancel(sc->tp);
+		sc->tp = NULL;
+	}
+	return error;
+}
+
+/* Perform common scrub context initialization. */
+STATIC int
+xfs_scrub_setup(
+	struct xfs_inode		*ip,
+	struct xfs_scrub_context	*sc,
+	const struct xfs_scrub_meta_fns	*fns,
+	struct xfs_scrub_metadata	*sm,
+	bool				try_harder)
+{
+	memset(sc, 0, sizeof(*sc));
+	sc->mp = ip->i_mount;
+	sc->sm = sm;
+	sc->fns = fns;
+	sc->try_harder = try_harder;
+
+	return sc->fns->setup(sc, ip);
+}
+
+/* Scrubbing dispatch. */
+
+static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
+	{ /* dummy verifier */
+		.setup	= xfs_scrub_setup_fs,
+		.scrub	= xfs_scrub_dummy,
+	},
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
+	bool				try_harder = false;
+	int				error = 0;
+
+	trace_xfs_scrub(ip, sm, error);
+
+	/* Forbidden if we are shut down or mounted norecovery. */
+	error = -ESHUTDOWN;
+	if (XFS_FORCED_SHUTDOWN(mp))
+		goto out;
+	error = -ENOTRECOVERABLE;
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY)
+		goto out;
+
+	/* Check our inputs. */
+	error = -EINVAL;
+	sm->sm_flags &= ~XFS_SCRUB_FLAGS_OUT;
+	if (sm->sm_flags & ~XFS_SCRUB_FLAGS_IN)
+		goto out;
+	if (memchr_inv(sm->sm_reserved, 0, sizeof(sm->sm_reserved)))
+		goto out;
+
+	/* Do we know about this type of metadata? */
+	error = -ENOENT;
+	if (sm->sm_type > XFS_SCRUB_TYPE_MAX)
+		goto out;
+	fns = &meta_scrub_fns[sm->sm_type];
+	if (fns->scrub == NULL)
+		goto out;
+
+	/* Does this fs even support this type of metadata? */
+	if (fns->has && !fns->has(&mp->m_sb))
+		goto out;
+
+	/* We don't know how to repair anything yet. */
+	error = -EOPNOTSUPP;
+	if (sm->sm_flags & XFS_SCRUB_FLAG_REPAIR)
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
+	/* Set up for the operation. */
+	error = xfs_scrub_setup(ip, &sc, fns, sm, try_harder);
+	if (error)
+		goto out_teardown;
+
+	/* Scrub for errors. */
+	error = fns->scrub(&sc);
+	if (!try_harder && error == -EDEADLOCK) {
+		/*
+		 * Scrubbers return -EDEADLOCK to mean 'try harder'.
+		 * Tear down everything we hold, then set up again with
+		 * preparation for worst-case scenarios.
+		 */
+		error = xfs_scrub_teardown(&sc, 0);
+		if (error)
+			goto out;
+		try_harder = true;
+		goto retry_op;
+	} else if (error)
+		goto out_teardown;
+
+	if (xfs_scrub_found_corruption(sm))
+		xfs_alert_ratelimited(mp, "Corruption detected during scrub.");
+
+out_teardown:
+	error = xfs_scrub_teardown(&sc, error);
+out:
+	trace_xfs_scrub_done(ip, sm, error);
+	return error;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
new file mode 100644
index 0000000..4f3113a
--- /dev/null
+++ b/fs/xfs/scrub/common.h
@@ -0,0 +1,179 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+/* Did we find something broken? */
+static inline bool xfs_scrub_found_corruption(struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_FLAG_CORRUPT |
+			       XFS_SCRUB_FLAG_XCORRUPT);
+}
+
+struct xfs_scrub_context {
+	/* General scrub state. */
+	struct xfs_mount		*mp;
+	struct xfs_scrub_metadata	*sm;
+	const struct xfs_scrub_meta_fns	*fns;
+	struct xfs_trans		*tp;
+	struct xfs_inode		*ip;
+	bool				try_harder;
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
+	} while (0)
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
+	} while (0)
+
+/* Check for file data block non-corruption problems. */
+bool xfs_scrub_data_warn_ok(struct xfs_scrub_context *sc, int whichfork,
+			    xfs_fileoff_t offset, const char *type, bool fs_ok,
+			    const char *check, const char *func, int line);
+#define XFS_SCRUB_DATA_WARN(sc, whichfork, offset, type, fs_ok) \
+	xfs_scrub_data_warn_ok((sc), (whichfork), (offset), (type), (fs_ok), \
+			#fs_ok, __func__, __LINE__)
+
+/* Signal an incomplete scrub. */
+bool xfs_scrub_incomplete(struct xfs_scrub_context *sc, const char *type,
+			  bool fs_ok, const char *check, const char *func,
+			  int line);
+#define XFS_SCRUB_INCOMPLETE(sc, type, fs_ok) \
+	xfs_scrub_incomplete((sc), (type), (fs_ok), \
+			#fs_ok, __func__, __LINE__)
+
+/* Setup functions */
+
+#define SETUP_FN(name) int name(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+SETUP_FN(xfs_scrub_setup_fs);
+#undef SETUP_FN
+
+/* Metadata scrubbers */
+
+#define SCRUB_FN(name) int name(struct xfs_scrub_context *sc)
+SCRUB_FN(xfs_scrub_dummy);
+#undef SCRUB_FN
+
+#endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/xfs_scrub.h b/fs/xfs/scrub/xfs_scrub.h
new file mode 100644
index 0000000..e00e0ea
--- /dev/null
+++ b/fs/xfs/scrub/xfs_scrub.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
+#ifndef CONFIG_XFS_ONLINE_SCRUB
+# define xfs_scrub_metadata(ip, sm)	(-ENOTTY)
+#else
+int xfs_scrub_metadata(struct xfs_inode *ip, struct xfs_scrub_metadata *sm);
+#endif /* CONFIG_XFS_ONLINE_SCRUB */
+
+#endif	/* __XFS_SCRUB_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cc00260..87b3874 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 #include "xfs_btree.h"
 #include <linux/fsmap.h>
 #include "xfs_fsmap.h"
+#include "scrub/xfs_scrub.h"
 
 #include <linux/capability.h>
 #include <linux/cred.h>
@@ -1689,6 +1690,30 @@ xfs_ioc_getfsmap(
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
@@ -1872,6 +1897,9 @@ xfs_file_ioctl(
 	case FS_IOC_GETFSMAP:
 		return xfs_ioc_getfsmap(ip, arg);
 
+	case XFS_IOC_SCRUB_METADATA:
+		return xfs_ioc_scrub_metadata(ip, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e8b4de3..972d4bd 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -557,6 +557,7 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ERROR_CLEARALL:
 	case FS_IOC_GETFSMAP:
 	case XFS_IOC_GET_AG_RESBLKS:
+	case XFS_IOC_SCRUB_METADATA:
 		return xfs_file_ioctl(filp, cmd, p);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 2e7e193..d4de29b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3312,7 +3312,7 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 
 /* scrub */
 #define XFS_SCRUB_TYPE_DESC \
-	{ 0, NULL }
+	{ XFS_SCRUB_TYPE_TEST,		"dummy" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
@@ -3330,6 +3330,11 @@ DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
+		__entry->type = sm->sm_type;
+		__entry->agno = sm->sm_agno;
+		__entry->inum = sm->sm_ino;
+		__entry->gen = sm->sm_gen;
+		__entry->flags = sm->sm_flags;
 		__entry->error = error;
 	),
 	TP_printk("dev %d:%d ino %llu type %s agno %u inum %llu gen %u flags 0x%x error %d",

