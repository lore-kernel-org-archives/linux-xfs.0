Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372AE15664F
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333479; cv=none; b=qqdIg0YvV4u0l10coyq5Y2c3dmmjVGwp/Ix2BIt7eFZHymlHProokmDpDnaHfxjYZm1kSAKntng1gcD64l83QHNq0kkjM8WebeALJTBzK+ma0uxWIMAxy2nl1S0BYrgE4TinzV1bGOU+naxNV2mqixBwKNBySr6ZWY1dgYdbAOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333479; c=relaxed/simple;
	bh=aMOKAc5f0gBQlPAK8EK+D48x7LMF5H0s4MHeEqXVakg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cixsR2SYM/58FvqAr7UygCNtKkJLrhdFPaSpsGXTWsP2mG8NkmF6c6AUCEx7e87Af5JzRwKO+yaYuSyXvdqgda6puvG8/c9YY91azX6dReFoPF+DfN8DNcR+lCepsTiV/tP9LJdj9UnMeAEPqvToWgq6oL+GjJjf67lMnDNb5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D3nHwe7b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D3nHwe7b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=25jxif0W162BnsGUcS4+kSD9A+DJeGfygPO9lVhKNUQ=; b=D3nHwe7b1qiueWA031Tdm2QmOq
	7YCtmOuOrRb1fqueyPcjdbVt2fwFDjopV/AbBQe1oXnhfVqREZ8qhd6AcwLknQ03wxdLodHZLDrIX
	N+6duCkcKfTF4Iz/wvh/dckFIH+W8Z0W3EYjEHm36lWcJQd2ygGN05vROKAefydXo/v2kcJt6ffwn
	D+RRccp81ZdeHN4SfvaNQQ1WdgLO6aYA9e2hfaY46jNycieoLjXe8OxYiXr5LKXF4ycxEgIKSaSqi
	XrDWMtADuxKkyHXMgCO+H0DwgJxTJsHS5jep81pE2ZehsopxCP6kLjzoZol10eprDtpAzlovyaR+7
	2J9f4Bcg==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0o-0000000EeTG-16mH;
	Mon, 25 Mar 2024 02:24:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/11] xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
Date: Mon, 25 Mar 2024 10:24:05 +0800
Message-Id: <20240325022411.2045794-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 240507cbe4db3e..1114e057e55783 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4067,6 +4067,7 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	uint64_t		fdblocks;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
@@ -4109,14 +4110,18 @@ xfs_bmapi_reserve_delalloc(
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
@@ -4140,8 +4145,9 @@ xfs_bmapi_reserve_delalloc(
 
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

