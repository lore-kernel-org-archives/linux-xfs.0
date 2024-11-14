Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E0CCA4E
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 00:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543516; cv=none; b=la+cm9IvFGF2sX4eWKv21FhLI6dWjaBU82AMYNFBUw6HqtxjW2FA4EyJ/LiXfXnbLJUAaTy1fennMsbTvrz9ZAnmrxtgJQk3to82BeRGT98XPoqqtVRj4rtfntUrEAnermLmxQTkv62H3PO9KGse53gaY9Y+I1XGgK3tyUB816c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543516; c=relaxed/simple;
	bh=I3QMv15sYprCljNXuOfgpd0DOd4VgFB6VWGyzBYAzoA=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=qojYLKMS/bf3bNKEyrw7+IxvltR9uckhrGwfng1YyTI3QFmZWP/5aai/ygXO3W52RDXhyCXL2+VqPl8z2Di/s19FeOWfKdN17vQX18FtJJ6uobfUKKkCLxXHqzUo+BbrgKEGKIFyFG7tHIyAeU6XmjJD1IRjgb+E+k4KA+Pu3WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ji+lLofc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ji+lLofc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E016C4CEC3;
	Thu, 14 Nov 2024 00:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731543516;
	bh=I3QMv15sYprCljNXuOfgpd0DOd4VgFB6VWGyzBYAzoA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ji+lLofcxqpNslSX+qfJeuZ14uA/NjrNKoX1Dh4uZCAW3VcwIQvh9X3ON/F3ts+Qg
	 Xl9ciIuzRkye89uKxKxYm7dZM/MhiVLhQ56USLYrRfUMOpn0vSS23rBupcMmsmlL5U
	 z5X9g7DphzcNpOXcpAag/T+aoFkswir5HPzMZQxxLTmNGia89xluGE+EVo86jTm/yC
	 C6YPcHg9ARrQxePAinhkACZe1kNiU6HZYuHckiELurvFWlcK60c6tx4AGSRmdwgOp8
	 ZM9Vv2Wfcc2AoiddywTFlFh4mTiNbd6wvudSuKtiVm6rlprt0EMgiftmFjd42vHvPk
	 EEnXXEllqFuEA==
Date: Wed, 13 Nov 2024 16:18:35 -0800
Subject: [GIT PULL 04/10] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173154342189.1140548.3591824391884884112.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241114001637.GL9438@frogsfrogsfrogs>
References: <20241114001637.GL9438@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfs for 6.13-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ffc12626fd0ee4fc7c5f1c91d33b452e6d757acd:

xfs: repair metadata directory file path connectivity (2024-11-13 16:05:28 -0800)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/incore-rtgroups-6.13_2024-11-13

for you to fetch changes up to dd2a92877987e615f5b62f872ee0d4f992362994:

xfs: make RT extent numbers relative to the rtgroup (2024-11-13 16:05:31 -0800)

----------------------------------------------------------------
xfs: create incore rt allocation groups [v5.6 04/10]

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

