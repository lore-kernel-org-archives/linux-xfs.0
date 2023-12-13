Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE704BA49
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKyLzmfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F62C433C7;
	Wed, 13 Dec 2023 22:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508262;
	bh=59mMuz11Mvfm37NNlfw7cfImtLCZUiVQM1bLEurURWs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CKyLzmfYmE/74T32A3EfnuEX6gsKZWD0iWeIUyDgfwoB8k8v5FZBCfwi+Xx4SfRL8
	 e4TEVBXkSFAqq0j+JVpM1CNl2hyiPBLi/y4hOlPFt6esS9JOsxQf5xCk4LNAiXL1W2
	 VCFXR4hSpD+ktaH0bJEroDo8gJJPG7HMISFePm+k9DZMPIz8MYlLwmEviMLdqUzSxJ
	 HiT5ii2Aq9nr+oZ8haa4KoUyKfLS5QdwQXu/y4S2lxUfvi/cu+FARu1JzBphhM47AP
	 B1y25zH84lE0UeW/uTvttAsXHhrJYf9S2kiAvSIEveJIJVH5VeACoHmhBHhMSTVnMe
	 yTfkgnzyVVbHA==
Date: Wed, 13 Dec 2023 14:57:42 -0800
Subject: [PATCH 3/4] xfs: improve dquot iteration for scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250784386.1399626.10050309418047002549.stgit@frogsfrogsfrogs>
In-Reply-To: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
References: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
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

Upon a closer inspection of the quota record scrubber, I noticed that
dqiterate wasn't actually walking all possible dquots for the mapped
blocks in the quota file.  This is due to xfs_qm_dqget_next skipping all
XFS_IS_DQUOT_UNINITIALIZED dquots.

For a fsck program, we really want to look at all the dquots, even if
all counters and limits in the dquot record are zero.  Rewrite the
implementation to do this, as well as switching to an iterator paradigm
to reduce the number of indirect calls.

This enables removal of the old broken dqiterate code from xfs_dquot.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile            |    5 +
 fs/xfs/libxfs/xfs_format.h |    3 +
 fs/xfs/scrub/dqiterate.c   |  211 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/quota.c       |   25 +++--
 fs/xfs/scrub/quota.h       |   34 +++++++
 fs/xfs/scrub/trace.c       |    2 
 fs/xfs/scrub/trace.h       |   49 ++++++++++
 fs/xfs/xfs_dquot.c         |   31 ------
 fs/xfs/xfs_dquot.h         |    5 -
 9 files changed, 319 insertions(+), 46 deletions(-)
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/quota.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e7727451d1c8..cdf81eb180e2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -176,7 +176,10 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   rtsummary.o \
 				   )
 
-xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
+xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
+				   dqiterate.o \
+				   quota.o \
+				   )
 
 # online repair
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index f16974126ff9..e6ca188e2271 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1272,6 +1272,9 @@ static inline time64_t xfs_dq_bigtime_to_unix(uint32_t ondisk_seconds)
 #define XFS_DQ_GRACE_MIN		((int64_t)0)
 #define XFS_DQ_GRACE_MAX		((int64_t)U32_MAX)
 
