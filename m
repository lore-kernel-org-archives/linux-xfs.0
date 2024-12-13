Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B471552FC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074531; cv=none; b=XSGcSyXeStyxCO4s7NxY9ODT/SD/9Zx1gVsxK6flqeFErsBcpOf243pexyngzn0J8oOjZ1QMJJ72GTPze3CQrDWnp5CUMF2RaFLPwl+bAdw3JrFtiKSKCvNCVnrsK7wM87E/OjTgVa7oSHr4zTAQyvIJreX5mFUFVkyW/NM4vD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074531; c=relaxed/simple;
	bh=5Hhu0VN3lGcmOL0tuj1B7nH7xsmw3+OeYkvx9pK/Row=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YejEwuFHyBZplzwLvhBs2gfbY6d0LBV0aSRyEOSAIBpTuplKRLOqT8mVgQiHO9Pa+eL/HBgy5DwtU/kBnoi/mh/qogOlhSqS7mJVClFKPV1iD0BVtfbgwwMHJ4JZvGn+TeHNGAnSPx/F684FkaEcu8lP+DK6XTQ1O+TgrrKv79E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NizFGg2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NizFGg2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399D4C4CED1
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734074529;
	bh=5Hhu0VN3lGcmOL0tuj1B7nH7xsmw3+OeYkvx9pK/Row=;
	h=Date:From:To:Subject:From;
	b=NizFGg2Pkm+8qjX8H5LQrwruNn7gjvfg64F7lWDai5osHRMuMm1IC2lmy+tsE64h+
	 upDyWL+b40zULhXjwkUdL0wagH7fAZMbqpgK6BsoPJ7UaHlldfqLtSypna2qt56XV2
	 vkFztQABWUZ/PSbAJwgV3I3hblDfIPCfIuctvJ1B15Gy5H7f8HZRKwKRnypIsMO7K+
	 fa/p6tBUazgkvh9OUeUfy4tYdFsZHPv1hEN11/w2S/7bLHFGo5Ic0c9mXuYBr0ySUK
	 FraGfmcZKXCZoKLlmUMAWPTXJV9QGcqMlvFR/BnQoGnJh4Ey9RZyqBwYaEAJhYnUBG
	 ejxv1V1mi+mdQ==
Date: Fri, 13 Dec 2024 08:22:06 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: changeme
Message-ID: <4x3b5i3h577qovwib5qore57h36ngcqogrxfobnmi3l76u6yju@zhz374ndprye>
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

has just been **REBASED**.

This was required due to an issue in one of the patches previously applied,
below is the full log to what's going to Linus this week.

As usual, patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

bf354410af83 Merge tag 'xfs-6.13-fixes_2024-12-12' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

29 new commits:

Carlos Maiolino (1):
      [bf354410af83] Merge tag 'xfs-6.13-fixes_2024-12-12' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

Darrick J. Wong (28):
      [a440a28ddbdc] xfs: fix off-by-one error in fsmap's end_daddr usage
      [9b7280010366] xfs: metapath scrubber should use the already loaded inodes
      [e1d8602b6cfb] xfs: keep quota directory inode loaded
      [bd27c7bcdca2] xfs: return a 64-bit block count from xfs_btree_count_blocks
      [7ce31f20a077] xfs: don't drop errno values when we fail to ficlone the entire range
      [aa7bfb537edf] xfs: separate healthy clearing mask during repair
      [6f4669708a69] xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink
      [dc5a0527398d] xfs: mark metadir repair tempfiles with IRECOVERY
      [af9f02457f46] xfs: fix null bno_hint handling in xfs_rtallocate_rtg
      [23bee6f390a1] xfs: fix error bailout in xfs_rtginode_create
      [6d7b4bc1c3e0] xfs: update btree keys correctly when _insrec splits an inode root block
      [ffc3ea4f3c1c] xfs: fix scrub tracepoints when inode-rooted btrees are involved
      [53b001a21c9d] xfs: unlock inodes when erroring out of xfs_trans_alloc_dir
      [44d9b07e52db] xfs: only run precommits once per transaction object
      [a004afdc6294] xfs: avoid nested calls to __xfs_trans_commit
      [3762113b597f] xfs: don't lose solo superblock counter update transactions
      [07137e925fa9] xfs: don't lose solo dquot update transactions
      [a40fe30868ba] xfs: separate dquot buffer reads from xfs_dqflush
      [ec88b41b932d] xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
      [acc8f8628c37] xfs: attach dquot buffer to dquot log item buffer
      [ca378189fdfa] xfs: convert quotacheck to attach dquot buffers
      [7f8a44f37229] xfs: fix sb_spino_align checks for large fsblock sizes
      [3853b5e1d7cc] xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
      [e57e083be9b9] xfs: don't crash on corrupt /quotas dirent
      [06b20ef09ba1] xfs: check pre-metadir fields correctly
      [c004a793e0ec] xfs: fix zero byte checking in the superblock scrubber
      [7f8b718c5878] xfs: return from xfs_symlink_verify early on V4 filesystems
      [12f2930f5f91] xfs: port xfs_ioc_start_commit to multigrain timestamps

Code Diffstat:

 fs/xfs/libxfs/xfs_btree.c          |  33 +++++--
 fs/xfs/libxfs/xfs_btree.h          |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   4 +-
 fs/xfs/libxfs/xfs_rtgroup.c        |   2 +-
 fs/xfs/libxfs/xfs_sb.c             |  11 ++-
 fs/xfs/libxfs/xfs_symlink_remote.c |   4 +-
 fs/xfs/scrub/agheader.c            |  77 +++++++++++----
 fs/xfs/scrub/agheader_repair.c     |   6 +-
 fs/xfs/scrub/fscounters.c          |   2 +-
 fs/xfs/scrub/health.c              |  57 ++++++-----
 fs/xfs/scrub/ialloc.c              |   4 +-
 fs/xfs/scrub/metapath.c            |  68 +++++--------
 fs/xfs/scrub/refcount.c            |   2 +-
 fs/xfs/scrub/scrub.h               |   6 ++
 fs/xfs/scrub/symlink_repair.c      |   3 +-
 fs/xfs/scrub/tempfile.c            |  22 ++++-
 fs/xfs/scrub/trace.h               |   2 +-
 fs/xfs/xfs_bmap_util.c             |   2 +-
 fs/xfs/xfs_dquot.c                 | 195 +++++++++++++++++++++++++++++++------
 fs/xfs/xfs_dquot.h                 |   6 +-
 fs/xfs/xfs_dquot_item.c            |  51 +++++++---
 fs/xfs/xfs_dquot_item.h            |   7 ++
 fs/xfs/xfs_exchrange.c             |  14 +--
 fs/xfs/xfs_file.c                  |   8 ++
 fs/xfs/xfs_fsmap.c                 |  38 +++++---
 fs/xfs/xfs_inode.h                 |   2 +-
 fs/xfs/xfs_qm.c                    | 102 +++++++++++++------
 fs/xfs/xfs_qm.h                    |   1 +
 fs/xfs/xfs_quota.h                 |   5 +-
 fs/xfs/xfs_rtalloc.c               |   2 +-
 fs/xfs/xfs_trans.c                 |  56 +++++------
 fs/xfs/xfs_trans_ail.c             |   2 +-
 fs/xfs/xfs_trans_dquot.c           |  31 +++++-
 33 files changed, 577 insertions(+), 250 deletions(-)
