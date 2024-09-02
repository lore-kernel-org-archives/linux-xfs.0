Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FFF5680
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301889; cv=none; b=XaQO6ORudeJoVK2bzfqP5JLRK2TU8UdM6fhR2MSI3IvvlEkdUHrH9TTwDXa6N5Cx5EHsdixeC0dxcg2rECPPi+lcc73LacuR70jlIijOfRskSG+AOQeRL6V+IA42poLZYzBQlfE9w7UP3PeXu2wFQLMqL2Z+OCtAdt0P++6HG+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301889; c=relaxed/simple;
	bh=0lNZzySYQGI4zCqXwTpEsDhQudXf8B3ZCofP60QyiD4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FD9gevPg2dVUBGRLFg7ufjVgycsr3SH0Tfdz2a+isdmjAfB+5aIhj/IC4HzShY8BLYESFBXDxHjEykNeV7wFvry3x4c8i0NTE77uId85rM+FWAXDp8725mUOv3TBOFzJTQ3ltPw7aeN3KnzEdeBC1i3I8+QBRSH2LxfB6dkbzio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baNPILqV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baNPILqV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD2C4CEC2;
	Mon,  2 Sep 2024 18:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301888;
	bh=0lNZzySYQGI4zCqXwTpEsDhQudXf8B3ZCofP60QyiD4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=baNPILqVr2gp4p4MoBiTa2DXvVGQnL7821xWkl6D2IMvyvGn93u3uigkvFpSailDq
	 F7YOn+nPXpII+mpSG5NXRcnpPvh6A8jNx0zHUvgqewH+3BumcKYPIEf3XbzUirm+AV
	 jsoWlZooOfSvMJFRunjL8UyVILixVi6vrzu2+83m8he8G0awjgw3sMHpqCnHGyoO/E
	 vMia6yUXuIxKYRvv+dUbJI4LVG7EIJHMLywjYznhNFuCiZ0M+BO0XvTGnzFRnte0HP
	 zuz+JUBSDMJ2SFHk2bObpk5+Crne+I62wRAI6OheEQuyR6SV1pH4Ytcr1os+r9it69
	 737CcTQig5RTA==
Date: Mon, 02 Sep 2024 11:31:28 -0700
Subject: [PATCH 07/10] xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530106881.3326080.7304548688608203352.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_rtbitmap_wordcount and xfs_rtsummary_wordcount are currently unused,
so remove them to simplify refactoring other rtbitmap helpers.  They
can be added back or simply open coded when actually needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   31 -------------------------------
 fs/xfs/libxfs/xfs_rtbitmap.h |    7 -------
 2 files changed, 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index c58eb75ef0fa..76706e8bbc4e 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1148,21 +1148,6 @@ xfs_rtbitmap_blockcount(
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
-/*
- * Compute the number of rtbitmap words needed to populate every block of a
- * bitmap that is large enough to track the given number of rt extents.
- */
-unsigned long long
-xfs_rtbitmap_wordcount(
-	struct xfs_mount	*mp,
-	xfs_rtbxlen_t		rtextents)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
@@ -1176,22 +1161,6 @@ xfs_rtsummary_blockcount(
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
-/*
- * Compute the number of rtsummary info words needed to populate every block of
- * a summary file that is large enough to track the given rt space.
- */
-unsigned long long
-xfs_rtsummary_wordcount(
-	struct xfs_mount	*mp,
-	unsigned int		rsumlevels,
-	xfs_extlen_t		rbmblocks)
-{
-	xfs_filblks_t		blocks;
-
-	blocks = xfs_rtsummary_blockcount(mp, rsumlevels, rbmblocks);
-	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
-}
-
 /* Lock both realtime free space metadata inodes for a freespace update. */
 void
 xfs_rtbitmap_lock(
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 0dbc9bb40668..140513d1d6bc 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -316,13 +316,8 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
-unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
-		xfs_rtbxlen_t rtextents);
-
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
-unsigned long long xfs_rtsummary_wordcount(struct xfs_mount *mp,
-		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
 int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
@@ -355,9 +350,7 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	/* shut up gcc */
 	return 0;
 }
-# define xfs_rtbitmap_wordcount(mp, r)			(0)
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
-# define xfs_rtsummary_wordcount(mp, l, b)		(0)
 # define xfs_rtbitmap_lock(mp)			do { } while (0)
 # define xfs_rtbitmap_trans_join(tp)		do { } while (0)
 # define xfs_rtbitmap_unlock(mp)		do { } while (0)

