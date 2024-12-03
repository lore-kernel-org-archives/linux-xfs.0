Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C04A1E0E11
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 10:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733220652; cv=none; b=lSrjhvKAXtytPAn/X5NZ4P2lJ7+no8P59n6gQc+eagVYIegFh7g5MlKN5sB9mJr5KX0hCxodYXUn4cNVPYqg+aBVJXDIdw32IjbgWQhMA4pIUlvNxjel2YgrMur+Qf51skOzjBAtmfY5quRAgHuJctucy1gOfAA1LJAwbv+EIDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733220652; c=relaxed/simple;
	bh=Z10HBcQZcb6EwJR88syJgvNtKhU1N269j864u8KytJs=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QA4ZQYfv0sQyYBAOxfTEtbuSpx++u+Bf8DwZQJsn3oSYmbJSlGIyNHLFYn14HbYmScTxcsTvr5Mn/n3gmD3V3sY5H29eEj7v0tS8ejqK65wlS8anlr9Fb2gNagLCKFUsA32HR2E+cVe1wl5K6dukYc0wlmpQUyrfzrOItbCMvWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l4fds9KA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l4fds9KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A06C4CED6
	for <linux-xfs@vger.kernel.org>; Tue,  3 Dec 2024 10:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733220651;
	bh=Z10HBcQZcb6EwJR88syJgvNtKhU1N269j864u8KytJs=;
	h=Date:From:To:Subject:From;
	b=l4fds9KAPfvv7OcJ4FkH2e5Fklqr9f3vJWTZEbJoxICjSaPOogRKJTix1WmfNY2FI
	 FMxjRMMFn5WNG7WWbS/xlOuLuoe/2s37ub7XqFqNczopWpfcNrdO1ftfixbrb+v4qM
	 pm5Azsl13wZOTEsJL39ovu+yRyk94Gfm4CZozbsqwlW4Zz5lcDm94+u7WWB75obcQN
	 my0VRbK6+Vso9xC6xeoCLT8CNCHFncCDCvue1I46IZ2nlsF+jMY4PM4SG6bYA/AnVc
	 PtwlxslV5WdSeOL7MU0kqb2q0DwHkpc81D26INQXWho9SU5V3qmVB82QXsk8v88n0O
	 nRTOGCdiWKU1g==
Date: Tue, 3 Dec 2024 11:10:48 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs v6.12.0 released
Message-ID: <vjjbmzy7uhdxhfejfctdjb4wf5o42wy7qpnbsjucixxwgreb4v@j5ey2vj2fo4o>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the master branch is commit:

90d6da68ee54e6d4ef99eca4a82cac6036a34b00

New commits:

Andrey Albershteyn (1):
      [90d6da68ee54] xfsprogs: Release v6.12.0

Catherine Hoang (1):
      [409477af604f] xfs_io: add support for atomic write statx fields

Chi Zhiling (1):
      [0cc807347d5a] xfs: Reduce unnecessary searches when searching for the best extents

Christoph Hellwig (35):
      [5bed9480fecd] libfrog: add xarray emulation
      [7220f58bed91] xfs: remove xfs_validate_rtextents
      [b03d9058b030] xfs: factor out a xfs_validate_rt_geometry helper
      [a9af23f75abb] xfs: remove the limit argument to xfs_rtfind_back
      [39c5ade94400] xfs: assert a valid limit in xfs_rtfind_forw
      [915ebe7528ce] xfs: add bounds checking to xfs_rt{bitmap,summary}_read_buf
      [f666752a6278] xfs: factor out rtbitmap/summary initialization helpers
      [cd0b8448a812] xfs: push transaction join out of xfs_rtbitmap_lock and xfs_rtgroup_lock
      [d9e765646569] xfs: ensure rtx mask/shift are correct after growfs
      [325a7bbff1cf] xfs: remove xfs_rtb_to_rtxrem
      [f7d5200c609e] xfs: simplify xfs_rtalloc_query_range
      [4fb1557f4a23] xfs: clean up the ISVALID macro in xfs_bmap_adjacent
      [609cb7865f9a] xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
      [84704ebf61a2] xfs: replace m_rsumsize with m_rsumblocks
      [596253fb3acb] xfs: use kfree_rcu_mightsleep to free the perag structures
      [14a383c4a680] xfs: move the tagged perag lookup helpers to xfs_icache.c
      [db0d88e9aab8] xfs: convert perag lookup to xarray
      [a8c3578c55cf] xfs: ensure st_blocks never goes to zero during COW writes
      [e63467a29e49] xfs: merge xfs_attr_leaf_try_add into xfs_attr_leaf_addname
      [3b59e7d1cd1f] xfs: return bool from xfs_attr3_leaf_add
      [2089fbfedcde] xfs: distinguish extra split from real ENOSPC from xfs_attr3_leaf_split
      [1f246811849b] xfs: distinguish extra split from real ENOSPC from xfs_attr_node_try_addname
      [a7c063b27cfe] xfs: fold xfs_bmap_alloc_userdata into xfs_bmapi_allocate
      [628f9141bd6c] xfs: don't ifdef around the exact minlen allocations
      [31f5b24c3e42] xfs: call xfs_bmap_exact_minlen_extent_alloc from xfs_bmap_btalloc
      [43f4e9bef3f5] xfs: support lowmode allocations in xfs_bmap_exact_minlen_extent_alloc
      [aadfcab59975] xfs: pass the exact range to initialize to xfs_initialize_perag
      [d64d607e19f4] xfs: merge the perag freeing helpers
      [4b7c32f74e83] xfs: don't use __GFP_RETRY_MAYFAIL in xfs_initialize_perag
      [6611215e3d44] xfs: update the pag for the last AG at recovery time
      [a65f5eefa631] xfs_repair: use xfs_validate_rt_geometry
      [47e42101759e] mkfs: remove a pointless rtfreesp_init forward declaration
      [7bb9a55fea7b] mkfs: use xfs_rtfile_initialize_blocks
      [49ef9d5070dd] xfs_repair: use libxfs_rtfile_initialize_blocks
      [07c09d46665c] xfs_repair: stop preallocating blocks in mk_rbmino and mk_rsumino

