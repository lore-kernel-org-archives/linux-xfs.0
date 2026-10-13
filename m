Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7832D781B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871340; cv=none; b=EdUZERuMorAd0PsafeR4n9xpo90vuj0Tkl2382qO4w4Wd6644qGWzzrpTeK6HqTUPdT7RRH57ioCv2QmyE0Hm5TAJil3Z84I1UdD10dP108PGYfSRtDz28lKtM/CVgVAB3nWtzrZ4zdtU45ibWHrYI+M0qybLXpwjDwnYrYVnpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871340; c=relaxed/simple;
	bh=RkZQVo8SYE/Su4kpLAbVXY2vF55oziiEctLgmaSRtAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REm4qprSaqE4yk5W7DuuJQmvD9VBcBlNbB+iDKCJwc0oTtML6DWMHhtXatE34gvhw0L3Sdi+13fzWCsIvlsk/229lqhrgEobvK1kpbww/lUuNonyri++5xEILWdOT2Si2WQn+OAO/YOjrjXXguPMXzHNs0J7Ie8mSt57Wgd/MO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JYDlL8Uy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JYDlL8Uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B064E1F000FF;
	Tue, 13 Oct 2026 06:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871338;
	bh=wS3SCkBC4RIpBRgeSTYxztXPKzdiAgByxRqN/w1Kzlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYDlL8UylunX5gOMlcwbQfvvjdOA3rjmjrT8BvlcwzqzBiCVkr13+dafQKloN8sQn
	 mkr7KopZHC1ChmU2GN5iah1OKToswEXBb4qDbjt/PSgeu7c00tKeQAdbVa2d+wFF/u
	 UZJrgiC03AQI1QEbpjs6rXD6W4ty/LqguSQY1UTbVcKfyN55FBFms0GT95+sOhdieP
	 DOCwUueEHEXSztp5yVS9sFg2SOtQ57zvchiiCPh4yhIvO5tqqH4qMmXQdvA69EKGEP
	 KaZ5mPWi+yh+f6OmssmlY4bQ7IAK780Xe6xZpXVHrKbbf48msQQ26QUWlgpCxPSoLr
	 MuAxMacSLrSfA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 07/48] xfs: add log item validation infrastructure to log recovery
Date: Tue, 13 Oct 2026 17:00:57 +1100
Message-ID: <20261013060204.3138690-8-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Log recovery decodes log items straight out of the journal and trusts the
region layout it finds there. Corrupt or malicious journal contents can
therefore drive recovery with bogus type codes, region counts and header
lengths before any validation happens. Add the infrastructure that later
patches will use to validate each item as it is decoded, and wire the
generic validation call sites into the region assembly path so per-type
patches only need to supply the checks.

struct xlog_recover_item_ops gains a min_hdr_len field (the minimum valid
length of the format header in ri_buf[0]) and four optional callbacks:
validate_nregions() returns the number of regions to assemble for the item;
validate_region() checks a single region once it has been fully assembled;
validate_item() checks the whole item once all of its regions are present;
and complete() is a per-type completion hook run once the item is fully
assembled and validated.

The region count is a per-type method rather than a static bound because not
all recovered types describe their regions with the same "type/size" format
header that log items use. Each such type needs to extract and validate its
own region count. Types that do use the common layout supply no method and
fall back to the generic xlog_recover_nregions() helper, which accepts any
0 < count <= XLOG_MAX_REGIONS_IN_ITEM.

Item completion is driven through a shared path.
xlog_recover_complete_region() runs the min_hdr_len check on the format
header and the type's validate_region() callback once a region is complete,
then completes the item via xlog_recover_complete_item() - which runs
validate_item() - once the final region has been assembled. A region is
complete when it is not a partial continuation fragment, tracked with a
region_complete flag derived from XLOG_CONTINUE_TRANS in
xlog_recovery_process_trans() and passed into both
xlog_recover_add_to_trans() and xlog_recover_add_to_cont_trans(). Running
the header and region checks only at region-completion time means a region
split across op records is not rejected while it is still being assembled.

