Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F123775
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 07:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635245; cv=none; b=Ag2Wb8piKCfv4jamrnQH0yfJ2UEQcwKttCbiX8NuKUeSfQhXzumCgE+VP+il1to3XDLLQZESgy+3ExBTtOKVSji5X3oq25H70FuXlJfP5IJClv+hrJYfiUU9G/CY8HGJD0+3ksG3OFU8PgtgPyDgFGlNJYWgpD+HbQQi+e2wrVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635245; c=relaxed/simple;
	bh=JfBVXUBe+iHjEAsRQL6Dx42j8iw1mv+HZcrt+XBEgNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mlysRPwkK9F8VPrx58qxLEGjU+glHin21yEk44PHQifk3LbGLp6WC3fkcXMhTx/pYyWy//l1Uw1K9sjau+hFCdjnxeNQqDFdhYr73LYOOdcrAYgEZdrBOwe1PS4dPMeTFTIEwlRFLTaT+CrKewc5HsIUUFTeHr3ot/6Gna93qEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PPGLoDLX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PPGLoDLX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qythVt4qOX3vV032QtEwZAF8TLR4FAJbq5CgmMEVGrY=; b=PPGLoDLXBXzBHv9P/ToTM1LNcM
	51fxdg7/RlZj9QkTtEFlT3Qwj0bhx6xQX39Sxn3cxBqwDivAA7VWrmy2qcRCX0FCj/Nngupm2ZSeU
	0YuNox0whbdfGoqyKSiXt2I3lQOxrPSLKDMAMl08hu4gmKRAm72xXDZMoaxjQmjJJ3Jghhc86gBfC
	bGK+jLi8fWak4EiAnQBwbEx9yT7WR3eOWTZxeKZ1nNHKeqsNJbu1LTPH+0JbJZYBKIuh4kD7YHiLA
	n7/IBPRXyY5iW08cYgksgCuyT5Nsdt1lzYHpUwldqITl8MuWPjp4vZn677ozoEc2xlMwNFm1B+FS2
	7ltDm4aA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s2Qx9-0000000BojY-1Sdl;
	Thu, 02 May 2024 07:34:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: remove a racy if_bytes check in xfs_reflink_end_cow_extent
Date: Thu,  2 May 2024 09:33:54 +0200
Message-Id: <20240502073355.1893587-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240502073355.1893587-1-hch@lst.de>
References: <20240502073355.1893587-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Accessing if_bytes without the ilock is racy.  Remove the initial
if_bytes == 0 check in xfs_reflink_end_cow_extent and let
ext_iext_lookup_extent fail for this case after we've taken the ilock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d6d5b65eb07fca..3bb5318f699ddc 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -717,12 +717,6 @@ xfs_reflink_end_cow_extent(
 	int			nmaps;
 	int			error;
 
-	/* No COW extents?  That's easy! */
-	if (ifp->if_bytes == 0) {
-		*offset_fsb = end_fsb;
-		return 0;
-	}
-
 	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
 			XFS_TRANS_RESERVE, &tp);
-- 
2.39.2

