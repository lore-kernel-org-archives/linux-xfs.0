Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578671684AC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 19:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734117828; cv=none; b=oWg4Hy60XyS+D5QYv++u4g8F7ZdjDkLUfraTuBLt50awiv6LftRIIxnauiUOlpEyVPU96E4bf1sVrCrlz2vVYNPSyxr4Als8Ua6fAfRs4X/g7TseGgbkLzT0fL9KLieLP1T64JoVmFKW5M+mBUhGlgEw/U94+/BF0a++vWyv1OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734117828; c=relaxed/simple;
	bh=EGeAtA+g/W/sVXmW0p0/H7LXlzj6fI+jRHhVcWAS8JA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WkcLwoGBKMvjalaNkql06OvlawP+kIyvXum8Iprj2wt+QI6p3cLGoS1027/T7vKDdGrxwXhht+S3NI7X7AJRRD6lJ2+e4m9XROlpfjygi1v/4lzwlgOrbVcvDrUUslmAHlD0GEjSxWUrejL67JfP7fge0MKWb37P3Wkpo1fx3gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pu1zLmTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pu1zLmTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDD5C4CED0;
	Fri, 13 Dec 2024 19:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734117828;
	bh=EGeAtA+g/W/sVXmW0p0/H7LXlzj6fI+jRHhVcWAS8JA=;
	h=Date:From:To:Cc:Subject:From;
	b=pu1zLmTvWO5H0pOdLr3sUEUBNWq9rwqVIbgJ2eNNZJr3LaWH1R+iPCz6dUFTntHmo
	 1e5lWONZBixNEYvQwWLSAmDJS5/fLV9EDdsDkQ7HG0YUEz0qWWMQHcPlHEe6NhJ9MJ
	 Y7Kf8o2b7PQf6NyMuhYW4F8pSsvnLVhGLCaheigrCvILXd3Htq4VC5Y9qdcMwXfPco
	 hdbXi1SKoGSq2tPHV/v6B5MLKrdI+gMiGrIAn4CRPtA7hmxJ5hmAiY7b5y1P46adiW
	 dJlZsmW5D1jzhHNNR/JLWauLA4UxCQUndHZIb8Vw1KF5ktYnVe6ROJAdurFzSXQw4V
	 HX8IHC25hEVuQ==
Date: Fri, 13 Dec 2024 20:23:43 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: hch@lst.de, djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for 6.13-rc3 - V2
Message-ID: <hcfhmfl252ski7nglf7f7uf2roulbd5da3uu2qs3jrtk45kai5@phgqvy4t2hkf>
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

It's the very same pull I sent earlier, just signed with the correct key.
Just in case, I tried a merge against your TOT and didn't get any conflicts.
I'm keeping the original pull request below for context

Fixes highlights are in the tag description.

Notice though, this has been rebased after Steven Rothwell pulled this into
linux-next. The reason for the rebase is because he initially found a build
issue when XFS_QUOTA config option was turned off. We initially fixed that by
patching the problem, but we decided to squash the fix into the problematic
patch to avoid breaking bisectability as the patches were still not in mainline.
Please let me know if there is any issues with that.

Thanks and my apologies for the key mistake,
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

