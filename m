Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B992641CA
	for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2026 00:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787098502; cv=none; b=fCVp2vrt9A9LPXcRiTCQRQkz/wG9YXrqYuE6AVOWfUU0zdlDhfAcNJo+JRifCzg10Nh4p7bg/j9Xorpwu+O9j+Tm9A3skoEaDXMbyfeyz7lteVQSMQCo9LxxtpTfJdYI9z6jtchm5AwJn/3khVX/OEzKp7GbzHECzDxwf+tzYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787098502; c=relaxed/simple;
	bh=Ef0RRWwTmX7+U3bjfo36VswS9M80uAfqS5rN1l/FZcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qn/LG9A1ADa1xc0CeGHKHpdHb9zWIzASr7WkfNKF8MxJbaLFafkoYTjh55q+44XPq97MrhQf/HaUGg9boji6/A4XnSN3K/pK0Rd5N7gig3mm9/B5Xu98a0acykRGhazhkvIF7gfOybizGdJKlq0JaqLjfUD7TqiGu9qYasOSnqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+5TYwXn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+5TYwXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAEE1F00A3D;
	Wed, 19 Aug 2026 00:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787098498;
	bh=y5f+odjzptHGBe0AITRVjUiWjEtlBfoIYJ47D8bn8kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+5TYwXnkPO8rv7grBV6GUZ2WRHLzPV+aiRK/DesZqQN6g/V04uEXI3Yz5N29sjaV
	 CCaaa3LK47MROzQK1WDIKIQw3R9fM5sFw9ySvSaPWyqaEUJeRBp7CATFP/UGjM6u8J
	 8KfbxzdIhEh8kp3mTpIK2u5Edg0wtWYKaPe3WKo4j+Qv6x1hxRN0ddFAc0ARfschjd
	 qi1uSOHEg1yx0qEOYZitGWh/+tG5cpTcnQ8nAN9JeB6RUUuCdQVqar0DXBo1bED7/m
	 GopSw2Sh8x1L138nULke3+cEl/VgKVTcURrQmMBOYNdsDkTmOQulBL+UxqIfniUofu
	 Tfqo+HGUmwrkg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 09/38] xfs: factor out COW iomap handling from xfs_direct_write_iomap_begin()
Date: Wed, 19 Aug 2026 10:12:12 +1000
Message-ID: <20260819001442.1451892-10-dgc@kernel.org>
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

Extract the COW extent allocation and iomap setup logic from
xfs_direct_write_iomap_begin() into a new helper function
xfs_direct_write_cow_iomap_begin().

When the inode is a COW inode, the new function handles the entire
COW path: acquiring the ILOCK exclusively, reading the data fork
extent mapping, checking if COW is needed, allocating COW extents
via xfs_reflink_allocate_cow(), and setting up the iomap/srcmap for
the COW write.

The *nimaps output parameter tells the caller what to do next:
  - *nimaps == 0: COW was fully handled, iomap/srcmap are filled in,
    and the ILOCK has been released. The caller returns immediately.
  - *nimaps > 0: The extent is not shared. The imap is valid and the
    ILOCK is still held, so the caller continues with the normal
    allocation or overwrite IO path.

When the inode is not a COW inode, xfs_direct_write_iomap_begin()
handles the locking and extent lookup itself as before, taking
only a shared ILOCK.

This is a pure refactoring with no functional change, done to prepare
for reworking the COW allocation to handle transaction allocation and
retry logic at the xfs_direct_write_cow_iomap_begin() level.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_iomap.c | 184 ++++++++++++++++++++++++++++++---------------
 1 file changed, 123 insertions(+), 61 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1437ea93563c..df9fc7c6a4b9 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -848,6 +848,111 @@ xfs_bmap_hw_atomic_write_possible(
 	return len <= xfs_inode_buftarg(ip)->bt_awu_max;
 }
 
