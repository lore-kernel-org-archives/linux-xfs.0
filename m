Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE49BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edcOqYKx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A59C433C8;
	Sun, 31 Dec 2023 21:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059215;
	bh=zmZX8SYGsrwnvNQcHgZ4qxtShWHy8z+EB7e94IYIKk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=edcOqYKx0W0PaeC3A/HQSV2OHssUDMF4vlFLaEqeXPC3Y6bAG4a0MckQbLrf8BEzz
	 UasQoxs6h7D6BRrWy0DBEHZ6//DbwBYgOgwkCMQCLmr/+JT12Xw/yhCConggBs2l8m
	 zkD4gvWaM3dQS1Y5rhDqzTd70LRsMZuE/nDE/oJifRrwJbqNIA2UbrNuChEch9vwhc
	 dGMr1CUId1WkaOvss1e+9gGIQYaleWkP7jHVqG95M538VKB0HpKPB9cx0XoRR1BNFL
	 5CSS4PJlsf5A+ITA107KUTF2qxG/9csjZuYoE76RGXqFP1kfheOmj3CNshlXRGwdse
	 CSahirHoF0YrQ==
Date: Sun, 31 Dec 2023 13:46:54 -0800
Subject: [PATCH 09/44] xfs: support recovering refcount intent items
 targetting realtime extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851727.1766284.18367389082794551051.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Now that we have reflink on the realtime device, refcount intent items
have to support remapping extents on the realtime volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 4d5941335bc75..11df3aaa7b3f7 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -433,6 +433,7 @@ xfs_refcount_update_abort_intent(
 static inline bool
 xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
+	bool				isrt,
 	struct xfs_phys_extent		*pmap)
 {
 	if (!xfs_has_reflink(mp))
@@ -451,6 +452,9 @@ xfs_cui_validate_phys(
 		return false;
 	}
 
+	if (isrt)
+		return xfs_verify_rtbext(mp, pmap->pe_startblock, pmap->pe_len);
+
 	return xfs_verify_fsbext(mp, pmap->pe_startblock, pmap->pe_len);
 }
 
@@ -458,6 +462,7 @@ static inline void
 xfs_cui_recover_work(
 	struct xfs_mount		*mp,
 	struct xfs_defer_pending	*dfp,
+	bool				isrt,
 	struct xfs_phys_extent		*pmap)
 {
 	struct xfs_refcount_intent	*ri;
@@ -467,7 +472,12 @@ xfs_cui_recover_work(
 	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
-	ri->ri_pag = xfs_perag_intent_get(mp, pmap->pe_startblock);
+	ri->ri_realtime = isrt;
+	if (isrt) {
+		ri->ri_rtg = xfs_rtgroup_intent_get(mp, pmap->pe_startblock);
+	} else {
+		ri->ri_pag = xfs_perag_intent_get(mp, pmap->pe_startblock);
+	}
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
@@ -486,6 +496,7 @@ xfs_refcount_recover_work(
 	struct xfs_cui_log_item		*cuip = CUI_ITEM(lip);
 	struct xfs_trans		*tp;
 	struct xfs_mount		*mp = lip->li_log->l_mp;
+	bool				isrt = xfs_cui_item_isrt(lip);
 	int				i;
 	int				error = 0;
 
@@ -495,7 +506,7 @@ xfs_refcount_recover_work(
 	 * just toss the CUI.
 	 */
 	for (i = 0; i < cuip->cui_format.cui_nextents; i++) {
-		if (!xfs_cui_validate_phys(mp,
+		if (!xfs_cui_validate_phys(mp, isrt,
 					&cuip->cui_format.cui_extents[i])) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&cuip->cui_format,
@@ -503,7 +514,8 @@ xfs_refcount_recover_work(
 			return -EFSCORRUPTED;
 		}
 
-		xfs_cui_recover_work(mp, dfp, &cuip->cui_format.cui_extents[i]);
+		xfs_cui_recover_work(mp, dfp, isrt,
+				&cuip->cui_format.cui_extents[i]);
 	}
 
 	/*