A completed item is queued on the transaction for replay by default. The
complete() hook lets a type do type-specific work at completion first, and it
may consume the item there and then rather than have it queued for later
recovery: returning XLOG_RECOVER_ITEM_CONSUMED frees the item instead of
queuing it, while returning 0 falls through to the default queuing. This
supports items that need finalising during decode, including pseudo-items
that are consumed rather than replayed. No type supplies the hook yet.

The ops lookup, unknown-type rejection and region-count validation move into
xlog_recover_add_item() as part of this, so the lookup is no longer done in
xlog_recover_reorder_trans() and xlog_find_item_ops() now takes the type
code directly. No item type supplies the new field or callbacks yet, so the
generic helper is always used and there is no functional change beyond the
unknown-type rejection moving earlier in decode.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 .../xfs-log-recovery-validation-design.rst    | 124 +++++----
 fs/xfs/libxfs/xfs_log_recover.h               |  53 ++++
 fs/xfs/xfs_log_recover.c                      | 238 +++++++++++++-----
 3 files changed, 298 insertions(+), 117 deletions(-)

diff --git a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
index 188b1bebf171..c0785dbaef12 100644
--- a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
+++ b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
@@ -70,8 +70,9 @@ c) Look up the item ops via ``xlog_find_item_ops()``
 d) If the type is unknown, reject immediately with ``-EFSCORRUPTED``
 e) Store ``item->ri_ops`` at this point (currently done in
    ``reorder_trans``)
-f) Validate ``ilf_size`` against ``ops->min_regions`` and
-   ``ops->max_regions``
+f) Validate the region count via ``ops->validate_nregions()`` (or the
+   generic ``xlog_recover_nregions()`` helper if the type does not supply
+   one), and use its return value as the number of regions to assemble
 g) Validate ``len >= ops->min_hdr_len`` (the minimum format header size)
 
 Transaction header as a validated type
@@ -110,36 +111,46 @@ ops entry by having the generic code recognise it as a special case
 at step (b) and apply its fixed constraints directly. Either approach
 works; the ops entry is cleaner but the special case is simpler.
 
-New fields in ``struct xlog_recover_item_ops``::
+New members in ``struct xlog_recover_item_ops``::
 
-    uint16_t    min_regions;    /* minimum valid ri_total */
-    uint16_t    max_regions;    /* maximum valid ri_total */
     uint16_t    min_hdr_len;    /* minimum ri_buf[0].iov_len */