+/* Maximum id value for a quota record */
+#define XFS_DQ_ID_MAX			(U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on
diff --git a/fs/xfs/scrub/dqiterate.c b/fs/xfs/scrub/dqiterate.c
new file mode 100644
index 000000000000..20c4daedd48d
--- /dev/null
+++ b/fs/xfs/scrub/dqiterate.c
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_bit.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_qm.h"
+#include "xfs_bmap.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/quota.h"
+#include "scrub/trace.h"
+
+/* Initialize a dquot iteration cursor. */
+void
+xchk_dqiter_init(
+	struct xchk_dqiter	*cursor,
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		dqtype)
+{
+	cursor->sc = sc;
+	cursor->bmap.br_startoff = NULLFILEOFF;
+	cursor->dqtype = dqtype & XFS_DQTYPE_REC_MASK;
+	cursor->quota_ip = xfs_quota_inode(sc->mp, cursor->dqtype);
+	cursor->id = 0;
+}
+
+/*
+ * Ensure that the cached data fork mapping for the dqiter cursor is fresh and
+ * covers the dquot pointed to by the scan cursor.
+ */
+STATIC int
+xchk_dquot_iter_revalidate_bmap(
+	struct xchk_dqiter	*cursor)
+{
+	struct xfs_quotainfo	*qi = cursor->sc->mp->m_quotainfo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(cursor->quota_ip,
+								XFS_DATA_FORK);
+	xfs_fileoff_t		fileoff;
+	xfs_dqid_t		this_id = cursor->id;
+	int			nmaps = 1;
+	int			error;
+
+	fileoff = this_id / qi->qi_dqperchunk;
+
+	/*
+	 * If we have a mapping for cursor->id and it's still fresh, there's
+	 * no need to reread the bmbt.
+	 */
+	if (cursor->bmap.br_startoff != NULLFILEOFF &&
+	    cursor->if_seq == ifp->if_seq &&
+	    cursor->bmap.br_startoff + cursor->bmap.br_blockcount > fileoff)
+		return 0;
+
+	/* Look up the data fork mapping for the dquot id of interest. */
+	error = xfs_bmapi_read(cursor->quota_ip, fileoff,
+			XFS_MAX_FILEOFF - fileoff, &cursor->bmap, &nmaps, 0);
+	if (error)
+		return error;
+	if (!nmaps) {
+		ASSERT(nmaps > 0);
+		return -EFSCORRUPTED;
+	}
+	if (cursor->bmap.br_startoff > fileoff) {
+		ASSERT(cursor->bmap.br_startoff == fileoff);
+		return -EFSCORRUPTED;
+	}
+
+	cursor->if_seq = ifp->if_seq;
+	trace_xchk_dquot_iter_revalidate_bmap(cursor, cursor->id);
+	return 0;
+}
+
+/* Advance the dqiter cursor to the next non-sparse region of the quota file. */
+STATIC int
+xchk_dquot_iter_advance_bmap(
+	struct xchk_dqiter	*cursor,
+	uint64_t		*next_ondisk_id)
+{
+	struct xfs_quotainfo	*qi = cursor->sc->mp->m_quotainfo;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(cursor->quota_ip,
+								XFS_DATA_FORK);
+	xfs_fileoff_t		fileoff;
+	uint64_t		next_id;
+	int			nmaps = 1;
+	int			error;
+
+	/* Find the dquot id for the next non-hole mapping. */
+	do {
+		fileoff = cursor->bmap.br_startoff + cursor->bmap.br_blockcount;
+		if (fileoff > XFS_DQ_ID_MAX / qi->qi_dqperchunk) {
+			/* The hole goes beyond the max dquot id, we're done */
+			*next_ondisk_id = -1ULL;
+			return 0;
+		}
+
+		error = xfs_bmapi_read(cursor->quota_ip, fileoff,
+				XFS_MAX_FILEOFF - fileoff, &cursor->bmap,
+				&nmaps, 0);
+		if (error)
+			return error;
+		if (!nmaps) {
+			/* Must have reached the end of the mappings. */
+			*next_ondisk_id = -1ULL;
+			return 0;
+		}
+		if (cursor->bmap.br_startoff > fileoff) {
+			ASSERT(cursor->bmap.br_startoff == fileoff);
+			return -EFSCORRUPTED;
+		}
+	} while (!xfs_bmap_is_real_extent(&cursor->bmap));
+
+	next_id = cursor->bmap.br_startoff * qi->qi_dqperchunk;
+	if (next_id > XFS_DQ_ID_MAX) {
+		/* The hole goes beyond the max dquot id, we're done */
+		*next_ondisk_id = -1ULL;
+		return 0;
+	}
+
+	/* Propose jumping forward to the dquot in the next allocated block. */
+	*next_ondisk_id = next_id;
+	cursor->if_seq = ifp->if_seq;
+	trace_xchk_dquot_iter_advance_bmap(cursor, *next_ondisk_id);
+	return 0;
+}
+
+/*
+ * Find the id of the next highest incore dquot.  Normally this will correspond
+ * exactly with the quota file block mappings, but repair might have erased a
+ * mapping because it was crosslinked; in that case, we need to re-allocate the
+ * space so that we can reset q_blkno.
+ */
+STATIC void
+xchk_dquot_iter_advance_incore(
+	struct xchk_dqiter	*cursor,
+	uint64_t		*next_incore_id)
+{
+	struct xfs_quotainfo	*qi = cursor->sc->mp->m_quotainfo;
+	struct radix_tree_root	*tree = xfs_dquot_tree(qi, cursor->dqtype);
+	struct xfs_dquot	*dq;
+	unsigned int		nr_found;
+
+	*next_incore_id = -1ULL;
+
+	mutex_lock(&qi->qi_tree_lock);
+	nr_found = radix_tree_gang_lookup(tree, (void **)&dq, cursor->id, 1);
+	if (nr_found)
+		*next_incore_id = dq->q_id;
+	mutex_unlock(&qi->qi_tree_lock);
+
+	trace_xchk_dquot_iter_advance_incore(cursor, *next_incore_id);
+}
+
+/*
+ * Walk all incore dquots of this filesystem.  Caller must set *@cursorp to
+ * zero before the first call, and must not hold the quota file ILOCK.
+ * Returns 1 and a valid *@dqpp; 0 and *@dqpp == NULL when there are no more
+ * dquots to iterate; or a negative errno.
+ */
+int
+xchk_dquot_iter(
+	struct xchk_dqiter	*cursor,
+	struct xfs_dquot	**dqpp)
+{
+	struct xfs_mount	*mp = cursor->sc->mp;
+	struct xfs_dquot	*dq = NULL;
+	uint64_t		next_ondisk, next_incore = -1ULL;
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	if (cursor->id > XFS_DQ_ID_MAX)
+		return 0;
+	next_ondisk = cursor->id;
+
+	/* Revalidate and/or advance the cursor. */
+	lock_mode = xfs_ilock_data_map_shared(cursor->quota_ip);
+	error = xchk_dquot_iter_revalidate_bmap(cursor);
+	if (!error && !xfs_bmap_is_real_extent(&cursor->bmap))
+		error = xchk_dquot_iter_advance_bmap(cursor, &next_ondisk);
+	xfs_iunlock(cursor->quota_ip, lock_mode);
+	if (error)
+		return error;
+
+	if (next_ondisk > cursor->id)
+		xchk_dquot_iter_advance_incore(cursor, &next_incore);
+
+	/* Pick the next dquot in the sequence and return it. */
+	cursor->id = min(next_ondisk, next_incore);
+	if (cursor->id > XFS_DQ_ID_MAX)
+		return 0;
+
+	trace_xchk_dquot_iter(cursor, cursor->id);
+
+	error = xfs_qm_dqget(mp, cursor->id, cursor->dqtype, false, &dq);
+	if (error)
+		return error;
+
+	cursor->id = dq->q_id + 1;
+	*dqpp = dq;
+	return 1;
+}
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 49835d2840b4..1a65a7502527 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/quota.h"
 
 /* Convert a scrub type code to a DQ flag, or return 0 if error. */
 static inline xfs_dqtype_t
