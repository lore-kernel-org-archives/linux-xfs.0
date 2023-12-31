Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8034ABA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qye/AfOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFFEC433C8;
	Sun, 31 Dec 2023 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054145;
	bh=tj7/I0mk2Nm9v4PcSxgDdzlDPr3p2V5qigdBWpXQZQU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qye/AfOECO+JPJ1r7jGtbhgRmHT8MOE7kfM+sCN+aneCoFmNP6HihSr9ymqhJqW/l
	 q8gEE328bLBtmTTKm/gr46GS8xBterZmj8QiamuUalXJN3AezxHbOm4Oh3EwqzRWkE
	 nSDlc3LS66hpROUSWJW5EASiuD1hSz4ElczTzWaJ2aPNUSmxtziVZeNy1vNZYtndJ7
	 rSb8UCpQ/TO7trYjnjxfOJZq/ZURBPIrMMu47C9cFwwH6gLVnx7ANmLOs2DXcBmuaw
	 JUa/YqiqhCPFiMI0MlwxH0iiNkPdHS7lioH5ZBdVpleYP3eCsJUl4+ytcZEM+ZfaWD
	 bWZlYV5kvXCiA==
Date: Sun, 31 Dec 2023 12:22:25 -0800
Subject: [PATCH 1/3] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831892.1749931.10507668815062235816.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
References: <170404831869.1749931.14460733843503552627.stgit@frogsfrogsfrogs>
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

When XFS_BMAPI_REMAP is passed to bunmapi, that means that we want to
remove part of a block mapping without touching the allocator.  For
realtime files with rtextsize > 1, that also means that we should skip
all the code that changes a partial remove request into an unwritten
extent conversion.  IOWs, bunmapi in this mode should handle removing
the mapping from the rt file and nothing else.

Note that XFS_BMAPI_REMAP callers are required to decrement the
reference count and/or free the space manually.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3df6856cf4872..bf20267cf6378 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5431,7 +5431,7 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		if (!isrt)
+		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
 		mod = xfs_rtb_to_rtxoff(mp,
@@ -5449,7 +5449,7 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(end >= mod);
+				ASSERT((flags & XFS_BMAPI_REMAP) || end >= mod);
 				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
 				if (end < got.br_startoff &&

