Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871065;
	b=gEo4mvYmJGSR4bIdmJa0i6zZDoM9NHgcGiCaqI78MxFk1wCodwgtJiK7Lz63acW/iA3c
	 +byzKgdUKlTz5pJ43B5scAghXMJe2zv+D+a+LCW7WNOQCK7qBTy961ovQDoHuoEe0M3cO
	 DcQeM0tq48rnhbyJV4ZeIdhd1Uk729y2wIEzAAKhwmPc5AU9/MbFgk3CmS/g8P4KviJ5h
	 CdhyEMjvAnY6gbJUqwN/LDnMynopuUaeLwEiVTB5vGbddpsPKtg6bnGXb4gWo3o6vHVup
	 56p5SGM1VgKhX3xmbpFZ2IwzMXRLNrO8FFmfZnbUiNPro6C2IROu3A1m9x1AlDQ3Z5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RKZA0iktDY3NmLVDVM2v4ZL193Lg4MSNHVoTxBFkB5o=;
	b=Z6judZnMpR4enBynRFtNCqbGrkGgWuupU7YtS5B0Q+CokRjrO1AViO0wlEXSNqde+NMW
	 5GltFw5k1iybk8vkROfSxw/yA+Tp+7P9BsoUL1xrRgo3mh3PAQqtOyMGg/Y1g/5RldgBJ
	 TDZukyfQ7tYDctnIyZA4VVKNo80IsHlI5FIwAEfwLMBowwFuOh1hpqQxBbbgeEfFgxV53
	 LYGnP8o2IkydB7HX0byFq/wupyu5LhwFVVw/W1vayOeoRpIohQ7WrPnLUMNakZPtyGkes
	 b1yAP7KF77/FCTJhovqN8iaCChRfkyq3Z1e+c0HneEcyKPjjCp3reCg0VSsn5btr4SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EieAVKzR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C3F606A339
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EieAVKzR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031C61F000C4;
	Mon, 16 Nov 2026 23:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871064;
	bh=RKZA0iktDY3NmLVDVM2v4ZL193Lg4MSNHVoTxBFkB5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EieAVKzRp6troNhWcsgEgeUZpAhlP+VQ12ACFiW4ryB8mzHZufy+z/Rr3cf6xdsYF
	 pY3R9d9MU+TU388n5H82wz6sUG54tmR9tZj6pTGArX0rQyMprP0ro6PSI8ztBbi9UU
	 V3BlCeeyJOMsHIgF2y0FeUQshqWJK7L5+b2EhINlnHJjHMqlZCGa2jGlDK7saV0L17
	 GrfoSs1P2GwN8KxpJgNL/Ixa3md4hBic1pj7B7qwTXxfduKmq7CDSF78cMc72u7Gnz
	 1QyVYOGlPdb+mbHrsOIbKixNqpOas+6rRU9+qaG8aZ/iQvDJv3JLDAbzLqdgfDFcUb
	 dKczVVu6iz/DQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 24/59] xfs: validate the unmount record during recovery
Date: Tue, 17 Nov 2026 10:14:41 +1100
Message-ID: <20261116231707.3625263-25-dgc@kernel.org>
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

The unmount record is the only record the log writes itself rather than
through a transaction. The log item processing loop skips it, so its contents
were never validated on recovery. A clean unmount is detected by inspecting it
during the head and tail scan, which trusted the operation header flags
without validating the header first.

Add xlog_recover_validate_unmount_record() to check the record is written by
the log, is the expected length, and carries the expected magic and zeroed
padding. Call it from the operation header validation.

The head and tail scan now validates the operation header before trusting its
flags. That scan runs before torn writes have been trimmed from the head of the
log, so an invalid record there is not treated as corruption. The log is only
considered clean if the record is a valid unmount record. Otherwise the log is
treated as dirty, and head verification and recovery deal with the record. The
scan validates quietly, as a record that is not an unmount record is expected
there.

A clean log can be mounted on a host of either endianness. The unmount record
magic is written in host byte order, so both byte orders are accepted.

