Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA85C5D910
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWl9cncv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD9BC433C7;
	Fri, 15 Dec 2023 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702677344;
	bh=In0aolk83/YXRfY8xw6Yn1hz8/+cW7I0RWsby00ovo4=;
	h=Date:Subject:From:To:Cc:From;
	b=YWl9cncvyVDWv1wNmawBTcH+s4CFcf0QgEIECllKGhLB/gjHNAmPk8G++6awxVN3b
	 idK+5jpXO2QXRyaqaleAHseV/g6LycmVZ618Q5hsgwZcA/XQb2+kKrsoPyxOUFPTIx
	 CNZVRRW0X8EDZgNH70Bq+EqXzQLIP6FboVzmS4OIQJWU5/ggxDu42muuVMZ7ZIszCb
	 WD8qMPvHpeWj/zE6It85ghAa7M6VwFowro9n4VFZ0Q7b70Bke9Kc5yO+hbUko0gCGx
	 gi24ya2dZs72rt/gWaBDuPZGxzAj5Bs75S/xlRSw2PvrO3htA+aNH5UeBgDJcfnAX4
	 SQWw9FZR1dxMQ==
Date: Fri, 15 Dec 2023 13:55:43 -0800
Subject: [GIT PULL 3/6] xfs: online repair of inodes and forks
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <170267713452.2577253.5573004281850246886.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.8-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 9099cd38002f8029c9a1da08e6832d1cd18e8451:

xfs: repair refcount btrees (2023-12-15 10:03:33 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-inodes-6.8_2023-12-15

for you to fetch changes up to c3a22c2e4b45fcf3184e7dd1c755e6b45dc9f499:

xfs: skip the rmapbt search on an empty attr fork unless we know it was zapped (2023-12-15 10:03:38 -0800)

----------------------------------------------------------------
xfs: online repair of inodes and forks [v28.3]

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (9):
xfs: disable online repair quota helpers when quota not enabled
xfs: try to attach dquots to files before repairing them
xfs: add missing nrext64 inode flag check to scrub
xfs: dont cast to char * for XFS_DFORK_*PTR macros
xfs: set inode sick state flags when we zap either ondisk fork
xfs: repair inode records
xfs: zap broken inode forks
xfs: abort directory parent scrub scans if we encounter a zapped directory
xfs: skip the rmapbt search on an empty attr fork unless we know it was zapped

fs/xfs/Makefile                    |    1 +
fs/xfs/libxfs/xfs_attr_leaf.c      |   13 +-
fs/xfs/libxfs/xfs_attr_leaf.h      |    3 +-
fs/xfs/libxfs/xfs_bmap.c           |   22 +-
fs/xfs/libxfs/xfs_bmap.h           |    2 +
fs/xfs/libxfs/xfs_dir2_priv.h      |    3 +-
fs/xfs/libxfs/xfs_dir2_sf.c        |   13 +-
fs/xfs/libxfs/xfs_format.h         |    2 +-
fs/xfs/libxfs/xfs_health.h         |   10 +
fs/xfs/libxfs/xfs_inode_fork.c     |   33 +-
fs/xfs/libxfs/xfs_shared.h         |    2 +-
fs/xfs/libxfs/xfs_symlink_remote.c |    8 +-
fs/xfs/scrub/bmap.c                |  144 +++-
fs/xfs/scrub/common.c              |   28 +
fs/xfs/scrub/common.h              |    8 +
fs/xfs/scrub/dir.c                 |   42 +-
fs/xfs/scrub/health.c              |   32 +
fs/xfs/scrub/health.h              |    2 +
fs/xfs/scrub/inode.c               |   16 +-
fs/xfs/scrub/inode_repair.c        | 1525 ++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/parent.c              |   17 +
fs/xfs/scrub/repair.c              |   57 +-
fs/xfs/scrub/repair.h              |   29 +
fs/xfs/scrub/rtbitmap.c            |    4 +
fs/xfs/scrub/rtsummary.c           |    4 +
fs/xfs/scrub/scrub.c               |    2 +-
fs/xfs/scrub/symlink.c             |   20 +-
fs/xfs/scrub/trace.h               |  171 ++++
fs/xfs/xfs_dir2_readdir.c          |    3 +
fs/xfs/xfs_health.c                |    8 +-
fs/xfs/xfs_inode.c                 |   35 +
fs/xfs/xfs_inode.h                 |    2 +
fs/xfs/xfs_symlink.c               |    3 +
fs/xfs/xfs_xattr.c                 |    6 +
34 files changed, 2185 insertions(+), 85 deletions(-)
create mode 100644 fs/xfs/scrub/inode_repair.c

