Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30053BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="srzeFgxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C73C433C8;
	Sun, 31 Dec 2023 21:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059325;
	bh=Rb40IupmMO4A0f84lfwwcei8JkEIHlY9wfK/fS8CDig=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=srzeFgxfX1C4xuk8kwoVY3CC9SwQDYdyFQwQmmi5g3Nr2sgzjOGf1svxNvsu4DzPK
	 ASpcnTbTI+JJ58ic62r9fGeGbKWnEvsvRyoVWLSFN8ILl9AhW4wE47ipTTp3wdUOW7
	 oXUJMJd7GtROBPy35gn1jl14QHW8+Ag/fZXIsUp4FiMhCH3LUvJGfb5BRuRBQEJZKG
	 OFQz2QfwPn+/zwoVHtf48Hrgu+6ZaAWnkZ6Ml3y92t6bPIJUDLfVwPgxBp76JhFSnm
	 uFxc+ip78RY7Tmp83TotHFOguUKY1aGfyFYlgUmkrwYhvchr5XfSMv4kJjFvgv1EuM
	 JeXpWf0ARdqfw==
Date: Sun, 31 Dec 2023 13:48:44 -0800
Subject: [PATCH 16/44] xfs: update rmap to allow cow staging extents in the rt
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851841.1766284.13724389503376391627.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 43108a195004c..501427d2f38cb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -276,6 +276,7 @@ xfs_rtrmap_check_irec(
 	bool				is_unwritten;
 	bool				is_bmbt;
 	bool				is_attr;
+	bool				is_cow;
 
 	if (irec->rm_blockcount == 0)
 		return __this_address;
@@ -287,6 +288,12 @@ xfs_rtrmap_check_irec(
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
@@ -303,8 +310,10 @@ xfs_rtrmap_check_irec(
 	is_bmbt = irec->rm_flags & XFS_RMAP_BMBT_BLOCK;
 	is_attr = irec->rm_flags & XFS_RMAP_ATTR_FORK;
 	is_unwritten = irec->rm_flags & XFS_RMAP_UNWRITTEN;
+	is_cow = xfs_has_rtreflink(mp) &&
+		 irec->rm_owner == XFS_RMAP_OWN_COW;
 
-	if (!is_inode && irec->rm_owner != XFS_RMAP_OWN_FS)
+	if (!is_inode && !is_cow && irec->rm_owner != XFS_RMAP_OWN_FS)
 		return __this_address;
 
 	if (!is_inode && irec->rm_offset != 0)
@@ -316,6 +325,9 @@ xfs_rtrmap_check_irec(
 	if (is_unwritten && !is_inode)
 		return __this_address;
 
+	if (is_unwritten && is_cow)
+		return __this_address;
+
 	/* Check for a valid fork offset, if applicable. */
 	if (is_inode &&
 	    !xfs_verify_fileext(mp, irec->rm_offset, irec->rm_blockcount))

