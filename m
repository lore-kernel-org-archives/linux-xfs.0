Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F75718732B
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371111; cv=none; b=pbo/RhYEvnmoeKQOOUGOny/eMCxyJCZbwsPse1+K82ZkRmOs+zA449CnO6iwtwzHYcsRP9WT8fFXWjxHCZEgNnIfVVMFpdaspIwUXBN0kZm+Y3JXwqOOpf2Wd8OvZkKS50FhcL4OWo37p/LOuKdpbu4m4BmCvrsFJ914gDFsws4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371111; c=relaxed/simple;
	bh=xLPjQjogIfWaoaaEEC9SRoZ+kJoxjMFE2CGZ2Tte3mM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KoLtH0Pc9glkwdauEqIpIKJXe7FyQaFCjmo6DTZ572gPki0ftcdZv+WhOgKIcI1q5IuwlgG6eMcHRVrV/h70cJh/FhmteBkPZYHMV/lHq7l4HHGNXa/SrHyG4/4rm0Z4qTKy2nCON7tTUOTCKfiNdoCDe268bW0xXSYB2RntwKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jitF/7gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jitF/7gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCF6C32782;
	Thu, 22 Aug 2024 23:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371111;
	bh=xLPjQjogIfWaoaaEEC9SRoZ+kJoxjMFE2CGZ2Tte3mM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jitF/7gkToYfhZWqE/AsNmnPPxLFtdw03jVOcpSv3YL/4+qTuKG8QPv0AMkSN00nT
	 PHt56DdnvUooCzZSvolIjgCgl/UIsP3D/zyhdl5ENQVRR9D/YsRt4BmGGCDxFRnu7B
	 OZpANy8QnB/235cft0FkGtjgF5A7peBB1thAipOnoHG1FRdL8JOadgdJnPMOl0SLtU
	 /J7ham62wyWVqzNwq3roRzC5Sm4fpYtCb4FR3YYKQsznFpbzmOeCYAnq9Xt1lkGU2U
	 2h68NWSCU4NBcKy+pDA8XDkalJmkstwtLNbYN2lphZikBSOR8wck59oF8p2gCzopPo
	 gY1Gp6xKW9zig==
Date: Thu, 22 Aug 2024 16:58:30 -0700
Subject: [PATCHSET v4.0 09/10] xfs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
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
these files.  It would be very useful if we could begin to tackle these
problems by sharding the realtime section, so create the notion of
realtime groups, which are similar to allocation groups on the data
section.

While we're at it, define a superblock to be stamped into the start of
each rt section.  This enables utilities such as blkid to identify block
devices containing realtime sections, and helpfully avoids the situation
where a file extent can cross an rtgroup boundary.

The best advantage for rtgroups will become evident later when we get to
adding rmap and reflink to the realtime volume, since the geometry
constraints are the same for rt groups and AGs.  Hence we can reuse all
that code directly.

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
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_alloc.c        |   15 +
 fs/xfs/libxfs/xfs_alloc.h        |   17 +
 fs/xfs/libxfs/xfs_bmap.c         |   86 ++++++-
 fs/xfs/libxfs/xfs_bmap.h         |    5 
 fs/xfs/libxfs/xfs_defer.c        |    6 +
 fs/xfs/libxfs/xfs_defer.h        |    1 
 fs/xfs/libxfs/xfs_format.h       |   76 ++++++
 fs/xfs/libxfs/xfs_fs.h           |   29 ++
 fs/xfs/libxfs/xfs_health.h       |   61 +++--
 fs/xfs/libxfs/xfs_log_format.h   |    6 -
 fs/xfs/libxfs/xfs_log_recover.h  |    2 
 fs/xfs/libxfs/xfs_ondisk.h       |    4 
 fs/xfs/libxfs/xfs_rtbitmap.c     |  211 +++++++++++++++---
 fs/xfs/libxfs/xfs_rtbitmap.h     |   64 +++++
 fs/xfs/libxfs/xfs_rtgroup.c      |  195 ++++++++++++++++-
 fs/xfs/libxfs/xfs_rtgroup.h      |   20 ++
 fs/xfs/libxfs/xfs_sb.c           |  165 +++++++++++++-
 fs/xfs/libxfs/xfs_sb.h           |    2 
 fs/xfs/libxfs/xfs_shared.h       |    4 
 fs/xfs/libxfs/xfs_types.c        |   38 +++
 fs/xfs/scrub/bmap.c              |   16 +
 fs/xfs/scrub/common.h            |    2 
 fs/xfs/scrub/fscounters_repair.c |    9 -
 fs/xfs/scrub/health.c            |   34 ++-
 fs/xfs/scrub/metapath.c          |   92 ++++++++
 fs/xfs/scrub/repair.h            |    3 
 fs/xfs/scrub/rgsuper.c           |   89 ++++++++
 fs/xfs/scrub/rtsummary.c         |    5 
 fs/xfs/scrub/rtsummary_repair.c  |   15 +
 fs/xfs/scrub/scrub.c             |    7 +
 fs/xfs/scrub/scrub.h             |    2 
 fs/xfs/scrub/stats.c             |    1 
 fs/xfs/scrub/trace.h             |    4 
 fs/xfs/xfs_bmap_item.c           |   18 +-
 fs/xfs/xfs_bmap_util.c           |   12 +
 fs/xfs/xfs_buf_item_recover.c    |   43 +++-
 fs/xfs/xfs_discard.c             |    2 
 fs/xfs/xfs_extfree_item.c        |  281 ++++++++++++++++++++++--
 fs/xfs/xfs_health.c              |  205 +++++++++++------
 fs/xfs/xfs_ioctl.c               |   37 +++
 fs/xfs/xfs_iomap.c               |   14 +
 fs/xfs/xfs_log_recover.c         |    2 
 fs/xfs/xfs_mount.h               |   11 +
 fs/xfs/xfs_rtalloc.c             |  446 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_rtalloc.h             |    6 +
 fs/xfs/xfs_super.c               |   12 +
 fs/xfs/xfs_trace.h               |   30 ++-
 fs/xfs/xfs_trans.c               |   27 ++
 fs/xfs/xfs_trans.h               |    2 
 fs/xfs/xfs_trans_buf.c           |   25 ++
 51 files changed, 2146 insertions(+), 314 deletions(-)
 create mode 100644 fs/xfs/scrub/rgsuper.c