The unmount record length was incorrectly written as zero for a period of time.
A zero length record has no payload to check, so accept it with a warning so
that filesystems written by those kernels still recover.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 144 +++++++++++++++++++++++++++++++++------
 1 file changed, 123 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bb3e23c20069..0c7788345cd3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -42,6 +42,8 @@ xlog_clear_stale_blocks(
 STATIC int
 xlog_do_recovery_pass(
         struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
+STATIC struct xlog_op_header *
+xlog_recover_validate_ophdr(struct xlog *log, char *dp, char *end, bool quiet);
 
 /*
  * Sector aligned buffer routines for buffer create/read/write/access
@@ -1169,8 +1171,18 @@ xlog_check_unmount_rec(
 		if (error)
 			return error;
 
-		op_head = (struct xlog_op_header *)offset;
-		if (op_head->oh_flags & XLOG_UNMOUNT_TRANS) {
+		/*
+		 * The log has not been checked for torn writes yet, so this
+		 * record cannot be trusted until its ophdr has been validated.
+		 * Only a valid unmount record makes the log clean. Anything else
+		 * is not an error here: the log is treated as dirty, and head
+		 * verification and recovery deal with the record.
+		 */
+		op_head = xlog_recover_validate_ophdr(log, offset,
+				offset + BBSIZE, true);
+		if (IS_ERR(op_head))
+			return 0;
+		if (op_head->oh_flags == XLOG_UNMOUNT_TRANS) {
 			/*
 			 * Set tail and last sync so that newly written log
 			 * records will point recovery to after the current
@@ -2583,9 +2595,11 @@ xlog_recovery_process_trans(
 
 	/* unexpected flag values */
 	case XLOG_UNMOUNT_TRANS:
-		/* just skip trans */
-		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
-		freeit = true;
+		/* An unmount record never belongs to a checkpoint. */
+		xfs_warn(log->l_mp,
+			"%s: unmount record in transaction 0x%x",
+			__func__, trans->r_log_tid);
+		error = -EFSCORRUPTED;
 		break;
 	case XLOG_START_TRANS:
 	default:
@@ -2649,6 +2663,72 @@ xlog_recover_ophdr_to_trans(
 	return NULL;
 }
 
+/*
+ * Validate an unmount record. The unmount record is the only record written by
+ * the log itself rather than by a transaction, and the log item processing loop
+ * skips it, so it can only be validated here. It is a single fixed size region,
+ * written by the log with the XFS_LOG clientid, containing an unmount format
+ * structure with a known magic number and zeroed padding.
+ *
+ * The ophdr has already been validated, so oh_len is known to be within the
+ * record. The unmount format length was incorrectly written for a period of
+ * time as zero rather than the region length. Such a record has no payload to
+ * read, so accept it with a warning and stop, so that filesystems written by
+ * those kernels still recover. That warning is always emitted, as the record
+ * is accepted. @quiet suppresses only the warnings for a rejected record.
+ */
+STATIC int
+xlog_recover_validate_unmount_record(
+	struct xlog			*log,
+	struct xlog_op_header		*ohead,
+	bool				quiet)
+{
+	struct xfs_unmount_log_format	*ulf;
+	unsigned int			len = be32_to_cpu(ohead->oh_len);
+
+	if (ohead->oh_clientid != XFS_LOG) {
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad unmount clientid 0x%x",
+				__func__, ohead->oh_clientid);
+		return -EFSCORRUPTED;
+	}
+
+	if (len == 0) {
+		xfs_warn(log->l_mp,
+			"%s: zero length unmount record recovered.", __func__);
+		return 0;
+	}
+
+	if (len != sizeof(*ulf)) {
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad unmount record length 0x%x",
+				__func__, len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * The magic number is written in host byte order, and a clean log can be
+	 * mounted on a host of either endianness, so accept both byte orders.
+	 */
+	ulf = (struct xfs_unmount_log_format *)(ohead + 1);
+	if (ulf->magic != XLOG_UNMOUNT_TYPE &&
+	    ulf->magic != swab16(XLOG_UNMOUNT_TYPE)) {
+		if (!quiet)
+			xfs_warn(log->l_mp,
+				"%s: bad unmount magic 0x%x, expected 0x%x",
+				__func__, ulf->magic, XLOG_UNMOUNT_TYPE);
+		return -EFSCORRUPTED;
+	}
+
+	if (ulf->pad1 != 0 || ulf->pad2 != 0) {
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad unmount padding", __func__);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
 /*
  * Decode and validate an operation header from the journal. dp points at the
  * ophdr within the log record and end is the end of the record data. The ophdr
@@ -2656,16 +2736,21 @@ xlog_recover_ophdr_to_trans(
  * so decode the header in place and check its fields for known values and
  * obvious corruption here, in one place, before anything acts on them.
  *
+ * A caller probing for a record that may legitimately not be there sets @quiet
+ * to suppress the warnings for an ophdr that fails validation.
+ *
  * Returns the validated ophdr, or an ERR_PTR() on corruption.
  */
 STATIC struct xlog_op_header *
 xlog_recover_validate_ophdr(
 	struct xlog		*log,
 	char			*dp,
-	char			*end)
+	char			*end,
+	bool			quiet)
 {
 	struct xlog_op_header	*ohead;
 	unsigned int		len;
+	int			error;
 
 	/*
 	 * All log regions are 32 bit aligned, so the ophdr must be too. A
@@ -2673,13 +2758,15 @@ xlog_recover_validate_ophdr(
 	 * the on-disk layout.
 	 */
 	if (dp != PTR_ALIGN(dp, sizeof(uint32_t))) {
-		xfs_warn(log->l_mp, "%s: unaligned op header", __func__);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: unaligned op header", __func__);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/* The ophdr itself must fit within the record. */
 	if (dp + sizeof(*ohead) > end) {
-		xfs_warn(log->l_mp, "%s: op header overrun", __func__);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: op header overrun", __func__);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -2689,7 +2776,9 @@ xlog_recover_validate_ophdr(
 
 	/* Check the ophdr contains all the data it is supposed to contain. */
 	if (dp + len > end) {
-		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__,
+				len);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -2698,7 +2787,9 @@ xlog_recover_validate_ophdr(
 	 * misaligned length desyncs the walk over the ophdrs in the record.
 	 */
 	if (!IS_ALIGNED(len, sizeof(uint32_t))) {
-		xfs_warn(log->l_mp, "%s: unaligned length 0x%x", __func__, len);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: unaligned length 0x%x",
+				__func__, len);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -2711,22 +2802,26 @@ xlog_recover_validate_ophdr(
 	 */
 	BUILD_BUG_ON(XFS_XATTR_SIZE_MAX > XFS_MAX_BLOCKSIZE);
 	if (len > XFS_MAX_BLOCKSIZE) {
-		xfs_warn(log->l_mp, "%s: length 0x%x too large", __func__, len);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: length 0x%x too large",
+				__func__, len);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/* Do we understand who wrote this op? */
 	if (ohead->oh_clientid != XFS_TRANSACTION &&
 	    ohead->oh_clientid != XFS_LOG) {
-		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
-			__func__, ohead->oh_clientid);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
+				__func__, ohead->oh_clientid);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
 	/* The padding is always written as zero. */
 	if (ohead->oh_res2 != 0) {
-		xfs_warn(log->l_mp, "%s: bad padding 0x%x",
-			__func__, ohead->oh_res2);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad padding 0x%x",
+				__func__, ohead->oh_res2);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -2744,20 +2839,27 @@ xlog_recover_validate_ophdr(
 		 * no data of their own.
 		 */
 		if (len != 0) {
-			xfs_warn(log->l_mp, "%s: bad control record length 0x%x",
-				__func__, len);
+			if (!quiet)
+				xfs_warn(log->l_mp,
+					"%s: bad control record length 0x%x",
+					__func__, len);
 			return ERR_PTR(-EFSCORRUPTED);
 		}
 		break;
+	case XLOG_UNMOUNT_TRANS:
+		error = xlog_recover_validate_unmount_record(log, ohead, quiet);
+		if (error)
+			return ERR_PTR(error);
+		break;
 	case 0:
 	case XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_END_TRANS:
-	case XLOG_UNMOUNT_TRANS:
 		break;
 	default:
-		xfs_warn(log->l_mp, "%s: bad flags 0x%x",
-			__func__, ohead->oh_flags);
+		if (!quiet)
+			xfs_warn(log->l_mp, "%s: bad flags 0x%x",
+				__func__, ohead->oh_flags);
 		return ERR_PTR(-EFSCORRUPTED);
 	}
 
@@ -2779,7 +2881,7 @@ xlog_recover_process_ophdr(
 	unsigned int		len;
 	int			error;
 
-	ohead = xlog_recover_validate_ophdr(log, dp, end);
+	ohead = xlog_recover_validate_ophdr(log, dp, end, false);
 	if (IS_ERR(ohead))
 		return PTR_ERR(ohead);
 
-- 
2.55.0

