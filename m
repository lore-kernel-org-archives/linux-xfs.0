Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF0EC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RB/x1Wck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D19DC433C7;
	Sun, 31 Dec 2023 23:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065204;
	bh=wCD+bY2tQEdS1dbBGmWTQKn0N9dtpF1OtNSNdi3+ErE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RB/x1Wck8LstDoYNtFXrszK91fyA+DCOcqY9jxIyw/DFPuUOJtS85yFH4pZDRVoPJ
	 vcJGK5dPsv7UCPdEV6bJ0PH/vk+VYOB0gue2JWpHN/2SmRc56yjnqrIm2Yg6TZzX+j
	 L+atRbNByCgl62CN4pi5EE3FmCwpk27zCViaoBWeWiNP5lO8cKr85Ihsmn+XnNulpS
	 uJ+782ho7Id/eb1vCSVmE2fW+siIyLCFi/zCKbDsS7nlvxbdW0dx8+AOnXQegiJ/IB
	 bG+olJmCfJuum4Tmr1nuoxk3Xylc4vN7OC0ZBJL4c1yvihey4sD0OL1CBfsPOshF/p
	 dxeMgvptLPUnQ==
Date: Sun, 31 Dec 2023 15:26:43 -0800
Subject: [PATCH 17/28] xfs: hoist xfs_iunlink to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009404.1808635.2366403959645245295.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Move xfs_iunlink and xfs_iunlink_remove to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_inode.h     |    1 
 include/xfs_trace.h     |    7 +
 libxfs/Makefile         |    2 
 libxfs/inode.c          |    2 
 libxfs/iunlink.c        |  163 +++++++++++++++++++++++++++
 libxfs/iunlink.h        |   24 ++++
 libxfs/libxfs_priv.h    |   28 +++++
 libxfs/xfs_inode_util.c |  281 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_inode_util.h |    4 +
 9 files changed, 512 insertions(+)
 create mode 100644 libxfs/iunlink.c
 create mode 100644 libxfs/iunlink.h


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 2af5f79e31e..a48cb7eaf77 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -228,6 +228,7 @@ typedef struct xfs_inode {
 
 	/* unlinked list pointers */
 	xfs_agino_t		i_next_unlinked;
+	xfs_agino_t		i_prev_unlinked;
 
 	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
 	unsigned int		i_cformat;	/* format of cow fork */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a8f3ecac7f6..7dcf88b7900 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -360,4 +360,11 @@
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
 
+#define trace_xfs_iunlink_update_bucket(...)	((void) 0)
+#define trace_xfs_iunlink_update_dinode(...)	((void) 0)
+#define trace_xfs_iunlink(...)			((void) 0)
+#define trace_xfs_iunlink_reload_next(...)	((void) 0)
+#define trace_xfs_iunlink_remove(...)		((void) 0)
+#define trace_xfs_iunlink_map_prev_fallback(...)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a251322d0f6..26781ceb913 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -25,6 +25,7 @@ HFILES = \
 	libxfs_io.h \
 	libxfs_api_defs.h \
 	init.h \
+	iunlink.h \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
@@ -70,6 +71,7 @@ CFILES = cache.c \
 	defer_item.c \
 	init.c \
 	inode.c \
+	iunlink.c \
 	kmem.c \
 	logitem.c \
 	rdwr.c \
diff --git a/libxfs/inode.c b/libxfs/inode.c
index ec005bbbf5e..73eecebae96 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -193,6 +193,8 @@ libxfs_iget(
 	ip->i_mount = mp;
 	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = NULLAGINO;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
new file mode 100644
index 00000000000..6d055453599
--- /dev/null
+++ b/libxfs/iunlink.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020-2022, Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "libxfs_priv.h"
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
+#include "xfs_ag.h"
+#include "iunlink.h"
+#include "xfs_trace.h"
+
+/* in memory log item structure */
+struct xfs_iunlink_item {
+	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		old_agino;
+};
+
+/*
+ * Look up the inode cluster buffer and log the on-disk unlinked inode change
+ * we need to make.
+ */
+static int
+xfs_iunlink_log_dinode(
+	struct xfs_trans	*tp,
+	struct xfs_iunlink_item	*iup)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip = iup->ip;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*ibp;
+	int			offset;
+	int			error;
+
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	if (error)
+		return error;
+	/*
+	 * Don't log the unlinked field on stale buffers as this may be the
+	 * transaction that frees the inode cluster and relogging the buffer
+	 * here will incorrectly remove the stale state.
+	 */
+	if (ibp->b_flags & LIBXFS_B_STALE)
+		goto out;
+
+	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
+
+	/* Make sure the old pointer isn't garbage. */
+	if (be32_to_cpu(dip->di_next_unlinked) != iup->old_agino) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
+			XFS_INO_TO_AGINO(mp, ip->i_ino),
+			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
+
+	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
+	offset = ip->i_imap.im_boffset +
+			offsetof(struct xfs_dinode, di_next_unlinked);
+
+	xfs_dinode_calc_crc(mp, dip);
+	xfs_trans_inode_buf(tp, ibp);
+	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+out:
+	xfs_trans_brelse(tp, ibp);
+	return error;
+}
+
+/*
+ * Initialize the inode log item for a newly allocated (in-core) inode.
+ *
+ * Inode extents can only reside within an AG. Hence specify the starting
+ * block for the inode chunk by offset within an AG as well as the
+ * length of the allocated extent.
+ *
+ * This joins the item to the transaction and marks it dirty so
+ * that we don't need a separate call to do this, nor does the
+ * caller need to know anything about the iunlink item.
+ */
+int
+xfs_iunlink_log_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_iunlink_item	iup = {
+		.ip		= ip,
+		.pag		= pag,
+		.next_agino	= next_agino,
+		.old_agino	= ip->i_next_unlinked,
+	};
+
+	ASSERT(xfs_verify_agino_or_null(pag, next_agino));
+	ASSERT(xfs_verify_agino_or_null(pag, ip->i_next_unlinked));
+
+	/*
+	 * Since we're updating a linked list, we should never find that the
+	 * current pointer is the same as the new value, unless we're
+	 * terminating the list.
+	 */
+	if (ip->i_next_unlinked == next_agino) {
+		if (next_agino != NULLAGINO)
+			return -EFSCORRUPTED;
+		return 0;
+	}
+
+	return xfs_iunlink_log_dinode(tp, &iup);
+}
+
+/*
+ * Load the inode @next_agino into the cache and set its prev_unlinked pointer
+ * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
+ * to the unlinked list.
+ */
+int
+xfs_iunlink_reload_next(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agibp,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_perag	*pag = agibp->b_pag;
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode	*next_ip = NULL;
+	xfs_ino_t		ino;
+	int			error;
+
+	ASSERT(next_agino != NULLAGINO);
+
+	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
+	error = libxfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, &next_ip);
+	if (error)
+		return error;
+
+	/* If this is not an unlinked inode, something is very wrong. */
+	if (VFS_I(next_ip)->i_nlink != 0) {
+		error = -EFSCORRUPTED;
+		goto rele;
+	}
+
+	next_ip->i_prev_unlinked = prev_agino;
+	trace_xfs_iunlink_reload_next(next_ip);
+rele:
+	xfs_irele(next_ip);
+	return error;
+}
diff --git a/libxfs/iunlink.h b/libxfs/iunlink.h
new file mode 100644
index 00000000000..8d8032cf932
--- /dev/null
+++ b/libxfs/iunlink.h
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2020-2022, Red Hat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef XFS_IUNLINK_ITEM_H
+#define XFS_IUNLINK_ITEM_H	1
+
+struct xfs_trans;
+struct xfs_inode;
+struct xfs_perag;
+
+static inline struct xfs_inode *
+xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino)
+{
+	return NULL;
+}
+
+int xfs_iunlink_log_inode(struct xfs_trans *tp, struct xfs_inode *ip,
+			struct xfs_perag *pag, xfs_agino_t next_agino);
+int xfs_iunlink_reload_next(struct xfs_trans *tp, struct xfs_buf *agibp,
+		xfs_agino_t prev_agino, xfs_agino_t next_agino);
+
+#endif	/* XFS_IUNLINK_ITEM_H */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 8faf63a8a67..a457e127d8a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -473,6 +473,8 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_new_ag(ip,ag)		(0)
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
+#define xfs_trans_inode_buf(tp, bp)		((void) 0)
+
 /* quota bits */
 #define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
