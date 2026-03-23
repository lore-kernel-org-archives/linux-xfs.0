Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFB030596F
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 18:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774291262; cv=none; b=ngbgRDWckhkdXtYLbZVHxt+JQ5eiB3hJESxetBGUTc79yWJa7UiQqntA4BvCbvkruT6mZj47yl1ql5zH1mucE95H7g7/Sdh0aYwDQI2UMAQ+dTsdqQshonZb04eTIlFHfoiu4da203ZNbTqpi9ywaI0mSS8YmgkmfdggdydHTm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774291262; c=relaxed/simple;
	bh=jX+U7O5wZ05c8Y2G35qy9Hjn7oROgHNQ05cYKAMUzK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5F7o45M1pbfeXPP5OUI4Jd1bAuGN8tRzKGXG4pap+eIUaaBKRKzq1XE6JrZu4WLceNhQ4QpcDUgQZqsx549B1S8DLkMJW/L2AWslPCIbM+swKa+jmXuwwTkhnIsdLBGmLpOl0DjVO7r0czkZ/1pJ3IRqe/0U6xV5aEnJVhueq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEvt3dit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEvt3dit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1ACBC4CEF7;
	Mon, 23 Mar 2026 18:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774291261;
	bh=jX+U7O5wZ05c8Y2G35qy9Hjn7oROgHNQ05cYKAMUzK8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PEvt3dit6laineCxwQDrOTLRjCCED38nej4vbw5x9WHuXh9hTsz/g1krslWQ4w+Mr
	 gr8SUpXMfOstzijYFYPihxom+Thf+78z5SdADAL/HAz2eu3mA3CxxaBsioLCD5AfIw
	 c89Dl0vJkiLhPWmF3OAakaRAyH+Vrjs918+W3gdE8w85LgifmvcbkQS55Z208EwuqZ
	 mkHs+ANESwhsW0+bFQqqazflyiVDHmQT8By76Hm0+6PTvCpg9ZSL4R5ddXB8esP/y9
	 PeRfeEzWC0p99cfNWY9+UJIEeHvAcD1Rw1kk/+ruEtYCP1HJ9AeUq1SWuRi+1slTOJ
	 2bhKEDFHWAjwA==
Date: Mon, 23 Mar 2026 11:41:01 -0700
Subject: [PATCHSET 2/2] xfsprogs: new libxfs code from kernel 7.0
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: kees@kernel.org, hch@lst.de, cem@kernel.org, cmaiolino@redhat.com,
 mark.tinguely@oracle.com, nirjhar.roy.lists@gmail.com,
 wilfred.mallawa@wdc.com, dlemoal@kernel.org, shinsj4653@gmail.com,
 torvalds@linux-foundation.org, hongao@uniontech.com,
 souptick.joarder@hpe.com, linux-xfs@vger.kernel.org, hans.holmberg@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177429120538.2266274.13630957356122775655.stgit@frogsfrogsfrogs>
In-Reply-To: <20260323183941.GJ6223@frogsfrogsfrogs>
References: <20260323183941.GJ6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This series ports kernel libxfs code to userspace from 7.0-rc5.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-7.0-sync
---
Commits in this patchset:
 * libxfs: fix XFS_STATS_DEC
 * libxfs: port various kernel apis from 7.0
 * libfrog: hoist some utilities from libxfs
 * libfrog: fix missing gettext call in current_fixed_time
 * xfs: start creating infrastructure for health monitoring
 * xfs: create event queuing, formatting, and discovery infrastructure
 * xfs: convey filesystem unmount events to the health monitor
 * xfs: convey metadata health events to the health monitor
 * xfs: convey filesystem shutdown events to the health monitor
 * xfs: convey externally discovered fsdax media errors to the health monitor
 * xfs: convey file I/O errors to the health monitor
 * xfs: check if an open file is on the health monitored fs
 * xfs: add media verification ioctl
 * xfs: move struct xfs_log_iovec to xfs_log_priv.h
 * xfs: directly include xfs_platform.h
 * xfs: remove xfs_attr_leaf_hasname
 * xfs: add missing forward declaration in xfs_zones.h
 * xfs: add a xfs_rtgroup_raw_size helper
 * xfs: split and refactor zone validation
 * xfs: delete attr leaf freemap entries when empty
 * xfs: fix freemap adjustments when adding xattrs to leaf blocks
 * xfs: refactor attr3 leaf table size computation
 * xfs: strengthen attr leaf block freemap checking
 * xfs: reduce xfs_attr_try_sf_addname parameters
 * xfs: speed up parent pointer operations when possible
 * xfs: add a method to replace shortform attrs
 * xfs: fix spacing style issues in xfs_alloc.c
 * xfs: don't validate error tags in the I/O path
 * xfs: add zone reset error injection
 * xfs: give the defer_relog stat a xs_ prefix
 * treewide: Replace kmalloc with kmalloc_obj for non-scalar types
 * Convert 'alloc_obj' family to use the new default GFP_KERNEL argument
 * xfs: Refactoring the nagcount and delta calculation
 * xfs: fix code alignment issues in xfs_ondisk.c
 * xfs: remove metafile inodes from the active inode stat
 * xfs: Add a comment in xfs_log_sb()
 * xfs: remove duplicate static size checks
 * xfs: add static size checks for ioctl UABI
 * xfs: Remove redundant NULL check after __GFP_NOFAIL
 * xfs: fix returned valued from xfs_defer_can_append
