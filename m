Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810A91E47AD
	for <linux-xfs@vger.kernel.org>; Thu, 24 Jul 2025 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753373182; cv=none; b=LhKFCDIJ5wu2msyiJ4v+3TCAAWb/CA3RPimNTdWei0YjH0SVOoBlKGensWO03tDHXcY2YiPUQXgjqwdAXjjt9WJ7St438RV7Yt9m/zvRweIrWwyq4qr8RIVxq2D2WiImY/VLKRRR3v50AK9vHIxFZ+MGzPSSyLHwktlQ+OQXzPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753373182; c=relaxed/simple;
	bh=2cF96SLVSUXRyXepeuRlgGJ+ZtB3+DSvBerNtetlnno=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CUMfQLAph8kct42n/+QLowVr3qUxDX6l4O4O6pLCi5zonsddhkP2YKBmuZku+Wcnp7Z4gCLoMeoyTjYhONn9Smi+WNAw1UaDCshGJJaBJgZ4yC20I8/NgC4mbDH0cwVZ/hEnueuNNgE66LWXGlYeN5Y7WHlY1H6y++igs5cqdbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D63uEpDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D63uEpDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A57C4CEED
	for <linux-xfs@vger.kernel.org>; Thu, 24 Jul 2025 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753373182;
	bh=2cF96SLVSUXRyXepeuRlgGJ+ZtB3+DSvBerNtetlnno=;
	h=Date:From:To:Subject:From;
	b=D63uEpDGi1VtFcjexcc+vo5i7NKb8y5jNHhaxdoBGo+1hAtJYqgXALf8l/i0vWisA
	 waSfmuf8a5uFzn9QgdnsDyNyux7fvPRT6KyVeTtJwLnPbcu6Ym7mUxh7b25cK76KLZ
	 fHJywefeuTnMgjNCOYQZgzCxKV91di9soneMYjT/tL0EvncuBjQivxBOdGJNQSN7At
	 6zVRCF+AFH42Z5EhLDGmT4Vu6PONIya68Se8OG+rFGICErbrFBTy7VxO5t3qvhKrcW
	 LeMR9N9PCpefY9QhjKEOFZWL0WYEoaSaZ1Q2xUcfgwCLPkwa7Og6dIF5YFpYApAG9l
	 0sAU38XafBB4A==
Date: Thu, 24 Jul 2025 18:06:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to ded74fddcaf6
Message-ID: <lcujirwpx7gp4xwxqyt6k3e2wt3zxicprpmaymo2lakhv56prx@w2n2x5j5erav>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been REBASED Against v6.16-rc7

This contains no new patches, but cleans up the tree for the merge window,
removing unneeded merge commits and fixing dependencies.


The new head of the for-next branch is commit:

ded74fddcaf6 xfs: don't use a xfs_log_iovec for ri_buf in log recovery

The 44 commits below are those staged for the merge window:

Alan Huang (1):
      [8c10b04f9fc1] xfs: Remove unused label in xfs_dax_notify_dev_failure

Christoph Hellwig (19):
      [736b576d4d98] xfs: use xfs_trans_reserve_more in xfs_trans_reserve_more_inode
      [f1cc16e1547e] xfs: don't use xfs_trans_reserve in xfs_trans_reserve_more
      [83a80e95e797] xfs: decouple xfs_trans_alloc_empty from xfs_trans_alloc
      [60538b0b54b3] xfs: don't use xfs_trans_reserve in xfs_trans_roll
      [d8e1ea43e5a3] xfs: return the allocated transaction from xfs_trans_alloc_empty
      [92176e32464c] xfs: return the allocated transaction from xchk_trans_alloc_empty
      [e4a1df35be5d] xfs: remove xrep_trans_{alloc,cancel}_hook_dummy
      [ff67c13dc8f0] xfs: remove the xlog_ticket_t typedef
      [59655147ec34] xfs: improve the xg_active_ref check in xfs_group_free
      [90b1bda80ece] xfs: use a uint32_t to cache i_used_blocks in xfs_init_zone
      [329b996d9210] xfs: rename oz_write_pointer to oz_allocated
      [86e6ddf1d0ba] xfs: stop passing an inode to the zone space reservation helpers
      [7cbbfd27a929] xfs: improve the comments in xfs_max_open_zones
      [60e02f956d77] xfs: improve the comments in xfs_select_zone_nowait
      [469342210afe] xfs: don't pass the old lv to xfs_cil_prepare_item
      [01774798c271] xfs: cleanup the ordered item logic in xlog_cil_insert_format_items
      [e870cbe6fa7c] xfs: use better names for size members in xfs_log_vec
      [8bf931f99e84] xfs: don't use a xfs_log_iovec for attr_item names and values
      [ded74fddcaf6] xfs: don't use a xfs_log_iovec for ri_buf in log recovery

Fedor Pchelkin (6):
      [edce172444b4] xfs: rename diff_two_keys routines
      [82b63ee16001] xfs: rename key_diff routines
      [3b583adf55c6] xfs: refactor cmp_two_keys routines to take advantage of cmp_int()
      [734b871d6cf7] xfs: refactor cmp_key_with_cur routines to take advantage of cmp_int()
      [2717eb351855] xfs: use a proper variable name and type for storing a comparison result
      [ce6cce46aff7] xfs: refactor xfs_btree_diff_two_ptrs() to take advantage of cmp_int()

Pranav Tyagi (1):
      [f4a3f01e8e45] fs/xfs: replace strncpy with memtostr_pad()

Steven Rostedt (17):
      [091e9451d0bd] xfs: remove unused trace event xfs_attr_remove_iter_return
      [32177ab8ba5f] xfs: remove unused event xlog_iclog_want_sync
      [6f7080bd932f] xfs: remove unused event xfs_ioctl_clone
      [8c54845c3a02] xfs: remove unused xfs_reflink_compare_extents events
      [b3b5015d3454] xfs: remove unused trace event xfs_attr_rmtval_set
      [b54480c3b10d] xfs: remove unused xfs_attr events
      [ea26bbc7795b] xfs: remove unused event xfs_attr_node_removename
      [237f8e885136] xfs: remove unused event xfs_alloc_near_error
      [f1100605590a] xfs: remove unused event xfs_alloc_near_nominleft
      [88fd451594a6] xfs: remove unused event xfs_pagecache_inval
      [9a8a536fe5a8] xfs: remove usused xfs_end_io_direct events
      [31b98ef2403f] xfs: only create event xfs_file_compat_ioctl when CONFIG_COMPAT is configure
      [e0a05579b2b6] xfs: change xfs_xattr_class from a TRACE_EVENT() to DECLARE_EVENT_CLASS()
      [b9adb86b9045] xfs: remove unused trace event xfs_dqreclaim_dirty
      [3c4052cb9f7e] xfs: remove unused trace event xfs_log_cil_return
      [2b74404188b5] xfs: remove unused trace event xfs_discard_rtrelax
      [75fe259ff7f6] xfs: remove unused trace event xfs_reflink_cow_enospc

Code Diffstat:

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
