Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77085129A79
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424253; cv=none; b=iao/fVzcmrP1gfMlooDFVGd2BJAMo+/SIDBSmtWMMZ/O6BQa93vbyMODXZafYt0KTAy06D9IrKIhefPJ/T1VXXWY5Si+w5FoJAUbC6MiUxc9w/4KKtgJ1A/57D9oWVZtD53KmudkUM5ulkqWafm2JxQhQcFLYhgyJFFe6C9qgrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424253; c=relaxed/simple;
	bh=PwyWYBkvzMFVd5RBFrfJ/NFldgg3FueMInwYNqckWSc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SaI8znnP8uycWPxDjI7CIUlLCLqV/GN8x7mfWTxgGrFhMUICbfGDjHDr4qBb0rBnH8C6haaGKbidXfqvp3iajZEJc7+UcODJ/iLMBC+3sl0c8QCBufig3khKbLM/deLcEyqdXyjPgsYNtbj0HVgtHube+9Cw2ToQb73vHlFn/SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAx9TY9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAx9TY9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B68C433C7;
	Tue, 26 Mar 2024 03:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424253;
	bh=PwyWYBkvzMFVd5RBFrfJ/NFldgg3FueMInwYNqckWSc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sAx9TY9GoDEcyOSNf/23rifLZqbgxni7Ga3Yv4Enw2/L3iV1+TbFbYhrc1uqYRsiK
	 HDfaR0ljWRWHUSPq2qdVecExpT2/44atEiPzzxFzq5VC8oD9OMIkaikFIW6fyUYkF3
	 2FhehTZXIOwl9mipYjAzXljGRDfRqpo/059WWaEpXCsiAWGH6700T42XvDb2tiCPEq
	 +UFRU4iR1ctFByAUp1dNRp7W1Zr/4ApTRCeX7Z4tOnGSMpIDXAFddarBU64VQcHI6K
	 59Cz0Vw9Q215KcCSM21gATCn9AXCpfAVxgHcgNSaIGVUQwuth+mAo9fLZineaoEwWN
	 0FrQld+oKikeg==
Date: Mon, 25 Mar 2024 20:37:32 -0700
Subject: [PATCH 035/110] xfs: turn the allocbt cursor active field into a
 btree flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131889.2215168.13460745794958153348.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 45843616647d..e5ae5394893a 100644
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
index d3ecd513d276..e3c2f90eb57a 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -521,7 +521,6 @@ xfs_allocbt_init_common(
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
-	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 17a0324a304e..b36530e56df9 100644
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
 

