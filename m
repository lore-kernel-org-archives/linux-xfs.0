Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871109;
	b=VnV14m79KlkUOYTSIgAWt5/feqlHgbRLdvimB/8bOaHf+V8Fn+ekFR0ucH7FoUnpe+RF
	 vidVk0mgIL4n8ruKHyUm9K6imXMjHTiOsHJgP0Oef1D/qJBFI74681jbjLcAfpufMzNCH
	 mVAle9YI4xkS6CcsUMMMBYQUQzmH1FBWm1OmSkvfgagXIBVfDpSQbM5CRhnKhnPrUeBEk
	 /m6HxqtvygPgTYdbB+COGsBSBVMgwWePWl5pN/YXfEiUJxGEpNXKiKi8198Wa68ClWNN0
	 cZDjE7RMGwSd23QZKSy7+C6P008OOhvIz4E2iR8vWYlukt/84jESipIll1KAxIhKnHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=tVWIIORnl/4PVw6apsZN3t+AwGG5b26uhas+Tnwpq0s=;
	b=gXJIv4GB6c8cEQ7k4E+iFRFmphVjbJdLmvkVXDwObvN3GPrRC1FP2Qkdy7WGjNdCbLRl
	 uHTJsR25Kq7iOCnnxvauVQ9xyfwo2kF39uKQ5JdRg6TcPMlyzIdJh/BauuEyZsq/So1h8
	 lGmRDcvN+7NNduu8Wgajq6COCZTHrpT5WCYuH5M3HBgxDu2FZMBYV9suyI9xOpbhhv96c
	 r0Ff9ET1l8jbl3eqGxcZ7YhdHqZBc6cjlFAsapZOOYLS86OjIwA5Jv7XNl6pDATTEJ8vH
	 2k+yrBOEA0aZ41H6U2MS3jEI5dHT2sPUBJqfW0nRtNIx4Uc906HAe7WoXLA1slXoorA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mw+6T7oW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FABC606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mw+6T7oW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6A91F000C7;
	Mon, 16 Nov 2026 23:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871109;
	bh=tVWIIORnl/4PVw6apsZN3t+AwGG5b26uhas+Tnwpq0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mw+6T7oWnf+eBpb0WdrQTHXnppDhhQvaBHt9IJTZiVr47sm6OiwxSv65uQH4YgbzD
	 CNtLgvi4txz1qEjSEKQIw2HidZI9rNOJBbSxmUu6rkTlYEti67AXHWIAo9MnV/uGEE
	 GGiyBgwbiHadLeBYKLfBnqcT7Z5UHmy2EVbfKjzGnc1jg3x/H7icP59oeq6dmZaHw0
	 34aJmw3XRYCLo7Xo3Smwh9WlKsBLwBBl5hZ/+v3UhcchVSEllFwfeMWmR4noHp9yKo
	 tR/gDmMkepdcawAOsWKzLUioJlciWXq3pbA64jXMmaNoBZLXADfMsCYcGBzHdgp0rN
	 7rWQ9aRqu4YtA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 58/59] xfs: fail recovery on a buffer type mismatch
Date: Tue, 17 Nov 2026 10:15:15 +1100
Message-ID: <20261116231707.3625263-59-dgc@kernel.org>
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

When recovering a buffer, xlog_recover_validate_buf_type() checks that the
buffer type recorded in the log item agrees with the magic number of the
buffer being replayed into. A mismatch left bp->b_ops unset and was only
reported with a warning and an ASSERT. On a production kernel recovery then
queued the buffer with no verifier attached, so xfs_buf_verify_write() warned
about the missing operations but still wrote the mismatched recovery data to
disk.

Return an error from xlog_recover_validate_buf_type() on a type mismatch
instead of asserting. The replay path propagates the error so recovery fails
rather than writing out an unverifiable buffer. The skip path, where the
buffer on disk is newer than the log item being recovered, ignores the result:
later changes to that buffer are still to be replayed and may change its type,
so a mismatch against the current log item is expected there and must not warn.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index bedaa25fa12e..32c7bf16378a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -214,7 +214,7 @@ xlog_recover_buf_commit_pass1(
  *	the first 32 bits of the buffer (most blocks),
  *	inside a struct xfs_da_blkinfo at the start of the buffer.
  */
-static void
+static int
 xlog_recover_validate_buf_type(
 	struct xfs_mount		*mp,
 	struct xfs_buf			*bp,
@@ -236,7 +236,7 @@ xlog_recover_validate_buf_type(
 	 * just avoid the verification stage for non-crc filesystems
 	 */
 	if (!xfs_has_crc(mp))
-		return;
+		return 0;
 
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
 	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
@@ -426,14 +426,22 @@ xlog_recover_validate_buf_type(
 	/*
 	 * Nothing else to do in the case of a NULL current LSN as this means
 	 * the buffer is more recent than the change in the log and will be
-	 * skipped.
+	 * skipped. The buffer contents are newer than this format, so later
+	 * changes to this buffer still to be replayed may change its type. A
+	 * mismatch against this format is therefore expected and not a corruption.
 	 */
 	if (current_lsn == NULLCOMMITLSN)
-		return;
+		return 0;
 
+	/*
+	 * The buffer type does not match the magic number in the buffer we are
+	 * about to replay into. The write verifier keyed off the type would
+	 * reject it, so fail recovery rather than submit a buffer that cannot be
+	 * verified.
+	 */
 	if (warnmsg) {
 		xfs_warn(mp, warnmsg);
-		ASSERT(0);
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -454,6 +462,8 @@ xlog_recover_validate_buf_type(
 		bip = bp->b_log_item;
 		bip->bli_item.li_lsn = current_lsn;
 	}
+
+	return 0;
 }
 
 /*
@@ -525,8 +535,7 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
-	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
-	return 0;
+	return xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 }
 
 /*
-- 
2.55.0

