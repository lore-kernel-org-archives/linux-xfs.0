Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89AB2D3725
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098520; cv=none; b=FIMQNXpmOh3BMSZYRA853K/AwQrn0bfyxeqKVaCr+fGKfDLcMpmduphDPRptL9FLHqpSX8+hnT3Q5m3qDILM/lJhRsc5o9ukISFZ3vYoLrhTS6BRjcd/wJFijsBHtuDCJEyeNewvrJtwnJJ5nwis9B8jewYuBx8c9W1F27FUSNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098520; c=relaxed/simple;
	bh=/lt3g3U51W2D7OdI0tMRog/oCUwxdYn6K9MVvP/MWYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbmV/3Nn0Ki/951EOW3IEa9UJljv+V9WYJI+VR/k48x72NUvfSQlbgevQPsSlUdHuQMBR6fd+hS5u1CsJ1lLeaHYTkNRuoPRa/IrcL7CAA649lGlObHQCjesiXPG2Dog5vcACf/jzzvXmi5Rm5kZcqMZMeBaCH76528OEsH+Irk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jaSWfNNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jaSWfNNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8B61F000E9;
	Wed, 19 Aug 2026 00:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098518;
	bh=msUJA9YyQshYDymulk4BAzVtNnWr/m0OvRTtp3RwxLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jaSWfNNXA87cYCRjN6Wmndj/PmpVP2IiWjpOMm7gtBzT/HUK6htOiRAXQd/sh8993
	 amjWFyR3XOBUvu+06BeZtAvLhseEZTkzW8m4AHYx6Z/BkjbqLdG4KRl3A/NUU4zk79
	 JUtJLsKex1qZhyH0rsD2Yf8EPkMEsbXXSl7XTeUvKjcatucO55zIEPvk4nw1HpvhbQ
	 zHbNiOI7g7eK32/DjaW3BI4USgM/eoN+tX1/o+3nvtbYIJRQHijVjnucwizRgfFIei
	 0gvVWXC2/jflQJrDR0Y1vW+nOlzxhhPIwmK7A5hnsT34Q6p/A3Q2lZMY6pcRbdYQm/
	 5jyV4L4CZZ5fw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 24/38] xfs: factor out xfs_iomap_write_unwritten_one helper
Date: Wed, 19 Aug 2026 10:12:27 +1000
Message-ID: <20260819001442.1451892-25-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819001442.1451892-1-dgc@kernel.org>
References: <20260819001442.1451892-1-dgc@kernel.org>
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

