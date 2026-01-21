Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1905A3A9DB2
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768998367; cv=none; b=Qr3qi1Ewep9NZRd01PPRiWhhRkQhj/MItTN7fWuBKOWOWUZCPLonxB4Cwxqf2ju5bi4W+uzHnrxVus5GFEB9sTGfC9OlVGbCOLy6U3RalPLHDFnF/em/LE1oayc6WsTB49y1xkjZLfPC3adLlrin1+foDYkzuSl/0NG7jTHXSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768998367; c=relaxed/simple;
	bh=l8h4loCgZ5LR5Rv8WjxgN71LCXubdeZqI9ED7aJCBaw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sUJS9YilnF6KN8cKj53QvD8NQxXd//xhQPikCgwNByEzMTkkHEEWdkLnyaJJ68/+mptF+qIehZNbt5R4dRGpEwmFD15GxsqILaDDnMv3rd7KxIwqP2zFUaUZ2ahvEs7FdAOVXT1CQ6nytAx4tKMTfmfvPLHa0j274gJ/qGtMD2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YeVFYDih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YeVFYDih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED54C19424
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768998366;
	bh=l8h4loCgZ5LR5Rv8WjxgN71LCXubdeZqI9ED7aJCBaw=;
	h=Date:From:To:Subject:From;
	b=YeVFYDihWwnTi9xY3wVeeFHubKVVRlM/cWfXVMlDPyqygPzVfWiJLYbdbhhhUS4P1
	 viQRyC4BKGbUR3C6b3v4tsGjEaeFJ3gzAYqQRXm5EUzOfUsr9UReoX6NrOK0/E9YCK
	 /8H6QAGLLfiISy0z7v2a79I+f0ulUv5Z82EzA+rMFwGs5zq7aZhqKhEGj3mcwK+veX
	 x/PK8quT7ey2lyLR8qQbkwouqTeBjIAQzprjPpghy6uleddHSkczGPOC0R/4gqJptH
	 JBZi7+aKLgWY/HW12LhIGx5Ixh+9YPsXxYLMJSq60I/1nEOAp9s/QQkH2L5qHb0c40
	 WqT9dNGEetgfg==
Date: Wed, 21 Jan 2026 13:26:03 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to a1ca658d649a
Message-ID: <aXDDSJYaHwfiN0L4@nidhogg.toxiclabs.cc>
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

has just been *REBASED*.

A series already there needed to be updated, so, just rebase it on top
of latest -rc. Statistics below refers to all patches queued up, not
only *new* patches.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

a1ca658d649a xfs: fix incorrect context handling in xfs_trans_roll

28 new commits:

Christoph Hellwig (22):
      [2d4521e4c00c] xfs: add a xlog_write_one_vec helper
      [c53fbeedbe90] xfs: set lv_bytes in xlog_write_one_vec
      [8e7625344321] xfs: improve the ->iop_format interface
      [027410591418] xfs: move struct xfs_log_iovec to xfs_log_priv.h
      [2499d9118014] xfs: move struct xfs_log_vec to xfs_log_priv.h
      [a82d7aac7581] xfs: regularize iclog space accounting in xlog_write_partial
      [a3eb1f9cf85f] xfs: improve the calling convention for the xlog_write helpers
      [865970d49a45] xfs: add a xlog_write_space_left helper
      [e2663443da71] xfs: improve the iclog space assert in xlog_write_iovec
      [a10b44cf1018] xfs: factor out a xlog_write_space_advance helper
      [971ffb634113] xfs: rename xfs_linux.h to xfs_platform.h
      [501a5161d2c3] xfs: include global headers first in xfs_platform.h
      [19a46f124669] xfs: move the remaining content from xfs.h to xfs_platform.h
      [cf9b52fa7d65] xfs: directly include xfs_platform.h
      [0506d32f7c52] xfs: use bio_reuse in the zone GC code
      [102f444b57b3] xfs: rework zone GC buffer management
      [3a65ea768b80] xfs: remove xfs_attr_leaf_hasname
      [fc633b5c5b80] xfs: add a xfs_rtgroup_raw_size helper
      [776b76f7547f] xfs: pass the write pointer to xfs_init_zone
      [19c5b6051ed6] xfs: split and refactor zone validation
      [b37c1e4e9af7] xfs: check that used blocks are smaller than the write pointer
      [12d12dcc1508] xfs: use blkdev_get_zone_info to simplify zone reporting

Damien Le Moal (1):
      [41263267ef26] xfs: add missing forward declaration in xfs_zones.h

