Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275846;
	b=FXwH0izzyOpNPg7SHO27pGS/axYIG+u8BHdA8roOxaWF5zAu8R4AW+UwA5tLyso+CZgR
	 MPrjp4ctFgkZUzRVLuexAlJyGb9m4JYNRyyOSvLCWFvaXE9PmP9cW6b6UltOH6KRP4mkv
	 6CSiZp0umKHqnAUALgs87YUr/284Je5WHrcnwNuo7BkyEhEOxNF5cnCywugVClyj3YvOB
	 MNJ6zd9XrToEHeFshfSKRggf0Ey6LVxBzcvp5BJBlk/QwFWH+BGtEs5pJ6m+ZhBBSC1Zi
	 5i+kiTPz9+F32otKEMoSB4em0X9/VHf7vaF6W/mx2G53jEW6pBGVkX/MWvoZ4vKRDGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RXFRfHwfyHNicsU3I9Ho5KRBPp82xhpBeZ31Tr98/yA=;
	b=x4sZ0ylbvzPvWKWhMyLr5V1ei6K4VYItwZc83QOk+bxevXZ4Ogmv5Lw4K5qsa1Q8hUT9
	 cyE0Dk23tKMwEjyqAi6PB9A5Wu42il8yOPkYDfluXrG7/yRpcyd9jd8Nn9jPnkmISanZk
	 SXrsFW74W7Yi9cUiNghCSWTpL5BoxAnDgnArqyAI96TEDQ7iVed4oJuPNfPcVJPJ8g4gk
	 DZtJ0Lgnko+Hc/LL9o/a5hbsATxszveB93399HyIItghxsD9feO3ph0VVMpiaV3o+4h8Z
	 Gv3C7+JZsGsU/pg0xQrkPPgxBzLYvWhtpZazvoa/usHY6f7cPQ7tciz0IJxrATCrDOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ej2au3Y7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC80606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ej2au3Y7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360AC1F01828;
	Thu, 29 Oct 2026 12:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275846;
	bh=RXFRfHwfyHNicsU3I9Ho5KRBPp82xhpBeZ31Tr98/yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ej2au3Y7FkOlWEmYJ+q1/s752pCmRcozktzeivQMng2/cxmyzRfPz3EIoQs1L+VTm
	 J6D0/Wz1f2wZHNqqNbwo8UQOWjisvKZmPIIcKZUTTvepAZkTt4wyfSHVfEJ6r0Wn8N
	 J8yE/LeX1xq4XcKSXWoFJ8sUTwZFvv1Mv9wTuSunncVeL5Jl0G2A8Jnyhqz3Zuaaje
	 HyEQUfpsA2nrrh6VfeheuVCsbdSvXmpjmJdfcoArePigCEiyfO+Jg/TwmKnXSTfo3u
	 yNWnBjhMTf8Qh03vQyk23S5z8dRYUGydRu/R6Wjcm8BdqGgMCKc+IyFcEsrqOXzoY3
	 3ZY4hoe63J1pQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: [PATCH 19/28] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
Date: Thu, 29 Oct 2026 13:06:16 +0100
Message-ID: <20261029120631.803074-20-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 022d5f5fce7f0b6125d404eb74044e6238aef369

It's possible to construct an in-memory rtrmap btree for filesystems
that don't have the rmap feature enabled.  The kernel doesn't do this,
but xfs_repair will, if asked to reindex a filesystem that has rtreflink
enabled but not rtrmap.  Therefore, we must create the cursor with
enough levels to handle a maximally sized btree possible.

Note that the rtrmapbt btree cursor slab creates objects large enough to
handle xfs_rtrmap_maxlevels_ondisk() levels, so setting bc_nlevels to
the same value isn't costing us any extra memory.

Fixes: 4a61f12eb11958 ("xfs: create a shadow rmap btree during realtime rmap repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 0cb2113d5b40..a15e460a1ec7 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -618,7 +618,7 @@ xfs_rtrmapbt_mem_cursor(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
-			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+			xfs_rtrmapbt_maxlevels_ondisk(), xfs_rtrmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 	cur->bc_group = xfs_group_hold(rtg_group(rtg));
-- 
2.54.0

