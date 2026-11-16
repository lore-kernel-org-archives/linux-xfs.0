Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871057;
	b=05vYqKHzLdIZr4s7+qLQVQKPAn0MdFxWLIZuF9lHFhXuPY7Wst7gT0v37TnCBjxZX3Wh
	 DupSMwj2BUgGb+krv4UMxUDu/EbpZ2F2YFmBxHtxbu8ZCsFVqvpAl8j78ppVjIu7PcOmY
	 XyvZxDfn5w8cbHYdO34jpchNr57eXasFONimIZ8ZzeEl9o/QySscjhtowvtFvZ/CYFf6V
	 ic6aPoTboaPv594ot2OjVV+4y6lVkqRZoqUosk7xs2/ao8iY0oVawQ3KzQBDbeeP74glP
	 h5BdVNYS6yzhF4dKYyfEht8Gz73HW2mj77iqNDRohserxamIoBeRuPKaqRtoIOu73zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZJeX8gtsRg93Bolqe/4zvsi+mU1h3OsIsi3wvXvUmG0=;
	b=kfzQG2z4OEVfIn66ZJJzG73oWi91hHzuXswKP+zpLqCmOZkcBfNCprBUS6wYfB6Yd/bg
	 2tnbdLWiSvOh1GXwtPKVeYyImJ5gzlk4TLibcVAfKUxa+s0CK/m+FIw0UAPsWcPgkkNHC
	 Pe8pjBxP04fntlJhtIhFVkxY13akESFsO4fnZkkBiMpSLVps6jEKX76JeMNGDD6nK+snj
	 YWiBsiXML+jU3tKH5Hr2WEceWYUwA4Tzh3JUTHMGTJ+Z/m9IlFIRuLRsFBlhw38UNA+eE
	 HPoeIHGui+6fLUEUe7oswe+656Yaq3FO6BITMybc9vcIojV7jsz1pP0+w3arBbTY54g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdOa9ymv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B9E606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AdOa9ymv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFD51F000C6;
	Mon, 16 Nov 2026 23:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871057;
	bh=ZJeX8gtsRg93Bolqe/4zvsi+mU1h3OsIsi3wvXvUmG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdOa9ymvorL2tceJRiF4UCAIRf3WhRIKFWDy/D7zqmkFzPapuYqlQ9OrjhZkEi77Y
	 F8u1cg/2jxDC0HOanah+KpqRVbjWPjyNGUdJsl++ZbOSBB1U55B/CCjQHtIPtNwPtk
	 7kmFHXzeOZB3r0VV+oFovUKAq4FGG428WdfjlIejjR9RNwAX7FHRPfPEL/z9gwoywx
	 7X2QoihI6cAbg7veAC2oFxjbQb0U1HDIh0gWjta+LjY96bjjx7MsDNtSBJjKKnWjyl
	 23T75IOO8bysZwiLV7OAeMro401T2c5A+Wg3Czw8gdqRo98qkjBoBvOeqkTaT3JXP4
	 6U82NRoDX5wPQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 18/59] xfs: recover the transaction header as a validated item type
Date: Tue, 17 Nov 2026 10:14:35 +1100
Message-ID: <20261116231707.3625263-19-dgc@kernel.org>
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

The transaction header that starts each recovered transaction was decoded by
a bespoke path: xlog_recovery_process_trans() routed the first op records of
a transaction to xlog_recover_init_new_trans() based on an r_hdr_decoded
flag, which reassembled the header into r_theader with its own inline magic
and length checks. This is a second, parallel copy of the region assembly and
validation logic that the generic item path already provides, and it is not
subject to the item validation infrastructure.

Decode the header through the generic item machinery instead. The header is
laid out so that the first two 16 bit words at the front of its single region
- which xlog_recover_add_item() reads as the item type and region count -
overlap the 32 bit th_magic field. Register an xlog_recover_item_ops keyed on
the magic so the header is assembled, validated and completed exactly like any
other item, and consumed via its ->complete() method (copied into the
transaction and freed rather than queued for replay).

The XFS log is written in host byte order, so which half of th_magic is read
as the type depends on the endianness of the host that wrote the log. Two ops
entries are registered, one for each order; on any given host only one of the
two type codes is matched. The type-count method validates that the other
half of the magic is present and returns a region count of 1, the region
validation checks the full magic and exact header length once assembled, and
min_hdr_len rejects a short header.

