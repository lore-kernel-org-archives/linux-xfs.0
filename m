Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7249313E19
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971023; cv=none; b=fX5A4Q6gk3NdmXt4LJwakyjLMh1ILGYNNFccy4ce7PvxktSarvfo6JJ9Q/2c1497mREEHf3IkjpcDC6wAmrMjw3eWx8noRRP88FC7NSIn8SKSFiXb5YL6BJ1YrwjwfjB0abLiUcq0hh7gbooorJd7nuZZMP9vf1OhwYVqqBa3Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971023; c=relaxed/simple;
	bh=yhBvDBqj0ixQMXilcmvVE9Rgn/w7r+Jby62n7Wftszo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l64h2Pw9baOnCjvc721NKMl09Y0DZClKg2FFdpX2UUUXeeesexqWESCW2NuoYNsEUXmcUelYc9LNXUy3diGKRjElSeiusTmRDmLFKWSa18pG0shjwcotjnN8nlBc41/hEVwtZoshL6IbkhvLBAXaUAtXra+ZIh3UwxhrZMfHkxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPzmczkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPzmczkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78F6C4CEF1
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 15:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971023;
	bh=yhBvDBqj0ixQMXilcmvVE9Rgn/w7r+Jby62n7Wftszo=;
	h=Date:From:To:Subject:From;
	b=iPzmczkDkWkH4SH34MVx805oKmQPlxHZ/F0A57lUUtZyBWFCE3QdYJBY/FLRy4/vL
	 q2UAcnef7vUwC+406lxqIuc/uGtrSnxCRaJCAQUky5U9aXsI1LaIF+ExPr+4XEpjPR
	 02deVBDQ/yl1xTOYSVtPh9Blne19lF+ztyZV1MXPN3o/Z4Sal8B1cDOmlD4soAtmWX
	 lU7C7ZtlTfHBnoV9nc1lkPUbXjRTo40VfumwVwknWyz7P2E07wZoo6sh74s8AlpJ50
	 8YSVjllrwcMefhyRgj5J88m4IktTz5P/OpiCYA0x31GVZ2mMaJ/53787Qafrg+Ts9g
	 fD58HmsIogJJQ==
Date: Fri, 9 Jan 2026 16:03:37 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to ea44380376cc
Message-ID: <aWEYhUztCe4kW3tE@nidhogg.toxiclabs.cc>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

ea44380376cc Merge branch 'xfs-6.19-fixes' into for-next

9 new commits:

Carlos Maiolino (1):
      [ea44380376cc] Merge branch 'xfs-6.19-fixes' into for-next

Christoph Hellwig (6):
      [24bb56d025e3] xfs: rename xfs_linux.h to xfs_platform.h
      [c21d7553f835] xfs: include global headers first in xfs_platform.h
      [e382d25fea02] xfs: move the remaining content from xfs.h to xfs_platform.h
      [d6e7819ce63f] xfs: directly include xfs_platform.h
      [ac6d78b0277b] xfs: use bio_reuse in the zone GC code
      [07e59f94f4d2] xfs: rework zone GC buffer management

