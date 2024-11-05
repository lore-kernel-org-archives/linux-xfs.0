Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3151CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846216; cv=none; b=WRDTicBfi5cAiJ/6eiJ8cCcN/RMsFUZvbSp5mZgNYaddxUm4OvT3eQiwpdTwGH2Iq17gjMOXPGRS1swmVkKS3eCvnNu0jTVWNS39C/nd8ECo/6w8lxfvMWyUE8bS1Y0nzyC/VaPTp3iQR/vtgth0QNSZa/feYTpc9vxygt+cTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846216; c=relaxed/simple;
	bh=PCIe5B7FN97E3xmwJ206m9uQprJwIr3spUNasC3Fw5I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlGOTsnw9Jc/l4j4bdJU5DpfOoVZbLAUhGekOID5tPFJZdOciUNoGYUgQwKmK1SKW5edkyKqNXxX+DnnNP/vE3XtuvkXrnZBQf14POCJu5XMW7vRH5Na4YzpnmVXPNJWKMnGC5Hk5P8E81opnfDXMr0bgIJDlqrC/267dVZzFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GHzP0rvS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GHzP0rvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C535C4CECF;
	Tue,  5 Nov 2024 22:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846216;
	bh=PCIe5B7FN97E3xmwJ206m9uQprJwIr3spUNasC3Fw5I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GHzP0rvSRj9ZgJ+qzeWimcGyU6b1nGaeaLyAeeV7LEROzliaZVuZ4MZWadZlELSKe
	 yOi3fnZCvls+YmX6qaLi9DrSnhGzMGmzNjKlPPfquuyW6fl39EBxhaVZQfgMIIlzls
	 ZE40zm1IiaRf4BRQy6LYEXAG3u/R7tQ3j1u6j1agtdIkFTkJUA+gen5M1PLImsgbaC
	 NoVjDDsfTgWJYeqZqc0rpAmoLJ6KAM4Yjiv7MDVHIDE7zTWbqh+VUw9n901sdpUtAm
	 XeynGR1fXWiYv7XdEL9D9uU0YYnk0aTx4r6mk0FGCHYRenHirLB9Kmcto/NNvRlFjB
	 d76dmoviH8+YA==
Date: Tue, 05 Nov 2024 14:36:55 -0800
Subject: [PATCH 27/34] xfs: create helpers to deal with rounding xfs_fileoff_t
 to rtx boundaries
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398645.1871887.5081702992702241647.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're about to segment xfs_rtblock_t addresses, so we must create
type-specific helpers to do rt extent rounding of file block offsets
because the rtb helpers soon will not do the right thing there.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.h |   17 +++++++++++++----
 fs/xfs/xfs_bmap_util.c       |    6 +++---
 2 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 7be76490a31879..dc2b8beadfc331 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -135,13 +135,22 @@ xfs_rtb_roundup_rtx(
 	return roundup_64(rtbno, mp->m_sb.sb_rextsize);
 }
 
-/* Round this rtblock down to the nearest rt extent size. */
+/* Round this file block offset up to the nearest rt extent size. */
 static inline xfs_rtblock_t
-xfs_rtb_rounddown_rtx(
+xfs_fileoff_roundup_rtx(
 	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtbno)
+	xfs_fileoff_t		off)
 {
-	return rounddown_64(rtbno, mp->m_sb.sb_rextsize);
+	return roundup_64(off, mp->m_sb.sb_rextsize);
+}
+
+/* Round this file block offset down to the nearest rt extent size. */
+static inline xfs_rtblock_t
+xfs_fileoff_rounddown_rtx(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	return rounddown_64(off, mp->m_sb.sb_rextsize);
 }
 
 /* Convert an rt extent number to a file block offset in the rt bitmap file. */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index bc53f5c7357c7a..1fe676710394e1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -541,7 +541,7 @@ xfs_can_free_eofblocks(
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
 	if (xfs_inode_has_bigrtalloc(ip))
-		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
+		end_fsb = xfs_fileoff_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
 		return false;
@@ -863,8 +863,8 @@ xfs_free_file_space(
 
 	/* We can only free complete realtime extents. */
 	if (xfs_inode_has_bigrtalloc(ip)) {
-		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
-		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
+		startoffset_fsb = xfs_fileoff_roundup_rtx(mp, startoffset_fsb);
+		endoffset_fsb = xfs_fileoff_rounddown_rtx(mp, endoffset_fsb);
 	}
 
 	/*

