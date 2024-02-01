Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDC84FCF
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816522; cv=none; b=n29vq3CxZ4Ufn7OwVROhDlHiVtQS6boR/KMNqQLi0JyLbXHVKUWJJwDDIbqUNkL2dy0KA0EjZFFV0KbuJW+K2H8FuFvCN/nVO0gKsk998ly9gsgVQhIHewGzW93d1+vmGUkRcHtvTdLvJzUFCzyFEhO0Uji4cGnw2s52X+v00+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816522; c=relaxed/simple;
	bh=qh5WY0WsdIZNq/k/WReMEDVhEzAredem7t2tpiA0ueI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NZ1JMgpOrwtzyz55zXx55Cj9MwNcHhfTQnnqUzryGBUYMg0dukw9XlUvKuwRr1+ouGEGGloSiPFlOtV3AE0+Cx+euj9P7b0+E98AJ5lVvt1Y7Gk8NvASBFWdg4T7z1H+0VyWrnjsbrAgzDxyMgNLRC5UTqhlrX2dt0HLY0OynuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmFzJysY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmFzJysY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E120C433F1;
	Thu,  1 Feb 2024 19:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816521;
	bh=qh5WY0WsdIZNq/k/WReMEDVhEzAredem7t2tpiA0ueI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JmFzJysY9K6F/9lFTMyQK9sxaY3jpKrnTRSWFc9jqVuuf3omY3pBsezWomF4xXv0q
	 vDxF2tTsfCCL+NZ1HUa0OSE4Y81xDLMt/nSOpWful86cgPlCr+IKUhkvAQWdnuWDDB
	 HdTIqyzpoZcv0ODRcs2fIzOYT08F5RrqxkVnand1kwbgUL4glK0sPPRR1GufzU2+RJ
	 z554ABDZ5IA5G9XPQdnAYjyeTNFtqOGjokvMOHPzJNRHWQGFD8wFwiE6AzVIk5NDAr
	 14fC8jzoKuw3LP2GUzhbPE5kvnQXhxDolYZh3n0NhL9Lz9PeK4GEuo46K9Wsh8Lfn6
	 XanJOj7IiwDkg==
Date: Thu, 01 Feb 2024 11:42:01 -0800
Subject: [PATCH 09/23] xfs: turn the allocbt cursor active field into a btree
 flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334085.1604831.17121982282621268410.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

Add a new XFS_BTREE_ALLOCBT_ACTIVE flag to replace the active field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c       |   13 ++++++++-----
 fs/xfs/libxfs/xfs_alloc_btree.c |    1 -
 fs/xfs/libxfs/xfs_btree.h       |    6 +++---
 3 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a40a5e43e94c8..91553a54dc30a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -165,7 +165,10 @@ xfs_alloc_lookup(
 	cur->bc_rec.a.ar_startblock = bno;
 	cur->bc_rec.a.ar_blockcount = len;
 	error = xfs_btree_lookup(cur, dir, stat);
-	cur->bc_ag.abt.active = (*stat == 1);
+	if (*stat == 1)
+		cur->bc_flags |= XFS_BTREE_ALLOCBT_ACTIVE;
+	else
+		cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
 	return error;
 }
 
@@ -214,7 +217,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_ag.abt.active;
+	return cur && (cur->bc_flags & XFS_BTREE_ALLOCBT_ACTIVE);
 }
 
 /*
@@ -992,7 +995,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_ag.abt.active = false;
+		cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1367,7 +1370,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_ag.abt.active = false;
+			cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
 
 		if (count > 0)
 			count--;
@@ -1481,7 +1484,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_ag.abt.active = true;
+			acur->cnt->bc_flags |= XFS_BTREE_ALLOCBT_ACTIVE;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 0ed1477187bca..91485b642471d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -523,7 +523,6 @@ xfs_allocbt_init_common(
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
-	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index a0daccf765c83..1e660ef3b4f4f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -236,9 +236,6 @@ struct xfs_btree_cur_ag {
 			unsigned int	nr_ops;	/* # record updates */
 			unsigned int	shape_changes;	/* # of extent splits */
 		} refc;
-		struct {
-			bool		active;	/* allocation cursor state */
-		} abt;
 	};
 };
 
@@ -321,6 +318,9 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
 /* For extent swap, ignore owner check in verifier (only for bmbt btrees) */
 #define	XFS_BTREE_BMBT_INVALID_OWNER	(1U << 2)
 
+/* Cursor is active (only for allocbt btrees) */
+#define	XFS_BTREE_ALLOCBT_ACTIVE	(1U << 3)
+
 #define	XFS_BTREE_NOERROR	0
 #define	XFS_BTREE_ERROR		1
 

