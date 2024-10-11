Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165D9EADA
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609251; cv=none; b=gAB5B6Lz/lyxslB1HJoPncY3rT5UDj7FtZfoPUTs5lS72rY7do73ppFOmkUgK0Okh/ld0Civt5y+ruzjuN7aB5hbQOTgahSO2r0pnvxKxhGGkAP4SSlPvQpA+/QjEkDeZhBkl7yUXvmKYcXwO/JFyRy3hwa9wmg2iaNZi2xWztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609251; c=relaxed/simple;
	bh=dvILRHLIo+ei2ZZ5pWFTNt6qSPiXZeamjnShEKr6Hb8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vyy+OY8toycwq2bh703UgStcfddS11vTtw6H3t9QzeUCwz0B9l4gZNG3G88TUmVEbllvCwP6kfdSX8SruuDpy7Qu5zj1VShtpSzk97Hfu8JuqSaSC/POwKf0/QTyYbzKKHH+RcScd2bIIEXhdjUx5ypWC+1Opc5wMOXcVYhvgug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvEIUPJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvEIUPJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DEEC4CEC5;
	Fri, 11 Oct 2024 01:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609250;
	bh=dvILRHLIo+ei2ZZ5pWFTNt6qSPiXZeamjnShEKr6Hb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uvEIUPJoJ3X5h7VZ3UjMcsLsYpwrsAHwisf86XuDw+3lIFvMI+zR+drA1UvBCV/RV
	 aR64ho/bxuMNDnKPbukwPu8euAg2WRyLQ718jD7Px+3TExtIZFT+zjSr8EVbCY31SM
	 shM1BsnL0ByRAIjy0WpK2pjocQ0ndv/hxyFCO1x0TgVH/wMfL/BJgINNuJLj0zcyKF
	 76ncs7swoxoL1261ZuRoDKfnFUovfmwwwRnCZecaUve9EODgTEVLsW29jxqIIw4cpR
	 rvTPxg7Wqs77vFF+ytP4qCv95xRW3wAhZaBQWtltA+ECo1o+Lqjjfazoez0KmFEfw5
	 xcPAX9y9biI8g==
Date: Thu, 10 Oct 2024 18:14:10 -0700
Subject: [PATCH 2/2] xfs: enable metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860646167.4180365.12478247512548125047.stgit@frogsfrogsfrogs>
In-Reply-To: <172860646128.4180365.15337586086476354855.stgit@frogsfrogsfrogs>
References: <172860646128.4180365.15337586086476354855.stgit@frogsfrogsfrogs>
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
index ac1fbc6ca28870..e75545f9161d61 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -414,7 +414,8 @@ xfs_sb_has_ro_compat_feature(
 		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR | \
 		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
 		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
-		 XFS_SB_FEAT_INCOMPAT_PARENT)
+		 XFS_SB_FEAT_INCOMPAT_PARENT | \
+		 XFS_SB_FEAT_INCOMPAT_METADIR)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool

