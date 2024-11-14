Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77AB1EB9ED
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 06:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731565617; cv=none; b=JPrsLzWJ30h3SJFQYrwB/jlQMkOURMLa0pUxOgN+9PKaoS0PQV+i7Be3dWBNAm+ghv1KB4aJly6YVNNuOfXL3UqGVW8QrmeYaL5iU5J995xdS+q6+NpOLv1jHvdmM5GpHYqKkZZCnpjGbSg9NWBoZSx9RoRinGH4dL1YNgRENWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731565617; c=relaxed/simple;
	bh=hZyA9fqcouvSWkUk4+Jt7iDQPaph1JCfZMR9Wqsx7tg=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=Rn+kBtJ/0CPViecgezJoZUC16UBpLSN7TEQJ0hZZoCWnlu5F84ULMgqRYMkaSqwLNpwiMGV/d8LWAojXFRJ5h/BI+Ir7dqPEcurrmrhnjoqo3Wz8b/1DdByFSRVsOLptqNW3f8AX8U2GIOWX/cH+uoNTEfoc1aiZW0ZMpsNONVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr4kAgsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr4kAgsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8513C4CECF;
	Thu, 14 Nov 2024 06:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731565617;
	bh=hZyA9fqcouvSWkUk4+Jt7iDQPaph1JCfZMR9Wqsx7tg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Sr4kAgsx0Bxo/2kTq8XTGfo2LzL5ZyLkbbqcK5MqOB6X7LGAmOU3R0ubQIVXXh+PJ
	 jqqUJskkhJCYkdjEBErOt0c4WcmpXbZI7p0iSPBdN8eE0aBhTRCBnbFbMhJOC0kmGF
	 RvmtSg6z2vxk9vu6cDZX/2pGFaTts8jknZZMvBbgwQrMGGBJbh0ENoTgubfFR9HExM
	 eS19Dx7HiTlXvKRw607WvHV2JuofxeFVzWTuWEdY8xd7KbaL704mjq2t/x+gQKsumX
	 0raNYyPs79OdxKm3WyeQ/uQQBi9I3vqf17Eyz04QAXRcOU4AstQCzyWFJ7BXTFbcXV
	 x4vd34MYIUqbQ==
Date: Wed, 13 Nov 2024 22:26:57 -0800
Subject: [GIT PULL 04/10] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173156551369.1445256.1153892087503510304.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114062447.GO9438@frogsfrogsfrogs>
References: <20241114062447.GO9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 16aa1e01ed77ca881dad0cffdeac1d33e3015d87:

xfs: repair metadata directory file path connectivity (2024-11-13 22:17:01 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/incore-rtgroups-6.13_2024-11-13

for you to fetch changes up to 9d64db093d7b4974d24af34aa3fa85a394195292:

xfs: make RT extent numbers relative to the rtgroup (2024-11-13 22:17:05 -0800)

----------------------------------------------------------------
xfs: create incore rt allocation groups [v5.7 04/10]

Add in-memory data structures for sharding the realtime volume into
independent allocation groups.  For existing filesystems, the entire rt
volume is modelled as having a single large group, with (potentially) a
number of rt extents exceeding 2^32 blocks, though these are not likely
to exist because the codebase has been a bit broken for decades.  The
next series fills in the ondisk format and other supporting structures.

With a bit of luck, this should all go splendidly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Christoph Hellwig (15):
xfs: clean up xfs_getfsmap_helper arguments
xfs: add a xfs_bmap_free_rtblocks helper
xfs: add a xfs_qm_unmount_rt helper
xfs: factor out a xfs_growfs_rt_alloc_blocks helper
xfs: cleanup xfs_getfsmap_rtdev_rtbitmap
xfs: split xfs_trim_rtdev_extents
xfs: move RT bitmap and summary information to the rtgroup
xfs: support creating per-RTG files in growfs
xfs: calculate RT bitmap and summary blocks based on sb_rextents
xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
xfs: factor out a xfs_growfs_check_rtgeom helper
xfs: refactor xfs_rtbitmap_blockcount
xfs: refactor xfs_rtsummary_blockcount
xfs: make RT extent numbers relative to the rtgroup

Darrick J. Wong (6):
xfs: create incore realtime group structures
xfs: define locking primitives for realtime groups
xfs: add a lockdep class key for rtgroup inodes
xfs: support caching rtgroup metadata inodes
xfs: add rtgroup-based realtime scrubbing context management
xfs: remove XFS_ILOCK_RT*

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

