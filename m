Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F4717993
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529629; cv=none; b=QzWzRj1ofYXLw/EoggivI1bSyQ+dtSF6di9nJ7Z5zsVZfshMNrjl2CZmR9eTJvBwwIxhuMl8rHYROppayw56lA8LwE4E7NustKjyni+UWTvOkbYn86/WMy7qJSSVaJiphfHs/rfOKBAIY3s863GzU0YkRQITV7lKRrgpam4v2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529629; c=relaxed/simple;
	bh=1ko9BkVvdHtwct/2cvCqMbwRgng3HpxgzB7+bZWbebc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iD8gaWtEX4msBBy8vmv3eRY0Hnh+ZxEU3vYtlbzad8GgovQ/ogxWwfmLCCSYX359idKxq7T0Iz3juqqr2wzFzaXNLeAmf5PAqNOtXBPCvHnqunTuqNvxexG1ItP4vNJo7YdTQtcEPwdtWXRYdYAmZEXt2SzHWPV01My+d7HGfvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hK/v+M7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hK/v+M7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150A7C4CED1;
	Sat,  7 Dec 2024 00:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529629;
	bh=1ko9BkVvdHtwct/2cvCqMbwRgng3HpxgzB7+bZWbebc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hK/v+M7ZuNIt5Xl+hHi/m3r04cbvadtEmq3a1/oNzs1AH0L4prbORnsljWhyF3umN
	 4f9yanuzdl/SYZcFi5CtpW7X+cjSjaI1OtOnvpcwFsnmVY/1dgUiYDRW3ZeMaAvkUt
	 TYxL5OkQIKbTNTQgkAJqtiV/i8eT7eBs/S2p9QjePKZBefOP5Zs+6OJbXNH/WHkPnn
	 ohkcndk9Ci1T0K1y/f2dSfUhrWd201cV5KB+o6Bi8V/09s36kseYMx8cvyZNnxyUoO
	 EwtEKW03DvBoO1jLpff8c4dIbaDlSayRucGZ84vmORUcOAL0uPMpFQuaga08L49Q5w
	 IvqimarwsxRHQ==
Date: Fri, 06 Dec 2024 16:00:28 -0800
Subject: [PATCH 35/46] xfs: adjust min_block usage in xfs_verify_agbno
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750530.124560.13470906129876479837.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

