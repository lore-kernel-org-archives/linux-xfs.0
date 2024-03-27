Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B3D1CD2B
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504965; cv=none; b=LskjgQ/bDuWa8fb3VOmxm+zYJBszF//GuF3d29aCkHeDMatuesJiadsQLg5dXrLbJqQVh+n8DdwN5DRxxPC+dxZh4gktVgsR3TgQJUlvC5d7obt6ecUGvxtbhu6zb7fzDLja9e4Mq/RsoOFq2VoK7bL/q3i/OhzjjFw3nnUzgs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504965; c=relaxed/simple;
	bh=Vr9g8+UlCUdelrwMZTb1tWVwHD7Y+FtA3gq5aVVMih8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UF+2f9CMoYJLp2GAlcbQpcnAyaIR3s2v8FOM2v3iXNBGDBUxAjCDvit9sRLSKJ8Pnrnr1vKF5ddN5oZJsmn4qP1GMHKV5gESCOcVP6Vkp8H9zB3DizB7hJtaFAayhOq4lawBo2mBtYgmWT/yH+vOkj+lvZluCglHkfuD6HfL7os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXkh2fgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXkh2fgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9A3C433F1;
	Wed, 27 Mar 2024 02:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504965;
	bh=Vr9g8+UlCUdelrwMZTb1tWVwHD7Y+FtA3gq5aVVMih8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eXkh2fggNBhMblZclxDxfjNzXagaoSp8l3HkWIhYsO+tHlEIKY6IG2oKtkU7VJBXV
	 rRDF48xp1qYh8k+WDMsBAxf9Ky9VPtuDBvsvtbezYS2zXidz5qmy9wXoN/xW8q2wHl
	 CCAS/Mk6V6lO28N4J6WAY1AQ2UvxdfVrd/0eMgeenoEmkiprnLcgCe9LJxN+6Kn7K8
	 2HwE8TErIDcvkLBIsLYPnu4zHa0Ds9HUB8p7nK3XJPVQxizSSx7dtaeK8RG5JA2f9e
	 Na2vQi69sZTtDBhkh8hdL9cODPCQeepvXbwLVe0TFjtTVsRF4Mv0DOCENEH9BjwiXc
	 DRfwhMC1fGtNQ==
Date: Tue, 26 Mar 2024 19:02:44 -0700
Subject: [PATCH 6/7] xfs: flag empty xattr leaf blocks for optimization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382770.3217666.7502083761570659679.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
References: <171150382650.3217666.5736938027118830430.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ba06be86ac7d4..696971204b876 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -420,6 +420,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d654c125feb4d..de291e3b77dd8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

