Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160EA2F4A
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052544; cv=none; b=Xh1XMeQtH9/Z+iFbx//rVPDVN8N40ZaYVBL/TdetZCzwihj05OJVHJvTc5pGsQu3WOf2c9G9nRribv1A0S+0pyH5gQkedDr6NQI9ESdzEOSz5gbllFVKHJiIikaaMZeE7KJtwvtiSKqlj4TDKI9zqaIJAgdyq3EWscZSXVxCH2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052544; c=relaxed/simple;
	bh=PoSCXuC0xyj5XUSfiG6AhMuOh7JLIN2RGgS8+pOhyAM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jw4sGs8stxoKz7tYXH+GvDImrUIUM+DYKuxQtLH9a43qG+6z9d2ukli6XfgO0rl7k3iTzwOOb9Jd2c57jwPaIKgxgUdaIE+K0jQnnPCPlORYVPMKthE8FVeKsojZfBG1UwPcZfSP+9RGxzvB4sP3mSyINk2Ym26bw62fFVWuwfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N/ZEoyy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N/ZEoyy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D3CC4CED3;
	Fri, 13 Dec 2024 01:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052543;
	bh=PoSCXuC0xyj5XUSfiG6AhMuOh7JLIN2RGgS8+pOhyAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N/ZEoyy7FkRXLfBU4iVNLvNwo1sjHOMV9N5JunA9JoJKGwzv/Ro38vtHvh8Cpgkmi
	 HpfbUWpnTZzEdHNjNHP17aAY2ybHgf7KN4YwV/RNWAUQOaymff2ifzfdPuVx4XKa8i
	 6MQiiK2x9J9k4QL5maonoHL/lP2h8wNZMlUn3WcePxEK4hP5k5D/WOCJfqFGEhQLS+
	 4Kb+zdcvFvd9HzuR5qIcM5g9K2gaVyjbO2Sia6CmURSDJZqPlYypD9a+e/iw87OP0q
	 ikjF8AVpLM7lQJJe5n03U+DJpCEeV6PWbzyOoFo7FDWl63OKunlcK4QwCeiGMf7lvB
	 xx7u5yis9W/MQ==
Date: Thu, 12 Dec 2024 17:15:43 -0800
Subject: [PATCH 21/43] xfs: allow inodes to have the realtime and reflink
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124927.1182620.3219838636826332787.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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

