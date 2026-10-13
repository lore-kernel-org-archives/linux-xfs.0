Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548933BCD2B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871338; cv=none; b=bpDY8CgFEhb/91qfrvRdh75MZs7XGFo7ot9FUaAtR0ItbJPGQLmzzou/qGPNuuDuBueaCg9G5dVz73BIBwbnA/boSvb0UF6OO8i6nTh9RUM+gdqHnezrdfd2LG4/94X3GXDtynl9WaJDuAY5yZV5LhS5OIYi30oXU3vwGNTneB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871338; c=relaxed/simple;
	bh=XDM/RQtArT+AXRX2j1yEQOW3ZncxvcDcsLPwOHpYGww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWiAW5D3EdVMYxMH3r46lnNzoI1UOAxO1iLYgJ6UBmlIMkWFNphzdT/4mkHvUPhCQrmUU2M4ioyeMN4YxDwJqIXlwOqqWO1htoNFzTIOO3w0aa0gZbXi38BwrqCVf5X+elM0MEBH2qwbvDcqfkCfHWqkzDHEyqCUkLEjymkovBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9uhOMs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9uhOMs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7C31F00893;
	Tue, 13 Oct 2026 06:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871337;
	bh=Xamvwi+tlbB7TBYwvkrwTZbwYMJMlkDmckShnhn/+FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9uhOMs1igKE2OlNe12rnhAXzBrSJXD2w24OYW0fs4xz0PJRr+qKKHBg9OTAfEJiQ
	 a88Rk6KnnTDs8+hIekwddGS4fJSTY81hRnrS7FySy1+DgMTB0TUjylI6PdwamS1oKb
	 uzCNAwxmFgh4QsvEllzv9ifLXqdYYg2tBmTvaJKtIQh0Vdrt8aX7Ro8hsLA5lQSbO/
	 rNCgUPIAIXpGEB1/uU2W4us1up0MuW0s9G2RbLBs/PeCgv300MoLeYTCAhQKc0jk6/
	 HMklkN9xHbagfIoJzz0xyqjgmqljcQoyFm3u+z+RAJVw5UP5iaZv6N0w+raIGVFVe7
	 rHJARjApPDrYw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 06/48] xfs: complete log items explicitly during recovery
Date: Tue, 13 Oct 2026 17:00:56 +1100
Message-ID: <20261013060204.3138690-7-dgc@kernel.org>
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

Log item completion during recovery was detected lazily: an item was added
to the transaction item queue as soon as its first region arrived, and the
code only noticed the item was full when the next region turned up and found
the current item's region count had reached its total.

Rework this into explicit item start and completion. An item is now created
off the item queue (xlog_recover_add_item() no longer links it) and tracked
only via r_cur_item while it is being rebuilt. When its final region has been
fully decoded the item is moved onto the item queue and r_cur_item is cleared
by xlog_recover_complete_item(); the next region decoded then finds no
current item and starts a new one.

Region completion is driven by a new region_complete argument, derived from
XLOG_CONTINUE_TRANS in xlog_recovery_process_trans() before the container
flags are masked. A region (and hence potentially its item) is only complete
once it is not a partial continuation fragment. This replaces the previous
implicit "item is done because its region count matched" detection with
explicit last-region state, and lets both xlog_recover_add_to_trans() and
xlog_recover_add_to_cont_trans() complete an item at the point its final
region finishes.

The transaction header is a single region, so it is now marked decoded when
its region completes rather than via a length comparison, and it no longer
creates a placeholder item for the first log item to reuse. As a result the
first log item region always starts a fresh item, so the first-region setup
(reading ilf_size and allocating ri_buf) moves entirely into the
new-item path and the ri_total == 0 special case goes away.

Because an item being rebuilt is no longer on the item queue,
xlog_recover_free_trans() also frees a non-NULL r_cur_item. The per-item
teardown is factored into xlog_recover_free_item() for reuse.

Changes:
- xlog_recover_add_item() no longer links the item to the queue
- Add xlog_recover_complete_item() to push a finished item and clear
  r_cur_item
- Plumb a region_complete flag into init_new_trans/add_to_trans/
  add_to_cont_trans and complete items when their final region finishes
- Mark the transaction header decoded on region completion; drop its
  placeholder item and the first-region ri_total == 0 handling
- Factor xlog_recover_free_item() and free a dangling r_cur_item in
  xlog_recover_free_trans()

Created-by-AI: Claude Opus 4.8 (1M context)

