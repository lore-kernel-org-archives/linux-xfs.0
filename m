Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E07200C8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Feb 2024 06:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708324496; cv=none; b=Gxs1d7Z+YOEstAbuNd4HtlMN1MFV9l3b9RHCqEBHyid99nmAZ0lfFbktwuRncH2UtDMVlDpVuqaxpaG7QaRw14VORW5HqFIV2cQ4LliUKDxN9UiygUnO4bRhoLQ8FcPoUQ/jQYWcjCVQ+aOimIl3h5aZq/3RRcdKxSnVWVbFrGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708324496; c=relaxed/simple;
	bh=SCUv/xvkY85eU/KiSYevi/a9hAfIscNoZg/mncU9RUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nUBNQpGmttJVgC1fbUVgjElsB2jA/3KQFCNH4bcxh/FJ26/gFtrfXLVnaHAucGDIJrDVX6FJ2G2idriWKbu8Yknnf1lWbh7eAsSpe4r3iKEAwAPZsUoLmZdAlNmwwtkN72T5irzW9CkvUuX6uq+YvO+vpm5mUCAPhDlsejVBtF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1eb8RjXQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1eb8RjXQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cJwY36xS6PvSp/vYl1CKsXpJr62awfAoGAkIx8s/cLY=; b=1eb8RjXQFRULLLEtxw8EwQmCD4
	W5YgAA+aRxrqdQeG/dD9roqsVWwjLdtdF+U6AFn2hMFrdtGdcP7Uz7+o37dP7fK3l+c0bCFvu5fGM
	OyCMopEEHuhb+zBU8emAxSpWLIlx77nN9bZ+k/d5YgJNUe5A3oVm2Q/7Y09TvOmcynbcPnytYf4fr
	h5TdqxLTLOUG+42nZdzDng/asAZjPkoJormcBTnsEvANb/EqUIj+f0Xo7+TiEp5IKH+1hHgD4P5Kr
	R9ubiW4SMHs5DLOysS2z5W2tXyHlr/5ZdKhwaJMMBCqtY4qRbgW3EF8eCi0hBaAAzQthVu0fsDfNl
	XVeahKwA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbxEs-00000009GKI-0ChV;
	Mon, 19 Feb 2024 06:34:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
Date: Mon, 19 Feb 2024 07:34:45 +0100
Message-Id: <20240219063450.3032254-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219063450.3032254-1-hch@lst.de>
References: <20240219063450.3032254-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Allocate data blocks for RT inodes using xfs_dec_frextents.  While at
it optimize the data device case by doing only a single xfs_dec_fdblocks
call for the extent itself and the indirect blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cc788cde8bffd6..95e93534cd1264 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3984,6 +3984,7 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	uint64_t		fdblocks;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
@@ -4026,14 +4027,18 @@ xfs_bmapi_reserve_delalloc(
 	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
 	ASSERT(indlen > 0);
 
-	error = xfs_dec_fdblocks(mp, alen, false);
-	if (error)
-		goto out_unreserve_quota;
+	fdblocks = indlen;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xfs_dec_frextents(mp, xfs_rtb_to_rtx(mp, alen));
+		if (error)
+			goto out_unreserve_quota;
+	} else {
+		fdblocks += alen;
+	}
 
-	error = xfs_dec_fdblocks(mp, indlen, false);
+	error = xfs_dec_fdblocks(mp, fdblocks, false);
 	if (error)
-		goto out_unreserve_blocks;
-
+		goto out_unreserve_frextents;
 
 	ip->i_delayed_blks += alen;
 	xfs_mod_delalloc(ip->i_mount, alen + indlen);
@@ -4057,8 +4062,9 @@ xfs_bmapi_reserve_delalloc(
 
 	return 0;
 
-out_unreserve_blocks:
-	xfs_add_fdblocks(mp, alen);
+out_unreserve_frextents:
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_add_frextents(mp, xfs_rtb_to_rtx(mp, alen));
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
 		xfs_quota_unreserve_blkres(ip, alen);
-- 
2.39.2

