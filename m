Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702F5234
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346674; cv=none; b=cw3Zv0NW9gOkuw/+2P6N7/M+DOU41aiSXMEfh/zAYs7WVefy/VyO1ZqyL6q2nTsaZkBnwMtoy5VOYkC0QTimSPzPop9FKjr9L2o9bNaJHvkiPusTx2a0NWEX3/b30FIDrzzZX1bgl0YpB/+CcDu/znirITLIKU+EMuPVSWvE3ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346674; c=relaxed/simple;
	bh=8ebfW1+GRhbGRalIoutrEGI547ktlircw+e1Uz7JOOk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bQ/R67xfZDGVkBEh7sCTLushq0VZPGDG2lYYBcwTp6JkTM11m6NJYAsv6TsOMYE/tXvwGjVqbKQQuLSuOnYYsyj34AGQ0VpNVeggNTpnhXTbvsRcl+BqUmaykssEdtpFYZiegKmeHpXGHi3xVOxVTaO+Jv2vG5tZRT/mlfOE1mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aATIuBEp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aATIuBEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769F0C2BD11;
	Wed, 22 May 2024 02:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346674;
	bh=8ebfW1+GRhbGRalIoutrEGI547ktlircw+e1Uz7JOOk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aATIuBEpSSeM6LUOxNA1FKiksz1G8Nb8O+nIRD2qMuXG3obsEyH6l7J+wSEcsFmv1
	 wz3OX+CIjycGN8v4gwO3OogKHbo9Q2RXpyfAMeE1lcITnWasMSlupq9O3XobkojfIq
	 A+nmAFhMlpslhRcwVz+iUCoj3NvCobaZANFClFyTrWubJpRtbfEhFH2xT6aO0LzDI3
	 npaHkFZPKLn52tROd0Dp3h0BeuWl7BhDNGxbgwPKJUxajUTuAKY/FAy/EDQ9hB+wUh
	 wWFOnODm9dee8O3/5trhJb0FtR6GLTiA2xiAY5RHc7at9EiHMWPoVS3Mdtg4umxDqY
	 jpmucHGvbXW0g==
Date: Tue, 21 May 2024 19:57:54 -0700
Subject: [PATCH 035/111] xfs: turn the allocbt cursor active field into a
 btree flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532237.2478931.7259670424217538622.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b20775ed644af0cbaee9632ad63ae6ec5ee502cc

Add a new XFS_BTREE_ALLOCBT_ACTIVE flag to replace the active field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c       |   13 ++++++++-----
 libxfs/xfs_alloc_btree.c |    1 -
 libxfs/xfs_btree.h       |    6 +++---
 3 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 458436166..e5ae53948 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -161,7 +161,10 @@ xfs_alloc_lookup(
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
 
@@ -210,7 +213,7 @@ static inline bool
 xfs_alloc_cur_active(
 	struct xfs_btree_cur	*cur)
 {
-	return cur && cur->bc_ag.abt.active;
+	return cur && (cur->bc_flags & XFS_BTREE_ALLOCBT_ACTIVE);
 }
 
 /*
@@ -988,7 +991,7 @@ xfs_alloc_cur_check(
 		deactivate = true;
 out:
 	if (deactivate)
-		cur->bc_ag.abt.active = false;
+		cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
 	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
 				  *new);
 	return 0;
@@ -1363,7 +1366,7 @@ xfs_alloc_walk_iter(
 		if (error)
 			return error;
 		if (i == 0)
-			cur->bc_ag.abt.active = false;
+			cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
 
 		if (count > 0)
 			count--;
@@ -1477,7 +1480,7 @@ xfs_alloc_ag_vextent_locality(
 		if (error)
 			return error;
 		if (i) {
-			acur->cnt->bc_ag.abt.active = true;
+			acur->cnt->bc_flags |= XFS_BTREE_ALLOCBT_ACTIVE;
 			fbcur = acur->cnt;
 			fbinc = false;
 		}
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index d3ecd513d..e3c2f90eb 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -521,7 +521,6 @@ xfs_allocbt_init_common(
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
-	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 17a0324a3..b36530e56 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
 

