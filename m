Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5A28EA54
	for <linux-xfs@vger.kernel.org>; Thu,  3 Apr 2025 19:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743707565; cv=none; b=XBnzwIuXB5w9S8AA/wu/FxWS8EhNQ/YkTKcDOqfgSOT5xa9D3YDGsdfiFEhMeMeB0id7Rls5PcrjhpYfUpXf/EKx0WxkQDKdTfVBZFNuc0jzpp+eSHDTgfPl+tdgRjPfmnwxfpamf5ON9EIZCBYSY4CnkYVwzBxeaDeJVU+PwmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743707565; c=relaxed/simple;
	bh=VcSqF9majT6s0EjgP6y5cqqJEb+OaY78hjsIBpONmlA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KaIMUZ4Jj574ixGdOjBhr5MvrRyObDi5C7yvHGMVyL/ln5f2CPxCFlP1SqT5hqKBoA7TDDeAITG3SQ1d1rqwBoO368jqgAsUxAHeWfcew62wL3o1m4a/diFq8+RKYoOcaQdtrOPHwdTkQmP69JrZnfcX3fXAhipWcUs2cRw5cug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeRCfMAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeRCfMAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 202E4C4CEE3;
	Thu,  3 Apr 2025 19:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743707565;
	bh=VcSqF9majT6s0EjgP6y5cqqJEb+OaY78hjsIBpONmlA=;
	h=Date:From:To:Cc:Subject:From;
	b=PeRCfMAZ5IaIjwxUlwz5MK8MIPSflHQI+bWbbDA07X2+Hv2YmWnQtB4u+oIIFB8Qg
	 gRTxtuHoVI5No3UVByQSCwyOYZtzWwR6XmLTgDfziVe1/CW56hf2VeLtrRLlVS51fo
	 2VCPASTqyJy1w8MK4G9ZZqFsYuA3waJtB/udENzu2yILHO34R6qQBJZnbcKRTyRZOe
	 KRxjx0WZVoKrhiekrfkHDq2zPJn5IGzPwM0HJ5fYiXGfFVETXCCijm/8SWoEAtBSUz
	 FHXsfQubB6REifXhpxPrp/YuZOTDmXA80Cu/b6K7VeLb/V5nk+eEuIouRHBs/9dtJF
	 13mZzkreB4m3A==
Date: Thu, 3 Apr 2025 12:12:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] xfs: compute the maximum repair reaping defer intent chain
 length
Message-ID: <20250403191244.GB6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Actually compute the log overhead of log intent items used in reap
operations and use that to compute the thresholds in reap.c instead of
assuming 2048 works.  Note that there have been no complaints because
tr_itruncate has a very large logres.

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 1c7ce115e52106 ("xfs: reap large AG metadata extents when possible")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/trace.h       |   29 ++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.h     |    3 +++
 fs/xfs/xfs_extfree_item.h  |    3 +++
 fs/xfs/xfs_log_priv.h      |   13 +++++++++++
 fs/xfs/xfs_refcount_item.h |    3 +++
 fs/xfs/xfs_rmap_item.h     |    3 +++
 fs/xfs/scrub/reap.c        |   50 +++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/trace.c       |    1 +
 fs/xfs/xfs_bmap_item.c     |   10 +++++++++
 fs/xfs/xfs_extfree_item.c  |   10 +++++++++
 fs/xfs/xfs_log_cil.c       |    4 +---
 fs/xfs/xfs_refcount_item.c |   10 +++++++++
 fs/xfs/xfs_rmap_item.c     |   10 +++++++++
 13 files changed, 140 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d7c4ced47c1567..172765967aaab4 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2000,6 +2000,35 @@ DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xreap_bmapi_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
+DECLARE_EVENT_CLASS(xrep_reap_max_deferred_reaps_class,
+	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size,
+		 unsigned int max_deferred_reaps),
+	TP_ARGS(tp, per_intent_size, max_deferred_reaps),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, log_res)
+		__field(unsigned int, per_intent_size)
+		__field(unsigned int, max_deferred_reaps)
+	),
+	TP_fast_assign(
+		__entry->dev = tp->t_mountp->m_super->s_dev;
+		__entry->log_res = tp->t_log_res;
+		__entry->per_intent_size = per_intent_size;
+		__entry->max_deferred_reaps = max_deferred_reaps;
+	),
+	TP_printk("dev %d:%d logres %u per_intent_size %u max_deferred_reaps %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->log_res,
+		  __entry->per_intent_size,
+		  __entry->max_deferred_reaps)
+);
+#define DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(name) \
+DEFINE_EVENT(xrep_reap_max_deferred_reaps_class, name, \
+	TP_PROTO(const struct xfs_trans *tp, unsigned int per_intent_size, \
+		 unsigned int max_deferred_reaps), \
+	TP_ARGS(tp, per_intent_size, max_deferred_reaps))
+DEFINE_REPAIR_REAP_MAX_DEFER_CHAIN_EVENT(xreap_agextent_max_deferred_reaps);
+
 DECLARE_EVENT_CLASS(xrep_reap_find_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len, bool crosslinked),
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 6fee6a5083436b..72512fc700e21a 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -72,4 +72,7 @@ struct xfs_bmap_intent;
 
 void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 