@@ -595,6 +597,32 @@ unsigned int hweight64(__u64 w);
 static inline int xfs_iunlink_init(struct xfs_perag *pag) { return 0; }
 static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
 
+static inline xfs_agino_t
+xfs_iunlink_lookup_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	return NULLAGINO;
+}
+
+static inline int
+xfs_iunlink_add_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		this_agino)
+{
+	return 0;
+}
+
+static inline int
+xfs_iunlink_change_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino,
+	xfs_agino_t		next_unlinked)
+{
+	return 0;
+}
+
 xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *mp,
 		xfs_agnumber_t agcount);
 
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 184da10db71..a51d0342b98 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -17,6 +17,9 @@
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
 #include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "xfs_ag.h"
+#include "iunlink.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -334,3 +337,281 @@ xfs_inode_init(
 
 	xfs_trans_log_inode(tp, ip, flags);
 }
+
+/*
+ * In-Core Unlinked List Lookups
+ * =============================
+ *
+ * Every inode is supposed to be reachable from some other piece of metadata
+ * with the exception of the root directory.  Inodes with a connection to a
+ * file descriptor but not linked from anywhere in the on-disk directory tree
+ * are collectively known as unlinked inodes, though the filesystem itself
+ * maintains links to these inodes so that on-disk metadata are consistent.
+ *
+ * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
+ * header contains a number of buckets that point to an inode, and each inode
+ * record has a pointer to the next inode in the hash chain.  This
+ * singly-linked list causes scaling problems in the iunlink remove function
+ * because we must walk that list to find the inode that points to the inode
+ * being removed from the unlinked hash bucket list.
+ *
+ * Hence we keep an in-memory double linked list to link each inode on an
+ * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
+ * based lists would require having 64 list heads in the perag, one for each
+ * list. This is expensive in terms of memory (think millions of AGs) and cache
+ * misses on lookups. Instead, use the fact that inodes on the unlinked list
+ * must be referenced at the VFS level to keep them on the list and hence we
+ * have an existence guarantee for inodes on the unlinked list.
+ *
+ * Given we have an existence guarantee, we can use lockless inode cache lookups
+ * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
+ * for the double linked unlinked list, and we don't need any extra locking to
+ * keep the list safe as all manipulations are done under the AGI buffer lock.
+ * Keeping the list up to date does not require memory allocation, just finding
+ * the XFS inode and updating the next/prev unlinked list aginos.
+ */
+
+/*
+ * Update the prev pointer of the next agino.  Returns -ENOLINK if the inode
+ * is not in cache.
+ */
+static int
+xfs_iunlink_update_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_inode	*ip;
+
+	/* No update necessary if we are at the end of the list. */
+	if (next_agino == NULLAGINO)
+		return 0;
+
+	ip = xfs_iunlink_lookup(pag, next_agino);
+	if (!ip)
+		return -ENOLINK;
+
+	ip->i_prev_unlinked = prev_agino;
+	return 0;
+}
+
+/*
+ * Point the AGI unlinked bucket at an inode and log the results.  The caller
+ * is responsible for validating the old value.
+ */
+STATIC int
+xfs_iunlink_update_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	unsigned int		bucket_index,
+	xfs_agino_t		new_agino)
+{
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		old_value;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
+
+	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
+			old_value, new_agino);
+
+	/*
+	 * We should never find the head of the list already set to the value
+	 * passed in because either we're adding or removing ourselves from the
+	 * head of the list.
+	 */
+	if (old_value == new_agino) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
+	offset = offsetof(struct xfs_agi, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+}
+
+static int
+xfs_iunlink_insert_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the pointer isn't garbage and that this inode
+	 * isn't already on the list.
+	 */
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (next_agino == agino ||
+	    !xfs_verify_agino_or_null(pag, next_agino)) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Update the prev pointer in the next inode to point back to this
+	 * inode.
+	 */
+	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
+	if (error)
+		return error;
+
+	if (next_agino != NULLAGINO) {
+		/*
+		 * There is already another inode in the bucket, so point this
+		 * inode to the current head of the list.
+		 */
+		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
+		if (error)
+			return error;
+		ip->i_next_unlinked = next_agino;
+	}
+
+	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
+	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+}
+
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agibp;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, &agibp);
+	if (error)
+		goto out;
+
+	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
+static int
+xfs_iunlink_remove_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		head_agino;
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the head pointer isn't garbage.
+	 */
+	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(pag, head_agino)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Set our inode's next_unlinked pointer to NULL and then return
+	 * the old pointer value so that we can update whatever was previous
+	 * to us in the list to point to whatever was next in the list.
+	 */
+	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
+	if (error)
+		return error;
+
+	/*
+	 * Update the prev pointer in the next inode to point back to previous
+	 * inode in the chain.
+	 */
+	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
+			ip->i_next_unlinked);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
+				ip->i_next_unlinked);
+	if (error)
+		return error;
+
+	if (head_agino != agino) {
+		struct xfs_inode	*prev_ip;
+
+		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
+		if (!prev_ip) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
+				ip->i_next_unlinked);
+		prev_ip->i_next_unlinked = ip->i_next_unlinked;
+	} else {
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
+				ip->i_next_unlinked);
+	}
+
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
+	return error;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_buf		*agibp;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
+}
diff --git a/libxfs/xfs_inode_util.h b/libxfs/xfs_inode_util.h
index 54d96e1aa9e..0406401d21b 100644
--- a/libxfs/xfs_inode_util.h
+++ b/libxfs/xfs_inode_util.h
@@ -57,4 +57,8 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */

