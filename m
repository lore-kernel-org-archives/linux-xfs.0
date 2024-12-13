Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877BC179BF
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052340; cv=none; b=LOIZ4/XAWxvFXSaj2fhqy5/ZuWWkSIt5ZlsmJR0tdiv2UErblMx7fiad30ZyC95Lr3JFA6XGPd0GDObw30kAkRYwAT1ruKVdtbCqXbYo4MklYKGZO3P9NGVCYaFrlH+/byAMUxlpuOMt2VM5XKUaMw7Bgbia+T/bLfikuJZCwiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052340; c=relaxed/simple;
	bh=kPwjmH/SdSF2HV4PEPV6idjbxnY/GRdN54U2s5wWunM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJZBevqZzlUXRqhyfjvNJbKMZlGcLRQGmiRSf7dy1CPVCf6JSTIWiHe0vcEeSiKq1FjY5abMdUsw89dBulZzxwf23byftPn4g2L/BCRkFOpUz82mTCpotulPxcZ83OfRtxDrbuPddd66LkVbpdBn90k3I5VrWfP0511K2VFfajE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GogL/yNq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GogL/yNq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE74C4CECE;
	Fri, 13 Dec 2024 01:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052340;
	bh=kPwjmH/SdSF2HV4PEPV6idjbxnY/GRdN54U2s5wWunM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GogL/yNqnHJCAG2RGm4QWPzBQvLrfZ6Y9vYBBhG1hYDWAMK9NA5mgqxEO3TOtOmyt
	 ChWXY1XP00BGe4dS2eohTsPxA1ndvMlT18gL8PG6lqoOFTKNpJeZleGEO9RDeUDMIk
	 x4E67/6WgwcpEvjGzEheN6GuGVodMiTytvMAGlYpjr1HLlq6Ihc2o1X1Y5FkdS2Ypq
	 XV7B3uavoyephUKeEA8fepE7dh9GH+DUM11K0wZ05HxuC8x6PgqqiyhbspnFkjQxup
	 qSPcFfK+HZm5FRudpG5mnU5hP+QwPJ39obE1RAVu+qyh09EzAWugpxwXS1kfki6dRg
	 jt+iDd1/aAakQ==
Date: Thu, 12 Dec 2024 17:12:19 -0800
Subject: [PATCH 08/43] xfs: support recovering refcount intent items
 targetting realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124705.1182620.9898053925515649452.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

