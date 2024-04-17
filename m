Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E930651AB
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389032; cv=none; b=cUu6NufUj7NUi3XSOuabv9doOQOMPtxoB3OlnS8dGsB9b7ZJ7W5Vb0x0YXJBtrQs5n+FxcKhdo1au4NeW+HVJLMRm0XRDuOlwacHUxWYSMoj9+XFn/dvrOApg/hS5nIqPXUwe0H8cvU160I1/igbH3STGW23rSEIxQijkT1ZDPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389032; c=relaxed/simple;
	bh=+c8LbC4sCnF8OdSxVXOV87SP+cI1pOft3X9XIoX0w3U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kX5HKZDqhaxs4xGeeJqJRLU+RYN1vYqyRwzHW+Da6mq/nJ2BoZnjDnIy5Erx5rHLjT9e5IqyUYzwi90IN1HYaPc46nml0E7NbNTF+kOXqdjjgzrsbfgIbq/9LG8avpYS2mXT5c7oMC9oY9cwDGJyOAdU62HQJgNPa1tNqwZQMiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A2DK2Zfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A2DK2Zfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1116AC072AA;
	Wed, 17 Apr 2024 21:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389032;
	bh=+c8LbC4sCnF8OdSxVXOV87SP+cI1pOft3X9XIoX0w3U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A2DK2ZfpGlsUp7/QwMB36ZUTSPV7qMnq8vGErrdntufHPPE+sRo3OlCxhb8nTpOrJ
	 Jhx6tql3PAWmiE0O2KBXild4KhkQElBNgfbSyjdqK2RoxdjdlgoUkw/sbrvLrhlmoo
	 D2GoiuS3sbEESUBRwgM/5+xHL7oC1GSTi/jcReaKCLLCHxIU/hdfSxeefGXXsU3u8s
	 dK3cG/zJirOqeYKODgvRxDL+XOUGVTiu7MNhfVby1dI31yWvecwv4srJxlltBBYAyb
	 vF7qdEkqi86G5Duw2aUIWTQH9Xf3QYIVdK3Nb5xuKLM0EC8/FiQZGgt8EoqHIg9BIM
	 JKpKYRgXmuSLw==
Date: Wed, 17 Apr 2024 14:23:51 -0700
Subject: [PATCH 08/67] xfs: clean out XFS_LI_DIRTY setting boilerplate from
 ->iop_relog
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842460.1853449.14210095427795914629.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

