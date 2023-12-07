Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B50A15CE
	for <linux-xfs@vger.kernel.org>; Thu,  7 Dec 2023 02:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iH68gc73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED319C433C7;
	Thu,  7 Dec 2023 02:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701916145;
	bh=sbJuYHm6OmCDrI45W20fs6Pl6JlEWIMbiZJGfwIje+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iH68gc73XiTtspPb2opC/JfDH+46/biU9SjaUGoAN8J6wfRH/bZdNsQ9vWIAYxS4L
	 NNNrO+kc7kuk8YtoiqbFh4/c2l9wIcATAnZTQJB+SD5C2A7W4KhOGlxh08YhnQdWOR
	 ZpmC2O3slLpKDcMS2CxWDsNa9jyrVrQIBiYx0L4KwEJsycqIazqcmlMGQo1arBiVIs
	 z/NSCRY4o9duNSbPuRosVkPkryUDhlPULpTSw/9sDLi6jgHJmP3RqAvNKd7l9xhp8j
	 f1czJargrMSGLrg8V9+gHuSNTZjuxG0w4dXbmlwEzA2WOJTP+hfpEWRb4jqKffgZeY
	 kUf+u7uhZ8VcA==
Date: Wed, 06 Dec 2023 18:29:04 -0800
Subject: [PATCH 1/1] xfs: recompute growfsrtfree transaction reservation while
 growing rt volume
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, hch@lst.de, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170191563659.1133893.4605821704716263615.stgit@frogsfrogsfrogs>
In-Reply-To: <170191563642.1133893.14966073508617867491.stgit@frogsfrogsfrogs>
References: <170191563642.1133893.14966073508617867491.stgit@frogsfrogsfrogs>
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

While playing with growfs to create a 20TB realtime section on a
filesystem that didn't previously have an rt section, I noticed that
growfs would occasionally shut down the log due to a transaction
reservation overflow.

xfs_calc_growrtfree_reservation uses the current size of the realtime
summary file (m_rsumsize) to compute the transaction reservation for a
growrtfree transaction.  The reservations are computed at mount time,
which means that m_rsumsize is zero when growfs starts "freeing" the new
realtime extents into the rt volume.  As a result, the transaction is
undersized and fails.

Fix this by recomputing the transaction reservations every time we
change m_rsumsize.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 8feb58c6241c..0c9893b9f2a9 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1038,6 +1038,9 @@ xfs_growfs_rt(
 		nrsumblocks = xfs_rtsummary_blockcount(mp, nrsumlevels,
 				nsbp->sb_rbmblocks);
 		nmp->m_rsumsize = nrsumsize = XFS_FSB_TO_B(mp, nrsumblocks);
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(nmp, &nmp->m_resv);
+
 		/*
 		 * Start a transaction, get the log reservation.
 		 */
@@ -1124,6 +1127,8 @@ xfs_growfs_rt(
 		 */
 		mp->m_rsumlevels = nrsumlevels;
 		mp->m_rsumsize = nrsumsize;
+		/* recompute growfsrt reservation from new rsumsize */
+		xfs_trans_resv_calc(mp, &mp->m_resv);
 
 		error = xfs_trans_commit(tp);
 		if (error)

