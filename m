Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871051;
	b=KOgtlAh7YaEQIn/TJVnwiOukq7HrdmsU4lm48rHGRNUftA7bTRhrQxWHrsDAq5+N9tn6
	 iB84h+C0xR+w0FxB2FYzk+dUNbOqubmiiljfvakvpIZeWJanIXVuifW90DBYbRZH5k+6n
	 tVPKzS8Oc3GVAfT45KpQgf5YIbKwsdXCfGp7UWY0U4tL3eZDG6A6iDeusf9pk9xkhWmSJ
	 ayTWfk6kuuYMvZKV1CDTDuWDJKNmVoiAgdefOEoLo5IDEgDYKoixhx21pVZBfwN5SY7gP
	 M1klgTsTL1KTjlJBW8mJu1b7g4FQZJkncxmrHKnC+c04DdZuRlEgmzWC5HbDtRQIeSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=W8FHly6CvGMspDvbmx0et8aeYnC0kIh1/YKD+wH1U2Q=;
	b=DoYsaEUA1TVUUXaKTMxCHR3/rPvdQnnK4NS0/hdzWS1yWsu9dFCEK1XKi3pcQ5ctXWSG
	 9YXQ8s4YXz0v5I3s/p17dN0EmZOTi6iXZsqVqWRvyAE0vkIN2zlH3CvKdyXx3Q9PD7OIV
	 d0IOla66YXuorlyMV5Ej1mfQeujzON6PRSpuPYsk88ukhEPaP0HvNV+hWxUnJRcqMf9np
	 drl9Yu4pyRRp698enuX6BrjglT12gEVb6cZZrkbR6WYoDSs+NozExQVPPrzIA6SuKCuJF
	 KdPisF/Jxt2bKs7jmPuVUkJFnCO2mxA0BozOfwnrd3XdWaGoHI5tZk9WyqTG8HzZkkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HUjQo30y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3559F606A32F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HUjQo30y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596911F000C4;
	Mon, 16 Nov 2026 23:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871051;
	bh=W8FHly6CvGMspDvbmx0et8aeYnC0kIh1/YKD+wH1U2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUjQo30ysTsg1AXo5994LVruQjkJv7BggmxmjcE6wT6iVjVCHbfxSNk7/usyuSq7l
	 cEGMvLDlFprKPlRiXLkQBSP9cxE/IPLVjWoaiCEYIgt1ANwWGv4XVTcqwqdsYnk7xh
	 0HUE94geh1RU3/KycGif1S0cpzpbOLMpb0PaPgXrmTQtUet5gQBdBJIppzxqbhubqJ
	 0o8Ml4RVREerzsgWWzSv3ORgB1OMIrpekPrVsqwJOcResa5v/7n7GU4sVobn7xxixo
	 xJPoUjtg0LVJg3LnSCGRc1jVMvg2FSMVMf9XklZTdtKFP8It5nf1iSrjEY2STeCGEH
	 v8hd7br5QKCNQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 13/59] xfs: lift transaction header parsing out of the region assembly
Date: Tue, 17 Nov 2026 10:14:30 +1100
Message-ID: <20261116231707.3625263-14-dgc@kernel.org>
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

The transaction header at the start of a recovered transaction is not a log
item. Its parsing is tangled into the generic log item region assembly code.
Both region assembly functions carry a special case that decodes the header
instead of a log item region while the item queue is empty.

Move the header decoding into a single helper called before log item region
processing. The two header decode paths are merged, so the header length is
checked in one place. A header fragment must now be at least 4 bytes, the
minimum needed to read the magic number. The bad magic warning reports the
observed and expected values. The ASSERT(0) calls on the corruption paths are
removed so debug builds exercise the error paths.

The header is still reassembled in place. The first log item is still added
once the header is complete. Removing the header special cases allows the
region assembly functions to be simplified in following patches.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 113 +++++++++++++++++++++++++--------------
 1 file changed, 73 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fd356b09f9d1..494bf5ebfa7b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2108,35 +2108,76 @@ xlog_recover_add_item(
 	list_add_tail(&item->ri_list, head);
 }
 
+/*
+ * Decode the transaction header at the start of a new transaction.
+ *
+ * The transaction header is not a log item. It can be arbitrarily split across
+ * op records, so it may arrive whole in a single op record, or as an initial
+ * fragment (cont == false) followed by one or more continuation fragments
+ * (cont == true). Reassemble it directly into r_theader where the rest of
+ * recovery expects to find it.
+ */
 STATIC int