-
-These are compile-time constants per item type. Examples:
-
-===========  ===========  ===========  ==============================
-Item Type    min_regions  max_regions  min_hdr_len
-===========  ===========  ===========  ==============================
-TRANS_HDR    1            1            sizeof(xfs_trans_header)
-BUF          2            XLOG_MAX..   sizeof(xfs_buf_log_format)
-INODE        2            4            sizeof(xfs_inode_log_format)
-DQUOT        2            2            sizeof(xfs_dq_logformat)
-EFI          1            1            sizeof(xfs_efi_log_format)
-EFD          1            1            sizeof(xfs_efd_log_format)
-RUI          1            1            sizeof(xfs_rui_log_format)
-RUD          1            1            sizeof(xfs_rud_log_format)
-CUI          1            1            sizeof(xfs_cui_log_format)
-CUD          1            1            sizeof(xfs_cud_log_format)
-BUI          1            1            sizeof(xfs_bui_log_format)
-BUD          1            1            sizeof(xfs_bud_log_format)
-ATTRI        2            5            sizeof(xfs_attri_log_format)
-ATTRD        1            1            sizeof(xfs_attrd_log_format)
-XMI          1            1            sizeof(xfs_xmi_log_format)
-XMD          1            1            sizeof(xfs_xmd_log_format)
-ICREATE      1            1            sizeof(xfs_icreate_log)
-QUOTAOFF     1            1            sizeof(xfs_qoff_logformat)
-===========  ===========  ===========  ==============================
+    int (*validate_nregions)(struct xlog *log, uint16_t nregions);
+
+``min_hdr_len`` is a compile-time constant per item type. The region count
+is validated by the ``validate_nregions()`` method rather than a static
+min/max pair: it is given the raw count read from the journal and returns
+the number of regions to assemble, or a negative error. This is a method,
+not a bound, because not all recovered types describe their regions with the
+same "type/size" format header that log items use, so each such type must
+extract and validate its own count. Types that do use the common layout
+supply no method and fall back to the generic ``xlog_recover_nregions()``
+helper, which accepts any ``0 < count <= XLOG_MAX_REGIONS_IN_ITEM``.
+
+Examples of the region count each type should accept and the minimum header
+length:
+
+===========  =====================  ==============================
+Item Type    regions                min_hdr_len
+===========  =====================  ==============================
+TRANS_HDR    1 (magic-derived)      sizeof(xfs_trans_header)
+BUF          2 .. XLOG_MAX..        sizeof(xfs_buf_log_format)
+INODE        2 .. 4                 sizeof(xfs_inode_log_format)
+DQUOT        2                      sizeof(xfs_dq_logformat)
+EFI          1                      sizeof(xfs_efi_log_format)
+EFD          1                      sizeof(xfs_efd_log_format)
+RUI          1                      sizeof(xfs_rui_log_format)
+RUD          1                      sizeof(xfs_rud_log_format)
+CUI          1                      sizeof(xfs_cui_log_format)
+CUD          1                      sizeof(xfs_cud_log_format)
+BUI          1                      sizeof(xfs_bui_log_format)
+BUD          1                      sizeof(xfs_bud_log_format)
+ATTRI        2 .. 5                 sizeof(xfs_attri_log_format)
+ATTRD        1                      sizeof(xfs_attrd_log_format)
+XMI          1                      sizeof(xfs_xmi_log_format)
+XMD          1                      sizeof(xfs_xmd_log_format)
+ICREATE      1                      sizeof(xfs_icreate_log)
+QUOTAOFF     1                      sizeof(xfs_qoff_logformat)
+===========  =====================  ==============================
 
 (RT variants same as their non-RT counterparts.)
 
@@ -355,8 +366,9 @@ region assembly code:
 
    - Check ``len >= 4`` before reading the type and size fields (except
      for the zero-length transaction header continuation case)
-   - After looking up ops, validate ``ilf_size`` against ops constraints
-     before using it for the ``kzalloc_objs`` allocation
+   - After looking up ops, validate the region count via
+     ``ops->validate_nregions()`` (or the generic helper) and use its
+     return value for the ``kzalloc_objs`` allocation
 
 3. ``xlog_recover_process_data()``:
 
@@ -372,25 +384,34 @@ region assembly code:
 Implementation Plan
 ===================
 
-The infrastructure fields and callbacks in ``struct
-xlog_recover_item_ops`` (the ``min_regions``/``max_regions``/``min_hdr_len``
-fields and the ``validate_region`` callback) are introduced first, before
-the transaction header ops entry that uses them. Later patches populate
-those fields and callbacks for the remaining item types and wire up the
-generic call sites. Each patch builds cleanly and is independently
+The infrastructure in ``struct xlog_recover_item_ops`` (the ``min_hdr_len``
+field and the ``validate_nregions``, ``validate_region``, ``validate_item``
+and ``complete`` callbacks) is introduced first, along with the generic
+region and item completion path that calls them, before the transaction
+header ops entry that uses them. Later patches populate those callbacks for
+the remaining item types. Each patch builds cleanly and is independently
 testable.
 
 Phase 1: Generic infrastructure, early ops lookup, transaction header
 ---------------------------------------------------------------------
 
 Patch 1: Add validation infrastructure to the ops struct
