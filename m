Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1966D21BAEB
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192320; cv=none; b=f9+9LWDiukTqSAd1jCia5ycSSMs0yKK+tXrWiwlYlh8x/IzSuy8iupFT+QrjjnxUSjFRGowJX3UIek7OHg+qiu5FDP/Vw+Ex34LsE0kutnQjAGtfK7mrBBC/O5tAXmC1sgAHTyEbQOBTZYF0Arb7E+fQf6Nhq7TG4mX6r8sleHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192320; c=relaxed/simple;
	bh=qnBBGtry7VGnzhAZXLDVFSZhECjhiV+XjDfjnj46xps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI4l7HwLrtfO8MJgX9/CAlWw/EUVTCZMQv/dzSaOZkxrEK7K1qvMD4wxkttPEmet5JtwKBJfg91AgNIUdhN3G0VCdzG2sHk8GkDfNicZFQNd9748yjEltXpvkQ09r+FCZeoIYRW+yw8hTUz2cPtt/nTukBGAISiazICf6JPgiNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGHut0YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGHut0YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AFBC4CECD;
	Thu, 17 Oct 2024 19:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192319;
	bh=qnBBGtry7VGnzhAZXLDVFSZhECjhiV+XjDfjnj46xps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VGHut0YByCnBnah01z7h8EbmFm+xsOqP/6q+7MU1k+l/pW1xrchiFc5xnMOZtzNVM
	 2/DmrSAmBj1XZ9yarQ6x6RPz5oq6sbMpxapdeCw+xznnhvp2yMZM+Rx8yxLMZ6r6fg
	 TvGem7l579ZC5Ca4GMYn72p7zvHWQUFtiP3d4AbFqPK30ib3DARnpYqL9i1C5Y6/8m
	 dEYJQjhNqu+UE+Aj9wNvUc8sFLekJrQ5hNrXZ3sAJvMNQC/ZwjDYtUhLquo8TvWD+t
	 cdxh5F8HK+tf3cbkWjXv1hqkSw7kp1nb5IyeGyGsHTm8D1eB3q3Ombye9qpPQOptAJ
	 L9O/w2cgxYlhw==
Date: Thu, 17 Oct 2024 12:11:59 -0700
Subject: [PATCH 2/2] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919073576.3456438.9149796427691706950.stgit@frogsfrogsfrogs>
In-Reply-To: <172919073537.3456438.5908736022117741188.stgit@frogsfrogsfrogs>
References: <172919073537.3456438.5908736022117741188.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

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
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d6c10855ab023b..4d47a3e723aa13 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -403,7 +403,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

