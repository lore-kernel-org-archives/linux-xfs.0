Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAE619AA43
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731326848; cv=none; b=M9rKf60DYTpNkPRgvGRpCkIk+wid0DfCYu/Hh7IVHsnTFXGi4EiU9rbpAfi85BNSfHAufh7iC7q/ctez0sovsIB6otKHnXim5aloEuNu5FW8anRZi5WRYJzhqTvxzoAIqtDpf7c3+Zmk2IBm1tmASQwUoVfcRKWdaX4sejhiO3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731326848; c=relaxed/simple;
	bh=kvafrbG/npIDGZqvin6cSxIvmmnp4dLLyswMa6fn6vg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uaRgyz4BcdrMitADtWoFRnWcmN7fLFztgAkVXU/4UWUTjNpulv2cBWgXKFc+cteJ3VZSQstrsjD6pX8aAg8nFKGFeXthZLmn/YlkBbMUKbGAFLYg++7QEEKR8Dlp2341k0xWao13wIJYtrKtTv/dq52NxUcCtX0dRwZjCU68YMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qmpoMVoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qmpoMVoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AEBC4CED5
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731326845;
	bh=kvafrbG/npIDGZqvin6cSxIvmmnp4dLLyswMa6fn6vg=;
	h=Date:From:To:Subject:From;
	b=qmpoMVoLTvdVIgoJ9/uXTCFaFiGtG4AwRXMePIklu000r5J8TbM2rhQq1EY2DdLOg
	 AP6IxWh9V2XJXTpz0o9aJ8/ag8rp1RURZkVa4GwGWXFRVKn2P2xKN9Zj/FPt4o6YO4
	 kLz7wH1AltIaXJMNrvSA9fP3izeYvz2csOtTLwTROzMZ3i64xyl/GS0rT3TmSLBeHV
	 g8rRr8t1JLShw82B2N5MKXJ7u3Po3uQqSLQB4oMRLkBDS69w51p2aq3K07m8wRS157
	 xndblfe+MCAqPQ8REHEFxdtIIpUdz9o5LeS7DVv96DSAU53quOw7jRkZIkhvRJuaTA
	 sZMSeKAxq7KFQ==
Date: Mon, 11 Nov 2024 13:07:19 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 67297671cbae
Message-ID: <a4q7ceul2urww4bfn7uxy5orbsllor27ov5ix7fzbthbr3nvf6@xx67livha6kt>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

67297671cbae3043e495312964470d31f4b9e5e7

66 new commits:

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

Darrick J. Wong (27):
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

Dave Chinner (1):
      [541ba966b2ee] xfs: use kvmalloc for xattr buffers

Jan Palus (1):
      [67297671cbae] xfs_spaceman: add dependency on libhandle target

Pankaj Raghav (1):
      [8a04405248ab] xfs: enable block size larger than page size support

Code Diffstat:

 Makefile                          |   2 +-
 configure.ac                      |  13 +-
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
 fsr/xfs_fsr.c                     |  74 +++----
 include/builddefs.in              |   8 +
 include/kmem.h                    |  11 +
 include/libxfs.h                  |   6 +-
 include/platform_defs.h           |  63 ++++++
 include/xfs_inode.h               |   4 -
 include/xfs_mount.h               |   4 +-
 io/exchrange.c                    | 390 ++++++++++++++++++++++++++++++++-
 io/io.h                           |   4 +
 io/open.c                         |  27 ++-
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
 libxfs/xfs_alloc.c                |   7 +-
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
 repair/dinode.c                   |  17 +-
 repair/phase4.c                   |   7 +
 repair/phase5.c                   |  22 +-
 repair/phase6.c                   | 292 +++++--------------------
 repair/prefetch.c                 |   8 +-
 repair/rt.c                       |   7 +-
 repair/sb.c                       |  40 +---
 repair/scan.c                     |   6 +-
 repair/xfs_repair.c               |   3 -
 scrub/xfs_scrub_all.in            |  52 +++++
 90 files changed, 3079 insertions(+), 1314 deletions(-)
 create mode 100644 libxfs/ioctl_c_dummy.c
 create mode 100644 libxfs/ioctl_cxx_dummy.cpp
 create mode 100644 man/man2/ioctl_xfs_commit_range.2
 create mode 100644 man/man2/ioctl_xfs_start_commit.2
 create mode 100644 mkfs/lts_6.12.conf
