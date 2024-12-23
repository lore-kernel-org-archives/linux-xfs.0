Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56851422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990359; cv=none; b=Rtp4WFTL+jVkLBn7Llb0qjJ1FNb3joS0uTuhDuxqZkm0ghj0DGsySZSEKkSlUzWSsm7kuJVGagT5Xbzb5qbSNh3A5Zdtcd1WW+7YJudnnRej4dKjCpK3Nvio7ANvV+rlN1Q2bapz6vJckk+0+e+LnIscLCTmhunyGeHWAY4p2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990359; c=relaxed/simple;
	bh=f1H0S3LmJiS7L2YE6t0iHQa9jIj5Qqej1nlZUUaehSQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tRWGK30RtUm56v0zfDmEWmWDbhEFw9hOE0Of/YcvwFhsJ25TDIeC4JXSMlYCnDGXOxuZ7Pn2DgGuiihy4V2QLEHdtcRe/xsbDeLuM2K5Cu4zbjwbp2YDAwfqDdqrYVCYJSxJr+vHYVqC4Fw1NSCV7AzcECRRw7j25FexCWoPDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NPivUrk+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NPivUrk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6EBC4CED3;
	Mon, 23 Dec 2024 21:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990359;
	bh=f1H0S3LmJiS7L2YE6t0iHQa9jIj5Qqej1nlZUUaehSQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NPivUrk+CvKMhU/DfWsU4Xmq8mm9ge9DWi+Dw8OMgT3qUq4CmpMA0p03CkenAwFbx
	 3rg1EzivZ3+fTnV2JzadigshtsjRDfMBU3QJnGGg0SUehhfAOSwpYwIGpocLXaVivL
	 kqcFdhtPtQbLZ/GQQibSkhkZZvJ/Zo7dlPBmgfuVuPLjA8S8VEb6qF6ILNtntLRIBO
	 94d81HHtKxqzRZ8LyGb7Xo39beGcmcQWS3dFyTe4Ke1rjzvqefacmQ0xeBpZTkpuRF
	 TpmeQExPS8I2KDnmvdVASgs7aTY2TEVfpAzMle5DsU/p+6QovjJFc3LuB1BRcdR1AW
	 eSA+gMLgdR8Yw==
Date: Mon, 23 Dec 2024 13:45:58 -0800
Subject: [PATCH 34/36] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940463.2293042.17206658494742067648.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 61b6bdb30a4bee1f3417081aedfe9e346538f897

Online repair might use the xfs_bmap_add_attrfork to repair a file in
the metadata directory tree if (say) the metadata file lacks the correct
parent pointers.  In that case, it is not correct to check that the file
is dqattached -- metadata files must be not have /any/ dquot attached at
all.  Adjust the assertions appropriately.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |    5 ++++-
 libxfs/xfs_bmap.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 150aaddf7f9fed..7567014abbe7f0 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1003,7 +1003,10 @@ xfs_attr_add_fork(
 	unsigned int		blks;		/* space reservation */
 	int			error;		/* error return value */
 
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 
 	blks = XFS_ADDAFORK_SPACE_RES(mp);
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 13cd4faa492838..99d53f9383a49a 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1036,7 +1036,10 @@ xfs_bmap_add_attrfork(
 	int			error;		/* error return value */
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
-	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+	if (xfs_is_metadir_inode(ip))
+		ASSERT(XFS_IS_DQDETACHED(ip));
+	else
+		ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
 	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

