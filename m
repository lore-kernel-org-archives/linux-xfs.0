Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74C7149C53
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850697; cv=none; b=rpsXSDgxxMQ7gx3HSDDoFQ/X9Q/BujqNWueYd+bMKcshwDfkxJoRy/T6iF/rOGD3xlw1iDn9MOZxhBWS45VOVsZcv4cXKEb/x/hwHD6W1RxtVys9kduhw3Tau1UDJzt4lWX9O8sj9k8q0Ckzfic1SOItZt5SCxfiHldunaAxPE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850697; c=relaxed/simple;
	bh=b7es/6kOPGufhV+/8pXyMKiQMyVPjjtIv1afBnaSRCg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=oqkACd8JFxwV5/VLzMJ5YikUwBDTJ/xtU45wbZgkNKV5WfsGaDq3l6Uf7n615X8if1LDV2wY5hgicrgIgvOM1oQ7YJiAhGD86CDmf5m3fM9ArHxD4uT5ihKI76+mx9AVEnAyOPZVIDoFkF6Ru1ubqWtQ9FVjuFZ3L9ey/xmEjGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CR01ldJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CR01ldJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FEEDC4CECF;
	Tue,  5 Nov 2024 23:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850697;
	bh=b7es/6kOPGufhV+/8pXyMKiQMyVPjjtIv1afBnaSRCg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CR01ldJij2pkKyCkPt/tKaSl3FCpiR3/88HR0O/R5BQCNkuRBc/OKcrCqK46b7gLD
	 zz8lY4VXXDcoRZdmiiYwFYbwDGrIe070Ajg5IqBybsyR3Oroit4PGtaAByBCnRo6if
	 E7YhO0g0LWuXSgjtHoUQpQf66yVp9n6HSkNBLZrp6lRDYRQxk7bJKCTD8uyNJu8BIZ
	 1PV8abwHYUAQwYokAcxQvZ+xj1bYjbbl+R5FCIU5+j2HPno1WL9WaSiRUwWVBPFunP
	 JHUSN8UvetGPFljAJBOzyn8q/gLpbJlSHyPJzS5+CoS+c68d5iDp6Aqz34AhSH4Chy
	 OZb+m6+WvADBw==
Date: Tue, 05 Nov 2024 15:51:37 -0800
Subject: [GIT PULL 06/10] xfs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054392.1980968.17940314938964656340.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 64c58d7c99343a910edf995e15d8037e19ec5777:

iomap: add a merge boundary flag (2024-11-05 13:38:39 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-groups-6.13_2024-11-05

for you to fetch changes up to a3315d11305f5c2d82fcb00e3df34775adff4084:

xfs: use rtgroup busy extent list for FITRIM (2024-11-05 13:38:44 -0800)

----------------------------------------------------------------
xfs: shard the realtime section [v5.5 06/10]

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

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (2):
xfs: add a helper to prevent bmap merges across rtgroup boundaries
xfs: make the RT allocator rtgroup aware

Darrick J. Wong (32):
xfs: define the format of rt groups
xfs: check the realtime superblock at mount time
xfs: update realtime super every time we update the primary fs super
xfs: export realtime group geometry via XFS_FSOP_GEOM
xfs: check that rtblock extents do not break rtsupers or rtgroups
xfs: add frextents to the lazysbcounters when rtgroups enabled
xfs: convert sick_map loops to use ARRAY_SIZE
xfs: record rt group metadata errors in the health system
xfs: export the geometry of realtime groups to userspace
xfs: add block headers to realtime bitmap and summary blocks
xfs: encode the rtbitmap in big endian format
xfs: encode the rtsummary in big endian format
xfs: grow the realtime section when realtime groups are enabled
xfs: store rtgroup information with a bmap intent
xfs: force swapext to a realtime file to use the file content exchange ioctl
xfs: support logging EFIs for realtime extents
xfs: support error injection when freeing rt extents
xfs: use realtime EFI to free extents when rtgroups are enabled
xfs: don't merge ioends across RTGs
xfs: don't coalesce file mappings that cross rtgroup boundaries in scrub
xfs: scrub the realtime group superblock
xfs: repair realtime group superblock
xfs: scrub metadir paths for rtgroup metadata
xfs: mask off the rtbitmap and summary inodes when metadir in use
xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
xfs: adjust min_block usage in xfs_verify_agbno
xfs: move the min and max group block numbers to xfs_group
xfs: port the perag discard code to handle generic groups
xfs: implement busy extent tracking for rtgroups
xfs: use rtgroup busy extent list for FITRIM

fs/xfs/Makefile                  |   1 +
fs/xfs/libxfs/xfs_ag.c           |  22 +-
fs/xfs/libxfs/xfs_ag.h           |  16 +-
fs/xfs/libxfs/xfs_alloc.c        |  15 +-
fs/xfs/libxfs/xfs_alloc.h        |  12 +-
fs/xfs/libxfs/xfs_bmap.c         |  84 +++++-
fs/xfs/libxfs/xfs_defer.c        |   6 +
fs/xfs/libxfs/xfs_defer.h        |   1 +
fs/xfs/libxfs/xfs_format.h       |  74 ++++-
fs/xfs/libxfs/xfs_fs.h           |  28 +-
fs/xfs/libxfs/xfs_group.h        |  33 +++
fs/xfs/libxfs/xfs_health.h       |  42 +--
fs/xfs/libxfs/xfs_ialloc_btree.c |   2 +-
fs/xfs/libxfs/xfs_log_format.h   |   6 +-
fs/xfs/libxfs/xfs_log_recover.h  |   2 +
fs/xfs/libxfs/xfs_ondisk.h       |   4 +-
fs/xfs/libxfs/xfs_rtbitmap.c     | 225 ++++++++++++---
fs/xfs/libxfs/xfs_rtbitmap.h     | 114 ++++++--
fs/xfs/libxfs/xfs_rtgroup.c      | 223 ++++++++++++++-
fs/xfs/libxfs/xfs_rtgroup.h      | 104 +++----
fs/xfs/libxfs/xfs_sb.c           | 232 ++++++++++++++--
fs/xfs/libxfs/xfs_sb.h           |   6 +-
fs/xfs/libxfs/xfs_shared.h       |   4 +
fs/xfs/libxfs/xfs_types.c        |  35 ++-
fs/xfs/scrub/agheader.c          |  15 +-
fs/xfs/scrub/agheader_repair.c   |   4 +-
fs/xfs/scrub/bmap.c              |  16 +-
fs/xfs/scrub/common.h            |   2 +
fs/xfs/scrub/fscounters_repair.c |   9 +-
fs/xfs/scrub/health.c            |  32 ++-
fs/xfs/scrub/metapath.c          |  92 +++++++
fs/xfs/scrub/repair.c            |   6 +-
fs/xfs/scrub/repair.h            |   3 +
fs/xfs/scrub/rgsuper.c           |  84 ++++++
fs/xfs/scrub/rtsummary.c         |   5 +
fs/xfs/scrub/rtsummary_repair.c  |  15 +-
fs/xfs/scrub/scrub.c             |   7 +
fs/xfs/scrub/scrub.h             |   2 +
fs/xfs/scrub/stats.c             |   1 +
fs/xfs/scrub/trace.h             |   4 +-
fs/xfs/xfs_bmap_item.c           |  25 +-
fs/xfs/xfs_bmap_util.c           |  18 +-
fs/xfs/xfs_buf_item_recover.c    |  37 ++-
fs/xfs/xfs_discard.c             | 187 ++++++++++++-
fs/xfs/xfs_exchrange.c           |   2 +-
fs/xfs/xfs_extent_busy.c         |   6 +
fs/xfs/xfs_extfree_item.c        | 270 +++++++++++++++---
fs/xfs/xfs_health.c              | 183 +++++++------
fs/xfs/xfs_ioctl.c               |  39 ++-
fs/xfs/xfs_iomap.c               |  13 +-
fs/xfs/xfs_log_recover.c         |   2 +
fs/xfs/xfs_mount.h               |  15 +-
fs/xfs/xfs_rtalloc.c             | 577 +++++++++++++++++++++++++++++++++++----
fs/xfs/xfs_rtalloc.h             |   6 +
fs/xfs/xfs_super.c               |  12 +-
fs/xfs/xfs_trace.h               | 150 +++++++---
fs/xfs/xfs_trans.c               |  64 +++--
fs/xfs/xfs_trans.h               |   2 +
fs/xfs/xfs_trans_buf.c           |  25 +-
59 files changed, 2704 insertions(+), 517 deletions(-)
create mode 100644 fs/xfs/scrub/rgsuper.c

