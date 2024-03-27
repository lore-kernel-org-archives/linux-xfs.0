Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AD36125
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537432; cv=none; b=Z0RQSFD9CyjZIKyTWgwm3ls+rk11WbYS87sRTqyRtrImadrHdo3M12DfJ36EQEQsHujbZ8PUtUnxWdMIkPnsUaJz/hZLnDj2S3njQu4iktRxPh22DFbMLqPTaOGBlsGWGzWKFAQ5LIq2zB8H+pSKvs4iFXGuNHNM5X044FYtgLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537432; c=relaxed/simple;
	bh=TZvhP5uXR21Qx/07YBQIkZfwYu+YLsAi3vHeju+OwWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f3Hljj3eyJdc2T79KyU4JDG+ycyZxe+aMb1xU3oBvyQEZGuJcyQRmLem+dhxyWlXx4fwDRyAemtR6rcx+6uZRIJDjlKqYqNUFSid0oeIP5OYSIMv8ggcv9dHaBjB40Gd83bU/xKo+wWRS2P4SI8EdcNIKEIADdDCQs/iYRmVvl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GA+OTxGk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GA+OTxGk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uvHnGG0xmcI1A5k8BRYpVX2uqAKH6iaUP39sup2L3ZE=; b=GA+OTxGkRyTwDNGPP1iJfb0wFW
	HJ39LMJUx8oU58Npt4ml5duBj0Abp+262Tte2b90bgsaqCJacjI9ezaiEl3kHdy999lJvXdY8ZCHj
	ybew9WYY7If0/zC1LExWOcU1dYeKFjCqq7QflL3khBSGtL2Zk+v1zYosIQhqIsa/6kJw0NlDDthmR
	I+oiACRzgTESUbidAGRpQsmJOx/o66A/1p2LXRxJNTOqBmjuuZMhAB7qQkVSiOsvu6t6phWZO7rbl
	+ikbpEjaGylT0448lHwW8xGUivmtO6VHUjXRKPgoHjwT3329yOhPBojo47zil6PfJbIjORNJ+65HQ
	Vy6wQKsg==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4P-00000008Wg1-1ctZ;
	Wed, 27 Mar 2024 11:03:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/13] xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
Date: Wed, 27 Mar 2024 12:03:12 +0100
Message-Id: <20240327110318.2776850-8-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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
index 4e81baf5e95301..572c91c986b6af 100644
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

