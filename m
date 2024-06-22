Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B68B224DC
	for <linux-xfs@vger.kernel.org>; Sat, 22 Jun 2024 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719071941; cv=none; b=mjd6ctONFrHovO5bPOzIPWAMdWerqxUcvyI1PQvAzprUoiHK10RHx8/lhHrMmfuGs9i0Vo+7VUJlDx4VAJj0n9cpGzhcYghi5vOQUPrsE1qF+u3kxZDmrBNvlZILI2ud4L4n33XssWjn8BwKp7hbai7LhmDGfwKc96wl7NUjkHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719071941; c=relaxed/simple;
	bh=56qX7PfYiwhHhMa45U+olmC2cm4hKuNKuoabdpi6YMA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=UKw1xR/BFCVmss8fqWeUah++L8YGVrg6EEIF58f2/s2EA6Ej43NHqD7eu5/d1S0zwKxx1P8ZsV91wq/CNtkQhfmJkVh7N7cnx+OTLrd0MZuCWYIkYouR4VngoBZlbsflc0sDnwC957hPCobXhy0glkvoclVSV5gfEYyZjRqTlTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mrEr4myz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mrEr4myz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20406C3277B;
	Sat, 22 Jun 2024 15:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719071941;
	bh=56qX7PfYiwhHhMa45U+olmC2cm4hKuNKuoabdpi6YMA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mrEr4myzrhRPDwozfAUffOQpM+RJUkr/hfL/MEjhmp6V3FJSvjmROqDNX1UVDcOjM
	 3P1gvC6VuzgdT5jcGIwlOzrD4dUYAkb8/JCPO5tdtJ+8cKSdgWq3jxZdIuno37tnh6
	 TBZ9RYA+bjR7+Pz1pMtZqt6hQy9aU/VS8EXYk1xIspFL0UY3SUoMgf77GKOgFLpBVv
	 nz0jX6DxN+XMfPnTdic7gs28DOhLJ1KYqXCbVgVWsqpk36shEKNjSjwvlYn6bB9gEl
	 pEH5WWzu2bgNhm8hBb9YIMxrYlkGFO0FOFpFggNFoKM9NhWLawky04yJyRW1DH4g8u
	 K6BN1HhoW9Q3g==
Date: Sat, 22 Jun 2024 08:59:00 -0700
Subject: [GIT PULL] xfs: random fixes for 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <171907190998.4005061.17863344358205284728.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <None>
References: <None>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc5.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 6ba59ff4227927d3a8530fc2973b80e94b54d58f:

Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/random-fixes-6.10_2024-06-22

for you to fetch changes up to 06400b685a05ef2760d8ba9c8d27d52ced82a83d:

xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs (2024-06-22 08:57:49 -0700)

----------------------------------------------------------------
xfs: random fixes for 6.10 [v2]

Here are some bugfixes for 6.10.  The first two patches are from hch,
and fix some longstanding delalloc leaks that only came to light now
that we've enabled it for realtime.

The second two fixes are from me -- one fixes a bug when we run out
of space for cow preallocations when alwayscow is turned on (xfs/205),
and the other corrects overzealous inode validation that causes log
recovery failure with generic/388.

The last patch is a debugging patch to ensure that transactions never
commit corrupt inodes, buffers, or dquots.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (1):
xfs: fix freeing speculative preallocations for preallocated files

Darrick J. Wong (4):
xfs: restrict when we try to align cow fork delalloc to cowextsz hints
xfs: allow unlinked symlinks and dirs with zero size
xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
xfs: honor init_xattrs in xfs_init_new_inode for !ATTR fs

fs/xfs/libxfs/xfs_bmap.c      | 31 +++++++++++++++++++++++++++----
fs/xfs/libxfs/xfs_fs.h        |  2 +-
fs/xfs/libxfs/xfs_inode_buf.c | 23 ++++++++++++++++++-----
fs/xfs/xfs_bmap_util.c        | 30 ++++++++++++++++++++++--------
fs/xfs/xfs_bmap_util.h        |  2 +-
fs/xfs/xfs_icache.c           |  2 +-
fs/xfs/xfs_inode.c            | 24 +++++++++++++-----------
fs/xfs/xfs_iomap.c            | 34 ++++++++++++----------------------
8 files changed, 95 insertions(+), 53 deletions(-)

