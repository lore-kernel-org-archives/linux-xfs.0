Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757931370
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nqt2lQ2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49082C433C7;
	Mon,  1 Jan 2024 00:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069458;
	bh=5UvRm7wgt+nEud3CUVbju/HTMwq5CftDTN/qCgstk/w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nqt2lQ2WkdChtq3tbseS5saKXUEbgea6hSZXIEy09Ma4AZSX9vtXZ+A3cjmJrO2U4
	 jTEJxOLzbc3HZAAi4maIPz9ItUBbrEc7O1qlDa2cAUE5QF+cCTnisSQ8C6DbHOuejd
	 vwnLguCwmxygCQV4NOFQrjVOaBiM+LLnUEJWqJdSi3EurX/oVPrsSI9pfCsTqh8c36
	 MPE5efulngTy+nv8l8Nk7eR9cWLJiiCiWp6HaJusGM8No8Kthw6+wwjaRUPNXh71+8
	 571o6NLFvdMF2oeAxBiApznxDmtj+7uOBHD0NKqlY2L8KdsmMhtP2+5ZhwNr3xiOkH
	 UxqqvxMJZqCSg==
Date: Sun, 31 Dec 2023 16:37:37 +9900
Subject: [PATCH 2/3] xfs: fix integer overflow when validating extent size
 hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405018038.1818169.12212197712076555126.stgit@frogsfrogsfrogs>
In-Reply-To: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
References: <170405018010.1818169.15531409874864543325.stgit@frogsfrogsfrogs>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_inode_buf.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index d9fc254b354..085c128c542 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -767,13 +767,11 @@ xfs_inode_validate_extsize(
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
@@ -802,9 +800,7 @@ xfs_inode_validate_extsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if ((hint_flag || inherit_flag) && !(S_ISDIR(mode) || S_ISREG(mode)))
 		return __this_address;
@@ -822,7 +818,7 @@ xfs_inode_validate_extsize(
 	if (mode && !(hint_flag || inherit_flag) && extsize != 0)
 		return __this_address;
 
-	if (extsize_bytes % blocksize_bytes)
+	if (extsize % alloc_unit)
 		return __this_address;
 
 	if (extsize > XFS_MAX_BMBT_EXTLEN)
@@ -857,12 +853,10 @@ xfs_inode_validate_cowextsize(
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
@@ -877,9 +871,7 @@ xfs_inode_validate_cowextsize(
 	 */
 
 	if (rt_flag)
-		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-	else
-		blocksize_bytes = mp->m_sb.sb_blocksize;
+		alloc_unit = mp->m_sb.sb_rextsize;
 
 	if (hint_flag && !xfs_has_reflink(mp))
 		return __this_address;
@@ -894,7 +886,7 @@ xfs_inode_validate_cowextsize(
 	if (mode && !hint_flag && cowextsize != 0)
 		return __this_address;
 
-	if (cowextsize_bytes % blocksize_bytes)
+	if (cowextsize % alloc_unit)
 		return __this_address;
 
 	if (cowextsize > XFS_MAX_BMBT_EXTLEN)

