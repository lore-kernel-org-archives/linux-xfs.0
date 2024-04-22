Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A92C153833
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803960; cv=none; b=AhrUTBuaeVZ14/nSpwWhHo1NBUMKuhp1lEsUm1mJaS0rbRe9Yj3sQdtn/1+JbOL9tcsxj0tkuVEaSHWNVdsynKdPCTlW9TjNF+l23xuvcBYfOuDf/mnOCJJeavVY4fRib5i0vU5XHyLdAG42XyuVczD3aIeZ1ivbRMcFNoEOFK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803960; c=relaxed/simple;
	bh=Eji+OJtqONYtyhzIfG3EfJ57V3Q/0XMnicUQ1HsFk7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFlkhVTHi9lm4FnN7sv7vOhDvQv0626RjIEkM6uhUILuifdORKfwa/lFYG9FU3zac9DY1TCAuQ0mQTkJ2iSoBl5+H7vrqj+q+iFCn51jCKkWq2VeHuD/FIUOu8yL2FrsiPvmcDUG1XyypckGyqh8HM2H9a5RPrpyhEYORQlYRPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlTUjNYp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlTUjNYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A32AC32782;
	Mon, 22 Apr 2024 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803960;
	bh=Eji+OJtqONYtyhzIfG3EfJ57V3Q/0XMnicUQ1HsFk7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlTUjNYpAokW6TCUTmWdNo6DE5nnrlpoyXv7OOyqn0r9KrnMGW/VW8//sWBdOB22a
	 eerqy6U8bYul5oD77XGIAyMS0ouAUIekkDbX3WAzYFWA0jaANCRoa3iUcF0sY57QFw
	 4r75An0uH/T05Zw4neIl6vT+eNqFBQEI5dkXevWww2AUNl0fqHA0lbPjGbXsU+6xls
	 zrHlwB7t46AOd+tRpKtNNC87J/HI16yGaDGxrxHfr/8+SBhMwErxp8/uUfQQm0UNXv
	 M2N/rRGC5hg1swURL//ymEwb0ZNPAONntTx0jzKQKMnABY2iT2qgAEy9k1/ZF+Oma9
	 nufAlXg/sgd0g==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 08/67] xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
Date: Mon, 22 Apr 2024 18:25:30 +0200
Message-ID: <20240422163832.858420-10-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 3e0958be2156d90ef908a1a547b4e27a3ec38da9

Hoist this dirty flag setting to the ->iop_relog callsite to reduce
boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 43117099c..42e1c9c0c 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -469,6 +469,8 @@ xfs_defer_relog(
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
+		struct xfs_log_item	*lip;
+
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -497,9 +499,12 @@ xfs_defer_relog(
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 
 		xfs_defer_create_done(*tpp, dfp);
-		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent,
-				dfp->dfp_done, *tpp);
+		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
+				*tpp);
+		if (lip)
+			set_bit(XFS_LI_DIRTY, &lip->li_flags);
 		dfp->dfp_done = NULL;
+		dfp->dfp_intent = lip;
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
-- 
2.44.0