Dan Carpenter (1):
      [8dad31f85c7b] xfs: fix memory leak in xfs_growfs_check_rtgeom()

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.c                 |   2 +-
 fs/xfs/libxfs/xfs_ag_resv.c            |   2 +-
 fs/xfs/libxfs/xfs_alloc.c              |   2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c        |   2 +-
 fs/xfs/libxfs/xfs_attr.c               |   2 +-
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
 fs/xfs/libxfs/xfs_rtrefcount_btree.c   |   2 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c       |   2 +-
 fs/xfs/libxfs/xfs_sb.c                 |   2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c     |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c        |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c         |   2 +-
 fs/xfs/libxfs/xfs_trans_space.c        |   2 +-
 fs/xfs/libxfs/xfs_types.c              |   2 +-
 fs/xfs/libxfs/xfs_zones.c              |   2 +-
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
 fs/xfs/scrub/btree.c                   |   2 +-
 fs/xfs/scrub/common.c                  |   2 +-
 fs/xfs/scrub/cow_repair.c              |   2 +-
 fs/xfs/scrub/dabtree.c                 |   2 +-
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
 fs/xfs/xfs.h                           |  28 --------
 fs/xfs/xfs_acl.c                       |   2 +-
 fs/xfs/xfs_aops.c                      |   2 +-
 fs/xfs/xfs_attr_inactive.c             |   2 +-
 fs/xfs/xfs_attr_item.c                 |   2 +-
 fs/xfs/xfs_attr_list.c                 |   2 +-
 fs/xfs/xfs_bio_io.c                    |   2 +-
 fs/xfs/xfs_bmap_item.c                 |   2 +-
 fs/xfs/xfs_bmap_util.c                 |   2 +-
 fs/xfs/xfs_buf.c                       |   2 +-
 fs/xfs/xfs_buf_item.c                  |   2 +-
 fs/xfs/xfs_buf_item_recover.c          |   2 +-
 fs/xfs/xfs_buf_mem.c                   |   2 +-
 fs/xfs/xfs_dahash_test.c               |   2 +-
 fs/xfs/xfs_dir2_readdir.c              |   2 +-
 fs/xfs/xfs_discard.c                   |   2 +-
 fs/xfs/xfs_dquot.c                     |   2 +-
 fs/xfs/xfs_dquot_item.c                |   2 +-
 fs/xfs/xfs_dquot_item_recover.c        |   2 +-
 fs/xfs/xfs_drain.c                     |   2 +-
 fs/xfs/xfs_error.c                     |   2 +-
 fs/xfs/xfs_exchmaps_item.c             |   2 +-
 fs/xfs/xfs_exchrange.c                 |   2 +-
 fs/xfs/xfs_export.c                    |   2 +-
 fs/xfs/xfs_extent_busy.c               |   2 +-
 fs/xfs/xfs_extfree_item.c              |   2 +-
 fs/xfs/xfs_file.c                      |   2 +-
 fs/xfs/xfs_filestream.c                |   2 +-
 fs/xfs/xfs_fsmap.c                     |   2 +-
 fs/xfs/xfs_fsops.c                     |   2 +-
 fs/xfs/xfs_globals.c                   |   2 +-
 fs/xfs/xfs_handle.c                    |   2 +-
 fs/xfs/xfs_health.c                    |   2 +-
 fs/xfs/xfs_hooks.c                     |   2 +-
 fs/xfs/xfs_icache.c                    |   2 +-
 fs/xfs/xfs_icreate_item.c              |   2 +-
 fs/xfs/xfs_inode.c                     |   2 +-
 fs/xfs/xfs_inode_item.c                |   2 +-
 fs/xfs/xfs_inode_item_recover.c        |   2 +-
 fs/xfs/xfs_ioctl.c                     |   2 +-
 fs/xfs/xfs_ioctl32.c                   |   2 +-
 fs/xfs/xfs_iomap.c                     |   2 +-
 fs/xfs/xfs_iops.c                      |   2 +-
 fs/xfs/xfs_itable.c                    |   2 +-
 fs/xfs/xfs_iunlink_item.c              |   2 +-
 fs/xfs/xfs_iwalk.c                     |   2 +-
 fs/xfs/xfs_log.c                       |   2 +-
 fs/xfs/xfs_log_cil.c                   |   2 +-
 fs/xfs/xfs_log_recover.c               |   2 +-
 fs/xfs/xfs_message.c                   |   2 +-
 fs/xfs/xfs_mount.c                     |   2 +-
 fs/xfs/xfs_mru_cache.c                 |   2 +-
 fs/xfs/xfs_notify_failure.c            |   2 +-
 fs/xfs/{xfs_linux.h => xfs_platform.h} |  46 ++++++++-----
 fs/xfs/xfs_pnfs.c                      |   2 +-
 fs/xfs/xfs_pwork.c                     |   2 +-
 fs/xfs/xfs_qm.c                        |   2 +-
 fs/xfs/xfs_qm_bhv.c                    |   2 +-
 fs/xfs/xfs_qm_syscalls.c               |   2 +-
 fs/xfs/xfs_quotaops.c                  |   2 +-
 fs/xfs/xfs_refcount_item.c             |   2 +-
 fs/xfs/xfs_reflink.c                   |   2 +-
 fs/xfs/xfs_rmap_item.c                 |   2 +-
 fs/xfs/xfs_rtalloc.c                   |   4 +-
 fs/xfs/xfs_stats.c                     |   2 +-
 fs/xfs/xfs_super.c                     |   2 +-
 fs/xfs/xfs_symlink.c                   |   2 +-
 fs/xfs/xfs_sysctl.c                    |   2 +-
 fs/xfs/xfs_sysfs.c                     |   2 +-
 fs/xfs/xfs_trace.c                     |   2 +-
 fs/xfs/xfs_trans.c                     |   2 +-
 fs/xfs/xfs_trans_ail.c                 |   2 +-
 fs/xfs/xfs_trans_buf.c                 |   2 +-
 fs/xfs/xfs_trans_dquot.c               |   2 +-
 fs/xfs/xfs_xattr.c                     |   2 +-
 fs/xfs/xfs_zone_alloc.c                |   2 +-
 fs/xfs/xfs_zone_gc.c                   | 115 +++++++++++++++++----------------
 fs/xfs/xfs_zone_info.c                 |   2 +-
 fs/xfs/xfs_zone_space_resv.c           |   2 +-
 195 files changed, 283 insertions(+), 292 deletions(-)
 delete mode 100644 fs/xfs/xfs.h
 rename fs/xfs/{xfs_linux.h => xfs_platform.h} (95%)
