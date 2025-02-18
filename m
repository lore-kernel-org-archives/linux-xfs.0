Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7B122B5AA
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866354; cv=none; b=dKFGUeGSYzwt04JaLdXbEuveb78ipcuxyU2n66b2HblWn9jSDXhYQU6llc2kN7IEp+oyZf1vkZIFgip3WeDgGjeE1OSs1siAbs2R5twS508QHG8HMdAFlwv3tTN9QmeKiYRFJOiDZ39kw4NCgFVudrkZIcZJfjf0ksp+eySGerw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866354; c=relaxed/simple;
	bh=AM+2BHuJVmjQeJfT+GsU6mrxD4BA9VHdxIc9Fsc0GLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYdh0M3tg5/uadd9CcZCuS4mhkq/3WeAxh6XXi50WkuKbLgPaww2V3ce9Y21WWm3NcWuTRBY/s76wvfo1tCvZjQrhLb3QVeCKu9ID+8AzKumaq8deljmNjAGpMydic69FCQZnFjosKqGxEUJJT79L1zQLJygIWaZxKm9OHhWg4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=udFo2uGq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="udFo2uGq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wPTeV0VsyZ/4DivebEdg7nlrrDfFUwcFAkymm7Qad90=; b=udFo2uGq88LKJ3a0XJET7SxanJ
	lpnyiwkTGXB56eghEOtLPX/jByOQazEltjSyp7+gXneSjJBJ3bZ1j7BHuEYdkF5wuWCpEDGTtt/yR
	G2q3/kyGeI1YFRbr491w4BBhis/NLUb4NkghzLjNY2y4c+9GBC9PS5iYe7GDQ7MwGWsBWHWVB54zT
	wuZ4SoJw4IEK3WB8p3QQMhS9e9LrMS8IrbaXL7rwzZrPfHhSLsu4tqkNrdfibNNp5cl1gtMif/EWN
	5zcWfC06SE6H8UVGIFagr/703E7WHSpksopyx5ocxURQox4Sp9NfVA7ZInUR77sqBKZzkv1mtw99m
	vkbWF7QA==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIiV-00000007CQc-3ske;
	Tue, 18 Feb 2025 08:12:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/45] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
Date: Tue, 18 Feb 2025 09:10:17 +0100
Message-ID: <20250218081153.3889537-15-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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
flags argument down to xfs_bmap_del_extent_delay and support the
XFS_BMAPI_REMAP flag to keep the reservation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 +++++++---
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_bmap_util.c   |  2 +-
 fs/xfs/xfs_reflink.c     |  2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5b17e59ed5b8..522c126e52fb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4667,7 +4667,8 @@ xfs_bmap_del_extent_delay(
 	int			whichfork,
 	struct xfs_iext_cursor	*icur,
 	struct xfs_bmbt_irec	*got,
-	struct xfs_bmbt_irec	*del)
+	struct xfs_bmbt_irec	*del,
+	uint32_t		bflags)	/* bmapi flags */
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -4787,7 +4788,9 @@ xfs_bmap_del_extent_delay(
 	da_diff = da_old - da_new;
 	fdblocks = da_diff;
 
-	if (isrt)
+	if (bflags & XFS_BMAPI_REMAP)
+		;
+	else if (isrt)
 		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, del->br_blockcount));
 	else
 		fdblocks += del->br_blockcount;
@@ -5389,7 +5392,8 @@ __xfs_bunmapi(
 
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
index fd65e5d7994a..b977930c4ebc 100644
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

