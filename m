Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D97EDE
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881813; cv=none; b=bVbrGJrz/97i42db4UUDyx0rwuaa36ITJirIF1NVLBnQHQbJ7aeKm3k8wdjd4uaxL0xC6Q3ojQnycK646UrSJumYSQBKWTNeUMTbvLBW4g+0eqG0Pska+P5j/2MGoeDmOIGoEZbB+4zdbK6Obb8S4Aa6x7zR+x6YZmRl2ixaX74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881813; c=relaxed/simple;
	bh=EHOcpvxzPw44FX1BI9a2UwZ76fsyFsNsXbbEjvetask=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ewq5oO4pwuSOWSDRSJ2lW5dhmiFXr+7i13iwhHWt5ic6gw9DoQBjkBINb1k8WOPVHBG/h8ZrhVKzcvrwE2XNZEFlI077WXsch+yn4BQCrlQc99o/RF4VAzuwX6DljvDj3FfWmCfCDZG20ihspriD0d+OPGMGDvivzmEgGkqWOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvNBjBDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvNBjBDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE131C116B1;
	Tue,  2 Jul 2024 00:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881812;
	bh=EHOcpvxzPw44FX1BI9a2UwZ76fsyFsNsXbbEjvetask=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lvNBjBDIxS+heCO5/wP/ZTXLLYSAg5956HdW4mTb7/pX1zfWI9rFNMBYTtjB/ewLO
	 FYme+ePNSEnFWVfJcBaFWzsawm9yhbQHkZhqK06io/24PgnFM5XpaKkWX/4tdVv8sI
	 /Hm9VPFbbBGvonkUOqA4T1v/1Vd36qfNSfjBNtfODc/ftNzrtjc7vWwwocuyFv3nOL
	 LTLukgv8bS6cWWDHQ2cxfClu9lJSkIRtEVEEQFSgQfRjInzJLE3xMRScu8IBQZLFhu
	 fZ3KGRAjfgrRJuqSzf6PmpvgLgVXtdgzCVU3Pzw8p3uSB94+X3U4p/zkdnccz4hoUp
	 WnzuWEYOA9nPw==
Date: Mon, 01 Jul 2024 17:56:52 -0700
Subject: [PATCH 1/3] xfs_{db,repair}: add an explicit owner field to
 xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117239.2006964.2035449041267157890.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs>
References: <171988117219.2006964.1550137506522221205.stgit@frogsfrogsfrogs>
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

Update these two utilities to set the owner field of the da args
structure prior to calling directory and extended attribute functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/namei.c      |    1 +
 repair/phase6.c |    3 +++
 2 files changed, 4 insertions(+)


diff --git a/db/namei.c b/db/namei.c
index 6de0621616a6..41ccaa04b659 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -447,6 +447,7 @@ listdir(
 	struct xfs_da_args	args = {
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
+		.owner		= dp->i_ino,
 	};
 	int			error;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 1e985e7db068..92a58db0d236 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1401,6 +1401,7 @@ dir2_kill_block(
 	args.trans = tp;
 	args.whichfork = XFS_DATA_FORK;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
 		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
 	else
@@ -1505,6 +1506,7 @@ longform_dir2_entry_check_data(
 	struct xfs_da_args	da = {
 		.dp = ip,
 		.geo = mp->m_dir_geo,
+		.owner = ip->i_ino,
 	};
 
 
@@ -2294,6 +2296,7 @@ longform_dir2_entry_check(
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	fmt = libxfs_dir2_format(&args, &error);
 
 	/* check directory "data" blocks (ie. name/inode pairs) */

