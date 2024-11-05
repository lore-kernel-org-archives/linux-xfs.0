Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E84E1D1748
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 23:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850666; cv=none; b=ERpE99t2OiwiV0LDsjzPXuH1ou6sb6bw/9m89P3Ct/M+/YDvLNq6EksatITqFGGUv1PgwEjOXfMa2Me1pygy2oluhP22ZkFnxyGiMm8AONG4CliDuDVZK5csvQj9M9nJmYjn8S/x1fcj8wz5sQJCbqaQcYiD5dJ4gU3G7Qm2l7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850666; c=relaxed/simple;
	bh=4hzEQWIlqf9Fc2MVK5ZbMboksLcHYfHybnSOuetnF34=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=gN5sdwQPyEc1IIuUGE5+7wLRXO4+F2ZquaTzwVJQ2UXbV+qmlkMnlT423CrJ3FMoXbuHjCyB884kL8wT4VVIKp73FvMvDh0pURcUl5/FlHM+C/2zldDRr5qXvoxPZ3sZ7QYWM/FLZrrX6jCzcZHSUxsjGoyBEHBeI/3wVSlGsUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uhWxi6uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uhWxi6uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166F7C4CECF;
	Tue,  5 Nov 2024 23:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850666;
	bh=4hzEQWIlqf9Fc2MVK5ZbMboksLcHYfHybnSOuetnF34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uhWxi6uycemERn8RiTBllScT0AAUmvVZ5jsSQfdIPUjGQTOwpRRnBWwI9eXUBzpQ1
	 +aqKPRSszA25AiLbJBmgJVA+kbBbTFHbq+k/3caBDQtTthfXUHomYBP4znYZlVlCQg
	 0Mj+1DAfariFA7CWpsmEyg/oRsE6kLaFwAQcPETyAHNy3w+by7Swt4l4PsPO/C09tP
	 axiGR3KgRGvMSSPbfsaggY39VUQCQerb+XnKPgr/FfEdV/TqATYLxJEL/vjIFPrC+i
	 d+Xbqx5MQ718fmH8o15ItQLGyGmCmUHtPoJ6pVBjnTQPvIZZ8EKafZ0b6o6OPPkm7i
	 jUIgrDk9tDJ3g==
Date: Tue, 05 Nov 2024 15:51:05 -0800
Subject: [GIT PULL 04/10] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173085054192.1980968.18037248267154179650.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241105234839.GL2386201@frogsfrogsfrogs>
References: <20241105234839.GL2386201@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 0d2c636e489c115add86bd66952880f92b5edab7:

xfs: repair metadata directory file path connectivity (2024-11-05 13:38:35 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/incore-rtgroups-6.13_2024-11-05

for you to fetch changes up to f220f6da5f4ad7da538c39075cf57e829d5202f7:

xfs: make RT extent numbers relative to the rtgroup (2024-11-05 13:38:38 -0800)

----------------------------------------------------------------
xfs: create incore rt allocation groups [v5.5 04/10]

Add in-memory data structures for sharding the realtime volume into
independent allocation groups.  For existing filesystems, the entire rt
volume is modelled as having a single large group, with (potentially) a
number of rt extents exceeding 2^32 blocks, though these are not likely
to exist because the codebase has been a bit broken for decades.  The
next series fills in the ondisk format and other supporting structures.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (14):
xfs: clean up xfs_getfsmap_helper arguments
xfs: add a xfs_bmap_free_rtblocks helper
xfs: add a xfs_qm_unmount_rt helper
xfs: factor out a xfs_growfs_rt_alloc_blocks helper
xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
xfs: split xfs_trim_rtdev_extents
xfs: move RT bitmap and summary information to the rtgroup
xfs: support creating per-RTG files in growfs
xfs: calculate RT bitmap and summary blocks based on sb_rextents
xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
xfs: factor out a xfs_growfs_check_rtgeom helper
xfs: refactor xfs_rtbitmap_blockcount
xfs: refactor xfs_rtsummary_blockcount
xfs: make RT extent numbers relative to the rtgroup

Darrick J. Wong (7):
xfs: create incore realtime group structures
xfs: define locking primitives for realtime groups
xfs: add a lockdep class key for rtgroup inodes
xfs: support caching rtgroup metadata inodes
xfs: add rtgroup-based realtime scrubbing context management
xfs: remove XFS_ILOCK_RT*
xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper

fs/xfs/Makefile                 |   1 +
fs/xfs/libxfs/xfs_bmap.c        |  46 ++--
fs/xfs/libxfs/xfs_format.h      |   3 +
fs/xfs/libxfs/xfs_rtbitmap.c    | 199 +++++++--------
fs/xfs/libxfs/xfs_rtbitmap.h    | 147 ++++++------
fs/xfs/libxfs/xfs_rtgroup.c     | 484 +++++++++++++++++++++++++++++++++++++
fs/xfs/libxfs/xfs_rtgroup.h     | 274 +++++++++++++++++++++
fs/xfs/libxfs/xfs_sb.c          |  13 +
fs/xfs/libxfs/xfs_trans_resv.c  |   2 +-
fs/xfs/libxfs/xfs_types.h       |   8 +-
fs/xfs/scrub/bmap.c             |  13 +
fs/xfs/scrub/common.c           |  78 ++++++
fs/xfs/scrub/common.h           |  30 +++
fs/xfs/scrub/fscounters.c       |  25 +-
fs/xfs/scrub/repair.c           |  24 ++
fs/xfs/scrub/repair.h           |   7 +
fs/xfs/scrub/rtbitmap.c         |  54 +++--
fs/xfs/scrub/rtsummary.c        | 111 +++++----
fs/xfs/scrub/rtsummary_repair.c |   7 +-
fs/xfs/scrub/scrub.c            |  33 ++-
fs/xfs/scrub/scrub.h            |  13 +
fs/xfs/xfs_bmap_util.c          |   3 +-
fs/xfs/xfs_buf_item_recover.c   |  25 ++
fs/xfs/xfs_discard.c            | 100 +++++---
fs/xfs/xfs_fsmap.c              | 329 ++++++++++++++-----------
fs/xfs/xfs_fsmap.h              |  15 ++
fs/xfs/xfs_inode.c              |   3 +-
fs/xfs/xfs_inode.h              |  13 +-
fs/xfs/xfs_iomap.c              |   4 +-
fs/xfs/xfs_mount.c              |  15 +-
fs/xfs/xfs_mount.h              |  26 +-
fs/xfs/xfs_qm.c                 |  27 ++-
fs/xfs/xfs_rtalloc.c            | 520 +++++++++++++++++++++++++---------------
fs/xfs/xfs_super.c              |   3 +-
fs/xfs/xfs_trace.c              |   1 +
fs/xfs/xfs_trace.h              |  74 ++++--
36 files changed, 2020 insertions(+), 710 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h