@@ -137,11 +138,9 @@ xchk_quota_item_timer(
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
-	struct xfs_dquot	*dq,
-	xfs_dqtype_t		dqtype,
-	void			*priv)
+	struct xchk_quota_info	*sqi,
+	struct xfs_dquot	*dq)
 {
-	struct xchk_quota_info	*sqi = priv;
 	struct xfs_scrub	*sc = sqi->sc;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
@@ -270,7 +269,7 @@ xchk_quota_data_fork(
 		return error;
 
 	/* Check for data fork problems that apply only to quota files. */
-	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
+	max_dqid_off = XFS_DQ_ID_MAX / qi->qi_dqperchunk;
 	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	for_each_xfs_iext(ifp, &icur, &irec) {
 		if (xchk_should_terminate(sc, &error))
@@ -297,9 +296,11 @@ int
 xchk_quota(
 	struct xfs_scrub	*sc)
 {
-	struct xchk_quota_info	sqi;
+	struct xchk_dqiter	cursor = { };
+	struct xchk_quota_info	sqi = { .sc = sc };
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	struct xfs_dquot	*dq;
 	xfs_dqtype_t		dqtype;
 	int			error = 0;
 
@@ -318,9 +319,15 @@ xchk_quota(
 	 * functions.
 	 */
 	xchk_iunlock(sc, sc->ilock_flags);
-	sqi.sc = sc;
-	sqi.last_id = 0;
-	error = xfs_qm_dqiterate(mp, dqtype, xchk_quota_item, &sqi);
+
+	/* Now look for things that the quota verifiers won't complain about. */
+	xchk_dqiter_init(&cursor, sc, dqtype);
+	while ((error = xchk_dquot_iter(&cursor, &dq)) == 1) {
+		error = xchk_quota_item(&sqi, dq);
+		xfs_qm_dqput(dq);
+		if (error)
+			break;
+	}
 	xchk_ilock(sc, XFS_ILOCK_EXCL);
 	if (error == -ECANCELED)
 		error = 0;
diff --git a/fs/xfs/scrub/quota.h b/fs/xfs/scrub/quota.h
new file mode 100644
index 000000000000..5056b7766c4a
--- /dev/null
+++ b/fs/xfs/scrub/quota.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_QUOTA_H__
+#define __XFS_SCRUB_QUOTA_H__
+
+/* dquot iteration code */
+
+struct xchk_dqiter {
+	struct xfs_scrub	*sc;
+
+	/* Quota file that we're walking. */
+	struct xfs_inode	*quota_ip;
+
+	/* Cached data fork mapping for the dquot. */
+	struct xfs_bmbt_irec	bmap;
+
+	/* The next dquot to scan. */
+	uint64_t		id;
+
+	/* Quota type (user/group/project). */
+	xfs_dqtype_t		dqtype;
+
+	/* Data fork sequence number to detect stale mappings. */
+	unsigned int		if_seq;
+};
+
+void xchk_dqiter_init(struct xchk_dqiter *cursor, struct xfs_scrub *sc,
+		xfs_dqtype_t dqtype);
+int xchk_dquot_iter(struct xchk_dqiter *cursor, struct xfs_dquot **dqpp);
+
+#endif /* __XFS_SCRUB_QUOTA_H__ */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 29afa4851235..4641522fd907 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -14,9 +14,11 @@
 #include "xfs_btree.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_quota.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
+#include "scrub/quota.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3d5c8e748955..83827f3e165b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -19,6 +19,7 @@
 struct xfile;
 struct xfarray;
 struct xfarray_sortinfo;
+struct xchk_dqiter;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -348,6 +349,54 @@ DEFINE_EVENT(xchk_fblock_error_class, name, \
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_error);
 DEFINE_SCRUB_FBLOCK_ERROR_EVENT(xchk_fblock_warning);
 
+#ifdef CONFIG_XFS_QUOTA
+DECLARE_EVENT_CLASS(xchk_dqiter_class,
+	TP_PROTO(struct xchk_dqiter *cursor, uint64_t id),
+	TP_ARGS(cursor, id),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_dqtype_t, dqtype)
+		__field(xfs_ino_t, ino)
+		__field(unsigned long long, cur_id)
+		__field(unsigned long long, id)
+		__field(xfs_fileoff_t, startoff)
+		__field(xfs_fsblock_t, startblock)
+		__field(xfs_filblks_t, blockcount)
+		__field(xfs_exntst_t, state)
+	),
+	TP_fast_assign(
+		__entry->dev = cursor->sc->ip->i_mount->m_super->s_dev;
+		__entry->dqtype = cursor->dqtype;
+		__entry->ino = cursor->quota_ip->i_ino;
+		__entry->cur_id = cursor->id;
+		__entry->startoff = cursor->bmap.br_startoff;
+		__entry->startblock = cursor->bmap.br_startblock;
+		__entry->blockcount = cursor->bmap.br_blockcount;
+		__entry->state = cursor->bmap.br_state;
+		__entry->id = id;
+	),
+	TP_printk("dev %d:%d dquot type %s ino 0x%llx cursor_id 0x%llx startoff 0x%llx startblock 0x%llx blockcount 0x%llx state %u id 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->dqtype, XFS_DQTYPE_STRINGS),
+		  __entry->ino,
+		  __entry->cur_id,
+		  __entry->startoff,
+		  __entry->startblock,
+		  __entry->blockcount,
+		  __entry->state,
+		  __entry->id)
+);
+
+#define DEFINE_SCRUB_DQITER_EVENT(name) \
+DEFINE_EVENT(xchk_dqiter_class, name, \
+	TP_PROTO(struct xchk_dqiter *cursor, uint64_t id), \
+	TP_ARGS(cursor, id))
+DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_revalidate_bmap);
+DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_advance_bmap);
+DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter_advance_incore);
+DEFINE_SCRUB_DQITER_EVENT(xchk_dquot_iter);
+#endif /* CONFIG_XFS_QUOTA */
+
 TRACE_EVENT(xchk_incomplete,
 	TP_PROTO(struct xfs_scrub *sc, void *ret_ip),
 	TP_ARGS(sc, ret_ip),
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index a013b87ab8d5..60ec401e26ff 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1362,34 +1362,3 @@ xfs_qm_exit(void)
 	kmem_cache_destroy(xfs_dqtrx_cache);
 	kmem_cache_destroy(xfs_dquot_cache);
 }
