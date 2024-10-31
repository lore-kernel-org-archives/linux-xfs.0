Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0C81C6B8
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 13:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380139; cv=none; b=Yse/g10tv5ppfnT29BwzOhglGmdN/fsoo4/CzT/VP06o2H2Q/OER6//rfCCoqWI+J1Wn/ttLlmb7Du0t2H7+0sFrZ9fyoSF/5N1StAMs96EvgNLNg8oGyS+IM0Il55Lan7jqAJrCWpzDsKKGUunRpJlKzXWr95d9/lgF4fDvF2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380139; c=relaxed/simple;
	bh=GQTdaM/Q+EhLTkXYPJYs29VN+CCTngRPoP8GcdF+7SM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aNhXf6Fz43yyawbcP3QkBsMJzSjr8hyAD4UkvT20pGt27bF7RyBcJ/qYunjWPoXkhuU+m+FQU1UKJaxEFtQWMzX7pxGGbcBfwKSvBDR11DaREBHx0o+DzQnbiGnBrQaMS1hfdHzL55NXdiwB6Ljjb2g0Y7LQ4PQPzvFYKRkIRE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LWztDZpZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LWztDZpZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=982kO25hSbu88LVhXMo3zDRJdVlzccbAyzjkEQwbspE=; b=LWztDZpZEzZy3/N42AF/kvsIuv
	S3svlRUjvaEFfapMwqnZwSWVKCFnlBILVYePK17SojYqEVStEY6YIl1acbfqxWcPkY0F165b9uxcA
	7LwojPBuxsDBO/1G6wsX3/hL0Fgojx3FjoouJ7qKajvTRTL/hoc1jM0lUwpdckeSO+1MV5hKvubmw
	WABnbDvYvcpV278Ev0//zgg8W9VR2gopibSiZJpt7wDUbcdtFwj2lFf8f3KkUoHM2pkvTpxxASTtt
	tm27H3v3GhlMn9RyoEMEIg+/IkeZIlblImk9LSIkK+4F0xsZ4pn4H1yQAgOSfXt0//v4utJmFJHkl
	UWdWrZZA==;
Received: from 2a02-8389-2341-5b80-4107-91b3-66f5-c0ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:4107:91b3:66f5:c0ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t6Uv2-00000003dPY-1ftx;
	Thu, 31 Oct 2024 13:08:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: simplify sector number calculation in xfs_zero_extent
Date: Thu, 31 Oct 2024 14:08:35 +0100
Message-ID: <20241031130854.163004-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_zero_extent does some really odd gymnstics to calculate the block
layer sectors numbers passed to blkdev_issue_zeroout.  This is because it
used to call sb_issue_zeroout and the calculations in that helper got
open coded here in the rather misleadingly named commit 3dc29161070a
("dax: use sb_issue_zerout instead of calling dax_clear_sectors").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index ba6092fcdeb8..05fd768f7dcd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -49,10 +49,6 @@ xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 
 /*
  * Routine to zero an extent on disk allocated to the specific inode.
- *
- * The VFS functions take a linearised filesystem block offset, so we have to
- * convert the sparse xfs fsb to the right format first.
- * VFS types are real funky, too.
  */
 int
 xfs_zero_extent(
@@ -60,15 +56,10 @@ xfs_zero_extent(
 	xfs_fsblock_t		start_fsb,
 	xfs_off_t		count_fsb)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
-	xfs_daddr_t		sector = xfs_fsb_to_db(ip, start_fsb);
-	sector_t		block = XFS_BB_TO_FSBT(mp, sector);
-
-	return blkdev_issue_zeroout(target->bt_bdev,
-		block << (mp->m_super->s_blocksize_bits - 9),
-		count_fsb << (mp->m_super->s_blocksize_bits - 9),
-		GFP_KERNEL, 0);
+	return blkdev_issue_zeroout(xfs_inode_buftarg(ip)->bt_bdev,
+			xfs_fsb_to_db(ip, start_fsb),
+			XFS_FSB_TO_BB(ip->i_mount, count_fsb),
+			GFP_KERNEL, 0);
 }
 
 /*
-- 
2.45.2

