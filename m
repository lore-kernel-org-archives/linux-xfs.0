Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5DF13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991719; cv=none; b=gviDvIW4cbwXztzKeVDag6hsIMCrHjWUSqMyIMV/6fMYxgywRGaBhh6mWFp7Veec1D+xcuXTJ+uLy0PKEi41lgbLHIsG5ZtD0k7noLkMUPEFoVG01EpeuOc3gmytPqfkSTBQcQKEqi/h6mv3m347v1LUtwI5FzBXjQ8Ga2kQVpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991719; c=relaxed/simple;
	bh=pxcvcAxSyQRu7r68aaoSqorK2wouR8o4lDgPJeFvT5w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiepUZ1irsdqBki2zJRl/hzcvk08T1MkgKVXPW3PmEH8Mdke90EY/xH4iu0VL7H6I3GQ2Dh/Lx6h3np/5eTGfPQbtazT/GKvKzv4HW5zWR7wakOLPVeacCu8a2DyezS/Wy7WqWbmejkU+p7OjwrrbosH4ibO2SKdfXeZUXGLKAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDcm8MJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDcm8MJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6069CC4CED3;
	Mon, 23 Dec 2024 22:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991719;
	bh=pxcvcAxSyQRu7r68aaoSqorK2wouR8o4lDgPJeFvT5w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rDcm8MJs8OQ57GnroA9/PCkHAJiag0/RLyvp1lfOub03Dgp3YFt5S9xRe922Fw5AN
	 RAtGoy9PJQvkxJNPQb75zjR5fGqE5s5uEWOnAo/Up3euhGEhIOsrxmPmLD5S234hsN
	 AsF2ZktECUqbFi276U0wrFj/l+Cc+f02KOsbXbaRD5pwm1ODhteRlfolLQ2zKicjYl
	 ow7bJK9wbqFNn/0ymCIoxZSDsRjeeDcH7S2dQ+k1TZYdSJ2+Vz+sxoADVXO9gNhA4H
	 LzukOhESlczQyxXXDeDUS6X2r4/DF8p4YbVfbKc+BDXJwTYn3EoJ14WR0TATk0vxXg
	 zjLleGRCdXkbw==
Date: Mon, 23 Dec 2024 14:08:38 -0800
Subject: [PATCH 40/52] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498943108.2295836.8664325175204474648.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: ea079efd365e60aa26efea24b57ced4c64640e75

Enable the metadata directory feature.  With this feature, all metadata
inodes are placed in the metadata directory, and the only inumbers in
the superblock are the roots of the two directory trees.

The RT device is now sharded into a number of rtgroups, where 0 rtgroups
mean that no RT extents are supported, and the traditional XFS stub RT
bitmap and summary inodes don't exist.  A single rtgroup gives roughly
identical behavior to the traditional RT setup, but now with checksummed
and self identifying free space metadata.

For quota, the quota options are read from the superblock unless
explicitly overridden via mount options.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index d6c10855ab023b..4d47a3e723aa13 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -403,7 +403,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

