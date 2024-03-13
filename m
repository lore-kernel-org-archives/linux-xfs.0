Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C88BE0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 02:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295768; cv=none; b=irrw0i9mScXpaFbbQTauEzIf46del5Rg+3n4iGDVW8Yuu/npnGIBenyYotFqAmUuUSRTozGdk9KX/zXYmQOlB735iLiN3x7rI3OaeoJ5pfQt0Wed5Cn5FMTkRQtRFfLISx5fLAHt+f80knPrF+kf5cW6cxmV2OfoczxTIzkAQmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295768; c=relaxed/simple;
	bh=/i+45+7QDE33lB0llDpWp26EZXzWxD6MuOjee0UG1Qo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzgdOJcWi/2akd11CLmep64jD7R52nbgopkccy1YBZoO9l/nZvBJjeDW1+atb1R0AYsnJWi4H2WEHpHzG2xAqZpO7/Sx/RU6uB0wx0KAIj0EP99CCROzTtvNAJZjgRDkfpzf2KeKmQR5o02IXH7CLjGDlSaqtqnMmIqvtxI4VjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZw0gd58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZw0gd58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C636C433F1;
	Wed, 13 Mar 2024 02:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295768;
	bh=/i+45+7QDE33lB0llDpWp26EZXzWxD6MuOjee0UG1Qo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TZw0gd58H+cADBWX7y9rsDqBsAocJnzSquxRUnJdDwfpcII+E1Y6wFdo1lajcG3GJ
	 9MxKNcIV1chYFKDR8cgw9GNIfLJOwL6MacvZQ/0PHe8u/zSX3AcgRwZbn/f4h7cSh8
	 q5uzsVUn6W0qEyHnANKa7F1UkRDJTkeEriJbHYya3SdUAHxP6q+JE/lWsWPmi0MoYv
	 eBHCNiV7VpiVEVS+6PinVhhong54Bv1JTjSBShtB/Y7hM78lnLZdh9JMwYdKgivqfl
	 GtV6/cxK2dNQ/+IM3YAXJBCUDNGE2e2CizxKq+QI/0wT7y4dZzfVBdazhb6W6tiEVp
	 lQ3YSs+XeBl0Q==
Date: Tue, 12 Mar 2024 19:09:27 -0700
Subject: [PATCH 63/67] xfs: fix a use after free in xfs_defer_finish_recovery
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: kernel test robot <oliver.sang@intel.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171029432104.2061787.18277817896007687707.stgit@frogsfrogsfrogs>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4f6ac47b55e3ce6e982807928d6074ec105ab66e

dfp will be freed by ->recover_work and thus the tracepoint in case
of an error can lead to a use after free.

Store the defer ops in a local variable to avoid that.

Fixes: 7f2f7531e0d4 ("xfs: store an ops pointer in struct xfs_defer_pending")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_defer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 077e99298074..5bdc8f5a258a 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -909,12 +909,14 @@ xfs_defer_finish_recovery(
 	struct xfs_defer_pending	*dfp,
 	struct list_head		*capture_list)
 {
+	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	int				error;
 
-	error = dfp->dfp_ops->recover_work(dfp, capture_list);
+	/* dfp is freed by recover_work and must not be accessed afterwards */
+	error = ops->recover_work(dfp, capture_list);
 	if (error)
 		trace_xlog_intent_recovery_failed(mp, error,
-				dfp->dfp_ops->recover_work);
+				ops->recover_work);
 	return error;
 }
 

