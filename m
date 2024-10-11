Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECDDBA27
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728606890; cv=none; b=LCfj6noE5JFn4AWGCJK2rWMZmndwj8cO9b+hjCpYp+cxFarfKMwO8qa4zIbSInfPshawKBtKRxB/zFPX7RzPTochrs4MhUms1u7ZXB3yA48V4wvFJgTQbpYJNlCsC1OPCZ+eIthBJH5Ha56YJKA++15WKS70ibUbJ0+lHQaUGQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728606890; c=relaxed/simple;
	bh=JXn5s3S0A7oeUsJIVlvY/X182+JKRcLFCS01Ks2vVEQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oJXgJkdEgjoLp+X+aKUB21QfD+cnN+IdABYEUePabBV6IDo48gNee97UoCCHwpwdFGIJ5OWlRrNxC6hKMk9LgjUkDRycQHjlXkTMclp/wdOwInf542BvjSIQu7FisIkGkCcxwExQgNfY66HlKXNGYbaTgMuGT0Fr2i/trkuisjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XmeYAILB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XmeYAILB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2821C4CEC5;
	Fri, 11 Oct 2024 00:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728606889;
	bh=JXn5s3S0A7oeUsJIVlvY/X182+JKRcLFCS01Ks2vVEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XmeYAILB3W0ssZGRviyY/ayReJl0cunAK7sFAQk2C4UJvyKYBb2cwAPyHvRvE5FBc
	 fu5bOfj65p3zgpEyFs/dYCpg4TqcQDAlmxiMJj0aCfPFZuFihmlXZJSZGkEzYrNEvo
	 aesMrX06g/AUyT3JvfR4bVoSzOmsbUj7ehHC7o5HpE6cmdwgNZGMd++pSzC7bco3TN
	 4KRkK2bNo7U/ISduEU+87eWW19IW1+0k0xzoXw4TwD2YNaOHknFdjAggDlwaF9zCBw
	 +8ZVHKorKCzuzqGwmIe5/4FjAU3D401vb/bHrgfbQjy+qYr2PEHIPW/n5Ci6ujDJpm
	 DGSZLbIlwvxlw==
Date: Thu, 10 Oct 2024 17:34:49 -0700
Subject: [PATCHSET v5.0 6/9] xfs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Right now, the realtime section uses a single pair of metadata inodes to
store the free space information.  This presents a scalability problem
since every thread trying to allocate or free rt extents have to lock
these files.  Solve this problem by sharding the realtime section into
separate realtime allocation groups.

While we're at it, define a superblock to be stamped into the start of
the rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and avoids the situation where
anything written into block 0 of the realtime extent can be
misinterpreted as file data.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

