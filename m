Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B983A2563
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530935; cv=none; b=RfdP9AYi8Kh9VvHaPC2kOIERobIyI5UfHoSBy/HPf3hEsA8ztOCBcpstYqCekv5tHApoXUyDpTFYTRwQhAy4A/D/f72rmqloTg7GzjbfLON+XQItatsuY2U4tLKU/FBYpTwO4erRzij4B6a2DsnxJxeJkBk3wefXVnLI1QaS4xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530935; c=relaxed/simple;
	bh=ICQ9hB0qoNG0a5KhQwj7YWoH4tkhpImpcwEKRGmRG/o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jccK7K4FCNiBNU56ThpdZQiM6TmwXHlIsNfSjJJwWw6BYhHUWGI2ABd2wQJzM6Qq8yp7kZZaE7IyJiHSkyttA6F0dp+llkjTx/0yFyeUvu31/b2um201R7cHwbY2xHb1Tia6JyeB31X94toi8SGzLNL5qLgR7Bih2M5pIkIXiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGDFdnYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGDFdnYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A26C4CED1;
	Sat,  7 Dec 2024 00:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530935;
	bh=ICQ9hB0qoNG0a5KhQwj7YWoH4tkhpImpcwEKRGmRG/o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kGDFdnYGqU58kqg2qluwAxxVmqv1zd335WXU539l5aukujzzqgJfpVeZIyEUDHbnz
	 3FptuHB0yPORbL0ny+srMZSliWcNquaR4p4jX6NzvsVTx5XKM+vaKWgx6/1Bn3364H
	 obYZLzhyZuKZ9zhrUnyZhzBfOkBCCQgUxKro0Yj1J3TAmhg7/wKqVKG8aCixgAQLv2
	 fugM3Z2TgSExKk1MeyidO25UmE55KQTqRYWFjo4YhuVGVcGMgkekuGpdgu6xO1r0DT
	 tyIFgg6+0sw0MoUvKJs1gMnGy6A5hTTU2eAt1d5tCRr++6dm3H6qekRGyj5lK1CDds
	 vKZXCfVx7nA+Q==
Date: Fri, 06 Dec 2024 16:22:15 -0800
Subject: [PATCHSET 5/9] xfsprogs: new code for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: leo.lilong@huawei.com, hch@lst.de, brauner@kernel.org,
 dchinner@redhat.com, jlayton@kernel.org, cem@kernel.org,
 josef@toxicpanda.com, rdunlap@infradead.org,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
In-Reply-To: <20241206232259.GO7837@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

New code for 6.12.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.13-merge

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfs-6.13-merge
---
Commits in this patchset:
 * xfs: create incore realtime group structures
 * xfs: define locking primitives for realtime groups
 * xfs: add a lockdep class key for rtgroup inodes
 * xfs: support caching rtgroup metadata inodes
 * xfs: add a xfs_bmap_free_rtblocks helper
 * xfs: move RT bitmap and summary information to the rtgroup
 * xfs: support creating per-RTG files in growfs
 * xfs: refactor xfs_rtbitmap_blockcount
 * xfs: refactor xfs_rtsummary_blockcount
 * xfs: make RT extent numbers relative to the rtgroup
 * libfrog: add memchr_inv
 * xfs: define the format of rt groups
 * xfs: update realtime super every time we update the primary fs super
 * xfs: export realtime group geometry via XFS_FSOP_GEOM
 * xfs: check that rtblock extents do not break rtsupers or rtgroups
 * xfs: add a helper to prevent bmap merges across rtgroup boundaries
 * xfs: add frextents to the lazysbcounters when rtgroups enabled
 * xfs: record rt group metadata errors in the health system
 * xfs: export the geometry of realtime groups to userspace
 * xfs: add block headers to realtime bitmap and summary blocks
 * xfs: encode the rtbitmap in big endian format
 * xfs: encode the rtsummary in big endian format
 * xfs: grow the realtime section when realtime groups are enabled
 * xfs: support logging EFIs for realtime extents
 * xfs: support error injection when freeing rt extents
 * xfs: use realtime EFI to free extents when rtgroups are enabled
 * xfs: don't merge ioends across RTGs
 * xfs: make the RT allocator rtgroup aware
 * xfs: scrub the realtime group superblock
 * xfs: scrub metadir paths for rtgroup metadata
 * xfs: mask off the rtbitmap and summary inodes when metadir in use
 * xfs: create helpers to deal with rounding xfs_fileoff_t to rtx boundaries
 * xfs: create helpers to deal with rounding xfs_filblks_t to rtx boundaries
 * xfs: make xfs_rtblock_t a segmented address like xfs_fsblock_t
 * xfs: adjust min_block usage in xfs_verify_agbno
 * xfs: move the min and max group block numbers to xfs_group
 * xfs: implement busy extent tracking for rtgroups
 * xfs: use metadir for quota inodes
 * xfs: scrub quota file metapaths
 * xfs: enable metadata directory feature
 * xfs: convert struct typedefs in xfs_ondisk.h
 * xfs: separate space btree structures in xfs_ondisk.h
 * xfs: port ondisk structure checks from xfs/122 to the kernel
 * xfs: remove unknown compat feature check in superblock write validation
 * xfs: fix sparse inode limits on runt AG
 * xfs: switch to multigrain timestamps