-    - Add the ``min_regions``/``max_regions``/``min_hdr_len`` fields to
-      ``struct xlog_recover_item_ops``
-    - Add the ``validate_region`` callback to ``struct
-      xlog_recover_item_ops``
-    - No behaviour change yet: the fields are zero and the callback is
-      NULL for all existing item types; nothing reads them until later
-      patches
+    - Add the ``min_hdr_len`` field and the ``validate_nregions``,
+      ``validate_region``, ``validate_item`` and ``complete`` callbacks to
+      ``struct xlog_recover_item_ops`` (plus the ``XLOG_RECOVER_ITEM_CONSUMED``
+      return value for ``complete``)
+    - Fold the start of a new item into ``xlog_recover_add_item()``, which
+      takes the type and region count, looks up the ops, rejects unknown
+      types, validates the region count (via ``validate_nregions`` or the
+      generic ``xlog_recover_nregions()`` helper) and returns the item or an
+      ERR_PTR(); remove the ops lookup from ``reorder_trans``
+    - Add the generic region/item completion path
+      (``xlog_recover_complete_region()``/``xlog_recover_complete_item()``)
+      that runs ``min_hdr_len``, ``validate_region``, ``validate_item`` and
+      the ``complete`` hook, driven from both region assembly functions
+    - No item type supplies the new field or callbacks yet, so the generic
+      helper is always used and there is no behaviour change beyond the
+      unknown-type rejection moving earlier
 
 Patch 2: Treat the transaction header as a validated region type
     - Add an ops entry for the transaction header keyed on the low 16 bits
@@ -414,12 +435,13 @@ Patch 3: Move item ops lookup to add_to_trans (first region decode)
     - Remove the ops lookup from ``xlog_recover_reorder_trans()`` (it
       becomes a simple NULL check / assertion)
 
-Patch 4: Populate min_regions/max_regions/min_hdr_len for all item types
-    - The three fields were added to ``struct xlog_recover_item_ops`` in
-      Patch 1; populate them for all remaining item types
-    - Add generic checks in ``add_to_trans`` after ops lookup:
-      ``ilf_size >= ops->min_regions && ilf_size <= ops->max_regions``,
-      ``len >= ops->min_hdr_len`` (for non-continuation first regions)
+Patch 4: Populate validate_nregions/min_hdr_len for all item types
+    - The ``min_hdr_len`` field and ``validate_nregions`` callback were added
+      to ``struct xlog_recover_item_ops`` in Patch 1; populate them for all
+      remaining item types (each ``validate_nregions`` enforces the type's
+      region-count range and returns the count)
+    - The generic ``min_hdr_len`` check already runs at region-completion
+      time from Patch 1
 
 Patch 5: Fix generic safety issues
     - ``add_to_cont_trans``: check ``ri_cnt > 0`` and ``ri_buf != NULL``
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 1fef69ec918c..dbb4bb5c57ad 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -11,6 +11,7 @@
  * define how recovery should work for that type of log item.
  */
 struct xlog_recover_item;
+struct xlog_recover;
 struct xfs_defer_op_type;
 
 /* Sorting hat for log items as they're read in. */
