Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071C02D3A86
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 05:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752556661; cv=none; b=oHR6P8SeIq/1GtJ0PzACrbRYGh4y+5rFHydXOt8DYiepbbJ9m8uwFh/JDaIZGHMGTESyynPhjB+vfty2Derkz632J1fJqdmKmaAKkd2mlobuYyBYPlLdh9hq0eYHcz5D4Cd1nh//pqYXI4p30wAVyD5j8P/+9UVrn7JXMG6i5MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752556661; c=relaxed/simple;
	bh=MF/ZaO8AIWbmbtOnTws63z9nf14RA5Se/2wq9ldIZzk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rp9tf8oXp2Ku7TBKBFen7sRem+hAyBHhcjsrHsiWrt+RScQolRr4EJ3q53ypoCAJSzkCXrBKH0v/Xgvj4emyvGIbW96h/zYSEuDGTFXUyvpMgRmpjH+p53TkAaXWNhabiO035SM9AkGWyH+qKEUSPOZLeCXE/1/hD4NBf7wfd5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D0/hjZEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D0/hjZEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3997C4CEE3;
	Tue, 15 Jul 2025 05:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752556660;
	bh=MF/ZaO8AIWbmbtOnTws63z9nf14RA5Se/2wq9ldIZzk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D0/hjZEAlCN0tDZ00sHv+1LOo4O4XYeffcyHSZFRtzeKc6pes/xTYjyM2za9O6ChJ
	 QBVzi1gBIB29Sd+GhhOb3BfDcVjAuVVN1uD2KelV2XTDWTC2sMnGbRu0cvwj+1vu+N
	 2DC8386Gx/OmydYsdOZ9pXhqkXzYsmpbbIoPH1C9mpApkY6sB9kG0qwiLlVZFmymz4
	 gBR6dODhjqGnaaOFhFI/OHdJQe311DQaDObni1IUkHZydJJOy1gqR5vQfRuPFEs9mV
	 Xu+256fj88FOm0bpgy+9VlYpyy8dV/I98toZ05TcZGLTX0LXjDSHEbZORDnn/cnGvO
	 AwGD29HJsubeQ==
Date: Mon, 14 Jul 2025 22:17:40 -0700
Subject: [PATCH 5/6] xfs: add xfs_calc_atomic_write_unit_max()
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, john.g.garry@oracle.com, catherine.hoang@oracle.com,
 john.g.garry@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <175255652203.1830720.16427932226193042656.stgit@frogsfrogsfrogs>
In-Reply-To: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
References: <175255652087.1830720.17606543077660806130.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: John Garry <john.g.garry@oracle.com>

Source kernel commit: 0c438dcc31504bf4f50b20dc52f8f5ca7fab53e2

Now that CoW-based atomic writes are supported, update the max size of an
atomic write for the data device.

The limit of a CoW-based atomic write will be the limit of the number of
logitems which can fit into a single transaction.

In addition, the max atomic write size needs to be aligned to the agsize.
Limit the size of atomic writes to the greatest power-of-two factor of the
agsize so that allocations for an atomic write will always be aligned
compatibly with the alignment requirements of the storage.

Function xfs_atomic_write_logitems() is added to find the limit the number
of log items which can fit in a single transaction.

Amend the max atomic write computation to create a new transaction
reservation type, and compute the maximum size of an atomic write
completion (in fsblocks) based on this new transaction reservation.
Initially, tr_atomic_write is a clone of tr_itruncate, which provides a
reasonable level of parallelism.  In the next patch, we'll add a mount
option so that sysadmins can configure their own limits.

[djwong: use a new reservation type for atomic write ioends, refactor
group limit calculations]

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[jpg: rounddown power-of-2 always]
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 include/xfs_trace.h     |    2 +
 libxfs/xfs_trans_resv.h |    2 +
 libxfs/xfs_trans_resv.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 30166c11dd597b..965c109cc1941a 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -64,6 +64,8 @@
 #define trace_xfs_attr_rmtval_alloc(...)	((void) 0)
 #define trace_xfs_attr_rmtval_remove_return(...) ((void) 0)
 
+#define trace_xfs_calc_max_atomic_write_fsblocks(...) ((void) 0)
+
 #define trace_xfs_log_recover_item_add_cont(a,b,c,d)	((void) 0)
 #define trace_xfs_log_recover_item_add(a,b,c,d)	((void) 0)
 
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 670045d417a65f..a6d303b836883f 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -121,4 +121,6 @@ unsigned int xfs_calc_itruncate_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_write_reservation_minlogsize(struct xfs_mount *mp);
 unsigned int xfs_calc_qm_dqalloc_reservation_minlogsize(struct xfs_mount *mp);
 