-
-/*
- * Iterate every dquot of a particular type.  The caller must ensure that the
- * particular quota type is active.  iter_fn can return negative error codes,
- * or -ECANCELED to indicate that it wants to stop iterating.
- */
-int
-xfs_qm_dqiterate(
-	struct xfs_mount	*mp,
-	xfs_dqtype_t		type,
-	xfs_qm_dqiterate_fn	iter_fn,
-	void			*priv)
-{
-	struct xfs_dquot	*dq;
-	xfs_dqid_t		id = 0;
-	int			error;
-
-	do {
-		error = xfs_qm_dqget_next(mp, id, type, &dq);
-		if (error == -ENOENT)
-			return 0;
-		if (error)
-			return error;
-
-		error = iter_fn(dq, type, priv);
-		id = dq->q_id + 1;
-		xfs_qm_dqput(dq);
-	} while (error == 0 && id != 0);
-
-	return error;
-}
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 80c8f851a2f3..8d9d4b0d979d 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -234,11 +234,6 @@ static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 	return dqp;
 }
 
-typedef int (*xfs_qm_dqiterate_fn)(struct xfs_dquot *dq,
-		xfs_dqtype_t type, void *priv);
-int xfs_qm_dqiterate(struct xfs_mount *mp, xfs_dqtype_t type,
-		xfs_qm_dqiterate_fn iter_fn, void *priv);
-
 time64_t xfs_dquot_set_timeout(struct xfs_mount *mp, time64_t timeout);
 time64_t xfs_dquot_set_grace_period(time64_t grace);
 