@@ -24,6 +25,24 @@ enum xlog_recover_reorder {
 struct xlog_recover_item_ops {
 	uint16_t	item_type;	/* XFS_LI_* type code. */
 
+	/*
+	 * Minimum valid length of the item's format header (ri_buf[0]). Checked
+	 * as the item is decoded from the journal before the region data is
+	 * trusted. A value of 0 means no minimum header length is enforced.
+	 */
+	uint16_t	min_hdr_len;
+
+	/*
+	 * Validate the region count read from the front of the item's first
+	 * region and return the number of regions to assemble for the item.
+	 * The returned count is used to size ri_buf and to detect item
+	 * completion, so it need not equal the raw on-disk value (the
+	 * transaction header, for example, ignores it and always returns 1).
+	 * Returns a negative error (e.g. -EFSCORRUPTED) if the count is
+	 * invalid. Types that do not supply this use xlog_recover_nregions().
+	 */
+	int (*validate_nregions)(struct xlog *log, uint16_t nregions);
+
 	/*
 	 * Help sort recovered log items into the order required to replay them
 	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
@@ -58,8 +77,42 @@ struct xlog_recover_item_ops {
 	 */
 	int (*commit_pass2)(struct xlog *log, struct list_head *buffer_list,
 			    struct xlog_recover_item *item, xfs_lsn_t lsn);
+
+	/*
+	 * Validate a single region of the item once it has been fully
+	 * assembled from the journal.  Called with the index of the region to
+	 * check.  Returns 0 if the region is valid or a negative error (e.g.
+	 * -EFSCORRUPTED) if it is not.  Optional.
+	 */
+	int (*validate_region)(struct xlog *log,
+			       struct xlog_recover_item *item,
+			       int region_index);
+
+	/*
+	 * Validate the whole item once all of its regions have been assembled
+	 * from the journal.  Used for cross-region structural checks that can
+	 * only be done with the complete item.  Returns 0 if the item is valid
+	 * or a negative error (e.g. -EFSCORRUPTED) if it is not.  Optional.
+	 */
+	int (*validate_item)(struct xlog *log,
+			     struct xlog_recover_item *item);
+
+	/*
+	 * Dispose of the item once it has been fully assembled and validated,
+	 * instead of the default of queuing it on the transaction for replay.
+	 * Used by pseudo-items that are consumed during decode rather than
+	 * replayed (e.g. the transaction header, which is copied into the
+	 * transaction).  Returns XLOG_RECOVER_ITEM_CONSUMED if it took
+	 * ownership of the item (the caller then frees it), 0 to fall back to
+	 * the default queuing, or a negative error.  Optional.
+	 */
+	int (*complete)(struct xlog *log, struct xlog_recover *trans,
+			struct xlog_recover_item *item);
 };
 
+/* ->complete() took ownership of the item; do not queue it for replay. */
+#define XLOG_RECOVER_ITEM_CONSUMED	1
+
 extern const struct xlog_recover_item_ops xlog_icreate_item_ops;
 extern const struct xlog_recover_item_ops xlog_buf_item_ops;
 extern const struct xlog_recover_item_ops xlog_inode_item_ops;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index f569fa2fa9e2..7ed6616f7075 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1829,12 +1829,12 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 
 static const struct xlog_recover_item_ops *
 xlog_find_item_ops(
-	struct xlog_recover_item		*item)
+	uint16_t				item_type)
 {
 	unsigned int				i;
 
 	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
-		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
+		if (xlog_recover_item_ops[i]->item_type == item_type)
 			return xlog_recover_item_ops[i];
 
 	return NULL;
@@ -1916,15 +1916,6 @@ xlog_recover_reorder_trans(
 			break;
 		}
 
-		item->ri_ops = xlog_find_item_ops(item);
-		if (!item->ri_ops) {
-			xfs_warn(log->l_mp,
-				"%s: unrecognized type of log operation (%d)",
-				__func__, ITEM_TYPE(item));
-			error = -EFSCORRUPTED;
-			break;
-		}
-
 		if (item->ri_ops->reorder)
 			fate = item->ri_ops->reorder(item);
 
@@ -2097,37 +2088,171 @@ xlog_recover_commit_trans(
 	return error;
 }
 
+/*
+ * Generic region count validation for item types that do not supply their own
+ * ->validate_nregions() method. Any non-zero count up to the maximum an item
+ * can hold is accepted, and the count is used as-is.
+ */
+static int
+xlog_recover_nregions(
+	struct xlog		*log,
+	uint16_t		nregions)
+{
+	if (nregions == 0 || nregions > XLOG_MAX_REGIONS_IN_ITEM) {
+		xfs_warn(log->l_mp,
+	"bad number of regions (%d) in inode log format", nregions);
+		return -EFSCORRUPTED;
+	}
+	return nregions;
+}
+
+/*
+ * Start decoding a new log item. The item type and region count come from the
+ * type/size fields at the front of the item's first region. Look up the item
+ * ops from the type, validate the region count, then allocate and initialise
+ * the item.
+ *
+ * Returns the new item, which becomes the item currently being rebuilt, or an
+ * ERR_PTR() if the type is unknown or the region count is invalid. The item is
+ * not placed on the transaction's item queue until it has been fully decoded
+ * (see xlog_recover_complete_item()).
+ */
 STATIC struct xlog_recover_item *
 xlog_recover_add_item(
-	struct xlog_recover	*trans)
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	uint16_t		item_type,
+	uint16_t		nregions)
 {
+	const struct xlog_recover_item_ops *ops;
 	struct xlog_recover_item *item;
+	int			valid_nregions;
 
-	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
-	INIT_LIST_HEAD(&item->ri_list);
+	ops = xlog_find_item_ops(item_type);
+	if (!ops) {
+		xfs_warn(log->l_mp,
+			"%s: unrecognized type of log operation (0x%x)",
+			__func__, item_type);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	/*
-	 * The item is not placed on the transaction's item queue until it has
-	 * been fully decoded (see xlog_recover_complete_item()). Until then it
-	 * is tracked as the item currently being rebuilt.
+	 * Validate the region count and determine how many regions to assemble
+	 * for the item. The type may override the raw count (e.g. the
+	 * transaction header always has a single region).
 	 */
+	if (ops->validate_nregions)
+		valid_nregions = ops->validate_nregions(log, nregions);
+	else
+		valid_nregions = xlog_recover_nregions(log, nregions);
+	if (valid_nregions < 0)
+		return ERR_PTR(valid_nregions);
+
+	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
+	INIT_LIST_HEAD(&item->ri_list);
+	item->ri_ops = ops;
+	item->ri_total = valid_nregions;
+	item->ri_buf = kzalloc_objs(*item->ri_buf, item->ri_total,
+				    GFP_KERNEL | __GFP_NOFAIL);
+
 	trans->r_cur_item = item;
 	return item;
 }
 
 /*
- * A log item has been fully decoded from the journal. Move it onto the
- * transaction's item queue and clear the current item so the next region
- * decoded starts a new item.
+ * Free up any resources allocated by the transaction
+ *
+ * Remember that EFIs, EFDs, and IUNLINKs are handled later.
  */
 static void
+xlog_recover_free_item(
+	struct xlog_recover_item *item)
+{
+	int			i;
+
+	/* Free the regions in the item. */
+	for (i = 0; i < item->ri_cnt; i++)
+		kvfree(item->ri_buf[i].iov_base);
+	/* Free the item itself */
+	kfree(item->ri_buf);
+	kfree(item);
+}
+
+/*
+ * A log item has been fully decoded from the journal. Validate the assembled
+ * item, then move it onto the transaction's item queue and clear the current
+ * item so the next region decoded starts a new item.
+ *
+ * A type may instead consume the item during decode via its ->complete()
+ * method, in which case it is freed here rather than queued for replay.
+ */
+static int
 xlog_recover_complete_item(
+	struct xlog		*log,
 	struct xlog_recover	*trans)
 {
 	struct xlog_recover_item *item = trans->r_cur_item;
+	int			error;
+
+	if (item->ri_ops->validate_item) {
+		error = item->ri_ops->validate_item(log, item);
+		if (error)
+			return error;
+	}
+
+	if (item->ri_ops->complete) {
+		error = item->ri_ops->complete(log, trans, item);
+		if (error < 0)
+			return error;
+		if (error == XLOG_RECOVER_ITEM_CONSUMED) {
+			xlog_recover_free_item(item);
+			trans->r_cur_item = NULL;
+			return 0;
+		}
+	}
 
 	list_add_tail(&item->ri_list, &trans->r_itemq);
 	trans->r_cur_item = NULL;
+	return 0;
+}
+
+/*
+ * A region of the current item has been fully assembled from the journal.
+ * Validate it, and if it is the last region of the item complete the item.
+ * Called only when the region is complete (not a partial continuation).
+ */
+static int
+xlog_recover_complete_region(
+	struct xlog		*log,
+	struct xlog_recover	*trans)
+{
+	struct xlog_recover_item *item = trans->r_cur_item;
+	int			error;
+
+	/*
+	 * The format header (region 0) must be at least the minimum size for
+	 * the item type. This is checked here, once the region is complete, so
+	 * a partial first fragment is not rejected while still being assembled.
+	 */
+	if (item->ri_cnt == 1 && item->ri_ops->min_hdr_len &&
+	    item->ri_buf[0].iov_len < item->ri_ops->min_hdr_len) {
+		xfs_warn(log->l_mp,
+	"log item type 0x%x header too short (%zu < %u)",
+			item->ri_ops->item_type, item->ri_buf[0].iov_len,
+			item->ri_ops->min_hdr_len);
+		return -EFSCORRUPTED;
+	}
+
+	if (item->ri_ops->validate_region) {
+		error = item->ri_ops->validate_region(log, item,
+						      item->ri_cnt - 1);
+		if (error)
+			return error;
+	}
+
+	if (item->ri_cnt == item->ri_total)
+		return xlog_recover_complete_item(log, trans);
+	return 0;
 }
 
 /*
@@ -2216,11 +2341,10 @@ xlog_recover_add_to_cont_trans(
 
 	/*
 	 * The continued region is only complete once its final fragment has
-	 * been appended. When that finishes the item's last region, the item is
-	 * complete.
+	 * been appended; until then it cannot be validated.
 	 */
-	if (region_complete && item->ri_cnt == item->ri_total)
-		xlog_recover_complete_item(trans);
+	if (region_complete)
+		return xlog_recover_complete_region(log, trans);
 	return 0;
 }
 
