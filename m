Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871106;
	b=N08/pWZc8W6u3s35pQkkYMKEBzVt7fPQ81MBelqlQe+LHNsYk0zLlo2gUP6ke2qRFA0I
	 0SToWeVy3OtFsGtPPBU59A3aac38BctEiT0BxZjR8DqYDzp0Mx2VULe/vXj+DcW2bk8Ls
	 5AwWkaIga9eqNbhyzzcT6ZiGR7qAhEM7psW3pUaKN1p5ToVFXkVCEjE9EzFadB2rwmF6O
	 aYUgR8L9/NviWpuV1Hn35Yvo7lHs435/2KOK+F2UfZKBoUMLXBhVvbQKO6m5O6vYzTiho
	 aMTjSHpzankS8VMIRIgUtHFJUDstSwQ4r4wgtMiI5unVV5CwZmXe3/a0eqB6p0d7psA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=8b9Dm3zm2QSoepzmw/0Iaeo8c91/ghaImt1BDBfoajw=;
	b=wx/EFJv3K9vvAPn8YBQEd+RjXLa6GJRlR1yAVcmRv3hENsqvM7EiTmIb+EojdxpqyXkF
	 eTzGoyzq1FXY1Y7t2ceYJRN5V6Hb9e42wheI+6KkVLi47wIyZ0/Ee6JF6TeiyurJda+u0
	 Si/oOy2vSwL/3qXnh1x3MySETMoSazNDZg3/M8e0J0at2ymLZRLNnzV83vSohl6MnVHka
	 9utN3D+WRCsA0t3WagUh02rqftd4hZoo7MFaD2ZR/9sgdIeI/udG2SW9G+zXwaqzg30qi
	 RYZff3SwbnzyDdWAO1azE1cBbsCFs1BnU91MxF5xADKzKAOCC9PB5SezjfEWnNF7ASA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEU95eOl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1171606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEU95eOl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFFA1F000C4;
	Mon, 16 Nov 2026 23:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871106;
	bh=8b9Dm3zm2QSoepzmw/0Iaeo8c91/ghaImt1BDBfoajw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEU95eOlvhTkwm5CxycQNGDWLRX1GYzAIj1lTnz72U8kRncuBkQTPCQwn7Lx1w9T5
	 3/coSkuMLtRWVGOysN6YnHUa45v5svZKlMfwZgWFQ8WeuGQE0cnsMArKQTGfHA8v2+
	 tP5yLc7oBlEhocztip/tX4GEk7hHgZG/zQlJYZWGM2YcxTQlrIrmt5ddaaIRXUjobM
	 Y41MTfMscAaqSus+zgJXdRPU4dnqzKHB+gyzsYkpDcsDFXxywphl1ECM19ZM5ZkiIx
	 /P8XIqMHPjknIY0SrnWU+mb3V/8rJzl/21v49c3X/7KUQJGwLLFkqL91hvcyAnLAw4
	 jalLeSLAcPGug==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 56/59] xfs: validate the whole buffer item during recovery
Date: Tue, 17 Nov 2026 10:15:13 +1100
Message-ID: <20261116231707.3625263-57-dgc@kernel.org>
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

Validate a buffer log item once all its regions are decoded from the journal.
The rest of recovery can then trust it. The item size must match the number of
regions attached. The buffer must lie wholly within the data device.

A cancelled buffer is not replayed. It logs only its format header, so it must
be a single region. Nothing further is checked for a cancelled buffer.

Any other buffer must log at least one dirty region. It must record a valid
buffer type. A type flag, if set, must match the buffer type. The type flags
select special replay handling. A buffer logged for full replay carries only
its type, even if it holds inodes or dquots. V4 inode allocation and online
repair log buffers this way, so a missing type flag is valid. The dirty
regions must correspond to the dirty bitmap. They must not describe more than
a buffer's worth of data.

All CRC enabled filesystems record buffer types. Older V4 filesystems may log
buffers without a type. An unknown type is accepted only on those filesystems.
Such a buffer may have no more than one type flag set.

Historically, a dirty region that spanned a page boundary in a buffer could be
split into two logged regions. The runtime code has not triggered this split
logging in kernel git history, so we should never encounter it during recovery.
Hence each run of dirty bits must map to a single region.

The buffer block range is checked against the data device size held in the
buftarg rather than the superblock geometry. Deriving a shared daddr range
helper is left for later.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/scrub/inode_repair.c   |  14 +++
 fs/xfs/scrub/quota_repair.c   |   7 ++
 fs/xfs/xfs_buf_item_recover.c | 185 ++++++++++++++++++++++++++++++++++
 3 files changed, 206 insertions(+)

diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 2dd3ea7fb361..3eff8cc66d1e 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -204,6 +204,13 @@ xrep_dinode_buf_core(
 	if (!unlinked_ok)
 		dip->di_next_unlinked = cpu_to_be32(NULLAGINO);
 	xfs_dinode_calc_crc(mp, dip);
+
+	/*
+	 * We don't mark the buffer with xfs_trans_inode_buf() as that would
+	 * cause recovery to only replay unlinked list pointers. However, we
+	 * still need to set the buffer type for recovery to correctly classify
+	 * it as an inode buffer.
+	 */
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
 	xfs_trans_log_buf(tp, bp, ioffset,
 				  ioffset + sizeof(struct xfs_dinode) - 1);
@@ -1632,6 +1639,13 @@ xrep_dinode_core(
 	/* Write out the inode. */
 	trace_xrep_dinode_fixed(sc, dip);
 	xfs_dinode_calc_crc(mp, dip);
+
+	/*
+	 * We don't mark the buffer with xfs_trans_inode_buf() as that would
+	 * cause recovery to only replay unlinked list pointers. However, we
+	 * still need to set the buffer type for recovery to correctly classify
+	 * it as an inode buffer.
+	 */
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_DINO_BUF);
 	xfs_trans_log_buf(sc->tp, bp, ri->imap.im_boffset,
 			ri->imap.im_boffset + mp->m_sb.sb_inodesize - 1);
diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 88e341d6d1af..8660cbf4683a 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -408,6 +408,13 @@ xrep_quota_block(
 		buftype = XFS_BLFT_PDQUOT_BUF;
 		break;
 	}
+
+	/*
+	 * We don't mark the buffer with xfs_trans_dquot_buf() as that would
+	 * cause recovery to skip replaying it when quotas are not in use.
+	 * However, we still need to set the buffer type for recovery to
+	 * correctly classify it as a dquot buffer.
+	 */
 	xfs_trans_buf_set_type(sc->tp, bp, buftype);
 	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
 	return xrep_roll_trans(sc);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8fb419aba094..d8cec17bbb4e 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1271,11 +1271,196 @@ xlog_recover_buf_validate_region(
 	return 0;
 }
 
+/* The buffer type flags. A buffer has at most one of these set. */
+#define XFS_BLF_TYPE_MASK \
+	(XFS_BLF_INODE_BUF | XFS_BLF_UDQUOT_BUF | XFS_BLF_PDQUOT_BUF | \
+	 XFS_BLF_GDQUOT_BUF)
+
+/*
+ * The buffer type is recorded both in the top bits of the format flags and in
+ * the type flags, and they describe different things. The type field
+ * describes the metadata held in the buffer. The type flags select special
+ * replay handling. An inode buffer flag replays only the unlinked list
+ * pointers, and a dquot buffer flag skips replay when that quota type is not
+ * in use. A buffer logged for full replay carries only its type, even if it
+ * holds inodes or dquots. V4 inode allocation and online repair log buffers
+ * this way.
+ *
+ * A buffer therefore carries at most one type flag, and if it has one it must
+ * be the one the type field describes.
+ */
+static xfs_failaddr_t
+xlog_recover_buf_verify_type(
+	struct xfs_mount		*mp,
+	uint16_t			blft,
+	unsigned int			type)
+{
+	unsigned int			expected;
+
+	/*
+	 * All CRC enabled filesystems have buffer types defined. Older V4
+	 * filesystems may not have types set, so allow an unknown type only in
+	 * that case.
+	 */
+	if (blft == XFS_BLFT_UNKNOWN_BUF && !xfs_has_crc(mp)) {
+		/*
+		 * Only one inode or dquot buffer type flag can be set on a
+		 * buffer. Without a buffer type there is nothing to validate
+		 * the specific flag against, so only check that no more than
+		 * one of them is set.
+		 */
+		if (type & (type - 1))
+			return __this_address;
+		return NULL;
+	}
+
+	if (blft <= XFS_BLFT_UNKNOWN_BUF || blft >= XFS_BLFT_MAX_BUF)
+		return __this_address;
+
+	switch (blft) {
+	case XFS_BLFT_DINO_BUF:
+		expected = XFS_BLF_INODE_BUF;
+		break;
+	case XFS_BLFT_UDQUOT_BUF:
+		expected = XFS_BLF_UDQUOT_BUF;
+		break;
+	case XFS_BLFT_PDQUOT_BUF:
+		expected = XFS_BLF_PDQUOT_BUF;
+		break;
+	case XFS_BLFT_GDQUOT_BUF:
+		expected = XFS_BLF_GDQUOT_BUF;
+		break;
+	default:
+		expected = 0;
+		break;
+	}
+
+	if (type && type != expected)
+		return __this_address;
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
+	/* A buffer that is not cancelled always logs some dirty data. */
+	if (item->ri_total < 2) {
+		xfs_warn(log->l_mp,
+			"BUF: buffer has no dirty regions recovered.");
+		return -EFSCORRUPTED;
+	}
+
+	fa = xlog_recover_buf_verify_type(log->l_mp, xfs_blft_from_flags(blf),
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

