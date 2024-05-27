Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25715E96;
	Mon, 27 May 2024 06:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716790227; cv=none; b=dhC/tz9yQa5eUnN8OUIKtzPxHhQD1MDoI7Fxa1rg6x9Qe9ldyXZx/xI8AFL8pClcH0KTLmv5PmLqRLP8ecQnTkCwmOe8jJKUYV8hYMnMMR2iNxEiDBfkW4D8a5MtMnkas1Yl7LJrzQ7lcv/2jsyEyPeWrA6Cs1lDD1zWBWCVNKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716790227; c=relaxed/simple;
	bh=iKZrztrPmrdcF9KTfZJNQHZ8ZiqFpV1iDuebum44Nl8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tESD5yYxzDNh2GRlvXc43qmgl59yENcjSlC0siaTV8TjGi3PsbUunA8zCkAZgOxrlglq7fOl3kGvx9FP+GTWcGVLFwsqEFyhPRDRMO5Dbrgz6TRhAQTr3VDVy4jZg/6D4iOUI/6k7/cfv/wteOpF9Oo4wXOy9FHz+2vAhyfOkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=V4dZov33; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="V4dZov33"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716790215; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=a1BbLwZ6DOeFwhHsXnf7eauIlyUMnYg0j+SjUcCFnSo=;
	b=V4dZov33d7uOWAlAQQ8CWQLuz7OVKsWwGsoH85uXV7wObBpTwSQsD2EA5RefpCzxGm13QZb0uTVc+liJqqvr0LnAldRaT4mHBBvQX87uDfPph1ySIxn52189r/MkOMamtom62GwKUBV9RYad7pF4zB16w+8G3bUmFEM08Hrn9KY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W7F7bKY_1716790207;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W7F7bKY_1716790207)
          by smtp.aliyun-inc.com;
          Mon, 27 May 2024 14:10:15 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH] xfs: avoid redundant AGFL buffer invalidation
Date: Mon, 27 May 2024 14:10:06 +0800
Message-Id: <20240527061006.4045908-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently AGFL blocks can be filled from the following three sources:
 - allocbt free blocks, as in xfs_allocbt_free_block();
 - rmapbt free blocks, as in xfs_rmapbt_free_block();
 - refilled from freespace btrees, as in xfs_alloc_fix_freelist().

Originally, allocbt free blocks would be marked as stale only when they
put back in the general free space pool as Dave mentioned on IRC, "we
don't stale AGF metadata btree blocks when they are returned to the
AGFL .. but once they get put back in the general free space pool, we
have to make sure the buffers are marked stale as the next user of
those blocks might be user data...."

However, after commit ca250b1b3d71 ("xfs: invalidate allocbt blocks
moved to the free list") and commit edfd9dd54921 ("xfs: move buffer
invalidation to xfs_btree_free_block"), even allocbt / bmapbt free
blocks will be invalidated immediately since they may fail to pass
V5 format validation on writeback even writeback to free space would be
safe.

IOWs, IMHO currently there is actually no difference of free blocks
between AGFL freespace pool and the general free space pool.  So let's
avoid extra redundant AGFL buffer invalidation, since otherwise we're
currently facing unnecessary xfs_log_force() due to xfs_trans_binval()
again on buffers already marked as stale before as below:

[  333.507469] Call Trace:
[  333.507862]  xfs_buf_find+0x371/0x6a0
[  333.508451]  xfs_buf_get_map+0x3f/0x230
[  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
[  333.509751]  xfs_free_agfl_block+0xa1/0xd0
[  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
[  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
[  333.511871]  xfs_defer_finish+0xc/0xa0
[  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
[  333.513253]  xfs_inactive_truncate+0xb8/0x130
[  333.513930]  xfs_inactive+0x223/0x270

And xfs_log_force() will take tens of milliseconds with AGF buffer
locked.  It becomes an unnecessary long latency especially on our PMEM
devices with FSDAX enabled.  Also fstests are passed with this patch.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6cb8b2ddc541..a80d2a31252a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2432,22 +2432,8 @@ xfs_free_agfl_block(
 	struct xfs_buf		*agbp,
 	struct xfs_owner_info	*oinfo)
 {
-	int			error;
-	struct xfs_buf		*bp;
-
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
-				   XFS_AG_RESV_AGFL);
-	if (error)
-		return error;
-
-	error = xfs_trans_get_buf(tp, tp->t_mountp->m_ddev_targp,
-			XFS_AGB_TO_DADDR(tp->t_mountp, agno, agbno),
-			tp->t_mountp->m_bsize, 0, &bp);
-	if (error)
-		return error;
-	xfs_trans_binval(tp, bp);
-
-	return 0;
+	return xfs_free_ag_extent(tp, agbp, agno, agbno, 1, oinfo,
+				  XFS_AG_RESV_AGFL);
 }
 
 /*
-- 
2.39.3