+unsigned int xfs_bui_item_overhead(unsigned int nr);
+unsigned int xfs_bud_item_overhead(unsigned int nr);
+
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index 41b7c43060799b..ebb237a4ae87b4 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -94,4 +94,7 @@ void xfs_extent_free_defer_add(struct xfs_trans *tp,
 		struct xfs_extent_free_item *xefi,
 		struct xfs_defer_pending **dfpp);
 
+unsigned int xfs_efi_item_overhead(unsigned int nr);
+unsigned int xfs_efd_item_overhead(unsigned int nr);
+
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f3d78869e5e5a3..39a102cc1b43e6 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -698,4 +698,17 @@ xlog_kvmalloc(
 	return p;
 }
 
+/*
+ * Given a count of iovecs and space for a log item, compute the space we need
+ * in the log to store that data plus the log headers.
+ */
+static inline unsigned int
+xlog_item_space(
+	unsigned int	niovecs,
+	unsigned int	nbytes)
+{
+	nbytes += niovecs * (sizeof(uint64_t) + sizeof(struct xlog_op_header));
+	return round_up(nbytes, sizeof(uint64_t));
+}
+
 #endif	/* __XFS_LOG_PRIV_H__ */
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index bfee8f30c63ce9..e23e768e031e20 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -76,4 +76,7 @@ struct xfs_refcount_intent;
 void xfs_refcount_defer_add(struct xfs_trans *tp,
 		struct xfs_refcount_intent *ri);
 
+unsigned int xfs_cui_item_overhead(unsigned int nr);
+unsigned int xfs_cud_item_overhead(unsigned int nr);
+
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 40d331555675ba..5fed8864bc32cc 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -75,4 +75,7 @@ struct xfs_rmap_intent;
 
 void xfs_rmap_defer_add(struct xfs_trans *tp, struct xfs_rmap_intent *ri);
 
+unsigned int xfs_rui_item_overhead(unsigned int nr);
+unsigned int xfs_rud_item_overhead(unsigned int nr);
+
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index b32fb233cf8476..2fd9b7465b5ed2 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -36,6 +36,9 @@
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_extfree_item.h"
+#include "xfs_rmap_item.h"
+#include "xfs_refcount_item.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -106,6 +109,9 @@ struct xreap_state {
 
 	/* Number of deferred reaps queued during the whole reap sequence. */
 	unsigned long long		total_deferred;
+
+	/* Maximum number of intents we can reap in a single transaction. */
+	unsigned int			max_deferred_reaps;
 };
 
 /* Put a block back on the AGFL. */
@@ -165,8 +171,8 @@ static inline bool xreap_dirty(const struct xreap_state *rs)
 
 /*
  * Decide if we want to roll the transaction after reaping an extent.  We don't
- * want to overrun the transaction reservation, so we prohibit more than
- * 128 EFIs per transaction.  For the same reason, we limit the number
+ * want to overrun the transaction reservation, so we restrict the number of
+ * log intent reaps per transaction.  For the same reason, we limit the number
  * of buffer invalidations to 2048.
  */
 static inline bool xreap_want_roll(const struct xreap_state *rs)
@@ -188,13 +194,11 @@ static inline void xreap_reset(struct xreap_state *rs)
 	rs->force_roll = false;
 }
 
-#define XREAP_MAX_DEFER_CHAIN		(2048)
-
 /*
  * Decide if we want to finish the deferred ops that are attached to the scrub
  * transaction.  We don't want to queue huge chains of deferred ops because
  * that can consume a lot of log space and kernel memory.  Hence we trigger a
- * xfs_defer_finish if there are more than 2048 deferred reap operations or the
+ * xfs_defer_finish if there are too many deferred reap operations or the
  * caller did some real work.
  */
 static inline bool
@@ -202,7 +206,7 @@ xreap_want_defer_finish(const struct xreap_state *rs)
 {
 	if (rs->force_roll)
 		return true;
-	if (rs->total_deferred > XREAP_MAX_DEFER_CHAIN)
+	if (rs->total_deferred > rs->max_deferred_reaps)
 		return true;
 	return false;
 }
@@ -495,6 +499,37 @@ xreap_agextent_iter(
 	return 0;
 }
 