@@ -2247,6 +2371,7 @@ xlog_recover_add_to_trans(
 {
 	struct xlog_recover_item *item;
 	char			*ptr;
+	int			error;
 
 	if (!len)
 		return 0;
@@ -2256,37 +2381,32 @@ xlog_recover_add_to_trans(
 
 	/*
 	 * If there is no item currently being rebuilt, this region is the first
-	 * region of a new item. Start the item and use its first region to
-	 * determine how many regions it has.
+	 * region of a new item. The type and region count are at the front of
+	 * the region; start the item from them. ptr is still standalone here,
+	 * so on error it just needs to be freed (out_free). Per-region size
+	 * validation (including min_hdr_len) happens once the region is
+	 * complete, below, because this first region may only be a partial
+	 * fragment here.
 	 */
 	item = trans->r_cur_item;
 	if (!item) {
 		struct xfs_inode_log_format *in_f = /* any will do */
 			(struct xfs_inode_log_format *)ptr;
 
-		if (in_f->ilf_size == 0 ||
-		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
-			xfs_warn(log->l_mp,
-		"bad number of regions (%d) in inode log format",
-				  in_f->ilf_size);
-			ASSERT(0);
-			kvfree(ptr);
-			return -EFSCORRUPTED;
+		item = xlog_recover_add_item(log, trans, in_f->ilf_type,
+					     in_f->ilf_size);
+		if (IS_ERR(item)) {
+			error = PTR_ERR(item);
+			goto out_free;
 		}
-
-		item = xlog_recover_add_item(trans);
-		item->ri_total = in_f->ilf_size;
-		item->ri_buf = kzalloc_objs(*item->ri_buf, item->ri_total,
-					    GFP_KERNEL | __GFP_NOFAIL);
 	}
 
-	if (item->ri_total <= item->ri_cnt) {
+	if (item->ri_cnt >= item->ri_total) {
 		xfs_warn(log->l_mp,
 	"log item region count (%d) overflowed size (%d)",
 				item->ri_cnt, item->ri_total);
-		ASSERT(0);
-		kvfree(ptr);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto out_free;
 	}
 
 	/* Description region is ri_buf[0] */
@@ -2296,32 +2416,18 @@ xlog_recover_add_to_trans(
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
 
 	/*
-	 * The item is complete once its final region has been fully decoded. If
-	 * this region continues into the next op record it is not complete yet,
-	 * so the item cannot be either.
+	 * A region that continues into the next op record is not yet complete
+	 * and cannot be validated until the continuation finishes assembling
+	 * it. ptr is now owned by the item, so the transaction teardown frees
+	 * it on any error from here.
 	 */
-	if (region_complete && item->ri_cnt == item->ri_total)
-		xlog_recover_complete_item(trans);
+	if (region_complete)
+		return xlog_recover_complete_region(log, trans);
 	return 0;
-}
-
-/*
- * Free up any resources allocated by the transaction
- *
- * Remember that EFIs, EFDs, and IUNLINKs are handled later.
- */
-static void
-xlog_recover_free_item(
-	struct xlog_recover_item *item)
-{
-	int			i;
 
-	/* Free the regions in the item. */
-	for (i = 0; i < item->ri_cnt; i++)
-		kvfree(item->ri_buf[i].iov_base);
-	/* Free the item itself */
-	kfree(item->ri_buf);
-	kfree(item);
+out_free:
+	kvfree(ptr);
+	return error;
 }
 
 STATIC void
-- 
2.55.0