+/*
+ * Handle COW extent allocation and iomap setup for direct writes to reflinked
+ * files.
+ *
+ * The caller passes in an imap and nimaps that the COW allocation will fill
+ * with the data fork extent mapping. On return, *nimaps indicates whether the
+ * caller needs to continue with the normal IO path:
+ *
+ *   *nimaps == 0: COW was handled, iomap/srcmap are filled in, ILOCK released.
+ *                 Caller should return 0 immediately.
+ *   *nimaps > 0:  Extent is not shared, imap is valid, ILOCK is still held.
+ *                 Caller should continue with the normal IO path.
+ */
+static int
+xfs_direct_write_cow_iomap_begin(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			length,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap,
+	struct xfs_bmbt_irec	*imap,
+	int			*nimaps,
+	unsigned int		*lockmode,
+	u16			iomap_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	cmap;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
+	bool			shared = false;
+	int			error;
+	u64			seq;
+
+	*lockmode = XFS_ILOCK_EXCL;
+
+relock:
+	error = xfs_ilock_for_iomap(ip, flags, lockmode);
+	if (error)
+		return error;
+
+	/*
+	 * The reflink iflag could have changed since the earlier unlocked
+	 * check, check if it again and relock if needed.
+	 */
+	if (xfs_is_cow_inode(ip) && *lockmode == XFS_ILOCK_SHARED) {
+		xfs_iunlock(ip, *lockmode);
+		*lockmode = XFS_ILOCK_EXCL;
+		goto relock;
+	}
+
+	*nimaps = 1;
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, imap,
+			       nimaps, 0);
+	if (error)
+		goto out_unlock;
+
+	if (!imap_needs_cow(ip, flags, imap, *nimaps))
+		return 0;
+
+	error = -EAGAIN;
+	if (flags & IOMAP_NOWAIT)
+		goto out_unlock;
+
+	/* may drop and re-acquire the ilock */
+	error = xfs_reflink_allocate_cow(ip, imap, &cmap, &shared,
+			lockmode,
+			(flags & IOMAP_DIRECT) || IS_DAX(VFS_I(ip)));
+	if (error)
+		goto out_unlock;
+
+	if (!shared)
+		return 0;
+
+	if ((flags & IOMAP_ATOMIC) &&
+	    !xfs_bmap_hw_atomic_write_possible(ip, &cmap,
+			offset_fsb, end_fsb)) {
+		error = -ENOPROTOOPT;
+		goto out_unlock;
+	}
+
+	/*
+	 * COW extent found and allocated. Set up iomap/srcmap and return
+	 * with *nimaps = 0 to tell the caller the COW path is complete.
+	 */
+	*nimaps = 0;
+	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
+	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK,
+			&cmap);
+	if (imap->br_startblock != HOLESTARTBLOCK) {
+		seq = xfs_iomap_inode_sequence(ip, 0);
+		error = xfs_bmbt_to_iomap(ip, srcmap, imap, flags, 0, seq);
+		if (error)
+			goto out_unlock;
+	}
+	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
+	xfs_iunlock(ip, *lockmode);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
+
+out_unlock:
+	if (*lockmode)
+		xfs_iunlock(ip, *lockmode);
+	return error;
+}
+
 static int
 xfs_direct_write_iomap_begin(
 	struct inode		*inode,
@@ -859,12 +964,11 @@ xfs_direct_write_iomap_begin(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	imap, cmap;
+	struct xfs_bmbt_irec	imap;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 	xfs_fileoff_t		orig_end_fsb = end_fsb;
 	int			nimaps = 1, error = 0;
-	bool			shared = false;
 	u16			iomap_flags = 0;
 	bool			needs_alloc;
 	unsigned int		lockmode;
@@ -887,57 +991,28 @@ xfs_direct_write_iomap_begin(
 	if (flags & IOMAP_ATOMIC)
 		iomap_flags |= IOMAP_F_ATOMIC_BIO;
 
-	/*
-	 * COW writes may allocate delalloc space or convert unwritten COW
-	 * extents, so we need to make sure to take the lock exclusively here.
-	 */
-	if (xfs_is_cow_inode(ip))
-		lockmode = XFS_ILOCK_EXCL;
-	else
-		lockmode = XFS_ILOCK_SHARED;
-
-relock:
-	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
-	if (error)
-		return error;
-
-	/*
-	 * The reflink iflag could have changed since the earlier unlocked
-	 * check, check if it again and relock if needed.
-	 */
-	if (xfs_is_cow_inode(ip) && lockmode == XFS_ILOCK_SHARED) {
-		xfs_iunlock(ip, lockmode);
-		lockmode = XFS_ILOCK_EXCL;
-		goto relock;
-	}
+	if (xfs_is_cow_inode(ip)) {
+		error = xfs_direct_write_cow_iomap_begin(ip, offset, length,
+				flags, iomap, srcmap, &imap, &nimaps,
+				&lockmode, iomap_flags);
+		if (error)
+			return error;
+		if (!nimaps)
+			return 0;
 
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
-			       &nimaps, 0);
-	if (error)
-		goto out_unlock;
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
+	} else {
+		lockmode = XFS_ILOCK_SHARED;
 
-	if (imap_needs_cow(ip, flags, &imap, nimaps)) {
-		error = -EAGAIN;
-		if (flags & IOMAP_NOWAIT)
-			goto out_unlock;
+		error = xfs_ilock_for_iomap(ip, flags, &lockmode);
+		if (error)
+			return error;
 
-		/* may drop and re-acquire the ilock */
-		error = xfs_reflink_allocate_cow(ip, &imap, &cmap, &shared,
-				&lockmode,
-				(flags & IOMAP_DIRECT) || IS_DAX(inode));
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, 0);
 		if (error)
 			goto out_unlock;
-		if (shared) {
-			if ((flags & IOMAP_ATOMIC) &&
-			    !xfs_bmap_hw_atomic_write_possible(ip, &cmap,
-					offset_fsb, end_fsb)) {
-				error = -ENOPROTOOPT;
-				goto out_unlock;
-			}
-			goto out_found_cow;
-		}
-		end_fsb = imap.br_startoff + imap.br_blockcount;
-		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	}
 
 	needs_alloc = imap_needs_alloc(inode, flags, &imap, nimaps);
@@ -1022,19 +1097,6 @@ xfs_direct_write_iomap_begin(
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
 				 iomap_flags | IOMAP_F_NEW, seq);
 
-out_found_cow:
-	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
-	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
-	if (imap.br_startblock != HOLESTARTBLOCK) {
-		seq = xfs_iomap_inode_sequence(ip, 0);
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0, seq);
-		if (error)
-			goto out_unlock;
-	}
-	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-	xfs_iunlock(ip, lockmode);
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED, seq);
-
 out_unlock:
 	if (lockmode)
 		xfs_iunlock(ip, lockmode);
-- 
2.55.0

