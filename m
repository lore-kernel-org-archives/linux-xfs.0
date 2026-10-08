Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7103264E7;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791423572; cv=none; b=iM/atCthUTSXpjB5Le2Z3Zg8qy//10r9F9kfuEDvTjYPbHvBq+m5CX/vfEGLx9PniQKnTkM0E9hLO54iMrXSlWGJOXF1DPbzSN1j5TP3gkRREqy0wXWwoXnMS866A0dRcdprsuv+ZhLBesirYPHZtY/7ux8Bl/XyWkVpewK8kKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791423572; c=relaxed/simple;
	bh=rO+5AWhme2grssEY0abfBFG8fdWvajMKPgnYg9fT2WI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WrtVG+5Ch3g06il2+2tvsVWTXBiiWbqmbbE9fHALTrt0oSmdPdj4Ky13kwiqTrz6rXkod5U9GPMx8T9a6M7KDSI35Ya3UjzrH7/l0cYLxnPADg5rcHTofI+fWscxStWq1Xi4ww2efVKdHv/AMVQbLb17XaepUMbqpuRlYD2lOyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lV3ilmET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lV3ilmET"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84D94C4DDE3;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791423571;
	bh=rO+5AWhme2grssEY0abfBFG8fdWvajMKPgnYg9fT2WI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lV3ilmETtTQtSORE2bhO2UUc5ECMLLMgXl1O4U6SmLEj3AGcMwksRNoGr9iqAP16k
	 jyr1KNvzqzTp1fnJmcPZGAYdLE5fxGBZjsZfnXbT9njkh+xiHcF2/XcKurSzh9wieT
	 /HBicFQShZmQ/ozc6KbUFlLRgKSVO1YJZUbC2+AO/Pa09CsicwTq1sHxOwfe6zoqbG
	 d72sk8IC7pBa62wmuQ6HNuW7ZtXFpjbgZszaBKx2AKj35yXDRLMd+udjum212cW5yB
	 1p4MlYzuuvh+eVuuTkwRoKAi1717HoAvQTT1nP9zOJFInxFGBy2Ly8n9HMrmoAjNi6
	 z6/s8FNfBQ1ww==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70642CA600C;
	Thu,  8 Oct 2026 01:39:31 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 08 Oct 2026 10:39:36 +0900
Subject: [PATCH 7/8] xfs: map the whole range of a pNFS layout in one
 ->map_blocks call
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-xfs-nfsd-map-blocks-v1-7-560026cdccb6@samsung.com>
References: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
In-Reply-To: <20261008-xfs-nfsd-map-blocks-v1-0-560026cdccb6@samsung.com>
To: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
 Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <dgc@kernel.org>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Christian Brauner <brauner@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791423569; l=5125;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=W4uxTtzIiaCL9JDyYl3vGOSp5Kpa7RtXwMu5dPaSg/w=;
 b=MoQFoCy96KsbPydtI0MJDOuWvKQFHn8oAQrtDWUCR0dd/+l+b7MmBSY5+sKxLYffoDiTuXKuS
 /ActQe5ajHfCs1GDfgRqOMfPpjRiZ+bBOcwF6dkkfApvoSSXzbIdCBr
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_fs_map_blocks() maps one extent per call, and nfsd calls it again
for the rest of the range. Each call takes the iolock and the
invalidate lock, flushes and invalidates the page cache, and, if it
allocated blocks for a write layout, updates the inode and forces the
log.

Map extent after extent until the range is covered or the array of
mappings is full, all under one hold of the iolock and the invalidate
lock, with one flush and invalidation and at most one inode update and
log force. Each mapping starts where the one before it ends.
xfs_fs_map_extent() never maps anything before the offset it is given,
which matters here: allocating a hole merges it with the extents around
it, and a mapping of the next offset would otherwise reach back over the
hole.

