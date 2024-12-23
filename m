Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA3613FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991641; cv=none; b=NrfnfDShBsD34/LNp4BKkUA1VU9fYYuqZSSy7BT8A8NYhjCc3YkZpRWusUGgnI0rKd0valc6WU4uM+MN9OL3R/42AkLCzcxXJb4z3btZd8QMml+6UsPRuTDJ7uf2ibr54qi9g1xzDmOVvuiThwbOUIvFK/A0+EI4w9LTKhml35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991641; c=relaxed/simple;
	bh=1ko9BkVvdHtwct/2cvCqMbwRgng3HpxgzB7+bZWbebc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLOoB8D3goBt8XhWcTQBcFiv07DL9sCoQhHhSmf8bkaGnKKXi/rpwsHO+nLd6UT4SuCSFMv1dj5yJ2g1d3bwLJtvQVUMjO7ajTPU7s2P++bvAKczw2rg5FDTp1pt+Nol1sU4UGzlLpNOJjAhPzzW7oDkhUEPXtTTtdM+6lx2F9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Avd8o0zQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Avd8o0zQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BE5C4CED3;
	Mon, 23 Dec 2024 22:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991641;
	bh=1ko9BkVvdHtwct/2cvCqMbwRgng3HpxgzB7+bZWbebc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Avd8o0zQQMPLeUxBXm5i+xHDvlq/T0ux1//7VqsnDc1SYyX2tnsLVuY4fvuaUU8v/
	 KdOmpcMEaGLpmQrFVxCOizrgl5FS0S5tFrOmIvyVwJXYXbBt/2i7i5SLimeW6rtsJ3
	 4/uvPN3mvmx9Bh0+UP5h3vyJA4U3bJ5UAnp19DbbrCZ50737R4v1AUJHteE59xGNVD
	 BygrqzPHcjNj75yU7CL2ym6FiZnGmSjMD6SHQwtIvBLdV5jLtKSav/hxDNpYMMyF5l
	 T+C9XAFI1JgFTFkSddBZ7vWV1dcHQ7N1xy/R/JgnVY2a1VcVWd3yJtQFwkhGnBJJPX
	 v+1wWuptmxJow==
Date: Mon, 23 Dec 2024 14:07:20 -0800
Subject: [PATCH 35/52] xfs: adjust min_block usage in xfs_verify_agbno
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943033.2295836.18172347903363428667.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ceaa0bd773e2d6d5726d6535f605ecd6b26d2fcc

There's some weird logic in xfs_verify_agbno -- min_block ought to be
the first agblock number in the AG that can be used by non-static
metadata.  However, we initialize it to the last agblock of the static
metadata, which works due to the <= check, even though this isn't
technically correct.

Change the check to < and set min_block to the next agblock past the
static metadata.  This hasn't been an issue up to now, but we're going
to move these things into the generic group struct, and this will cause
problems with rtgroups, where min_block can be zero for an rtgroup that
doesn't have a rt superblock.

Note that there's no user-visible impact with the old logic, so this
isn't a bug fix.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c |    2 +-
 libxfs/xfs_ag.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index bd38ac175bbae3..181e929132d855 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -240,7 +240,7 @@ xfs_perag_alloc(
 	 * Pre-calculated geometry
 	 */
 	pag->block_count = __xfs_ag_block_count(mp, index, agcount, dblocks);
-	pag->min_block = XFS_AGFL_BLOCK(mp);
+	pag->min_block = XFS_AGFL_BLOCK(mp) + 1;
 	__xfs_agino_range(mp, pag->block_count, &pag->agino_min,
 			&pag->agino_max);
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 7290148fa6e6aa..9c22a76d58cfc2 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -222,7 +222,7 @@ xfs_verify_agbno(struct xfs_perag *pag, xfs_agblock_t agbno)
 {
 	if (agbno >= pag->block_count)
 		return false;
-	if (agbno <= pag->min_block)
+	if (agbno < pag->min_block)
 		return false;
 	return true;
 }

