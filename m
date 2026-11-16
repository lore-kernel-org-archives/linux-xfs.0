Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871056;
	b=qY9lJyitD0KaUf7ykl6gtQWGuDm93wiBpsBkh4AzW5Ts9Oa/2MGde3OkgscgGJjsSaSJ
	 ITGVAfYDGyEgcb17Ae8SYErDTviisw1+n/F4xDm4SMdaDcksDf919ZbB4G1NJGWj61d7Z
	 8H5qkXf4pluE+OfIicpwAVxASdYaJ4Js6zZoQtHMg4E68d4kVv6XxDQDfYJcqcNFGm/Ku
	 PtDYL2xf4W9gnpoNwTjZP7hWq3O/gx+JuZQmJXZe6ja8B16cCz0UG23zpmqSmcNItDehp
	 lNcjpWNOIbmOwy07SfWx9NA8Ibska+nHtLDKPOmo9m3/rXAj8Fxx5rbQc5RtP/sP3vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Df7OwdKUvaN49gaARXXkA6jU7maCRyn06eIa1Qe2xgY=;
	b=sUDO0HGLvhKM7X1kJiuiMCvN8sL/tc4VQhS24rWZjnJHlt+JC1nhn/xaWEWLJcJ9+G16
	 sG9UJqUARS6wUKoGuEE/ypnYpdFl/6iOy5Ly2UxFm9PncmD34aINSmc+5jS/9dwvQCKkC
	 tkrVxwJbPjlEHlcnihzvxMTRn7W+kPAjADCXjg4iuv4hS7vEFL++ecNMmgsFxfk6CPhZp
	 vGTWqOFJZfnO1If5WUU9aWbCKZdB5EnfkFQP5W+GmpifJwKwoJDPS0muA82H0mkCM0sYr
	 j37SYqCI4o4+BAy+4NqKll6/ELw1dyQqsyHONETuZNdTLyNQDxeSxVQ2svymSnnp6zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FiYMukT3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9CE606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FiYMukT3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631211F000C4;
	Mon, 16 Nov 2026 23:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871056;
	bh=Df7OwdKUvaN49gaARXXkA6jU7maCRyn06eIa1Qe2xgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FiYMukT3ba6z/jWPQfY1yIPVruoB01qk/ar1DWKoynfh9KCCBlZpOcNICyvVDKcR7
	 +TF5pXmnArhEw1wYKSKhYHp3SFjtttdY6RJfpO7b7+91MdTRaLdSWszwBOFNU9PmuN
	 I9wQg7nyevB9jugtFXHO7rXWfQLs1DIux4xWQ0k45brKRpnwN+81rQJW20cTvcCTUS
	 rIISaUGoQZr2RVaZ/WFe63aEbjdlzaDgDduq6ZDq39lDKcGVLoMEOmdiRP3j9+OQ6y
	 r1qvDS9iXHHRmARDU0HX0x1c9ZtmcPIphOjaKgV0chb0xN+g/+yCzleAMkpct1viqM
	 Gp9YO1p2pOKJA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 17/59] xfs: add log item validation infrastructure to log recovery
Date: Tue, 17 Nov 2026 10:14:34 +1100
Message-ID: <20261116231707.3625263-18-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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
 fs/xfs/libxfs/xfs_log_recover.h |  53 +++++++
 fs/xfs/xfs_log_recover.c        | 238 +++++++++++++++++++++++---------
 2 files changed, 225 insertions(+), 66 deletions(-)

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
index e5eca851d497..dee839b831b1 100644
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

