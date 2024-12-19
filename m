Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C53E19884C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637017; cv=none; b=GUQo+VBb/Fz5gGwUlXvqeqj6Ocb+0Qi5FxJC4933J4vmohr1sRBGRtt0WtVA+ewyN8PnHD1KOBh7eFQPE5BJnU1RQpAKjqdn0yCP/x/DlaoV22nzbQwYKTlJ7OdNzYeZa7NDNJS05q9JqoMbEd+RLM6lBlD6vQxkdv7z8vEvK68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637017; c=relaxed/simple;
	bh=MWUsJf5LAwVnADKP8zAqai6EORpjE/kmaFcm+GMTHOw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zr19pUjPiAZ6loIdSSNHedR9fbpXlrrn2r/0L8U0EbA/yDGvOMlqg8KASXdNKiHbHgb6yzwytqW+iItR3A2PsiTOih2HRsvEVSfdX568X67+T6BREu6WlYjwq3YEnF5Iz1lzV18x58LhVFm8wIaVgmv0JPLr0KGJyjVR30KybUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i13pWUG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i13pWUG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D9DC4CECE;
	Thu, 19 Dec 2024 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637017;
	bh=MWUsJf5LAwVnADKP8zAqai6EORpjE/kmaFcm+GMTHOw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i13pWUG5z5xtzxR0QzvdwqkCG9RVYklO3MfoPS4jocy9wN1OLkQUZHwsbr9xUwM4N
	 A+qDVynTdr/eItK/7rB1pnan6LoEm3IJDd9bsUMD68zy334BIn0ANa7KKexSDoBuuV
	 33lzdKgld2XVnHMjAVMGnuDZWb3u/MowyxlhvpSmOfCTvolf3olkObOR04w4cyNyEw
	 67JJkyyAKtwgug0dorgkmJgk1SRV9siTTzEIaTb7TsCrpm+OdEZ+sZpRZ8HjabuXL2
	 T3Q/x1LeetKq2REiSD2+1PO92XIV5lnC59xXo5G+YabPQ6MVXmgbYqXvtR+TXbo9G2
	 prTiQ3xnK5Row==
Date: Thu, 19 Dec 2024 11:36:56 -0800
Subject: [PATCH 15/43] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581236.1572761.8380322015327920196.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a library routine to allocate and initialize an empty realtime
refcountbt inode.  We'll use this for growfs, mkfs, and repair.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c          |    2 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |    3 +++
 3 files changed, 33 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index d5ecc2f6c5c202..eab655a4a9ef5c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -34,6 +34,7 @@
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 
 /* Find the first usable fsblock in this rtgroup. */
 static inline uint32_t
@@ -382,6 +383,7 @@ static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
 		.fmt_mask	= 1U << XFS_DINODE_FMT_META_BTREE,
 		/* same comment about growfs and rmap inodes applies here */
 		.enabled	= xfs_has_reflink,
+		.create		= xfs_rtrefcountbt_create,
 	},
 };
 
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index 6a5bc7ea42fbe6..151fb1ef7db126 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -721,3 +721,31 @@ xfs_iflush_rtrefcount(
 			ifp->if_broot_bytes, dfp,
 			XFS_DFORK_SIZE(dip, ip->i_mount, XFS_DATA_FORK));
 }
+
+/*
+ * Create a realtime refcount btree inode.
+ */
+int
+xfs_rtrefcountbt_create(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_inode	*ip,
+	struct xfs_trans	*tp,
+	bool			init)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_btree_block	*broot;
+
+	ifp->if_format = XFS_DINODE_FMT_META_BTREE;
+	ASSERT(ifp->if_broot_bytes == 0);
+	ASSERT(ifp->if_bytes == 0);
+
+	/* Initialize the empty incore btree root. */
+	broot = xfs_broot_realloc(ifp,
+			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
+	if (broot)
+		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
+				ip->i_ino);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.h b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
index e558a10c4744ad..a99b7a8aec8659 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.h
@@ -183,4 +183,7 @@ void xfs_rtrefcountbt_to_disk(struct xfs_mount *mp,
 		struct xfs_rtrefcount_root *dblock, int dblocklen);
 void xfs_iflush_rtrefcount(struct xfs_inode *ip, struct xfs_dinode *dip);
 
+int xfs_rtrefcountbt_create(struct xfs_rtgroup *rtg, struct xfs_inode *ip,
+		struct xfs_trans *tp, bool init);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */

