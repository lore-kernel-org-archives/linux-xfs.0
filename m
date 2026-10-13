Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515AF30ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871337; cv=none; b=lJUNeFIGcJ7SSmfwqgYlHjdIwoHTddzfxKupGsSqEEqPPxHjAmu/+Z+bSuUmWyUxl3MhUFGugQkLzy5u6X9Z3GqMos+f8a1g03N6mcgDtEe2i+61q/jKVB/p4SeQZRz3uRM3SnocsyRt2N+csMxOIcNvdTBLm4YPs21r5T+bJqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871337; c=relaxed/simple;
	bh=mfOxhS6Id2/DFatifODdcromKgvbqA3qcUOK/FeTM2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuldhWVOW+rnIizmch98xk6o2d+ZOdFrAV2IQNaD4TfCdSTcEwJtGcUqtGsSvONAB23thOLVDcRF7UcpITLN/K733dbkiT1yXR2EvR0KI9q25q3PodgMbTP/bln6qIl42FnoG8GNKvxgxgjNVhcnTLItDk6LDk0VsgZZizj1KeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CB2hV3D9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CB2hV3D9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448151F000FF;
	Tue, 13 Oct 2026 06:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871336;
	bh=qN5fA8wYI96YxoJArp1h9BU63nvx2O6yLslHxt9z+Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB2hV3D9LFtjccwm2+im4NGwGKmfjBdIQbzZMZJKcPNahIUaWk/ssVII8fJ2u/vl6
	 BGDGFXXthuJ+rcuRUC/bCwmef9fauGQ3cPXEIL6pvQPfeYFnz1vAT5Zb1SGyr9qlnM
	 0txv/c813teXzFnLgYvcWJEfAPvOiW6MYoH7w06Wp52UrFFN9CUbT7BMwTFD5ReSLn
	 Hqd3/63BC5XhC4lQt+woCOp3n6ulJkQXJWM2Ypm6GSf1fdrPYsQeVYKzTOIU4XHvG4
	 rmYyYNPOHzlvVRu9hk7nzNMHPj56zX4n2A668bUFIneuJdFNuhxqZavI/X5RYFSIGx
	 siavuVe/EJkZQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 05/48] xfs: track the log item being rebuilt with an explicit pointer
Date: Tue, 13 Oct 2026 17:00:55 +1100
Message-ID: <20261013060204.3138690-6-dgc@kernel.org>
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

The log item currently being reassembled from journal op records is found by
taking the tail entry of the transaction's item queue with
list_entry(trans->r_itemq.prev, ...). This is repeated in several places and
relies on the item being rebuilt always being the last one on the queue.

Track it explicitly instead. Add a struct xlog_recover_item *r_cur_item to
struct xlog_recover, have xlog_recover_add_item() record and return the item
it creates, and use trans->r_cur_item wherever the code previously fetched
the tail entry.

r_cur_item is zero-initialised to NULL when the transaction is allocated and
is set when the first item is added as the transaction header completes, so
it is always valid by the time log item regions are decoded. No functional
change.

Changes:
- Add r_cur_item to struct xlog_recover
- xlog_recover_add_item() now takes the trans, sets r_cur_item and returns
  the new item
- Replace list_entry(r_itemq.prev) lookups in xlog_recover_add_to_trans()
  and xlog_recover_add_to_cont_trans() with trans->r_cur_item

Created-by-AI: Claude Opus 4.8 (1M context)

Prompt: The third patch is adding r_cur_item to replace the
list_entry(.prev) mechanism for tracking the current item. [Refactor patch 3
of 4.] Refinement: have xlog_recover_add_item() return the new item.
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
index d5d19769c217..0c19bce1d334 100644
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

