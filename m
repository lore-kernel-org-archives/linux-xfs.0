Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43902 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752343AbeCAGms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 01:42:48 -0500
Date: Wed, 28 Feb 2018 22:42:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 5/5] xfs: fix agfl wrapping
Message-ID: <20180301064241.GO19312@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935121574.21654.7158330354778549108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151935121574.21654.7158330354778549108.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the AGFL wrapping issues introduced with the v5 disk format and
semi-corrected later in 4.5.  In short, if we find an incorrectly
wrapped agfl at mount time, or a list that touches the last item in the
agfl block, move the entire list to the start of the agfl block to avoid
triggering wrapping problems if the next mount is on a kernel that does
not have the 4.5 wrapping fix.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile     |    1 
 fs/xfs/xfs_fixups.c |  492 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fixups.h |   26 +++
 fs/xfs/xfs_mount.c  |   21 ++
 fs/xfs/xfs_super.c  |   10 +
 fs/xfs/xfs_trace.h  |   25 +++
 6 files changed, 574 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_fixups.c
 create mode 100644 fs/xfs/xfs_fixups.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b03c77e..f88368a 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_extent_busy.o \
 				   xfs_file.o \
 				   xfs_filestream.o \
+				   xfs_fixups.o \
 				   xfs_fsmap.o \
 				   xfs_fsops.o \
 				   xfs_globals.o \