Darrick J. Wong (2):
      [f39854a3fb2f] xfs: mark data structures corrupt on EIO and ENODATA
      [4d6d335ea955] xfs: promote metadata directories and large block support

Hans Holmberg (1):
      [01a28961549a] xfs: always allocate the free zone with the lowest index

Wenwu Hou (1):
      [a1ca658d649a] xfs: fix incorrect context handling in xfs_trans_roll

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c                 |   2 +-
 fs/xfs/libxfs/xfs_ag_resv.c            |   2 +-
 fs/xfs/libxfs/xfs_alloc.c              |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c        |   2 +-
 fs/xfs/libxfs/xfs_attr.c               |  77 +++------
 fs/xfs/libxfs/xfs_attr_leaf.c          |   2 +-
 fs/xfs/libxfs/xfs_attr_remote.c        |   2 +-
 fs/xfs/libxfs/xfs_bit.c                |   2 +-
 fs/xfs/libxfs/xfs_bmap.c               |   2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c         |   2 +-
 fs/xfs/libxfs/xfs_btree.c              |   2 +-
 fs/xfs/libxfs/xfs_btree_mem.c          |   2 +-
 fs/xfs/libxfs/xfs_btree_staging.c      |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c           |   2 +-
 fs/xfs/libxfs/xfs_defer.c              |   2 +-
 fs/xfs/libxfs/xfs_dir2.c               |   2 +-
 fs/xfs/libxfs/xfs_dir2_block.c         |   2 +-
 fs/xfs/libxfs/xfs_dir2_data.c          |   2 +-
 fs/xfs/libxfs/xfs_dir2_leaf.c          |   2 +-
 fs/xfs/libxfs/xfs_dir2_node.c          |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c            |   2 +-
 fs/xfs/libxfs/xfs_dquot_buf.c          |   2 +-
 fs/xfs/libxfs/xfs_exchmaps.c           |   2 +-
 fs/xfs/libxfs/xfs_group.c              |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c             |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c       |   2 +-
 fs/xfs/libxfs/xfs_iext_tree.c          |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c          |   2 +-
 fs/xfs/libxfs/xfs_inode_fork.c         |   2 +-
 fs/xfs/libxfs/xfs_inode_util.c         |   2 +-
 fs/xfs/libxfs/xfs_log_format.h         |   7 -
 fs/xfs/libxfs/xfs_log_rlimit.c         |   2 +-
 fs/xfs/libxfs/xfs_metadir.c            |   2 +-
 fs/xfs/libxfs/xfs_metafile.c           |   2 +-
 fs/xfs/libxfs/xfs_parent.c             |   2 +-
 fs/xfs/libxfs/xfs_refcount.c           |   2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c     |   2 +-
 fs/xfs/libxfs/xfs_rmap.c               |   2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c         |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c           |   2 +-
 fs/xfs/libxfs/xfs_rtgroup.c            |   2 +-
 fs/xfs/libxfs/xfs_rtgroup.h            |  15 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c       |   2 +-
 fs/xfs/libxfs/xfs_sb.c                 |   2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c     |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c        |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c         |   2 +-
 fs/xfs/libxfs/xfs_trans_space.c        |   2 +-
 fs/xfs/libxfs/xfs_types.c              |   2 +-
 fs/xfs/libxfs/xfs_zones.c              | 151 +++++------------
 fs/xfs/libxfs/xfs_zones.h              |   6 +-
 fs/xfs/scrub/agb_bitmap.c              |   2 +-
 fs/xfs/scrub/agheader.c                |   2 +-
 fs/xfs/scrub/agheader_repair.c         |   2 +-
 fs/xfs/scrub/alloc.c                   |   2 +-
 fs/xfs/scrub/alloc_repair.c            |   2 +-
 fs/xfs/scrub/attr.c                    |   2 +-
 fs/xfs/scrub/attr_repair.c             |   2 +-
 fs/xfs/scrub/bitmap.c                  |   2 +-
 fs/xfs/scrub/bmap.c                    |   2 +-
 fs/xfs/scrub/bmap_repair.c             |   2 +-
 fs/xfs/scrub/btree.c                   |   4 +-
 fs/xfs/scrub/common.c                  |   6 +-
 fs/xfs/scrub/cow_repair.c              |   2 +-
 fs/xfs/scrub/dabtree.c                 |   4 +-
 fs/xfs/scrub/dir.c                     |   2 +-
 fs/xfs/scrub/dir_repair.c              |   2 +-
 fs/xfs/scrub/dirtree.c                 |   2 +-
 fs/xfs/scrub/dirtree_repair.c          |   2 +-
 fs/xfs/scrub/dqiterate.c               |   2 +-
 fs/xfs/scrub/findparent.c              |   2 +-
 fs/xfs/scrub/fscounters.c              |   2 +-
 fs/xfs/scrub/fscounters_repair.c       |   2 +-
 fs/xfs/scrub/health.c                  |   2 +-
 fs/xfs/scrub/ialloc.c                  |   2 +-
 fs/xfs/scrub/ialloc_repair.c           |   2 +-
 fs/xfs/scrub/inode.c                   |   2 +-
 fs/xfs/scrub/inode_repair.c            |   2 +-
 fs/xfs/scrub/iscan.c                   |   2 +-
 fs/xfs/scrub/listxattr.c               |   2 +-
 fs/xfs/scrub/metapath.c                |   2 +-
 fs/xfs/scrub/newbt.c                   |   2 +-
 fs/xfs/scrub/nlinks.c                  |   2 +-
 fs/xfs/scrub/nlinks_repair.c           |   2 +-
 fs/xfs/scrub/orphanage.c               |   2 +-
 fs/xfs/scrub/parent.c                  |   2 +-
 fs/xfs/scrub/parent_repair.c           |   2 +-
 fs/xfs/scrub/quota.c                   |   2 +-
 fs/xfs/scrub/quota_repair.c            |   2 +-
 fs/xfs/scrub/quotacheck.c              |   2 +-
 fs/xfs/scrub/quotacheck_repair.c       |   2 +-
 fs/xfs/scrub/rcbag.c                   |   2 +-
 fs/xfs/scrub/rcbag_btree.c             |   2 +-
 fs/xfs/scrub/readdir.c                 |   2 +-
 fs/xfs/scrub/reap.c                    |   2 +-
 fs/xfs/scrub/refcount.c                |   2 +-
 fs/xfs/scrub/refcount_repair.c         |   2 +-
 fs/xfs/scrub/repair.c                  |   2 +-
 fs/xfs/scrub/rgsuper.c                 |   2 +-
 fs/xfs/scrub/rmap.c                    |   2 +-
 fs/xfs/scrub/rmap_repair.c             |   2 +-
 fs/xfs/scrub/rtbitmap.c                |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c         |   2 +-
 fs/xfs/scrub/rtrefcount.c              |   2 +-
 fs/xfs/scrub/rtrefcount_repair.c       |   2 +-
 fs/xfs/scrub/rtrmap.c                  |   2 +-
 fs/xfs/scrub/rtrmap_repair.c           |   2 +-
 fs/xfs/scrub/rtsummary.c               |   2 +-
 fs/xfs/scrub/rtsummary_repair.c        |   2 +-
 fs/xfs/scrub/scrub.c                   |   2 +-
 fs/xfs/scrub/stats.c                   |   2 +-
 fs/xfs/scrub/symlink.c                 |   2 +-
 fs/xfs/scrub/symlink_repair.c          |   2 +-
 fs/xfs/scrub/tempfile.c                |   2 +-
 fs/xfs/scrub/trace.c                   |   2 +-
 fs/xfs/scrub/xfarray.c                 |   2 +-
 fs/xfs/scrub/xfblob.c                  |   2 +-
 fs/xfs/scrub/xfile.c                   |   2 +-
 fs/xfs/xfs.h                           |  28 ----
 fs/xfs/xfs_acl.c                       |   2 +-
 fs/xfs/xfs_aops.c                      |   2 +-
 fs/xfs/xfs_attr_inactive.c             |   2 +-
 fs/xfs/xfs_attr_item.c                 |  29 ++--
 fs/xfs/xfs_attr_list.c                 |   2 +-
 fs/xfs/xfs_bio_io.c                    |   2 +-
 fs/xfs/xfs_bmap_item.c                 |  12 +-
 fs/xfs/xfs_bmap_util.c                 |   2 +-
 fs/xfs/xfs_buf.c                       |   2 +-
 fs/xfs/xfs_buf_item.c                  |  21 +--
 fs/xfs/xfs_buf_item_recover.c          |   2 +-
 fs/xfs/xfs_buf_mem.c                   |   2 +-
 fs/xfs/xfs_dahash_test.c               |   2 +-
 fs/xfs/xfs_dir2_readdir.c              |   2 +-
 fs/xfs/xfs_discard.c                   |   2 +-
 fs/xfs/xfs_dquot.c                     |   2 +-
 fs/xfs/xfs_dquot_item.c                |  11 +-
 fs/xfs/xfs_dquot_item_recover.c        |   2 +-
 fs/xfs/xfs_drain.c                     |   2 +-
 fs/xfs/xfs_error.c                     |   2 +-
 fs/xfs/xfs_exchmaps_item.c             |  13 +-
 fs/xfs/xfs_exchrange.c                 |   2 +-
 fs/xfs/xfs_export.c                    |   2 +-
 fs/xfs/xfs_extent_busy.c               |   2 +-
 fs/xfs/xfs_extfree_item.c              |  12 +-
 fs/xfs/xfs_file.c                      |   2 +-
 fs/xfs/xfs_filestream.c                |   2 +-
 fs/xfs/xfs_fsmap.c                     |   2 +-
 fs/xfs/xfs_fsops.c                     |   2 +-
 fs/xfs/xfs_globals.c                   |   2 +-
 fs/xfs/xfs_handle.c                    |   2 +-
 fs/xfs/xfs_health.c                    |   2 +-
 fs/xfs/xfs_hooks.c                     |   2 +-
 fs/xfs/xfs_icache.c                    |   2 +-
 fs/xfs/xfs_icreate_item.c              |   8 +-
 fs/xfs/xfs_inode.c                     |   2 +-
 fs/xfs/xfs_inode_item.c                |  51 +++---
 fs/xfs/xfs_inode_item_recover.c        |   2 +-
 fs/xfs/xfs_ioctl.c                     |   2 +-
 fs/xfs/xfs_ioctl32.c                   |   2 +-
 fs/xfs/xfs_iomap.c                     |   2 +-
 fs/xfs/xfs_iops.c                      |   2 +-
 fs/xfs/xfs_itable.c                    |   2 +-
 fs/xfs/xfs_iunlink_item.c              |   2 +-
 fs/xfs/xfs_iwalk.c                     |   2 +-
 fs/xfs/xfs_log.c                       | 294 +++++++++++++--------------------
 fs/xfs/xfs_log.h                       |  65 ++------
 fs/xfs/xfs_log_cil.c                   | 113 +++++++++++--
 fs/xfs/xfs_log_priv.h                  |  20 +++
 fs/xfs/xfs_log_recover.c               |   2 +-
 fs/xfs/xfs_message.c                   |  10 +-
 fs/xfs/xfs_message.h                   |   2 -
 fs/xfs/xfs_mount.c                     |   2 +-
 fs/xfs/xfs_mru_cache.c                 |   2 +-
 fs/xfs/xfs_notify_failure.c            |   2 +-
 fs/xfs/{xfs_linux.h => xfs_platform.h} |  46 ++++--
 fs/xfs/xfs_pnfs.c                      |   2 +-
 fs/xfs/xfs_pwork.c                     |   2 +-
 fs/xfs/xfs_qm.c                        |   2 +-
 fs/xfs/xfs_qm_bhv.c                    |   2 +-
 fs/xfs/xfs_qm_syscalls.c               |   2 +-
 fs/xfs/xfs_quotaops.c                  |   2 +-
 fs/xfs/xfs_refcount_item.c             |  12 +-
 fs/xfs/xfs_reflink.c                   |   2 +-
 fs/xfs/xfs_rmap_item.c                 |  12 +-
 fs/xfs/xfs_rtalloc.c                   |   2 +-
 fs/xfs/xfs_stats.c                     |   2 +-
 fs/xfs/xfs_super.c                     |   6 +-
 fs/xfs/xfs_symlink.c                   |   2 +-
 fs/xfs/xfs_sysctl.c                    |   2 +-
 fs/xfs/xfs_sysfs.c                     |   2 +-
 fs/xfs/xfs_trace.c                     |   2 +-
 fs/xfs/xfs_trans.c                     |  10 +-
 fs/xfs/xfs_trans.h                     |  13 +-
 fs/xfs/xfs_trans_ail.c                 |   2 +-
 fs/xfs/xfs_trans_buf.c                 |   2 +-
 fs/xfs/xfs_trans_dquot.c               |   2 +-
 fs/xfs/xfs_xattr.c                     |   2 +-
 fs/xfs/xfs_zone_alloc.c                | 220 ++++++++++++------------
 fs/xfs/xfs_zone_gc.c                   | 115 +++++++------
 fs/xfs/xfs_zone_info.c                 |   2 +-
 fs/xfs/xfs_zone_priv.h                 |   1 -
 fs/xfs/xfs_zone_space_resv.c           |   2 +-
 203 files changed, 806 insertions(+), 930 deletions(-)
 delete mode 100644 fs/xfs/xfs.h
 rename fs/xfs/{xfs_linux.h => xfs_platform.h} (95%)


