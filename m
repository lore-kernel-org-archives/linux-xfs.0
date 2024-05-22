Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833C81E498
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347723; cv=none; b=cILibQmbDmyei8KPmGIgBE0lmVl6h3VZRYMtefGh4EHtHbgaecOFzwgy2PMGsXDwMsO0VZvds3zALmP8CnG7c4CSQo6htuTTYHsTW17qAE96C+43XpvbLJGMn3dwTvDtgA6PcCQUw3fm9gNVumgKKbK2Jnx+D5FNspS0h2V9ntw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347723; c=relaxed/simple;
	bh=ma/SH4XburZjxuKKdYtVavy9Q6WmapeCQANpcZlOw4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r9SLvPEb0JhN6jEc8xKqij2Z8xXwfALZhxkSdPvPKl7lMuDqBbZq1KKPy+F+7E4j2SXRB8Ptp7c46QOWb520OWT8ipzzFbzCI/XfofSdrHZ+lSo9HO4/ZXucFMl18F0WMFO7/gvPa1mttUFLixt3I0U/JgemEZ3BKRk4OMGmz7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qhgHxggL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qhgHxggL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F12C2BD11;
	Wed, 22 May 2024 03:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347723;
	bh=ma/SH4XburZjxuKKdYtVavy9Q6WmapeCQANpcZlOw4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qhgHxggL/T/UR0IVTjkipnPth/xR9xCW/7z7OpD64w/A+VHl3im8UjGqbD+NB4H0O
	 yuDcCgQQnVde0umBtGMGw/TitHNfGXUKGfdlx8CrsA3cEtLKgNIplEteKrX+GqM79t
	 mYqZCTEm/m89wMBhJf8cDr21JKv/JQkdJvzUXpHW0WwulG7Io+sd0FD9Z4TqKo9pSe
	 p1/tfpEDthR/eMDDDkfd1kk/XgA8qUgvOttatqXIyq8J/11+9CwnK/ZeavSSPK39Ks
	 1ZpvgQXozbpXykkHzc46o1A8c7owShZlnmYT/JzzANaWZpT8amgepjISS4OZzysocm
	 72ZOUOsuH/RYw==
Date: Tue, 21 May 2024 20:15:22 -0700
Subject: [PATCH 102/111] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533233.2478931.1181500881974935567.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2b6a5ec26887cba195022286b039f2cc0ec683b1

When XFS_BMAPI_REMAP is passed to bunmapi, that means that we want to
remove part of a block mapping without touching the allocator.  For
realtime files with rtextsize > 1, that also means that we should skip
all the code that changes a partial remove request into an unwritten
extent conversion.  IOWs, bunmapi in this mode should handle removing
the mapping from the rt file and nothing else.

Note that XFS_BMAPI_REMAP callers are required to decrement the
reference count and/or free the space manually.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 07bd8b346..388550912 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5453,7 +5453,7 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		if (!isrt)
+		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
 		mod = xfs_rtb_to_rtxoff(mp,
@@ -5471,7 +5471,7 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(end >= mod);
+				ASSERT((flags & XFS_BMAPI_REMAP) || end >= mod);
 				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
 				if (end < got.br_startoff &&

