Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00FA3FF1A3
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860041; cv=none; b=Hl3A8fBOqYVlRPxQxGNUVXXGOXLLYzZWYbv7EuTNFBfsjGSjFFmQJMOF1+f3GnuTu8kSIo7J2JEy7tB+FtbPeVL5d9tf2Y8XEddhNbAJp6O2nMss4VFKloLB0KhuSBW00heHQJniNca1cyDRt6H8hJm6OKpx1g4H1qolzZJ/wbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860041; c=relaxed/simple;
	bh=8Kcy8SsfY/PYkfYONe5XipLy4Ld4goOY+BjuS6sLSgg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O7fxCKfVvCVKWODpdF8YguiH4Btuw8ICUGqPzDsJenMipt1BVT32Jvc/LsM9z8mOHBhFhvsG1z+GDsPyPzQDJxPenpBjolKYLgKwpZgI+s3SSEowTHYWfYXO0sz4NLdpaW/MDGxmAEVBkGkQvALIUHWPny0aVWrLcWvSloO3psM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tt5TJ1rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tt5TJ1rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78108C2BCB0;
	Fri, 15 May 2026 15:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778860041;
	bh=8Kcy8SsfY/PYkfYONe5XipLy4Ld4goOY+BjuS6sLSgg=;
	h=Date:From:To:Cc:Subject:From;
	b=tt5TJ1rgY7t3zeXqhhplsSz4wp/5BKtPX00WHV/zmwbUfPgl3Sj3KG7NsysixByS2
	 FyHG3cqkbz+ucAZqd56Xa2q9PK6SQKbLKX87yLhI3BVmBdY3QM26KL5x5MnzaNrDsD
	 fr0U7R1dyADdydpj+H3AfUgjfKZ8Qa4QG/T/FI2V1gYKIA3oh0wEN+zFwow7fxySqm
	 +ucoWowaFaNAtLPC62itCxaYdtcIqQPeFMUjA1mmEZq+RjC3TE/mm74nxyNItbyhIx
	 5nQIKoemcE/LfySQ9rhPx9RYR3qI/4TEaf7BGz5cZ83ih8OFrKrBcHRQHEZkVDeyOh
	 9G0C+sMA8bWtQ==
Date: Fri, 15 May 2026 17:47:17 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.1-rc4
Message-ID: <agc_BzMjfmkuojM5@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful.

This contains a few bug fixes, nothing really special stands out.

Thanks,
Carlos

"The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.1-rc4

for you to fetch changes up to 509fdeb3326be0db055e88d0f689a3888f147f90:

  xfs: Fix typo in comment (2026-05-11 12:58:38 +0200)

----------------------------------------------------------------
xfs: fixes for v7.1-rc4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
      xfs: fix the "limiting open zones" message

Jinliang Zheng (1):
      xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING

Md Shofiqul Islam (1):
      xfs: Fix typo in comment

Ravi Singh (1):
      xfs: flush delalloc blocks on ENOSPC in xfs_trans_alloc_icreate

Wilfred Mallawa (2):
      xfs: fix memory leak on error in xfs_alloc_zone_info()
      xfs: fix memory leak for data allocated by xfs_zone_gc_data_alloc()

Yuto Ohnuki (4):
      xfs: zero entire directory data block header region at init
      xfs: zero directory data block padding on write verification
      xfs: check directory data block header padding in scrub
      xfs: check da node block pad field during scrub

 fs/xfs/libxfs/xfs_dir2_data.c | 18 +++++++++++-------
 fs/xfs/libxfs/xfs_refcount.c  |  3 +--
 fs/xfs/scrub/common.c         | 11 +++++++++++
 fs/xfs/scrub/common.h         |  2 ++
 fs/xfs/scrub/dabtree.c        |  7 ++++++-
 fs/xfs/scrub/dir.c            |  7 ++++++-
 fs/xfs/xfs_inode.c            |  6 ------
 fs/xfs/xfs_notify_failure.c   |  2 +-
 fs/xfs/xfs_trans.c            | 11 +++++++++++
 fs/xfs/xfs_zone_alloc.c       |  4 ++--
 fs/xfs/xfs_zone_gc.c          |  2 +-
 11 files changed, 52 insertions(+), 21 deletions(-)"
