Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773621EC4D9
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907434; cv=none; b=nzFm882ZEdm9Qc1k/7LvK8mUJqDFNLwb3C7SvVWDaKPBFRKzIKjyZNWWlY0WF34f6fZwNzDmInttMUXYbnkWT1nrNZNbZ4xbFZ+nI6mg4RU1tyHKUneYXf/1whzL82pQ8pao0LSqJUDuLk1Tad1PW41TlQNASRVN8gqCwR+IsgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907434; c=relaxed/simple;
	bh=BmWEIlbP8fhU0ThCe/5Gfm7VRmHZSjH/m/oBkiH+T7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJG8AeOo1BQL8/Oirty35ypLSlXcQc4lvQyhAEqV/4sH0L8Wc+imaSJm6suYrfr0Y38IDtUFzgAxmRHznvvIhbeACd5RyBtnhfUFq608eeFVvWGkGsHUmwYeryzFZjwAqQuZnnf7gjo5AQR3jht91CL6Mr5PiQqhvaf48w9k9AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UGUQwBO5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UGUQwBO5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4f8lZvIpfj2ZR3NJ37VS6FWEWdQ5upyDLR0f7/HC2W4=; b=UGUQwBO5zTlWQ+7Ov1DpITapff
	21cVLW1ZNp1wTrvRqXB/Mz5c7fv1cQcMaHIK9fAvChPDW/BR1077MnMTqhufH1IXdXIX0yd6ukPIA
	P/CNQhrbZ851OZsnGrrgnil7WOHMu4s7gq/6P6ZThNSGuIyw+r/l0dsr96y9uwvYrRYDrWHg6BgyM
	QgwV+BOwX4rOGTj5FCcGIORmUIqyGDkClI6OtY8Xz+wRIj16bWYtnDlm5toYuB56ClnSaHGs9rsgl
	E1mBqCuRqcQSe5qMX03AiT56QJNsLXzua8w2zjZsbscPitb5UzMIqh+dl6R7VQbYdSPZGqMO0xZeY
	cfNgwMGw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIWu-0000000EJ8A-2oSG;
	Wed, 11 Dec 2024 08:57:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 13/43] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
Date: Wed, 11 Dec 2024 09:54:38 +0100
Message-ID: <20241211085636.1380516-14-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The zone allocator wants to be able to remove a delalloc mapping in the
COW fork while keeping the block reservation.  To support that pass the
blags argument down to xfs_bmap_del_extent_delay and support the
XFS_BMAPI_REMAP flag to keep the reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 +++++++---
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_bmap_util.c   |  2 +-
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 861945a5fce3..512f1ceca47f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4666,7 +4666,8 @@ xfs_bmap_del_extent_delay(
 	int			whichfork,
 	struct xfs_iext_cursor	*icur,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*del)
+	struct xfs_bmbt_irec	*del,
+	uint32_t		bflags)	/* bmapi flags */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -4786,7 +4787,9 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (isrt)
+	if (bflags & XFS_BMAPI_REMAP)
+		;
+	else if (isrt)
 		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
@@ -5388,7 +5391,8 @@ __xfs_bunmapi(
 
 delete:
 		if (wasdel) {
-			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
+			xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got,
+					&del, flags);
 		} else {
 			error = xfs_bmap_del_extent_real(ip, tp, &icur, cur,
 					&del, &tmp_logflags, whichfork,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4d48087fd3a8..b4d9c6e0f3f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -204,7 +204,7 @@ int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extnum_t nexts, int *done);
 void	xfs_bmap_del_extent_delay(struct xfs_inode *ip, int whichfork,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
-		struct xfs_bmbt_irec *del);
+		struct xfs_bmbt_irec *del, uint32_t bflags);
 void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 		struct xfs_iext_cursor *cur, struct xfs_bmbt_irec *got,
 		struct xfs_bmbt_irec *del);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0836fea2d6d8..c623688e457c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -467,7 +467,7 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
+		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del, 0);
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3e778e077d09..b7dba5ad2f34 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -651,7 +651,7 @@ xfs_reflink_cancel_cow_blocks(
 
 		if (isnullstartblock(del.br_startblock)) {
 			xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &got,
-					&del);
+					&del, 0);
 		} else if (del.br_state == XFS_EXT_UNWRITTEN || cancel_real) {
 			ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
 
-- 
2.45.2

