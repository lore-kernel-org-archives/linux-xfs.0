Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D513FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991531; cv=none; b=qAu8fGwzaJyxhY3NTyDfs/hRAZds/CsD4kk2xYdvqkxaqz4/mp1YqnKVm1JwR3UPF1BteYiQN3yoTQmXhdc1p5wTCylySAlUHgivs0HznFI7SYB87WWd/6St8W/DaViguRKbkqgWB9w9ty+aNe63uQ2atyE9Lx0MLeni+1ndgpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991531; c=relaxed/simple;
	bh=Kn7zZw/cAtyCXmdZ3MSG23KXQdoWqOdhiJFgrqequOc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WfT5uuAM0Psu2FMOuqrYGZ6TpCot6Ty+pLzpzWWmgzipj62K9yRPEhV9XonUgvB6g8p9ghMPJLZiF5A4S/dQjPQtj1rAPLtm1fAExOkuxnTfVq1Oc0RnVWjdhUwxsdGaizn6QGSoT6oYjlkMOC63f3LI6pr53GFvB/bCdUciwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBfAV5Qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBfAV5Qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B76C4CED3;
	Mon, 23 Dec 2024 22:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991531;
	bh=Kn7zZw/cAtyCXmdZ3MSG23KXQdoWqOdhiJFgrqequOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dBfAV5QeXPil2brjYEM4CVGBuOnna7GY9kzHMd8NPfeyOv4Ju/B1CTty+wgeK6LZ+
	 TeFRCQ847efBbe7YPMocXWh4fRTcd8BIBEXTFKIVWPZwfuKgGQp4IKZOcIdbs/aWsB
	 NwPs+r9BCFOx4HDLprb+wcfUGmCub8QFTqfGKHTQz4Q8jrBUnH6EWoOHUC+OS72la+
	 abXOBt56O9C3UlbavbGtEiy2OBiaIRSEDNOQMQAIDdo2Y1X+xBodQiAafYDc4Hi0Fr
	 UT5JCLxSK+dQqc5l6yMhIOW5EfeDPaiZ3IWxQufkh57PbS95GIiP00y1c+Dji3DA7T
	 ZXA6+Ub+fwGvQ==
Date: Mon, 23 Dec 2024 14:05:31 -0800
Subject: [PATCH 28/52] xfs: make the RT allocator rtgroup aware
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942923.2295836.16300361370292980640.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: d162491c5459f4dd72e65b72a2c864591668ec07

Make the allocator rtgroup aware by either picking a specific group if
there is a hint, or loop over all groups otherwise.  A simple rotor is
provided to pick the placement for initial allocations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c     |   13 +++++++++++--
 libxfs/xfs_rtbitmap.c |    6 ++++--
 2 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index bdede0e683ae91..60310d3c1074c8 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3145,8 +3145,17 @@ xfs_bmap_adjacent_valid(
 	struct xfs_mount	*mp = ap->ip->i_mount;
 
 	if (XFS_IS_REALTIME_INODE(ap->ip) &&
-	    (ap->datatype & XFS_ALLOC_USERDATA))
-		return x < mp->m_sb.sb_rblocks;
+	    (ap->datatype & XFS_ALLOC_USERDATA)) {
+		if (x >= mp->m_sb.sb_rblocks)
+			return false;
+		if (!xfs_has_rtgroups(mp))
+			return true;
+
+		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
+			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
+			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;
+
+	}
 
 	return XFS_FSB_TO_AGNO(mp, x) == XFS_FSB_TO_AGNO(mp, y) &&
 		XFS_FSB_TO_AGNO(mp, x) < mp->m_sb.sb_agcount &&
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index b6874885107f09..44c801f31d5dc3 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1080,11 +1080,13 @@ xfs_rtfree_extent(
 	 * Mark more blocks free in the superblock.
 	 */
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_FREXTENTS, (long)len);
+
 	/*
 	 * If we've now freed all the blocks, reset the file sequence
-	 * number to 0.
+	 * number to 0 for pre-RTG file systems.
 	 */
-	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
+	if (!xfs_has_rtgroups(mp) &&
+	    tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
 		if (!(rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
 			rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;

