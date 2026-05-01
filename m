Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2AF39F181
	for <linux-xfs@vger.kernel.org>; Fri,  1 May 2026 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634448; cv=none; b=MWJ2ORrbw8Q0JyIh7GU8TfZeTptsaBi9gjk2Z81C6FsahTixICufW8zYyXwh4mwiz35Utmj7NjZNvIP73sxWGkVRgexHfl4XZbZakuTUjN4n100iBtg0llz1chrcIHTqpGvNoThuaqCl5moR58xmPpo/kQi/6FYbcfgjaXEKwpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634448; c=relaxed/simple;
	bh=ZiQtVpwVViWIFHwdAljTUHOrxATNMWkUoS+nAZs0+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tssOl6znCzPVwCZZy1nNiHkRhvKYoEDs/DnfOq2PbBYq4JltqWAYNFvrdbnsQ0zA1Ryn4hVmL9pciaOkkhEgMSP3UJskZhrnKlF2KZotUWr34h8C0qk0QNhjeKnA7CKgpKb0O26c3TPrZmVrrHpxisqNhEqD4g26BroMedCNPo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=pankajraghav.com; arc=none smtp.client-ip=80.241.56.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4g6T9l27p5z9tqP;
	Fri,  1 May 2026 13:20:43 +0200 (CEST)
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::1 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
From: Pankaj Raghav <p.raghav@samsung.com>
To: linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	lukas@herbolt.com,
	"Darrick J . Wong" <djwong@kernel.org>,
	p.raghav@samsung.com,
	dgc@kernel.org,
	gost.dev@samsung.com,
	pankaj.raghav@linux.dev,
	andres@anarazel.de,
	kundan.kumar@samsung.com,
	cem@kernel.org,
	hch@infradead.org
Subject: [PATCH v4 1/2] xfs: add xfs_bmap_alloc_or_convert_range function
Date: Fri,  1 May 2026 13:20:25 +0200
Message-ID: <20260501112026.673609-2-p.raghav@samsung.com>
In-Reply-To: <20260501112026.673609-1-p.raghav@samsung.com>
References: <20260501112026.673609-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4g6T9l27p5z9tqP

Add xfs_bmap_alloc_or_convert_range() that can either allocate a range
and/or convert unwritten extents to written extents.

This function is based on xfs_iomap_write_unwritten() but we add an
extra flag parameter. Only XFS_BMAPI_CONVERT and/or XFS_BMAPI_ZERO is
accepted as flags to this function. This function also additionally
accounts while starting the transaction for the blocks that might
be created because of XFS_BMAPI_ZERO.

This is done as a preparation to add FALLOC_FL_WRITE_ZEROES flag.

xfs_iomap_write_unwritten() function will now just call
xfs_bmap_alloc_or_convert_range() with flag set to XFS_BMAPI_CONVERT.

Suggested-by: Dave Chinner <dgc@kernel.org>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
I feel like xfs_bmap_alloc_or_convert_range() has become a bit big and
logic repeated, should we rethink of going back to the original solution? [1]

[1] https://lore.kernel.org/linux-xfs/20260310194245.848034-2-lukas@herbolt.com/

 fs/xfs/xfs_iomap.c | 215 ++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_iomap.h |   2 +
 2 files changed, 155 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..40715589814a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -609,12 +609,30 @@ xfs_iomap_prealloc_size(
 	return alloc_blocks;
 }
 
+/*
+ * This function is used to allocate written extents over holes and/or convert
+ * unwritten extents to written extents based on the @flags passed to it.
+ *
+ * If @flags is zero, it will allocate written extents for holes and delalloc
+ * extents across the range.
+ *
+ * If XFS_BMAPI_CONVERT is specified in @flags, then it will also do conversion
+ * of unwritten extents in the range to written extents.
+ *
+ * If XFS_BMAPI_ZERO is specified in @flags, then both newly allocated extents
+ * and converted unwritten extents will be initialised to contain zeroes.
+ *
+ * If @update_isize is true, then if the range we are operating on extends
+ * beyond the current EOF, extend i_size to offset+len incrementally as extents
+ * in the range are allocated/converted.
+ */
 int
