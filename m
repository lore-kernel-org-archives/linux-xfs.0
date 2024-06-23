Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB9120E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120972; cv=none; b=OqERdCae2Bk8QW0pCXdl7JJFvzcWfOrgDoe819hfMYII5sGl/FC0OQfs2IlLhECbIq2k0p0Mko3LrpS8zS81YnbdBICzrVCofrKT+yOpVN5gnyXwasm8P1Dhy7e8dkqKIEkfWN0t2yRbOqyT2+InnxkgQtoHqR9oMjjBau443CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120972; c=relaxed/simple;
	bh=Xl7ZhTdSH0rx5ES25zn63cZGzL6lLalKtCJB0Xp8yBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTEfBWeMnOR3f+6Lwh2igm5rHdn5MFwlflPF8j5/+MRyz38UBq3cWucgDoejxVFQJl2kc9C9UstIMGs0S+EAl/L976FbNwi12VC1QAEe9bm1ijEb+pxTLvYqP8+Nn9K5anCiJiFkoiWskmd0zUC3sB7II861h17FtkuBpaxFXmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mIl+XF/y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mIl+XF/y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=B7G2rHwczb0XBn9nGkvhOKsTeqaDrTu+fOpTyinDvHs=; b=mIl+XF/y/wax1SkNhmjVCTFt9t
	O5Gdv8+mKwzNorrNTbZZyRVdi6QaVC/uiuBnJgA2/hrKSF2XfPQYvpHEZ0oeeobllSFnjTdJbg9/X
	ZbRvG98K4z5Y4CAC0edsSWvln4JU4ngfsKO29MNBIwPdU4BRsPQIs61CrcfliPtGcFLjxCrN8yzoE
	snjs4+Zsk8zNCxAvy4B41z+LSm7lyObU/qS8vyGr5YG7vOrSHZL6we9h1KNGcqmKgP5I+0ZmBGIJ1
	/IgREoU37kgHcc7QuNyuS7Atcl7xBt+/dBw+A/2Nxm/qavGw1a0dST8v+Oyz99v/Tr4O3P+sMFMc0
	Zjh42+kg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFta-0000000DOJv-0za1;
	Sun, 23 Jun 2024 05:36:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/10] xfs: simplify extent lookup in xfs_can_free_eofblocks
Date: Sun, 23 Jun 2024 07:34:54 +0200
Message-ID: <20240623053532.857496-10-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_can_free_eofblocks just cares if there is an extent beyond EOF.
Replace the call to xfs_bmapi_read with a xfs_iext_lookup_extent
as we've already checked that extents are read in earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a4d9fbc21b8343..52863b784b023f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -492,12 +492,12 @@ bool
 xfs_can_free_eofblocks(
 	struct xfs_inode	*ip)
 {
-	struct xfs_bmbt_irec	imap;
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			found_blocks = false;
 	xfs_fileoff_t		end_fsb;
 	xfs_fileoff_t		last_fsb;
-	int			nimaps = 1;
-	int			error;
+	struct xfs_bmbt_irec	imap;
+	struct xfs_iext_cursor	icur;
 
 	/*
 	 * Caller must either hold the exclusive io lock; or be inactivating
@@ -544,21 +544,13 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Look up the mapping for the first block past EOF.  If we can't find
-	 * it, there's nothing to free.
+	 * Check if there is an post-EOF extent to free.
 	 */
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	error = xfs_bmapi_read(ip, end_fsb, last_fsb - end_fsb, &imap, &nimaps,
-			0);
+	if (xfs_iext_lookup_extent(ip, &ip->i_df, end_fsb, &icur, &imap))
+		found_blocks = true;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	if (error || nimaps == 0)
-		return false;
-
-	/*
-	 * If there's a real mapping there or there are delayed allocation
-	 * reservations, then we have post-EOF blocks to try to free.
-	 */
-	return imap.br_startblock != HOLESTARTBLOCK || ip->i_delayed_blks;
+	return found_blocks;
 }
 
 /*
-- 
2.43.0