Dan Carpenter (1):
      [0e955beedcb8] xfs: remove unnecessary check

Darrick J. Wong (29):
      [fb4e1bc02044] libxfs: require -std=gnu11 for compilation by default
      [6e1d3517d108] libxfs: test compiling public headers with a C++ compiler
      [3a7e14f936c8] libxfs: port IS_ENABLED from the kernel
      [ec322218899e] xfs: introduce new file range commit ioctls
      [bca9de398b66] xfs: pass the icreate args object to xfs_dialloc
      [9bd5f52de658] xfs: fix a sloppy memory handling bug in xfs_iroot_realloc
      [2f8e9b0aa899] xfs: replace shouty XFS_BM{BT,DR} macros
      [07037e853426] xfs: standardize the btree maxrecs function parameters
      [bc37fe78843f] man: document file range commit ioctls
      [943d67216327] libfrog: add support for commit range ioctl family
      [ee97b29a4413] libxfs: remove unused xfs_inode fields
      [4612e4ad75ce] libxfs: validate inumber in xfs_iget
      [ea1626b8a8d6] xfs_fsr: port to new file exchange library function
      [e21a6c0c5aad] xfs_io: add a commitrange option to the exchangerange command
      [1cf7afbc0c8b] xfs_io: add atomic file update commands to exercise file commit range
      [e84718ec0a40] xfs_db: support passing the realtime device to the debugger
      [49844913d4d8] xfs_db: report the realtime device when associated with each io cursor
      [52b857269481] xfs_db: make the daddr command target the realtime device
      [b05a31722f5d] xfs_db: access realtime file blocks
      [3b04ddaed83d] xfs_db: access arbitrary realtime blocks and extents
      [08ff89704463] xfs_db: enable conversion of rt space units
      [9c4441af72e7] xfs_db: convert rtbitmap geometry
      [5f10590bae67] xfs_db: convert rtsummary geometry
      [5e8139658b79] xfs_db: allow setting current address to log blocks
      [9e63cdfd416a] xfs_repair: checking rt free space metadata must happen during phase 4
      [024f91c02f22] xfs_scrub_all: wait for services to start activating
      [d19c5581b03e] mkfs: add a config file for 6.12 LTS kernels
      [2c054ce65a40] xfs_repair: fix crasher in pf_queuing_worker
      [09f319213924] xfs_repair: synthesize incore inode tree records when required

Dave Chinner (1):
      [541ba966b2ee] xfs: use kvmalloc for xattr buffers

Jan Palus (1):
      [67297671cbae] xfs_spaceman: add dependency on libhandle target

Pankaj Raghav (1):
      [8a04405248ab] xfs: enable block size larger than page size support

