Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445357;
	b=kKvxJhBZKIlL7AOg7L+ritprxdvkN2ONCyuEwHR3LU0EIqwODJ/bGcnYW/1Yin5Jiz+b
	 v8UF5mpyNKWy36oxhEVI1j69cq8X7zReXuHZyMBsAE5PGCkDkfa7NbALBfNp75r7RedvM
	 EzNhI/yS2m60uPYD1Ti5Vmpf3fPJ/HcKqaboAz319JfX3oGIFvYTKkO6iteHKvUC/49YG
	 IOyJ5RKnzM/VXxtVjTUUBudJiEdOHfid5cIfAJU8Jq1mk7l2b0NnnXjUpmzZZHcm1ir2J
	 de8NM9Ek8eyOZWVuuVrQhpDl9AlVaAd2xrQyRaVzuDtA58XoWAL3S7wO6LZqL+KyPYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445357;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WqO0pJMJF+rEU4fJC/7faLegk+yw1GUf8GH4Qsj2pJI=;
	b=zk0HXyCiouhsLGo3d2JK8a6+hfMEVWY4mBoe3VVdXRoyyoOg56sEpFpBFrxKHwdR+vDd
	 BE3LAZC7YuITAkAnJVCtFb9G1g/TVefb/VNScWUD3bXFriL/pmw+6Xw+in/UmSd/apcgE
	 MIbKoopJ/vK6ZSfIWc46AYBwydgVQYCqdiwBOghdGQiJrxmuee9TDBaabkDlBXqekoxQs
	 YchSLhasWX4mZUsogXwbYU647JAzvJPHxSxAy0vUyzOzOa94TKhIHlWgFyidifOWC62qA
	 zNSFQ/sIsl7FJAQSaSRGBCQY4JP/9TJ1KrCUtmap+NLAFVd/ip7XJvjaedyuoFuM31A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NfI2XS7c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804D5606A8A9;
	Thu, 12 Nov 2026 01:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NfI2XS7c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB101F00A06;
	Thu, 12 Nov 2026 01:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445357;
	bh=WqO0pJMJF+rEU4fJC/7faLegk+yw1GUf8GH4Qsj2pJI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=NfI2XS7cSVtF8RxK7x0ecTNzmpxulm37OkfoZza9TWkhE6cijwwEQQa2OyS6RIwn6
	 hgEeEdV8MoxW+V/ydfPEKFvLtt06tXtoXE7866l+iO1luAhCSlh5t/lJOui3JvJceb
	 WKp930YqErlUdMCUbcXFnMs5d3N0jvhUfQXOULJsmpiCZXnIPcApOMkQ/D6zP+JTwa
	 P2cEWR6nUMKE+h/NAW0Jb2ZUql6cBjnPhEVtQAjohzg4VUdun586n6SyJgNOLj3Rws
	 W5Ws2ihm7/+tbr1NyhMNL6ncpKt7p3o79pmxrbm51E+qkO67Jcp82qbXP/cUeYPPnZ
	 ywU+PimxThg3g==
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
Subject: [PATCH v8 03/15] xfs: don't change the block map under a dirty folio
Date: Wed, 11 Nov 2026 20:02:32 -0500
Message-ID: <20261112010229.51029-4-mason@kernel.org>
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

Notes:
    v7->v8:
    - No change.
    
    v6->v7:
    - No change.

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

