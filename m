Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E9525A345
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185397; cv=none; b=TOjvrAt8Z54dGsDJVCT6J1/JXd22ZCHP69JigL3I41qntPH3HJ3dpgJFxMnvZ6lS08ZUMJ7DBe8k6q1vDeZkBx9rZz/iWm+hExYsSRZrVwNxiXNSEXpIfBVvuH0GM+FCMqh320fszGf2rtJwH2vzpMFcH/aGKG8IlxtKxOMuRbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185397; c=relaxed/simple;
	bh=E7MdulDnhnb8qQFbZKAS1xUO6NZ3hV92s+OtoSHR2rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idv0xCKoNymVSEqEuw2DiVVIJw08oEyZ4+JWBA6uvi/daWQIQgQhb+KLooD0N5AWHYQxLGilGQZY4IFlUajCogQ1+K5D/qVA0bpZcutHuFwEDCZs+/u0jrfyL7M5tpT7fOedW07J/mkSCCr1LfboJHhiEhZACssBZlDeEaEXT74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rhONtCkU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rhONtCkU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MivaGvbpCZ2di3mJkXqGqejX/yspcP2CysmcdHHBt9M=; b=rhONtCkUIQjlYQiijQKvWK2zJp
	9x0gt6pMzaTov2NuZ9SZWqcSqXQyF/jG/BtKZCyxoehZVYft7RWKnNCe/HRIy3BMnBzFsqkGXwUcP
	HXFQYrKRaajlhE+o5z7PFpA527SKJiI3TE0IAZGW/Ju+dQJOBKJxpgNqTDRm94J37yXKiba9SBwnd
	4yLxp04Ha/obJPKstXTdhOirsgVeP/SrYvYpbZv6tBGtrnh0e8YEgf17IzsvVaCBbFYrpcsluf9k6
	RpKZBYD68k81IcqhqBfDe0OMaJJAcJy24mVJCtiueLDjvHGiX2F2cvrX+GeniVYHaIu1Yt8Jxhjye
	04dLIreg==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QIV-00000006UHI-0HpM;
	Wed, 09 Apr 2025 07:56:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/45] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
Date: Wed,  9 Apr 2025 09:55:11 +0200
Message-ID: <20250409075557.3535745-9-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: f42c652434de5e26e02798bf6a0c2a4a8627196b

The zone allocator wants to be able to remove a delalloc mapping in the
COW fork while keeping the block reservation.  To support that pass the
flags argument down to xfs_bmap_del_extent_delay and support the
XFS_BMAPI_REMAP flag to keep the reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c | 10 +++++++---
 libxfs/xfs_bmap.h |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 4dc66e77744f..c40cdf004ac9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4662,7 +4662,8 @@ xfs_bmap_del_extent_delay(
 	int			whichfork,
 	struct xfs_iext_cursor	*icur,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*del)
+	struct xfs_bmbt_irec	*del,
+	uint32_t		bflags)	/* bmapi flags */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -4782,7 +4783,9 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (isrt)
+	if (bflags & XFS_BMAPI_REMAP)
+		;
+	else if (isrt)
 		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
@@ -5384,7 +5387,8 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got,
+					&del, flags);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4d48087fd3a8..b4d9c6e0f3f9 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -204,7 +204,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extnum_t nexts, int *done);
 void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
-		struct xfs_bmbt_irec *del);
+		struct xfs_bmbt_irec *del, uint32_t bflags);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
-- 
2.47.2

