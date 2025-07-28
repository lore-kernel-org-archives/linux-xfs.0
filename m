Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834049478
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 08:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753691711; cv=none; b=H630nNLObabv7tOp8YeH0oSXYL6/lTNIZqgF2AofWZxNNf4ISzUUV3Q7KjrglgnZxbhm+gWSfN83lw2nD1jZ0KkgilgctmII2iWJXXXm5N555gRyBMiljtvRSi9aU49xeZm7WKZx4tyhu5YFCKxesfzbVsccm66l+LP25bxDasQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753691711; c=relaxed/simple;
	bh=hKQGLphvuIDgOiGsGg3T0PD/a+6dpCr8ZNU3x6oKkTI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WhT4D3zgAAtRGoNwk2HiF/LPRJp+xXjeHKaxqfZm2GJF15y7byGJ0AT0qr6Qf4qzXIT9CBc3aS/gWRWCdW6XbjQ9syMbO2dOjLbIm2dLS2ylH1jbCmctfHo/gsud++vjcZjwd3Xg1nghwSibXhNHiA7bc8ShnG9pqGBo7s0uu1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZov1Scr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZov1Scr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4140EC4CEE7;
	Mon, 28 Jul 2025 08:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753691711;
	bh=hKQGLphvuIDgOiGsGg3T0PD/a+6dpCr8ZNU3x6oKkTI=;
	h=Date:From:To:Cc:Subject:From;
	b=EZov1ScrxJLgMNN8HsFUZtCsVK/ccSW4qUc9TYWC/WFW33YpMlm/PElXPXA9k+iJU
	 ExQm0QBQaZpLPe8mO+maU/s2GyvUv0BPBENwvk17vBhSXyWnDbUak9Yua0Xa6YPBUi
	 jWmWz2ni8YRkZiM/4htUBP79tpieFaRb0LvHigsT950+LE0BMof3LhMeRWeZUP8zYJ
	 cKxZgoyL5AnlSX4US0YYLAqPjTWXRKLyPh/KlnTsAUEmwM8KvFF2EONhwUoDutjLDC
	 u+PWqKSmLfB1fQFUr2mkBZNumKRtkBAnr0szHsUuGPBKvX3db94YouAMBl+FMKZDSf
	 oP68KooBIhLvA==
Date: Mon, 28 Jul 2025 10:35:07 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS new code for 6.17
Message-ID: <sueusz4drzu3yag3w6psq4ewym2a3xowzkz6mafeommuf7swwy@dx77kbi5uldo>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT (v6.16) has been successful.

This series doesn't contain any new features. It mostly is a
collection of clean ups and code refactoring that I preferred to
postpone to the merge window.

It includes removal of several unused tracepoints, refactoring key
comparing routines under the B-Trees management and cleanup of xfs
journaling code.

Thanks,
Carlos

