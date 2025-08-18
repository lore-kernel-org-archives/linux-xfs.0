Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A912D1F1
	for <linux-xfs@vger.kernel.org>; Mon, 18 Aug 2025 05:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755493644; cv=none; b=IywWYf+F4FJ+7HprIP68u5RYLTSY/UvyHWxZYyo+qgNxA3pAw+n/Zo2H/gzMzDeXJXyjWwztrgfNdjslSC0EIiI/sYX8weB92xBAYDNu5iw/sjPLI+EnEieMLjcxboe0H2WfX32yHsRXXnmrGrzzTSo29W07EYDZWzysiDIxOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755493644; c=relaxed/simple;
	bh=8UTDf7yWdkVnk3oI5ZWk+zHtlvgMgsA3RYXUhotlxAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utFmSPFqLh5Po+m4qy2LDwm0q4M04w54Crm/u5L4qnvjXAHs/MavyMXSJYXff0UjXtvRTnj5gsOmRBGPk+baK+21Fvft9094ucznGI7BdLKILvIS0+pwKHdgCBQ2Xbu4PL2yeSmYA5VF9eILcVFfyPNIZurRlgDvOIiiWMx3dPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CIwIqZwC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CIwIqZwC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LRXhAroBwr5n/rPg65SV4ltMeM2pRjxrcTEKn3HAKzw=; b=CIwIqZwCpQaJdJDRcvnPIW8bj1
	7LNG2ogR7yBGnUbUYl9YwTZasN9NNtHR0Yr+N5auJcmgIvEP1yphMbl++s8t8fZ7gmtJ0bBNHrX3P
	wgFS+Cs98gDG4EiTEYuZD+ZgT9se0vYJlvwHmiHI7ZNKjocCHc0o3SdHEoc4QWshX2Yn4eIYtKsHH
	vdrb6wH9/DG5SEtFzPTXprvFvpRCZYdinM7CwCEGlga0Xp7jVc7LpTUucwFQj3hnMpc9a5flVOlGB
	zrhwv7YF/8WQFegbHp9LQGDBr3sgmuGuxMi5+Uxay3wgPik7thBP5+PKMYhadC4gNeiQcpwiPEuGx
	qHqYY+CA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uns5Z-00000006WY3-0ZXv;
	Mon, 18 Aug 2025 05:07:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: remove xfs_last_used_zone
Date: Mon, 18 Aug 2025 07:06:43 +0200
Message-ID: <20250818050716.1485521-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250818050716.1485521-1-hch@lst.de>
References: <20250818050716.1485521-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This was my first attempt at caching the last used zone.  But it turns out
for O_DIRECT or RWF_DONTCACHE that operate concurrently or in very short
sequence, the bmap btree does not record a written extent yet, so it fails.
Because it then still finds the last written zone it can lead to a weird
ping-pong around a few zones with writers seeing different values.

Remove it entirely as the later added xfs_cached_zone actually does a
much better job enforcing the locality as the zone is associated with the
inode in the MRU cache as soon as the zone is selected.

Fixes: 4e4d52075577 ("xfs: add the zoned space allocator")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_alloc.c | 45 ++---------------------------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index f8bd6d741755..dfdb14120614 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -374,44 +374,6 @@ xfs_zone_free_blocks(
 	return 0;
 }
 
-/*
- * Check if the zone containing the data just before the offset we are
- * writing to is still open and has space.
- */
-static struct xfs_open_zone *
-xfs_last_used_zone(
-	struct iomap_ioend	*ioend)
-{
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSB(mp, ioend->io_offset);
-	struct xfs_rtgroup	*rtg = NULL;
-	struct xfs_open_zone	*oz = NULL;
-	struct xfs_iext_cursor	icur;
-	struct xfs_bmbt_irec	got;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (!xfs_iext_lookup_extent_before(ip, &ip->i_df, &offset_fsb,
-				&icur, &got)) {
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
-		return NULL;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	rtg = xfs_rtgroup_grab(mp, xfs_rtb_to_rgno(mp, got.br_startblock));
-	if (!rtg)
-		return NULL;
-
-	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
-	oz = READ_ONCE(rtg->rtg_open_zone);
-	if (oz && (oz->oz_is_gc || !atomic_inc_not_zero(&oz->oz_ref)))
-		oz = NULL;
-	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
-
-	xfs_rtgroup_rele(rtg);
-	return oz;
-}
-
 static struct xfs_group *
 xfs_find_free_zone(
 	struct xfs_mount	*mp,
@@ -918,12 +880,9 @@ xfs_zone_alloc_and_submit(
 		goto out_error;
 
 	/*
-	 * If we don't have a cached zone in this write context, see if the
-	 * last extent before the one we are writing to points to an active
-	 * zone.  If so, just continue writing to it.
+	 * If we don't have a locally cached zone in this write context, see if
+	 * the inode is still associated with a zone and use that if so.
 	 */
-	if (!*oz && ioend->io_offset)
-		*oz = xfs_last_used_zone(ioend);
 	if (!*oz)
 		*oz = xfs_cached_zone(mp, ip);
 
-- 
2.47.2

