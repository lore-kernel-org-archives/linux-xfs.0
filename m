Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393F2F4F1
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000437; cv=none; b=NhFM9/rAxQoGTXtaE4DPrTT2OBN1sGzZ5c4cfaOowwNIuZdu0Be43L95KcVhBa+w1pjiax0i/L3xKGFwQhO6RneHK/tHTE+5XziNrcYyxI8psZ2ByAJDCW6/xD/71S5vNa4SclLp4D73G86cRscqeUNtOSDSxnKcjHqG5pVyTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000437; c=relaxed/simple;
	bh=9rZI6HX6vbWdmJUIpEmtTMTEomcgFvKWqrDENsKad3Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRtBtdR+t5TzuKjXhCQQI++at0vIbgxGBy5GQ1+5/Oxc9sgQnlIei9/LnXa8raZeoU6vlAIBvcgIn7g/niu7ovfzVNTvH1EulZPeiwAh+zqwjHB2rjCujuTUxV1SDZutQnQhUEjYEHHRGyTlP88p0sKlaiJc2IosBlvPL91ICEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrFhRtSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrFhRtSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE1DC433C7;
	Tue, 27 Feb 2024 02:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000436;
	bh=9rZI6HX6vbWdmJUIpEmtTMTEomcgFvKWqrDENsKad3Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LrFhRtSxHRglCfUY0J/QBtpm0xuStyEQor6NWsErN7hC32Esc/T7XLOnnyALPoriY
	 l59qh1p27aVXR3Jt0Yg3zw3aP2wShG18NthTn7IUaZfHssiNxH79UEJ3PDHzPBn1Eg
	 EwfXjUFORR0qZd7VYlJj6/VZzDlALpwYKQGdtrPZwQy+8SmUEAxo9wNzAK3BZOW1hU
	 YcwYWvDxpq+Lcj4Pa2ihGXnyUINnF++A9/85yp4zIr28ewRphTvPIZ1jkn0tHPOxrK
	 cBnL/WxQEfvKy9GgG8YoPdpNIA1w7zK/6+Ay5Vgv6t3ANOjah5Us4SeOLPwKojGfyK
	 opYYSpQX1XH7g==
Date: Mon, 26 Feb 2024 18:20:36 -0800
Subject: [PATCH 5/6] xfs: hoist multi-fsb allocation unit detection to a
 helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900011214.938068.18217925414531189912.stgit@frogsfrogsfrogs>
In-Reply-To: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_inode.h     |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e58ae3654e7a8..74c42544155d5 100644
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
index c8799a55d885f..b7b238e88f23a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -311,6 +311,11 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
 
+static inline bool xfs_inode_has_bigallocunit(struct xfs_inode *ip)
+{
+	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
+}
+
 /*
  * Return the buftarg used for data allocations on a given inode.
  */

