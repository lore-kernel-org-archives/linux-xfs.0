Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF802D8767
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418691; cv=none; b=gAwNeb6Dw1NUMEhkQoOLtDyWMH25buXYBUudZ6+YWNzZs2FF645A3w0erOMzEwTEHhONLoEbzIGpgGU074ycD89bUig/kw9YkrLFU73GyjNRLihuOZ9F2KH0QiR6+ZkSa3ZF+vy7HupOKKg3B4HfZ/gVAgzn9WyVmZzuKui3TEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418691; c=relaxed/simple;
	bh=dFItehqxqh8oR7n+fBuBFgkaiuNedH3VfqdFEwEptMo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kWk2Fz2uxGZBKHI6rmg9CNHMqBYVtayKwKMEjIFIEsbP7wGkDq7TTKB9Iosmcw8uzj4eJ6a2oovOREKCUzRrNl45ibl0/WKICrCiGigdfvAy7moiBvM71IhFvmuRqfBM6GCiolOuAMrcsUKAFM1h5fQGM5monQ2Vic6VKpsQjso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BtpYs62P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BtpYs62P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E771F000E9
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 06:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788418690;
	bh=Swfm1aQkxJmc5BwSFTYYUrIJMReSW1EZp5q5Xglu2NA=;
	h=Date:From:To:Subject;
	b=BtpYs62Pqlvss2kMI2RMSREPP/LPlVVzruCzQvr7LfeeYvugBQe+OQWmgfhnGcZpd
	 MR3iFThmQI0P5tBjRtXOCQRxFu6ctAV3k62al8O5MdUa8UyQzKhiDUcHnPFGswHGa0
	 r1ioFB7XvbjWJwxbzcQiq4pZzZvwL1HUxfnbjJ3CG5D5DD4eo/KfMTirBburvTGW60
	 wUtCUWsb0/z1/04rccb0VjKIDjZukzDoSYOK9innFXIVBYjC2DY/MfORai74GFz2lv
	 YaDyi8goIt4hfSV4yQI8wMrar7RdD8+WUanuij8WCr5JxXT4O/V6ju/FxH+zCIihHJ
	 FR5Ur3Uz1eezw==
Date: Thu, 3 Sep 2026 08:58:06 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE V2] xfs-linux: for-next rebased to c44f3db4f4c0
Message-ID: <apkaERVAa2F2S-jU@andromeda.toxiclabs.cc>
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

has just been *REBASED*.

Patches are exactly the same as the previous from a few minutes ago,
with a reordering so to postpone a few of the patches below to 7.4 by
hch's suggestion.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

c44f3db4f4c0 xfs: remove an extra cast in xfs_file_compat_ioctl

42 new commits:

Anuj Gupta (1):
      [724d0bae9604] xfs: release alleged child inode on metapath unlink error

Christoph Hellwig (24):
      [144d8bc332fa] xfs: fix the lock annotation on xfs_iget_cache_hit
      [928a0ff252b1] xfs: fix the lock annotation in xfs_extent_busy_update_extent
      [e3bae00ffa91] xfs: fix the lock annotation in xfs_mru_cache_lookup
      [167da957c7e3] xfs: improve lock annotations in the log code
      [f3cc0483ffe3] xfs: add lock annotations to xfs_try_open_zone
      [4bb0fb3366fa] xfs: add lock annotations to xlog_state_shutdown_callbacks
      [0a9c62fb4ef5] xfs: add a lock annotation to xlog_cil_push_background
      [ca753f8184db] xfs: add lock annotations to xfs_ail_delete*
      [cc38e26e3f94] xfs: remove an outdated comment above xfs_file_ioctl
      [4e58106b3cf8] xfs: rename xfs_ioc_swapext to xfs_swapext
      [d551ed0e7ed3] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [ddb7719b20b7] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [1e6f3dd66fc1] xfs: split out the handler for XFS_IOC_DIOINFO
      [b6128807c04d] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [4f80ca267bd2] xfs: split out the handler for XFS_IOC_SWAPEXT
      [92b649340587] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [3534db92bfd7] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [a3083bc5a617] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [126092c37ae8] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [1e4c3089ab63] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [a0f3142afdcb] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [c1f331382b61] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [0a0a7894f3db] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [c44f3db4f4c0] xfs: remove an extra cast in xfs_file_compat_ioctl

Darrick J. Wong (7):
      [153c75d93cd5] xfs: fix media verification ioctl for internal rt volumes
      [556928b50187] xfs: don't spin forever on zero-length dirents when salvaging them
      [3db0206c6423] xfs: don't stash removename operations with unknown ftype
      [6bd830b68329] xfs: log the tempip after we convert it to extents format
      [5b5ea66f124c] xfs: fix parent rec lookup initialization in xrep_metapath_unlink
      [cd2d27b0c32a] xfs: handle reconnecting metadir subdirectories
      [fbb8c1b636be] xfs: lock the healthmon when inserting unmount event

Eric Sandeen (2):
      [7f49bf8378c7] xfs: fix reclaimed page accounting in xfs_buf_free
      [97a956fb8cc2] xfs: mark slab-allocated xfs_buf backing memory as __GFP_RECLAIMABLE

Hans Holmberg (1):
      [d5ae1c095942] xfs: prevent race in zoned space reservations

Javier Tia (6):
      [4f434e6c6b3c] xfs: initialise error in xfs_defer_finish_one()
      [69d300eba1ef] xfs: give the deferred barrier op type a name
      [5d46cb54112a] xfs: report the error that made deferred work shut down the fs
      [ae66b1508239] xfs: correct the parent pointer space reservation comment
      [05276cd720f9] xfs: initialise args->total for parent pointer updates
      [4476c24bd779] xfs: assert the reservation covers each da fork growth

Lin Jiapeng (1):
      [f3772e189ee8] xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Code Diffstat:

 fs/xfs/libxfs/xfs_da_btree.c    |   1 +
 fs/xfs/libxfs/xfs_defer.c       |  18 +-
 fs/xfs/libxfs/xfs_exchmaps.c    |  10 ++
 fs/xfs/libxfs/xfs_parent.c      |  12 +-
 fs/xfs/libxfs/xfs_trans_space.c |  19 +-
 fs/xfs/scrub/dir_repair.c       |  27 ++-
 fs/xfs/scrub/metapath.c         |  87 ++++++++-
 fs/xfs/scrub/symlink_repair.c   |   2 +-
 fs/xfs/xfs_buf.c                |   4 +-
 fs/xfs/xfs_extent_busy.c        |   4 +-
 fs/xfs/xfs_healthmon.c          |   6 +
 fs/xfs/xfs_icache.c             |   3 +-
 fs/xfs/xfs_ioctl.c              | 385 +++++++++++++++++++++++-----------------
 fs/xfs/xfs_ioctl.h              |   4 +-
 fs/xfs/xfs_ioctl32.c            | 188 +++++++++++---------
 fs/xfs/xfs_log.c                |  33 ++--
 fs/xfs/xfs_log_cil.c            |   3 +-
 fs/xfs/xfs_log_priv.h           |   4 +-
 fs/xfs/xfs_mru_cache.c          |   2 +-
 fs/xfs/xfs_trans_ail.c          |   4 +-
 fs/xfs/xfs_verify_media.c       |  24 ++-
 fs/xfs/xfs_zone_alloc.c         |   2 +
 fs/xfs/xfs_zone_space_resv.c    |   8 +-
 23 files changed, 563 insertions(+), 287 deletions(-)
