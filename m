Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8EC3AA4EB
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 06:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762455; cv=none; b=qWAjW1BnQe3Gw6g9Yx8uoPbCchvBJhVmSNo/GJO7gD2KQB4wvCllHcAVNgcyU5dRcT9ipZi+r+1PUHSME+TMxoZs9BPfSkWnjgtn+zu8h/+BsAGxUnR5uZbkXmHcsMPtW2Z1Te+HBDtAok3HD3PshlO8hLOCRPOeln8xr3nNbG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762455; c=relaxed/simple;
	bh=gIT+K9HuRQNjsA4oY08Ny3g74mH/J2+pfJdkyCY1WVY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IjqAZDXXJgn8wwvHTX35VhkNiDzGJ53iKSjHlibXEDdBNqs0otRFmLtMFH4bVevIu1cFQfcVD/cY7DOsiPeKVYnfHxj/6hQcVSagqsh4U10rirahn1gj4hPj9poXweoXFZv/L4MyOot4q4umcZkcMWvwU9vYeNCtm9ukNG7+3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ez1H7f5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ez1H7f5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C031F00A3A
	for <linux-xfs@vger.kernel.org>; Mon,  7 Sep 2026 06:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788762452;
	bh=Fe8S7oehZ30ChltdLZI8UAPShSEzSPJAgdTzVdye8E4=;
	h=Date:From:To:Subject;
	b=Ez1H7f5IfvbgYQld3XL4/bTeBVKtLcAfaaJL/AdjSO1430xYhMSPdCnpRa9DXAxlN
	 rI79uNvsziO9lRTxuR6hSa0sbwurHCMNCHe4NMGPBbcCTOKlasDooHIesunOrsBRfF
	 9OoO5+DkH1Tfwem9vld+BrrbpgdRCsGu8f3OyV/zcTjVtWmN0uThf8KnU42VUYHePb
	 4QTFK535RKwMPTPyeykMbrwFI3W8lVgeipu+Q0wLP7PIFTjP++udYQT+CmqRB3mW8n
	 LZgLfL8RCXrPGOQAPNkXQX0dEkegSrYRevLN1FxI/IIbyICWj9jR+cprOyjNaSM/hJ
	 LGbfWA5J2B5Wg==
Date: Mon, 7 Sep 2026 08:27:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 0ca15a1a1151
Message-ID: <ap5YR7itg1MNWW3A@andromeda.toxiclabs.cc>
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

	gitolite.kernel.org:/pub/scm/fs/xfs/xfs-linux.git

has just been ** REBASED **.

As I mentioned previously, I was planning to rebase for-next on the top
of a proper -rc tag. So this rebase includes all the previously patches
already queued plus a few extra ones. Unless anything urgent comes by,
this will be the update to -rc3.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

0ca15a1a1151 xfs: remove an extra cast in xfs_file_compat_ioctl

72 new commits:

Anuj Gupta (1):
      [48d2b8351bae] xfs: release alleged child inode on metapath unlink error

Christoph Hellwig (24):
      [cf3a01684f32] xfs: fix the lock annotation on xfs_iget_cache_hit
      [2078c2d6e174] xfs: fix the lock annotation in xfs_extent_busy_update_extent
      [b2ae7f243583] xfs: fix the lock annotation in xfs_mru_cache_lookup
      [64e1f211d97b] xfs: improve lock annotations in the log code
      [912a5b8e344a] xfs: add lock annotations to xfs_try_open_zone
      [2d1b21fcc9f9] xfs: add lock annotations to xlog_state_shutdown_callbacks
      [166089a85685] xfs: add a lock annotation to xlog_cil_push_background
      [ed4abd8617ba] xfs: add lock annotations to xfs_ail_delete*
      [23f5ea3d0d03] xfs: remove an outdated comment above xfs_file_ioctl
      [35bd2ae47386] xfs: rename xfs_ioc_swapext to xfs_swapext
      [b076be93abb3] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [2e9b75546a69] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [22c47b7c7ec6] xfs: split out the handler for XFS_IOC_DIOINFO
      [84ca1a3a8e18] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [d3beb063f248] xfs: split out the handler for XFS_IOC_SWAPEXT
      [0a9eb67598d9] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [aea4db0cf773] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [9696940fd2e3] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [14a51eff8194] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [af5e40c5cdc7] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [d99d2af5b515] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [a9a1dc9eaf2a] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [31256907674f] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [0ca15a1a1151] xfs: remove an extra cast in xfs_file_compat_ioctl