+xfs_extlen_t xfs_calc_max_atomic_write_fsblocks(struct xfs_mount *mp);
+
 #endif	/* __XFS_TRANS_RESV_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index cf735f946c8ac7..ec61ddfba44601 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -19,6 +19,8 @@
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_trace.h"
+#include "defer_item.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -1391,3 +1393,91 @@ xfs_trans_resv_calc(
 	 */
 	xfs_calc_default_atomic_ioend_reservation(mp, resp);
 }
+
+/*
+ * Return the per-extent and fixed transaction reservation sizes needed to
+ * complete an atomic write.
+ */
+STATIC unsigned int
+xfs_calc_atomic_write_ioend_geometry(
+	struct xfs_mount	*mp,
+	unsigned int		*step_size)
+{
+	const unsigned int	efi = xfs_efi_log_space(1);
+	const unsigned int	efd = xfs_efd_log_space(1);
+	const unsigned int	rui = xfs_rui_log_space(1);
+	const unsigned int	rud = xfs_rud_log_space();
+	const unsigned int	cui = xfs_cui_log_space(1);
+	const unsigned int	cud = xfs_cud_log_space();
+	const unsigned int	bui = xfs_bui_log_space(1);
+	const unsigned int	bud = xfs_bud_log_space();
+
+	/*
+	 * Maximum overhead to complete an atomic write ioend in software:
+	 * remove data fork extent + remove cow fork extent + map extent into
+	 * data fork.
+	 *
+	 * tx0: Creates a BUI and a CUI and that's all it needs.
+	 *
+	 * tx1: Roll to finish the BUI.  Need space for the BUD, an RUI, and
+	 * enough space to relog the CUI (== CUI + CUD).
+	 *
+	 * tx2: Roll again to finish the RUI.  Need space for the RUD and space
+	 * to relog the CUI.
+	 *
+	 * tx3: Roll again, need space for the CUD and possibly a new EFI.
+	 *
+	 * tx4: Roll again, need space for an EFD.
+	 *
+	 * If the extent referenced by the pair of BUI/CUI items is not the one
+	 * being currently processed, then we need to reserve space to relog
+	 * both items.
+	 */
+	const unsigned int	tx0 = bui + cui;
+	const unsigned int	tx1 = bud + rui + cui + cud;
+	const unsigned int	tx2 = rud + cui + cud;
+	const unsigned int	tx3 = cud + efi;
+	const unsigned int	tx4 = efd;
+	const unsigned int	relog = bui + bud + cui + cud;
+
+	const unsigned int	per_intent = max(max3(tx0, tx1, tx2),
+						 max3(tx3, tx4, relog));
+
+	/* Overhead to finish one step of each intent item type */
+	const unsigned int	f1 = xfs_calc_finish_efi_reservation(mp, 1);
+	const unsigned int	f2 = xfs_calc_finish_rui_reservation(mp, 1);
+	const unsigned int	f3 = xfs_calc_finish_cui_reservation(mp, 1);
+	const unsigned int	f4 = xfs_calc_finish_bui_reservation(mp, 1);
+
+	/* We only finish one item per transaction in a chain */
+	*step_size = max(f4, max3(f1, f2, f3));
+
+	return per_intent;
+}
+
+/*
+ * Compute the maximum size (in fsblocks) of atomic writes that we can complete
+ * given the existing log reservations.
+ */
+xfs_extlen_t
+xfs_calc_max_atomic_write_fsblocks(
+	struct xfs_mount		*mp)
+{
+	const struct xfs_trans_res	*resv = &M_RES(mp)->tr_atomic_ioend;
+	unsigned int			per_intent = 0;
+	unsigned int			step_size = 0;
+	unsigned int			ret = 0;
+
+	if (resv->tr_logres > 0) {
+		per_intent = xfs_calc_atomic_write_ioend_geometry(mp,
+				&step_size);
+
+		if (resv->tr_logres >= step_size)
+			ret = (resv->tr_logres - step_size) / per_intent;
+	}
+
+	trace_xfs_calc_max_atomic_write_fsblocks(mp, per_intent, step_size,
+			resv->tr_logres, ret);
+
+	return ret;
+}

