Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388EF1A9B49
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636767; cv=none; b=BPHGm2KOC/py2vBoIYJgR/rfrV01vMDf6z4GsAe++Z9j1l1/Ys9VTexTErB0EZ1u4uD7ZUmcqtM+iyJrgLCxzTgRSEu1gJd7HwFBDqRT1/dEAr/hZ5IgRvAl+ubKD0j2Dzcr7WNT+97v/70tFhnXlUFXwEnde2whLgah0RocBl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636767; c=relaxed/simple;
	bh=Yay2ZgifQ2To15HeQs0FFN/JR6eFb1MFQVMau6VXUkA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cmrPRpFRcs0ssLGGyrdZXoQ7Emhy4X3iVHkD//Qvb1+yGnLl3Ugv6COVVfE9mGsuXi0ZI4zfLVygIh9KD8yeWG8Kk0l4Oput976JBp31ri2079vBZIuFxS2mSred8PiJzBSe1cqhE7Gohr7UPLw0GmX1h2jQKE4hT0305+RY9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJ8B3Wj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJ8B3Wj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FA2C4CECE;
	Thu, 19 Dec 2024 19:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636767;
	bh=Yay2ZgifQ2To15HeQs0FFN/JR6eFb1MFQVMau6VXUkA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bJ8B3Wj4MJi85TRma7QJtszNK+ozV9MdfKp2ut/VnyIImHdX3vvK+lhb7OzUbs+hF
	 3EV+RLFJe6KrvSZYktrw+Oia0ozvpxaLJt3DeVItRR+YVswjTIHutMpikyY6M6sowl
	 W0XOsLoqnPmVCk0PT8mxx0IILR7Al0+aUtvWJ9vSRfecFEkNtwewSuZ8rdqSP+5dHA
	 6o1xNDM+9RNHNP5N+aiJO8BL0dy0HrkKIc277f2TWs6qQhgUr2krb6lkwvhjJZaPdi
	 N04wOOoIant7MKB8++XW231vzBnrQSpP+7F5/a2S1rnL1kGAQYkbpRUjleYrrgEZGh
	 OqGfl1clb2kUA==
Date: Thu, 19 Dec 2024 11:32:46 -0800
Subject: [PATCH 36/37] xfs: react to fsdax failure notifications on the rt
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580376.1571512.13084612178987057437.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reverse mapping for the realtime device, use the
information to kill processes that have mappings to bad pmem.  This
requires refactoring the existing routines to handle rtgroups or AGs;
and splitting out the translation function to improve cohesion.
Also make a proper header file for the dax holder ops.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c            |    1 
 fs/xfs/xfs_notify_failure.c |  127 ++++++++++++++++++++++++-------------------
 fs/xfs/xfs_notify_failure.h |   11 ++++
 fs/xfs/xfs_super.h          |    1 
 4 files changed, 84 insertions(+), 56 deletions(-)
 create mode 100644 fs/xfs/xfs_notify_failure.h


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aa63b8efd78228..6f313fbf766910 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 #include "xfs_buf_mem.h"
+#include "xfs_notify_failure.h"
 
 struct kmem_cache *xfs_buf_cache;
 
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 0b0b0f31aca274..ed8d8ed42f0a2c 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -19,6 +19,9 @@
 #include "xfs_rtalloc.h"
 #include "xfs_trans.h"
 #include "xfs_ag.h"
+#include "xfs_notify_failure.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 #include <linux/mm.h>
 #include <linux/dax.h>
@@ -227,23 +230,42 @@ xfs_dax_notify_logdev_failure(
 }
 
 static int
-xfs_dax_notify_ddev_failure(
+xfs_dax_notify_dev_failure(
 	struct xfs_mount	*mp,
-	xfs_daddr_t		daddr,
-	xfs_daddr_t		bblen,
-	int			mf_flags)
+	u64			offset,
+	u64			len,
+	int			mf_flags,
+	enum xfs_group_type	type)
 {
 	struct xfs_failure_info	notify = { .mf_flags = mf_flags };
 	struct xfs_trans	*tp = NULL;
 	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_buf		*agf_bp = NULL;
 	int			error = 0;
 	bool			kernel_frozen = false;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, daddr);
