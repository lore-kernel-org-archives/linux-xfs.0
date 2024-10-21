Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9661D0F76
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729547936; cv=none; b=gAgDTgZVuYoM+QBfgq5hBOUjZbuTO1IA+xDZwWfy/61Q0UZGFwkhewO/RzEOLlcM29Y+C3Q4rU+FmSZyI34KMm+Ls8QUOd7A5+AidRNOs2r1ixboZPnP/ujgXyBELq+TaEiRvfz69Yxr9NQXI5jl6YvRR73EaZe5Wvbk/3LjaYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729547936; c=relaxed/simple;
	bh=P47SkSMnqssSuCyMUwFlRhUiH/xe0u4SSEpVrcJ6kic=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G7hbsRic97iCYn8jPcOa8WREkMzxV99lAwlEqSWpgoSKEXTafqrCwhLfdXHUU+Nl9gf9l3zNvNFJ4qIH81t22HbdVXuruEy2CFWcFvK+kDaeRXbKUQrd/NVXNn8BZbdnTLZaTSivS7wFV7LYf7IDtFQMb96j4jm/8Fm8YA/PCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fW0Fw3GK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fW0Fw3GK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4120AC4CEE4;
	Mon, 21 Oct 2024 21:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729547936;
	bh=P47SkSMnqssSuCyMUwFlRhUiH/xe0u4SSEpVrcJ6kic=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fW0Fw3GKq2MCbhPssLngXGDfukIqYX7JV9gQdavViMxgIvGAOX4YDRVkfZqbBSVPu
	 +2GA0C/TM46+FGUInSL+0bepun36LX8Vtr41NJM27Ssyad+MvB6Vf6doRgNltfLvde
	 djGUMV/z5m4uUOZO98YDPDuO8vEWnaVPETBeeZIgy/XoeeqN/GcjWhqC71J2UpuVkC
	 46P9qdzmES0+//fBkeO7c/Xb7H9/5mklXwZnKV2+JCcjivNzq0RDp0QXvL7IkVMDM7
	 Urh529npUNopjc0CEFqpfwkhStEIzN1vdynZrzgR74/XLzMRaWG3+KUBowhAZkpIyT
	 Quf9scBWpQMFQ==
Date: Mon, 21 Oct 2024 14:58:55 -0700
Subject: [PATCHSET] libxfs: new code for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
In-Reply-To: <20241021215627.GC21853@frogsfrogsfrogs>
References: <20241021215627.GC21853@frogsfrogsfrogs>
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

Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.12
---
Commits in this patchset:
 * libxfs: require -std=gnu11 for compilation by default
 * libxfs: compile with a C++ compiler
 * libxfs: port IS_ENABLED from the kernel
 * libfrog: add xarray emulation
 * xfs: introduce new file range commit ioctls
 * xfs: pass the icreate args object to xfs_dialloc
 * xfs: remove xfs_validate_rtextents
 * xfs: factor out a xfs_validate_rt_geometry helper
 * xfs: remove the limit argument to xfs_rtfind_back
 * xfs: assert a valid limit in xfs_rtfind_forw
 * xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
 * xfs: factor out rtbitmap/summary initialization helpers
 * xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock
 * xfs: ensure rtx mask/shift are correct after growfs
 * xfs: remove xfs_rtb_to_rtxrem
 * xfs: simplify xfs_rtalloc_query_range
 * xfs: clean up the ISVALID macro in xfs_bmap_adjacent
 * xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
 * xfs: replace m_rsumsize with m_rsumblocks
 * xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
 * xfs: replace shouty XFS_BM{BT,DR} macros
 * xfs: standardize the btree maxrecs function parameters
 * xfs: use kvmalloc for xattr buffers
 * xfs: remove unnecessary check
 * xfs: use kfree_rcu_mightsleep to free the perag structures
 * xfs: move the tagged perag lookup helpers to xfs_icache.c
 * xfs: convert perag lookup to xarray
 * xfs: ensure st_blocks never goes to zero during COW writes
 * xfs: enable block size larger than page size support
 * xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
 * xfs: return bool from xfs_attr3_leaf_add
 * xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
 * xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
 * xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
 * xfs: don't ifdef around the exact minlen allocations
 * xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
 * xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
