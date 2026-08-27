Received: from proxima.stupidest.org (proxima.stupidest.org [35.163.12.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ED53C1F54
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.163.12.83
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788112176; cv=none; b=X6EgTfpdrzxZNEs+aaieh2SMtu0/bSZWri10S/LVIExtGaYH8c9qNYBkP10k/tYbPdzEL3uWt0gPoWKrihapnQro45hLkx4BHlGaokY/1Ge3FG+TTQdz9ribOe6BeaO4/nyKK4mqaAugF0Qb5Fk83lNxd1eY7V6Kxhzelt37lDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788112176; c=relaxed/simple;
	bh=4NhM46l8Bg4hfy/6YC6lzU2AX1UqA1VMtBbkglxveu4=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject; b=bku8ibEGHpX8huiyDQoc/1vBJyQIR4lZPzFhnl3WQ84lg5XAU1wtRtYAkmnjJui6sNcNO8NrUinxWlNCRXIPfDW0zB0JB9Ux40MxHoQ79MIIZ2Qxd9ttLrsadhCAX/ZCXEZ//eCBIIzLXEVSY1axneBQ/TJq7dtFrmbL/q2ooUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org; spf=pass smtp.mailfrom=f00f.org; dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b=RpNleC17; arc=none smtp.client-ip=35.163.12.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=f00f.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=f00f.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=f00f.org header.i=@f00f.org header.b="RpNleC17"
Received: from aether.stupidest.org (unknown [10.0.1.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by proxima.stupidest.org (Postfix) with ESMTPS id 4hY04Z68gGz6lh
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=f00f.org; s=m2016a;
	t=1788112174; bh=ZZhnZx0w7ITvFhPV+7YfHDCMBExjBm9CZ3JCjsqlo/s=;
	h=To:Message-ID:In-Reply-To:References:From:Date:Subject;
	b=RpNleC17vRFbKmApchwaUdVYp7tOVB+oFuuka/Y4l3n0fropJAS0hrT/lYRKl1t4R
	 mWFHIKu4oeTpjqlaNLDl3iUhVWWVLOuA4PrRzBcVb4VNpSKB82DPxGfwfCn0sPEXwc
	 n19uuWEzFhgDKDzavMqMh8nKV6YE6wKgjw1iwO/KSSUGJfHb3ySlSJI0ujivvNS3Hj
	 GkslGzIV6keyLUFJ228cv8BRNUK/QRY8wYf49XIFnYOuv77hk2TtiMTAm6ckomZgcg
	 254xq+OMbsjyCNDqu0rPWzoXHRSkYvQX9Hr0YXWtYWX3UbOe+ExXTZpvcqfY2GQPvg
	 63EyJtaMqO9fQ==
Received: from stupidest.org (unknown [172.31.255.110])
	by aether.stupidest.org (Postfix) with SMTP id 4hY04Y2QN1z9KVLH
	for <linux-xfs@vger.kernel.org>; Sun, 30 Aug 2026 10:49:33 -0700 (PDT)
Received: by stupidest.org (sSMTP sendmail emulation); Sun, 30 Aug 2026 10:49:33 -0700
To: linux-xfs@vger.kernel.org
Message-ID: <f779978814dd39ccf58cadbf176418dbc638d473.1788110147.git.cw@f00f.org>
In-Reply-To: <cover.1788110147.git.cw@f00f.org>
References: <cover.1788110147.git.cw@f00f.org>
From: Chris Wedgwood <cw@f00f.org>
Date: Wed, 26 Aug 2026 22:48:03 -0700
Subject: [PATCH 9/9] xfs_repair: finish deletions the crash interrupted
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

A file unlinked while still open goes on the AGI unlinked list, and the
deletion completes when the last reference is dropped.  A crash in
between leaves it there: no name, no links, but its blocks are still
allocated and its inode record still in use.

The kernel finishes those deletions during recovery.  -R did not, so
repair found the inodes unreferenced afterwards and moved them to
lost+found - which is not merely untidy, it resurrects files the user
had deleted, readable by anyone who can read the filesystem.

Do the work.  The kernel drives it through xfs_irele() and the inodegc
workers, ending in xfs_inactive() in fs/xfs/xfs_inode.c, which is
written against the VFS inode lifecycle and does not build here.  What
it does for an unlinked inode is small, though, and both halves already
exist in libxfs: xfs_bunmapi_range() releases the blocks and
xfs_inode_uninit() frees the inode and takes it off the list.  So walk
the unlinked lists explicitly once recovery has finished.

Explicit rather than hooked into xfs_irele(), because inodes are
released during recovery for reasons that have nothing to do with
deletion, and this way the work happens at a point where the filesystem
is consistent and the log has not yet been retired.

The four-image corpus now matches kernel recovery exactly, where before
two of the four differed:

  unlinked:  icount 64 ifree 22 fdblocks 245419   (kernel: identical)
  intents2:  matches

Before this patch that filesystem reported ifree 9 and moved twelve
inodes to lost+found.
---
 include/xfs_mount.h   |   1 +
 libxfs/Makefile       |   1 +
 libxfs/inactive.c     | 181 ++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_repair.8 |  11 ---
 repair/phase2.c       |  17 ++++
 5 files changed, 200 insertions(+), 11 deletions(-)
 create mode 100644 libxfs/inactive.c

diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8d18f2d9..936db6c7 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -405,6 +405,7 @@ void libxfs_compute_all_maxlevels(struct xfs_mount *mp);
 struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
 		struct libxfs_init *xi, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
+int libxfs_inactive_unlinked(struct xfs_mount *mp, unsigned int *freed);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1ca6ad82..57135d6e 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -79,6 +79,7 @@ HFILES = \
 vpath %.c $(TOPDIR)/libxlog
 
 CFILES = buf_mem.c \
+	inactive.c \
 	xfs_bmap_item.c \
 	xfs_buf_item_recover.c \
 	xfs_attr_item.c \
diff --git a/libxfs/inactive.c b/libxfs/inactive.c
new file mode 100644
index 00000000..6bce5a1e
--- /dev/null
+++ b/libxfs/inactive.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Finish deleting inodes that a crash left on the AGI unlinked lists.
+ *
+ * When a file is unlinked while it is still open, XFS puts it on the AGI
+ * unlinked list and completes the deletion when the last reference goes away.
+ * A crash in between leaves the inode on that list: it has no name, its link
+ * count is zero, but its blocks are still allocated and the inode record is
+ * still in use.
+ *
+ * The kernel finishes those deletions during log recovery.  xlog_recover_
+ * iunlink_bucket() walks each list, and the xfs_irele() at the end of each
+ * iteration drops the last reference, which queues the inode to the percpu
+ * inodegc workers; xfs_inodegc_flush() then waits for them.  The work itself
+ * is xfs_inactive(), in fs/xfs/xfs_inode.c.
+ *
+ * Userspace has no inodegc, and fs/xfs/xfs_inode.c does not build here - it is
+ * written against the VFS inode lifecycle.  What it does for an unlinked inode
+ * is small, though, and both halves of it already exist in libxfs:
+ * xfs_bunmapi_range() to release the blocks and xfs_inode_uninit() to free the
+ * inode and take it off the unlinked list.  So do the walk explicitly once
+ * recovery has finished, rather than emulating the queue.
+ *
+ * Being explicit rather than hooking xfs_irele() also keeps this out of the
+ * recovery paths themselves, where an inode can be released for reasons that
+ * have nothing to do with deletion.
+ */
+
+#include "xfs_platform.h"
+#include "libxfs.h"
+#include "libxfs_io.h"
+#include "init.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_ialloc.h"
+#include "xfs_inode_util.h"
+#include "xfs_ag.h"
+#include "xfs_inode_fork.h"
+#include "xfs_trans_space.h"
+
+/*
+ * Release every block the inode owns, then free the inode itself.  This is
+ * xfs_inactive() reduced to the case that matters here: an inode with no
+ * links, which is therefore going away entirely.
+ */
+static int
+xfs_inactive_one(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_trans	*tp;
+	struct xfs_perag	*pag;
+	struct xfs_icluster	xic = { 0 };
+	int			error;
+
+	error = -xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
+			XFS_IFREE_SPACE_RES(mp), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(tp, ip, 0);
+
+	/*
+	 * Symlinks short enough to live in the inode, and directories in short
+	 * form, own no blocks; anything else has extents to release.  Attr
+	 * forks are handled the same way.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_EXTENTS ||
+	    ip->i_df.if_format == XFS_DINODE_FMT_BTREE) {
+		error = -xfs_bunmapi_range(&tp, ip, 0, 0, XFS_MAX_FILEOFF);
+		if (error)
+			goto out_cancel;
+	}
+
+	if (xfs_inode_has_attr_fork(ip) &&
+	    (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS ||
+	     ip->i_af.if_format == XFS_DINODE_FMT_BTREE)) {
+		error = -xfs_bunmapi_range(&tp, ip, XFS_BMAPI_ATTRFORK, 0,
+				XFS_MAX_FILEOFF);
+		if (error)
+			goto out_cancel;
+	}
+
+	ip->i_disk_size = 0;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	error = -xfs_inode_uninit(tp, pag, ip, &xic);
+	xfs_perag_put(pag);
+	if (error)
+		goto out_cancel;
+
+	return -xfs_trans_commit(tp);
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+/*
+ * Walk one AG's unlinked buckets, deleting what is on them.
+ *
+ * Each inode is re-read from the AGI every time round because freeing one
+ * rewrites the list it was on.
+ */
+static int
+xfs_inactive_ag(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	unsigned int		*freed)
+{
+	struct xfs_perag	*pag = xfs_perag_get(mp, agno);
+	int			bucket;
+	int			error = 0;
+
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+		for (;;) {
+			struct xfs_buf	*agibp;
+			struct xfs_agi	*agi;
+			struct xfs_inode *ip;
+			xfs_agino_t	agino;
+
+			error = -xfs_read_agi(pag, NULL, 0, &agibp);
+			if (error)
+				goto out;
+
+			agi = agibp->b_addr;
+			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+			xfs_buf_relse(agibp);
+
+			if (agino == NULLAGINO)
+				break;
+
+			error = -libxfs_iget(mp, NULL,
+					XFS_AGINO_TO_INO(mp, agno, agino), 0,
+					&ip);
+			if (error)
+				goto out;
+
+			error = xfs_inactive_one(mp, ip);
+			xfs_irele(ip);
+			if (error)
+				goto out;
+
+			(*freed)++;
+		}
+	}
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
+/*
+ * Finish every deletion the crash interrupted.  Returns the number of inodes
+ * freed so the caller can say what it did.
+ */
+int
+libxfs_inactive_unlinked(
+	struct xfs_mount	*mp,
+	unsigned int		*freed)
+{
+	xfs_agnumber_t		agno;
+	int			error;
+
+	*freed = 0;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xfs_inactive_ag(mp, agno, freed);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index c2888277..3fd1691e 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -605,17 +605,6 @@ would apply them twice.  In that case use
 .B \-L
 to discard the log and repair without it.
 .PP
-There is a difference between
-.B \-R
-and kernel recovery.  A file that was deleted, but whose deletion had not
-finished when the system crashed, is left on the filesystem's unlinked list.
-The kernel finishes the deletion; replay in userspace does not, so repair
-finds the file unreferenced and moves it to
-.IR lost+found .
-The filesystem is consistent either way, but a
-.B \-R
-run can leave files there that a mount and unmount would have removed.
-.PP
 As a last resort the log can be erased by running
 .B xfs_repair
 with the -L option.
diff --git a/repair/phase2.c b/repair/phase2.c
index 49928f78..34361090 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -46,6 +46,7 @@ replay_dirty_log(
 {
 	int			error;
 	uint32_t		new_cycle;
+	unsigned int		inactivated;
 
 	/*
 	 * libxlog's header_check_uuid() does not refuse a log whose UUID does
@@ -165,6 +166,22 @@ replay_dirty_log(
 		do_error(
 	_("Log recovery failed and the log was shut down.\n"));
 
+	/*
+	 * A crash can leave inodes that were unlinked but not yet deleted on
+	 * the AGI unlinked lists.  The kernel finishes those deletions as part
+	 * of recovery; do the same, or repair finds them unreferenced later and
+	 * moves them to lost+found, resurrecting files the user deleted.
+	 */
+	error = -libxfs_inactive_unlinked(mp, &inactivated);
+	if (error)
+		do_error(
+	_("Failed to delete inodes left unlinked by the crash: %s\n"),
+			 strerror(error));
+	if (inactivated)
+		do_log(
+	_("        - completed deletion of %u unlinked inode%s\n"),
+			inactivated, inactivated == 1 ? "" : "s");
+
 	libxfs_buf_lock(mp->m_sb_bp);
 	libxfs_buf_relse(mp->m_sb_bp);
 	mp->m_sb_bp = NULL;
-- 
2.47.3