Prompt: The fourth patch is reworking add_to_trans/cont_trans to change the
way the items are added to the list (i.e. from 'add next at end of current'
to 'add at end of current, clear r_cur_item, next sees r_cur_item == NULL so
creates new'). [Refactor patch 4 of 4.]

Refinements:
- Moved the first-region ilf_size/ri_buf setup entirely into the
  no-current-item branch and removed the now-impossible ri_total == 0 case.
- Drove header and item completion off an explicit region_complete flag
  rather than length/region-count heuristics.
---
 fs/xfs/xfs_log_recover.c | 128 +++++++++++++++++++++++++++++----------
 1 file changed, 96 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0c19bce1d334..f569fa2fa9e2 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2105,13 +2105,31 @@ xlog_recover_add_item(
 
 	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&item->ri_list);
-	list_add_tail(&item->ri_list, &trans->r_itemq);
 
-	/* this is now the item being rebuilt */
+	/*
+	 * The item is not placed on the transaction's item queue until it has
+	 * been fully decoded (see xlog_recover_complete_item()). Until then it
+	 * is tracked as the item currently being rebuilt.
+	 */
 	trans->r_cur_item = item;
 	return item;
 }
 
+/*
+ * A log item has been fully decoded from the journal. Move it onto the
+ * transaction's item queue and clear the current item so the next region
+ * decoded starts a new item.
+ */
+static void
+xlog_recover_complete_item(
+	struct xlog_recover	*trans)
+{
+	struct xlog_recover_item *item = trans->r_cur_item;
+
+	list_add_tail(&item->ri_list, &trans->r_itemq);
+	trans->r_cur_item = NULL;
+}
+
 /*
  * Decode the transaction header at the start of a new transaction.
  *
@@ -2127,7 +2145,8 @@ xlog_recover_init_new_trans(
 	struct xlog_recover	*trans,
 	char			*dp,
 	int			len,
-	bool			cont)
+	bool			cont,
+	bool			region_complete)
 {
 	char			*ptr;
 
@@ -2162,16 +2181,13 @@ xlog_recover_init_new_trans(
 	memcpy(ptr, dp, len);
 
 	/*
-	 * The header is complete once the full struct has been assembled: for
-	 * an unsplit header that is this initial fragment (len == full header),
-	 * and for a split header it is the continuation fragment that finishes
-	 * it. Mark it decoded and add the item that subsequent log item regions
-	 * will be decoded into.
+	 * The transaction header is a single region, so it is fully decoded
+	 * once the region is complete. The header is not a log item, so nothing
+	 * is added to the item queue here; the first log item region decoded
+	 * after this will start the first item.
 	 */
-	if (cont || len == sizeof(struct xfs_trans_header)) {
+	if (region_complete)
 		trans->r_hdr_decoded = true;
-		xlog_recover_add_item(trans);
-	}
 	return 0;
 }
 
@@ -2180,7 +2196,8 @@ xlog_recover_add_to_cont_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
 	char			*dp,
