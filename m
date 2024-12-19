Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59DB198A08
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636908; cv=none; b=BkjDXT3pEP6PKC55BA6Ip1kwQlb3iXvMpLnqcxJ5hcm5igo9W2WWRa+L/0dxXNXfeXtw1YMGwJW3ZiqSVHI6QtMsokXfmZZ+WJEnMMYPUs1exOL6radxdDrYA13q58SLrf1p/H+j6bLQwHM9PC3S2war/6yOvpQJPS3wrviWNKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636908; c=relaxed/simple;
	bh=HemWDq9qDFjcNe/eRbtiNBUhO/YD3edsPVAd2P2iXVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/pnK0dV70NS/aAmhemEFk49u/4Mx+vUq3SprKpEKD+Md4CWZuAmQ28cYr+wyczK6rZWXPgkEx3FjQr0q/5SsKKqSIeRvZftxnyEZM6rBCSeMHSL+1AGgvFlJw0bRfAwK/Lvy6CesWYFhibAFelAKy8YTtXCNmTBP49TLkFws+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5ThQTGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5ThQTGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC305C4CECE;
	Thu, 19 Dec 2024 19:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636907;
	bh=HemWDq9qDFjcNe/eRbtiNBUhO/YD3edsPVAd2P2iXVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K5ThQTGDlp6Wea6t4SOEwKlyj4MXvdmJ4HvUQ0Y2l73SZUwU5At7tYwDNQMii4vzx
	 cjNpQbX6hZtPcwnms9AECxdPiXTEdAMbuhkLBLGRJbC8BMQeu5sr/LzNEV+G1X2dAC
	 QKcxZ2Waj/ak8gKEZkHIdYBqkNARxIHshFAN9HznBOXVm9W0XAqa68/16besPgtp94
	 x0LppX8N7kxQhclejo7dVy6+3+BD9B4jqY4iIZIdU9tUhnzOIYa+wkjU8sNUmm2pBj
	 9q+vHMtnwuiUI5KvuWczXg6XZWfrzIeFPHca7Wjqre+P2/jZyBcoTjtLvnWnOhB8lb
	 xsMdby5ZL8omA==
Date: Thu, 19 Dec 2024 11:35:07 -0800
Subject: [PATCH 08/43] xfs: support recovering refcount intent items
 targetting realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581115.1572761.6866470540595917101.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we have reflink on the realtime device, refcount intent items
have to support remapping extents on the realtime volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_refcount_item.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2086d40514d086..fe2d7aab8554fc 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -440,6 +440,7 @@ xfs_refcount_update_abort_intent(
 static inline bool
 xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_phys_extent		*pmap)
 {
 	if (!xfs_has_reflink(mp))
@@ -458,6 +459,9 @@ xfs_cui_validate_phys(
 		return false;
 	}
 
+	if (isrt)
+		return xfs_verify_rtbext(mp, pmap->pe_startblock, pmap->pe_len);
+
 	return xfs_verify_fsbext(mp, pmap->pe_startblock, pmap->pe_len);
 }
 
@@ -465,6 +469,7 @@ static inline void
 xfs_cui_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	struct xfs_phys_extent		*pmap)
 {
 	struct xfs_refcount_intent	*ri;
@@ -475,7 +480,8 @@ xfs_cui_recover_work(
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
 	ri->ri_group = xfs_group_intent_get(mp, pmap->pe_startblock,
-			XG_TYPE_AG);
+			isrt ? XG_TYPE_RTG : XG_TYPE_AG);
+	ri->ri_realtime = isrt;
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
@@ -494,6 +500,7 @@ xfs_refcount_recover_work(
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_cui_item_isrt(lip);
 	int				i;
 	int				error = 0;
 
@@ -503,7 +510,7 @@ xfs_refcount_recover_work(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		if (!xfs_cui_validate_phys(mp,
+		if (!xfs_cui_validate_phys(mp, isrt,
 					&cuip->cui_format.cui_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&cuip->cui_format,
@@ -511,7 +518,8 @@ xfs_refcount_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_cui_recover_work(mp, dfp, &cuip->cui_format.cui_extents[i]);
+		xfs_cui_recover_work(mp, dfp, isrt,
+				&cuip->cui_format.cui_extents[i]);
 	}
 
 	/*