---
 db/block.c                |    2 
 db/block.h                |   16 -
 db/convert.c              |    1 
 db/faddr.c                |    1 
 include/libxfs.h          |    2 
 include/platform_defs.h   |   33 ++
 include/xfs_mount.h       |   30 +-
 include/xfs_trace.h       |    7 
 include/xfs_trans.h       |    1 
 libfrog/util.c            |   14 +
 libfrog/util.h            |    4 
 libxfs/Makefile           |    2 
 libxfs/init.c             |   35 ++
 libxfs/libxfs_api_defs.h  |   16 +
 libxfs/libxfs_io.h        |    1 
 libxfs/libxfs_priv.h      |   34 --
 libxfs/rdwr.c             |   17 +
 libxfs/trans.c            |   29 ++
 libxfs/util.c             |    8 -
 libxfs/xfs_ag.c           |   22 +
 libxfs/xfs_ag.h           |   16 -
 libxfs/xfs_alloc.c        |   15 +
 libxfs/xfs_alloc.h        |   12 +
 libxfs/xfs_bmap.c         |  130 +++++++-
 libxfs/xfs_defer.c        |    6 
 libxfs/xfs_defer.h        |    1 
 libxfs/xfs_dquot_buf.c    |  190 ++++++++++++
 libxfs/xfs_format.h       |   80 +++++
 libxfs/xfs_fs.h           |   32 ++
 libxfs/xfs_group.h        |   33 ++
 libxfs/xfs_health.h       |   42 ++-
 libxfs/xfs_ialloc.c       |   16 +
 libxfs/xfs_ialloc_btree.c |    2 
 libxfs/xfs_log_format.h   |    6 
 libxfs/xfs_ondisk.h       |  186 +++++++++---
 libxfs/xfs_quota_defs.h   |   43 +++
 libxfs/xfs_rtbitmap.c     |  405 ++++++++++++++++++--------
 libxfs/xfs_rtbitmap.h     |  247 +++++++++++-----
 libxfs/xfs_rtgroup.c      |  694 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h      |  284 ++++++++++++++++++
 libxfs/xfs_sb.c           |  235 ++++++++++++++-
 libxfs/xfs_sb.h           |    6 
 libxfs/xfs_shared.h       |    4 
 libxfs/xfs_trans_inode.c  |    6 
 libxfs/xfs_trans_resv.c   |    2 
 libxfs/xfs_types.c        |   35 ++
 libxfs/xfs_types.h        |    8 -
 mkfs/proto.c              |   33 +-
 mkfs/xfs_mkfs.c           |    8 +
 repair/dinode.c           |    4 
 repair/phase6.c           |  203 +++++++------
 repair/rt.c               |   34 --
 repair/rt.h               |    4 
 53 files changed, 2694 insertions(+), 603 deletions(-)
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h

