Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348141DD0D2
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844952; cv=none; b=m/P846nv3SLP2SJcqlk4WPLrew9+N7JQz+Hj/aBAWK4As4cmCPYMAonDtLt4marRzuwQr+exEFhP8nx/XeY/rQR/QY/+VXYK4TuV6SC+8CO66bDF2CyUaeJEp2rmjP7+juG/9QSH3uFbTVCAGodeopBPLzBNZKyNw4SjRpFPL2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844952; c=relaxed/simple;
	bh=U0LQDbiSEjftj2FCRJzHtp6pnD88HBSP6PywAi5Whrg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvaB5QSOgLRyQBjOwOYgDKSkBZBcxyZIwKCP4Yer8NHbYmMzup88/9IfuTmm+UgWNxL+wzjhXCGN9Hvu8GGBlt7T2EPrp3GKkL7rJuwCL9R/9+5lvbwF/bKFZ4r/A9z3gcCpcI9GiLd6EBLNGX6T4Kfrw9/1OwVVr4dVMsyPDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R74X79lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R74X79lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6D4C4CECF;
	Tue,  5 Nov 2024 22:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844951;
	bh=U0LQDbiSEjftj2FCRJzHtp6pnD88HBSP6PywAi5Whrg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R74X79lTtlL+EsM0PPk7nvAgCddlZoV3gSh7eGkVDGGgitwzcIlA7vMwUuz7+WVVR
	 novE0jXCt2kqJ/653Nk/sR5LtQCXzwzBDnuNr5SkoYryeM+0Y9hEBPThSIOxC6giDV
	 JENwSkcaMRKYrQFa5NcL+l0r2UIoT7u2WMHeUiDtvON2f14qfqwnkbWREgJI4eKT/J
	 is+z2vOU+ztvH1uGZN4+Uze0wEWutFvo5sYKPHS37zpKYhYu6ayFtXrLWunEuFx0YP
	 qHGbkisy2gM8AuJla3xEQVKuj1Pu0KA6Llm80vhEqQvpfKHcpwhCHjyZa+d28FrzDP
	 xtZlTMz+1gT+Q==
Date: Tue, 05 Nov 2024 14:15:51 -0800
Subject: [PATCH 13/16] xfs: store a generic xfs_group pointer in
 xfs_getfsmap_info
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395493.1869491.7056223583293426352.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
References: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Replace the pag and rtg pointers with a generic group pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5d5e54a16f23c8..a91677ac54e7e3 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -158,7 +158,7 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
-	struct xfs_perag	*pag;		/* AG info, if applicable */
+	struct xfs_group	*group;		/* group info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
 	xfs_daddr_t		low_daddr;
@@ -216,12 +216,13 @@ xfs_getfsmap_is_shared(
 	if (!xfs_has_reflink(mp))
 		return 0;
 	/* rt files will have no perag structure */
-	if (!info->pag)
+	if (!info->group)
 		return 0;
 
 	/* Are there any shared blocks here? */
 	flen = 0;
-	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp, info->pag);
+	cur = xfs_refcountbt_init_cursor(mp, tp, info->agf_bp,
+			to_perag(info->group));
 
 	error = xfs_refcount_find_shared(cur, rec->rm_startblock,
 			rec->rm_blockcount, &fbno, &flen, false);
@@ -353,7 +354,8 @@ xfs_getfsmap_helper(
 		return -ECANCELED;
 
 	trace_xfs_fsmap_mapping(mp, info->dev,
-			info->pag ? pag_agno(info->pag) : NULLAGNUMBER, rec);
+			info->group ? info->group->xg_gno : NULLAGNUMBER,
+			rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -519,7 +521,7 @@ __xfs_getfsmap_datadev(
 		 * Set the AG high key from the fsmap high key if this
 		 * is the last AG that we're querying.
 		 */
-		info->pag = pag;
+		info->group = pag_group(pag);
 		if (pag_agno(pag) == end_ag) {
 			info->high.rm_startblock = XFS_FSB_TO_AGBNO(mp,
 					end_fsb);
@@ -569,7 +571,7 @@ __xfs_getfsmap_datadev(
 			if (error)
 				break;
 		}
-		info->pag = NULL;
+		info->group = NULL;
 	}
 
 	if (bt_cur)
@@ -579,9 +581,9 @@ __xfs_getfsmap_datadev(
 		xfs_trans_brelse(tp, info->agf_bp);
 		info->agf_bp = NULL;
 	}
-	if (info->pag) {
-		xfs_perag_rele(info->pag);
-		info->pag = NULL;
+	if (info->group) {
+		xfs_perag_rele(pag);
+		info->group = NULL;
 	} else if (pag) {
 		/* loop termination case */
 		xfs_perag_rele(pag);
@@ -604,7 +606,7 @@ xfs_getfsmap_datadev_rmapbt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_rmapbt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag);
+			to_perag(info->group));
 	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
 			xfs_getfsmap_datadev_helper, info);
 }
@@ -637,7 +639,7 @@ xfs_getfsmap_datadev_bnobt_query(
 
 	/* Allocate cursor for this AG and query_range it. */
 	*curpp = xfs_bnobt_init_cursor(tp->t_mountp, tp, info->agf_bp,
-			info->pag);
+			to_perag(info->group));
 	key->ar_startblock = info->low.rm_startblock;
 	key[1].ar_startblock = info->high.rm_startblock;
 	return xfs_alloc_query_range(*curpp, key, &key[1],
@@ -997,7 +999,7 @@ xfs_getfsmap(
 
 		info.dev = handlers[i].dev;
 		info.last = false;
-		info.pag = NULL;
+		info.group = NULL;
 		info.low_daddr = XFS_BUF_DADDR_NULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);

