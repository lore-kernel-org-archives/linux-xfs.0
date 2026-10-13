Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351F3C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871349; cv=none; b=h0BuSCq+86Bpn0kvwCDVq9uPN54Elgba/x5xwfwjWclux30WmR/o4thJXxVS4W1onBFytNFg08hJbb3cVHPLNd2rz3+q/36YqzeKzHZmewMgVgLIQ0VyUCFXSHkAYjq2g3bBtg9LXsKjvSqCPvkQmXtMZ2HI5svvNdU2ZhoF9N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871349; c=relaxed/simple;
	bh=4mTtHr1QJnwbFAupyBNglfDEHYuf/7sdkI4mE1UmtJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6esrFkSaMDQifC+vAnPQDdQipCzZLGfKtymnWzDSnr1Ak6ph8MZoezGkdTQD4SRv1QmKHBKfWytRZzSfMkeW2i429VFMAhwgxrBRY6DNfx6/aGHkPikG2PrbCK6G0yKt/13ykm7BbeRNEb5/qjW5+hu9z4vRoHwIrFxEceliFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8wpTbSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8wpTbSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907D21F00893;
	Tue, 13 Oct 2026 06:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871348;
	bh=IPG/kfQX0MNi8OoW/9X3M7XJP4wYmG217N7yg2Rw1no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8wpTbSG6UMLPrp0Ni7TLkd72TTb/nJKzW+Llfc6doEo//BWRy90RFXBIPXfVHG1D
	 R+ndeh9kqtuVlPePYCw5CU0alODHmNjhS8tK3JQBs2yfCe8UXiBt30hIdvN8jjTx3Z
	 pkAXOcN0H/xoYadhdinGNywCTDG4I5iZTGQAJA1v+SEca07ROscIk5Zj45q6oSldtl
	 5b3/wxMuS/iziw3dcDdWiArhw0JnECfXMauVSj8YItBLz81re4wJAUtSTxZaJHZE/9
	 LZ0adHtdw+i5nQGhcabwX7/gGjI0TOM/DGjbb4OQFAgRf0gAxzussj5m3MCScnALL9
	 kq5qBEbOE8Bbg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 15/48] xfs: handle zero length continuation op headers during recovery
Date: Tue, 13 Oct 2026 17:01:05 +1100
Message-ID: <20261013060204.3138690-16-dgc@kernel.org>
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

Recovery has always had to cope with zero length op headers, but only ever
handled them as a special case in the bespoke transaction header decode.
Routing the transaction header through the generic item assembly dropped that
handling, so handle zero length continuation op headers generically for all
items instead.

A zero length op header that opens a new item carries nothing to decode, so
the item cannot be initialised until the continuation that follows arrives.
Leave a sentinel in r_cur_item for this case so the continuation is decoded as
the first region of the new item. Zero length op headers on subsequent regions
are handled naturally by the region iterator. A continuation that reaches the
append path with no item under assembly is now treated as a corrupt log.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  9 +++++++
 fs/xfs/xfs_log_recover.c        | 48 +++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index f4dbed616ee6..d2e128fca058 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -171,6 +171,15 @@ struct xlog_recover {
 	struct xlog_recover_item *r_cur_item;	/* item currently being rebuilt */
 };
 
+/*
+ * The current recovery item can sometimes start with a zero length continuation
+ * op header. In this case there is nothing to decode, so the recovery item
+ * cannot be initialised yet. Leave this sentinel in r_cur_item instead so the
+ * continuation initialises the recovery item from the start of the continued
+ * region data.
+ */
+#define XLOG_RECOVER_CONT_ITEM	((struct xlog_recover_item *)1UL)
+
 #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].iov_base)
 
 #define	XLOG_RECOVER_CRCPASS	0
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 37b5dbc3b239..90f841bf0aa5 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2393,6 +2393,18 @@ xlog_recover_add_to_cont_trans(
 	char			*ptr, *old_ptr;
 	int			old_len;
 
+	/*
+	 * A continuation must append to a region under assembly. The only valid
+	 * way to reach here without one is a region opened by a zero length op
+	 * header, which the dispatch in xlog_recovery_process_trans() routes to
+	 * xlog_recover_add_to_trans() instead. So no current item here means the
+	 * log is corrupt.
+	 */
+	if (!item) {
+		xfs_warn(log->l_mp, "%s: continuation with no item", __func__);
+		return -EFSCORRUPTED;
+	}
+
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
@@ -2438,8 +2450,17 @@ xlog_recover_add_to_trans(
 	char			*ptr;
 	int			error;
 
-	if (!len)
+	/*
+	 * A zero length region that opens a new item has nothing we can decode.
+	 * Leave a sentinel in r_cur_item so that xlog_recover_process_trans()
+	 * will call here again with the continuation that carries the data we
+	 * need to initialise the recovery item.
+	 */
+	if (!len) {
+		if (!trans->r_cur_item)
+			trans->r_cur_item = XLOG_RECOVER_CONT_ITEM;
 		return 0;
+	}
 
 	ptr = xlog_kvmalloc(len);
 	memcpy(ptr, dp, len);
@@ -2454,7 +2475,7 @@ xlog_recover_add_to_trans(
 	 * fragment here.
 	 */
 	item = trans->r_cur_item;
-	if (!item) {
+	if (!item || item == XLOG_RECOVER_CONT_ITEM) {
 		struct xfs_inode_log_format *in_f = /* any will do */
 			(struct xfs_inode_log_format *)ptr;
 
@@ -2510,9 +2531,10 @@ xlog_recover_free_trans(
 
 	/*
 	 * An item still being rebuilt has not been added to the item queue yet,
-	 * so free it separately.
+	 * so free it separately. The sentinel is not a real item and has nothing
+	 * to free.
 	 */
-	if (trans->r_cur_item)
+	if (trans->r_cur_item && trans->r_cur_item != XLOG_RECOVER_CONT_ITEM)
 		xlog_recover_free_item(trans->r_cur_item);
 
 	/* Free the transaction recover structure */
@@ -2557,15 +2579,25 @@ xlog_recovery_process_trans(
 	 */
 	switch (flags) {
 	/* expected flag values */
+	case XLOG_WAS_CONT_TRANS:
+		/*
+		 * A continuation appends to the region under assembly, unless
+		 * the region was opened by a zero length op header. In that case
+		 * r_cur_item holds the sentinel and this continuation carries
+		 * the first data of the region, so fall through and decode it as
+		 * the first region of a new item.
+		 */
+		if (trans->r_cur_item != XLOG_RECOVER_CONT_ITEM) {
+			error = xlog_recover_add_to_cont_trans(log, trans, dp,
+							len, region_complete);
+			break;
+		}
+		fallthrough;
 	case 0:
 	case XLOG_CONTINUE_TRANS:
 		error = xlog_recover_add_to_trans(log, trans, dp, len,
 						  region_complete);
 		break;
-	case XLOG_WAS_CONT_TRANS:
-		error = xlog_recover_add_to_cont_trans(log, trans, dp, len,
-						       region_complete);
-		break;
 	case XLOG_COMMIT_TRANS:
 		error = xlog_recover_commit_trans(log, trans, pass,
 						  buffer_list);
-- 
2.55.0

