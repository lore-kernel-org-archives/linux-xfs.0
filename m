Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF64A1E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607876; cv=none; b=TmtU7DkPOwSBiCN9fOa5bYJSWNibDcKe0yLzSGUPKfWEldLNsau4SRR3ypq+AKrllE3n3BgKG4HAk8tp3G1/rffyT9opLshuC9DcNMqIHd9hVTy9vzmKmRfIYT/jfYRiGh94n1uQSi8yilqgGB7sL5nut2gAE83hSAi+s8fBAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607876; c=relaxed/simple;
	bh=ffCx0YgHJ8Wts3ZJfLenSZJpwPIXXScFII9Qhw31am8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8cjI2hw7LdtXKhrabzilUO5et2SFBzYL9AQTV6Xw9mkU9PacYns0HZASTQzjhRUF+W0YGjrf1yQ7chf2JPIp6v0yGrRZ53wB/SMokMKbo/6IyjNseGKLTvFKbVd7G3uSJVZPnjmfK8zDnXKrr1TsetD2BLrwPxdIWIL89quaKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rf4jnRmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rf4jnRmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E154DC4CEC5;
	Fri, 11 Oct 2024 00:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607875;
	bh=ffCx0YgHJ8Wts3ZJfLenSZJpwPIXXScFII9Qhw31am8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rf4jnRmUV3JqmcasdCHLmfrzbjfNQKG8xWfTRmLcu8vJzuIwl4nLAubotCoe9iOC4
	 ozYCUZq0O5RqJyD5wf6VAZhpjZder2zlQLF7vwa+dx2bfEz6d9kgx48vxN1YL2gEtS
	 +CIS5CDn2T7LQ1RYJejKzMWWrE+cDtUOh51doNwU6CAISbpWjticIvjzwRfWsBUOrH
	 6R4K36JCpmEW4mtU8MDkr089GGVUaxaXZEvvFmL5xdo0R343wlwua52H/emTNWglAR
	 E90QfvnRPrR7FEr5tldQs3+zFxO0ZBOGOGkSTHaxyovF7T3FFI3HPMV4INx71juvLh
	 JdTL5BiiRBORw==
Date: Thu, 10 Oct 2024 17:51:15 -0700
Subject: [PATCH 11/28] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642206.4176876.18307294388373529193.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h |    1 +
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 3 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 860284064c5aa9..a42c1a33691c0f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -242,6 +242,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_NREXT64	(1 << 23) /* large extent counters */
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1 << 26) /* metadata directories */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 81b3a6e02e19b4..5fbf8d18417880 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1303,6 +1303,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_has_exchange_range(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 

