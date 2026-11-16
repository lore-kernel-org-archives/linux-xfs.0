Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871053;
	b=dISHww3a85t4HOVAVJssjWYAlSZ+3gD24piGAT9gIMFnOLlmXzhuaJMm/AvmDSraAmfX
	 CcGFy3lpq/o7i5hpNUjdDML9+FI+6dOSaue9Ip6iImXLVD5hz7Pz0VHe4gM1wWzX5sRYd
	 As3r1RTj7LBt44krK7UMffgHttyrXCmw9opE1ZbzlvCSl9wjx26kG0GEvT/5KTxS80FZ8
	 eEkH2feyXb8k6sFF/F3JHwZeVQGGkTrQS3sT4fRGlR/Jkn2JQ/bfyZZCqdSGWyn48Z9wJ
	 zQOuTd/ha4yijQo69KuSfB+xYUUlV4XKd4CCMsmS9PCIyPm6VMCPpodvsMC7BpbmdIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DP5GYiLqiPFlWRJXgLp3ogEPY+o96Vj4qc9eXyZlJTs=;
	b=zqda3GoEt9bS0u56Gq9WCEAig55l8a/4In/jdv8L3DfQi90uUZeXoVkScUMjiYjXZnZm
	 OAzDVRyFeq3tB9tP+4PtnkX5UE/BoKY57Wx4Z5IxL+z4i1Kkrhg0LKV7S+lkCwMK14tJP
	 ZWbLbaS8ZuiccZZ0DpyT4tiHlQyhgI8OLsXAcToXRuduS1hs9l7np3Q4Kk4HnJdsSKncv
	 csKtVIcMU/+oD0azkU5llzvzZzT6PLPbYLlqiWfB9XHbZD95nMqTfEG3XEfMgaaXGJjEy
	 fxMPDPBHFiDpNtRW6VmXgq2wZRIMsPsk8XbM/42+uamuQrivg7v3fkPmKCdwQ4SCLfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CyiolbMZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7D6606A333
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CyiolbMZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5EF1F000C4;
	Mon, 16 Nov 2026 23:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871053;
	bh=DP5GYiLqiPFlWRJXgLp3ogEPY+o96Vj4qc9eXyZlJTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CyiolbMZDVmhoTwZt13poheLf1n/6iJl1F0DZ9/bi7gDd4skQolHEFsYvbL2zXoqx
	 aRXZiXYxJfZ0fwnE1BbleuVg4C7qhcszql6sUy5sXIMp8jB6pB0JpHXG6d4iyAZrIB
	 CkJCi0/qxKYroQFibFBG5SuqgDyRrPUXkZ19VMFU/wlRq9CagPQbALyHl2D1C5Eny0
	 eTwWq3zZhydVTSXzYl+S17ijBM5GVgFld6g8cLs/canYjfgvtVzU+dPin3XbL8IDqL
	 PNYdevEjc81WaDzu9L5GUH339UN5EZdurfFpCpY9DkxQqGasLXXhkipFy+bzHA1D9T
	 66coVUtbkFnbg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 15/59] xfs: track the log item being rebuilt with an explicit pointer
Date: Tue, 17 Nov 2026 10:14:32 +1100
Message-ID: <20261116231707.3625263-16-dgc@kernel.org>
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

Recovery finds the log item being reassembled from op records by taking the
tail entry of the transaction item queue. This lookup is open coded in several
places. It relies on the item being rebuilt always being the last one on the
queue.

Track the current item with an explicit pointer in the recovery transaction
instead. Adding an item now records it as the current item and returns it to
the caller. The pointer is set when the transaction header completes, so it is
valid before any log item region is decoded. There is no functional change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 +
 fs/xfs/xfs_log_recover.c        | 29 +++++++++++++----------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ad73a1a6abf8..1fef69ec918c 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -116,6 +116,7 @@ struct xlog_recover {
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */
 	bool			r_hdr_decoded;	/* trans header fully decoded */
+	struct xlog_recover_item *r_cur_item;	/* item currently being rebuilt */
 };
 
 #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].iov_base)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c50f85757216..404e27fe2337 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2097,15 +2097,19 @@ xlog_recover_commit_trans(
 	return error;
 }
 
-STATIC void
+STATIC struct xlog_recover_item *
 xlog_recover_add_item(
-	struct list_head	*head)
+	struct xlog_recover	*trans)
 {
 	struct xlog_recover_item *item;
 
 	item = kzalloc_obj(struct xlog_recover_item, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&item->ri_list);
-	list_add_tail(&item->ri_list, head);
+	list_add_tail(&item->ri_list, &trans->r_itemq);
+
+	/* this is now the item being rebuilt */
+	trans->r_cur_item = item;
+	return item;
 }
 
 /*
@@ -2166,7 +2170,7 @@ xlog_recover_init_new_trans(
 	 */
 	if (cont || len == sizeof(struct xfs_trans_header)) {
 		trans->r_hdr_decoded = true;
-		xlog_recover_add_item(&trans->r_itemq);
+		xlog_recover_add_item(trans);
 	}
 	return 0;
 }
@@ -2178,14 +2182,10 @@ xlog_recover_add_to_cont_trans(
 	char			*dp,
 	int			len)
 {
-	struct xlog_recover_item *item;
+	struct xlog_recover_item *item = trans->r_cur_item;
 	char			*ptr, *old_ptr;
 	int			old_len;
 
-	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
-			  ri_list);
-
 	old_ptr = item->ri_buf[item->ri_cnt-1].iov_base;
 	old_len = item->ri_buf[item->ri_cnt-1].iov_len;
 
@@ -2230,15 +2230,12 @@ xlog_recover_add_to_trans(
 	memcpy(ptr, dp, len);
 	in_f = (struct xfs_inode_log_format *)ptr;
 
-	/* take the tail entry */
-	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
-			  ri_list);
+	/* the item currently being rebuilt */
+	item = trans->r_cur_item;
 	if (item->ri_total != 0 &&
 	     item->ri_total == item->ri_cnt) {
-		/* tail item is in use, get a new one */
-		xlog_recover_add_item(&trans->r_itemq);
-		item = list_entry(trans->r_itemq.prev,
-					struct xlog_recover_item, ri_list);
+		/* current item is full, start a new one */
+		item = xlog_recover_add_item(trans);
 	}
 
 	if (item->ri_total == 0) {		/* first region to be added */
-- 
2.55.0

