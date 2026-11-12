Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519973;
	b=ZpVs+4jnpnDj4vUd99Khk7SH8LFkMg5XBeHR3Fm1VGt+DM32ERudcSDBBHa/kQHiOvUr
	 z2dTVnWMHnKMj4GbWGiZuY/WBA7NHxkvpyo0DNzi7F6wCOnZq8RasQ/72rzEGCny3h6wq
	 Lrh4jOBZk5cWQyTbJuQWN6lhRw+SMdvAWW55EEoRe/6nVjUjHkDsd0/9dD4W1OYLQDgx0
	 ce4DTOoTTvWSxWfR79EIBjvgHN2uPNq5j3pZw5WSqkmUm8jjwb2Z1X5IRK+bLdZmJ/4aB
	 V5TePIreVuWhPEgyEABNczFTUDkVPpbALyqHThg5DXiOhhQD46syTM9fGOvShqoqn3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519973;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=piWR28b9ERr6mSBbLCTUNJFRme4zBeeYNbdteUV+tJs=;
	b=Bxr46dlijjDmJvbbxQrFzoxLeDuoGFarv9GFs0244WIE68WxopzMzmZn/DMMjqqF3Uw1
	 pzF6MGfpGN+GzPENU+ooyqlEHCRKiZT09K07dd5fg2FbUbSuoenB6QSwTRVtDgmqTMXN4
	 pRFOdP5X3jVHvRvZ92EvISl9OTDovedBI5LTcMaU9fEzqC9fsttDeg6txjlFx+OBVQFAv
	 tvg6G6r1Z4/l1QMCllcBLWIsfZsUYTBn4/9AuPARym3xhmyrjDlw5IyRZzUtCK83IcveQ
	 wWD43U2a8VkVj4mZkUV9axRj2vhIv3N8hR/JXfJUc6AZ4UTJy1Gdnmhx1ZJPD+d6yMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Re1ThrCN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E1606A32D;
	Thu, 12 Nov 2026 21:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Re1ThrCN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615541F000CA;
	Thu, 12 Nov 2026 21:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519972;
	bh=piWR28b9ERr6mSBbLCTUNJFRme4zBeeYNbdteUV+tJs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Re1ThrCNBkHqgIWnZ+cxDQEfc0aO7YVATe2c6xZ/QiNoFH1G5pjRvCyNjipZFobPc
	 zXgBod+drgDZDztCdO1fVQKaONcWhLrsNzVipQfB2UKhYLRf7I8XpnhoNcG5XJAo5Y
	 YvhEoQ/3BxcltE77rDQyhraaR0Cqn+OnSbXRufIG/nqfQQJrf6w6V38PUkb8swJ4D/
	 Ir+NuWXFEcEdO3vC4EJyszykqeclQl73G2eV0HFPiRXlTwESUJYBNeteS+7TJ3gDQY
	 ajLJ9sAa8I4v2tZ2VFf6wr16XQVQbQJWJsCmiI6Mh+qKZuBr8MxnYvEzl6FNa7zm+I
	 1hvhRp1pxFr3A==
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
Subject: [PATCH v9 03/14] xfs: don't change the block map under a dirty folio
Date: Thu, 12 Nov 2026 16:46:07 -0500
Message-ID: <20261112214604.67875-4-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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
    v6->v9: no change

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

