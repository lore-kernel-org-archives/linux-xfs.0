Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A3D3B189
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 19:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706730435; cv=none; b=cAtTS3hjde2RtM0ragkulGOXAYZPJwjFpI3f9SASBI6T8kqvn+J90scNxWBItW7K+4dtTdiyWscShwsor16U/APYkJf8OtVZ8ITaq4rrx+o1o2Ot4QJ6TQ2t0gH8+ReMLM0x9N9ogv35RPAFwrcaOUsZE6WBx6uFeGzRb2B+pQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706730435; c=relaxed/simple;
	bh=wQRgi149nS/k2Ce5kTWqeDrBtiGr8ORIu678feLjUEw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=PQVOqXX2n7iuI+JH9F0xpvRUKdvlY9vqqLIlKnMAX/BVLg5U7j84QYHlzTNoRaVBIeK+O++FPGd2H3ZWQ1cXzOMUElScPrzLA6zSu07zlvx9hGzAXlvYu51W6oJvxXQCMOArQS2xU0aKY6ERal16CwCdU/iM7jg+re+PpNMcVRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAqHuJQz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAqHuJQz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00521C433C7;
	Wed, 31 Jan 2024 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706730435;
	bh=wQRgi149nS/k2Ce5kTWqeDrBtiGr8ORIu678feLjUEw=;
	h=Date:From:To:Cc:Subject:From;
	b=sAqHuJQzvYfOgjbXB25/RXbRDcYytGC7t3g62q3NKPs/Q8bS6qSWfAxYT0mQpp4Ay
	 rMZP1jEE6vXQG3QkBlEPWWDdxLigjm2SAbq64sKoHWvqVoTCcdEW+NanBDA6LwVSOf
	 8zb1QbWEr/6X/QqSNzibUVij5fGN3bGCHABCwUT5IBqVFuK5Usp+J2nKTuTVS+qjiF
	 TbGLBoi+RrwLCA3Unn2u83v1tb645nPA8tqsLnfpbK94gLEABL8xXt4pjUnmGMbrfK
	 J7OpRVwewHtUtH7AH49q2vm0ycFsHn6hC5/Cym9muxpbVNiYqw86FRok0lF4PasVGP
	 BgDKeNW6itQ0w==
Date: Wed, 31 Jan 2024 11:47:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: disable sparse inode chunk alignment check when there
 is no alignment
Message-ID: <20240131194714.GO1371843@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

While testing a 64k-blocksize filesystem, I noticed that xfs/709 fails
to rebuild the inode btree with a bunch of "Corruption remains"
messages.  It turns out that when the inode chunk size is smaller than a
single filesystem block, no block alignments constraints are necessary
for inode chunk allocations, and sb_spino_align is zero.  Hence we can
skip the check.

Fixes: dbfbf3bdf639 ("xfs: repair inode btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index b3f7182dd2f5d..e94f108000825 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -369,7 +369,7 @@ xrep_ibt_check_inode_ext(
 	 * On a sparse inode fs, this cluster could be part of a sparse chunk.
 	 * Sparse clusters must be aligned to sparse chunk alignment.
 	 */
-	if (xfs_has_sparseinodes(mp) &&
+	if (xfs_has_sparseinodes(mp) && mp->m_sb.sb_spino_align &&
 	    (!IS_ALIGNED(agbno, mp->m_sb.sb_spino_align) ||
 	     !IS_ALIGNED(agbno + len, mp->m_sb.sb_spino_align)))
 		return -EFSCORRUPTED;