This is a very large patchset, but it catches us up with 20 years of
technical debt that have accumulated.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-groups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-groups

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-groups

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups
---
Commits in this patchset:
 * xfs: define the format of rt groups
 * xfs: check the realtime superblock at mount time
 * xfs: update realtime super every time we update the primary fs super
 * xfs: export realtime group geometry via XFS_FSOP_GEOM
 * xfs: check that rtblock extents do not break rtsupers or rtgroups
 * xfs: add a helper to prevent bmap merges across rtgroup boundaries
 * xfs: add frextents to the lazysbcounters when rtgroups enabled
 * xfs: convert sick_map loops to use ARRAY_SIZE
 * xfs: record rt group metadata errors in the health system
 * xfs: export the geometry of realtime groups to userspace
 * xfs: add block headers to realtime bitmap and summary blocks
 * xfs: encode the rtbitmap in big endian format
 * xfs: encode the rtsummary in big endian format
 * xfs: grow the realtime section when realtime groups are enabled
 * xfs: store rtgroup information with a bmap intent
 * xfs: force swapext to a realtime file to use the file content exchange ioctl
 * xfs: support logging EFIs for realtime extents
 * xfs: support error injection when freeing rt extents
 * xfs: use realtime EFI to free extents when rtgroups are enabled
 * xfs: don't merge ioends across RTGs
 * xfs: make the RT allocator rtgroup aware
 * xfs: don't coalesce file mappings that cross rtgroup boundaries in scrub
 * xfs: scrub the realtime group superblock
 * xfs: repair realtime group superblock
 * xfs: scrub metadir paths for rtgroup metadata
 * xfs: mask off the rtbitmap and summary inodes when metadir in use
 * xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
 * xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
 * xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
 * xfs: move the group geometry into struct xfs_groups
 * xfs: add a xfs_rtbno_is_group_start helper
 * xfs: fix minor bug in xfs_verify_agbno
 * xfs: move the min and max group block numbers to xfs_group
 * xfs: port the perag discard code to handle generic groups
 * xfs: implement busy extent tracking for rtgroups
 * xfs: use rtgroup busy extent list for FITRIM
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_ag.c           |   15 +
 fs/xfs/libxfs/xfs_ag.h           |   16 -
 fs/xfs/libxfs/xfs_alloc.c        |   15 +
 fs/xfs/libxfs/xfs_alloc.h        |   12 +
 fs/xfs/libxfs/xfs_bmap.c         |   84 +++++-
 fs/xfs/libxfs/xfs_defer.c        |    6 
 fs/xfs/libxfs/xfs_defer.h        |    1 
 fs/xfs/libxfs/xfs_format.h       |   84 +++++-
 fs/xfs/libxfs/xfs_fs.h           |   29 ++
 fs/xfs/libxfs/xfs_group.c        |   34 --
 fs/xfs/libxfs/xfs_group.h        |   94 ++++++
 fs/xfs/libxfs/xfs_health.h       |   42 ++-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 
 fs/xfs/libxfs/xfs_log_format.h   |    6 
 fs/xfs/libxfs/xfs_log_recover.h  |    2 
 fs/xfs/libxfs/xfs_ondisk.h       |    4 
 fs/xfs/libxfs/xfs_rtbitmap.c     |  225 ++++++++++++---
 fs/xfs/libxfs/xfs_rtbitmap.h     |  114 ++++++--
 fs/xfs/libxfs/xfs_rtgroup.c      |  223 ++++++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.h      |  104 ++++---
 fs/xfs/libxfs/xfs_sb.c           |  226 +++++++++++++--
 fs/xfs/libxfs/xfs_sb.h           |    6 
 fs/xfs/libxfs/xfs_shared.h       |    4 
 fs/xfs/libxfs/xfs_types.c        |   35 ++
 fs/xfs/scrub/agheader.c          |    8 -
 fs/xfs/scrub/agheader_repair.c   |    4 
 fs/xfs/scrub/bmap.c              |   16 +
 fs/xfs/scrub/common.h            |    2 
 fs/xfs/scrub/fscounters_repair.c |    9 -
 fs/xfs/scrub/health.c            |   32 +-
 fs/xfs/scrub/metapath.c          |   92 ++++++
 fs/xfs/scrub/repair.c            |    6 
 fs/xfs/scrub/repair.h            |    3 
 fs/xfs/scrub/rgsuper.c           |   84 ++++++
 fs/xfs/scrub/rtsummary.c         |    5 
 fs/xfs/scrub/rtsummary_repair.c  |   15 +
 fs/xfs/scrub/scrub.c             |    7 
 fs/xfs/scrub/scrub.h             |    2 
 fs/xfs/scrub/stats.c             |    1 
 fs/xfs/scrub/trace.h             |    4 
 fs/xfs/xfs_bmap_item.c           |   25 +-
 fs/xfs/xfs_bmap_util.c           |   18 +
 fs/xfs/xfs_buf_item_recover.c    |   43 +++
 fs/xfs/xfs_discard.c             |  187 +++++++++++-
 fs/xfs/xfs_exchrange.c           |    2 
 fs/xfs/xfs_extent_busy.c         |    6 
 fs/xfs/xfs_extfree_item.c        |  270 ++++++++++++++++--
 fs/xfs/xfs_health.c              |  183 ++++++------
 fs/xfs/xfs_ioctl.c               |   39 +++
 fs/xfs/xfs_iomap.c               |   13 +
 fs/xfs/xfs_log_recover.c         |    2 
 fs/xfs/xfs_mount.h               |   45 +++
 fs/xfs/xfs_rtalloc.c             |  577 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_rtalloc.h             |    6 
 fs/xfs/xfs_super.c               |   12 +
 fs/xfs/xfs_trace.c               |    2 
 fs/xfs/xfs_trace.h               |  147 +++++++---
 fs/xfs/xfs_trans.c               |   64 +++-
 fs/xfs/xfs_trans.h               |    2 
 fs/xfs/xfs_trans_buf.c           |   25 +-
 61 files changed, 2785 insertions(+), 557 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c

