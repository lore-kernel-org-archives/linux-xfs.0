Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5735D17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481416; cv=none; b=ephPw1OCSfYElxIMy6t3hFRIP6Gz8FkrYeSmHKyS8n2lLLroHxHKXg28fQObuFcDOXg/Ey1fZqGqBUVaFYYyRW4V6AGPQef+gR+jjYzzywk9oaJhi7vlrdubWrEkz8Bc6fK1A4O8PpZP6c1ETnM4wG32joih+GUjwrkjHR4xHNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481416; c=relaxed/simple;
	bh=q2mjVVO9RhrRhvlgEwLGwSlI5NEiZrOCsJBvRgDpr1o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j3EqrhUBPdjFIPyQtJ6UO+8DPz0HNANSJn81QiXGAuyrizQi6PxxVSSoh3xV97LDOw3fN1rANd5Fv6AaEQzn+bMgIg2soBrsSYLtaNqG70jh318MYngmG4XwHuT9F9mLaY7ogafIHewP2mOhtkzY+Ht4bJDyAAWqSFrYW70vyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L5JverHt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L5JverHt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=g/fj3jy8+ER9HT70acDD7+o7o55GjEr4z2n5TBRRayE=; b=L5JverHt/YhmfwiWISnWnFyMo+
	6feTnL8JxxSN4jQIfIW3nGcoIiP20jbvAVmA9cQTqS/bMxbTbEVSehDdJSSsDViSyMlXDFV0CGRYD
	W8XIZb25IKv4uy3rurvUZdTMsHdiPfZZB7gn+fcGbpIYonVNpHXIVI62CVymvHKerZsUyWofSzzXx
	5olKo37Y5YPXbc4bzxi9b0ypSNIUPn5l721lW/Fo3kc5dQsQg/wu6CrqOudcI2NS0KvchcNK2aD95
	qWMuzykiJKxENHgb4JD+q974SO0O2KnsDFqXzfcdBcgtkUSDMhKVyo9erYEt8eXJ1bk9+7MNIfFNB
	XwF6j65A==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mw2-00000006Nps-14lR;
	Tue, 30 Apr 2024 12:50:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 15/16] xfs: move the block format conversion out of line in xfs_dir2_sf_addname
Date: Tue, 30 Apr 2024 14:49:25 +0200
Message-Id: <20240430124926.1775355-16-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Move the code to convert to the block format and add the entry to the end
of xfs_dir2_sf_addname instead of the current very hard to read compound
statement in the middle of the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 02aa176348a795..0598465357cc3a 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -426,26 +426,16 @@ xfs_dir2_sf_addname(
 	}
 
 	new_isize = (int)dp->i_disk_size + incr_isize;
+
 	/*
-	 * Won't fit as shortform any more (due to size),
-	 * or the pick routine says it won't (due to offset values).
+	 * Too large to fit into the inode fork or too large offset?
 	 */
-	if (new_isize > xfs_inode_data_fork_size(dp) ||
-	    (pick =
-	     xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset)) == 0) {
-		/*
-		 * Just checking or no space reservation, it doesn't fit.
-		 */
-		if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
-			return -ENOSPC;
-		/*
-		 * Convert to block form then add the name.
-		 */
-		error = xfs_dir2_sf_to_block(args);
-		if (error)
-			return error;
-		return xfs_dir2_block_addname(args);
-	}
+	if (new_isize > xfs_inode_data_fork_size(dp))
+		goto convert;
+	pick = xfs_dir2_sf_addname_pick(args, objchange, &sfep, &offset);
+	if (pick == 0)
+		goto convert;
+
 	/*
 	 * Just checking, it fits.
 	 */
@@ -479,6 +469,17 @@ xfs_dir2_sf_addname(
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	return 0;
+
+convert:
+	/*
+	 * Just checking or no space reservation, it doesn't fit.
+	 */
+	if ((args->op_flags & XFS_DA_OP_JUSTCHECK) || args->total == 0)
+		return -ENOSPC;
+	error = xfs_dir2_sf_to_block(args);
+	if (error)
+		return error;
+	return xfs_dir2_block_addname(args);
 }
 
 /*
-- 
2.39.2

