Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A37F3EAC76
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871386; cv=none; b=ku8fwAeoLbOsdFFXKuVevcE9PwzIfLE7CAZ+7aR0M5lWGTKE530JXRnPF2zx2xJ7ZoTJxnKSMKDA5/7xRnovbFaqPVMl7Azx2s0NPmVEQLDqWeYFG6FNZs6vBFIsbS5Gwszdn1h2BxY2+2YaX7LDKkkyNHZlPv6FLD9TutGIBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871386; c=relaxed/simple;
	bh=4WvR+MX/FCdW70Z278FHYMCBdlnqsBw3F+URI7bmXHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNzRUp00mHqikH4KffUGu3j9+8nznruc0/4VXx3yQ/3f2p9rQvnUBpFUlkcKJ1/dRjjWIw3Ru7aayqmw3Y/8GWvGcI0+ARZ6yVrM1193Ruk3cyA2m6EHMShzcTt6MC1MTxSC9myA0xfpIcNAfx9HwoTAI2BleJwQxjfhPGzcsI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlJBEQqg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlJBEQqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756971F000FF;
	Tue, 13 Oct 2026 06:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871385;
	bh=ozccFh2ztddoZEySshM4gLubzVcG/kJ6ncmN6dEt69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlJBEQqgUiuwxmFx+6a9CxrxGBi838y20px6lT9hS1cdUEkmg3laralB6fSx+mXTW
	 ZZIK5XgD4Uzio8A3FAuJ0MzWhlsNDLM24z5kG3NWGhQpjiBr4GFj5lWcF+bOMAnA1M
	 Bx3YUlbPIEqZfbksFNhEWxBdmarxnkLMLppZbf3ILn6DjThXjToXGl1vrXL0KCV8g5
	 aV1TUdL5tWv0CQFz1a6GnsFkntZvH5XDPQwB2kS5uzhP1YbsbV5RmY4EkL3RUSsghx
	 Lf15qIERou4DkfGVwDAv3BxKWN1gUq5wwVFhlXWF5Y87hCZM+TKTlr0bi9HOTk1y24
	 k+nzmbQMarB/A==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 45/48] xfs: validate the whole buffer item during recovery
Date: Tue, 13 Oct 2026 17:01:35 +1100
Message-ID: <20261013060204.3138690-46-dgc@kernel.org>
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

Validate a buffer log item once all its regions are decoded from the journal, so
the rest of recovery can trust it. The item size must match the number of
regions attached, and the buffer must lie wholly within the data device.

A cancelled buffer is not replayed and logs only its format header, so it is
required to be a single region and nothing further is checked. Any other buffer
must record a valid buffer type that agrees with its type flags, and its dirty
regions must correspond to the dirty bitmap without describing more than a
buffer's worth of data.

The buffer block range is checked against the data device size held in the
buftarg rather than the superblock geometry. Deriving a shared daddr range
helper is left for later.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 153 ++++++++++++++++++++++++++++++++++
 1 file changed, 153 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8cae5287e4fb..309260e65889 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1233,11 +1233,164 @@ xlog_recover_buf_validate_region(
 	return 0;
 }
 
