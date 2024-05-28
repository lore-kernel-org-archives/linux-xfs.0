Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910A11429B;
	Tue, 28 May 2024 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716869582; cv=none; b=eEA5G4NJsU/dmP9fkUcDH08LXfSdWLm0qpog/RvN9vHIi9rQCDSlvlCrxi2pZzBtO9ogQlRsf9vimpko9vgQVpYqwhA3O8y1Kg+DVndNUV7kJSXxzh2XFizvnhwEfWBKFFxe9N/Zwew1C+9wupC4l81baQOJy8jR84R+81i5FSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716869582; c=relaxed/simple;
	bh=x9Rlf8wl3JxeXV0/ov/EZ5Ix7bzuuHNhbjCuo6p85ws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WpKKVOjl4G+LUoEEeaGztmNRVO1LMiKVtRo4vBwf6r3MLVbbrQ7AIHbkCO19F1DNqEz+Gn+xagGfZzwSonBBSL/kHiE2/ZpUh1Axh2NppWJr71pmBYefLHBhz3iYfycHnl+z9XYywh4QFfhPeQqau1Or5YMuknlsqIKo/olUN08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W976m3l4; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W976m3l4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1716869571; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=7O8EsjskgXj4srU7xmN/rSPQeBKsB8BqZNKMKD3Eq8o=;
	b=W976m3l4OS2EI6Ulr0x8lhdrH7zagh2Gx+JKcEYaoKeeQE1Z86PoWYBaV1MOaWhgk4WgKNm99ORqXMZMwrbsYrdaRMCzSFjUjYTCaw8rtGL+ZtBomIbmJbdR3A6MHatthcB3xMZ8OGJEonawG3VUTwhseX2TamiQyK95zEpe/fM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033068173054;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W7OLZIn_1716869562;
Received: from x31i01179.sqa.na131.tbsite.net(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0W7OLZIn_1716869562)
          by smtp.aliyun-inc.com;
          Tue, 28 May 2024 12:12:50 +0800
From: Gao Xiang <hsiangkao@linux.alibaba.com>
To: linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH v2] xfs: avoid redundant AGFL buffer invalidation
Date: Tue, 28 May 2024 12:12:39 +0800
Message-Id: <20240528041239.1190215-1-hsiangkao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <1b2be7fa-332d-4fab-8d36-89ef7a0d3a24@linux.alibaba.com>
References: <1b2be7fa-332d-4fab-8d36-89ef7a0d3a24@linux.alibaba.com>
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
[  333.507862]  xfs_buf_find+0x371/0x6a0       <- xfs_buf_lock
[  333.508451]  xfs_buf_get_map+0x3f/0x230
[  333.509062]  xfs_trans_get_buf_map+0x11a/0x280
[  333.509751]  xfs_free_agfl_block+0xa1/0xd0
[  333.510403]  xfs_agfl_free_finish_item+0x16e/0x1d0
[  333.511157]  xfs_defer_finish_noroll+0x1ef/0x5c0
[  333.511871]  xfs_defer_finish+0xc/0xa0
[  333.512471]  xfs_itruncate_extents_flags+0x18a/0x5e0
[  333.513253]  xfs_inactive_truncate+0xb8/0x130
[  333.513930]  xfs_inactive+0x223/0x270

xfs_log_force() will take tens of milliseconds with AGF buffer locked.
It becomes an unnecessary long latency especially on our PMEM devices
with FSDAX enabled and fsops like xfs_reflink_find_shared() at the same
time are stuck due to the same AGF lock.  Removing the double
invalidation on the AGFL blocks does not make this issue go away, but
this patch fixes for our workloads in reality and it should also work
by the code analysis.

Note that I'm not sure I need to remove another redundant one in
xfs_alloc_ag_vextent_small() since it's unrelated to our workloads.
Also fstests are passed with this patch.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
---
changes since v1:
 - Get rid of xfs_free_agfl_block() suggested by Dave;
 - Some commit message refinement.

 fs/xfs/libxfs/xfs_alloc.c | 28 +---------------------------
 fs/xfs/libxfs/xfs_alloc.h |  6 ++++--
 fs/xfs/xfs_extfree_item.c |  4 ++--
 3 files changed, 7 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6cb8b2ddc541..67b0709734f5 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1934,7 +1934,7 @@ xfs_alloc_ag_vextent_size(
 /*
  * Free the extent starting at agno/bno for length.
  */
-STATIC int
+int
 xfs_free_ag_extent(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
@@ -2424,32 +2424,6 @@ xfs_alloc_space_available(
 	return true;
 }
 
-int
-xfs_free_agfl_block(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agblock_t		agbno,
-	struct xfs_buf		*agbp,
-	struct xfs_owner_info	*oinfo)
-{
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
-}
-
 /*
  * Check the agfl fields of the agf for inconsistency or corruption.
  *
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0b956f8b9d5a..3dc8e44fea76 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -80,6 +80,10 @@ int xfs_alloc_get_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, struct xfs_buf *agflbp,
 		xfs_agblock_t bno, int btreeblk);
+int xfs_free_ag_extent(struct xfs_trans *tp, struct xfs_buf *agbp,
+		xfs_agnumber_t agno, xfs_agblock_t bno,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+		enum xfs_ag_resv_type type);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.
@@ -194,8 +198,6 @@ int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agfl(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf **bpp);
-int xfs_free_agfl_block(struct xfs_trans *, xfs_agnumber_t, xfs_agblock_t,
-			struct xfs_buf *, struct xfs_owner_info *);
 int xfs_alloc_fix_freelist(struct xfs_alloc_arg *args, uint32_t alloc_flags);
 int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_buf **agbp);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 8c382f092332..01ebbd7691a5 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -547,8 +547,8 @@ xfs_agfl_free_finish_item(
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
-		error = xfs_free_agfl_block(tp, xefi->xefi_pag->pag_agno,
-				agbno, agbp, &oinfo);
+		error = xfs_free_ag_extent(tp, agbp, xefi->xefi_pag->pag_agno,
+				agbno, 1, &oinfo, XFS_AG_RESV_AGFL);
 
 	next_extent = efdp->efd_next_extent;
 	ASSERT(next_extent < efdp->efd_format.efd_nextents);
-- 
2.39.3