-xfs_iomap_write_unwritten(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,
-	xfs_off_t	count,
-	bool		update_isize)
+xfs_bmap_alloc_or_convert_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		count,
+	uint32_t		flags,
+	bool			update_isize)
 {
 	xfs_mount_t	*mp = ip->i_mount;
 	xfs_fileoff_t	offset_fsb;
@@ -625,98 +643,159 @@ xfs_iomap_write_unwritten(
 	xfs_bmbt_irec_t imap;
 	struct inode	*inode = VFS_I(ip);
 	xfs_fsize_t	i_size;
-	uint		resblks;
 	int		error;
+	int rt = XFS_IS_REALTIME_INODE(ip);
+	xfs_extlen_t	extsz, temp;
 
-	trace_xfs_unwritten_convert(ip, offset, count);
+	ASSERT((flags & ~(XFS_BMAPI_ZERO | XFS_BMAPI_CONVERT)) == 0);
 
+	extsz = xfs_get_extsz_hint(ip);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	count_fsb = (xfs_filblks_t)(count_fsb - offset_fsb);
 
-	/*
-	 * Reserve enough blocks in this transaction for two complete extent
-	 * btree splits.  We may be converting the middle part of an unwritten
-	 * extent and in this case we will insert two new extents in the btree
-	 * each of which could cause a full split.
-	 *
-	 * This reservation amount will be used in the first call to
-	 * xfs_bmbt_split() to select an AG with enough space to satisfy the
-	 * rest of the operation.
-	 */
-	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
-
 	/* Attach dquots so that bmbt splits are accounted correctly. */
 	error = xfs_qm_dqattach(ip);
 	if (error)
 		return error;
 
 	do {
+
+		uint	resblks, dblocks, bmapi_total, rblocks;
+		int	bmapi_error;
+
+		if (flags == XFS_BMAPI_CONVERT) {
+			/*
+			 * Reserve enough blocks in this transaction for two
+			 * complete extent btree splits.  We may be converting
+			 * the middle part of an unwritten extent and in this
+			 * case we will insert two new extents in the btree each
+			 * of which could cause a full split.
+			 *
+			 * This reservation amount will be used in the first call
+			 * to xfs_bmbt_split() to select an AG with enough space
+			 * to satisfy the rest of the operation.
+			 */
+			resblks = 0;
+			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks) << 1;
+			rblocks = 0;
+			bmapi_total = dblocks;
+		} else {
+			xfs_fileoff_t	s, e;
+			if (unlikely(extsz)) {
+				s = offset_fsb;
+				do_div(s, extsz);
+				s *= extsz;
+				e = offset_fsb + count_fsb;
+				div_u64_rem(offset_fsb, extsz, &temp);
+				if (temp)
+					e += temp;
+				div_u64_rem(e, extsz, &temp);
+				if (temp)
+					e += extsz - temp;
+			} else {
+				s = 0;
+				e = count_fsb;
+			}
+
+			/*
+			 * We might allocate data blocks (needs resblks + 1 split)
+			 * or convert an unwritten extent (needs 0 data blocks +
+			 * 2 splits). Ensure we have enough block reservation for
+			 * the worst case.
+			 */
+			resblks = XFS_FILBLKS_MIN((e - s), XFS_MAX_BMBT_EXTLEN);
+			bmapi_total = 0;
+			if (unlikely(rt)) {
+				rblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
+				dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+			} else {
+				rblocks = 0;
+				dblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
+				dblocks = max(dblocks,
+					XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1);
+			}
+		}
+
 		/*
-		 * Set up a transaction to convert the range of extents
-		 * from unwritten to real. Do allocations in a loop until
-		 * we have covered the range passed in.
+		 * Set up a transaction to convert the range of extents based on
+		 * the flags. Do allocations in a loop until we have covered the
+		 * range passed in.
 		 *
 		 * Note that we can't risk to recursing back into the filesystem
 		 * here as we might be asked to write out the same inode that we
 		 * complete here and might deadlock on the iolock.
 		 */
-		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks,
-				0, true, &tp);
+		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, dblocks,
+				rblocks, true, &tp);
 		if (error)
 			return error;
 