The following changes since commit 89be9a83ccf1f88522317ce02f854f30d6115c41:

  Linux 6.16-rc7 (2025-07-20 15:18:33 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.17

for you to fetch changes up to ded74fddcaf685a9440c5612f7831d0c4c1473ca:

  xfs: don't use a xfs_log_iovec for ri_buf in log recovery (2025-07-24 17:30:15 +0200)

----------------------------------------------------------------
xfs: New code for 6.17

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Alan Huang (1):
      xfs: Remove unused label in xfs_dax_notify_dev_failure

Christoph Hellwig (19):
      xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
      xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
      xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
      xfs: don't use xfs_trans_reserve in xfs_trans_roll
      xfs: return the allocated transaction from xfs_trans_alloc_empty
      xfs: return the allocated transaction from xchk_trans_alloc_empty
      xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
      xfs: remove the xlog_ticket_t typedef
      xfs: improve the xg_active_ref check in xfs_group_free
      xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
      xfs: rename oz_write_pointer to oz_allocated
      xfs: stop passing an inode to the zone space reservation helpers
      xfs: improve the comments in xfs_max_open_zones
      xfs: improve the comments in xfs_select_zone_nowait
      xfs: don't pass the old lv to xfs_cil_prepare_item
      xfs: cleanup the ordered item logic in xlog_cil_insert_format_items
      xfs: use better names for size members in xfs_log_vec
      xfs: don't use a xfs_log_iovec for attr_item names and values
      xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Fedor Pchelkin (6):
      xfs: rename diff_two_keys routines
      xfs: rename key_diff routines
      xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      xfs: use a proper variable name and type for storing a comparison result
      xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

Pranav Tyagi (1):
      fs/xfs: replace strncpy with memtostr_pad()

Steven Rostedt (17):
      xfs: remove unused trace event xfs_attr_remove_iter_return
      xfs: remove unused event xlog_iclog_want_sync
      xfs: remove unused event xfs_ioctl_clone
      xfs: remove unused xfs_reflink_compare_extents events
      xfs: remove unused trace event xfs_attr_rmtval_set
      xfs: remove unused xfs_attr events
      xfs: remove unused event xfs_attr_node_removename
      xfs: remove unused event xfs_alloc_near_error
      xfs: remove unused event xfs_alloc_near_nominleft
      xfs: remove unused event xfs_pagecache_inval
      xfs: remove usused xfs_end_io_direct events
      xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
      xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()
      xfs: remove unused trace event xfs_dqreclaim_dirty
      xfs: remove unused trace event xfs_log_cil_return
      xfs: remove unused trace event xfs_discard_rtrelax
      xfs: remove unused trace event xfs_reflink_cow_enospc

 fs/xfs/libxfs/xfs_alloc_btree.c      |  52 ++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c       |  32 ++----
 fs/xfs/libxfs/xfs_btree.c            |  33 +++---
 fs/xfs/libxfs/xfs_btree.h            |  41 +++----
 fs/xfs/libxfs/xfs_format.h           |   2 +-
 fs/xfs/libxfs/xfs_group.c            |   3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     |  24 ++--
 fs/xfs/libxfs/xfs_log_recover.h      |   4 +-
 fs/xfs/libxfs/xfs_refcount.c         |   4 +-
 fs/xfs/libxfs/xfs_refcount_btree.c   |  18 +--
 fs/xfs/libxfs/xfs_rmap_btree.c       |  67 ++++--------
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  18 +--
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |  67 ++++--------
 fs/xfs/scrub/btree.c                 |   2 +-
 fs/xfs/scrub/common.c                |   7 +-
 fs/xfs/scrub/common.h                |   2 +-
 fs/xfs/scrub/dir_repair.c            |   8 +-
 fs/xfs/scrub/fscounters.c            |   3 +-
 fs/xfs/scrub/metapath.c              |   4 +-
 fs/xfs/scrub/nlinks.c                |   8 +-
 fs/xfs/scrub/nlinks_repair.c         |   4 +-
 fs/xfs/scrub/parent_repair.c         |  12 +-
 fs/xfs/scrub/quotacheck.c            |   4 +-
 fs/xfs/scrub/rcbag_btree.c           |  38 ++-----
 fs/xfs/scrub/repair.c                |  36 ------
 fs/xfs/scrub/repair.h                |   4 -
 fs/xfs/scrub/rmap_repair.c           |  14 +--
 fs/xfs/scrub/rtrmap_repair.c         |  14 +--
 fs/xfs/scrub/scrub.c                 |   5 +-
 fs/xfs/scrub/trace.h                 |   2 +-
 fs/xfs/xfs_attr_item.c               | 148 ++++++++++++-------------
 fs/xfs/xfs_attr_item.h               |   8 +-
 fs/xfs/xfs_bmap_item.c               |  18 +--
 fs/xfs/xfs_buf_item.c                |   8 +-
 fs/xfs/xfs_buf_item.h                |   2 +-
 fs/xfs/xfs_buf_item_recover.c        |  38 +++----
 fs/xfs/xfs_discard.c                 |  12 +-
 fs/xfs/xfs_dquot_item_recover.c      |  20 ++--
 fs/xfs/xfs_exchmaps_item.c           |   8 +-
 fs/xfs/xfs_extfree_item.c            |  59 +++++-----
 fs/xfs/xfs_file.c                    |  24 ++--
 fs/xfs/xfs_fsmap.c                   |   4 +-
 fs/xfs/xfs_icache.c                  |   5 +-
 fs/xfs/xfs_icreate_item.c            |   2 +-
 fs/xfs/xfs_inode.c                   |   7 +-
 fs/xfs/xfs_inode_item.c              |   6 +-
 fs/xfs/xfs_inode_item.h              |   4 +-
 fs/xfs/xfs_inode_item_recover.c      |  26 ++---
 fs/xfs/xfs_ioctl.c                   |   3 +-
 fs/xfs/xfs_iops.c                    |   4 +-
 fs/xfs/xfs_itable.c                  |  18 +--
 fs/xfs/xfs_iwalk.c                   |  11 +-
 fs/xfs/xfs_log.c                     |  16 +--
 fs/xfs/xfs_log.h                     |  16 +--
 fs/xfs/xfs_log_cil.c                 |  71 ++++++------
 fs/xfs/xfs_log_priv.h                |   4 +-
 fs/xfs/xfs_log_recover.c             |  16 +--
 fs/xfs/xfs_notify_failure.c          |   6 +-
 fs/xfs/xfs_qm.c                      |  10 +-
 fs/xfs/xfs_refcount_item.c           |  34 +++---
 fs/xfs/xfs_rmap_item.c               |  34 +++---
 fs/xfs/xfs_rtalloc.c                 |  13 +--
 fs/xfs/xfs_trace.h                   |  80 +-------------
 fs/xfs/xfs_trans.c                   | 207 ++++++++++++++++-------------------
 fs/xfs/xfs_trans.h                   |   4 +-
 fs/xfs/xfs_zone_alloc.c              |  45 ++++----
 fs/xfs/xfs_zone_alloc.h              |   4 +-
 fs/xfs/xfs_zone_gc.c                 |  18 ++-
 fs/xfs/xfs_zone_info.c               |   2 +-
 fs/xfs/xfs_zone_priv.h               |  16 +--
 fs/xfs/xfs_zone_space_resv.c         |  17 +--
 71 files changed, 636 insertions(+), 944 deletions(-)

