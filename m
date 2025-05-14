Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4790E46B8
	for <linux-xfs@vger.kernel.org>; Wed, 14 May 2025 17:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747243823; cv=none; b=iF4Do/KYn4try7+gjeaJzM04L9rgAiy5FwHst5l71JNlmMnUiCghhT7AtCzCo/QzOuktfPfTXK3zxqlFWqIe3lMUhcoQ57QUDheIVTqFt7X3IdsGO5eFes5I2kgEfpJLeESf5E4662P5425Yvqg8GHxSCxYebqJWIIr6kEoqCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747243823; c=relaxed/simple;
	bh=EuyLeEbest4ehJaN8kn3WTxK/xbofKQTBHJZVQjDdKY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CvuRVgCNVUh2rFkRyYjaKgnUu60i/vQN0+cr6an1dA+uUU2U9fwyL4YU9uzAmnLiqDxLfkXKcROa4eTATLO0ZtslqyRNluXGtL+M4z3HxflKzyLTi0s9fF6n81whsXU9iblmKlPXsImhY83QdbRT9Bo90bOL3lS4JI7kygWbDaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+65ouC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+65ouC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EC1C4CEE3;
	Wed, 14 May 2025 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747243822;
	bh=EuyLeEbest4ehJaN8kn3WTxK/xbofKQTBHJZVQjDdKY=;
	h=Date:From:To:Cc:Subject:From;
	b=m+65ouC5wAlJHEJtDv6RajRYYIJ2KN2XVN8RhbXIo49DDoo7TC8HzNKWQM8ldCWFi
	 A+3JcFOweJn6N/JmOnqVx2D1dl2704Gf/RBkSfwDU+lpuVgqyf1wtC+U2I3qH0aO3X
	 Zjp1r/+8Q/xoG3Y2fTplyoxIsu6C1liog+oYZfZNpVKg2vXw1C+c6pPebfyQPKHv1/
	 4a+aFNsBQNN0a8RV4stNts+A3Mh2pbrdaxaz1CPNAQ/dFWwhWcL5kEN/ymhVPVWupX
	 QDWbjv+dUIjfV8Un4ZuCcaBbYnuz1OMuzWaax4jvCMXCbkmn+H2uHQyjLPa6i7IqvI
	 obuVKJhPDYz2g==
Date: Wed, 14 May 2025 19:30:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: hch@lst.de, djwong@kernel.org, Hans.Holmberg@wdc.com
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 6d444c8db0ac
Message-ID: <ndluoxz4tvj4f2xuz5nkbhkpqhqbwlkjigedxigxzoethnf5bg@s4ovfedmih5l>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been *REBASED*.

My big apologies for the consecutive rebase, but I noticed a couple issues on
the previous rebase and I needed to fix it.
The list below is essentially the same, with a couple new commits, and two
duplicated commits removed.

Again my apologies for the second rebase today, hopefully this is the last (for
today).

Patch list below are everything since the last Pull Request for mainline.

The new head of the for-next branch is commit:

6d444c8db0ac Merge branch 'xfs-6.15-fixes' into for-next

109 new commits:

Carlos Maiolino (5):
      [4abb9052a72b] Merge tag 'atomic-writes-6.16_2025-05-07' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into atomic_writes
      [6e7d71b3a0f9] Merge branch 'atomic_writes-6.16' into xfs-6.16-merge
      [fa8deae92f47] xfs: Fix a comment on xfs_ail_delete
      [08c73a4b2e3c] xfs: Fix comment on xfs_trans_ail_update_bulk()
      [6d444c8db0ac] Merge branch 'xfs-6.15-fixes' into for-next

Christoph Hellwig (3):
      [1c7161ef0164] xfs: remove the EXPERIMENTAL warning for pNFS
      [fbecd731de05] xfs: fix zoned GC data corruption due to wrong bv_offset
      [70b95cb86513] xfs: free the item in xfs_mru_cache_insert on failure

Darrick J. Wong (9):
      [5088aad3d32c] xfs: stop using set_blocksize
      [84270a1a30c9] xfs: only call xfs_setsize_buftarg once per buffer target
      [13c7c54bd0fa] xfs: separate out setting buftarg atomic writes limits
      [6d1bdc739140] xfs: add helpers to compute log item overhead
      [805f89881252] xfs: add helpers to compute transaction reservation for finishing intent items
      [85bf2dfa3f12] xfs: ignore HW which cannot atomic write a single block
      [4528b9052731] xfs: allow sysadmins to specify a maximum atomic write limit at mount time
      [ea31bdece29a] xfs: stop using set_blocksize
      [ca43b74ac304] xfs: remove some EXPERIMENTAL warnings