---
 configure.ac                |   13 ++
 db/bmap.c                   |   10 +-
 db/bmap_inflate.c           |    2 
 db/bmroot.c                 |    8 +
 db/btheight.c               |   18 +--
 db/check.c                  |   11 +-
 db/frag.c                   |    8 +
 db/iunlink.c                |    2 
 db/metadump.c               |   16 +--
 include/builddefs.in        |    8 +
 include/kmem.h              |   11 ++
 include/libxfs.h            |    6 +
 include/platform_defs.h     |   63 ++++++++++
 include/xfs_mount.h         |    4 -
 libfrog/radix-tree.h        |   35 +++++
 libxfs/Makefile             |   31 +++++
 libxfs/defer_item.c         |   14 ++
 libxfs/init.c               |   11 +-
 libxfs/ioctl_c_dummy.c      |   11 ++
 libxfs/ioctl_cxx_dummy.cpp  |   13 ++
 libxfs/libxfs_priv.h        |    6 +
 libxfs/xfs_ag.c             |   94 +--------------
 libxfs/xfs_ag.h             |   14 --
 libxfs/xfs_alloc.c          |    7 -
 libxfs/xfs_alloc.h          |    4 -
 libxfs/xfs_alloc_btree.c    |    6 -
 libxfs/xfs_alloc_btree.h    |    3 
 libxfs/xfs_attr.c           |  190 +++++++++++++-----------------
 libxfs/xfs_attr_leaf.c      |   63 +++++-----
 libxfs/xfs_attr_leaf.h      |    2 
 libxfs/xfs_bmap.c           |  243 ++++++++++++++++----------------------
 libxfs/xfs_bmap_btree.c     |   24 ++--
 libxfs/xfs_bmap_btree.h     |  207 ++++++++++++++++++++++----------
 libxfs/xfs_da_btree.c       |    5 -
 libxfs/xfs_fs.h             |   26 ++++
 libxfs/xfs_ialloc.c         |   14 ++
 libxfs/xfs_ialloc.h         |    4 -
 libxfs/xfs_ialloc_btree.c   |    6 -
 libxfs/xfs_ialloc_btree.h   |    3 
 libxfs/xfs_inode_fork.c     |   40 +++---
 libxfs/xfs_inode_util.c     |    2 
 libxfs/xfs_refcount_btree.c |    5 -
 libxfs/xfs_refcount_btree.h |    3 
 libxfs/xfs_rmap_btree.c     |    7 +
 libxfs/xfs_rmap_btree.h     |    3 
 libxfs/xfs_rtbitmap.c       |  274 +++++++++++++++++++++++++++++++------------
 libxfs/xfs_rtbitmap.h       |   61 ++--------
 libxfs/xfs_sb.c             |   92 ++++++++------
 libxfs/xfs_sb.h             |    3 
 libxfs/xfs_shared.h         |    3 
 libxfs/xfs_trans_resv.c     |    4 -
 libxfs/xfs_types.h          |   12 --
 m4/package_utilies.m4       |    5 +
 mkfs/proto.c                |   17 +--
 repair/bmap_repair.c        |    2 
 repair/dinode.c             |   17 +--
 repair/phase5.c             |   16 +--
 repair/phase6.c             |   18 +--
 repair/prefetch.c           |    8 +
 repair/rt.c                 |    7 -
 repair/scan.c               |    6 -
 61 files changed, 1026 insertions(+), 795 deletions(-)
 create mode 100644 libxfs/ioctl_c_dummy.c
 create mode 100644 libxfs/ioctl_cxx_dummy.cpp