-	int			len)
+	int			len,
+	bool			region_complete)
 {
 	struct xlog_recover_item *item = trans->r_cur_item;
 	char			*ptr, *old_ptr;
@@ -2196,6 +2213,14 @@ xlog_recover_add_to_cont_trans(
 	item->ri_buf[item->ri_cnt-1].iov_len += len;
 	item->ri_buf[item->ri_cnt-1].iov_base = ptr;
 	trace_xfs_log_recover_item_add_cont(log, trans, item, 0);
+
+	/*
+	 * The continued region is only complete once its final fragment has
+	 * been appended. When that finishes the item's last region, the item is
+	 * complete.
+	 */
+	if (region_complete && item->ri_cnt == item->ri_total)
+		xlog_recover_complete_item(trans);
 	return 0;
 }
 
@@ -2217,9 +2242,9 @@ xlog_recover_add_to_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
 	char			*dp,
-	int			len)
+	int			len,
+	bool			region_complete)
 {
-	struct xfs_inode_log_format	*in_f;			/* any will do */
 	struct xlog_recover_item *item;
 	char			*ptr;
 
@@ -2228,17 +2253,17 @@ xlog_recover_add_to_trans(
 
 	ptr = xlog_kvmalloc(len);
 	memcpy(ptr, dp, len);
-	in_f = (struct xfs_inode_log_format *)ptr;
 
-	/* the item currently being rebuilt */
+	/*
+	 * If there is no item currently being rebuilt, this region is the first
+	 * region of a new item. Start the item and use its first region to
+	 * determine how many regions it has.
+	 */
 	item = trans->r_cur_item;
-	if (item->ri_total != 0 &&
-	     item->ri_total == item->ri_cnt) {
-		/* current item is full, start a new one */
-		item = xlog_recover_add_item(trans);
-	}
+	if (!item) {
+		struct xfs_inode_log_format *in_f = /* any will do */
+			(struct xfs_inode_log_format *)ptr;
 
-	if (item->ri_total == 0) {		/* first region to be added */
 		if (in_f->ilf_size == 0 ||
 		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
 			xfs_warn(log->l_mp,
@@ -2249,6 +2274,7 @@ xlog_recover_add_to_trans(
 			return -EFSCORRUPTED;
 		}
 
+		item = xlog_recover_add_item(trans);
 		item->ri_total = in_f->ilf_size;
 		item->ri_buf = kzalloc_objs(*item->ri_buf, item->ri_total,
 					    GFP_KERNEL | __GFP_NOFAIL);
@@ -2268,6 +2294,14 @@ xlog_recover_add_to_trans(
 	item->ri_buf[item->ri_cnt].iov_len  = len;
 	item->ri_cnt++;
 	trace_xfs_log_recover_item_add(log, trans, item, 0);
+
+	/*
+	 * The item is complete once its final region has been fully decoded. If
+	 * this region continues into the next op record it is not complete yet,
+	 * so the item cannot be either.
+	 */
+	if (region_complete && item->ri_cnt == item->ri_total)
+		xlog_recover_complete_item(trans);
 	return 0;
 }
 
@@ -2276,24 +2310,40 @@ xlog_recover_add_to_trans(
  *
  * Remember that EFIs, EFDs, and IUNLINKs are handled later.
  */
+static void
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
 STATIC void
 xlog_recover_free_trans(
 	struct xlog_recover	*trans)
 {
 	struct xlog_recover_item *item, *n;
-	int			i;
 
 	hlist_del_init(&trans->r_list);
 
 	list_for_each_entry_safe(item, n, &trans->r_itemq, ri_list) {
-		/* Free the regions in the item. */
 		list_del(&item->ri_list);
-		for (i = 0; i < item->ri_cnt; i++)
-			kvfree(item->ri_buf[i].iov_base);
-		/* Free the item itself */
-		kfree(item->ri_buf);
-		kfree(item);
+		xlog_recover_free_item(item);
 	}
+
+	/*
+	 * An item still being rebuilt has not been added to the item queue yet,
+	 * so free it separately.
+	 */
+	if (trans->r_cur_item)
+		xlog_recover_free_item(trans->r_cur_item);
+
 	/* Free the transaction recover structure */
 	kfree(trans);
 }
@@ -2313,6 +2363,17 @@ xlog_recovery_process_trans(
 {
 	int			error = 0;
 	bool			freeit = false;
+	bool			region_complete;
+
+	/*
+	 * If XLOG_CONTINUE_TRANS is set the current region is only a partial
+	 * fragment that continues into the next op record, so it cannot be
+	 * completed yet. The region is complete once this flag is clear, which
+	 * is the case for both an unsplit region and the final (XLOG_END_TRANS)
+	 * fragment of a split region. Capture this before the flags are masked
+	 * below.
+	 */
+	region_complete = !(flags & XLOG_CONTINUE_TRANS);
 
 	/* mask off ophdr transaction container flags */
 	flags &= ~XLOG_END_TRANS;
@@ -2330,7 +2391,8 @@ xlog_recovery_process_trans(
 	if (!trans->r_hdr_decoded &&
 	    (!flags || (flags & (XLOG_CONTINUE_TRANS | XLOG_WAS_CONT_TRANS)))) {
 		error = xlog_recover_init_new_trans(log, trans, dp, len,
-					flags & XLOG_WAS_CONT_TRANS);
+					flags & XLOG_WAS_CONT_TRANS,
+					region_complete);
 		goto out_error;
 	}
 
@@ -2342,10 +2404,12 @@ xlog_recovery_process_trans(
 	/* expected flag values */
 	case 0:
 	case XLOG_CONTINUE_TRANS:
-		error = xlog_recover_add_to_trans(log, trans, dp, len);
+		error = xlog_recover_add_to_trans(log, trans, dp, len,
+						  region_complete);
 		break;
 	case XLOG_WAS_CONT_TRANS:
-		error = xlog_recover_add_to_cont_trans(log, trans, dp, len);
+		error = xlog_recover_add_to_cont_trans(log, trans, dp, len,
+						       region_complete);
 		break;
 	case XLOG_COMMIT_TRANS:
 		error = xlog_recover_commit_trans(log, trans, pass,
-- 
2.55.0

