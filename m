Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3449522F14
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442366; cv=none; b=XsujmEiV4c2vjWCRLmAjzS4UoN4ySLcHfVG+MPf/pS0nQn/vhkO8Gz5g4ZTHsmCiSftFlh+G6M/XAcrnFTigjOidT3BU5kp1FOMu5t7NUmVD6jUSqa0pMx/l43kuCeD67bF7n19w8et4h69P4aLjHXHmD7TLAlwHirkAITganBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442366; c=relaxed/simple;
	bh=S97hq3VOBvl/aev+IBjX17dddzfZnYJrVJgsabSNlFY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KvyDb7E5SdlfLDExZ0RskdaEWS9N15mFyq1qnrrxYTOsdCn9cgQnb6gC6kIzDWX2YbUQS0mTrAPiQxCVL9E7YCTpTYE00xlR0MR6PEYE4huIlu5vItZozRnX0W97+EYeYZJeD45bynUuVA9c08U7x7sMDZ1ut6h9UcoGcaWlY0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARzAZlyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARzAZlyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A39C2BD10;
	Mon,  3 Jun 2024 19:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442366;
	bh=S97hq3VOBvl/aev+IBjX17dddzfZnYJrVJgsabSNlFY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ARzAZlylnRbp4FyRVCvR4EMzaIG996ilStj/4y37fARP2RkOWk8iMO5h7JtSNVoiN
	 80Cf8p2GYqc03+Ya+nq2i7uFGX/sI9zyBrigW+oaeDQxDXVxhNL1pL2EdAI2h6Lf09
	 4Wmt2qFCUoB8oWnOQqQWHTXgdtW8g8jo0d+ChQqmptpVmFadF/gb5DWE+Dq9s4hs24
	 lhKNZBD+jLazCoSaDEq+Ta6bIe5IIGMgKK+rk9wxzi+R3JpFSZq1GHl6/ZCPhDrRdd
	 WOxVn4+k7qFAaXiQwor2fkFJT6ngnp29lOnsx0Wd5xgFJnt4YFgfg6RotMIhthcyib
	 ATWpPiPB1/vBg==
Date: Mon, 03 Jun 2024 12:19:25 -0700
Subject: [PATCH 105/111] xfs: xfs_bmap_finish_one should map unwritten extents
 properly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040943.1443973.13045498951073969691.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6c8127e93e3ac9c2cf6a13b885dd2d057b7e7d50

The deferred bmap work state and the log item can transmit unwritten
state, so the XFS_BMAP_MAP handler must map in extents with that
unwritten state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index f09ec3dfe..70476c549 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6239,6 +6239,8 @@ xfs_bmap_finish_one(
 
 	switch (bi->bi_type) {
 	case XFS_BMAP_MAP:
+		if (bi->bi_bmap.br_state == XFS_EXT_UNWRITTEN)
+			flags |= XFS_BMAPI_PREALLOC;
 		error = xfs_bmapi_remap(tp, bi->bi_owner, bmap->br_startoff,
 				bmap->br_blockcount, bmap->br_startblock,
 				flags);