Code Diffstat:

 Makefile                          |   2 +-
 VERSION                           |   2 +-
 configure.ac                      |  16 +-
 db/block.c                        | 272 ++++++++++++++++++++++-
 db/block.h                        |  20 ++
 db/bmap.c                         |  10 +-
 db/bmap_inflate.c                 |   2 +-
 db/bmroot.c                       |   8 +-
 db/btheight.c                     |  18 +-
 db/check.c                        |  11 +-
 db/convert.c                      | 438 ++++++++++++++++++++++++++++++++++++--
 db/faddr.c                        |   5 +-
 db/frag.c                         |   8 +-
 db/init.c                         |   7 +-
 db/io.c                           |  39 +++-
 db/io.h                           |   3 +
 db/iunlink.c                      |   2 +-
 db/metadump.c                     |  16 +-
 db/xfs_admin.sh                   |   4 +-
 debian/changelog                  |   6 +
 doc/CHANGES                       |  21 ++
 fsr/xfs_fsr.c                     |  74 +++----
 include/builddefs.in              |  12 ++
 include/kmem.h                    |  11 +
 include/libxfs.h                  |   6 +-
 include/platform_defs.h           |  63 ++++++
 include/xfs_inode.h               |   4 -
 include/xfs_mount.h               |   4 +-
 io/exchrange.c                    | 390 ++++++++++++++++++++++++++++++++-
 io/io.h                           |   4 +
 io/open.c                         |  27 ++-
 io/stat.c                         |   7 +
 io/statx.h                        |  23 +-
 libfrog/file_exchange.c           | 194 +++++++++++++++++
 libfrog/file_exchange.h           |  10 +
 libfrog/radix-tree.h              |  35 +++
 libxfs/Makefile                   |  31 ++-
 libxfs/defer_item.c               |  14 ++
 libxfs/init.c                     |  17 +-
 libxfs/inode.c                    |   2 +-
 libxfs/ioctl_c_dummy.c            |  11 +
 libxfs/ioctl_cxx_dummy.cpp        |  13 ++
 libxfs/libxfs_api_defs.h          |   4 +-
 libxfs/libxfs_priv.h              |   6 +-
 libxfs/xfs_ag.c                   | 165 +++-----------
 libxfs/xfs_ag.h                   |  25 +--
 libxfs/xfs_alloc.c                |   9 +-
 libxfs/xfs_alloc.h                |   4 +-
 libxfs/xfs_alloc_btree.c          |   6 +-
 libxfs/xfs_alloc_btree.h          |   3 +-
 libxfs/xfs_attr.c                 | 190 +++++++----------
 libxfs/xfs_attr_leaf.c            |  63 +++---
 libxfs/xfs_attr_leaf.h            |   2 +-
 libxfs/xfs_bmap.c                 | 243 +++++++++------------
 libxfs/xfs_bmap_btree.c           |  24 +--
 libxfs/xfs_bmap_btree.h           | 207 ++++++++++++------
 libxfs/xfs_da_btree.c             |   5 +-
 libxfs/xfs_fs.h                   |  26 +++
 libxfs/xfs_ialloc.c               |  14 +-
 libxfs/xfs_ialloc.h               |   4 +-
 libxfs/xfs_ialloc_btree.c         |   6 +-
 libxfs/xfs_ialloc_btree.h         |   3 +-
 libxfs/xfs_inode_fork.c           |  40 ++--
 libxfs/xfs_inode_util.c           |   2 +-
 libxfs/xfs_refcount_btree.c       |   5 +-
 libxfs/xfs_refcount_btree.h       |   3 +-
 libxfs/xfs_rmap_btree.c           |   7 +-
 libxfs/xfs_rmap_btree.h           |   3 +-
 libxfs/xfs_rtbitmap.c             | 274 +++++++++++++++++-------
 libxfs/xfs_rtbitmap.h             |  61 +-----
 libxfs/xfs_sb.c                   |  92 ++++----
 libxfs/xfs_sb.h                   |   3 +
 libxfs/xfs_shared.h               |   3 +
 libxfs/xfs_trans_resv.c           |   4 +-
 libxfs/xfs_types.h                |  12 --
 m4/package_libcdev.m4             |  20 ++
 m4/package_utilies.m4             |   5 +
 man/man2/ioctl_xfs_commit_range.2 | 296 ++++++++++++++++++++++++++
 man/man2/ioctl_xfs_fsgeometry.2   |   2 +-
 man/man2/ioctl_xfs_start_commit.2 |   1 +
 man/man8/xfs_db.8                 | 148 ++++++++++++-
 man/man8/xfs_io.8                 |  35 ++-
 mkfs/Makefile                     |   3 +-
 mkfs/lts_6.12.conf                |  19 ++
 mkfs/proto.c                      | 116 ++--------
 repair/bmap_repair.c              |   2 +-
 repair/dino_chunks.c              |  28 +++
 repair/dinode.c                   |  17 +-
 repair/phase4.c                   |   7 +
 repair/phase5.c                   |  22 +-
 repair/phase6.c                   | 292 +++++--------------------
 repair/prefetch.c                 |  10 +-
 repair/rt.c                       |   7 +-
 repair/sb.c                       |  40 +---
 repair/scan.c                     |   6 +-
 repair/xfs_repair.c               |   3 -
 scrub/xfs_scrub_all.in            |  52 +++++
 97 files changed, 3193 insertions(+), 1318 deletions(-)
 create mode 100644 libxfs/ioctl_c_dummy.c
 create mode 100644 libxfs/ioctl_cxx_dummy.cpp
 create mode 100644 man/man2/ioctl_xfs_commit_range.2
 create mode 100644 man/man2/ioctl_xfs_start_commit.2
 create mode 100644 mkfs/lts_6.12.conf
