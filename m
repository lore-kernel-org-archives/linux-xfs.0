Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F29224E8
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346909; cv=none; b=d1zRK3R5+6LSfl8yunXIWU8H8T/9l6/sVsWIdQtFyoV3hBZG9/EizXeYwBAi8T2R09Fb372SkBiZIbIlJLfIj7jhtg3DdqwSuePZfK9atTwVEZ2tPWTXKsGEb9mxYO+4w2SIxPcRM9w26XE6AJ/sqLEituTlELM3R1xMJbYZCow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346909; c=relaxed/simple;
	bh=oLS8g37TuJNvwG6RzQBMd+V99z6+TZXsPGHLA0/XE4A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLwGRwdzcTzMzyqKFWywC3RODCeK3r8tX+iUC5hL6Zus2Osp6dDHIF41TiSMieExPEvI2qKlBxNIkGaQpM+9Pa4XRKXsiMiBgbJpUnbFG6y+SAMCffMOrGNPMFDR7qu0/Hsk467BieOaCL3Re7kTZWq6XjUVfcay9kcBEfFLWPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqMCXd5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqMCXd5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8466CC2BD11;
	Wed, 22 May 2024 03:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346909;
	bh=oLS8g37TuJNvwG6RzQBMd+V99z6+TZXsPGHLA0/XE4A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TqMCXd5HGwsTDa4NSwOhQwfRe6EvAheBQTMBg9KhkuEOvixTf9UsmqrqRL42mZu/J
	 2gFK9q+6dpXKE0JYrwVig1oxreWyiMOsgxnJ80LYefTkJCZ77Tn793OjoEZUHZlk6i
	 E8c/HGrMA+KQnBkt+wwkSZe3b6crBdFP8aNzUgnjqWZPAp1mbex5ghdsERiaUu7OQb
	 cSNEHa4ocL/EcPBQIc/gV6p8dHUI1blL3WswTOSRdgVmxW3VaWGRkXA4BzVTBGM8hI
	 iwXtJjEt91J5F/YlNb1TW121LaP+MC95qA6pbvC9GWekzATz91gSAzfcBTm1k5rdTh
	 K5APwW0C+/94Q==
Date: Tue, 21 May 2024 20:01:49 -0700
Subject: [PATCH 050/111] xfs: move comment about two 2 keys per pointer in the
 rmap btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532453.2478931.14874938310432599721.stgit@frogsfrogsfrogs>
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

Source kernel commit: 72c2070f3f52196a2e8b4efced94390b62eb8ac4

Move it to the relevant initialization of the ops structure instead
of a place that has nothing to do with the key size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f87e34a1d..311261df3 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -475,6 +475,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
+	/* Overlapping btree; 2 keys per pointer. */
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
 
@@ -507,7 +508,6 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);

