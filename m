Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288D813CABC
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 04:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725337726; cv=none; b=PIdz75zWhSqZgdx7JzB8zHoqGDoi3Ish6f+UPuQcZgKwvcZD9jnRIKNqPwcWvukkl0AnNe8Ib6O1Gq9FVcl04lC9wSVP6YE0flkHD+fi/nk9Yb4OI9TIuESU5yrqCVcDCswXA1Kbxl0aLK8nWUH1sOdeXVd1jkEw7JuUUmHMXMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725337726; c=relaxed/simple;
	bh=6KMaVTjJyogOQdP2Bs9Sm1bSt3HrscVJE0noZhnLsqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=asrvGdfKRIYDoLFF9PIiy16d7gYmSHXqXwWIXdxLgSIjHAYIEUlLW84AGL3EiEywqxDDsOUfHcxPgnzLx3Oy7rmpb6Ya/EMPLsWQR6cKsMAVbU1fhqwVK/2Wxbvxht1eg8x0Z2+8EZPo72wU36Fd9InMWDq6R5xkoF0XREH+kWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qBig6KRf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qBig6KRf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=X2JxuptafFSuN+SsF4DTRdc66diz6g8+LTcqNlja3iw=; b=qBig6KRfyr2vJzBweKyiypu+Em
	Lqq7F3aHeLzpyV8NeEDLwJkxXCaFvc3w1tvPtr7U7YIEzkB6JesBx24Tsdud4oDnBwXfAgNL++hk5
	UbuY4bNPpuPYRSn+JL5j1tcfo5eJ+4Zzfh3jHACZ7R6fWyKyh632+36jQyfF6KWuK3Z4/yJ7X7Zpo
	Fnj3RPBzEETKex2K0yY/j4xpzP8uSN8a4SglB5WCrOnhRoBvP+m1Vi5BNqs63Wag6NJtxhRWgXEoq
	UAi1ez1vd2pk+y/S0Wp9tzQHutey46j/6CiaM3UenFhhaHYTOC/ZQMAqsL9jgLoy8B0CEVWNc86gs
	z1g7t76g==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slL9n-0000000GI7z-4Bdr;
	Tue, 03 Sep 2024 04:28:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
Date: Tue,  3 Sep 2024 07:27:46 +0300
Message-ID: <20240903042825.2700365-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240903042825.2700365-1-hch@lst.de>
References: <20240903042825.2700365-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just like xfs_attr3_leaf_split, xfs_attr_node_try_addname can return
-ENOSPC both for an actual failure to allocate a disk block, but also
to signal the caller to convert the format of the attr fork.  Use magic
1 to ask for the conversion here as well.

Note that unlike the similar issue in xfs_attr3_leaf_split, this one was
only found by code review.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0bf4f718be462f..c63da14eee0432 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -597,7 +597,7 @@ xfs_attr_node_addname(
 		return error;
 
 	error = xfs_attr_node_try_addname(attr);
-	if (error == -ENOSPC) {
+	if (error == 1) {
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
@@ -1386,9 +1386,12 @@ xfs_attr_node_addname_find_attr(
 /*
  * Add a name to a Btree-format attribute list.
  *
- * This will involve walking down the Btree, and may involve splitting
- * leaf nodes and even splitting intermediate nodes up to and including
- * the root node (a special case of an intermediate node).
+ * This will involve walking down the Btree, and may involve splitting leaf
+ * nodes and even splitting intermediate nodes up to and including the root
+ * node (a special case of an intermediate node).
+ *
+ * If the tree was still in single leaf format and needs to converted to
+ * real node format return 1 and let the caller handle that.
  */
 static int
 xfs_attr_node_try_addname(
@@ -1410,7 +1413,7 @@ xfs_attr_node_try_addname(
 			 * out-of-line values so it looked like it *might*
 			 * have been a b-tree. Let the caller deal with this.
 			 */
-			error = -ENOSPC;
+			error = 1;
 			goto out;
 		}
 
-- 
2.45.2

