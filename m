Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3712E21353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425303; cv=none; b=WlM+tr2mrWLnhHBi8nVgsc63TQeemEm5kyBjHHXOXC8gIa5SP/jHY85eNpSRoUx7zVWX6Rw02TFgaSWFgPYlOJZlxOOQ5BrPmbEgxtWY7sxzLwUwSsFNb7isHcllptR2gtrQEAzHf2O202E/+yyGDGN5yppajrjkcqIk67VF7iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425303; c=relaxed/simple;
	bh=iTP2gsR6hA0DbN2uhLp5FmcaX62Wi2GgMl280XvlKow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCZlquYtIcUZEN0BIoZV7pD0tvcosr75c52A9A/28DQgYaY7EHEtj2naoo8SWYGeeyWPh4UgE2rwmL+NTq7bd7zqKU37lKg5VCRWqbqvmpiI5zv3UFhQQOm4XflNkirW511FAsZPlTN/nHmtWKlP8UAlybUMBkO89Qkjvorfu1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcZMz2vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcZMz2vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F58CC43390;
	Tue, 26 Mar 2024 03:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425303;
	bh=iTP2gsR6hA0DbN2uhLp5FmcaX62Wi2GgMl280XvlKow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NcZMz2vrpiLP5V0pUtk6pioecoYQcQ9v/TlvmMx8vHPDzFz7oBVMjv9sOn1gz0cje
	 8WaSTNbpXOUyCEhzCKtqsxH6i8iQdtnCXWTmyCCXF+B3M+1rWlUztkYETt1lyTmQqc
	 gHFBiXdBUa7Xaj1QrRgx4Lg8N2QTXTHsj7LtMMlwt/VA+zmgIfk072Uq43pmGt54pr
	 GI13KC9GhTLtVQaimASRXcelOx1vgOqpB8Fsv4Oh/oh+kyT1I6OHXXHjhq/qKo23XZ
	 sKPN2puZojuYkwM6+1QmQTmo093BxV0ONmlcoNGvGU7J+NVH02ahdzrKN+1sHB+hYy
	 unRa1Nmgj4SGA==
Date: Mon, 25 Mar 2024 20:55:02 -0700
Subject: [PATCH 102/110] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132848.2215168.8963838411567979606.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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
index 07bd8b34635a..38855091283c 100644
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

