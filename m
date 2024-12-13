Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB452AF07;
	Fri, 13 Dec 2024 01:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734054710; cv=none; b=cASzcgDR/75qIiJ9cEVDr+PfoW69P1TlnbO3mqTJgvsZpePioZ5j1D9d4sxiiomUNwuMx+qoSOX+Yix+1gVrQTzkblsKwB+VBUG3sSn61MSesjkCMfGeVCVOIosMr65+fRZ+bD1eGxF3px2cVQhUsx2FL/WbPnAFC9B9UtPM1u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734054710; c=relaxed/simple;
	bh=A5hmFDPQrDk3mhkD1kROkrgTdZbf8cewr5kUL74YAuc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=sohq0SkEHWjzJbznwNT4qI8brc90II6uH9XF1LvkhxShXEX1uFzv5WMF8jIipoH8g5qz4zVrt8XryuxCfeLA5VEBxNtXH+RX8muHA70oz0Mm320qJygbmZ/szW1MVv3DwlObaLHZbY2tUucN3ilx7wHfUH/RlnX8Cyy8bGy7Rp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=puUG3x9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="puUG3x9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4156EC4CECE;
	Fri, 13 Dec 2024 01:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734054710;
	bh=A5hmFDPQrDk3mhkD1kROkrgTdZbf8cewr5kUL74YAuc=;
	h=Date:Subject:From:To:Cc:From;
	b=puUG3x9o/7gVoQrSf/GXfxUd3SGgQwVdDIKEPWofni1a0p4RV8vu15aQUssH2etvJ
	 E9pElEK6Vh55MnhyJezVLl7UEtm069GwYzLZ6WNUQmFx/IY6L1XgPl33StXswbZd59
	 pRQZYq4dI4QE/zo2ZUXXTxHAfwVUxeB6On397jsf6ZkfDNGChXr1GrKx7f6deUfmKe
	 PJgl/gNbF09BvyaxWrU3onebUIzly2xEw3XuGEf32RpC+d1+od2GdcpzrXd1giapjS
	 BvbLdY+mFHHH5RVkl4hhCufkTHtR4EvEfdsbwpywB1XSyfleDUOv0cSPudk2hS8yEK
	 ooSrx+ViX/NHQ==
Date: Thu, 12 Dec 2024 17:51:49 -0800
Subject: [GIT PULL] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, jlayton@kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org, wozizhi@huawei.com
Message-ID: <173405445870.1255647.17634074191421041925.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs.  Christoph said that he'd
rather we rebased the whole xfs for-next branch to preserve
bisectability so this branch folds in his fix for !quota builds and a
missing zero initialization for struct kstat in the mgtime conversion
patch that the build robots just pointed out.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit f92f4749861b06fed908d336b4dee1326003291b:

Merge tag 'clk-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/clk/linux (2024-12-10 18:21:40 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/xfs-6.13-fixes_2024-12-12

for you to fetch changes up to 12f2930f5f91bc0d67794c69d1961098c7c72040:

xfs: port xfs_ioc_start_commit to multigrain timestamps (2024-12-12 17:45:13 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.13 [01/12]

Bug fixes for 6.13.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
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
fs/xfs/xfs_trans.c                 |  58 ++++++-----
fs/xfs/xfs_trans_ail.c             |   2 +-
fs/xfs/xfs_trans_dquot.c           |  31 +++++-
33 files changed, 578 insertions(+), 251 deletions(-)

