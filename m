Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46261991AB
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416028; cv=none; b=c8qdgnDIaxRJRDDlcoG62ZXIyjg+Z34ZD2aaK+vhht/UwrIzaU2zX72cm8jMdsjFFi/Zo7YMHVLC8540WuP4HLsiVj5Q6f5LefCA439DSavdyB2QOiUs38LTciUGLc4dazlwkxAh99FUqTShu9jaPEuLIsIH5ISRwxaRUuP2K6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416028; c=relaxed/simple;
	bh=KA+M1Eqack4gyet4bMIq2qfTT6t3+CH6xVyK9nkBPyY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CUiT6C5WzoLck3I6SEz4PvxpznkCz26nN1Hw5obgO6NdgtZOSeWgIVWu8tX8SYJ61H6+5Z2vdTAyFUbvjTtLJDVZI0P+gJ1RsNS1OvHQcc5cbWhnXIaxXuI1grC8mlQUjQYsvgyL+MgZyrOS0Y3sSWtYTA0VIWGAEiCY4d1/zeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uf82/pmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uf82/pmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61075C4CEC3;
	Thu, 31 Oct 2024 23:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416028;
	bh=KA+M1Eqack4gyet4bMIq2qfTT6t3+CH6xVyK9nkBPyY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uf82/pmVMd/hk6sQlhk6O3sKsElVLPwQENnFAGsWb6bGTBapZ00kxUWBVAq3jnbpd
	 wLTW7ZMX8y2nfLmFy43rLhlTruuhBMdWo/b6wJQcNVzsjc5QlAV9ZPLiNuHZpOXca3
	 31V2FKrm32n0P4eziLlGIL+XaaFs5WY0hmgTUHPPa61eIXlJ/XYiEC5FU/xuwsvIjM
	 3Xh4PmNGS0eNClU0qrY6hmYyK4/wzthCneE7CzLw9IOokXLXXK6IWLgkDkXFqXYr0R
	 04Z3yiot8aUDFdZlWjrQv5rnM1zW1Nbe2XEOGeY0JoZgK7tXJxQR1rnslJExVAs4VT
	 EwLob13rM7eQw==
Date: Thu, 31 Oct 2024 16:07:07 -0700
Subject: [PATCHSET 1/7] libxfs: new code for 6.12
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
In-Reply-To: <20241031225721.GC2386201@frogsfrogsfrogs>
References: <20241031225721.GC2386201@frogsfrogsfrogs>
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
 * libxfs: test compiling public headers with a C++ compiler
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
 * xfs: pass the exact range to initialize to xfs_initialize_perag
 * xfs: merge the perag freeing helpers
 * xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
 * xfs: update the pag for the last AG at recovery time
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
 libxfs/init.c               |   17 ++-
 libxfs/ioctl_c_dummy.c      |   11 ++
 libxfs/ioctl_cxx_dummy.cpp  |   13 ++
 libxfs/libxfs_api_defs.h    |    2 
 libxfs/libxfs_priv.h        |    6 +
 libxfs/xfs_ag.c             |  165 +++++---------------------
 libxfs/xfs_ag.h             |   25 +---
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
 62 files changed, 1062 insertions(+), 849 deletions(-)
 create mode 100644 libxfs/ioctl_c_dummy.c
 create mode 100644 libxfs/ioctl_cxx_dummy.cpp

