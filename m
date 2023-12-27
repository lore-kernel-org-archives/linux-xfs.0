Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1D384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ouVTf9bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC683C433C8;
	Mon,  1 Jan 2024 00:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068972;
	bh=LDgSF+gSQEZWozEs5PVQ64vYpARVyrxbBfZlRKA30XM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ouVTf9bpmpjXJPc4ICM2PPSRwusdXsMDpMJ48KFGy5pS0CR9vZwVGaKix35tWDOvj
	 nAHaP4+oPC6dHHsjC8T8l3WrZVqIuRiDG5hLYbQ+m9R4SAnZqghKKftL/Pqm0xKY0l
	 6H9QyqWUupgDz6DwvCPL+kLXj6VkGSzqsy28YQwKvKT2GBdEYga1IensS6QpGA67bx
	 ktmhqiQzw0XRjI8T6ed71irwyAspYXYxCvM23a+MhUfI9mXt4oUd3WBIyyPfnAbpRe
	 bzT1gZIyqOM3LF2yaSeS/yxzJwMeQ2RDW15pMCv7FRtVNs70F/gc8+Y5ejzw6rSgyF
	 Jz3Dz/uZIo3cQ==
Date: Sun, 31 Dec 2023 16:29:32 +9900
Subject: [PATCH 13/42] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017299.1817107.15972227651180584816.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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

Don't error out on CoW staging extent records when realtime reflink is
enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_rmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 0056dc08662..acee6a36fb9 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -275,6 +275,7 @@ xfs_rtrmap_check_irec(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				is_cow;
 
 	if (irec->rm_blockcount == 0)
 		return __this_address;
@@ -286,6 +287,12 @@ xfs_rtrmap_check_irec(
 			return __this_address;
 		if (irec->rm_offset != 0)
 			return __this_address;
+	} else if (irec->rm_owner == XFS_RMAP_OWN_COW) {
+		if (!xfs_has_rtreflink(mp))
+			return __this_address;
+		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
+					    irec->rm_blockcount))
+			return __this_address;
 	} else {
 		if (!xfs_verify_rgbext(rtg, irec->rm_startblock,
 					    irec->rm_blockcount))
@@ -302,8 +309,10 @@ xfs_rtrmap_check_irec(
 	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
 	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
 	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+	is_cow = xfs_has_rtreflink(mp) &&
+		 irec->rm_owner == XFS_RMAP_OWN_COW;
 
-	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+	if (!is_inode && !is_cow && irec->rm_owner != XFS_RMAP_OWN_FS)
 		return __this_address;
 
 	if (!is_inode && irec->rm_offset != 0)
@@ -315,6 +324,9 @@ xfs_rtrmap_check_irec(
 	if (is_unwritten && !is_inode)
 		return __this_address;
 
+	if (is_unwritten && is_cow)
+		return __this_address;
+
 	/* Check for a valid fork offset, if applicable. */
 	if (is_inode &&
 	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))