-		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
-				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (flags & XFS_BMAPI_CONVERT)
+			error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+					XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		else
+			error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+					XFS_IEXT_ADD_NOSPLIT_CNT);
+
 		if (error)
 			goto error_on_bmapi_transaction;
 
-		/*
-		 * Modify the unwritten extent state of the buffer.
-		 */
 		nimaps = 1;
 		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
-		if (error)
-			goto error_on_bmapi_transaction;
+					flags, bmapi_total, &imap, &nimaps);
+		bmapi_error = error;
+
+		if (error) {
+			if (error != -ENOSR)
+				goto error_on_bmapi_transaction;
+			/*
+			 * Keep searching until we get one contiguous
+			 * extent if we get ENOSR
+			 */
+			error = 0;
+		} else {
+			/*
+			 * Log the updated inode size as we go. We have to be
+			 * careful to only log it up to the actual write offset
+			 * if it is halfway into a block.
+			 */
+			i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
+			if (i_size > offset + count)
+				i_size = offset + count;
+			if (update_isize && i_size > i_size_read(inode))
+				i_size_write(inode, i_size);
+			i_size = xfs_new_eof(ip, i_size);
+			if (i_size) {
+				ip->i_disk_size = i_size;
+				xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+			}
 
-		/*
-		 * Log the updated inode size as we go.  We have to be careful
-		 * to only log it up to the actual write offset if it is
-		 * halfway into a block.
-		 */
-		i_size = XFS_FSB_TO_B(mp, offset_fsb + count_fsb);
-		if (i_size > offset + count)
-			i_size = offset + count;
-		if (update_isize && i_size > i_size_read(inode))
-			i_size_write(inode, i_size);
-		i_size = xfs_new_eof(ip, i_size);
-		if (i_size) {
-			ip->i_disk_size = i_size;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		if (error)
-			return error;
 
-		if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
-			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
-			return xfs_alert_fsblock_zero(ip, &imap);
+		if (!bmapi_error) {
+			if (unlikely(!xfs_valid_startblock(ip, imap.br_startblock))) {
+				xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+				return xfs_alert_fsblock_zero(ip, &imap);
+			}
+			if ((numblks_fsb = imap.br_blockcount) == 0) {
+				/*
+				 * The numblks_fsb value should always get smaller,
+				 * otherwise the loop is stuck.
+				 */
+				ASSERT(imap.br_blockcount);
+				break;
+			}
+			offset_fsb += numblks_fsb;
+			count_fsb -= numblks_fsb;
 		}
 
-		if ((numblks_fsb = imap.br_blockcount) == 0) {
-			/*
-			 * The numblks_fsb value should always get
-			 * smaller, otherwise the loop is stuck.
-			 */
-			ASSERT(imap.br_blockcount);
-			break;
-		}
-		offset_fsb += numblks_fsb;
-		count_fsb -= numblks_fsb;
+		if (error)
+			return error;
+
 	} while (count_fsb > 0);
 
 	return 0;
@@ -727,6 +806,18 @@ xfs_iomap_write_unwritten(
 	return error;
 }
 
+int
+xfs_iomap_write_unwritten(
+	xfs_inode_t	*ip,
+	xfs_off_t	offset,
+	xfs_off_t	count,
+	bool		update_isize)
+{
+	trace_xfs_unwritten_convert(ip, offset, count);
+	return xfs_bmap_alloc_or_convert_range(ip, offset, count,
+					XFS_BMAPI_CONVERT, update_isize);
+}
+
 static inline bool
 imap_needs_alloc(
 	struct inode		*inode,
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..ba7b06074539 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -16,6 +16,8 @@ int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
+int xfs_bmap_alloc_or_convert_range(struct xfs_inode *, xfs_off_t, xfs_off_t,
+		uint32_t, bool);
 xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
 		xfs_fileoff_t end_fsb);
 
-- 
2.51.2

