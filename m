Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871060;
	b=1qu3zlVD7vxMpRPFd5OX33Q5OM/+yeb+lwmJwZoZcfPWrUZA9TEZrjCnBpwoB1lQesEC
	 xtfY7O71H0bsSbW+zxBtrmjUF0PDMZZjpWWCjeRDElYSZ7LtIdEG/SGwE7xEBi6kyxicE
	 UuDiOCGrfzNjv46Vp2NYuvg/41vv7iSzF3UZwZmZNy4s47RbgZyGMKGObYbXu9Ruc1MnP
	 73lLR9o1FRqz8zSxBNJ5MxTEWjZoUlC7LVWzElPOc+jkMim9LgSwCwIZcE0dLJPpZwwnO
	 Pc5f5oQPnjXKa1EYhhqLvW6UUcXpC9xCRqRH85hj6JvR8Hmnpk4Ll67GIFHDC4+aljw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=m52UgFURClF0wE9oWlWaUsxnfky9qSYHoSYulTCHEVw=;
	b=dPz79MYBoW0g2UJZXf6iAkMt26XXIgjByRmwhXuFNu0USf50yekRrOIVqSLAd1tIE8uG
	 7IPn8dqAL8+UVaCgNtVtGtbvrKxJI0dBeFbhDCKtNfhlwYUp8xVOedcIHV3nh0xGXdsWA
	 GwhJ9eMn5Q4EEj/+3TYYRKQFOQz7UrOvdu7ad1rhkc0+ePXD9z3MjNyIXnYJPl0ljgXUk
	 mSofsioAk8klfEcl8dBDeDAWuGQZSZh4Z5QT1wyQoA9L6x9Cl13KYyyVT3eJcNNhND5zQ
	 ziTLUrp6mrDmSfq9fvfthyPOP80Mym1lqg/6bK8wnFBR+/6ikDfc0UMrq3uIvkhSu2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DM3tHLLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EE8606A335
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DM3tHLLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C051F000C5;
	Mon, 16 Nov 2026 23:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871060;
	bh=m52UgFURClF0wE9oWlWaUsxnfky9qSYHoSYulTCHEVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DM3tHLLA1xRZHEMt3cef3TiIeFzjEWndY0OhXvAedUw7gjtZS6d2G/61IuAicbYjB
	 jdLX9JDjBnLi1eaFVwaVStzo1w42C5ZmqKgY9ObJTLqV0rJyFIHrBA0h7uZaI1e9ET
	 PyC/gzk4qYKNQZtoFlXBMgIT2bfNCc4E9wfEcr4sMgGCFHKgErOpGdTrhWZzATe0Iv
	 ZoLiL1yKZP4KgJ+5kZmP4h8iwE6mX0R3drLso88AdwIrGHSzRNqKx7pHH1y8Rx1mIw
	 9MP6fROstm0t26DPEGQkIP743EC2VL0s37BVJHDQxGIUJg5Ov15c+0MCA5kofvI0UT
	 2lHARio6wjgjQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 20/59] xfs: validate operation header length and alignment during recovery
Date: Tue, 17 Nov 2026 10:14:37 +1100
Message-ID: <20261116231707.3625263-21-dgc@kernel.org>
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
index a5fa7d2676cd..472e0093d589 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2652,24 +2652,69 @@ xlog_recover_ophdr_to_trans(
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
@@ -2677,10 +2722,10 @@ xlog_recover_validate_ophdr(
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
@@ -2688,24 +2733,28 @@ xlog_recover_process_ophdr(
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
@@ -2739,8 +2788,11 @@ xlog_recover_process_ophdr(
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
@@ -2761,10 +2813,9 @@ xlog_recover_process_data(
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
@@ -2775,21 +2826,17 @@ xlog_recover_process_data(
 
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

