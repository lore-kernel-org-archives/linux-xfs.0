Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC62BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YstyTwCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCD2C433C8;
	Sun, 31 Dec 2023 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059403;
	bh=25eNxN3ivXryMrjBbLwTSaziGLWYh5G43ccyMTiIolY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YstyTwCMBLJ3R6LndMdd/VhfB8DujfNppFwkLYKS7U5eopbyqAsRI3z+JgwMZCF05
	 J/oyETvGA+GubfqI1K8X66fFeIXWnNz/0W1ayDrgCWeSAfM2gvuJTXphUlJfd78SH4
	 l5xc8qjSl3zK+wm2tGjKpvUqykisOabiROZROjStXV+X8rLCYNthng5MF6/QAi3nDr
	 rssOpj0WZaL8ad7Vs/CR3GHkq2zGaI2YvWwZh1Iz3wvCkfv67h90Zfzg44h2lhkAyN
	 03Ir7+9zklekpTEWOOL+/7ON7VXUGEVq4luVWFTEmfC60KFlIm2ob55vHZ51KPtkES
	 CqMJQEp1g/SbA==
Date: Sun, 31 Dec 2023 13:50:02 -0800
Subject: [PATCH 21/44] xfs: allow inodes to have the realtime and reflink
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851920.1766284.5827263861111762378.stgit@frogsfrogsfrogs>
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

Now that we can share blocks between realtime files, allow this
combination.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    3 ++-
 fs/xfs/scrub/inode.c          |    5 +++--
 fs/xfs/scrub/inode_repair.c   |    6 ------
 fs/xfs/xfs_ioctl.c            |    4 ----
 4 files changed, 5 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6e08ff8d8e239..ba37b864f6a8b 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -691,7 +691,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 5fc10e02b9c41..705865ec6c1c0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -359,8 +359,9 @@ xchk_inode_flags2(
 	if ((flags2 & XFS_DIFLAG2_REFLINK) && !S_ISREG(mode))
 		goto bad;
 
-	/* realtime and reflink make no sense, currently */
-	if ((flags & XFS_DIFLAG_REALTIME) && (flags2 & XFS_DIFLAG2_REFLINK))
+	/* realtime and reflink don't always go together */
+	if ((flags & XFS_DIFLAG_REALTIME) && (flags2 & XFS_DIFLAG2_REFLINK) &&
+	    !xfs_has_rtreflink(mp))
 		goto bad;
 
 	/* no bigtime iflag without the bigtime feature */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index f4f6ed6ef5120..8d67ae257e597 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -509,8 +509,6 @@ xrep_dinode_flags(
 		flags2 |= XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
-	if (flags & XFS_DIFLAG_REALTIME)
-		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (!xfs_has_bigtime(mp))
 		flags2 &= ~XFS_DIFLAG2_BIGTIME;
 	if (!xfs_has_large_extent_counts(mp))
@@ -1716,10 +1714,6 @@ xrep_inode_flags(
 	/* DAX only applies to files and dirs. */
 	if (!(S_ISREG(mode) || S_ISDIR(mode)))
 		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;
-
-	/* No reflink files on the realtime device. */
-	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME)
-		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 32a52799ae826..4559d122101cd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1119,10 +1119,6 @@ xfs_ioctl_setattr_xflags(
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    xfs_extlen_to_rtxmod(mp, ip->i_extsize))
 			return -EINVAL;
-
-		/* Clear reflink if we are actually able to set the rt flag. */
-		if (xfs_is_reflink_inode(ip))
-			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	}
 
 	/* diflags2 only valid for v3 inodes. */

