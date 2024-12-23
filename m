Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF532837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995303; cv=none; b=SJbzoMZLXVQp+I6yENrpBnQdIqaCIHWBMQUh+NODWuPyL/Z6dvVkhcXQVHi0IFDp51aiuuoEGVdZu6fHhbahER5EVTCIV+UO2YFTm8QOkOd8JiMYnN1kmEg/FiNqaVAERHj/+5ojCkcUqmSDEUy2efvOqSfPY85T8C6Dh5HRwfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995303; c=relaxed/simple;
	bh=HemWDq9qDFjcNe/eRbtiNBUhO/YD3edsPVAd2P2iXVw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADJNw+qvFTM66j3k+6Qmp0INbwSXdoXerTQ0OH2xWziuLwYAts4Po7NXm8tAf4nmjc3EtDjGB7G4Qn7BniQtHIHukbJcRAIChbouYWnhaGk+xvSKKiwjgxJQahwjZTSt6b7Jp5iCWtEhZ8Qqu3enW4idas9m/LeSHdR0C9n5Og8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQDoAhcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQDoAhcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02497C4CED3;
	Mon, 23 Dec 2024 23:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995303;
	bh=HemWDq9qDFjcNe/eRbtiNBUhO/YD3edsPVAd2P2iXVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iQDoAhcXsxC9+l27xkzSuCEamNPwkBMHMfZfXL1Mi50hFSDXSE33r8mZrAFbJZcJ0
	 KdNnAMtk6C8HvanoegHMXSEfNNjiSYOPIjkPU/pUSrRC/8UPQk74jnVxAZAA2ReGVK
	 PoOYUGuOt8dvYgmoJKTqCaWqCP8BjfTewyd+SXitS37wHIyUUlXuNGGfGgLtRWTKxp
	 hs/OLdzge8+CerdOY+LKfEFSJsKgxQa7+oHCLJ3h9dW9tnllF/QZDNXzmGySo7oW1U
	 PSidzEQeNTl960u5SlT/MHcPOsB6PodTBs8N4MLgCyCbtB29FH0X4yu4uB1YelWX7o
	 H2s6ee5zgNMCQ==
Date: Mon, 23 Dec 2024 15:08:22 -0800
Subject: [PATCH 08/43] xfs: support recovering refcount intent items
 targetting realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420076.2381378.10858952194768470070.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

