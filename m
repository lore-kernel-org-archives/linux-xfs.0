Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121EF1C36
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371299; cv=none; b=I7cfxt3P0nntnMun7sb+xywMm7LlhbKwGqB6E182p8Dbn6QpC/x+sfVYGyI/wy+xymnDo75iyq9jkYyC1JVHGucJpgLSVN9IBEPC5akjTwxEDhrouf4BmwTWKXcLI+b8++vnDZ0OUFsSHpFlxPipkEvsqmMs4qkrmgmAQVCtwgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371299; c=relaxed/simple;
	bh=15XbvOxjHEIqQtdXJUm4MGmRb8QE1Z4v1mwBQBjBn4o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/ln6m2CMeQnRcUeuaBuJ9Le2By24ChznI+hpoHF7h0g641r9CI1A/dJ4c9+wgoNkYTHi1zhjUy3vvwZ3BOFopUyRx4a2+V4rgvDh6bI+SYo80tsHOuw5d988RefVQ1q1cXI1WUaNQ870VDJ6xo7KPl5/bXUny3YAwC5H2Pffqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MxdkRecN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MxdkRecN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB038C32782;
	Fri, 23 Aug 2024 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371298;
	bh=15XbvOxjHEIqQtdXJUm4MGmRb8QE1Z4v1mwBQBjBn4o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MxdkRecN7PsQ6pQ5T7N2iQdj5vdNwzFsusAw2b12rDz9V3Ja8oAwfGsdpB8R3+uyq
	 y+KXMkdjnkJzxQyNJPJYp6UBXQGWDQ+7vVHyB+0g0w5vMVQW3SBhful3X2NFIpQLCJ
	 FFpXmOw1ztBGeH/jKUYHCoul/Pq2sigtH0vDya9XReZvv809QmAehEwqxaWfk2lmav
	 hkpeP0kzm1d9tm02Tske85l9dT+ZfrZFIFynTYFpXzN88JuJsgvlfecxw3tqcwDUpG
	 5CrjhCNSx/hchGKNDPGjeNNO0idqlHuRCDS4Bj4TXJiME0+W8BEdbAN9bJ//epM0i3
	 MJSaWkDaeb2jg==
Date: Thu, 22 Aug 2024 17:01:38 -0700
Subject: [PATCH 1/3] xfs: validate inumber in xfs_iget
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437084655.57308.14689040024608460458.stgit@frogsfrogsfrogs>
In-Reply-To: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
References: <172437084629.57308.17035804596151035899.stgit@frogsfrogsfrogs>
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

Actually use the inumber validator to check the argument passed in here.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index cf629302d48e7..887d2a01161e4 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -755,7 +755,7 @@ xfs_iget(
 	ASSERT((lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) == 0);
 
 	/* reject inode numbers outside existing AGs */
-	if (!ino || XFS_INO_TO_AGNO(mp, ino) >= mp->m_sb.sb_agcount)
+	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
 	XFS_STATS_INC(mp, xs_ig_attempts);

