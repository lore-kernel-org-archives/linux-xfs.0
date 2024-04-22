Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB93145FE9
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784868; cv=none; b=rl2dXyVTeeUWchqIxzi46V5LgmrhWfSetAA5H2AYPtzdZD9lGWIjP5E5kZ9T1qgFxGqBQ4vH0ZrtpSCEGsRb+sIwYR+TcGk4F0gp+mTD1665HwkZg23wG8AKCgZnJyX/mPxzdSnKs2dO74zxvHHD5aZZ6R98x8kZee8sLZQx8Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784868; c=relaxed/simple;
	bh=hziRA1Drx2egZ4A6AaRwv1rlJXlnzLk+yYPLYsXuLMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IAjQqTUKFe96A/E47UvUeEEsFU4luab9w4JNKPxm9h5SNN6DFa69EaWe3mFF4o5j4M4x7l9pd++Kh2gsJougZVsPtzvn52n6nKw8nbQZBfpvsY4/il3awodfpvy/oh+V57ZO9Pf5he7wQaE/Toc3tF7PnzNvCuXUMVK2besL5u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=llTsMwj/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="llTsMwj/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0USXuzPKUSat8q/z7C64t/aakr1CuioJZfnSotHrGFs=; b=llTsMwj//yk2Tl17YqxY9fCvXz
	Ob+qH80Thssjw99hfnM8O8NhlR9RjRXjqylwfgnofIedyorLd2JRHnQsaSmifFVmSNCVroYe48qTc
	kPbAm3vY13nxrzeCMGJ8JYC71Im6RWuL17380P8yIyln93AK4XQqnnwJDTq9VN5ECQEVRY6sxd8ci
	8tWaNkPowAekry3rWnBSSSYl05qB9jGU5lvboqdLPe86dvB1gDY+h3FlTi2pKlnN3iMwAnvZkfuGk
	oyg69HVHqu10uZiW1FxMiFp3qwfjd0m79Iu0ZP8/CBZLHLxzA8WROAmRg95tsRWlNCRWbec0lfR2/
	yF7Dy1EQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjO-0000000DLRj-01A5;
	Mon, 22 Apr 2024 11:21:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 12/13] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Mon, 22 Apr 2024 13:20:18 +0200
Message-Id: <20240422112019.212467-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When xfs_bmap_del_extent_delay has to split an indirect block it tries
to steal blocks from the the part that gets unmapped to increase the
indirect block reservation that now needs to cover for two extents
instead of one.

This works perfectly fine on the data device, where the data and
indirect blocks come from the same pool.  It has no chance of working
when the inode sits on the RT device.  To support re-enabling delalloc
for inodes on the RT device, make this behavior conditional on not
being for rt extents.

Note that split of delalloc extents should only happen on writeback
failure, as for other kinds of hole punching we first write back all
data and thus convert the delalloc reservations covering the hole to
a real allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fe33254ca39074..8a1446e025e072 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4983,9 +4983,14 @@ xfs_bmap_del_extent_delay(
 		/*
 		 * Steal as many blocks as we can to try and satisfy the worst
 		 * case indlen for both new extents.
+		 *
+		 * However, we can't just steal reservations from the data
+		 * blocks if this is an RT inodes as the data and metadata
+		 * blocks come from different pools.  We'll have to live with
+		 * under-filled indirect reservation in this case.
 		 */
 		da_new = got_indlen + new_indlen;
-		if (da_new > da_old) {
+		if (da_new > da_old && !isrt) {
 			stolen = XFS_FILBLKS_MIN(da_new - da_old,
 						 del->br_blockcount);
 			da_old += stolen;
-- 
2.39.2

