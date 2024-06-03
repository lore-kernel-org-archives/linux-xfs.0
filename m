Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DA282D94
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442319; cv=none; b=BViX4fpY+sJf4u5ckqlKjFDI/qWUpOeCSNgRUrfUvhdizKqBoY2h9GpzIF6ZdfEz5+6fafKwFCwUhovIM82bRRyMU50iFQDmB4MuBaoSxZ1ANstDZ/0VssThsfIk1UFwnHzaKOZ+Tfa0KwipyoBypVgYYjkt60YivQ2ChGoaZgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442319; c=relaxed/simple;
	bh=QmIVNLCYh/8QTCTv4hxUQSpsvmlcHyqn+GwRdGVaevc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pu08XZN3Q4FnssOlMeFPPAG98XcNNLrX4Htty1qd5MtOdWT4cfjd1E6XHPtmu+aQQldGSKhMmAv2TEWlHyXbjf9wFFsyd2OAnwNuA1SHCFxe2igHQxbTHJ4emxLSFw/IiUv82j53ITpbFPKdPwKnNk5IjsZ1Scb9QBxbm+vT+2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eErGL8G7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eErGL8G7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33366C2BD10;
	Mon,  3 Jun 2024 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442319;
	bh=QmIVNLCYh/8QTCTv4hxUQSpsvmlcHyqn+GwRdGVaevc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eErGL8G7x/oxaPsLmiFnzg39o1eHVYvEAZKAQubxhLUc0u7XNlCAkR/P1py2B/Sgs
	 JW8MfNx5dETP8fvLsGt7YLc6pNozieb0p3WTY99UDP6dr+tu0p/25AC275vxW098cZ
	 if8gE6+n4aLlB938B3XSNDXju+nCqVyMTgHxhAQ1OOdy7VNtpxMLQzWoj6hdvyv1D2
	 S16NvFKCWKLOx9DEkHKnYs6Z/w3iwvEizNp6DQuOk/snD8Qf9qpfkkYmby1iJB3mGS
	 Tq7wtwBcNufj8tTZga8fgoIpB8+qdtQzEoYPcuR3L431OmC2VNq1/pCDEbe819VCju
	 WunlAxuV8+3Ig==
Date: Mon, 03 Jun 2024 12:18:38 -0700
Subject: [PATCH 102/111] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040898.1443973.4991917877682473923.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