Darrick J. Wong (37):
      [f789d291bbda] xfs: fix media verification ioctl for internal rt volumes
      [9f84792b40d0] xfs: don't spin forever on zero-length dirents when salvaging them
      [865b751e7503] xfs: don't stash removename operations with unknown ftype
      [ed799148e0d6] xfs: log the tempip after we convert it to extents format
      [cdc4a083adf7] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
      [9dd6cc92a736] xfs: handle reconnecting metadir subdirectories
      [7538ba528cfd] xfs: lock the healthmon when inserting unmount event
      [05cff7c2b79f] xfs: fix unit conversions in per_binval computation
      [eacb84795077] xfs: fix short ifork reaping computation in xreap_bmapi_binval
      [72d0a3e4405c] xfs: fix name string recording in slowpath pptr tracepoints
      [2eac8d01d2c7] xfs: don't leak dqacct if rhashtable insertion fails
      [aa301322f72f] xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
      [022d5f5fce7f] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
      [5287e56cba3b] xfs: preserve owner on in-memory btree creation
      [f1930bc57809] xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
      [b71ae66863e4] xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
      [365fe37e10ea] xfs: don't modify file attributes or poke fsnotify for dry runs
      [c83d1ef97ee3] xfs: fix bnobt repair space reservation disposal failure
      [58a0c7578b25] xfs: always set xfs_healthmon::first_event when inserting at front of list
      [10b1d5fd7189] xfs: move healthmon event merge tracepoint
      [9097f5c03f03] xfs: port healthmon event list to list_head
      [4c98464e12fc] xfs: merge healthmon insert/push helpers
      [74eeb68a628d] xfs: check healthmon outbuffer space correctly
      [295f2cfd3e2c] xfs: bump lost_prev_errors if we lose even the healthmon lost event
      [014c1aff607a] xfs: report nonexistent parents as a filesystem corruption
      [1a441c6842da] xfs: destroy seen inode bitmap when we fail to add a dirpath
      [8c71ad4d4f3e] xfs: signal inode btree xref error if get_rec returns an error
      [0fc67528f54b] xfs: truncate quota file correctly when repairing quota file
      [de20f7014917] xfs: compute dquot checksum after resetting dd_lsn in repair
      [d7f97be48cbe] xfs: fix backwards skipping logic in xrep_quota_block
      [e8b01aaafffe] xfs: fix backwards mergeability logic in refcount scrubber
      [79ab1af2034b] xfs: cross-reference the rtgroup superblock extent, not block
      [c3085f6c7cca] xfs: use the rtgroup extent count to find rtrefcount gaps
      [0d43368844a7] xfs: strengthen the "is cow staging" helpers in scrub
      [3f9fd694fa42] xfs: fix rtrefcount btree block counting in scrub
      [6b760b3232b3] xfs: make the rtsummary repair fix the file size too
      [4d0624679ae2] xfs: count escaped corruption errors in scrub stats

Eric Sandeen (2):
      [4164b1e3d728] xfs: fix reclaimed page accounting in xfs_buf_free
      [5344402f2c65] xfs: mark slab-allocated xfs_buf backing memory as __GFP_RECLAIMABLE

Hans Holmberg (1):
      [ff99a5f6cbcc] xfs: prevent race in zoned space reservations

Javier Tia (6):
      [6176d21d7bd6] xfs: initialise error in xfs_defer_finish_one()
      [91c15cee394e] xfs: give the deferred barrier op type a name
      [d058f24b163a] xfs: report the error that made deferred work shut down the fs
      [6c0fc3cb4e87] xfs: correct the parent pointer space reservation comment
      [8e4ebb6afaa3] xfs: initialise args->total for parent pointer updates
      [0fe77e57588b] xfs: assert the reservation covers each da fork growth

Lin Jiapeng (1):
      [a23eca88448e] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Code Diffstat:

 fs/xfs/libxfs/xfs_btree_mem.c        |   2 +
 fs/xfs/libxfs/xfs_btree_staging.c    |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c         |   1 +
 fs/xfs/libxfs/xfs_defer.c            |  18 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |  10 +
 fs/xfs/libxfs/xfs_parent.c           |  12 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   7 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   6 +-
 fs/xfs/libxfs/xfs_trans_space.c      |  19 +-
 fs/xfs/scrub/alloc_repair.c          |  18 +-
 fs/xfs/scrub/dir_repair.c            |  27 ++-
 fs/xfs/scrub/dirtree.c               |  31 ++-
 fs/xfs/scrub/dirtree_repair.c        |   1 +
 fs/xfs/scrub/ialloc.c                |   4 +
 fs/xfs/scrub/metapath.c              |  87 +++++++-
 fs/xfs/scrub/quota_repair.c          |  14 +-
 fs/xfs/scrub/quotacheck.c            |   4 +-
 fs/xfs/scrub/reap.c                  |   6 +-
 fs/xfs/scrub/refcount.c              |   8 +-
 fs/xfs/scrub/rgsuper.c               |   6 +-
 fs/xfs/scrub/rtrefcount.c            |  82 ++++++--
 fs/xfs/scrub/rtsummary_repair.c      |   3 +-
 fs/xfs/scrub/scrub.c                 |   3 +-
 fs/xfs/scrub/stats.c                 |  28 ++-
 fs/xfs/scrub/stats.h                 |   4 +-
 fs/xfs/scrub/symlink_repair.c        |   2 +-
 fs/xfs/scrub/trace.h                 |  35 +++-
 fs/xfs/xfs_buf.c                     |   4 +-
 fs/xfs/xfs_exchmaps_item.c           |  19 +-
 fs/xfs/xfs_exchrange.c               |  12 +-
 fs/xfs/xfs_extent_busy.c             |   4 +-
 fs/xfs/xfs_healthmon.c               | 126 ++++++------
 fs/xfs/xfs_healthmon.h               |   5 +-
 fs/xfs/xfs_icache.c                  |   3 +-
 fs/xfs/xfs_ioctl.c                   | 385 +++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h                   |   4 +-
 fs/xfs/xfs_ioctl32.c                 | 188 +++++++++--------
 fs/xfs/xfs_log.c                     |  33 +--
 fs/xfs/xfs_log_cil.c                 |   3 +-
 fs/xfs/xfs_log_priv.h                |   4 +-
 fs/xfs/xfs_mru_cache.c               |   2 +-
 fs/xfs/xfs_trace.h                   |   4 +-
 fs/xfs/xfs_trans_ail.c               |   4 +-
 fs/xfs/xfs_verify_media.c            |  24 ++-
 fs/xfs/xfs_zone_alloc.c              |   2 +
 fs/xfs/xfs_zone_space_resv.c         |   8 +-
 46 files changed, 866 insertions(+), 410 deletions(-)