---
 include/kmem.h                |   50 ++++++++++
 include/libxfs.h              |    7 -
 include/platform_defs.h       |    8 ++
 include/xfs_fs_compat.h       |    8 --
 include/xfs_trace.h           |    1 
 libfrog/util.h                |   21 ++++
 libxfs/libxfs_api_defs.h      |    2 
 libxfs/xfs_ag.h               |    3 +
 libxfs/xfs_attr.h             |    6 +
 libxfs/xfs_attr_leaf.h        |    1 
 libxfs/xfs_da_format.h        |    2 
 libxfs/xfs_errortag.h         |    8 +-
 libxfs/xfs_fs.h               |  189 +++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_health.h           |    5 +
 libxfs/xfs_log_format.h       |    7 -
 libxfs/xfs_ondisk.h           |   52 +++++++----
 libxfs/xfs_platform.h         |   25 +----
 libxfs/xfs_rtgroup.h          |   15 +++
 libxfs/xfs_zones.h            |    6 +
 libfrog/Makefile              |    4 +
 libfrog/util.c                |  166 +++++++++++++++++++++++++++++++++++
 libxfs/Makefile               |    4 -
 libxfs/buf_mem.c              |    2 
 libxfs/cache.c                |    2 
 libxfs/defer_item.c           |    2 
 libxfs/init.c                 |    2 
 libxfs/inode.c                |    2 
 libxfs/iunlink.c              |    2 
 libxfs/kmem.c                 |    2 
 libxfs/logitem.c              |    2 
 libxfs/rdwr.c                 |    2 
 libxfs/topology.c             |    2 
 libxfs/trans.c                |    2 
 libxfs/util.c                 |  162 ----------------------------------
 libxfs/xfblob.c               |    2 
 libxfs/xfile.c                |    2 
 libxfs/xfs_ag.c               |   32 ++++++-
 libxfs/xfs_ag_resv.c          |    2 
 libxfs/xfs_alloc.c            |   10 +-
 libxfs/xfs_alloc_btree.c      |    2 
 libxfs/xfs_attr.c             |  191 +++++++++++++++++++++++++++-------------
 libxfs/xfs_attr_leaf.c        |  197 ++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_attr_remote.c      |    2 
 libxfs/xfs_bit.c              |    2 
 libxfs/xfs_bmap.c             |    2 
 libxfs/xfs_bmap_btree.c       |    2 
 libxfs/xfs_btree.c            |    2 
 libxfs/xfs_btree_mem.c        |    2 
 libxfs/xfs_btree_staging.c    |    2 
 libxfs/xfs_da_btree.c         |   10 +-
 libxfs/xfs_defer.c            |    8 +-
 libxfs/xfs_dir2.c             |   21 ++--
 libxfs/xfs_dir2_block.c       |    2 
 libxfs/xfs_dir2_data.c        |    2 
 libxfs/xfs_dir2_leaf.c        |    2 
 libxfs/xfs_dir2_node.c        |    2 
 libxfs/xfs_dir2_sf.c          |    2 
 libxfs/xfs_dquot_buf.c        |    2 
 libxfs/xfs_exchmaps.c         |    2 
 libxfs/xfs_group.c            |    2 
 libxfs/xfs_ialloc.c           |    2 
 libxfs/xfs_ialloc_btree.c     |    2 
 libxfs/xfs_iext_tree.c        |    2 
 libxfs/xfs_inode_buf.c        |    6 +
 libxfs/xfs_inode_fork.c       |    2 
 libxfs/xfs_inode_util.c       |    2 
 libxfs/xfs_log_rlimit.c       |    2 
 libxfs/xfs_metadir.c          |    2 
 libxfs/xfs_metafile.c         |    7 +
 libxfs/xfs_parent.c           |   16 ++-
 libxfs/xfs_refcount.c         |    6 +
 libxfs/xfs_refcount_btree.c   |    2 
 libxfs/xfs_rmap.c             |    2 
 libxfs/xfs_rmap_btree.c       |    2 
 libxfs/xfs_rtbitmap.c         |    2 
 libxfs/xfs_rtgroup.c          |    4 -
 libxfs/xfs_rtrefcount_btree.c |    2 
 libxfs/xfs_rtrmap_btree.c     |    2 
 libxfs/xfs_sb.c               |    5 +
 libxfs/xfs_symlink_remote.c   |    2 
 libxfs/xfs_trans_inode.c      |    2 
 libxfs/xfs_trans_resv.c       |    2 
 libxfs/xfs_trans_space.c      |    2 
 libxfs/xfs_types.c            |    2 
 libxfs/xfs_zones.c            |  151 ++++++++-----------------------
 libxlog/xfs_log_recover.c     |    4 -
 repair/zoned.c                |    7 +
 87 files changed, 990 insertions(+), 533 deletions(-)
 rename libxfs/{libxfs_priv.h => xfs_platform.h} (96%)

