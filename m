Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967F1213E97
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528348; cv=none; b=u9++nuUA+5BspTns87BRmvMY48mo05WSn0T+PgkV4iXzCxsqPMvu0W0kKGXko+fDmFmYvYg1sWf2QpCxKePIbINBuRGc+namxhp5zAHFyXud1+kSt4ZPIMeTAVkmYcbfW7Mf42xtqaqjXKcAPntodlQhMGOgrsNPidkEV4xqzYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528348; c=relaxed/simple;
	bh=f1H0S3LmJiS7L2YE6t0iHQa9jIj5Qqej1nlZUUaehSQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yetj/YSjwadkNoLfz4fTjAPOfyJ3DBof0WBvQcZWvJTxNFPvKmf3TG0QAqk0HgC337Gy/WS8ZxsByZuglpVqntA8ajEUN6PGgxgptrfHxrsLiKz4RhNpwVnpwzLzFxUPLNx6o5l29+4ltCtDCXigzVoNLJiBKsBZMM77fBxKVWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOjARFYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOjARFYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B84C4CED1;
	Fri,  6 Dec 2024 23:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528348;
	bh=f1H0S3LmJiS7L2YE6t0iHQa9jIj5Qqej1nlZUUaehSQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dOjARFYTgZVKv/bTssnQ4SK4xtmBI9ggmBpx/ZsWuWFj4pJ0Av4d3TOEzVuKSJsSj
	 WbvQzOpqshyAHHUSmioD0dOdG8vcXPlxg+5SUiIPma3CK1slO3D9BEk2ijcuA7P8uO
	 4YT8GZtaECQycnf19yYLoPwclYMMxM0+UH2jR0O/ZDqiPxduIAK0jHhcGCogyLiiVx
	 7fWu57PSCo12JeYdwhcuw46bWUuaO4CPWEO4EXUiBMXe0slkzDA5AsOLH4WbN/i8BS
	 FCGQkj/kDPYti3j/wDXpwZcEwornfabq/hf2zt47hJqwHjJ7lY6muq4nk6O+GEFpZc
	 ebMAdYpRXc9zQ==
Date: Fri, 06 Dec 2024 15:39:07 -0800
Subject: [PATCH 34/36] xfs: adjust xfs_bmap_add_attrfork for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747396.121772.4712174044501346925.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

