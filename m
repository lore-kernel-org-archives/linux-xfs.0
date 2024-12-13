Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B437118EA2
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053044; cv=none; b=ZqFIKeRQtmY4rD+TqWxa5CYUvRe1iNCXekiPqyPUFKFoK+wgu5v+YKytojQQRgA5vCDv9chDAZ1FqQ+wE21iV6CFYQ4tGHaRg+0oVnZnag/W79DYbsHRQWIRtHJFGNqngmqFPdfHuz3vDFqQot18duCk4KbF0QAx5eiSbvi3KE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053044; c=relaxed/simple;
	bh=IdDYYjRNrpi6gmPsYhhzs8I1wZiq+3261RkKgjFDRSU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzwtIra1CmP6AIRELYjDB41SYAEyzbC7N0j9mLjIuf8Og4U70mEc69InFzZLmTxeeQRtb56vsEvyoyrF9a00Nea/GbBR+hxAG7sX1FL5u4W8RgTiFZJD8pmgoXSWtuVknl31xlq3fkqhhRRyYAkzZOjlMeY38QOr1c3u5gHSOyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YwpZDQnX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YwpZDQnX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F69DC4CED3;
	Fri, 13 Dec 2024 01:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734053044;
	bh=IdDYYjRNrpi6gmPsYhhzs8I1wZiq+3261RkKgjFDRSU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YwpZDQnXBgF1MP2IqHHfOz+4kZ4hhDHCBRCu2L1ZZYPccZQ81R8PTrK2m1TABVTNz
	 PEo0+dD92myTh3yzHZtkP7s6GvCrdA5JSPMmmrXjF4eVeZtLmrXndqsq3/oIT44V/m
	 s5AP6vApLgUrO+KnXw7X4pKwc9egs9278wRo2dcIaIUnQbGOb7ILTJ+ofgOr8u83fh
	 xCVFx9yzs9sUyBcaRKjJe3xUOblcmrgqckuofe2kdo/2o2JI87aUb+mTV3Kwbh8E8T
	 Zzps9JY6FpdNp9EWeJbxss3R14zMWGXIXxGgGUYNCAjhxhISF2/l0ND5ZCm/Ba99xF
	 3MYvAStfbC4dQ==
Date: Thu, 12 Dec 2024 17:24:04 -0800
Subject: [PATCH 10/11] xfs: fix integer overflow when validating extent size
 hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405125912.1184063.5511687476090644949.stgit@frogsfrogsfrogs>
In-Reply-To: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
References: <173405125712.1184063.11685981006674346615.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Both file extent size hints are stored as 32-bit quantities, in units of
filesystem blocks.  As part of validating the hints, we convert these
quantities to bytes to ensure that the hint is congruent with the file's
allocation size.

The maximum possible hint value is 2097151 (aka XFS_MAX_BMBT_EXTLEN).
If the file allocation unit is larger than 2048, the unit conversion
will exceed 32 bits in size, which overflows the uint32_t used to store
the value used in the comparison.  This isn't a problem for files on the
data device since the hint will always be a multiple of the block size.
However, this is a problem for realtime files because the rtextent size
can be any integer number of fs blocks, and truncation of upper bits
changes the outcome of division.

Eliminate the overflow by performing the congruency check in units of
blocks, not bytes.  Otherwise, we get errors like this:

$ truncate -s 500T /tmp/a
$ mkfs.xfs -f -N /tmp/a -d extszinherit=2097151,rtinherit=1 -r extsize=28k
illegal extent size hint 2097151, must be less than 2097151 and a multiple of 7.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index f24fa628fecf1e..3fd1b03b4c78cc 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -819,13 +819,11 @@ xfs_inode_validate_extsize(
 	bool				rt_flag;
 	bool				hint_flag;
 	bool				inherit_flag;
-	uint32_t			extsize_bytes;
-	uint32_t			blocksize_bytes;
+	uint32_t			alloc_unit = 1;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags & XFS_DIFLAG_EXTSIZE);
 	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
-	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
 
 	/*
 	 * This comment describes a historic gap in this verifier function.
@@ -854,9 +852,7 @@ xfs_inode_validate_extsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
 		return __this_address;
@@ -874,7 +870,7 @@ xfs_inode_validate_extsize(
 	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
 		return __this_address;
 
-	if (extsize_bytes % blocksize_bytes)
+	if (extsize % alloc_unit)
 		return __this_address;
 
 	if (extsize > XFS_MAX_BMBT_EXTLEN)
@@ -909,12 +905,10 @@ xfs_inode_validate_cowextsize(
 {
 	bool				rt_flag;
 	bool				hint_flag;
-	uint32_t			cowextsize_bytes;
-	uint32_t			blocksize_bytes;
+	uint32_t			alloc_unit = 1;
 
 	rt_flag = (flags & XFS_DIFLAG_REALTIME);
 	hint_flag = (flags2 & XFS_DIFLAG2_COWEXTSIZE);
-	cowextsize_bytes = XFS_FSB_TO_B(mp, cowextsize);
 
 	/*
 	 * Similar to extent size hints, a directory can be configured to
@@ -929,9 +923,7 @@ xfs_inode_validate_cowextsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
@@ -946,7 +938,7 @@ xfs_inode_validate_cowextsize(
 	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
-	if (cowextsize_bytes % blocksize_bytes)
+	if (cowextsize % alloc_unit)
 		return __this_address;
 
 	if (cowextsize > XFS_MAX_BMBT_EXTLEN)

