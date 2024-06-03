Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80748130492
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441271; cv=none; b=bz4m0/1NT3KQTikNfzQpeofgEFQKAktJYM8MLUx0yzKrVOAPqZqC8EmW/a0/C2hA5mu1OFbEUwUfPz+JP1ShHL5DI0zns11tKpI/r2YS4UxVwcwiHQIMdAmm1lKzEHF30DoLlfUrSKmLioDVlHTE5W2GVdcPcmV800bI56ZQNJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441271; c=relaxed/simple;
	bh=iMuuvnkiXaySoKLVpMhWD8IZG/aWoP+JRQt3KnEjUcI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nO+TbLXRa/1NDA5W1RdDARbI4t6lmtbCqCSEXta3DZzPFOaeqdviEuZwy9h0FpPTVl6LEWy9o7XwHVFliMag6GKEte1JTwAW1tUcvoEnItDlDkBt7BetTnUwf7x92N/7HyO3wefb9ntZ3lUzryJEEIFC+WXQ5F4gopzkFPUxxVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bNrZKezr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bNrZKezr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CADC2BD10;
	Mon,  3 Jun 2024 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441271;
	bh=iMuuvnkiXaySoKLVpMhWD8IZG/aWoP+JRQt3KnEjUcI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bNrZKezrfip23hs0698Qro8Uv1Cqnb6KJODBPwfh2q/V2dh5F0f9DKy9aK1DVK4UE
	 pwhwkryp+fSnfLfOpOhpcDRl5BMSpD554yCp2pGIKwqLtFEzxnstALjM8uXKhylWEN
	 srhpW02xt8a6gxnStabV2/u0JVMZzapRc8bfnhWcSs+4EA3xJjnE3ILuLTofDV6i3g
	 Suypz8oW5CFbqc8BHs1pL1wfzexz1eBx5xrPPYTgenyW4pmnVHP1sgR6hiZT7Ptkzb
	 vXF56m3dhclDLNgNQhHw3HqoNyrtFIQpyNEsd9cUJ9wwlcn4h0pwau4srTxE7i3C0x
	 3aIhkmHAdKfww==
Date: Mon, 03 Jun 2024 12:01:10 -0700
Subject: [PATCH 035/111] xfs: turn the allocbt cursor active field into a
 btree flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039897.1443973.8475024990762526204.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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
 

