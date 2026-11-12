Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445374;
	b=uMtB/JjIXvRROapySShiquEHQBmoq6wJ0whOPG0/iAd8OFGyaKzlySc+zJqCnO4oehPP
	 RlCa2t3dawxvtyUB8qCdMf74wCSbXqgyxhhQbxbseCV5MEyCzktu0+LZ+hTWRGEFwGTYv
	 d7FmvjyPjhaYXryuybd5EgZxGnpOc6WTPYvdLIfnbWLe9D5RBOhlIMrJ91L6jPCd4SWMR
	 mcR879y12AZx55RbHSYyytq33CTgkf5SlVJSaIxIgzC0qiLh23ibZZ3efOr5cPunQbIXI
	 mrPofmF8Sh1P8ic5uIZMk0Wg6tudT8Wk5aK49weUdRGQTGL2L5gTS+FdYj0IBIaOMog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445374;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3qbqmc6cdWPSncv1+TSlwXoNXgVr5nmRF5eCdfntADM=;
	b=3jsU8dLXMvUUk6EP0Fb+UJZ1Ltti0eZkFFOHoeStFxEWYxeptWdATCbZIROzyQzIgIil
	 IdyOpv3ePUWo6k2WNYunFHLXkKFgA6EBN8tGRejjzP/Wpii8IqRHNt/7oFvj3yy2TCvWw
	 VOz4BshsyYzyVnOj731Auu8JgIRNUo2b/er5oG7bUXUoB6SepM6D/RTPudquS5C29UmG5
	 SgaPuRv9bZTuIw2B67FdWKe+oBchfACWmFDQWu8ZE1Sv6HExifI2qfKvqSaMn2Gs9f0dK
	 IcZBAkfzdbCw5eO3rHopF3i0B+aoWX2E+tJBrW3CpOp+22oMmm2C5y5qex5JedMcGyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fm5YPT71;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658C5606A887;
	Thu, 12 Nov 2026 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fm5YPT71
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0F61F00A09;
	Thu, 12 Nov 2026 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445374;
	bh=3qbqmc6cdWPSncv1+TSlwXoNXgVr5nmRF5eCdfntADM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fm5YPT71WnLqt/itHD7ZE3K8qObFzCsSsK0dPbE2LYQO2qSKNjjByEG1PcVm4gCED
	 SJOR+YZtyR0h4VC5TRmjuYg1VfgRcz/F3za3rrVkH4tQ96MS0JtOs73D75tsu6zWES
	 my0GHT2J8Xiz2Lb/xasLbuRb8/I4enPUNQMsQmXlpmGvzt/7gz9XwPfLcFAEz0w7G3
	 xV38t/H7URyf42LUzJ0X1dS0PHr0TVpuGrVWwmVlOa4f0lIMsHp0OSdkHWzwxwBCXu
	 plkvRd0ZF+7/DqoTuX6IWeteFfF5JhKfzMCCkRR/AoCZY2s6JxsVN2U4eSi33+W3Ig
	 xIayp8HdnyXsQ==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v8 13/15] xfs: resample the extsize hint after taking the ILOCK
Date: Wed, 11 Nov 2026 20:02:42 -0500
Message-ID: <20261112010229.51029-14-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A write fault on a file with an extent size hint can overrun its block
reservation and shut down the filesystem, if it races with a change of
the hint or of the realtime flag.

xfs_iomap_write_direct() sizes the reservation from the hint and the
flag before xfs_trans_alloc_inode() takes the ILOCK, and the allocator
reads both again under it. But a write fault only holds the MMAPLOCK,
and FS_IOC_FSSETXATTR changes both on a file with no blocks without it:

    write fault                         FS_IOC_FSSETXATTR
    ===========                         =================
    xfs_iomap_write_direct()
      hint is 1 block
      dblocks = 1 + bmbt blocks
                                        xfs_ilock(ILOCK_EXCL)
                                        hint = 4096 blocks
                                        xfs_iunlock(ILOCK_EXCL)
      xfs_trans_alloc_inode()
      xfs_bmapi_write()
        allocates 4096 blocks
        xfs_trans_mod_sb()
          t_blk_res_used > t_blk_res

The fix used here is to compare both with the values that sized the
reservation once the ILOCK is held, and to start over if either has
changed.

Signed-off-by: Chris Mason <mason@kernel.org>
---

Notes:
    v7->v8:
    - New patch.

 fs/xfs/xfs_iomap.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b414e2cff346..7fb61f56a414 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -295,9 +295,11 @@ xfs_iomap_write_direct(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	xfs_filblks_t		resaligned;
+	xfs_extlen_t		extsz;
 	int			nimaps;
 	unsigned int		dblocks, rblocks;
 	bool			force = false;
+	bool			rt;
 	int			error;
 	int			bmapi_flags = XFS_BMAPI_PREALLOC;
 	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
@@ -312,9 +314,11 @@ xfs_iomap_write_direct(
 	 */
 	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
 
-	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
-					   xfs_get_extsz_hint(ip));
-	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
+retry:
+	extsz = xfs_get_extsz_hint(ip);
+	rt = XFS_IS_REALTIME_INODE(ip);
+	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb, extsz);
+	if (unlikely(rt)) {
 		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
 		rblocks = resaligned;
 	} else {
@@ -358,6 +362,17 @@ xfs_iomap_write_direct(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * A write fault doesn't hold the IOLOCK, so what sized the reservation
+	 * can change until we hold the ILOCK.
+	 */
+	if (extsz != xfs_get_extsz_hint(ip) ||
+	    rt != XFS_IS_REALTIME_INODE(ip)) {
+		xfs_trans_cancel(tp);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		goto retry;
+	}
+
 	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
-- 
2.55.0

