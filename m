Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78322C12D
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trN5fesZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484B6C433C8;
	Sun, 31 Dec 2023 22:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061514;
	bh=vSxW5iQTZ8aDGGfn2RooVk0Q+p0sfZDhXfGxnh+ZxVI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=trN5fesZM+SmYEaBroramb7+SwWn93IEm6Vr86wmROo80NiNp/96PUuO8DbcVNN6H
	 mHmgB0OImxCGWWvOBNVPjkBV6syGtheCuiWhqn17g7xyQFUO8Lsi4aZkLqScwVlOO3
	 nq23ubfQOt5ymJxGpvqBu3aIHBYnp+4hiiLo7xsOxY6mpuVRXsJJLC9DfHg3s8M10G
	 BqM5gkWD5VizP/mPYULqx4hTMtYU5JbE8MOH0KoMwU5FT3o2JPo8wnakrAApdQrIlR
	 9UU5sfrW0jikhuGE2BCGJ1RJLSOvmX+xtUvP5kYEW691lMZr+CptAuPn6XY64B7AU+
	 7eQjznUBrbL7w==
Date: Sun, 31 Dec 2023 14:25:13 -0800
Subject: [PATCH 1/2] xfs: fix xfs_bunmapi to allow unmapping of partial rt
 extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404995213.1795774.508500796488164613.stgit@frogsfrogsfrogs>
In-Reply-To: <170404995199.1795774.9776541526454187305.stgit@frogsfrogsfrogs>
References: <170404995199.1795774.9776541526454187305.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 69ed4150c5e..b0747e57e90 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5425,7 +5425,7 @@ __xfs_bunmapi(
 		if (del.br_startoff + del.br_blockcount > end + 1)
 			del.br_blockcount = end + 1 - del.br_startoff;
 
-		if (!isrt)
+		if (!isrt || (flags & XFS_BMAPI_REMAP))
 			goto delete;
 
 		mod = xfs_rtb_to_rtxoff(mp,
@@ -5443,7 +5443,7 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(end >= mod);
+				ASSERT((flags & XFS_BMAPI_REMAP) || end >= mod);
 				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
 				if (end < got.br_startoff &&

