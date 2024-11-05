Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F378D21018F
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844296; cv=none; b=raJ0UMwAGVwSxulI0hrR9gXxOteC6VoAWB5qGxj/LRzHRcC/pSfMXSN/FIFJvXv6BBj9HO2FtMhWiu1t/NvnBD7Dmda5SblQbHAWaavWbKl5/xO+l/ibqgCUwpvrpGeR49wYiyKIIw3VdYzO3Lnuub2sQbh/lG45l7mdwtDeFvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844296; c=relaxed/simple;
	bh=4k4SOOJpdumlZ8HgOR19jfIVMkHG0Pwj5ZAGtSFQ71g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGT83gXsJ7y/gBrIb0O3hQMxbaDUlTJrhqaQ6g1bwfsB/Zcw5e6TLI+TO7jndPiykZeMWb0filHqwlQjO566Tr+M4dlWh3tppfgqVhUNjlqpn9BiAOeGXnAx4cjPFs3t/0DcpbhNrbVn1p0BeKsuvVmj3g0B8Io8QSBhSacoRn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sa9T8cy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sa9T8cy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951F7C4CECF;
	Tue,  5 Nov 2024 22:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844295;
	bh=4k4SOOJpdumlZ8HgOR19jfIVMkHG0Pwj5ZAGtSFQ71g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sa9T8cy43cN9xA7qVFOoO4x4BqGOdEx779lG6+kNyG6WzKbDv3uu3Kmks2+BrAI3s
	 QVhjFq30RCKTgA4mdIEnXxZSFLu9Lhr2W5zFAgYKWSWQBzFUkE9VDrlRUJJhItS05v
	 rxRVUII/b7LgZAaLEtb4zJpidTWM1mtsF6r7sR2F/P2w2DTvBljOgyoBZB2UhRDWnQ
	 4qGoP5N35/BBnGudrX/GtTTGnFKV31rOeAAN+dIK1F2w8f7hQpcvXm1ss0nTtQFgG9
	 Hatujp1RiuwBvbA0JFzZ2r3+mVeQw82x4iYe80SuSB3vFuO2bu9PIyJV+1DZ4KQnib
	 GbfwkIbex/ZQA==
Date: Tue, 05 Nov 2024 14:04:55 -0800
Subject: [PATCHSET v5.5 04/10] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084396885.1871025.10467232711863188560.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Add in-memory data structures for sharding the realtime volume into
independent allocation groups.  For existing filesystems, the entire rt
volume is modelled as having a single large group, with (potentially) a
number of rt extents exceeding 2^32 blocks, though these are not likely
to exist because the codebase has been a bit broken for decades.  The
next series fills in the ondisk format and other supporting structures.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-rtgroups-6.13
---
Commits in this patchset:
 * xfs: clean up xfs_getfsmap_helper arguments
 * xfs: create incore realtime group structures
 * xfs: define locking primitives for realtime groups
 * xfs: add a lockdep class key for rtgroup inodes
 * xfs: support caching rtgroup metadata inodes
 * xfs: add rtgroup-based realtime scrubbing context management
 * xfs: add a xfs_bmap_free_rtblocks helper
 * xfs: add a xfs_qm_unmount_rt helper
 * xfs: factor out a xfs_growfs_rt_alloc_blocks helper
 * xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
 * xfs: split xfs_trim_rtdev_extents
 * xfs: move RT bitmap and summary information to the rtgroup
 * xfs: support creating per-RTG files in growfs
 * xfs: remove XFS_ILOCK_RT*
 * xfs: calculate RT bitmap and summary blocks based on sb_rextents
 * xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
 * xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
 * xfs: factor out a xfs_growfs_check_rtgeom helper
 * xfs: refactor xfs_rtbitmap_blockcount
 * xfs: refactor xfs_rtsummary_blockcount
 * xfs: make RT extent numbers relative to the rtgroup
---
 fs/xfs/Makefile                 |    1 
 fs/xfs/libxfs/xfs_bmap.c        |   46 ++-
 fs/xfs/libxfs/xfs_format.h      |    3 
 fs/xfs/libxfs/xfs_rtbitmap.c    |  199 ++++++++-------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  147 ++++++-----
 fs/xfs/libxfs/xfs_rtgroup.c     |  484 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h     |  274 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |   13 +
 fs/xfs/libxfs/xfs_trans_resv.c  |    2 
 fs/xfs/libxfs/xfs_types.h       |    8 +
 fs/xfs/scrub/bmap.c             |   13 +
 fs/xfs/scrub/common.c           |   78 ++++++
 fs/xfs/scrub/common.h           |   30 ++
 fs/xfs/scrub/fscounters.c       |   25 +-
 fs/xfs/scrub/repair.c           |   24 ++
 fs/xfs/scrub/repair.h           |    7 +
 fs/xfs/scrub/rtbitmap.c         |   54 ++--
 fs/xfs/scrub/rtsummary.c        |  111 ++++----
 fs/xfs/scrub/rtsummary_repair.c |    7 -
 fs/xfs/scrub/scrub.c            |   33 ++
 fs/xfs/scrub/scrub.h            |   13 +
 fs/xfs/xfs_bmap_util.c          |    3 
 fs/xfs/xfs_buf_item_recover.c   |   25 ++
 fs/xfs/xfs_discard.c            |  100 +++++---
 fs/xfs/xfs_fsmap.c              |  329 ++++++++++++++-----------
 fs/xfs/xfs_fsmap.h              |   15 +
 fs/xfs/xfs_inode.c              |    3 
 fs/xfs/xfs_inode.h              |   13 -
 fs/xfs/xfs_iomap.c              |    4 
 fs/xfs/xfs_mount.c              |   15 +
 fs/xfs/xfs_mount.h              |   26 +-
 fs/xfs/xfs_qm.c                 |   27 ++
 fs/xfs/xfs_rtalloc.c            |  520 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_super.c              |    3 
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   74 ++++--
 36 files changed, 2020 insertions(+), 710 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h