diff --git a/fs/xfs/xfs_fixups.c b/fs/xfs/xfs_fixups.c
new file mode 100644
index 0000000..05b7193
--- /dev/null
+++ b/fs/xfs/xfs_fixups.c
@@ -0,0 +1,492 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_alloc.h"
+#include "xfs_trans.h"
+#include "xfs_fixups.h"
+#include "xfs_trace.h"
+
+/*
+ * v5 AGFL padding defects
+ *
+ * When the v5 format was first introduced, there was a defect in the struct
+ * xfs_agfl definition that resulted in the agfl length calculation formula
+ * returning different values depending on the compiler padding.  On a fs with
+ * 512-byte sectors, this meant that XFS_AGFL_SIZE was 119 on i386, but 118 on
+ * x64.  Commit 96f859d52bcb1 ("libxfs: pack the agfl header structure so
+ * XFS_AGFL_SIZE is correct") changed the definition to disable padding the
+ * end of the structure, and was accepted into Linux 4.5.  Since then, the
+ * AGFL has always used the larger size (e.g. 119 entries on a 512b sector
+ * fs).
+ *
+ * Unfortunately, pre-4.5 kernels can produce filesystems with AGFLs that wrap
+ * at the smaller size, and those kernels are not prepared to handle the
+ * longer size.  This typically manifests itself as an AGF verifier corruption
+ * error followed by a filesystem shutdown.  While we encourage admins to stay
+ * current with software, we would like to avoid this intermittent breakage.
+ *
+ * Any v5 filesystem which has a feature bit set for a feature that was
+ * introduced after Linux 4.5 will not have this problem, as such kernels
+ * cannot be mounted on older kernels.  v4 filesystems are also unaffected.
+ *
+ * Therefore, we add two fixup functions -- the first runs at mount time to
+ * detect a short-wrapped AGFL and fix it; the second runs at unmount, freeze,
+ * or remount-ro time to move a wrapped AGFL to the beginning of the list.
+ * This reduces the likelihood of a screwup to the scenario where you have (a)
+ * a filesystem with no post-4.5 features (reflink, rmap), (b) the AGFL wraps,
+ * (c) the filesystem goes down leaving a dirty log, and (d) the dirty
+ * filesystem is mounted on an old kernel.
+ *
+ * We prefer to fix this in the kernel at mount/unmount time instead of simply
+ * detecting the problem at mount time and ordering the administrator to run
+ * xfs_repair because not all the distros include xfs_repair in the initrd or
+ * the logic to call it (as opposed to "fsck -y") if the root fs fails to
+ * mount.  This means that if this wrapping problem hits a root filesystem
+ * then the administrator will have to reboot with a recovery iso and run
+ * xfs_repair from there.  That's going to generate a /lot/ of support work
+ * compared to us figuring out how to repair the filesystems automatically.
+ *
+ * To explain graphically exactly what this fixup does, let's pretend the AGFL
+ * block has space for 10 items.  It looks like this:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header |   |   |   |   |   |   |   |   |   |   |
+ *
+ * When the fs is freshly formatted or repaired, the AGFL will look like:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | A | B | C | D | E | F |   |   |   |   |
+ *          ^-- flfirst         ^-- fllast
+ *
+ * Scenario A: List Wraps Badly at Mount Time
+ *
+ * Due to the padding problems prior to 4.5 ("4.5 agfl padding fix"),
+ * XFS_AGFL_SIZE would return 10 on 32-bit systems and 9 on 64-bit systems.
+ * Therefore, if the AGFL wrapped on a 64-bit kernel we would end up with:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | D | E | F |   |   |   | A | B | C |   |
+ *                  ^-- fllast      ^-- flfirst
+ *
+ * Note that block 9's contents are undefined because we didn't write anything
+ * there.  Because the "4.5 agfl padding fix" corrected XFS_AGFL_SIZE to
+ * return 10 in all cases, this looks like an AGF corruption because flcount
+ * is 6 but the distance between flfirst and fllast is 7.  So long as the list
+ * wraps and the mismatch is exactly one block we can fix this by moving the
+ * whole list to the start of the block:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | A | B | C | D | E | F |   |   |   |   |
+ *          ^-- flfirst         ^-- fllast
+ *
+ * If the count is off by more than 1 then the AGF is truly corrupt and we
+ * bail out.
+ *
+ * Scenario B: List Wraps Incompatibly at Unmount Time
+ *
+ * Now let's say that we run for a while and want to unmount, but our AGFL
+ * wraps like this:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | T | U | V |   |   |   |   | Q | R | S |
+ *                  ^-- fllast          ^-- flfirst
+ *
+ * We don't know that the next kernel to mount this filesystem will have the
+ * "4.5 agfl padding fix" applied to it; if that kernel is a 64-bit kernel
+ * without the padding fix applied, it will flag the AGF as corrupted because
+ * flcount is 6 but in its view the distance between flfirst and fllast (which
+ * omits bno[9]) is 5.  We don't want unpatched kernels choke on that, so the
+ * unmount fixer moves the whole list to the start of the block:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | Q | R | S | T | U | V |   |   |   |   |
+ *          ^-- flfirst         ^-- fllast
+ *
+ * Since the AGFL no longer wraps at all, it doesn't matter if the next
+ * kernel to mount this filesystem has the "4.5 agfl padding fix" applied;
+ * all kernels can handle this correctly.
+ *
+ * Scenario C: List Hits the End at Unmount Time
+ *
+ * Now let's say that we run for a while and want to unmount, but our AGFL
+ * happens to stop right at the last block:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header |   |   |   |   | Q | R | S | T | U | V |
+ *                          ^-- flfirst         ^-- fllast
+ *
+ * This has the same problem as Scenario B, and the solution is the same:
+ * Move the whole list to the start of the block.
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header | Q | R | S | T | U | V |   |   |   |   |
+ *          ^-- flfirst         ^-- fllast
+ *
+ * Scenario D: Empty List Touches the End at Unmount Time
+ *
+ * Let's say that the list is empty but the pointers touch the end:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header |   |   |   |   |   |   |   |   |   |   |
+ *          ^ flfirst                           ^-- fllast
+ *
+ * Or:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header |   |   |   |   |   |   |   |   |   |   |
+ *                                 fllast --^   ^-- flfirst
+ *
+ * Then we simply move the pointers to the start of the block:
+ *
+ *          0   1   2   3   4   5   6   7   8   9
+ * Header |   |   |   |   |   |   |   |   |   |   |
+ * fllast --^   ^-- flfirst
+ *
+ * As a side note, if flcount == 0 (which is only the case for AGs that are
+ * either entirely out of space or have been freshly created by growfs), we
+ * simply reset the pointers to the start of the block.
+ */
+
+/*
+ * Decide if we need to have the agfl wrapping fixes applied.  This only
+ * affects v5 filesystems that do not have any features enabled that did not
+ * exist when the agfl padding fix went in.
+ *
+ * Features already present when the fix went in were finobt, ftype, spinodes.
+ * If we see something new (e.g. reflink) then don't bother.
+ */
+#define XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED \
+		(~(XFS_SB_FEAT_RO_COMPAT_FINOBT))
+#define XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED \
+		(~(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		   XFS_SB_FEAT_INCOMPAT_SPINODES))
+#define XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED \
+		(~0)
+static inline bool xfs_sb_version_needs_agfl_wrap_fixes(struct xfs_sb *sbp)
+{
+	return xfs_sb_version_hascrc(sbp) &&
+		!xfs_sb_has_incompat_feature(sbp,
+			XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED) &&
+		!xfs_sb_has_ro_compat_feature(sbp,
+			XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED) &&
+		!xfs_sb_has_incompat_log_feature(sbp,
+			XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED);
+}
+
+/* Copy the entire AGFL list into the memory buffer. */
+STATIC void
+xfs_fixup_freelist_copyin(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agfbp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agflbp,
+	__be32			*bnolist,
+	unsigned int		agfl_size)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agfbp);
+	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	unsigned int		flfirst;
+	unsigned int		fllast;
+
+	ASSERT(pag->pagf_flcount < agfl_size);
+
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/* Non wrapping list, easy. */
+	if (flfirst < fllast) {
+		memcpy(bnolist, &agfl_bno[flfirst],
+				pag->pagf_flcount * sizeof(__be32));
+		return;
+	}
+
+	/* Copy the first part: 0 to fllast */
+	memcpy(bnolist, agfl_bno, (fllast + 1) * sizeof(__be32));
+
+	/* Copy the second part: flfirst to agfl_size */
+	memcpy(&bnolist[fllast + 1], &agfl_bno[flfirst],
+			(agfl_size - flfirst) * sizeof(__be32));
+}
+
+/* Copy the list into memory and move it to the head. */
+STATIC int
+xfs_fixup_freelist_reset(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agfbp,
+	struct xfs_perag	*pag,
+	__be32			*bnolist,
+	unsigned int		agfl_size)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agfbp);
+	__be32			*agfl_bno;
+	struct xfs_buf		*agflbp;
+	unsigned int		copylen;
+	int			error;
+
+	trace_xfs_fixup_freelist_reset(mp, agno, be32_to_cpu(agf->agf_flfirst),
+			be32_to_cpu(agf->agf_fllast), pag->pagf_flcount);
+
+	/* Empty list, just move it to the start. */
+	if (pag->pagf_flcount == 0) {
+		agf->agf_flfirst = cpu_to_be32(1);
+		agf->agf_fllast = 0;
+		xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST);
+		return 0;
+	}
+
+	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
+	if (error)
+		return error;
+
+	/*
+	 * Load the agfl into the buffer and write it back at the start
+	 * of the block.
+	 */
+	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
+	copylen = pag->pagf_flcount * sizeof(__be32);
+	xfs_fixup_freelist_copyin(tp, agfbp, pag, agflbp, bnolist,
+			agfl_size);
+	memcpy(agfl_bno, bnolist, copylen);
+	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
+	xfs_trans_log_buf(tp, agflbp, 0, copylen);
+	xfs_trans_brelse(tp, agflbp);
+
+	agf->agf_flfirst = 0;
+	agf->agf_fllast = cpu_to_be32(pag->pagf_flcount - 1);
+	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST);
+
+	return 0;
+}
+
+/* Detect and fix Scenario A. */
+STATIC int
+xfs_fixup_freelist_wrap_mount(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agfbp,
+	struct xfs_perag	*pag,
+	void			*priv)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf;
+	xfs_agnumber_t		agno;
+	unsigned int		agfl_size;
+	unsigned int		bad_agfl_size;
+	unsigned int		flfirst;
+	unsigned int		fllast;
+	unsigned int		active;
+
+	agfl_size = xfs_agfl_size(mp);
+	bad_agfl_size = agfl_size - 1;
+	agf = XFS_BUF_TO_AGF(agfbp);
+	agno = be32_to_cpu(agf->agf_seqno);
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/* List doesn't wrap or is empty, no correction required. */
+	if (flfirst < fllast || pag->pagf_flcount == 0)
+		return 0;
+
+	/* Compare computed active item count to flcount. */
+	active = (fllast + 1) + (agfl_size - flfirst);
+	if (active == pag->pagf_flcount) {
+		/* Exactly the right size, we're done. */
+		return 0;
+	} else if (active != pag->pagf_flcount + 1) {
+		/*
+		 * If the distance between flfirst and fllast is greater than
+		 * flcount by more than 1, then there's more wrong with this
+		 * agfl than just the padding problem.  Bail out completely,
+		 * which will force the admin to run xfs_repair.
+		 */
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Bail out if either pointer goes off the end of the block, the
+	 * flcount is insane, or the agfl wasn't wrapped to start with.
+	 */
+	if (flfirst >= agfl_size - 1 || fllast >= agfl_size - 1 ||
+	    pag->pagf_flcount > agfl_size)
+		return -EFSCORRUPTED;
+
+	return xfs_fixup_freelist_reset(tp, agno, agfbp, pag, priv,
+			bad_agfl_size);
+}
+
+/* Detect and fix Scenario B - D. */
+STATIC int
+xfs_fixup_freelist_wrap_unmount(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agfbp,
+	struct xfs_perag	*pag,
+	void			*priv)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agf		*agf;
+	xfs_agnumber_t		agno;
+	uint32_t		agfl_size;
+	uint32_t		flfirst;
+	uint32_t		fllast;
+	int			error;
+
+	agfl_size = xfs_agfl_size(mp);
+	agf = XFS_BUF_TO_AGF(agfbp);
+	agno = be32_to_cpu(agf->agf_seqno);
+	flfirst = be32_to_cpu(agf->agf_flfirst);
+	fllast = be32_to_cpu(agf->agf_fllast);
+
+	/* Scenario D: empty list, but pointer touches the end. */
+	if (pag->pagf_flcount == 0) {
+		if (flfirst == agfl_size - 1 || fllast == agfl_size - 1)
+			return xfs_fixup_freelist_reset(tp, agno, agfbp, pag,
+					priv, agfl_size);
+		return 0;
+	}
+
+	/*
+	 * If the AGFL is completely full, fix_freelist to free up some space
+	 * in the list.
+	 */
+	if (pag->pagf_flcount == agfl_size) {
+		struct xfs_alloc_arg		args = {
+			.mp = mp,
+			.agno = agno,
+			.alignment = 1,
+			.pag = pag,
+			.tp = tp,
+		};
+
+		error = xfs_alloc_fix_freelist(&args, 0);
+		if (error)
+			return error;
+
+		/* The list should not still be full! */
+		if (pag->pagf_flcount == agfl_size) {
+			ASSERT(0);
+			return -EIO;
+		}
+	}
+
+	/*
+	 * If the list doesn't wrap and doesn't touch the last element, we're
+	 * done here.
+	 */
+	if (flfirst < fllast && fllast < agfl_size - 1)
+		return 0;
+
+	/*
+	 * Either the list wraps around the end (Scenario B) or the last
+	 * element touches the end (Scenario C).
+	 */
+	return xfs_fixup_freelist_reset(tp, agno, agfbp, pag, priv, agfl_size);
+}
+
+typedef int (*xfs_agf_apply_fn_t)(struct xfs_trans *tp, struct xfs_buf *agfbp,
+		struct xfs_perag *pag, void *priv);
+
+/* Apply something to every AGF. */
+STATIC int
+xfs_fixup_agf_apply(
+	struct xfs_mount	*mp,
+	xfs_agf_apply_fn_t	fn,
+	void			*priv)
+{
+	struct xfs_trans	*tp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agfbp;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0,
+			XFS_TRANS_NO_WRITECOUNT, &tp);
+	if (error)
+		return error;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agfbp);
+		if (error)
+			goto cancel;
+		if (!agfbp) {
+			error = -ENOMEM;
+			goto cancel;
+		}
+		pag = xfs_perag_get(mp, agno);
+		error = fn(tp, agfbp, pag, priv);
+		xfs_perag_put(pag);
+		xfs_trans_brelse(tp, agfbp);
+		if (error)
+			goto cancel;
+	}
+
+	return xfs_trans_commit(tp);
+cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/* Fix AGFL wrapping so we can use the filesystem. */
+int
+xfs_fixup_agfl_wrap_mount(
+	struct xfs_mount	*mp)
+{
+	__be32			*buf;
+	int			error;
+
+	if (!xfs_sb_version_needs_agfl_wrap_fixes(&mp->m_sb))
+		return 0;
+
+	buf = kmem_alloc(xfs_agfl_size(mp) * sizeof(__be32), KM_SLEEP);
+	if (!buf)
+		return -ENOMEM;
+
+	error = xfs_fixup_agf_apply(mp, xfs_fixup_freelist_wrap_mount, buf);
+	kmem_free(buf);
+	return error;
+}
+
+/* Fix AGFL wrapping so old kernels can use this filesystem. */
+int
+xfs_fixup_agfl_wrap_unmount(
+	struct xfs_mount	*mp)
+{
+	__be32			*buf;
+	int			error;
+
+	if (!xfs_sb_version_needs_agfl_wrap_fixes(&mp->m_sb))
+		return 0;
+
+	buf = kmem_alloc(xfs_agfl_size(mp) * sizeof(__be32), KM_SLEEP);
+	if (!buf)
+		return -ENOMEM;
+
+	error = xfs_fixup_agf_apply(mp, xfs_fixup_freelist_wrap_unmount, buf);
+	kmem_free(buf);
+	return error;
+}
diff --git a/fs/xfs/xfs_fixups.h b/fs/xfs/xfs_fixups.h
new file mode 100644
index 0000000..fb52a96
--- /dev/null
+++ b/fs/xfs/xfs_fixups.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
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
+#ifndef	__XFS_FIXUPS_H__
+#define	__XFS_FIXUPS_H__
+
+int xfs_fixup_agfl_wrap_mount(struct xfs_mount *mp);
+int xfs_fixup_agfl_wrap_unmount(struct xfs_mount *mp);
+
+#endif /* __XFS_FIXUPS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 98fd41c..eb284aa 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -46,7 +46,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_extent_busy.h"
-
+#include "xfs_fixups.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -875,6 +875,16 @@ xfs_mountfs(
 	}
 
 	/*
+	 * Make sure our AGFL counters do not wrap the end of the block
+	 * in a troublesome manner.
+	 */
+	error = xfs_fixup_agfl_wrap_mount(mp);
+	if (error) {
+		xfs_warn(mp, "Failed to fix agfl wrapping.  Run xfs_repair.");
+		goto out_log_dealloc;
+	}
+
+	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
 	 */
