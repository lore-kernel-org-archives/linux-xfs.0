Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E075517E006
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371080; cv=none; b=ndhU52DnDnGIe69hCFM8ZYjSarg2+63AxhfjrHn36scqKyRpN6IP52zQFQA+drzvyRaO6n+3MjIj/R0sQ18uVdFykYaD34JoetZmJxPyBpP74bnHTPu/7HMwSn7UN6Tj9szGQcJFCboiPgBYgRug7r/6NDBdDUBkkL8I2LBf0uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371080; c=relaxed/simple;
	bh=kvA3AOLH0DLmiDi5jvyn8lTDuj5CQyxFjeLYM+KEek8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nLpChT5lAgGGUvvetqyBfwoIRQ7rez0vI17oGgHjVk3KKn61KCky/DBRVN+Md9A+ZpJgDaJExuLwKiEqgCn9Ik9tVzYjXDls/PAqpSm/JjJDm2esh9K66Et0YMoPPFSU65+H+Ou3wtoc62ol5O2ZJWGEAUOHo2zE2tCTHBB9+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDQcVlCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDQcVlCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18A7C32782;
	Thu, 22 Aug 2024 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371079;
	bh=kvA3AOLH0DLmiDi5jvyn8lTDuj5CQyxFjeLYM+KEek8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gDQcVlCdwiSwlE+to9RPs2RQmhLL2uhttwKEIINmHjZ9YjFU2GzjKEXXryVrgSkCj
	 zdWy/0zucXTnCSqsyqny2StCQRDpxXX4mu0xjlSQ3Q6nT7TbvmcEUCEkXkdluYfNvJ
	 HAigKgGAEBCokXSPBLs8Y8lH8qSQ7f7Yd4mKVk9jqV9sgjnYkMbXm2MpNTOmM3NFMK
	 lyfQ2MTX1QHpCeAKeYEqcJ7lkawVtr8Q9d5IbnYNXZj3W1RJQTx8nJ193QsJkO8Xop
	 xAVKgSJXxPHi91wldBfJLEVzHVw86Xc6QhmwVbo3g89tDOpicF9bz94gdZrcE+arWz
	 Jqn+yVcYVTFbw==
Date: Thu, 22 Aug 2024 16:57:59 -0700
Subject: [PATCHSET v4.0 07/10] xfs: create incore rt allocation groups
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
In-Reply-To: <20240822235230.GJ6043@frogsfrogsfrogs>
References: <20240822235230.GJ6043@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series adds in-memory data structures for sharding the realtime volume
into independent allocation groups.  For existing filesystems, the entire rt
volume is modelled as having a single large group, with (potentially) a number
of rt extents exceeding 2^32, though these are not likely to exist because the
codebase has been a bit broken for decades.  The next series fills in the
ondisk format and other supporting structures.

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
 * xfs: clean up the ISVALID macro in xfs_bmap_adjacent
 * xfs: factor out a xfs_rtallocate helper
 * xfs: rework the rtalloc fallback handling
 * xfs: factor out a xfs_rtallocate_align helper
 * xfs: make the rtalloc start hint a xfs_rtblock_t
 * xfs: add xchk_setup_nothing and xchk_nothing helpers
 * xfs: remove xfs_{rtbitmap,rtsummary}_wordcount
 * xfs: replace m_rsumsize with m_rsumblocks
 * xfs: rearrange xfs_fsmap.c a little bit
 * xfs: move xfs_ioc_getfsmap out of xfs_ioctl.c
 * xfs: create incore realtime group structures
 * xfs: define locking primitives for realtime groups
 * xfs: add a lockdep class key for rtgroup inodes
 * xfs: support caching rtgroup metadata inodes
 * xfs: add rtgroup-based realtime scrubbing context management
 * xfs: move RT bitmap and summary information to the rtgroup
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
 fs/xfs/libxfs/xfs_bmap.c        |  101 +++--
 fs/xfs/libxfs/xfs_format.h      |    3 
 fs/xfs/libxfs/xfs_rtbitmap.c    |  222 +++++------
 fs/xfs/libxfs/xfs_rtbitmap.h    |  152 ++++----
 fs/xfs/libxfs/xfs_rtgroup.c     |  529 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h     |  268 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    7 
 fs/xfs/libxfs/xfs_trans_resv.c  |    4 
 fs/xfs/libxfs/xfs_types.h       |    4 
 fs/xfs/scrub/bmap.c             |   13 +
 fs/xfs/scrub/common.c           |   78 ++++
 fs/xfs/scrub/common.h           |   59 ++-
 fs/xfs/scrub/fscounters.c       |   26 +
 fs/xfs/scrub/repair.c           |   24 +
 fs/xfs/scrub/repair.h           |    7 
 fs/xfs/scrub/rtbitmap.c         |   54 ++-
 fs/xfs/scrub/rtsummary.c        |  118 +++---
 fs/xfs/scrub/rtsummary.h        |    2 
 fs/xfs/scrub/rtsummary_repair.c |   19 -
 fs/xfs/scrub/scrub.c            |   33 ++
 fs/xfs/scrub/scrub.h            |   42 +-
 fs/xfs/xfs_discard.c            |  100 +++--
 fs/xfs/xfs_fsmap.c              |  435 +++++++++++++++--------
 fs/xfs/xfs_fsmap.h              |    6 
 fs/xfs/xfs_inode.c              |    3 
 fs/xfs/xfs_inode.h              |   13 -
 fs/xfs/xfs_ioctl.c              |  130 -------
 fs/xfs/xfs_iomap.c              |    4 
 fs/xfs/xfs_log_recover.c        |   20 +
 fs/xfs/xfs_mount.c              |   18 +
 fs/xfs/xfs_mount.h              |   29 +-
 fs/xfs/xfs_qm.c                 |   27 +
 fs/xfs/xfs_rtalloc.c            |  753 ++++++++++++++++++++++++---------------
 fs/xfs/xfs_super.c              |    4 
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   38 ++
 37 files changed, 2326 insertions(+), 1021 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h

