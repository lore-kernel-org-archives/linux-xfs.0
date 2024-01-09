Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D4964A
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2L6AsZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DCFC433C7;
	Tue,  9 Jan 2024 02:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704766655;
	bh=w4JkwSMC/GcKf4VlM4YB6CeE43hHJUPYROAQz42UC6M=;
	h=Date:From:To:Cc:Subject:From;
	b=M2L6AsZ1SYnQnrWi5p1347ClotmpeebSFKHy8jYaVlu7estdpY89tM7FiGwBFlU8c
	 s+7VoC5J7sElU41CjL/oSWp/waflZf6KOwl6LtJrEEMmzJtSVSE/ecTT8CdMRoR4bO
	 wHQ7x2uOBGy+3bsH4SFN5YWa5eNxVd4fHZ7ApCjXy08wQFg1iGEiq+xF6q3EL6kXhp
	 NI4YBfRT23aAfqpEZqiTFvVv31PcjphYpVfbREbsj7tuil+Ak+ILK4ZQJjcBR+ebcs
	 dJpicIUWlhJKO64iCX8hwC44lv1BE237tNNfxCbp2vOpWZK8p0BGAWuScieTvGEe0C
	 qcHhtEl93uRgQ==
Date: Mon, 8 Jan 2024 18:17:34 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Message-ID: <20240109021734.GB722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

We're only allocating from the realtime device if the inode is marked
for realtime and we're /not/ allocating into the attr fork.

Fixes: 8a3cf489410dd ("xfs: also use xfs_bmap_btalloc_accounting for RT allocations")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ed7e11697249e..e1f2e61cb308e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3320,7 +3320,7 @@ xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
 	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
-					(ap->flags & XFS_BMAPI_ATTRFORK);
+					!(ap->flags & XFS_BMAPI_ATTRFORK);
 	uint			fld;
 
 	if (ap->flags & XFS_BMAPI_COWFORK) {
