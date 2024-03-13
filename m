Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B58BBA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295815; cv=none; b=imMtD1GGoqmbHb9Qmggu9+kgHXlB6JnQ04YL9jZEgxOL9ZCnxl6yZiMf4w/vWG9017stOBN2goKlHSeXxPzxzVAbKE2fX9g1HSDk7P8QrnpTmJHL5jEvqPuLuJ+9PoFoA2ZElbEbxJAKPgvf5uYutT9BwxHsyYWRoAnsiMmzvgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295815; c=relaxed/simple;
	bh=N6o2/8nTpWLLDAwSWeybEIU1hl4FviI8I6jq1xXBy9w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l8HHfbJs2PgCdmIvKQXWndJLvWLqa9Re+gS2p6vIAuBiu7VoU9Jl0rh5YYwl8VS9U5VopM5NA7VLI0OPqJ6aFhBahBW2YPICo6eWnD7oOYWL850hctlBC+Do7pSkuO/zV255MXXgeYjs152xCK4OJOiDUgOJNU9h1G1rvraNQzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOdv54pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOdv54pi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7395C433F1;
	Wed, 13 Mar 2024 02:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295815;
	bh=N6o2/8nTpWLLDAwSWeybEIU1hl4FviI8I6jq1xXBy9w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QOdv54pirH6g9WXj07JWXOCTU/90ZKjZqIUBL6WMfPhn5eoJDwH7SHPFr6BlsP1HF
	 b0eGRq+hsxuGKtovgSCQX1lfAZ1/+nhd3+/n/qExtU4s91E0L8ea7wsRG4d9zO+tVe
	 nLbF/3p+v+NOqzUApmUUwtBGNzaBTKfrPGCQVEYzZJCfkbqn/dmxldIia5reea0nPT
	 y4ZwBENId01rVuQAN7hA461XAEAteJEn/NOSMeO3vmPAAf5Kq9pmkicKh3q4vN09kc
	 1XT/ULxJoWe+pEdHNEcKB0Q4Etx6j1I8k5zdsZuEHy+OU8/sxtzN31LTLx5s+sgIXG
	 B9Z/jZTeTcoZQ==
Date: Tue, 12 Mar 2024 19:10:14 -0700
Subject: [PATCH 66/67] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432147.2061787.11984387032713086021.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Andrey Albershteyn <aalbersh@redhat.com>

Source kernel commit: 82ef1a5356572219f41f9123ca047259a77bd67b

In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.

The filter is not reset though if XFS just removes the attribute
(args->value == NULL) with xfs_attr_defer_remove(). attr code goes
to XFS_DAS_DONE state.

Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
operation already resets this filter in anyway and others are
completed at this step hence don't need it.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1419846bdf9d..630065f1a392 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -419,10 +419,10 @@ xfs_attr_complete_op(
 	bool			do_replace = args->op_flags & XFS_DA_OP_REPLACE;
 
 	args->op_flags &= ~XFS_DA_OP_REPLACE;
-	if (do_replace) {
-		args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
+	if (do_replace)
 		return replace_state;
-	}
+
 	return XFS_DAS_DONE;
 }
 