-xlog_recover_add_to_cont_trans(
+xlog_recover_init_new_trans(
 	struct xlog		*log,
 	struct xlog_recover	*trans,
 	char			*dp,
-	int			len)
+	int			len,
+	bool			cont)
 {
-	struct xlog_recover_item *item;
-	char			*ptr, *old_ptr;
-	int			old_len;
+	char			*ptr;
 
 	/*
-	 * If the transaction is empty, the header was split across this and the
-	 * previous record. Copy the rest of the header.
+	 * All regions are 32 bit aligned, so the smallest valid fragment is 4
+	 * bytes; that is also the minimum needed to read the magic number. A
+	 * fragment larger than the whole header is corruption in either case.
 	 */
-	if (list_empty(&trans->r_itemq)) {
-		ASSERT(len <= sizeof(struct xfs_trans_header));
-		if (len > sizeof(struct xfs_trans_header)) {
-			xfs_warn(log->l_mp, "%s: bad header length", __func__);
+	if (len < 4 || len > sizeof(struct xfs_trans_header)) {
+		xfs_warn(log->l_mp, "%s: bad header length %d", __func__, len);
+		return -EFSCORRUPTED;
+	}
+
+	if (!cont) {
+		/*
+		 * Initial fragment. The magic number is at the start of the
+		 * header, which lands at the start of r_theader.
+		 */
+		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
+			xfs_warn(log->l_mp,
+			"%s: bad header magic number 0x%x, expected 0x%x",
+				__func__, *(uint *)dp, XFS_TRANS_HEADER_MAGIC);
 			return -EFSCORRUPTED;
 		}
-
-		xlog_recover_add_item(&trans->r_itemq);
+		ptr = (char *)&trans->r_theader;
+	} else {
+		/* continuation fragment completes the tail of the header */
 		ptr = (char *)&trans->r_theader +
 				sizeof(struct xfs_trans_header) - len;
-		memcpy(ptr, dp, len);
-		return 0;
 	}
 
+	/*
+	 * Add an item to the transaction once the header is complete: for an
+	 * unsplit header that is this initial fragment (len == full header),
+	 * and for a split header it is the continuation fragment that finishes
+	 * it.
+	 */
+	if (cont || len == sizeof(struct xfs_trans_header))
+		xlog_recover_add_item(&trans->r_itemq);
+	memcpy(ptr, dp, len);
+	return 0;
+}
+
+STATIC int
+xlog_recover_add_to_cont_trans(
+	struct xlog		*log,
+	struct xlog_recover	*trans,
+	char			*dp,
+	int			len)
+{
+	struct xlog_recover_item *item;
+	char			*ptr, *old_ptr;
+	int			old_len;
+
 	/* take the tail entry */
 	item = list_entry(trans->r_itemq.prev, struct xlog_recover_item,
 			  ri_list);
@@ -2180,31 +2221,6 @@ xlog_recover_add_to_trans(
 
 	if (!len)
 		return 0;
-	if (list_empty(&trans->r_itemq)) {
-		/* we need to catch log corruptions here */
-		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
-			xfs_warn(log->l_mp, "%s: bad header magic number",
-				__func__);
-			ASSERT(0);
-			return -EFSCORRUPTED;
-		}
-
-		if (len > sizeof(struct xfs_trans_header)) {
-			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			ASSERT(0);
-			return -EFSCORRUPTED;
-		}
-
-		/*
-		 * The transaction header can be arbitrarily split across op
-		 * records. If we don't have the whole thing here, copy what we
-		 * do have and handle the rest in the next record.
-		 */
-		if (len == sizeof(struct xfs_trans_header))
-			xlog_recover_add_item(&trans->r_itemq);
-		memcpy(&trans->r_theader, dp, len);
-		return 0;
-	}
 
 	ptr = xlog_kvmalloc(len);
 	memcpy(ptr, dp, len);
@@ -2302,6 +2318,21 @@ xlog_recovery_process_trans(
 	if (flags & XLOG_WAS_CONT_TRANS)
 		flags &= ~XLOG_CONTINUE_TRANS;
 
+	/*
+	 * An empty item queue means we are still decoding the transaction
+	 * header at the start of the transaction rather than a log item. The
+	 * header can arrive whole (flags == 0), as an initial fragment
+	 * (XLOG_CONTINUE_TRANS) or as a continuation fragment
+	 * (XLOG_WAS_CONT_TRANS); XLOG_WAS_CONT_TRANS distinguishes the
+	 * continuation.
+	 */
+	if (list_empty(&trans->r_itemq) &&
+	    (!flags || (flags & (XLOG_CONTINUE_TRANS | XLOG_WAS_CONT_TRANS)))) {
+		error = xlog_recover_init_new_trans(log, trans, dp, len,
+					flags & XLOG_WAS_CONT_TRANS);
+		goto out_error;
+	}
+
 	/*
 	 * Callees must not free the trans structure. We'll decide if we need to
 	 * free it or not based on the operation being done and it's result.
@@ -2335,6 +2366,8 @@ xlog_recovery_process_trans(
 		error = -EFSCORRUPTED;
 		break;
 	}
+
+out_error:
 	if (error || freeit)
 		xlog_recover_free_trans(trans);
 	return error;
-- 
2.55.0

