Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268278;
	b=MF8fem8FH+lEzTHg64tUIClHKJosiLrSWeMyClBaJa0oU2Kur/ffwakCfnZy39yqCGgY
	 VRKhQfSuPUScVSghEWCOtjVrY4xph+1ghZHMV28B5RPmN7UiRLWGd/3w9fTat7oA2LW4Q
	 UH17eYv22be7bu6gEk9MwLdXsEIyMoSkkgASZdwBjoAA4g+62eoOaYYX3Y90ApQeLDGEJ
	 fRLN7r69Jm6znYS5bwMwyRSC4AtBM/lX905bMuoIRNckYu0ZY/9teGHtvQ6XXbjmYJg6t
	 9rrpUQuGqSquv1cNfDhp/w7UH5NK1HiCkQ5mubS7II3/wr1kCPA0LViu+NVk1RMQ7Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268278;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qE9g22oMWABo12D6N4ycFfCEmpV+1AMLGjwQ65U/0Tg=;
	b=I+j7gyyMAX1nepUOk/05bsJF71H+K/r0mJJRLUC90aRI41m+tv+ozRo4AaSR3ejTMabz
	 CaARzkcvnq+Altb3kA7/4C7/PJmdsthCEkKO+z1yypmAmRicNB1RZxAJ0VEIuTRSdOqD6
	 x15vYl67rpNHUaEBOuWxBXNU87/VI/DFSGU5WijD2EJtmmP84z9PiuY5FYWqwcCJ7Ofdl
	 bN42NllbgDhnq9ThDc9170qOixUqZGvnofs5QT3E7AY38joJpm2CtGd0EIDcbUgCFhA3X
	 LzskpSJUy6JCWpB5W3vMeIt5RCpS3cMLJz7X+MTGjO2K1rlwtOLkkiZHev/KoRFhMFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Kb/bw+Pq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75413606A326;
	Mon,  9 Nov 2026 23:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kb/bw+Pq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEEA1F008A5;
	Mon,  9 Nov 2026 23:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268278;
	bh=qE9g22oMWABo12D6N4ycFfCEmpV+1AMLGjwQ65U/0Tg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Kb/bw+Pqly587rlckVxFyC/4KmaBikTWOdNKY98MNUAPw40w0IDSJACN/Cv4AP6ja
	 tnq4H7YidzhES+mIYQwom12VudUJWqfEaTFFFWpRBwXQPD3deVjI+Nuh0R0fogdcjL
	 35fXu9SMzxj8gGhrJmxqtz6Oz1inwb6pzrE+GIQe73W7fxspGUTEJtWJ6AOqwIuIim
	 9Nr9kzbzGzQSdd+4Pu44CVbA2yPaDjairRpq9jeNWBlFtFkx5xrOG18tRkpR9mem7H
	 NuP9EuXtD3bdOoenic1P+wv7DQ35TieVcntg6BkYuNt8bgWQXS+IVjVbmwkDwrm3NK
	 AiTKW+nFgEyGA==
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
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 03/10] xfs: don't change the block map under a dirty folio
Date: Mon, 09 Nov 2026 18:51:14 -0500
Message-ID: <20261109235111.14129-4-mason@kernel.org>
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>
References: <20261109235111.14129-1-mason@kernel.org>
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

With CONFIG_TRANSPARENT_HUGEPAGE=y, writeback on XFS can write in place
to a shared block and corrupt the other file that shares it.

xfs_map_blocks() writes in place unless the COW fork has an extent for
the block. write() and write faults reserve one before they dirty a
folio over a shared block, so xfs_flush_unmap_range() writes back and
truncates the range before a clone changes the block map. But the holder
of a GUP write pin takes no filesystem lock, and the truncate keeps a
large dirty folio that straddles the range:

    clone                         pin holder         writeback
    =====                         ==========         =========
    writes the range back
                                  dirties the folio
    truncate keeps the folio
    maps a shared block under it
                                  dirties it again
                                                     finds no COW extent
                                                     writes in place
                                                     /* shared block */

The fix used here is to invalidate the range instead of truncating it,
and to fail the call with -EINVAL if a dirty folio is left, before the
block map changes.

Fixes: 6795801366da ("xfs: Support large folios")
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 17 +++++++++++++++--
 fs/xfs/xfs_reflink.c   |  2 +-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 537c6b29417c..4673d5174645 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -863,8 +863,21 @@ xfs_flush_unmap_range(
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
 		return error;
-	truncate_pagecache_range(inode, start, end);
-	return 0;
+
+	/*
+	 * The callers go on to change the block map, so no folio may stay over
+	 * the range.  The holder of a GUP pin can mark a folio dirty again
+	 * after the flush, with no lock of ours.  A truncate drops such a folio
+	 * if it lies inside the range.  If it is a large folio that straddles
+	 * the range, the truncate cannot split it, so it zeroes a part of the
+	 * folio, keeps it, and reports nothing.  The invalidation removes whole
+	 * folios, changes no data, and fails on a dirty folio.
+	 */
+	error = invalidate_inode_pages2_range(inode->i_mapping,
+			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
+	if (error == -EBUSY)
+		error = -EINVAL;
+	return error;
 }
 
 int
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 104542b10d9e..ff89516154bd 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1663,7 +1663,7 @@ xfs_reflink_zero_posteof(
 /*
  * Prepare two files for range cloning.  Upon a successful return both inodes
  * will have the iolock and mmaplock held, the page cache of the out file will
- * be truncated, and any leases on the out file will have been broken.  This
+ * be invalidated, and any leases on the out file will have been broken.  This
  * function borrows heavily from xfs_file_aio_write_checks.
  *
  * The VFS allows partial EOF blocks to "match" for dedupe even though it hasn't
-- 
2.55.0

