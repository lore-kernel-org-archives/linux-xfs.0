Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF1023C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881448; cv=none; b=C+PSBHRQjBKbO23iDlsOFkPLz/w79XbAuqdGRiOid+4knoY4mLaxGcfgHEIjS6liWwlvInV+cJCz4pQfGIajOuw6c/8w6XDq2u/YRo5x0Qlev37Yu95ynVwqkI3i+ju/2DQLB5lCidMJoDE755Pmb2ZGTmN6+9fhZwNx8Lrt8O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881448; c=relaxed/simple;
	bh=NL4DkrPh9tZxYmFq7mytVcWwgJdk23SbfsPmKmDtQoM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKVHNimdPkwJNU5onZP2yg7dTctil3rwDN08rjDh37jU3vUJzcw4JgkQghydo7xxbu76ofVm3HA1+KaXO71VYHHlzlN56wHPDWeUvGslPfnAkGw1siBzrPONnr7JuJx1oBl9CeGRO8GksRNLX+Y/31+hkAmCdkcY/g4XVPwG42M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECIVxGpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECIVxGpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38EDC4CEDD;
	Thu,  6 Feb 2025 22:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881447;
	bh=NL4DkrPh9tZxYmFq7mytVcWwgJdk23SbfsPmKmDtQoM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ECIVxGpHJi35A0ZokLAXJV/pYB7qekvbkp8VhVmJrIhmd9npE3UCS3xVxwcgxbu0s
	 M3yDtaUURGkHK2yt7jOAtOXUCMsbDy43iq12zRC3ioHnc8Z7t3LTnaTeBtt5DxfwbJ
	 YdBjpJTug+Cq+2WI/t3McI7Ruqt/5v6fs+i0sqVEWihdbZDvNJuuViVC3shAg645gv
	 gvpZhqqG5t5r91WjmztafSYbPooEJOCBobf2eJFTLzdWml04epaZ9DJlcOIPY257LC
	 W9Lu9263ZIfyCc9mXZMGhJTD+DgQZ9CrLcM2SY0Kubb972iTqSTDzCWr/GeAwogooF
	 /eLbxAka39ITg==
Date: Thu, 06 Feb 2025 14:37:27 -0800
Subject: [PATCH 09/56] xfs: prepare to reuse the dquot pointer space in struct
 xfs_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086929.2739176.3113945891228463785.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 84140a96cf7a5b5b48b862a79c8322aa220ce591

Files participating in the metadata directory tree are not accounted to
the quota subsystem.  Therefore, the i_[ugp]dquot pointers in struct
xfs_inode are never used and should always be NULL.

In the next patch we want to add a u64 count of fs blocks reserved for
metadata btree expansion, but we don't want every inode in the fs to pay
the memory price for this feature.  The intent is to union those three
pointers with the u64 counter, but for that to work we must guard
against all access to the dquot pointers for metadata files.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |    4 +---
 libxfs/xfs_bmap.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 7567014abbe7f0..4b985e054ff84c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1003,9 +1003,7 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	if (xfs_is_metadir_inode(ip))
-		ASSERT(XFS_IS_DQDETACHED(ip));
-	else
+	if (!xfs_is_metadir_inode(ip))
 		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index fcb400bc768c2f..41cfadb51f4937 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1036,9 +1036,7 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	if (xfs_is_metadir_inode(ip))
-		ASSERT(XFS_IS_DQDETACHED(ip));
-	else
+	if (!xfs_is_metadir_inode(ip))
 		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 

