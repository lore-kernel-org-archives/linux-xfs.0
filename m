Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BB71946BC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730418162; cv=none; b=nu6h4YukDsLguqEm78NHGcaUtNVnGLt3EuziBMyCPNIEEjZyrHcUlsPyXYtSFRB/xjixBBaqREr5eTsk6MpOFqjx6/SxMW94jjoekJyEujdTEP+izspkwnM2bFHqtt54gwKDLjCC0NcgzjQdMCBN/qO6CV7iaRSqw5AEh3v5NyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730418162; c=relaxed/simple;
	bh=59fKSUELu8tgj9fIqu+UnQd+1zyYMz1deGOLmyiXCq0=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=im0CzUuGC6TQfI3oYPCnimumhC7P5ZA6H/qdfDtOnC73q380anjPpesLOg6sk+OKvzbpeXWEQZqYv/a1IrkDaWyjZFr39Q9oOpH4ZM6HJLvH1uwuf6Ob0APetfZxaFyvDsVq8Zo9Zl9zOevXEVwF5UJTTjGT9rztnfayUzdCihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Orm5BPP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Orm5BPP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D264C4CEC3;
	Thu, 31 Oct 2024 23:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730418160;
	bh=59fKSUELu8tgj9fIqu+UnQd+1zyYMz1deGOLmyiXCq0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Orm5BPP8zdCiLvl1mAwA8H4kuOcOBL6o2azF6yZbnXCZuz2hNez6qjnlrhTu7yIFb
	 sUOwclt9vtGl/ojXe3LNv0fTLO9vHYc8uaM4yK8rV6F7AQbqTZp43R/OIjgyQnOFwx
	 uZuoLONZU/m21In3clQv7PqtMrXlymOeDFshtlzJoYtNfsg/4ASRaHXaJs9yBw2yC1
	 KMKdhBos3Di1BiQI0hy+HfTy9qUPIByckmUpl3zFTrZN06wn2C+dqjsPEspR9KMfKz
	 fmT0hkrYm78wOmRPfEmpiCLwmzvQCxUw5gS1TZ7MAE5q7AW7mJAmRB+yF5hG4WSVPh
	 Udeeo1ghEzmdQ==
Date: Thu, 31 Oct 2024 16:42:40 -0700
Subject: [GIT PULL 1/7] libxfs: new code for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: bfoster@redhat.com, brauner@kernel.org, cem@kernel.org, chandanbabu@kernel.org, da.gomez@samsung.com, dan.carpenter@linaro.org, dchinner@redhat.com, hare@suse.de, hch@lst.de, jlayton@kernel.org, kch@nvidia.com, kernel@pankajraghav.com, linux-xfs@vger.kernel.org, mcgrof@kernel.org, p.raghav@samsung.com, sam@gentoo.org, willy@infradead.org
Message-ID: <173041764416.994242.1631031230343563017.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241031233336.GD2386201@frogsfrogsfrogs>
References: <20241031233336.GD2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Andrey,

Please pull this branch with changes for xfsprogs for 6.11-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 42523142959ddebd127a87e98879f9110da0cc7d:

xfsprogs: update gitignore (2024-10-08 14:31:31 +0200)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/libxfs-sync-6.12_2024-10-31

for you to fetch changes up to 6611215e3d441a5e6d9d6a2f85c5ea1bf573a8d0:

xfs: update the pag for the last AG at recovery time (2024-10-31 15:45:04 -0700)

----------------------------------------------------------------
libxfs: new code for 6.12 [1/7]

New code for 6.12.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (1):
xfsprogs: Release v6.11.0

Christoph Hellwig (30):
libfrog: add xarray emulation
xfs: remove xfs_validate_rtextents
xfs: factor out a xfs_validate_rt_geometry helper
xfs: remove the limit argument to xfs_rtfind_back
xfs: assert a valid limit in xfs_rtfind_forw
xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
xfs: factor out rtbitmap/summary initialization helpers
xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock
xfs: ensure rtx mask/shift are correct after growfs
xfs: remove xfs_rtb_to_rtxrem
xfs: simplify xfs_rtalloc_query_range
xfs: clean up the ISVALID macro in xfs_bmap_adjacent
xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
xfs: replace m_rsumsize with m_rsumblocks
xfs: use kfree_rcu_mightsleep to free the perag structures
xfs: move the tagged perag lookup helpers to xfs_icache.c
xfs: convert perag lookup to xarray
xfs: ensure st_blocks never goes to zero during COW writes
xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
xfs: return bool from xfs_attr3_leaf_add
xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
xfs: don't ifdef around the exact minlen allocations
xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
xfs: pass the exact range to initialize to xfs_initialize_perag
xfs: merge the perag freeing helpers
xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
xfs: update the pag for the last AG at recovery time

