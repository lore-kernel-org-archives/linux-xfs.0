Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E76217911
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190816; cv=none; b=WWwbWTdIGTiRuASxQ4zxVYrR8cR4OZ8QozmmJvaNs61idY6dncK4CYCbatQbPTX+Wr+w+pG0wYgG2JOqIPViFM/RLXFShLBtvPZ3LkQNqFUoP7CTMkxbg1UCugH1IR1Xa2qDIZHq0oMdSmuZQHiiPAZOi9mh08MDV+9iHC0iuqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190816; c=relaxed/simple;
	bh=yKuhsm9uh0HdELtZnhXT1rqJqp2ssSvxILQ0m9aQZPA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hEZsl1PjiIZZ7HZ/7YV29JID0he5+IDcT1CqWgqxDPSBSPAOcXPSlaGWFpPcXCSpuI8I9oSJpQUybBz/YfjjNdNcRtc5JbnMzqSF1UNsLT7rKdc+NjdW7Yr0qNYb1ukkb2QXy1xOA96zoYFw/nnQpyHjcSxv00Yb8C66P0F/2+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDyNnpYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDyNnpYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2335AC4CEC3;
	Thu, 17 Oct 2024 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190816;
	bh=yKuhsm9uh0HdELtZnhXT1rqJqp2ssSvxILQ0m9aQZPA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aDyNnpYNnjJmsoamPGPqqsDEz9Z4t8wAHnMOq5txB0M3oWqVCwIRtdYlOuNTEXukI
	 NuZokgtmWs3JpEvPIq5JRntxrEwZ4/LFuSMWb/OdKSR+iiJdnTCTaqB8gtA1bTY4vv
	 QJJY8vw2A9UltuX5RP5lZepUrEdA0xpcEhekD3eMyjaxlW2q2otx1sSoTBcJfvFN1c
	 FEClxDHklUhjucX1vic/dTT77wLfnDXOYq5ugq35ClYqKSE3h7tvvvjfaJhlw8hOF3
	 TOeZRoxOPDZPX5dUyJBBqvgEIippQURgfK21XUyJXkQ9ZB7AZY6XMOTIP7Q/NL71+f
	 f7G+kX0UYmGDw==
Date: Thu, 17 Oct 2024 11:46:55 -0700
Subject: [PATCHSET v5.1 4/9] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>
References: <20241017184009.GV21853@frogsfrogsfrogs>
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

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=incore-rtgroups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=incore-rtgroups
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
 fs/xfs/xfs_rtalloc.c            |  518 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_super.c              |    3 
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   74 ++++--
 36 files changed, 2018 insertions(+), 710 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h

