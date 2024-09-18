Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82691136326
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 05:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726637494; cv=none; b=Qk0Cb4AV4awQ4cW647CcDoSIybXSgCTBe9Z0zFrVeZJlktxjVB7uUquOazOc4LSGuizBXcCaIYGwyx6Fn5s1ROO41v4yE/acMNUmtl4WNWTDL7YlzIQD5+d/tG4ujhJ8l0dZeFmYvqPwF6+Z99/bU96eqGy3N2c9ExI9SLYuAKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726637494; c=relaxed/simple;
	bh=0wysRAkcnDnL9mf2CjbYMzDRrG1xaX54YhmCJrgO+Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5oftCaoGL+C89M4AKFxTaLQ3xTpKP/8lXXe1V6ex8X0N5XIrLhF2jb7ySKS6xK4DDmPqfaWROJg73HDwjfYrbESt1kV36L5leBEZZzn2HE7jCA56Bq/xClJipnqwF0kIstW78Ut6PBqBBF8+mAmQ9AjAfUZQ+jTlP3FxGsU0kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=orLWAcMF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="orLWAcMF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kNHFgzqDljHpmJmrdeLy5yL/3tFp+tkTwqz+drOvwEU=; b=orLWAcMF0U/x0dWYp3dzShiC/X
	dT3xwEr6dswXlUefyCk+o/YvFA1m3Dfrfzu654seR04+g3gWLPnFJns8lb4Dz2zfkrkX4D31J9kc+
	Wf8JY6wsU4iqAw7KrV+Z5AkeC5b8MaCmgv1DA5w9uUhSqPujMUneCY5HVwxP7nfE+TPDMaLLzSjCe
	GRwWyYf5K72vb5Cs1pdapYNKqxTONtsGcALEcyyUzO9qfQDO9pjOywg+zlX1VjK9x9stgljgIh/6t
	xLw7REAT/TE7gmphX+Nam0YXZW2/8xkP7gMyVEkwyiiA69VuAbFrRiMSv+WrkFPk9Gw6E4k6aIvdf
	4wotZWcg==;
Received: from [62.218.44.93] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sqnHo-00000007Tkg-1LSU;
	Wed, 18 Sep 2024 05:31:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
Date: Wed, 18 Sep 2024 07:30:05 +0200
Message-ID: <20240918053117.774001-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240918053117.774001-1-hch@lst.de>
References: <20240918053117.774001-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_attr3_leaf_split propagates the need for an extra btree split as
-ENOSPC to it's only caller, but the same return value can also be
returned from xfs_da_grow_inode when it fails to find free space.

Distinguish the two cases by returning 1 for the extra split case instead
of overloading -ENOSPC.

This can be triggered relatively easily with the pending realtime group
support and a file system with a lot of small zones that use metadata
space on the main device.  In this case every about 5-10th run of
xfs/538 runs into the following assert:

	ASSERT(oldblk->magic == XFS_ATTR_LEAF_MAGIC);

in xfs_attr3_leaf_split caused by an allocation failure.  Note that
the allocation failure is caused by another bug that will be fixed
subsequently, but this commit at least sorts out the error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 ++++-
 fs/xfs/libxfs/xfs_da_btree.c  | 5 +++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8f69ce89da247e..f95f5502084dd7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1334,6 +1334,9 @@ xfs_attr3_leaf_create(
 
 /*
  * Split the leaf node, rebalance, then add the new entry.
+ *
+ * Returns 0 if the entry was added, 1 if a further split is needed or a
+ * negative error number otherwise.
  */
 int
 xfs_attr3_leaf_split(
@@ -1390,7 +1393,7 @@ xfs_attr3_leaf_split(
 	oldblk->hashval = xfs_attr_leaf_lasthash(oldblk->bp, NULL);
 	newblk->hashval = xfs_attr_leaf_lasthash(newblk->bp, NULL);
 	if (!added)
-		return -ENOSPC;
+		return 1;
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 16a529a8878083..17d9e6154f1978 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -593,9 +593,8 @@ xfs_da3_split(
 		switch (oldblk->magic) {
 		case XFS_ATTR_LEAF_MAGIC:
 			error = xfs_attr3_leaf_split(state, oldblk, newblk);
-			if ((error != 0) && (error != -ENOSPC)) {
+			if (error < 0)
 				return error;	/* GROT: attr is inconsistent */
-			}
 			if (!error) {
 				addblk = newblk;
 				break;
@@ -617,6 +616,8 @@ xfs_da3_split(
 				error = xfs_attr3_leaf_split(state, newblk,
 							    &state->extrablk);
 			}
+			if (error == 1)
+				return -ENOSPC;
 			if (error)
 				return error;	/* GROT: attr inconsistent */
 			addblk = newblk;
-- 
2.45.2

