Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239281D417F
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801634; cv=none; b=qJlsL/ADQcMctvjp5ZlrjSTC8q5RcbXCljRzi78uiqfk4Y+EUcclfO3vHjITb0CkwZOZh+oC//wmw24A+Di5uzTeHkwefM/LYhuCX2BIoIUwd0DmMV+Pnheu2/NM+Z1n0cluq3zxm5zAYUZumB9/cC4YSx6PWrhm73ukzZ80CEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801634; c=relaxed/simple;
	bh=eEgW/SV+sck23Y+yNVc3y0162C1r1f8gJRF2FWYmBx0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=T1WFNhJUWi9XUSh8oMvuXjxxI5gmcHJ2CisewHJZiIjWrILRy/O//UMABb1AoulJk3x0sVOqzVHQxJE9UYlrPdMupnP9yjNOI/nnPGhqSKnX3lEBmZ+WXoPvT36NPyFrF0IX3vYnlZsGynmYYoktXKMj/X7m8HgFiVkRzMos6Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVG+mSo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVG+mSo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D3AC53FC4;
	Tue, 27 Aug 2024 23:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801633;
	bh=eEgW/SV+sck23Y+yNVc3y0162C1r1f8gJRF2FWYmBx0=;
	h=Date:Subject:From:To:Cc:From;
	b=FVG+mSo1JtlYQDEYARyFK+lgb3ucbTVsJAikceYVM0nVOg2Xx4Uff4N9rho+bUY/j
	 UOD8YFR42zrSFegsK+i+13KR0hi1YwrBOKcC1fYXz+ARw4mZIJ2syWyQc0SkviW0It
	 LdHa86+DfTuVTVDSSzpIIvgAGd+2MVaNtIRAG8X9fymv312C8cHZTjTIHmsrGHUhnU
	 ShNi8eFsRo2WZj3dEp7SI9sXSjyLrBV6M1SF/vz38EGULAFcdk6vCcXf2OgHmL1j2m
	 Gh3OUOqDRLckl4moAEETutKhKlytaOiKcA+oSWNGBaFT97aF8yBIiQh4Aljpeiowjn
	 kF+YBaMsk72ew==
Date: Tue, 27 Aug 2024 16:33:52 -0700
Subject: [PATCHSET v4.1] xfs: cleanups for inode rooted btree code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: sam@gentoo.org, kernel@mattwhitlock.name, linux-xfs@vger.kernel.org,
 hch@lst.de
Message-ID: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series prepares the btree code to support realtime reverse mapping btrees
by refactoring xfs_ifork_realloc to be fed a per-btree ops structure so that it
can handle multiple types of inode-rooted btrees.  It moves on to refactoring
the btree code to use the new realloc routines.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-cleanups
---
Commits in this patchset:
 * xfs: fix C++ compilation errors in xfs_fs.h
 * xfs: fix FITRIM reporting again
 * xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
 * xfs: replace shouty XFS_BM{BT,DR} macros
 * xfs: move the zero records logic into xfs_bmap_broot_space_calc
 * xfs: refactor the allocation and freeing of incore inode fork btree roots
 * xfs: refactor creation of bmap btree roots
 * xfs: hoist the code that moves the incore inode fork broot memory
 * xfs: rearrange xfs_iroot_realloc a bit
 * xfs: standardize the btree maxrecs function parameters
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 -
 fs/xfs/libxfs/xfs_attr_leaf.c      |    8 +
 fs/xfs/libxfs/xfs_bmap.c           |   62 +++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c     |   37 ++++--
 fs/xfs/libxfs/xfs_bmap_btree.h     |  216 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_fs.h             |    4 -
 fs/xfs/libxfs/xfs_ialloc.c         |    4 -
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 +
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 -
 fs/xfs/libxfs/xfs_inode_fork.c     |  192 ++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_inode_fork.h     |    3 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 +
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 -
 fs/xfs/libxfs/xfs_sb.c             |   16 +--
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/scrub/bmap_repair.c         |    2 
 fs/xfs/scrub/inode_repair.c        |   12 +-
 fs/xfs/xfs_bmap_util.c             |    4 -
 fs/xfs/xfs_discard.c               |    2 
 22 files changed, 363 insertions(+), 237 deletions(-)