+/*
+ * Compute the worst case log overhead of the intent items needed to reap a
+ * single per-AG space extent.
+ */
+STATIC unsigned int
+xreap_agextent_max_deferred_reaps(
+	struct xfs_scrub	*sc)
+{
+	const unsigned int	efi = xfs_efi_item_overhead(1);
+	const unsigned int	rui = xfs_rui_item_overhead(1);
+
+	/* unmapping crosslinked metadata blocks */
+	const unsigned int	t1 = rui;
+
+	/* freeing metadata blocks */
+	const unsigned int	t2 = rui + efi;
+
+	/* worst case of all four possible scenarios */
+	const unsigned int	per_intent = max(t1, t2);
+
+	/*
+	 * tr_itruncate has enough logres to unmap two file extents; use only
+	 * half the log reservation for intent items so there's space to do
+	 * actual work and requeue intent items.
+	 */
+	const unsigned int	ret = sc->tp->t_log_res / (2 * per_intent);
+
+	trace_xreap_agextent_max_deferred_reaps(sc->tp, per_intent, ret);
+	return max(1, ret);
+}
+
 /*
  * Break an AG metadata extent into sub-extents by fate (crosslinked, not
  * crosslinked), and dispose of each sub-extent separately.
@@ -556,6 +591,7 @@ xrep_reap_agblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= type,
+		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
 	};
 	int				error;
 
@@ -668,6 +704,7 @@ xrep_reap_fsblocks(
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= XFS_AG_RESV_NONE,
+		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
 	};
 	int				error;
 
@@ -922,6 +959,7 @@ xrep_reap_metadir_fsblocks(
 		.sc			= sc,
 		.oinfo			= &oinfo,
 		.resv			= XFS_AG_RESV_NONE,
+		.max_deferred_reaps	= xreap_agextent_max_deferred_reaps(sc),
 	};
 	int				error;
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 2450e214103fed..987313a52e6401 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -22,6 +22,7 @@
 #include "xfs_parent.h"
 #include "xfs_metafile.h"
 #include "xfs_rtgroup.h"
+#include "xfs_trans.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 3d52e9d7ad571a..586031332994ff 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -77,6 +77,11 @@ xfs_bui_item_size(
 	*nbytes += xfs_bui_log_format_sizeof(buip->bui_format.bui_nextents);
 }
 
+unsigned int xfs_bui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_bui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given bui log item. We use only 1 iovec, and we point that
@@ -168,6 +173,11 @@ xfs_bud_item_size(
 	*nbytes += sizeof(struct xfs_bud_log_format);
 }
 
+unsigned int xfs_bud_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, sizeof(struct xfs_bud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given bud log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index a25c713ff888c7..1dd7f45359e090 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -82,6 +82,11 @@ xfs_efi_item_size(
 	*nbytes += xfs_efi_log_format_sizeof(efip->efi_format.efi_nextents);
 }
 
+unsigned int xfs_efi_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efi_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given efi log item. We use only 1 iovec, and we point that
@@ -253,6 +258,11 @@ xfs_efd_item_size(
 	*nbytes += xfs_efd_log_format_sizeof(efdp->efd_format.efd_nextents);
 }
 
+unsigned int xfs_efd_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_efd_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given efd log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 1ca406ec1b40b3..f66d2d430e4f37 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -309,9 +309,7 @@ xlog_cil_alloc_shadow_bufs(
 		 * Then round nbytes up to 64-bit alignment so that the initial
 		 * buffer alignment is easy to calculate and verify.
 		 */
-		nbytes += niovecs *
-			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
-		nbytes = round_up(nbytes, sizeof(uint64_t));
+		nbytes = xlog_item_space(niovecs, nbytes);
 
 		/*
 		 * The data buffer needs to start 64-bit aligned, so round up
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index fe2d7aab8554fc..7ea43d35b1380d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -78,6 +78,11 @@ xfs_cui_item_size(
 	*nbytes += xfs_cui_log_format_sizeof(cuip->cui_format.cui_nextents);
 }
 
+unsigned int xfs_cui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_cui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given cui log item. We use only 1 iovec, and we point that
@@ -179,6 +184,11 @@ xfs_cud_item_size(
 	*nbytes += sizeof(struct xfs_cud_log_format);
 }
 
+unsigned int xfs_cud_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, sizeof(struct xfs_cud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given cud log item. We use only 1 iovec, and we point that
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 89decffe76c8b5..3e214ce2339f54 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -77,6 +77,11 @@ xfs_rui_item_size(
 	*nbytes += xfs_rui_log_format_sizeof(ruip->rui_format.rui_nextents);
 }
 
+unsigned int xfs_rui_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, xfs_rui_log_format_sizeof(nr));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given rui log item. We use only 1 iovec, and we point that
@@ -180,6 +185,11 @@ xfs_rud_item_size(
 	*nbytes += sizeof(struct xfs_rud_log_format);
 }
 
+unsigned int xfs_rud_item_overhead(unsigned int nr)
+{
+	return xlog_item_space(1, sizeof(struct xfs_rud_log_format));
+}
+
 /*
  * This is called to fill in the vector of log iovecs for the
  * given rud log item. We use only 1 iovec, and we point that
