Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A91C145A0B;
	Wed,  4 Dec 2024 03:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733282601; cv=none; b=sjPPGW2S3kiBxW+aveoy3QRcG/2nROsX1glK8nDhZFng2PZf4azEnQfC1srgjFViRDdD8vGS4ksqqo9OmCWAAKu/VteS66DeQDK0rFPQy1HkmJM4fP38DAhFjRE/VblW6XCZ8yQ8KL5VXq5vqW/q+bLQRxhsadZqhsRSJGb0RZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733282601; c=relaxed/simple;
	bh=JeTbbGh+igtqLAeGNq1wAJhz9kFuQ1HReyhHEuaf+i8=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=IrtN+WiJ2fnfGyb+O5TY0MhA4pzel/WgVFpo8JnXzI1r8ZrQ15YAieitCQ9DqLMZV/u88roCwVn27sZYWx4OkkM69YZSVU0OwllVF8ufrveR2vYLQWovGeojheYK1kyGRoXePNVUze5tkfXfDj9hO1mVT6m0uDNvhSfnIjOIUxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aB3z9lhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aB3z9lhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F58C4CEDE;
	Wed,  4 Dec 2024 03:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733282600;
	bh=JeTbbGh+igtqLAeGNq1wAJhz9kFuQ1HReyhHEuaf+i8=;
	h=Date:Subject:From:To:Cc:From;
	b=aB3z9lhBXIfsItt38ZmBuzQ430cFCCe/k8jUXTftH1VDaOb6s0ed+LcLQzXXddOFW
	 KXqOYoXtnwzbbSmAw7P6Xf9zZU1LvLw0H2JokoGUemkCWcDck8cFm/BC8o5sDEsHih
	 tKBdLZUcp14qMsZ2cUqbQmzHI7J/IA5vyETqPq+GtYLCuE884fQDE09oLYDQ5hcJ/D
	 MtK9PE9mJFKDpH2NB2ULYLbOV9G9fSe+AMNwmBZJx1cs2y07AqjJH9o8+CVg9HwvjA
	 y60tHptsVsR3o+L4W15alROnzscQk+9sUmWrEWJxLFCIGkAfnWEDWYfzQPiHaJRtjZ
	 aF6/Gp2qRPuPQ==
Date: Tue, 03 Dec 2024 19:23:19 -0800
Subject: [GIT PULL] xfs: bug fixes for 6.13
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: dan.carpenter@linaro.org, hch@lst.de, linux-xfs@vger.kernel.org, stable@vger.kernel.org, wozizhi@huawei.com
Message-ID: <173328206660.1159971.4540485910402305562.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs against 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit feffde684ac29a3b7aec82d2df850fbdbdee55e4:

Merge tag 'for-6.13-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2024-12-03 11:02:17 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/fixes-6.13_2024-12-03

for you to fetch changes up to 641a4a63154885060b7900f86bb45582f07e964b:

xfs: fix sb_spino_align checks for large fsblock sizes (2024-12-03 18:54:49 -0800)

----------------------------------------------------------------
xfs: bug fixes for 6.13 [v2 1/2]

Here are some bugfixes for 6.13 that have been accumulating since 6.12
was released.

With a bit of luck, this should all go splendidly.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (22):
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

fs/xfs/libxfs/xfs_btree.c        |  33 +++++--
fs/xfs/libxfs/xfs_btree.h        |   2 +-
fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
fs/xfs/libxfs/xfs_rtgroup.c      |   2 +-
fs/xfs/libxfs/xfs_sb.c           |  11 ++-
fs/xfs/scrub/agheader.c          |   6 +-
fs/xfs/scrub/agheader_repair.c   |   6 +-
fs/xfs/scrub/fscounters.c        |   2 +-
fs/xfs/scrub/health.c            |  57 +++++++-----
fs/xfs/scrub/ialloc.c            |   4 +-
fs/xfs/scrub/metapath.c          |  68 ++++++--------
fs/xfs/scrub/refcount.c          |   2 +-
fs/xfs/scrub/scrub.h             |   6 ++
fs/xfs/scrub/symlink_repair.c    |   3 +-
fs/xfs/scrub/tempfile.c          |  10 +-
fs/xfs/scrub/trace.h             |   2 +-
fs/xfs/xfs_bmap_util.c           |   2 +-
fs/xfs/xfs_dquot.c               | 195 +++++++++++++++++++++++++++++++++------
fs/xfs/xfs_dquot.h               |   6 +-
fs/xfs/xfs_dquot_item.c          |  51 +++++++---
fs/xfs/xfs_dquot_item.h          |   7 ++
fs/xfs/xfs_file.c                |   8 ++
fs/xfs/xfs_fsmap.c               |  38 ++++----
fs/xfs/xfs_inode.h               |   2 +-
fs/xfs/xfs_qm.c                  |  95 +++++++++++++------
fs/xfs/xfs_qm.h                  |   1 +
fs/xfs/xfs_quota.h               |   7 +-
fs/xfs/xfs_rtalloc.c             |   2 +-
fs/xfs/xfs_trans.c               |  58 ++++++------
fs/xfs/xfs_trans_ail.c           |   2 +-
fs/xfs/xfs_trans_dquot.c         |  31 ++++++-
31 files changed, 495 insertions(+), 228 deletions(-)

