Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DB22901
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504339; cv=none; b=PKkazwP5lh7DxVCg+LdrQKAlEoil6ZGeTiPBOb3+QCZNQTda4YZn0DkaS9uR8V03VstzFBFb1VA5zU6EqPzQU4lwdPZPY+0ygLZ3Th4Wat1EYhpkt2nUMM2qoWJnaLVzvkA5BiMF02sDGozEf7IfYDxiF55Rlj5egKCf0UbOTUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504339; c=relaxed/simple;
	bh=aDWyu6HQsmq2qfb6seRD/ENjwj2NHDaXGyQ95r+PACQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ubfq5iaLYKxvUMc3PIjbPse5FevLAcAdeJImKUAjzIWsw1vxQqwWBzgdeyEIfxseQty2MQJCG7W/IHksh2R79CM3K5zsfGyaZP88HBX2/9n4LBejMpn3KxvU+m7PWbahWjoId5CjV1jv0gLa2hf4yUBWcdINhurW86O1dYUeWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kN2pCEmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kN2pCEmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24021C433B1;
	Wed, 27 Mar 2024 01:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504339;
	bh=aDWyu6HQsmq2qfb6seRD/ENjwj2NHDaXGyQ95r+PACQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kN2pCEmR4FeClBfQ8OBPUzyd3xwgc2lkf0lrKNBj51gUn1EvH8IqIP3zBZJ4Nafnu
	 qQial4bHemtPdIu8p1K3PMaEsS36diwhXagd/Esx9RGJVm+FSpvzDUjvJfj3Uq4x9B
	 8Qfekg83vZ4xZkqXoK+Nrc3pcJ4qvhDTGSN4KWkWSfA9FWM8aALSAggtA0wGy3MXiH
	 sM5iL8z24aYjagZLPpI83TBOhYJEgOAHXiIrHC6jJxljPsiiZKFDI9WOS8D1BiRZwB
	 2dRSBoAOZYlE/MVzZ/+oRg9DZUyUzfhVfS6kisLwG/eqaXt3VLP/lqF6UPjCGo0YpQ
	 +mFdUia/SMb+w==
Date: Tue, 26 Mar 2024 18:52:18 -0700
Subject: [PATCH 5/7] xfs: hoist multi-fsb allocation unit detection to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150380216.3216450.3675851752965499332.stgit@frogsfrogsfrogs>
In-Reply-To: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
References: <171150380117.3216450.660937377362010507.stgit@frogsfrogsfrogs>
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

Replace the open-coded logic to decide if a file has a multi-fsb
allocation unit to a helper to make the code easier to read.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    4 ++--
 fs/xfs/xfs_inode.h     |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 19e11d1da6607..c17b5858fed62 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -542,7 +542,7 @@ xfs_can_free_eofblocks(
 	 * forever.
 	 */
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
+	if (xfs_inode_has_bigallocunit(ip))
 		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
 	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
 	if (last_fsb <= end_fsb)
@@ -843,7 +843,7 @@ xfs_free_file_space(
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
 	/* We can only free complete realtime extents. */
-	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1) {
+	if (xfs_inode_has_bigallocunit(ip)) {
 		startoffset_fsb = xfs_rtb_roundup_rtx(mp, startoffset_fsb);
 		endoffset_fsb = xfs_rtb_rounddown_rtx(mp, endoffset_fsb);
 	}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index fa3e605901e24..89ba114fdb468 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -311,6 +311,15 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+/*
+ * Decide if the file data allocation unit for this file is larger than
+ * a single filesystem block.
+ */
+static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */

