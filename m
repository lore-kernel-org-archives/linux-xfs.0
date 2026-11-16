Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871066;
	b=Tz7O+orcrvTvSQ0GjybV9CpWwiGemG/CRv7a0Ydowzj1037ptxOfVLxvETI/HbfNcPYc
	 Skc7TzYgp5vpX+e2azpD0roRVnwCxqZxicpbf5Es2mbP4h3S7PFEzImuO74SG2lOiIIR1
	 lKdsOaXIdnl1a78f53g0VtQy+Aqi59iugV/8xUEt/ZK9URosCfYI9RP3oXTmdNgxzXEVC
	 tHGDd/1VXFt4KGov2bVBBnfTDInt/lb3e2nMrPlov9gmWMr9MFE17vP5ybKeGP3RkmXlr
	 +5c/libCdT2xC4wxiIEMSxTNtrV5WLfDhQPih3blX08Up1KHOJZ8I/6iEOmfzbAZGug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CB1S0zNA4qycxHQNWTu3sGoqqvfCUaijZuxyH6Orc/E=;
	b=2yTqKkXA2grhMlHoByUq/pnwnJwMb35d4w7dUx5XyctiE8YYGS0syvx2NvDcbNlsFQM9
	 uR6QHT3DloIVx6G7My0blIIvtNDup561uCOHJGZYQb1PN2cDOXs4Gbls9VBJU5Z0nhPEg
	 Y1rMaXs939rcE7XYCkkHbadqWCxJWrSUgEJ9DK7yoZR+/TgUw2AdRF+Qw2abk4mDqp2se
	 T9/4bY6buXR4M5VN1tHubQxBQ8bizuRoQCnfAPvxKc5ruyBTK50FuN8doC08NwHYKkHtN
	 We79SVeb71AeE/w4Fb7wXDtdEJsh0M+aJi78NgNFYRlDnzSbN4cOZWNs6KVWO5kLARg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSxhR4d6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682CA606A33F
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSxhR4d6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8741F000C4;
	Mon, 16 Nov 2026 23:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871066;
	bh=CB1S0zNA4qycxHQNWTu3sGoqqvfCUaijZuxyH6Orc/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSxhR4d6GA+Omsf5xBbxaSpxEok9F50SVRAmazqwahsxNe3tMRCZiOb775zG6HsGJ
	 ygO+DkaVTnAuw7LqoXaCWVoAxqxXyYKis2ByRSRwd5OvVS8vAzXmFBMQ/w1Gg0wUGh
	 ozFWPuK+YFESYfILMg8hCIgdwaLVxhjX5lvHFG3Fnb5pMYd9w7q8c7pyoz/OmgrTIP
	 /1fso34MprFpcWsSgRO9QinjTR9RuAR/mdofCO9jW0SDZpRfyUJ9bLC/VRsu0Fi6yN
	 ytYoz3J9O0XZbxCG5CmVAzT/FiaxoLmFP2KCrRW1IHsUFKOmAWYdTOtknZeG1+u8lh
	 BAaJAtG3JULWA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 25/59] xfs: handle zero length continuation op headers during recovery
Date: Tue, 17 Nov 2026 10:14:42 +1100
Message-ID: <20261116231707.3625263-26-dgc@kernel.org>
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

The log writer can start the transaction header at the start of a checkpoint
with a zero length op header, with the header data following in the
continuation. This is the only region the log writer ever opens with a zero
length op header. Recovery used to handle this as a special case in the
bespoke transaction header decode. Routing the transaction header through the
generic item assembly dropped that handling.

A zero length op header that opens the transaction header carries nothing to
decode, so the item cannot be initialised until the continuation arrives.
Leave a sentinel in r_cur_item for this case so the continuation is decoded as
the first region of the transaction header.

A zero length op header anywhere else in a checkpoint is corrupt, as is a zero
length op header that completes a region. Reject them. A continuation that
reaches the append path with no item under assembly is also treated as a
corrupt log.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |  9 +++++
 fs/xfs/xfs_log_recover.c        | 59 ++++++++++++++++++++++++++++-----
 2 files changed, 60 insertions(+), 8 deletions(-)

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
index 0c7788345cd3..aea6f5404cec 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2400,6 +2400,18 @@ xlog_recover_add_to_cont_trans(
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
 
@@ -2445,8 +2457,28 @@ xlog_recover_add_to_trans(
 	char			*ptr;
 	int			error;
 
-	if (!len)
+	/*
+	 * Only the transaction header at the start of a checkpoint can be
+	 * opened by a zero length fragment, with its data following in the
+	 * continuation. A zero length fragment anywhere else, or one that
+	 * completes a region, is corrupt.
+	 *
+	 * There is nothing to decode yet, so leave a sentinel in r_cur_item so
+	 * that xlog_recover_process_trans() will call here again with the
+	 * continuation that carries the data we need to initialise the
+	 * recovery item.
+	 */
+	if (!len) {
+		if (region_complete || trans->r_cur_item ||
+		    trans->r_theader.th_magic == XFS_TRANS_HEADER_MAGIC) {
+			xfs_warn(log->l_mp,
+				"%s: zero length region in transaction 0x%x",
+				__func__, trans->r_log_tid);
+			return -EFSCORRUPTED;
+		}
+		trans->r_cur_item = XLOG_RECOVER_CONT_ITEM;
 		return 0;
+	}
 
 	ptr = xlog_kvmalloc(len);
 	memcpy(ptr, dp, len);
@@ -2461,7 +2493,7 @@ xlog_recover_add_to_trans(
 	 * fragment here.
 	 */
 	item = trans->r_cur_item;
-	if (!item) {
+	if (!item || item == XLOG_RECOVER_CONT_ITEM) {
 		struct xfs_inode_log_format *in_f = /* any will do */
 			(struct xfs_inode_log_format *)ptr;
 
@@ -2517,9 +2549,10 @@ xlog_recover_free_trans(
 
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
@@ -2564,15 +2597,25 @@ xlog_recovery_process_trans(
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
 		/*
 		 * The commit record is written after all items in the
-- 
2.55.0

