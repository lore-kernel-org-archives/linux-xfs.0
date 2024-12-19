Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DF719884C
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637110; cv=none; b=IcOIob0Wf9SjbPrgqJ3LQNh8d+L6gXWHA+7wA/2Cv823CtYz91A2f3fvbSnVp6lJ9+3nsLvJktRxUosmCYoD+yz/b05L0q3W68juDaWi/wD+mzHwzga6Ui14RskQnB733WU4UL1vFJanFzd+ovluzaGQUxbU8UH3ZZnnT0nwdTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637110; c=relaxed/simple;
	bh=eKrvap0A7dc5lsWpWCkzOsqhx8kRWHDiYveWjQjWIKI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRhiIy6a/KWEJzgz9jy73XESwSXt+/9dxrwmVgCql/80ynmCEUrFhVeL3cD8rb7KW3ZZ5bYITePbhCDKTkF970pc0tW5UY1d7/XY+nDqlJM6hbO5gNl/DAL+SNhhHGfu2c3tjKB8c5qEo7jRLUIAsFjmmsGnRB5X6rKWN5Fflmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOg6+Fo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOg6+Fo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF803C4CECE;
	Thu, 19 Dec 2024 19:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637110;
	bh=eKrvap0A7dc5lsWpWCkzOsqhx8kRWHDiYveWjQjWIKI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XOg6+Fo74WY/qIL+5wCYQ4Ho1rP+KuJIM6JpbJlxqwMR46VegHq1pXKgd6ZdOuIuk
	 Kv9RZKPHFT4X5iS0cBUQGQZFbie5zGXtX6Q/YW3BM2ZwAKeDShADBtrjxzMzV7JyXQ
	 w2trBDXSt+RZnAyvAN8jls+ouGQHxWx9bnw023ouPoEq8Lc8OYv53cBByOCuykP9Pz
	 zO/AOj2DpXpNDrghEyPlxr5yF75lEjj7wY6nR9UHWGvum/2+0EcFAFr1clL2ygSDOD
	 OB2vxfT9qkroc3Br/+Dy1MkeUX1GW24L3qv5bK69eNUaIEPux7/5GeMLq1aI+963Ik
	 e1XyMKKpkrbTw==
Date: Thu, 19 Dec 2024 11:38:30 -0800
Subject: [PATCH 21/43] xfs: allow inodes to have the realtime and reflink
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581337.1572761.5681483291096817147.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |    3 ++-
 fs/xfs/scrub/inode.c          |    5 +++--
 fs/xfs/scrub/inode_repair.c   |    6 ------
 fs/xfs/xfs_ioctl.c            |    4 ----
 4 files changed, 5 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 65eec8f60376d3..4273d096fb0a9c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -748,7 +748,8 @@ xfs_dinode_verify(
 		return __this_address;
 
 	/* don't let reflink and realtime mix */
-	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME))
+	if ((flags2 & XFS_DIFLAG2_REFLINK) && (flags & XFS_DIFLAG_REALTIME) &&
+	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
 	/* COW extent size hint validation */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 8e702121dc8699..c7bbc3f78e90b1 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -360,8 +360,9 @@ xchk_inode_flags2(
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
index d7e3f033b16073..938a18721f3697 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -564,8 +564,6 @@ xrep_dinode_flags(
 		flags2 |= XFS_DIFLAG2_REFLINK;
 	else
 		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
-	if (flags & XFS_DIFLAG_REALTIME)
-		flags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (!xfs_has_bigtime(mp))
 		flags2 &= ~XFS_DIFLAG2_BIGTIME;
 	if (!xfs_has_large_extent_counts(mp))
@@ -1790,10 +1788,6 @@ xrep_inode_flags(
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
index 0789c18aaa1871..4caf29cc59b9ef 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -541,10 +541,6 @@ xfs_ioctl_setattr_xflags(
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
 		    xfs_extlen_to_rtxmod(mp, ip->i_extsize))
 			return -EINVAL;
-
-		/* Clear reflink if we are actually able to set the rt flag. */
-		if (xfs_is_reflink_inode(ip))
-			ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	}
 
 	/* diflags2 only valid for v3 inodes. */

