Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C150C3BCD2B
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871341; cv=none; b=T4EoUGQBqnFxhqazWCLmUlLIwr3L/lEQrQp2O+SyomefKLs4QOkcJsPoARN6PfEY+aDfL061OYTXOvQYY+vfWzRpmhYER9cQgRUDVFSRhXT6j7uUryEWhcigyjiJMCzxig0ZX2YfnN6YeGl1HY0i2s/JsVTyBkpO2qtCYCyYP18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871341; c=relaxed/simple;
	bh=EZtBbbTD6szIgsUFnh2OoKidzYwrxhW5N8pP3SN2bc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kraNDWpE7AO66UVGmvMCJIeqhWTuJBVA/EatNPQ945eO8hsaz+3+Kq1qTZJDDcsTgKBtH/har7GYkMCz4Ymnuwh0A+J+OMRgplAGXtXeGYn/v85bGM1P0exBiZBMYiD7duSfyZcoY0QDkyipZVCw9H09tHFUpXQYAUdlEEcUXs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ibcuYTnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ibcuYTnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E744A1F00893;
	Tue, 13 Oct 2026 06:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871339;
	bh=4yzpgKgVFnlvpC/391fZg14iW2cr/JMTHRv13IyUu7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibcuYTnM5asXX5o2rvTuz6Rpml7GbY5bTDTBsVe6gF3ZaBkeksFgzg/SJ7zNIhvN8
	 F/rNEIReG6Na6tbnr7OrLaXiAgJEelAnEesejL9KikekQJV3JwtVh5RetrnLS+yGIB
	 XlTGIdPQMxgRGvlr5xS9LLFXm+sRrA17XGHJVUWMOb7POQNGsxnd4XpyXOQgalZ/Hd
	 dBOLO5YRY8gcCZU2yURB/z5bU9zjjQhShmqqwQEBpzo3r1bkw8fq4+L+w3ndmxKBlA
	 gHsj36/hyGs4kNqwCwb7FR0N9xBKJYoOxAo/aDYRi1V8sV8owE8ilov7iDi6VhjK5z
	 U9m38KCVmBY2A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 08/48] xfs: recover the transaction header as a validated item type
Date: Tue, 13 Oct 2026 17:00:58 +1100
Message-ID: <20261013060204.3138690-9-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 .../xfs-log-recovery-validation-design.rst    |  89 ++++----
 fs/xfs/libxfs/xfs_log_recover.h               |   1 -
 fs/xfs/xfs_log_recover.c                      | 199 +++++++++++-------
 3 files changed, 173 insertions(+), 116 deletions(-)

diff --git a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
index c0785dbaef12..4cbe4ab67bc0 100644
--- a/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
+++ b/Documentation/filesystems/xfs/xfs-log-recovery-validation-design.rst
@@ -81,35 +81,42 @@ Transaction header as a validated type
 The transaction header (``struct xfs_trans_header``) is currently decoded
 inline in ``add_to_trans`` with bespoke magic number and length checks, and
 its continuation is handled separately in ``add_to_cont_trans``. Instead,
-treat it as a regular validated type within the same framework:
+treat it as a regular validated type within the same framework by giving it
+an ``xlog_recover_item_ops`` entry:
 
-- Add a pseudo item type (e.g. ``XFS_LI_TRANS_HDR`` or use the magic
-  number ``XFS_TRANS_HEADER_MAGIC`` as the type code) with its own
-  ``xlog_recover_item_ops`` entry.
-- ``min_regions = 1``, ``max_regions = 1``
 - ``min_hdr_len = sizeof(struct xfs_trans_header)``
+- ``validate_nregions`` always returns a region count of 1 (see the
+  endianness note below)
 - ``validate_region`` checks ``iov_len == sizeof(struct xfs_trans_header)``
   and the magic number
