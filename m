Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB11DE4FF
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 15:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734105461; cv=none; b=qyoM4pn3rR4eCk3exC/5mqTgS1EksbYSIvMGAQuMApf4faAdH5I+YPx9McxIRvPECv4HQ0S/0S7IpIcb2eztO9VEOp+o7gEwMp8tu36P8fhwRwkAciZtoxbsjS1n7P1YsmXfrZqq69r+9CxdUnaMd0UCT/xkcRn+KB5XXvanqdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734105461; c=relaxed/simple;
	bh=S9OlnwJM3HXMVwO8OSkGFySz+d73pBhwcjfHltuvGsI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nOxSY6WtozcwxDIdcZcNYniE7O2Rw5EH9D0jLYJe3RMusD8oRrpeGLyfyDPpS95Ts+8ZxcdbpD/b6HwarDP6Z7AHOFzsAblrbWvaI8GwrUFawHH7I02x+dBpPzAdqmYxA3cm+9vIJ7inMisS2ZzX/F/E58sCuXh2G7w7P262OHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYEkzVZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYEkzVZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8302EC4CED0;
	Fri, 13 Dec 2024 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734105460;
	bh=S9OlnwJM3HXMVwO8OSkGFySz+d73pBhwcjfHltuvGsI=;
	h=Date:From:To:Cc:Subject:From;
	b=XYEkzVZKwNCpWQ23R00QXjkNxErit8YhkI1GyRckzPKHrxfa45YEO5KVezLGTYRAo
	 /dGrJD5JBHfCkyqueuaJ35oKw3CYjKJaLD+Rsg7xWl/bKig/W5G1XOHQa8c6RiunD0
	 uSet2pC4uEBCpF7mFijS3pzVjoVmpHK+cK2WhoU1esitYMKuBOpxulYd3aBtzMVdeU
	 fMgeaPqkb4mhEbNICNAh7uSAJoF5tiJr4P5khR5ztVf7BCMFF70X232qOEQmXnuRDS
	 tgN4XaBk8BGXseiOhWWlzIOSrETApyYnTfUOV8MM2Zuf3HwcvrLvABaX4hbhwk/HAL
	 0Q+EjVVQ2pD0Q==
Date: Fri, 13 Dec 2024 16:57:36 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for 6.13-rc3
Message-ID: <cf5d4x5hfxbsca5c5g5o5r7k225ul3v67liy365gp5wagq2yzv@6v427uwmp5vz>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

could you please pull the patches described on the request below?

I just attempted a merge against your TOT, and no conflicts have been found.

Fixes highlights are in the dag description.

Notice though, this has been rebased after Steven Rothwell pulled this into
linux-next. The reason for the rebase is because he initially found a build
issue when XFS_QUOTA config option was turned off. We initially fixed that by
patching the problem, but we decided to squash the fix into the problematic
patch to avoid breaking bisectability as the patches were still not in mainline.
Please let me know if there is any issues with that.

Thanks,
Carlos.

The following changes since commit f932fb9b40749d1c9a539d89bb3e288c077aafe5:

  Merge tag 'v6.13-rc2-ksmbd-server-fixes' of git://git.samba.org/ksmbd (2024-12-12 17:33:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-6.13-rc3

for you to fetch changes up to bf354410af832232db8438afe006bb12675778bc:

  Merge tag 'xfs-6.13-fixes_2024-12-12' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc (2024-12-13 07:47:12 +0100)

----------------------------------------------------------------
Bug fixes for 6.13-rc3

* Fixes for scrub subsystem
* Fix quota crashes
* Fix sb_spino_align checons on large fsblock sizes
* Fix discarded superblock updates
* fix stuck unmount due to a locked inode

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Carlos Maiolino (1):
      Merge tag 'xfs-6.13-fixes_2024-12-12' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into next-rc

Darrick J. Wong (28):
      xfs: fix off-by-one error in fsmap's end_daddr usage
      xfs: metapath scrubber should use the already loaded inodes
      xfs: keep quota directory inode loaded
      xfs: return a 64-bit block count from xfs_btree_count_blocks
      xfs: don't drop errno values when we fail to ficlone the entire range
      xfs: separate healthy clearing mask during repair
      xfs: set XFS_SICK_INO_SYMLINK_ZAPPED explicitly when zapping a symlink
      xfs: mark metadir repair tempfiles with IRECOVERY
      xfs: fix null bno_hint handling in xfs_rtallocate_rtg
      xfs: fix error bailout in xfs_rtginode_create
      xfs: update btree keys correctly when _insrec splits an inode root block
      xfs: fix scrub tracepoints when inode-rooted btrees are involved
      xfs: unlock inodes when erroring out of xfs_trans_alloc_dir
      xfs: only run precommits once per transaction object
      xfs: avoid nested calls to __xfs_trans_commit
      xfs: don't lose solo superblock counter update transactions
      xfs: don't lose solo dquot update transactions
      xfs: separate dquot buffer reads from xfs_dqflush
      xfs: clean up log item accesses in xfs_qm_dqflush{,_done}
      xfs: attach dquot buffer to dquot log item buffer
      xfs: convert quotacheck to attach dquot buffers
      xfs: fix sb_spino_align checks for large fsblock sizes
      xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
      xfs: don't crash on corrupt /quotas dirent
      xfs: check pre-metadir fields correctly
      xfs: fix zero byte checking in the superblock scrubber
      xfs: return from xfs_symlink_verify early on V4 filesystems
      xfs: port xfs_ioc_start_commit to multigrain timestamps

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
