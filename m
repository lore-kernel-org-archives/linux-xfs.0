Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2784FA8
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816912; cv=none; b=gt1sHlxR5gWb92jzosv4b/+10qGvZrx0eVidpcUWfB4X0XIdGdq8fnQLt/T+cCuDAM2jlRny4B8I1GG8I35IutemOYtDvJx/Sbq6TvgzrD089w7HvDZ66HW5Tl8QEpfVdB4f9p20OwztBs4vauzuLwdO0Vkh+ddm5EvLgiQyATw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816912; c=relaxed/simple;
	bh=Q3DoJPYEUKicPMv2M+i17jRCFXNyDlaxpV+6KHHLb5A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hpnhn3aNnX2/hhpuhdTATm/DkNoXVkuvxDL+ZmpLCL3cGg4AlIotcUqKx07fFrKSQVCQhhBEcLHzsKqWpoCWGE3eNOlXxZmSfqlybqVFhDGBNxcWJ2g45CKw6zkPaoTlT1leDqH/eVXp6aS64OFhvaFvHaQ8mG4kx+LZYINYjOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edkj400u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edkj400u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EE5C433C7;
	Thu,  1 Feb 2024 19:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816912;
	bh=Q3DoJPYEUKicPMv2M+i17jRCFXNyDlaxpV+6KHHLb5A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=edkj400uPUB5z3CT30CJzj+1F9Kne9Vk3kOEYOWg/9GVppM01wG/woiNwhuADEVYr
	 nTraSA9XsF4ggFep3kmewfSkzvZBZraTFrs/OeOVXy3B1eapiUH/14SWYmyamOPZ+M
	 kMqwX6k7XrB5EPWhAt9gLeQnf0xAcyJmbFqWSIBct6/IK6BLqUQKeBxrucePhmPJ8H
	 rKfxzNcwZaz2jA0A0UpWZJaIYUgn6qekh3Bl2XghzqoMgvGQB/BZm9eYvou4P/Q9Ga
	 sB+WtisNnIodpVwu2QSywXA2/RK3DlKyxHpn4cD2YSPcEhsGtZEfWEoUijCBwaCzRU
	 3XaAwCJFJlWUg==
Date: Thu, 01 Feb 2024 11:48:31 -0800
Subject: [PATCH 11/27] xfs: remove xfs_rmapbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334964.1605438.12334303570245209977.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_rmapbt_stage_cursor is currently unused, but future callers can
trivially open code the two calls.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap_btree.c |   14 --------------
 fs/xfs/libxfs/xfs_rmap_btree.h |    2 --
 2 files changed, 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index dda9f8844d841..b0da31f49ca8c 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -528,20 +528,6 @@ xfs_rmapbt_init_cursor(
 	return cur;
 }
 
-/* Create a new reverse mapping btree cursor with a fake root for staging. */
-struct xfs_btree_cur *
-xfs_rmapbt_stage_cursor(
-	struct xfs_mount	*mp,
-	struct xbtree_afakeroot	*afake,
-	struct xfs_perag	*pag)
-{
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_rmapbt_init_cursor(mp, NULL, NULL, pag);
-	xfs_btree_stage_afakeroot(cur, afake);
-	return cur;
-}
-
 /*
  * Install a new reverse mapping btree root.  Caller is responsible for
  * invalidating and freeing the old btree blocks.
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 3244715dd111b..27536d7e14aac 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -44,8 +44,6 @@ struct xbtree_afakeroot;
 struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_trans *tp, struct xfs_buf *bp,
 				struct xfs_perag *pag);
-struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
-		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);