Dan Carpenter (1):
xfs: remove unnecessary check

Darrick J. Wong (8):
libxfs: require -std=gnu11 for compilation by default
libxfs: test compiling public headers with a C++ compiler
libxfs: port IS_ENABLED from the kernel
xfs: introduce new file range commit ioctls
xfs: pass the icreate args object to xfs_dialloc
xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
xfs: replace shouty XFS_BM{BT,DR} macros
xfs: standardize the btree maxrecs function parameters

Dave Chinner (1):
xfs: use kvmalloc for xattr buffers

Pankaj Raghav (1):
xfs: enable block size larger than page size support

VERSION                     |   4 +-
configure.ac                |  15 ++-
db/bmap.c                   |  10 +-
db/bmap_inflate.c           |   2 +-
db/bmroot.c                 |   8 +-
db/btheight.c               |  18 +--
db/check.c                  |  11 +-
db/frag.c                   |   8 +-
db/iunlink.c                |   2 +-
db/metadump.c               |  16 +--
debian/changelog            |   6 +
doc/CHANGES                 |   5 +
include/builddefs.in        |   8 ++
include/kmem.h              |  11 ++
include/libxfs.h            |   6 +-
include/platform_defs.h     |  63 ++++++++++
include/xfs_mount.h         |   4 +-
libfrog/radix-tree.h        |  35 ++++++
libxfs/Makefile             |  31 ++++-
libxfs/defer_item.c         |  14 +++
libxfs/init.c               |  17 +--
libxfs/ioctl_c_dummy.c      |  11 ++
libxfs/ioctl_cxx_dummy.cpp  |  13 +++
libxfs/libxfs_api_defs.h    |   2 +-
libxfs/libxfs_priv.h        |   6 +-
libxfs/xfs_ag.c             | 165 ++++++--------------------
libxfs/xfs_ag.h             |  25 +---
libxfs/xfs_alloc.c          |   7 +-
libxfs/xfs_alloc.h          |   4 +-
libxfs/xfs_alloc_btree.c    |   6 +-
libxfs/xfs_alloc_btree.h    |   3 +-
libxfs/xfs_attr.c           | 190 +++++++++++++-----------------
libxfs/xfs_attr_leaf.c      |  63 +++++-----
libxfs/xfs_attr_leaf.h      |   2 +-
libxfs/xfs_bmap.c           | 243 ++++++++++++++++-----------------------
libxfs/xfs_bmap_btree.c     |  24 ++--
libxfs/xfs_bmap_btree.h     | 207 ++++++++++++++++++++++-----------
libxfs/xfs_da_btree.c       |   5 +-
libxfs/xfs_fs.h             |  26 +++++
libxfs/xfs_ialloc.c         |  14 ++-
libxfs/xfs_ialloc.h         |   4 +-
libxfs/xfs_ialloc_btree.c   |   6 +-
libxfs/xfs_ialloc_btree.h   |   3 +-
libxfs/xfs_inode_fork.c     |  40 +++----
libxfs/xfs_inode_util.c     |   2 +-
libxfs/xfs_refcount_btree.c |   5 +-
libxfs/xfs_refcount_btree.h |   3 +-
libxfs/xfs_rmap_btree.c     |   7 +-
libxfs/xfs_rmap_btree.h     |   3 +-
libxfs/xfs_rtbitmap.c       | 274 +++++++++++++++++++++++++++++++-------------
libxfs/xfs_rtbitmap.h       |  61 ++--------
libxfs/xfs_sb.c             |  92 ++++++++-------
libxfs/xfs_sb.h             |   3 +
libxfs/xfs_shared.h         |   3 +
libxfs/xfs_trans_resv.c     |   4 +-
libxfs/xfs_types.h          |  12 --
m4/package_utilies.m4       |   5 +
mkfs/proto.c                |  17 ++-
repair/bmap_repair.c        |   2 +-
repair/dinode.c             |  17 +--
repair/phase5.c             |  16 +--
repair/phase6.c             |  18 ++-
repair/prefetch.c           |   8 +-
repair/rt.c                 |   7 +-
repair/scan.c               |   6 +-
65 files changed, 1076 insertions(+), 852 deletions(-)
create mode 100644 libxfs/ioctl_c_dummy.c
create mode 100644 libxfs/ioctl_cxx_dummy.cpp

