Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961937F9
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n5w6rgfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684DCC433C7;
	Mon,  1 Jan 2024 00:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067612;
	bh=crL7isInhxuf7Trb09E6aSLKAryS1h8t8juwjciF2/M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n5w6rgfvdWPYssrus4Svo8lb+q+ArBcJcsLRQZKE4u1nxnFvFB1/QGv0UG3bII4A5
	 ClbiKfq1fpU1TiIRV1pHtsz3VU2tZuG0Zz2ltkKwzCkN2ZUvz2dSzKbtp3oqcbLU8t
	 JsfYcLWV6gD2wc5u4JDedN63x/9cy7rxFdFqMXLecw8TQie62a4Vid9w8gWOz+MkBk
	 6pMPa+pUwr/6usH981em/At8VNIW6pPmvackozIzKyc4LKMnXbC5lClv3WJ+IZETNo
	 iUDTmGolfn5l6QWSBjZkoFLcQR+G88wsEY4scpbzMq2lvyDsohDmTD+PuAtjklqOaU
	 IpacsGewDjhGw==
Date: Sun, 31 Dec 2023 16:06:52 +9900
Subject: [PATCH 6/8] xfs: remove duplicate asserts in xfs_defer_extent_free
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014121.1814860.11780010368849686036.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
References: <170405014035.1814860.4299784888161945873.stgit@frogsfrogsfrogs>
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

The bno/len verification is already done by the calls to
xfs_verify_rtbext / xfs_verify_fsbext, and reporting a corruption error
seem like the better handling than tripping an assert anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c |   13 -------------
 1 file changed, 13 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 442a045378c..160563b1b26 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2592,23 +2592,10 @@ xfs_defer_extent_free(
 {
 	struct xfs_extent_free_item	*xefi;
 	struct xfs_mount		*mp = tp->t_mountp;
-#ifdef DEBUG
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
 
-	ASSERT(bno != NULLFSBLOCK);
-	ASSERT(len > 0);
 	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
 	ASSERT(!isnullstartblock(bno));
-	agno = XFS_FSB_TO_AGNO(mp, bno);
-	agbno = XFS_FSB_TO_AGBNO(mp, bno);
-	ASSERT(agno < mp->m_sb.sb_agcount);
-	ASSERT(agbno < mp->m_sb.sb_agblocks);
-	ASSERT(len < mp->m_sb.sb_agblocks);
-	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
-#endif
 	ASSERT(!(free_flags & ~XFS_FREE_EXTENT_ALL_FLAGS));
-	ASSERT(xfs_extfree_item_cache != NULL);
 	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))