@@ -1128,6 +1138,15 @@ xfs_unmountfs(
 	xfs_qm_unmount(mp);
 
 	/*
+	 * Make sure our AGFL counters do not wrap the end of the block
+	 * in a troublesome manner for old kernels.
+	 */
+	error = xfs_fixup_agfl_wrap_unmount(mp);
+	if (error)
+		xfs_warn(mp, "Unable to fix agfl wrapping.  "
+				"This may cause problems on next mount.");
+
+	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
 	 * lazy superblock counting because it trusts the incore superblock
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 624a802..d9aa39a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -50,6 +50,7 @@
 #include "xfs_refcount_item.h"
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
+#include "xfs_fixups.h"
 
 #include <linux/namei.h>
 #include <linux/dax.h>
@@ -1206,6 +1207,15 @@ xfs_quiesce_attr(
 	xfs_reclaim_inodes(mp, 0);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
+	/*
+	 * Make sure our AGFL counters do not wrap the end of the block
+	 * in a troublesome manner for old kernels.
+	 */
+	error = xfs_fixup_agfl_wrap_unmount(mp);
+	if (error)
+		xfs_warn(mp, "Unable to fix agfl wrapping.  "
+				"This may cause problems on next mount.");
+
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp);
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 945de08..d83d079 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3339,6 +3339,31 @@ TRACE_EVENT(xfs_trans_resv_calc,
 		  __entry->logflags)
 );
 
+TRACE_EVENT(xfs_fixup_freelist_reset,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 unsigned int flfirst, unsigned int fllast,
+		 unsigned int flcount),
+	TP_ARGS(mp, agno, flfirst, fllast, flcount),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, flfirst)
+		__field(unsigned int, fllast)
+		__field(unsigned int, flcount)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->flfirst = flfirst;
+		__entry->fllast = fllast;
+		__entry->flcount = flcount;
+	),
+	TP_printk("dev %d:%d agno %u flfirst %u fllast %u flcount %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno, __entry->flfirst, __entry->fllast,
+		  __entry->flcount)
+);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
