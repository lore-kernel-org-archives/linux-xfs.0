Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BAC139E
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346815; cv=none; b=pGazG/YHU0BEuWkdcMQ38k4AVTm8OqBP1Un7x8Y1b5mx8P/G9y3nA2WoMVKJyjrJ1sGLPiA7es+73DNklt/hfIQDkdiUjg6udUezzcaRzE64UtLmgVSOkKbcynq3GVyhLntImC8JxiP2wHQE8jeq0wfRDImpaXlmnfO+bhiqIaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346815; c=relaxed/simple;
	bh=0CK7u2HmLFFAb9yvlEk4ihTXYTh7vehGuzVcLpbkTm8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bDdOqCCMow4n1pr2kC9eTN55/8oiQJFBCkmwP/GJyOZa9ltuDvjEAjg2J6pxlTZttlLB7dBd73gpMcYESMgos0DVaLWL5wCu8+iwMzOA/cwB3ndatSqBX44w9FFnMm37T05M9c8LJHj6DbTdd2ECCNBJr8tJ47foZW0L3XKLzHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaO1OG75; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaO1OG75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809BAC2BD11;
	Wed, 22 May 2024 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346815;
	bh=0CK7u2HmLFFAb9yvlEk4ihTXYTh7vehGuzVcLpbkTm8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iaO1OG75Jjgh2WTV4fpkzUaf7/ARfl7pHCDw7OltG+Wgu4rxHAPqg0vPWVus6aLKx
	 +pL4UDkc5FnmTNhjDOk16YzObFGHRrvAkzBWDhJgoxJ3w8/EAyQSp0UzTBdXI37khC
	 kqcYw6uNYoyw5wg6tG3MUh8uzD3kq1HeP/IKy1GF6S/4UzgOAl/ZuNYHWfVVlfW/44
	 g/UpoKyP//htb67l/4yAmgUzFwC4HxH3EvGtgFBEb8zQfgcTR1UgYxqOqv9LxmS0DK
	 jHI1DA+BwTO/GZLdbm47eD7Hmn1IL8yNLE9G7MxN4mhpG4HC/tQ5dwq6cYbIbYcv2u
	 xZy+QphMHlIlw==
Date: Tue, 21 May 2024 20:00:15 -0700
Subject: [PATCH 044/111] xfs: factor out a xfs_btree_owner helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532370.2478931.770233372423142680.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2054cf051698d30cc9479678c2b807a364248f38

Split out a helper to calculate the owner for a given btree instead of
duplicating the logic in two places.  While we're at it, make the
bc_ag/bc_ino switch logic depend on the correct geometry flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: break this up into two patches for the owner check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 150f8ac23..dab571222 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1219,6 +1219,15 @@ xfs_btree_init_buf(
 	bp->b_ops = ops->buf_ops;
 }
 
+static inline __u64
+xfs_btree_owner(
+	struct xfs_btree_cur    *cur)
+{
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		return cur->bc_ino.ip->i_ino;
+	return cur->bc_ag.pag->pag_agno;
+}
+
 void
 xfs_btree_init_block_cur(
 	struct xfs_btree_cur	*cur,
@@ -1226,20 +1235,8 @@ xfs_btree_init_block_cur(
 	int			level,
 	int			numrecs)
 {
-	__u64			owner;
-
-	/*
-	 * we can pull the owner from the cursor right now as the different
-	 * owners align directly with the pointer size of the btree. This may
-	 * change in future, but is safe for current users of the generic btree
-	 * code.
-	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
-		owner = cur->bc_ino.ip->i_ino;
-	else
-		owner = cur->bc_ag.pag->pag_agno;
-
-	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs,
+			xfs_btree_owner(cur));
 }
 
 /*