If an allocation fails after others in the same call, the error is
returned without the inode update and the log force. nfsd then fails the
LAYOUTGET, so none of the blocks allocated is handed out; they stay
unwritten, and blocks past EOF can be freed again unless the inode
already has XFS_DIFLAG_PREALLOC or the file is empty.

With the nfsd change that follows, a LAYOUTGET for the first 256 KiB of
a file in which 32 blocks of 4 KiB written with O_DIRECT are each
followed by a 4 KiB hole gets 64 extents in one call. For an RW layout,
which allocates the 32 holes, the log is forced once instead of 32
times, and nfsd4_block_proc_layoutget() takes 2.2 ms instead of 166 ms,
most of which were the 32 synchronous log forces (median of 20
LAYOUTGETs each; QEMU VMs, XFS on an NVMe/TCP namespace, pynfs as the
client, time from a kprobe, KASAN and lockdep off).

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/xfs_pnfs.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index bd6f7d5093..60c552c511 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -138,13 +138,12 @@ xfs_fs_map_extent(
 	/*
 	 * Map to the end of the extent that covers the start of the range,
 	 * so that a client doing I/O in pieces gets a layout it can use for
-	 * the pieces that follow.  Never map anything before the start of
-	 * the range: nfsd calls in here once per extent of a LAYOUTGET, for
-	 * the range that is left after the previous extent, and the mapping
-	 * can change in between, so a mapping that reaches back can overlap
-	 * one already in the layout.  Don't extend the mapping past EOF
-	 * beyond the range either: xfs_free_eofblocks() can free blocks past
-	 * EOF without breaking the layout.
+	 * the pieces that follow. Never map anything before @offset_fsb:
+	 * allocating the hole before it can have merged that hole with the
+	 * extents around it, and a mapping that reaches back would overlap
+	 * the previous one. Don't extend the mapping past EOF beyond the
+	 * range either: xfs_free_eofblocks() can free blocks past EOF without
+	 * breaking the layout.
 	 */
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				imap, &nimaps, XFS_BMAPI_ENTIRE);
@@ -182,6 +181,10 @@ xfs_fs_map_extent(
 
 /*
  * Get a layout for the pNFS client.
+ *
+ * Map the range, or as much of it as fits into @iomaps, while holding the
+ * iolock and the invalidate lock, so that the mappings fit together: each
+ * one starts where the one before it ends.
  */
 static int
 xfs_fs_map_blocks(
@@ -195,14 +198,16 @@ xfs_fs_map_blocks(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	imap;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	unsigned int		nr = 0;
 	bool			allocated = false;
 	loff_t			limit;
 	int			error = 0;
-	u64			seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
+	if (WARN_ON_ONCE(!*nr_iomaps))
+		return -EINVAL;
 
 	/*
 	 * We can't export inodes residing on the realtime device.  The realtime
@@ -248,10 +253,21 @@ xfs_fs_map_blocks(
 	if (WARN_ON_ONCE(error))
 		goto out_unlock;
 
-	error = xfs_fs_map_extent(ip, XFS_B_TO_FSBT(mp, offset),
-			offset + length, write, &imap, &seq, &allocated);
-	if (error)
-		goto out_unlock;
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
+	while (nr < *nr_iomaps && offset_fsb < end_fsb) {
+		struct xfs_bmbt_irec	imap;
+		u64			seq;
+
+		error = xfs_fs_map_extent(ip, offset_fsb, offset + length,
+				write, &imap, &seq, &allocated);
+		if (error)
+			goto out_unlock;
+		error = xfs_bmbt_to_iomap(ip, &iomaps[nr++], &imap, 0, 0, seq);
+		if (error)
+			goto out_unlock;
+		offset_fsb = imap.br_startoff + imap.br_blockcount;
+	}
 
 	if (allocated) {
 		/*
@@ -267,10 +283,9 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomaps, &imap, 0, 0, seq);
-	*nr_iomaps = 1;
+	*nr_iomaps = nr;
 	*device_generation = mp->m_generation;
-	return error;
+	return 0;
 out_unlock:
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	return error;

-- 
2.43.0


