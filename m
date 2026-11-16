Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871055;
	b=bW1wvp/xJsfm+wj5YSVjP/qG9f/CFG4Mh/SNr3iZh/IbJel18YEEnzEOHwzDmfZHXQKZ
	 N1xIj5NAZNx4ewZk+Cn7AF4GkwHDtovbujPsqcLqDjs5AcTuzYKt9nzBTtcnDf/l5saA3
	 kMXmGIYdVDbCViXjYcAJ4X7s1FxYSjh88klSUinGv2qIUTYtAR8UefV+iC+A54vASAE3f
	 PLnx1JUqoSKRlwYawBpkn38L+1g+6vMXvpeoT5q/xPmQVbJzV6CrGTZmu9fw/k/qV2fbl
	 diYhIbSr/2u52g52umQPR3hXeJdWJGjpoFAi3DRJGdReyvaQGuOQvCoNLHSu0sHrGEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Vm5BpCfhtk4s54zGCBW1/ZD0vKxBfaltZri/OL04j4g=;
	b=P2M5Fgeox9fsCRzsPC2+uV9NvhCrYjfNuAF0TEoG0YS6RkCVh+9MqfQDVNwNmg40B93n
	 G/81WrFl1l9RBw4EdflKRETkMlDxSZatlDxoS22gnH/gpkzoXB9zHYNqpPVC50c32fKD1
	 XEP/+kOHssGmMsYkhB8zCUrdSylFl+wNvArUGj+XPBgTb7jU5j+hnkqeYYe0fspADDN1b
	 5UZGgariyUGwC6cT/lzJ9fPe7pDHboN7gu18iAFE+KHCf4CUxa7KI0q34BjWHetiMPLP8
	 XuhjilhkDn0EJh+xWp5P/wjuIedNxU1gKUgN7FXJoJ7DAD/8GhLShfsq0O1BBR44RWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cc55y6db;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A27606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cc55y6db
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334BD1F000C4;
	Mon, 16 Nov 2026 23:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871054;
	bh=Vm5BpCfhtk4s54zGCBW1/ZD0vKxBfaltZri/OL04j4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cc55y6dbFRz9P5qxFsnu2Oz+4oApIo0gRbC+tR79mL+UjhYPONrYV10eDZ2an19Us
	 86jF1fthgScCbwFqs5QSjNi3J+VCccihtB8D6LkZ99ltb4mcNwvvy6z4GT4ng2nN7Z
	 mSOsyC5tebSBEz6dfypQOLnsI2Ojo/D6h3Nmt4vQInv4z3/6JcYDBHntZnogq6aHPY
	 t164AEGfeUCx/PXzVRmQZQ4YgljlBM7aHwbk4wCP4kn14zWG55RickcOIxXx1mZroh
	 ZTq3GT/5vw4E1AUEdQ4sSQkBffMvYgtGtT92gAtd8tqF+9N/hZ2c+oZH6YQE1z9sMA
	 tCYxlNLW/3cmg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 16/59] xfs: complete log items explicitly during recovery
Date: Tue, 17 Nov 2026 10:14:33 +1100
Message-ID: <20261116231707.3625263-17-dgc@kernel.org>
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

Log recovery only noticed that an item was complete when the next region
arrived and found the current item's region count had reached its total. An
item was added to the transaction item queue as soon as its first region was
decoded, so a partially assembled item sat on the queue alongside complete
ones.

Rework item assembly so that items are started and completed explicitly. An
item being rebuilt is tracked only as the current item and is not on the item
queue. It is moved onto the queue once its final region has been fully
decoded, and the next region then starts a new item. Region completion is
taken from the continuation flags of each operation header, so an item
completes at the point its last region finishes rather than when the next
region turns up.

The transaction header is a single region, and it is now marked decoded when
that region completes. It no longer creates a placeholder item for the first
log item to reuse, so every log item starts from a fresh item.

The commit record is written after all the items in the transaction. An item
still being assembled when the commit record is seen means the transaction is
incomplete. Recovery now fails with a corruption error in that case, rather
than replaying the incomplete transaction.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 141 ++++++++++++++++++++++++++++++---------
 1 file changed, 109 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 404e27fe2337..e5eca851d497 100644
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
 
@@ -2342,12 +2404,27 @@ xlog_recovery_process_trans(
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
+		/*
+		 * The commit record is written after all items in the
+		 * transaction have been written to the journal. Hence we
+		 * should have completely processed all items in the
+		 * transaction before we see the commit record.
+		 */
+		if (trans->r_cur_item) {
+			xfs_warn(log->l_mp,
+	"%s: transaction 0x%x committed with an incomplete log item",
+				__func__, trans->r_log_tid);
+			error = -EFSCORRUPTED;
+			break;
+		}
 		error = xlog_recover_commit_trans(log, trans, pass,
 						  buffer_list);
 		/* success or fail, we are now done with this transaction. */
-- 
2.55.0

