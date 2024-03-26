Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F854128392
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422295; cv=none; b=Ya8NCyzkQA1h3xBx3eQj8jpea57+O1R1I7nq+llnK/4VCzYtya61ztxV8mhFdhUNAD3LYfcBZQUXRQjqtMTdeQlNIhZupnvFFhSU5ccGzaPBnRiqAgaTStLSzP7GKbrAE6N/YkOXgqUuRJsdAPEMiTIXIol69CBmHSH6l75xqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422295; c=relaxed/simple;
	bh=/loSYCHuZ58g5YiI0r20FlJXrV371n7C1C0f+LEOu2M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pAab9XVPHds+L++tuZTzRubzcSjkTkkzuu/hWnfFoeai/ciN2obrtNS5jsuECOpe5F5y/sFqCQWn4FKMCj2sIRo7Kab3hx8tT9UPfxUhQgiUCiofK86XAI4DGxfWrqkYuuCCYBMMxENQQuX5YWrPxQmGwcQyqKGTLCnU28Qm2Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHlRJKeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHlRJKeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE8BC433F1;
	Tue, 26 Mar 2024 03:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422295;
	bh=/loSYCHuZ58g5YiI0r20FlJXrV371n7C1C0f+LEOu2M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PHlRJKegEQomme6GnyxRWziM0u2FK80+KGMw0Epl7zX0GlZfmgmFGSo7OM3s66QnD
	 vUyKRlwAPX+fk8Pgp+Cn+cLhQHkIzRvBuusRal+6yN8HgyMjHfD6HwQTnc7YTMNWo1
	 cUoMi/LE4X5HLa/xAnb2S2+gwa6UcBURYRgj88H7qUKFdgfaEiXDvFTfll0P17T148
	 Qiu0C9nMsu9lv9VNa+C1QGQ73U8OEmR3k0PhgTRNT4ewEKiOBKLRRktjuumzis0wVc
	 Vgt2ZvZ//DHikGhIuHW0y6VBWyWbTI7mQO4ssuadUUsq2K2XQN4cMk6Iz/V7pUA/7S
	 7fPoKSBc08ZpA==
Date: Mon, 25 Mar 2024 20:04:54 -0700
Subject: [PATCH 08/67] xfs: clean out XFS_LI_DIRTY setting boilerplate from
 ->iop_relog
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127078.2212320.2042940855938745376.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3e0958be2156d90ef908a1a547b4e27a3ec38da9

Hoist this dirty flag setting to the ->iop_relog callsite to reduce
boilerplate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_defer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 43117099cc4c..42e1c9c0c9a4 100644
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