+/* The buffer type flags. A buffer has at most one of these set. */
+#define XFS_BLF_TYPE_MASK \
+	(XFS_BLF_INODE_BUF | XFS_BLF_UDQUOT_BUF | XFS_BLF_PDQUOT_BUF | \
+	 XFS_BLF_GDQUOT_BUF)
+
+/*
+ * The buffer type is recorded both in the top bits of the format flags and in
+ * the type flags. Check the two agree: a buffer carries at most one type flag,
+ * and it must be the one the type field describes.
+ */
+static xfs_failaddr_t
+xlog_recover_buf_verify_type(
+	uint16_t			blft,
+	unsigned int			type)
+{
+	if (blft <= XFS_BLFT_UNKNOWN_BUF || blft >= XFS_BLFT_MAX_BUF)
+		return __this_address;
+
+	switch (blft) {
+	case XFS_BLFT_DINO_BUF:
+		if (type != XFS_BLF_INODE_BUF)
+			return __this_address;
+		break;
+	case XFS_BLFT_UDQUOT_BUF:
+		if (type != XFS_BLF_UDQUOT_BUF)
+			return __this_address;
+		break;
+	case XFS_BLFT_PDQUOT_BUF:
+		if (type != XFS_BLF_PDQUOT_BUF)
+			return __this_address;
+		break;
+	case XFS_BLFT_GDQUOT_BUF:
+		if (type != XFS_BLF_GDQUOT_BUF)
+			return __this_address;
+		break;
+	default:
+		if (type)
+			return __this_address;
+		break;
+	}
+
+	return NULL;
+}
+
+/*
+ * Validate the whole buffer item once all regions are assembled. The item size
+ * must match the number of regions attached. A cancelled buffer is not
+ * replayed, so it logs only the format header. Any other buffer must have a
+ * valid type, and its dirty regions must match the dirty bitmap and not
+ * describe more than a buffer's worth of data.
+ */
+static int
+xlog_recover_buf_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_buf_log_format	*blf = item->ri_buf[0].iov_base;
+	xfs_daddr_t			eofs = log->l_mp->m_ddev_targp->bt_nr_sectors;
+	xfs_failaddr_t			fa;
+	size_t				total = 0;
+	unsigned int			ri = 1;
+	int				first_bit;
+
+	if (blf->blf_size != item->ri_total) {
+		xfs_warn(log->l_mp,
+			"BUF: item size %u does not match region count %u recovered.",
+			blf->blf_size, item->ri_total);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * The buffer length is an invariant: a buffer cannot be larger than the
+	 * most data that can be logged in a single region.
+	 */
+	if (blf->blf_len == 0 || BBTOB(blf->blf_len) > XLOG_MAX_REGION_SIZE) {
+		xfs_warn(log->l_mp,
+			"BUF: bad buffer length %u recovered.", blf->blf_len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * The buffer must lie wholly within the data device. Guard against the
+	 * end wrapping so an out of range buffer cannot pass the bounds check.
+	 */
+	if (blf->blf_blkno < 0 ||
+	    blf->blf_blkno >= eofs ||
+	    blf->blf_blkno + blf->blf_len < blf->blf_blkno ||
+	    blf->blf_blkno + blf->blf_len > eofs) {
+		xfs_warn(log->l_mp,
+			"BUF: bad buffer block 0x%llx length %u recovered.",
+			blf->blf_blkno, blf->blf_len);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * A cancelled buffer overrides everything else. It is not replayed, so
+	 * it logs only the format header regardless of what the dirty bitmap
+	 * holds, and nothing else needs to be checked.
+	 */
+	if (blf->blf_flags & XFS_BLF_CANCEL) {
+		if (blf->blf_size != 1) {
+			xfs_warn(log->l_mp,
+				"BUF: cancelled buffer has %u regions recovered.",
+				blf->blf_size);
+			return -EFSCORRUPTED;
+		}
+		return 0;
+	}
+
+	fa = xlog_recover_buf_verify_type(xfs_blft_from_flags(blf),
+			blf->blf_flags & XFS_BLF_TYPE_MASK);
+	if (fa) {
+		xfs_warn(log->l_mp,
+			"BUF: type %u and flags 0x%x disagree recovered at %pS",
+			xfs_blft_from_flags(blf), blf->blf_flags, fa);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Each dirty region covers one contiguous run of set bits in the dirty
+	 * bitmap. Walk the bitmap and the regions together: each region size
+	 * must match the length of the run it covers, each run must lie within
+	 * the buffer, and the regions must exactly cover the bitmap. The dirty
+	 * data across all regions cannot be larger than the buffer itself.
+	 */
+	first_bit = xfs_next_bit(blf->blf_data_map, blf->blf_map_size, 0);
+	while (first_bit != -1) {
+		int	nbits = xfs_contig_bits(blf->blf_data_map,
+				blf->blf_map_size, first_bit);
+
+		if (ri >= item->ri_total ||
+		    item->ri_buf[ri].iov_len != (nbits << XFS_BLF_SHIFT) ||
+		    ((first_bit + nbits) << XFS_BLF_SHIFT) > BBTOB(blf->blf_len))
+			goto bad_map;
+
+		total += item->ri_buf[ri].iov_len;
+		ri++;
+		first_bit = xfs_next_bit(blf->blf_data_map, blf->blf_map_size,
+				first_bit + nbits + 1);
+	}
+
+	if (ri != item->ri_total || total > BBTOB(blf->blf_len))
+		goto bad_map;
+
+	return 0;
+
+bad_map:
+	xfs_warn(log->l_mp,
+		"BUF: dirty bitmap does not match regions recovered.");
+	return -EFSCORRUPTED;
+}
+
 const struct xlog_recover_item_ops xlog_buf_item_ops = {
 	.item_type		= XFS_LI_BUF,
 	.min_hdr_len		= offsetof(struct xfs_buf_log_format, blf_data_map),
 	.validate_nregions	= xlog_recover_buf_nregions,
 	.validate_region	= xlog_recover_buf_validate_region,
+	.validate_item		= xlog_recover_buf_validate_item,
 	.reorder		= xlog_recover_buf_reorder,
 	.ra_pass2		= xlog_recover_buf_ra_pass2,
 	.commit_pass1		= xlog_recover_buf_commit_pass1,
-- 
2.55.0

