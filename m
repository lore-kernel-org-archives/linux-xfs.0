Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538C2417D6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882638; cv=none; b=Z0KJ7g3L80YJbVAzOzVJufhNVpj8NZ/21K0lUbUByA9twMozD9VhNRgECNKyh/L4FFIHSh0Q7sWRbctAnohwOXPzJ0L+R4gNvaO1wgxtGiAkbrWhvr0gZ7JzvC9+yEb+Mdcf78+k0NYqDwXdNKYZ1yTqCCfbpukQMRIBx/HaTPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882638; c=relaxed/simple;
	bh=dbrGcm4jdptWmqRtrXgJDUrBcyrGTteXHj6xuovA7O0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bWmjREIb+xNCK/+KAqOvHCDXlTUbguJJ2tTdAvqxotm6Rn8+YfbLyDhwZAMJYnBCY2JIiGgF5r/3JiMKPqsjMfPeOQE73hliwcDtkyQUgUKl1M8cmXshcHAmawCnQTxU5/JQeCel9vNnobqOvjwJ69F11/A8CTnWmF2T7ElnoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiDqY3hk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiDqY3hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89DFC4CEDD;
	Thu,  6 Feb 2025 22:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882638;
	bh=dbrGcm4jdptWmqRtrXgJDUrBcyrGTteXHj6xuovA7O0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YiDqY3hkM0nnZ7vLnkRR23xKvP5CazlmU4j6wUnF6iJuMv2uuEkqluO/ET47KRJCu
	 vUfclRZ09y4HFKY0BQG7qZqCDZV8xsS/MLUXPDYa3K/jhRPX1WkGjV33aMIvpJs4Ph
	 EuJW1vTl/Udpa2WkVD5m0m4QUwO6+rlNUeXbgpkhiqRXjl6j236r+5XHXpFHNAhG0o
	 UAYR5QNB0F+lqzbj3brCyVXO5srUwSrbIFWpxlexOs+Lmix99l2obKn9zXm0PsaXja
	 J8ECb2bPmXtW7ppXNiwlkNftKwOLP7Sv/0xvkTui5idXAp5dDclLTpF4KAOsVa8VaR
	 0/Up10k31IOtA==
Date: Thu, 06 Feb 2025 14:57:17 -0800
Subject: [PATCH 02/22] libxfs: add a realtime flag to the refcount update log
 redo items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088965.2741962.5146151692664108906.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Extend the refcount update (CUI) log items with a new realtime flag that
indicates that the updates apply against the realtime refcountbt.  We'll
wire up the actual refcount code later.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/defer_item.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 1ca9ce15ecfe3d..6beefa6a439980 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -442,9 +442,18 @@ xfs_refcount_defer_add(
 
 	trace_xfs_refcount_defer(mp, ri);
 
+	/*
+	 * Deferred refcount updates for the realtime and data sections must
+	 * use separate transactions to finish deferred work because updates to
+	 * realtime metadata files can lock AGFs to allocate btree blocks and
+	 * we don't want that mixing with the AGF locks taken to finish data
+	 * section updates.
+	 */
 	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock,
-			XG_TYPE_AG);
-	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
+			ri->ri_realtime ? XG_TYPE_RTG : XG_TYPE_AG);
+	xfs_defer_add(tp, &ri->ri_list, ri->ri_realtime ?
+			&xfs_rtrefcount_update_defer_type :
+			&xfs_refcount_update_defer_type);
 }
 
 /* Cancel a deferred refcount update. */
@@ -516,6 +525,27 @@ const struct xfs_defer_op_type xfs_refcount_update_defer_type = {
 	.cancel_item	= xfs_refcount_update_cancel_item,
 };
 
+/* Clean up after calling xfs_rtrefcount_finish_one. */
+STATIC void
+xfs_rtrefcount_finish_one_cleanup(
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	*rcur,
+	int			error)
+{
+	if (rcur)
+		xfs_btree_del_cursor(rcur, error);
+}
+
+const struct xfs_defer_op_type xfs_rtrefcount_update_defer_type = {
+	.name		= "rtrefcount",
+	.create_intent	= xfs_refcount_update_create_intent,
+	.abort_intent	= xfs_refcount_update_abort_intent,
+	.create_done	= xfs_refcount_update_create_done,
+	.finish_item	= xfs_refcount_update_finish_item,
+	.finish_cleanup = xfs_rtrefcount_finish_one_cleanup,
+	.cancel_item	= xfs_refcount_update_cancel_item,
+};
+
 /* Inode Block Mapping */
 
 static inline struct xfs_bmap_intent *bi_entry(const struct list_head *e)

