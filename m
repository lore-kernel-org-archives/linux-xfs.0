Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68782259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441365; cv=none; b=gtJW9gne/v/BHomGVYcmEVYa317OfgUxbP9j786aCyXzw166wLHS8Plhd/zONlkHm/RSOJ1P4QOG2A61Xl+uk1sVPj7apJYMDddIQJpYwDcbiQ60iGgtgFnWVhe1488pTmfI2JZkd9+V00rl4miIM6MnFGXydV3d5PCJuEssZYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441365; c=relaxed/simple;
	bh=vbH5EiDr3xS2zmG5ng9yqVp4NIAr5U1w5o2iA4Jtyts=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lYy9jzDOK1a3g+Melqi3uz86v/6gkwj6A5NjDm5koATMBvgDEcmsfT6r4zoxbBEhfqGIg2Fdz1sxd33e+09UQzL6I+h6WX65mrjJxtg1lOITSDpl2JULAgI/oFQa8Ft5T5yUbCNdjv3psgQc65UkkQZ8t+Spnu/+72WGM3VluWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRNdpOCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRNdpOCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B173C2BD10;
	Mon,  3 Jun 2024 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441365;
	bh=vbH5EiDr3xS2zmG5ng9yqVp4NIAr5U1w5o2iA4Jtyts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lRNdpOCf5VM05JEDI8O+u1A26a2rXR1sgq2HhMbEOz0KpL+okdzMzv0a62IfWn7Ce
	 yEOFrppDu4s3rhC4hmevqeDZehSMaJQj94qo7IzKP8dJ0gMSo7/gCieJdpSFkkJ0By
	 qfUEEPZakyj4w9Ao4J9qKqWPx2tAagLAuTHBnaDAZHVkqgNhLOUL3p4Tp8BeQeg5ZE
	 MU+VyM9SttxlmmktSYHCgm4a2dMGMMnRAEvwMZehlhwZxpfgiwpuiMybo2YNfMQGFS
	 K1XA70eAvyeEexlluFOfqVEEeuD3icJC2fL6DCyfwpY3Aqro4RT/HdbZ144xrPRCSf
	 gJfCz/TlYTF6Q==
Date: Mon, 03 Jun 2024 12:02:44 -0700
Subject: [PATCH 041/111] xfs: set btree block buffer ops in _init_buf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744039989.1443973.14091518118967142765.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: ad065ef0d2fcd787225bd8887b6b75c6eb4da9a1

Set the btree block buffer ops in xfs_btree_init_buf since we already
have access to that information through the btree ops.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_bmap.c  |    1 -
 libxfs/xfs_btree.c |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a7b6c44f1..b81f3e3da 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -682,7 +682,6 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the child block.
 	 */
-	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
 	xfs_bmbt_init_block(ip, ablock, abp, 0, 0);
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2386084a5..95041d626 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1216,6 +1216,7 @@ xfs_btree_init_buf(
 {
 	__xfs_btree_init_block(mp, XFS_BUF_TO_BLOCK(bp), ops,
 			xfs_buf_daddr(bp), level, numrecs, owner);
+	bp->b_ops = ops->buf_ops;
 }
 
 void

