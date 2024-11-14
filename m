Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECB5F9DF
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543548; cv=none; b=VQf7MkhHUASk48b4qX3dmQPk7IvzWyxaIA7fViyP1gKFu9z6OpnOz9JLkWpQQ/Mn3qxu+9ByffXISxiom7CamTYXwMQ4uvpMbX+/5F/snJ0hHUnSZFVRbj2EkEdTeiVoIZ7Frzh2s8+Oz8xKkZ7GzXKGX3PRCXwCAEHdymFX5uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543548; c=relaxed/simple;
	bh=tJMPUi42rAt1ynbGcjNatYy275g4RZUQkxRj2rXfdBY=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=kOE9YiYrMm/c0puyXMqrqg1040mv9Im+v1a91CfAjPyz+P1GRBCKt9Tf5aJ22LqHg5mvXwVyQQejKmWxafWMD1e4FggyCbnZC0ca4j6nFvc9lXF9jNMuBCuz7/DaSI00s0vlBCZhWLNLtQIiU4yTWxLYTB+Qwksb3ivSviSpLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jnCIs51H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jnCIs51H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8533C4CEC3;
	Thu, 14 Nov 2024 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543547;
	bh=tJMPUi42rAt1ynbGcjNatYy275g4RZUQkxRj2rXfdBY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jnCIs51HSV/RlnBiEqW/AdrurUB9dXcllHyZ9yBK0knBLHg3BUk9nmxi0K4NJ6gdg
	 c3qKZUOvbCB5WJR+zyADD+fmMdNXlx4uFC+UXQBZqBfS+sBuIHe0XLA/lzvKss5fQC
	 y19U6GUS6nd+twPmMnrTPDr8UIgNKvgOLDv3+HvykZ4HzcKowlwHsMd/Yx/QjBAn+R
	 ue147Qbi++vn/2IahTIplpk5xbUXJSP4TRnEKN2gJlejJZmtST8rO1q21A2qQYocIu
	 etGaGcxmnx+moiCHr/nZjBhRTC6RsJRRejEz80/GlQtb9yNBQ1q4fH3YIp0jhUgWJc
	 Wk4M9V4OQU6fg==
Date: Wed, 13 Nov 2024 16:19:07 -0800
Subject: [GIT PULL 06/10] xfs: shard the realtime section
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342386.1140548.545475601428791717.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 320c28fb42f571064ddc9b769dfaa3a59c105677:

iomap: add a merge boundary flag (2024-11-13 16:05:32 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/realtime-groups-6.13_2024-11-13

for you to fetch changes up to 4e88a1158f8c167b47a0f115b74d4ffbc1c9901d:

xfs: use rtgroup busy extent list for FITRIM (2024-11-13 16:05:38 -0800)

----------------------------------------------------------------
xfs: shard the realtime section [v5.6 06/10]

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

