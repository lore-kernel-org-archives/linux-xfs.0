Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BC3345757
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778191950; cv=none; b=i+XSwIDbri4Kznk3x05tspDpY0SEy5uiY4PooWnesnMJO5CSjSNU0KqP9te0XprsO10voCwR9MgT1PTSAniQFM4lm+4BHE0kPkhW4DofyAwXMnmEB/RL+xi51Iypwuv4HCNC89TngssNc+eeGkjoqN8/B0PAfPnFscabsnKt1lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778191950; c=relaxed/simple;
	bh=P8mH9+LcBsLOjYhL7W9hxPmRB/fz31UYnHp/28ysAqw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgGReVXhilFvQhstyp5bwNa4iZXn8M1Ig8xoWNLO2+dSfREiy3P1drdd65BcAnrxkN/vvODhuQMkcyV9ctreG4TDhQ7T9YthNqECEMdhXUb1c/QefgX/hr7LAMT81JgzppE++4000e0szDDDJ/yGXXzYiE0QmNcXYeiQ03jgZpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rg+V/ALF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rg+V/ALF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D150C2BCB2;
	Thu,  7 May 2026 22:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778191950;
	bh=P8mH9+LcBsLOjYhL7W9hxPmRB/fz31UYnHp/28ysAqw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rg+V/ALFHjRO64owZLWqKBi/JtSfn7AQd55qd8Z/DorPYHyButDqNGTNG2oXMg9an
	 eJQUsmubnxL0m6kAb8dbkZTRqDi3XzwYWeicG+FPyr44qwYTUmMzR+oyC0J0B9Nli+
	 ac7dXmoB92pxh/OPVZtCpLCDAl+Tc6VFDXBRhdrSpNFDvtNHfm+vl/6suFrbpR88Fp
	 O6M09+abll2qZJAaw7eTKbMmZfzozjiboyuMDr7E8xsYAtP268EmrO2er1WxwV8qJH
	 CnHojqoJ088muLxRW/DzBozjkwTZQyUiuPsRb+qG2JnhT55JNB4VmPQqiovhNFc3jT
	 ZKOqt0Gfq3pnQ==
Date: Thu, 07 May 2026 15:12:30 -0700
Subject: [PATCH 2/2] xfs: switch (back) to a per-buftarg buffer hash
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: bfoster@redhat.com, cem@kernel.org, hch@lst.de,
 syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177819182930.3486206.5244724900370880393.stgit@frogsfrogsfrogs>
In-Reply-To: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
References: <177819182887.3486206.18149824043863236840.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 497560b9ef42a4ab22ada7f1ea975a89cd3c5dfa

The per-AG buffer hashes were added when all buffer lookups took a
per-hash look.  Since then we've made lookups entirely lockless and
removed the need for a hash-wide lock for inserts and removals as
well.  With this there is no need to sharding the hash, so reduce the
used resources by using a per-buftarg hash for all buftargs.

Long after writing this initially, syzbot found a problem in the buffer
cache teardown order, which this happens to fix as well by doing the
entire buffer cache teardown in one places instead of splitting it
between destroying the buftarg and the perag structures.

Link: https://lore.kernel.org/linux-xfs/aLeUdemAZ5wmtZel@dread.disaster.area/
Reported-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: syzbot+0391d34e801643e2809b@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h |    2 --
 libxfs/xfs_ag.c |   13 ++-----------
 2 files changed, 2 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 3cd4790768ff91..16a9b43a3c270c 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -85,8 +85,6 @@ struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
-	struct xfs_buf_cache	pag_bcache;
-
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 #endif /* __KERNEL__ */
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index fd5f902b052435..1c75ef51056789 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -108,10 +108,7 @@ xfs_perag_uninit(
 	struct xfs_group	*xg)
 {
 #ifdef __KERNEL__
-	struct xfs_perag	*pag = to_perag(xg);
-
-	cancel_delayed_work_sync(&pag->pag_blockgc_work);
-	xfs_buf_cache_destroy(&pag->pag_bcache);
+	cancel_delayed_work_sync(&to_perag(xg)->pag_blockgc_work);
 #endif
 }
 
@@ -233,10 +230,6 @@ xfs_perag_alloc(
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 #endif /* __KERNEL__ */
 
-	error = xfs_buf_cache_init(&pag->pag_bcache);
-	if (error)
-		goto out_free_perag;
-
 	/*
 	 * Pre-calculated geometry
 	 */
@@ -248,12 +241,10 @@ xfs_perag_alloc(
 
 	error = xfs_group_insert(mp, pag_group(pag), index, XG_TYPE_AG);
 	if (error)
-		goto out_buf_cache_destroy;
+		goto out_free_perag;
 
 	return 0;
 
-out_buf_cache_destroy:
-	xfs_buf_cache_destroy(&pag->pag_bcache);
 out_free_perag:
 	kfree(pag);
 	return error;

