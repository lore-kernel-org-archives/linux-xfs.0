Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4454BC8
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537453; cv=none; b=B+JSY0IgqLY9h5bI6XNjhhT+EW50KVTo5Hpbk0xFgA9oO4KppwqJKU6ok7X1EUFqGKC8SLXukSK5s/Ii3MQxZzIyqZAupjaX4nwx1B70npB1veWxzuYw2kKFOitHdeUHzfuu3iutATEw5C8X1/CVjUblTiuu7+jpVGU0nDUVnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537453; c=relaxed/simple;
	bh=1gZxL8ArFdK2QS7ECrfRkbmgnSM7Y/ntXGX+xWhDZZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JWDxEDy8g6sHa6GNamA5tJoftj3niVRIpz4tn3/u56Vm5bvmce5DxR1pnC49kWW4b4o8+Ap8MU4u7a8TwM26lUAeGebRQmu0PfpxnOSqzCaLt3/E45R+TfLC0VGgstCyyMf5mhYya2bI+PbAiZDxqcR1cJBHQufLlzifEa2JnCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lgeh2YKk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lgeh2YKk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iMT74XWRqIWtgge8iodHKwgC4ZSNIqpO9NQnTxh5jDE=; b=lgeh2YKkuMxnEPqXcd2qMIFJpL
	lo2tCxcZdUdfwuaY/YFYBh1NdyjiJjcdNr08/pEyLm4bS9bWM6N8hDivqi7g4PItLp/NJcIA0arxm
	7wqOgqYTgVWRwMt5rw2dp4K4CZ9pGPxZjxN6sGZrmtohHDOriH4Su894EgWTJlviCucD3ZwTBuSyO
	7b8NZx0TsY+lPVOfqYj3PuQ5HHG5Rkuhn2/JFnSiWG7uE4fsAuI0SfKHRdSu2jglgnJrkCFplfxdt
	BULNt4urUZUgo4wMco+9xnsI2O1OmvBkaqo8Jx/o9ugHEwa19YwBTa4oGhoXCaVk0nEpHEg5O3SqK
	qsXkyQ6w==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4l-00000008Wpe-12AP;
	Wed, 27 Mar 2024 11:04:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 12/13] xfs: stop the steal (of data blocks for RT indirect blocks)
Date: Wed, 27 Mar 2024 12:03:17 +0100
Message-Id: <20240327110318.2776850-13-hch@lst.de>
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

When xfs_bmap_del_extent_delay has to split an indirect block it tries
to steal blocks from the the part that gets unmapped to increase the
indirect block reservation that now needs to cover for two extents
instead of one.

This works perfectly fine on the data device, where the data and
indirect blocks come from the same pool.  It has no chance of working
when the inode sits on the RT device.  To support re-enabling delalloc
for inodes on the RT device, make this behavior conditional on not
beeing for rt extents.

Note that split of delalloc extents should only happen on writeback
failure, as for other kinds of hole punching we first write back all
data and thus convert the delalloc reservations covering the hole to
a real allocation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9d0b7caa9a036c..ef34738fb0fedd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4981,9 +4981,14 @@ xfs_bmap_del_extent_delay(
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