-	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp,
-							     daddr + bblen - 1);
-	xfs_agnumber_t		end_agno = XFS_FSB_TO_AGNO(mp, end_fsbno);
+	uint32_t		start_gno, end_gno;
+	xfs_fsblock_t		start_bno, end_bno;
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	struct xfs_group	*xg = NULL;
+
+	if (!xfs_has_rmapbt(mp)) {
+		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
+		return -EOPNOTSUPP;
+	}
+
+	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
+			mp->m_rtdev_targp : mp->m_ddev_targp,
+			offset, len, &daddr, &bblen);
+	if (error)
+		return error;
+
+	if (type == XG_TYPE_RTG) {
+		start_bno = xfs_daddr_to_rtb(mp, daddr);
+		end_bno = xfs_daddr_to_rtb(mp, daddr + bblen - 1);
+	} else {
+		start_bno = XFS_DADDR_TO_FSB(mp, daddr);
+		end_bno = XFS_DADDR_TO_FSB(mp, daddr + bblen - 1);
+	}
 
 	if (mf_flags & MF_MEM_PRE_REMOVE) {
 		xfs_info(mp, "Device is about to be removed!");
@@ -262,46 +284,58 @@ xfs_dax_notify_ddev_failure(
 	if (error)
 		goto out;
 
-	for (; agno <= end_agno; agno++) {
+	start_gno = xfs_fsb_to_gno(mp, start_bno, type);
+	end_gno = xfs_fsb_to_gno(mp, end_bno, type);
+	while ((xg = xfs_group_next_range(mp, xg, start_gno, end_gno, type))) {
+		struct xfs_buf		*agf_bp = NULL;
+		struct xfs_rtgroup	*rtg = NULL;
 		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
-		struct xfs_agf		*agf;
-		struct xfs_perag	*pag;
-		xfs_agblock_t		range_agend;
 
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
-		if (error) {
-			xfs_perag_put(pag);
-			break;
+		if (type == XG_TYPE_AG) {
+			struct xfs_perag	*pag = to_perag(xg);
+
+			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+			if (error) {
+				xfs_perag_put(pag);
+				break;
+			}
+
+			cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, pag);
+		} else {
+			rtg = to_rtg(xg);
+			xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+			cur = xfs_rtrmapbt_init_cursor(tp, rtg);
 		}
 
-		cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, pag);
-
 		/*
 		 * Set the rmap range from ri_low to ri_high, which represents
 		 * a [start, end] where we looking for the files or metadata.
 		 */
 		memset(&ri_high, 0xFF, sizeof(ri_high));
-		ri_low.rm_startblock = XFS_FSB_TO_AGBNO(mp, fsbno);
-		if (agno == end_agno)
-			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
+		if (xg->xg_gno == start_gno)
+			ri_low.rm_startblock =
+				xfs_fsb_to_gbno(mp, start_bno, type);
+		if (xg->xg_gno == end_gno)
+			ri_high.rm_startblock =
+				xfs_fsb_to_gbno(mp, end_bno, type);
 
-		agf = agf_bp->b_addr;
-		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
-				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
+		notify.blockcount = min(xg->xg_block_count,
+					ri_high.rm_startblock + 1) -
+					ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
 		xfs_btree_del_cursor(cur, error);
-		xfs_trans_brelse(tp, agf_bp);
-		xfs_perag_put(pag);
-		if (error)
+		if (agf_bp)
+			xfs_trans_brelse(tp, agf_bp);
+		if (rtg)
+			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+		if (error) {
+			xfs_group_put(xg);
 			break;
-
-		fsbno = XFS_AGB_TO_FSB(mp, agno + 1, 0);
+		}
 	}
 
 	xfs_trans_cancel(tp);
@@ -336,37 +370,20 @@ xfs_dax_notify_failure(
 	int			mf_flags)
 {
 	struct xfs_mount	*mp = dax_holder(dax_dev);
-	xfs_daddr_t		daddr;
-	uint64_t		bblen;
-	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
 		return -EIO;
 	}
 
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
-		xfs_debug(mp,
-			 "notify_failure() not supported on realtime device!");
-		return -EOPNOTSUPP;
-	}
-
-	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
-	    mp->m_logdev_targp != mp->m_ddev_targp) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp &&
+	    mp->m_logdev_targp->bt_daxdev == dax_dev) {
 		return xfs_dax_notify_logdev_failure(mp, offset, len, mf_flags);
 	}
 
-	if (!xfs_has_rmapbt(mp)) {
-		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
-		return -EOPNOTSUPP;
-	}
-
-	error = xfs_dax_translate_range(mp->m_ddev_targp, offset, len, &daddr,
-			&bblen);
-	if (error)
-		return error;
-
-	return xfs_dax_notify_ddev_failure(mp, daddr, bblen, mf_flags);
+	return xfs_dax_notify_dev_failure(mp, offset, len, mf_flags,
+		(mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) ?
+				XG_TYPE_RTG : XG_TYPE_AG);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {
diff --git a/fs/xfs/xfs_notify_failure.h b/fs/xfs/xfs_notify_failure.h
new file mode 100644
index 00000000000000..8d08ec29dd2949
--- /dev/null
+++ b/fs/xfs/xfs_notify_failure.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_NOTIFY_FAILURE_H__
+#define __XFS_NOTIFY_FAILURE_H__
+
+extern const struct dax_holder_operations xfs_dax_holder_operations;
+
+#endif /* __XFS_NOTIFY_FAILURE_H__ */
diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 302e6e5d6c7e20..c0e85c1e42f27d 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -92,7 +92,6 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
 
 extern const struct export_operations xfs_export_operations;
 extern const struct quotactl_ops xfs_quotactl_operations;
-extern const struct dax_holder_operations xfs_dax_holder_operations;
 
 extern void xfs_reinit_percpu_counters(struct xfs_mount *mp);
 

