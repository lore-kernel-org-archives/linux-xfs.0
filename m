Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFD03BCD2B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871343; cv=none; b=Nxtwd43/F4T1pmiXo8tUYD2qXytdLmhLJXp1RWG+gYMEN8o9VmV5+bM6WENBNjYO5uYYzqMvRn9xGUME1bQj3ewbMDjobWpnEFNdX1BR7kRRWFpuFoKqtShAty5JKj9FSHqnWd90ql/37wjmS2zj/qT0EEGYhRab0vu1Yu/WfTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871343; c=relaxed/simple;
	bh=ueNV5W1+lUMjU5YqZTvEkzkKlRyxBSxCO+0/99Z2gfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTp4E5YLUxqPOtDk8dS2XMAShthyBgVOvWXUax0AoMOP/ri5MMqiXR8sp8QZtkdB2EvX/ryKFJviI1k/ZMswnvA+GBHCSZAEAE1qH7LZcZ//vcogrQEWTSwoHGuRCHOnwOwV0NvsZo5LlBGVdT/WQfIkBcY2CpKkVQQLEE3Okk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=blVBEN0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="blVBEN0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3701F00899;
	Tue, 13 Oct 2026 06:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871342;
	bh=ORGKlnio7fku6pmRp4cKtIfJiDVpD38+dQOKlsfs1eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blVBEN0DaxUpPcg1MPVl8/jJ0FAcCb0PrIIuefZbJrgSns9cfWuewJUmgx0LaDZ6X
	 vpbfwEvKwPG85MDwSLn/FD2bbD+1kkPyilVN7d/51Pig4vOYpZphKETt0qNybcHr+D
	 uGWUYYEzwT2CdayfWEE2X6BvOevGwXsp9Y4zaaCzTNeT38zzbHBYrqGokghA6FPLpq
	 +ZCw60wiLQxtNhDfn0Fz1cGKdgVJSi7GP3Qu7IX+KZtVMberDtJwmVW8RnsWOuB/SL
	 y1x9wh/pCku2emwmIrbL7qT932VHz2v8Aop+EySp/3Kma+4q7EWIuLQxqxnZhQQt04
	 s9f126BTIAv3g==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 10/48] xfs: validate operation header length and alignment during recovery
Date: Tue, 13 Oct 2026 17:01:00 +1100
Message-ID: <20261013060204.3138690-11-dgc@kernel.org>
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

The operation header length read from the journal was only checked against
the end of the log record, so an implausibly large or misaligned length was
still trusted to drive region assembly and memory allocation.

Bound the length against the largest object that can be logged in a single
region and require it to be 32 bit aligned. Move the in-place ophdr decode
into the validation helper as well, so a misaligned or out-of-bounds header
is rejected before it is dereferenced rather than after.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 115 +++++++++++++++++++++++++++------------
 1 file changed, 81 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1e0b8f2affe3..4a5c8830b781 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2639,24 +2639,69 @@ xlog_recover_ophdr_to_trans(
 }
 
 /*
- * Validate an operation header decoded from the journal before it is used to
- * drive transaction recovery. The ophdr and its data region come straight from
- * the on-disk log and cannot be trusted, so check the fields for known values
- * and obvious corruption here, in one place, before anything acts on them.
+ * Decode and validate an operation header from the journal. dp points at the
+ * ophdr within the log record and end is the end of the record data. The ophdr
+ * and its data region come straight from the on-disk log and cannot be trusted,
+ * so decode the header in place and check its fields for known values and
+ * obvious corruption here, in one place, before anything acts on them.
+ *
+ * Returns the validated ophdr, or an ERR_PTR() on corruption.
  */
