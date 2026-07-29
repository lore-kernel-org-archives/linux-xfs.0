Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99544C4F1
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785319618; cv=none; b=KpIdu7MMyhV+/E0lX2D/sLyzNA2HGEtiYySeQv2J4eR4JE1+tQJP1fBq3fqKRj8waYWjFSvq4jLiWvC8psVJNMCRNRdjksotXsKuOp8w/txwA7f14dYPiMF6CzUaovq03jDvl7v70g4l8Ut4xhDDOSKgGcgbzUNG62Pvy8ENnAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785319618; c=relaxed/simple;
	bh=/lt3g3U51W2D7OdI0tMRog/oCUwxdYn6K9MVvP/MWYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXjvsTrtL7Om0ZK2l1dNatmKyZFbNM5qaUg/g3JkB468O/w73v+iSUedtCjkUZ7CISkl80Jfz/U+9RemJ8dBaf3XERAtwvSm8i2woRZ4D/TyBBpHj5zYyu0CDfgTz28Ium750cbx3vWH1924xifcRwDGDvx2aJyccRmeoxOHyMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXsEsEby; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXsEsEby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6441F000E9;
	Wed, 29 Jul 2026 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785319617;
	bh=msUJA9YyQshYDymulk4BAzVtNnWr/m0OvRTtp3RwxLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXsEsEbyYOPTVzvj3Swkz9nDduBEDglFaQrTCqdicVdj/W6drniY2K4JOMxCN4/Ft
	 FqLzLoD1HWoJQJExezd0yRGJqtyx/GdR07o3OgKNuR6YBqWSwiFpUbYAKyCfH8doLs
	 dfOemqb6edu+Pv+idJAQXx+OZGQy2Oxk9dSudfR+yf10RuxvLhOP8huxcHBqxelGIC
	 JvssF8K4UhcTM4dJM2kpnBj4wyCjgE8OUVaCeF0BrRjsWZhMVCoVUhSQRFxyBbMc/1
	 yPHsVHsxSBENF0c8Yxkp4D63WP+rAhf44jbC/lB+sgKL3m9cml56fQc0ZNk4q3+F5h
	 7fhZYx6aKT4ZA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 19/33] xfs: factor out xfs_iomap_write_unwritten_one helper
Date: Wed, 29 Jul 2026 20:02:03 +1000
Message-ID: <20260729100629.1943710-20-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729100629.1943710-1-dgc@kernel.org>
References: <20260729100629.1943710-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extract the per-iteration unwritten extent conversion work from
xfs_iomap_write_unwritten() into a new helper function
xfs_iomap_write_unwritten_one().

The helper takes a caller-supplied transaction and performs the
extent count extension, unwritten-to-written conversion via
xfs_bmapi_write(), and inode size update for a single extent.

The startblock validation check remains in the caller after the
transaction commit, as it is a corruption detection check that
should warn and return an error without causing a filesystem
shutdown from cancelling a dirty transaction.

This is a pure refactoring with no functional change, done to
prepare for converting the loop to use rolling transactions.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 103 +++++++++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2f18a8f62e39..16feac3ad3bd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -609,6 +609,59 @@ xfs_iomap_prealloc_size(
 	return alloc_blocks;
 }
 
+/*
+ * Convert a single unwritten extent to a real extent using the supplied
+ * transaction. Returns the converted extent via @imap.
+ */
+static int
+xfs_iomap_write_unwritten_one(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_filblks_t		count_fsb,
+	xfs_off_t		end,
+	bool			update_isize,
+	uint			resblks,
+	struct xfs_bmbt_irec	*imap)
+{
+	xfs_fsize_t		i_size;
+	int			nimaps;
+	int			error;
+
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+			XFS_IEXT_WRITE_UNWRITTEN_CNT);
+	if (error)
+		return error;
+
+	nimaps = 1;
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
+				XFS_BMAPI_CONVERT, resblks, imap, &nimaps);
+	if (error)
+		return error;
+
+	/*
+	 * Update the inode size to reflect the extent that was converted in
+	 * this iteration. We must not advance isize beyond the extent we just
+	 * converted, otherwise a crash before the next conversion exposes
+	 * unwritten extents (zeroes) to userspace instead of the written data.
+	 * Clamp to the byte-level write end in case the converted extent
+	 * extends past the write boundary.
+	 */
+	i_size = XFS_FSB_TO_B(ip->i_mount,
+			imap->br_startoff + imap->br_blockcount);
+	if (i_size > end)
+		i_size = end;
+	if (update_isize && i_size > i_size_read(VFS_I(ip)))
+		i_size_write(VFS_I(ip), i_size);
+	i_size = xfs_new_eof(ip, i_size);
+	if (i_size) {
+		ip->i_disk_size = i_size;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
+
+	return 0;
+}
+
 int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
@@ -617,21 +670,19 @@ xfs_iomap_write_unwritten(
 	bool		update_isize)
 {
 	xfs_mount_t	*mp = ip->i_mount;
+	xfs_off_t	end = offset + count;
 	xfs_fileoff_t	offset_fsb;
 	xfs_filblks_t	count_fsb;
 	xfs_filblks_t	numblks_fsb;
-	int		nimaps;
 	xfs_trans_t	*tp;
 	xfs_bmbt_irec_t imap;
-	struct inode	*inode = VFS_I(ip);
-	xfs_fsize_t	i_size;
 	uint		resblks;
 	int		error;
 
 	trace_xfs_unwritten_convert(ip, offset, count);
 
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
+	count_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)end);
 	count_fsb = (xfs_filblks_t)(count_fsb - offset_fsb);
 
 	/*
@@ -666,39 +717,12 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
-				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error)
-			goto error_on_bmapi_transaction;
-
-		/*
-		 * Modify the unwritten extent state of the buffer.
-		 */
-		nimaps = 1;
-		error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-					XFS_BMAPI_CONVERT, resblks, &imap,
-					&nimaps);
-		if (error)
-			goto error_on_bmapi_transaction;
-
-		/*
-		 * Update the inode size to reflect the extent that was
-		 * converted in this iteration. We must not advance isize
-		 * beyond the extent we just converted, otherwise a crash
-		 * before the next conversion exposes unwritten extents
-		 * (zeroes) to userspace instead of the written data.
-		 * Clamp to the byte-level write end in case the converted
-		 * extent extends past the write boundary.
-		 */
-		i_size = XFS_FSB_TO_B(mp, imap.br_startoff + imap.br_blockcount);
-		if (i_size > offset + count)
-			i_size = offset + count;
-		if (update_isize && i_size > i_size_read(inode))
-			i_size_write(inode, i_size);
-		i_size = xfs_new_eof(ip, i_size);
-		if (i_size) {
-			ip->i_disk_size = i_size;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		error = xfs_iomap_write_unwritten_one(tp, ip, offset_fsb,
+				count_fsb, end, update_isize, resblks, &imap);
+		if (error) {
+			xfs_trans_cancel(tp);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			return error;
 		}
 
 		error = xfs_trans_commit(tp);
@@ -724,11 +748,6 @@ xfs_iomap_write_unwritten(
 	} while (count_fsb > 0);
 
 	return 0;
-
-error_on_bmapi_transaction:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
 }
 
 static inline bool
-- 
2.55.0