Dave Chinner (1):
      [23be716b1c4f] xfs: don't assume perags are initialised when trimming AGs

Hans Holmberg (2):
      [bfecc4091e07] xfs: allow ro mounts if rtdev or logdev are read-only
      [f3e2e53823b9] xfs: add inode to zone caching for data placement

John Garry (11):
      [5d894321c49e] fs: add atomic write unit max opt to statx
      [5af9f5508477] xfs: rename xfs_inode_can_atomicwrite() -> xfs_inode_can_hw_atomic_write()
      [6baf4cc47a74] xfs: allow block allocator to take an alignment hint
      [514df14fae97] xfs: refactor xfs_reflink_end_cow_extent()
      [0ea88ed47bb1] xfs: refine atomic write size check in xfs_file_write_iter()
      [bd1d2c21d5d2] xfs: add xfs_atomic_write_cow_iomap_begin()
      [11ab31909d7c] xfs: add large atomic writes checks in xfs_direct_write_iomap_begin()
      [b1e09178b73a] xfs: commit CoW-based atomic writes atomically
      [9baeac3ab1f8] xfs: add xfs_file_dio_write_atomic()
      [0c438dcc3150] xfs: add xfs_calc_atomic_write_unit_max()
      [9dffc58f2384] xfs: update atomic write limits

Nirjhar Roy (IBM) (1):
      [95b613339c0e] xfs: Fail remount with noattr2 on a v5 with v4 enabled

Wengang Wang (1):
      [09dab6ce0243] xfs: free up mp->m_free[0].count in error case

Zizhi Wo (1):
      [c0a5c4084709] xfs: Remove deprecated xfs_bufd sysctl parameters

Code Diffstat:

 Documentation/admin-guide/xfs.rst |  11 ++
 fs/xfs/libxfs/xfs_bmap.c          |   5 +
 fs/xfs/libxfs/xfs_bmap.h          |   6 +-
 fs/xfs/libxfs/xfs_log_rlimit.c    |   4 +
 fs/xfs/libxfs/xfs_trans_resv.c    | 343 ++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_resv.h    |  25 +++
 fs/xfs/scrub/scrub.c              |   2 -
 fs/xfs/xfs_bmap_item.c            |  10 ++
 fs/xfs/xfs_bmap_item.h            |   3 +
 fs/xfs/xfs_buf.c                  |  79 +++++++--
 fs/xfs/xfs_buf.h                  |   4 +-
 fs/xfs/xfs_buf_item.c             |  19 +++
 fs/xfs/xfs_buf_item.h             |   3 +
 fs/xfs/xfs_discard.c              |  17 +-
 fs/xfs/xfs_extfree_item.c         |  10 ++
 fs/xfs/xfs_extfree_item.h         |   3 +
 fs/xfs/xfs_file.c                 |  87 +++++++++-
 fs/xfs/xfs_filestream.c           |  15 +-
 fs/xfs/xfs_globals.c              |   2 -
 fs/xfs/xfs_inode.h                |  14 +-
 fs/xfs/xfs_iomap.c                | 190 ++++++++++++++++++++-
 fs/xfs/xfs_iomap.h                |   1 +
 fs/xfs/xfs_iops.c                 |  76 ++++++++-
 fs/xfs/xfs_iops.h                 |   3 +
 fs/xfs/xfs_log_cil.c              |   4 +-
 fs/xfs/xfs_log_priv.h             |  13 ++
 fs/xfs/xfs_message.c              |  16 --
 fs/xfs/xfs_message.h              |   4 -
 fs/xfs/xfs_mount.c                | 161 ++++++++++++++++++
 fs/xfs/xfs_mount.h                |  27 ++-
 fs/xfs/xfs_mru_cache.c            |  15 +-
 fs/xfs/xfs_pnfs.c                 |   2 -
 fs/xfs/xfs_refcount_item.c        |  10 ++
 fs/xfs/xfs_refcount_item.h        |   3 +
 fs/xfs/xfs_reflink.c              | 146 ++++++++++++----
 fs/xfs/xfs_reflink.h              |   6 +
 fs/xfs/xfs_rmap_item.c            |  10 ++
 fs/xfs/xfs_rmap_item.h            |   3 +
 fs/xfs/xfs_super.c                | 136 ++++++++++++---
 fs/xfs/xfs_sysctl.h               |   2 -
 fs/xfs/xfs_trace.h                | 115 +++++++++++++
 fs/xfs/xfs_trans_ail.c            |  34 ++--
 fs/xfs/xfs_zone_alloc.c           | 109 ++++++++++++
 fs/xfs/xfs_zone_gc.c              |   5 +-
 44 files changed, 1552 insertions(+), 201 deletions(-)