-- No ``commit_pass1``/``commit_pass2`` callbacks — after validation, the
-  decoded transaction header is copied to ``trans->r_theader`` as before
-
-This eliminates the special-case parsing in ``add_to_trans`` and
-``add_to_cont_trans`` for the transaction header. The zero-length first
-fragment case is handled uniformly: it arrives as a continuation
-(``oh_len == 0``, ``XLOG_CONTINUE_TRANS`` set), and the continuation
-infrastructure assembles the complete region before ``validate_region``
-checks it.
-
-The ``ilf_size`` field of the transaction header format is a bit different
-— ``xfs_trans_header`` uses ``th_num_items`` rather than the generic
-``ilf_size`` at offset 2. Since the transaction header always has exactly
-1 region, we don't need to read ``ilf_size`` from it. The
-``ops->min_regions == ops->max_regions == 1`` is sufficient.
-
-Alternatively, the transaction header could be handled without a full
-ops entry by having the generic code recognise it as a special case
-at step (b) and apply its fixed constraints directly. Either approach
-works; the ops entry is cleaner but the special case is simpler.
+- ``complete`` copies the decoded header to ``trans->r_theader`` and
+  returns ``XLOG_RECOVER_ITEM_CONSUMED`` so it is freed rather than queued
+  for replay — the header is not a log item and has no
+  ``commit_pass1``/``commit_pass2`` handler
+
+The header has no format header of the ``type/size`` shape: its first 32
+bits are ``th_magic``. When ``add_to_trans`` reads the first two 16 bit
+words as the type and region count, they land on the two halves of the
+magic. The type-half is used as the ops key, and ``validate_nregions``
+checks that the count-half holds the other half of the magic before
+returning 1 (the header always has a single region).
+
+Because the XFS log is written in host byte order, which half of the magic
+is read as the type depends on the endianness of the host that wrote the
+log. Register two ops entries, one for each order (``item_type`` of
+``0x414e``/``0x5452``, with the complementary half checked by
+``validate_nregions``); on any given host only one is ever matched, and
+neither type code collides with an ``XFS_LI_*`` value.
+
+Routing the header through the generic assembly removes the special-case
+parsing in ``add_to_trans`` and ``add_to_cont_trans``, and lets
+``xlog_recover_init_new_trans()``, the ``r_hdr_decoded`` flag and the
+header dispatch branch in ``xlog_recovery_process_trans()`` be deleted — a
+header op record now falls through to the generic region assembly like any
+other. The zero-length first fragment case is handled uniformly: it arrives
+as a continuation (``oh_len == 0``, ``XLOG_CONTINUE_TRANS`` set), and the
+continuation infrastructure assembles the complete region before
+``validate_region`` checks it.
 
 New members in ``struct xlog_recover_item_ops``::
 
@@ -414,19 +421,20 @@ Patch 1: Add validation infrastructure to the ops struct
       unknown-type rejection moving earlier
 
 Patch 2: Treat the transaction header as a validated region type
-    - Add an ops entry for the transaction header keyed on the low 16 bits
-      of ``XFS_TRANS_HEADER_MAGIC``, with ``min_regions = 1``,
-      ``max_regions = 1``, ``min_hdr_len = sizeof(struct xfs_trans_header)``
-      and a ``validate_region`` that checks ``iov_len`` and the magic
-      number
+    - Add two ops entries for the transaction header, keyed on the two
+      halves of ``XFS_TRANS_HEADER_MAGIC`` (one per host byte order), each
+      with ``min_hdr_len = sizeof(struct xfs_trans_header)``, a
+      ``validate_nregions`` that checks the other half of the magic and
+      returns 1, a ``validate_region`` that checks ``iov_len`` and the magic
+      number, and a ``complete`` that copies the header to
+      ``trans->r_theader`` and returns ``XLOG_RECOVER_ITEM_CONSUMED``
     - Remove the bespoke transaction header parsing from ``add_to_trans``
       and ``add_to_cont_trans``; route through the generic region assembly
-    - Handle the zero-length first fragment case (``len == 0`` with empty
-      ``r_itemq``) by deferring to the continuation path
-    - Add the ``validate_region`` call site(s) needed for the transaction
-      header (generic call sites for all other types are wired in Patch 7)
-    - After validation, copy the decoded header to ``trans->r_theader``
-      as before
+    - Delete ``xlog_recover_init_new_trans()``, the ``r_hdr_decoded`` flag
+      and the header dispatch branch in ``xlog_recovery_process_trans()``
+    - The zero-length first fragment case is handled by the continuation
+      path (see the note below on ``add_to_cont_trans`` needing a
+      ``r_cur_item != NULL`` guard, added in Patch 5)
 
 Patch 3: Move item ops lookup to add_to_trans (first region decode)
     - Look up and store ``ri_ops`` when ``ri_total == 0``
@@ -444,7 +452,14 @@ Patch 4: Populate validate_nregions/min_hdr_len for all item types
       time from Patch 1
 
 Patch 5: Fix generic safety issues
-    - ``add_to_cont_trans``: check ``ri_cnt > 0`` and ``ri_buf != NULL``
+    - ``add_to_cont_trans``: check there is an item under assembly
+      (``trans->r_cur_item != NULL``) before dereferencing it. A corrupt
+      log whose first op record is a continuation fragment
+      (``XLOG_WAS_CONT_TRANS`` with no preceding initial fragment) reaches
+      ``add_to_cont_trans`` with no current item; reject it rather than
+      dereferencing NULL. (Now that the transaction header is decoded as an
+      item in Patch 2, this also covers the header's leading-continuation
+      case, which the old ``xlog_recover_init_new_trans()`` handled itself.)
     - ``add_to_cont_trans``: bounds-check accumulated region size before
       ``kvrealloc``
     - ``process_data``: validate ``oh_len`` alignment
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
index 7ed6616f7075..f2c814f1e78e 100644
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
@@ -2538,7 +2582,6 @@ xlog_recovery_process_trans(
 		break;
 	}
 
-out_error:
 	if (error || freeit)
 		xlog_recover_free_trans(trans);
 	return error;
-- 
2.55.0