With the header handled as an item, xlog_recover_init_new_trans(), the
r_hdr_decoded flag and the special-case dispatch in
xlog_recovery_process_trans() are all removed; a header op record now falls
through to xlog_recover_add_to_trans()/add_to_cont_trans() like any other
region.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |   1 -
 fs/xfs/xfs_log_recover.c        | 199 +++++++++++++++++++-------------
 2 files changed, 121 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index dbb4bb5c57ad..f4dbed616ee6 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -168,7 +168,6 @@ struct xlog_recover {
 	int			r_state;	/* not needed */
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */
-	bool			r_hdr_decoded;	/* trans header fully decoded */
 	struct xlog_recover_item *r_cur_item;	/* item currently being rebuilt */
 };
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index dee839b831b1..4f05b5130bdd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1801,7 +1801,128 @@ xlog_recover_iget_handle(
  *
  ******************************************************************************
  */
+
+/*
+ * The transaction header that starts each recovered transaction is not a log
+ * item, but it is decoded from the journal as a region in exactly the same way.
+ * Give it an xlog_recover_item_ops so it is assembled and validated through the
+ * same generic machinery as everything else, then consumed into the
+ * transaction rather than queued for replay.
+ *
+ * ITEM_TYPE() and xlog_recover_add_item() read the 16 bit type and region count
+ * from the first two 16 bit words at the front of the first region. For the
+ * transaction header these words overlap the 32 bit th_magic field, so the two
+ * halves of the magic act as the type and the region count. The XFS log is
+ * written in host byte order, so which half is read as the type depends on the
+ * endianness of the host that wrote the log: on a little endian host the type
+ * is 0x414e and the count is 0x5452, and on a big endian host they are the
+ * other way around. Register an ops entry for each order so a log is recovered
+ * correctly regardless of the byte order it was written in; on any given host
+ * only one of the two type codes is ever matched. Neither 0x414e nor 0x5452
+ * collides with an XFS_LI_* type code.
+ *
+ * The header always has a single region regardless of the count read from the
+ * journal, so validate_nregions() checks that the other half of the magic is
+ * present and returns 1.
+ */
+#define XLOG_TRANS_HDR_MAGIC_LO		((uint16_t)XFS_TRANS_HEADER_MAGIC)
+#define XLOG_TRANS_HDR_MAGIC_HI		((uint16_t)(XFS_TRANS_HEADER_MAGIC >> 16))
+
+static int
+xlog_recover_trans_hdr_check_half(
+	struct xlog			*log,
+	uint16_t			nregions,
+	uint16_t			expected)
+{
+	if (nregions != expected) {
+		xfs_warn(log->l_mp,
+	"bad transaction header magic number 0x%x, expected 0x%x",
+			nregions, expected);
+		return -EFSCORRUPTED;
+	}
+	return 1;
+}
+
+/* Little endian host: type is the low half, count is the high half. */
+static int
+xlog_recover_trans_hdr_nregions_le(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	return xlog_recover_trans_hdr_check_half(log, nregions,
+			XLOG_TRANS_HDR_MAGIC_HI);
+}
+
+/* Big endian host: type is the high half, count is the low half. */
+static int
+xlog_recover_trans_hdr_nregions_be(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	return xlog_recover_trans_hdr_check_half(log, nregions,
+			XLOG_TRANS_HDR_MAGIC_LO);
+}
+
+static int
+xlog_recover_trans_hdr_validate(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	struct xfs_trans_header		*thdr = item->ri_buf[region_index].iov_base;
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (len != sizeof(struct xfs_trans_header)) {
+		xfs_warn(log->l_mp,
+	"bad transaction header length %zu, expected %zu",
+			len, sizeof(struct xfs_trans_header));
+		return -EFSCORRUPTED;
+	}
+
+	if (thdr->th_magic != XFS_TRANS_HEADER_MAGIC) {
+		xfs_warn(log->l_mp,
+	"bad transaction header magic number 0x%x, expected 0x%x",
+			thdr->th_magic, XFS_TRANS_HEADER_MAGIC);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+static int
+xlog_recover_trans_hdr_complete(
+	struct xlog			*log,
+	struct xlog_recover		*trans,
+	struct xlog_recover_item	*item)
+{
+	/*
+	 * The header has been validated. Copy it into the transaction and
+	 * consume the item - it is not a log item and is not replayed.
+	 */
+	memcpy(&trans->r_theader, item->ri_buf[0].iov_base,
+			sizeof(struct xfs_trans_header));
+	return XLOG_RECOVER_ITEM_CONSUMED;
+}
+
+static const struct xlog_recover_item_ops xlog_trans_hdr_le_item_ops = {
+	.item_type		= XLOG_TRANS_HDR_MAGIC_LO,
+	.min_hdr_len		= sizeof(struct xfs_trans_header),
+	.validate_nregions	= xlog_recover_trans_hdr_nregions_le,
+	.validate_region	= xlog_recover_trans_hdr_validate,
+	.complete		= xlog_recover_trans_hdr_complete,
+};
+
+static const struct xlog_recover_item_ops xlog_trans_hdr_be_item_ops = {
+	.item_type		= XLOG_TRANS_HDR_MAGIC_HI,
+	.min_hdr_len		= sizeof(struct xfs_trans_header),
+	.validate_nregions	= xlog_recover_trans_hdr_nregions_be,
+	.validate_region	= xlog_recover_trans_hdr_validate,
+	.complete		= xlog_recover_trans_hdr_complete,
+};
+
 static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
+	&xlog_trans_hdr_le_item_ops,
+	&xlog_trans_hdr_be_item_ops,
 	&xlog_buf_item_ops,
 	&xlog_inode_item_ops,
 	&xlog_dquot_item_ops,
@@ -2255,67 +2376,6 @@ xlog_recover_complete_region(
 	return 0;
 }
 
-/*
- * Decode the transaction header at the start of a new transaction.
- *
- * The transaction header is not a log item. It can be arbitrarily split across
- * op records, so it may arrive whole in a single op record, or as an initial
- * fragment (cont == false) followed by one or more continuation fragments
- * (cont == true). Reassemble it directly into r_theader where the rest of
- * recovery expects to find it.
- */
-STATIC int
-xlog_recover_init_new_trans(
-	struct xlog		*log,
-	struct xlog_recover	*trans,
-	char			*dp,
-	int			len,
-	bool			cont,
-	bool			region_complete)
-{
-	char			*ptr;
-
-	/*
-	 * All regions are 32 bit aligned, so the smallest valid fragment is 4
-	 * bytes; that is also the minimum needed to read the magic number. A
-	 * fragment larger than the whole header is corruption in either case.
-	 */
-	if (len < 4 || len > sizeof(struct xfs_trans_header)) {
-		xfs_warn(log->l_mp, "%s: bad header length %d", __func__, len);
-		return -EFSCORRUPTED;
-	}
-
-	if (!cont) {
-		/*
-		 * Initial fragment. The magic number is at the start of the
-		 * header, which lands at the start of r_theader.
-		 */
-		if (*(uint *)dp != XFS_TRANS_HEADER_MAGIC) {
-			xfs_warn(log->l_mp,
-			"%s: bad header magic number 0x%x, expected 0x%x",
-				__func__, *(uint *)dp, XFS_TRANS_HEADER_MAGIC);
-			return -EFSCORRUPTED;
-		}
-		ptr = (char *)&trans->r_theader;
-	} else {
-		/* continuation fragment completes the tail of the header */
-		ptr = (char *)&trans->r_theader +
-				sizeof(struct xfs_trans_header) - len;
-	}
-
-	memcpy(ptr, dp, len);
-
-	/*
-	 * The transaction header is a single region, so it is fully decoded
-	 * once the region is complete. The header is not a log item, so nothing
-	 * is added to the item queue here; the first log item region decoded
-	 * after this will start the first item.
-	 */
-	if (region_complete)
-		trans->r_hdr_decoded = true;
-	return 0;
-}
-
 STATIC int
 xlog_recover_add_to_cont_trans(
 	struct xlog		*log,
@@ -2486,22 +2546,6 @@ xlog_recovery_process_trans(
 	if (flags & XLOG_WAS_CONT_TRANS)
 		flags &= ~XLOG_CONTINUE_TRANS;
 
-	/*
-	 * Until the transaction header has been fully decoded we are still
-	 * assembling it at the start of the transaction rather than decoding a
-	 * log item. The header can arrive whole (flags == 0), as an initial
-	 * fragment (XLOG_CONTINUE_TRANS) or as a continuation fragment
-	 * (XLOG_WAS_CONT_TRANS); XLOG_WAS_CONT_TRANS distinguishes the
-	 * continuation.
-	 */
-	if (!trans->r_hdr_decoded &&
-	    (!flags || (flags & (XLOG_CONTINUE_TRANS | XLOG_WAS_CONT_TRANS)))) {
-		error = xlog_recover_init_new_trans(log, trans, dp, len,
-					flags & XLOG_WAS_CONT_TRANS,
-					region_complete);
-		goto out_error;
-	}
-
 	/*
 	 * Callees must not free the trans structure. We'll decide if we need to
 	 * free it or not based on the operation being done and it's result.
@@ -2551,7 +2595,6 @@ xlog_recovery_process_trans(
 		break;
 	}
 
-out_error:
 	if (error || freeit)
 		xlog_recover_free_trans(trans);
 	return error;
-- 
2.55.0