-STATIC int
+STATIC struct xlog_op_header *
 xlog_recover_validate_ophdr(
 	struct xlog		*log,
-	struct xlog_op_header	*ohead,
 	char			*dp,
 	char			*end)
 {
-	unsigned int		len = be32_to_cpu(ohead->oh_len);
+	struct xlog_op_header	*ohead;
+	unsigned int		len;
+
+	/*
+	 * All log regions are 32 bit aligned, so the ophdr must be too. A
+	 * misaligned ophdr means the walk over the record has lost sync with
+	 * the on-disk layout.
+	 */
+	if (dp != PTR_ALIGN(dp, sizeof(uint32_t))) {
+		xfs_warn(log->l_mp, "%s: unaligned op header", __func__);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
+	/* The ophdr itself must fit within the record. */
+	if (dp + sizeof(*ohead) > end) {
+		xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
+	ohead = (struct xlog_op_header *)dp;
+	dp += sizeof(*ohead);
+	len = be32_to_cpu(ohead->oh_len);
 
 	/* Check the ophdr contains all the data it is supposed to contain. */
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
-		return -EFSCORRUPTED;
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
+	/*
+	 * All log regions are 32 bit aligned, so the length must be too. A
+	 * misaligned length desyncs the walk over the ophdrs in the record.
+	 */
+	if (!IS_ALIGNED(len, sizeof(uint32_t))) {
+		xfs_warn(log->l_mp, "%s: unaligned length 0x%x", __func__, len);
+		return ERR_PTR(-EFSCORRUPTED);
+	}
+
+	/*
+	 * A single region cannot be larger than the largest object we log in
+	 * one region. That is a whole buffer in a buffer log item (up to
+	 * XFS_MAX_BLOCKSIZE, e.g. a 64k directory block on a 4k block size
+	 * filesystem) or a remote attribute value (up to XFS_XATTR_SIZE_MAX,
+	 * logged in its own region); both are 64k.
+	 */
+	BUILD_BUG_ON(XFS_XATTR_SIZE_MAX > XFS_MAX_BLOCKSIZE);
+	if (len > XFS_MAX_BLOCKSIZE) {
+		xfs_warn(log->l_mp, "%s: length 0x%x too large", __func__, len);
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/* Do we understand who wrote this op? */
@@ -2664,10 +2709,10 @@ xlog_recover_validate_ophdr(
 	    ohead->oh_clientid != XFS_LOG) {
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
-		return -EFSCORRUPTED;
+		return ERR_PTR(-EFSCORRUPTED);
 	}
 
-	return 0;
+	return ohead;
 }
 
 STATIC int
@@ -2675,24 +2720,28 @@ xlog_recover_process_ophdr(
 	struct xlog		*log,
 	struct hlist_head	rhash[],
 	struct xlog_rec_header	*rhead,
-	struct xlog_op_header	*ohead,
 	char			*dp,
 	char			*end,
 	int			pass,
 	struct list_head	*buffer_list)
 {
+	struct xlog_op_header	*ohead;
 	struct xlog_recover	*trans;
-	unsigned int		len = be32_to_cpu(ohead->oh_len);
+	unsigned int		len;
 	int			error;
 
-	error = xlog_recover_validate_ophdr(log, ohead, dp, end);
-	if (error)
-		return error;
+	ohead = xlog_recover_validate_ophdr(log, dp, end);
+	if (IS_ERR(ohead))
+		return PTR_ERR(ohead);
+
+	/* the data region follows the ophdr */
+	dp += sizeof(*ohead);
+	len = be32_to_cpu(ohead->oh_len);
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
 	if (!trans) {
 		/* nothing to do, so skip over this ophdr */
-		return 0;
+		return sizeof(*ohead) + len;
 	}
 
 	/*
@@ -2726,8 +2775,11 @@ xlog_recover_process_ophdr(
 		log->l_recovery_lsn = trans->r_lsn;
 	}
 
-	return xlog_recovery_process_trans(log, trans, dp, len,
-					   ohead->oh_flags, pass, buffer_list);
+	error = xlog_recovery_process_trans(log, trans, dp, len,
+					    ohead->oh_flags, pass, buffer_list);
+	if (error)
+		return error;
+	return sizeof(*ohead) + len;
 }
 
 /*
@@ -2748,10 +2800,9 @@ xlog_recover_process_data(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	struct xlog_op_header	*ohead;
 	char			*end;
 	int			num_logops;
-	int			error;
+	int			consumed;
 
 	end = dp + be32_to_cpu(rhead->h_len);
 	num_logops = be32_to_cpu(rhead->h_num_logops);
@@ -2762,21 +2813,17 @@ xlog_recover_process_data(
 
 	trace_xfs_log_recover_record(log, rhead, pass);
 	while ((dp < end) && num_logops) {
+		/*
+		 * Decode, validate and process the next ophdr and its data
+		 * region. On success the number of bytes consumed from the
+		 * record is returned; errors abort recovery.
+		 */
+		consumed = xlog_recover_process_ophdr(log, rhash, rhead, dp,
+						      end, pass, buffer_list);
+		if (consumed < 0)
+			return consumed;
 
-		ohead = (struct xlog_op_header *)dp;
-		dp += sizeof(*ohead);
-		if (dp > end) {
-			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
-			return -EFSCORRUPTED;
-		}
-
-		/* errors will abort recovery */
-		error = xlog_recover_process_ophdr(log, rhash, rhead, ohead,
-						   dp, end, pass, buffer_list);
-		if (error)
-			return error;
-
-		dp += be32_to_cpu(ohead->oh_len);
+		dp += consumed;
 		num_logops--;
 	}
 	return 0;
-- 
2.55.0

