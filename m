Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5E321345
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052449; cv=none; b=Ssy6wk69w46qDXbH8XYbdC9rHsTK6gFbHwfx83PjrpJNtTdPnRwvBi8Z8lh72NIrVU8B5NLLPpJSvMuyuc7rDclJv+UeoD5STGI+lrXq31L5LjmX0UrXbSaeP5FQVLKzkhuacUSdl/uivviI+g6VXMVwX0mPluLMoz4IEa3y8nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052449; c=relaxed/simple;
	bh=pV8fFmCMivF1zg9j4Zb+3ol0TNfWjh7j70ntXWghIDM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OUD/56xEFhkduc881F07qUCWW8OJMRzEHab2QgneMriNVha3cET4g50R0Duhah/U6OOsKk936ZxmUpU9CvKCUIdPOsFwe0Ao4Vp5co0O7BTYv5t0+Gdv/Le6oCZd9+HMFrKzOAsX9PsLldqmp8b72u3C5IhYcl/+xyByGY5uw5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZHQ8ypU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZHQ8ypU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A685EC4CECE;
	Fri, 13 Dec 2024 01:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052449;
	bh=pV8fFmCMivF1zg9j4Zb+3ol0TNfWjh7j70ntXWghIDM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SZHQ8ypUUsODAomg7J48YY0fOkgVg9ooYTWLrFmD8s3CUi0kXoNgeeIITA3B650+G
	 Gj5q20YUL0UvcNCHb2Ut/R46Ndcov2t3lBUuZPTq3T0UhDdVyRLyvRdLJo+spflElM
	 86ab17n75B2KPHo60N14J7H9gwhOBQ3tZh2ULEaWU/goSZbDuo9oMszUTNnvT+FyJB
	 aACyLxu6ZzQP8mLUatWsCJkqm2G4PjzYNQjyhDGrJgPHwh9D2xxYApLa9CEUsgBquw
	 1JiQrVg/Tu+3NXkvdTmbcHinQMoTNV/ialXnkGaXdrJi9Do7dsqrqIITpf0Oa5DiKX
	 D75cUooc+gdTg==
Date: Thu, 12 Dec 2024 17:14:09 -0800
Subject: [PATCH 15/43] xfs: create routine to allocate and initialize a
 realtime refcount btree inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124825.1182620.2612165173359034874.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

