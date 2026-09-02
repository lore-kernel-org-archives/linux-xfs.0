Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9119305693;
	Wed,  2 Sep 2026 05:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788327816; cv=none; b=J0UToDZkmp5rF1Zef6q2mZQk6Ijxo3iM06KK7PqzJG7laG2y0dXYY8BcFuCXPkj+5kf3UvdXYjwUoRrArzfbDpxNaokddpvPDRjZQHAZf8V1A3mIn391wIizixzE/HTfdSjVepRfNjCcQX3CBR5taEU6kSpbzmB9tdjeVp/N8/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788327816; c=relaxed/simple;
	bh=M7iok7LL9DeOBsUrV0YKCJJkz7N0PfAD2HueBVGME3k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pyo1tlFnPGcCS24O14OZ+pAVgOK+LC8j6EWV+rkC14SqMn23C2O7E6lShDx4/9eDQFlbiy0tdM1kjSFVltqE813/XoI3Ca2QhIgVoGbCJwOOqgA69/aasXNI5hpe+ORkyzFspKX0ZbiWZnRt320NHdmbwY6l52cZmKOjc47ub9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XUGhjs1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XUGhjs1E"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 41BC01F000E9;
	Wed,  2 Sep 2026 05:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788327815;
	bh=G5jdjM9x+a1EIJfBgYi/j6Ait6scDTCx8zmfpsMiRoQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=XUGhjs1EdMV4D1+sXlRwPl1MDqmizhyEhnj1UdJBemuP5Chm2oegNKB472mGN32jJ
	 sdE4tLhSkEvfBgO2CboZ8XltFZCkjs3Bd+JYim0mSxyWi3AR0QwaT4fo4vqLhECS5n
	 RPqNO7KeNJhpHfU+lASuaHMLcVrxUS8kqMqnW/8oTYYle8lxn9ukcDocmRiq0DBZkC
	 DjAoFEWImG5+pOp9StCEvrTBFFk4B5d9Sr54+kp+7F1NWJOLZC/90FnYQTDx5leG0s
	 Bi7ZHzQAhQfMEfGqQuhGXq3Zf9Z950QCtK2g6imf4aoUa3uK6IV5SbwiPKudl8R3tG
	 BxtWmq1Iu/p4g==
Date: Tue, 01 Sep 2026 22:43:34 -0700
Subject: [PATCH 1/6] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, hch@lst.de, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178832749444.3507209.986722117041125252.stgit@frogsfrogsfrogs>
In-Reply-To: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
References: <178832749387.3507209.8650516312948237987.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It's possible to construct an in-memory rtrmap btree for filesystems
that don't have the rmap feature enabled.  The kernel doesn't do this,
but xfs_repair will, if asked to reindex a filesystem that has rtreflink
enabled but not rtrmap.  Therefore, we must create the cursor with
enough levels to handle a maximally sized btree possible.

Note that the rtrmapbt btree cursor slab creates objects large enough to
handle xfs_rtrmap_maxlevels_ondisk() levels, so setting bc_nlevels to
the same value isn't costing us any extra memory.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 4a61f12eb11958 ("xfs: create a shadow rmap btree during realtime rmap repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 0cb2113d5b4045..a15e460a1ec7f4 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -618,7 +618,7 @@ xfs_rtrmapbt_mem_cursor(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
-			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+			xfs_rtrmapbt_maxlevels_ondisk(), xfs_rtrmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 	cur->bc_group = xfs_group_hold(rtg_group(rtg));

