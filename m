Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20412F34
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606859; cv=none; b=kvZ4phmjAJCTEXu2J0378+3kjk/m5W+ZPvhDu7y998HqHO/rWaGGuEsLxXcA2/k8VZQnAztw2RguYxwPbYmZVAlUVAm4tCI+TkqoY8CRzl6Jm5HCFInzRrEQjxMwekJbbVzwoY9Y6P6OKnjsMZhY99QtiRRker/3zOvGva9EmEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606859; c=relaxed/simple;
	bh=fk1CYNcY1SodBLlN9DCr7mEb8o34eMtzOmIDZGu3KOI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fDawCU0nLKllwPu0zXX3U0Od3rjWnVF+4ZRySnmTt7E/az5RC2keimbAtnqu+yA41gJCRKAmauirRFR/UWdEBBuqFldgRgndV1qH3GJrvtfov9Gzswu/xOtfLB9HgF4TIFnkcpsz9+1NkIHgLA7tafH5FfjFoYKCzrJjzy7h2zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dhmlf7P1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dhmlf7P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CFCC4CEC5;
	Fri, 11 Oct 2024 00:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606858;
	bh=fk1CYNcY1SodBLlN9DCr7mEb8o34eMtzOmIDZGu3KOI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dhmlf7P1BalWHqSDOeDc4vqzN9v+6FYniJlkP/wAYHqJmE10kihiTMnm+G83zSGWv
	 mWffk3oJI+Siemo4jyf1nTodUmZ2hfvgicAUCycDvlwGlrCYpcp+/uidV3lzZ0QsUI
	 NRGV7P2aR/Jw5vJBNutpdwdpLxyW4k9Uw+LWtDhyDj0roPQ9N/ExriXe/rgw0+3/jb
	 aQrVg6Di32Tl9z4783nSWj2OdZFlLzLcg5XCs5LEj/lU3XlNFAmLYXPAbOVs1PXFUs
	 54HIGr+Lq0jYukN4ujWpcJldeFiMAzn6tq06mLBG6ukuYXOHsCvzrJvoxXxR4n5EBC
	 LJuIVG9OUadcw==
Date: Thu, 10 Oct 2024 17:34:17 -0700
Subject: [PATCHSET v5.0 4/9] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
In-Reply-To: <20241011002402.GB21877@frogsfrogsfrogs>
References: <20241011002402.GB21877@frogsfrogsfrogs>
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

Add in-memory data structures for sharding the realtime volume into
independent allocation groups.  For existing filesystems, the entire rt
volume is modelled as having a single large group, with (potentially) a
number of rt extents exceeding 2^32 blocks, though these are not likely
to exist because the codebase has been a bit broken for decades.  The
next series fills in the ondisk format and other supporting structures.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-rtgroups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=incore-rtgroups
---
Commits in this patchset:
 * xfs: clean up xfs_getfsmap_helper arguments
 * xfs: create incore realtime group structures
 * xfs: define locking primitives for realtime groups
 * xfs: add a lockdep class key for rtgroup inodes
 * xfs: support caching rtgroup metadata inodes
 * xfs: add rtgroup-based realtime scrubbing context management
 * xfs: add a xfs_bmap_free_rtblocks helper
 * xfs: add a xfs_qm_unmount_rt helper
 * xfs: factor out a xfs_growfs_rt_alloc_blocks helper
 * xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
 * xfs: split xfs_trim_rtdev_extents
 * xfs: move RT bitmap and summary information to the rtgroup
 * xfs: support creating per-RTG files in growfs
 * xfs: remove XFS_ILOCK_RT*
 * xfs: calculate RT bitmap and summary blocks based on sb_rextents
 * xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
 * xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
 * xfs: factor out a xfs_growfs_check_rtgeom helper
 * xfs: refactor xfs_rtbitmap_blockcount
 * xfs: refactor xfs_rtsummary_blockcount
 * xfs: make RT extent numbers relative to the rtgroup
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   46 ++-
 fs/xfs/libxfs/xfs_format.h      |    3 
 fs/xfs/libxfs/xfs_group.c       |    8 +
 fs/xfs/libxfs/xfs_rtbitmap.c    |  199 ++++++++-------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  147 ++++++-----
 fs/xfs/libxfs/xfs_rtgroup.c     |  462 +++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h     |  265 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    7 +
 fs/xfs/libxfs/xfs_trans_resv.c  |    2 
 fs/xfs/libxfs/xfs_types.h       |    8 +
 fs/xfs/scrub/bmap.c             |   13 +
 fs/xfs/scrub/common.c           |   78 ++++++
 fs/xfs/scrub/common.h           |   30 ++
 fs/xfs/scrub/fscounters.c       |   25 +-
 fs/xfs/scrub/repair.c           |   24 ++
 fs/xfs/scrub/repair.h           |    7 +
 fs/xfs/scrub/rtbitmap.c         |   54 ++--
 fs/xfs/scrub/rtsummary.c        |  111 ++++----
 fs/xfs/scrub/rtsummary_repair.c |    7 -
 fs/xfs/scrub/scrub.c            |   33 ++
 fs/xfs/scrub/scrub.h            |   13 +
 fs/xfs/xfs_bmap_util.c          |    3 
 fs/xfs/xfs_discard.c            |  100 +++++---
 fs/xfs/xfs_fsmap.c              |  329 ++++++++++++++-----------
 fs/xfs/xfs_fsmap.h              |   15 +
 fs/xfs/xfs_inode.c              |    3 
 fs/xfs/xfs_inode.h              |   13 -
 fs/xfs/xfs_iomap.c              |    4 
 fs/xfs/xfs_log_recover.c        |   15 +
 fs/xfs/xfs_mount.c              |   15 +
 fs/xfs/xfs_mount.h              |   26 +-
 fs/xfs/xfs_qm.c                 |   27 ++
 fs/xfs/xfs_rtalloc.c            |  518 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_super.c              |    4 
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   74 ++++--
 37 files changed, 1980 insertions(+), 710 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h

