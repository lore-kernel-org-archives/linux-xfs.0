Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C062F531B
	for <linux-xfs@vger.kernel.org>; Sat, 12 Sep 2026 14:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224875; cv=none; b=mQS8KXheVS+2y0CXXSrsWYMtOdsZGsDfQz0dcWv8nG3OeMbcguwCHxzTFPj8cVhedWLrFZOEymYLqqOFfo7y8MB3n3BQSh/fD3rYNWqjTYvqaK/hv87P9i+xLKngbRMrdpf/H3IEF5rEBqZSih6LkNx4BNtu35l4PaMuijrpHt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224875; c=relaxed/simple;
	bh=bihfBrpn9MKR/Uc+S78Oia0zdRRbClKJV2mQNcKmiok=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nKoVkHmf0N7206l+fAwILS8h1zFTrewDOJG9vCEncT4pAQ8k5SXaOZKgogFbOAaqmBUeQ55c9eVR4qJTOW2ioYAsIqt5hlgi9ggC04bWTPPZSfCkTWO7ulHUXQ4Z3fNs0Y/ngSGhHA+97nmd2CW525yhedH2/75uUFGrqM9efNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBsDqfCv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBsDqfCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D861F00893;
	Sat, 12 Sep 2026 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789224873;
	bh=pH0C+q5AFlAYbxE6Msnk6cjQrBz4mIMAGGW1wvCrvYo=;
	h=Date:From:To:Cc:Subject;
	b=DBsDqfCvurO3j1ko1urFR8YrkIhIw73KZtNYTj+C3d0YmbeNzQ/rMsmVVmaj1Ge0d
	 Hm3fc57WFLk+6Fx4GDeKlwPlx937G1xogA4V4OcfnD+IGD/cPqz7NzwXrFrCmLlWdn
	 bIbeTFwlZL4o9bD0TRL/yM3E1SAcP6S5+BUmJW/t98rFHev/b/+k6IqoF7aTo8ngTs
	 1Vjoxozx70bghSD8dwrk4zNymE7d2VlM8/tQRbhNsNg+Zp8bKRDSsVJbE2yirF1U0Q
	 JlSraTYUoYjwimNvRJIuZqdWtj4XhlpYr86mhQ7+gR3KgOmMI7bYxR90y+pH3bgvu9
	 rwhrl10/PoxZg==
Date: Sat, 12 Sep 2026 16:54:29 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: Fixes for v7.3-rc3
Message-ID: <aqUKwxI9Bsw4VUZg@nidhogg.toxiclabs.cc>
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

An attempt merge against your current TOT has been successful.

This tag contains a more than usual amount of fixes.

The highlights here are a block under reservation fix which caused
an assert to be triggered in non-default configurations.  The assert,
initially added on 7.3-rc2 just makes the problem explicit but is not
the cause.  Another highlight is a missed lock/unlock mutex in the xfs
healthmonitor which was causing lockdeps warnings.

Besides those two, this also contains a myriad of fixes for random bugs
found by LLM tools in the healthmon, scrub and online repair.

A few bug fixes for zoned xfs are also included.

This also includes an accounting fix for our buffer slab cache where the
memory payload associated to each object was not being properly
accounted for.

The remaining of the patches are a few lock context annotations added
and/or fixed. They are mostly disabled by now, but still worth fixing
before we get them enabled.

And last but not least, a few clean ups.

Please notice that a few of these patches (the last 17 patches to be
specific), were added to linux-next only yesterday Sep 11. But yet I'm
sending the pull request because some of them they are important to be
fixed as soon as possible. A few of those patches were in linux-next
before but I needed to rebase the tree so they changed hashes. But as
usual, I did test all of them here in my regression suite before
sending you the pull request.


Thanks,
Carlos

"The following changes since commit df2908090cda368b01ff43709f51890076c56157:

  Linux 7.3-rc2 (2026-09-06 15:07:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-fixes-7.3-rc3

for you to fetch changes up to ad4497a92caba4630f75c80d49cb947026213280:

  xfs: advance the findparent inode scan cursor while holding ILOCK (2026-09-11 08:45:11 +0200)

----------------------------------------------------------------
xfs: fixes for 7.3-rc3

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Anuj Gupta (2):
      xfs: release alleged child inode on metapath unlink error
      xfs: set IOMAP_F_INTEGRITY for zoned writes on integrity devices

Christoph Hellwig (11):
      xfs: fix the lock annotation on xfs_iget_cache_hit
      xfs: fix the lock annotation in xfs_extent_busy_update_extent
      xfs: fix the lock annotation in xfs_mru_cache_lookup
      xfs: improve lock annotations in the log code
      xfs: add lock annotations to xfs_try_open_zone
      xfs: add lock annotations to xlog_state_shutdown_callbacks
      xfs: add a lock annotation to xlog_cil_push_background
      xfs: add lock annotations to xfs_ail_delete*
      xfs: also flush the RT device cache in xlog_write_iclog
      xfs: don't continue on error in xfs_fsync
      xfs: avoid extra cache flushes for multi-device file systems in xfs_fsync

Darrick J. Wong (50):
      xfs: fix media verification ioctl for internal rt volumes
      xfs: don't spin forever on zero-length dirents when salvaging them
      xfs: don't stash removename operations with unknown ftype
      xfs: log the tempip after we convert it to extents format
      xfs: fix parent rec lookup initialization in xrep_metapath_unlink
      xfs: handle reconnecting metadir subdirectories
      xfs: lock the healthmon when inserting unmount event
      xfs: fix unit conversions in per_binval computation
      xfs: fix short ifork reaping computation in xreap_bmapi_binval
      xfs: fix name string recording in slowpath pptr tracepoints
      xfs: don't leak dqacct if rhashtable insertion fails
      xfs: fix the rtrmap and rtrefcount _maxlevels_ondisk functions
      xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap filesystems
      xfs: preserve owner on in-memory btree creation
      xfs: don't leak new_bp if xfs_btree_bload_drop_buf fails
      xfs: actually recover intended file sizes in xfs_xmi_item_recover_intent
      xfs: don't modify file attributes or poke fsnotify for dry runs
      xfs: fix bnobt repair space reservation disposal failure
      xfs: always set xfs_healthmon::first_event when inserting at front of list
      xfs: move healthmon event merge tracepoint
      xfs: port healthmon event list to list_head
      xfs: merge healthmon insert/push helpers
      xfs: check healthmon outbuffer space correctly
      xfs: bump lost_prev_errors if we lose even the healthmon lost event
      xfs: report nonexistent parents as a filesystem corruption
      xfs: destroy seen inode bitmap when we fail to add a dirpath
      xfs: signal inode btree xref error if get_rec returns an error
      xfs: truncate quota file correctly when repairing quota file
      xfs: compute dquot checksum after resetting dd_lsn in repair
      xfs: fix backwards skipping logic in xrep_quota_block
      xfs: fix backwards mergeability logic in refcount scrubber
      xfs: cross-reference the rtgroup superblock extent, not block
      xfs: use the rtgroup extent count to find rtrefcount gaps
      xfs: strengthen the "is cow staging" helpers in scrub
      xfs: fix rtrefcount btree block counting in scrub
      xfs: make the rtsummary repair fix the file size too
      xfs: count escaped corruption errors in scrub stats
      xfs: snapshot scrub stats when rendering them
      xfs: report healthy filesystem events in scrub stats
      xfs: report runtime failures in scrub
      xfs: remove redundant function declaration
      xfs: snapshot old AGFL before rewriting it
      xfs: bail out on bitmap errors in xrep_agfl_fill
      xfs: fix under-reservation of blocks when repairing sf directories
      xfs: actually check internal-rtdev fields in the superblock
      xfs: fix rtrmap cross-referencing elision logic
      xfs: fix termination logic in xchk_bmap
      xfs: fix replaying dirent removals into the temporary directory
      xfs: reset parent pointer args before each dir tree unlink repair
      xfs: advance the findparent inode scan cursor while holding ILOCK

Deepanshu Kartikey (1):
      xfs: take hm->lock in xfs_ioc_health_monitor() before insert

Eric Sandeen (2):
      xfs: fix reclaimed page accounting in xfs_buf_free
      xfs: mark slab-allocated xfs_buf backing memory as __GFP_RECLAIMABLE

Hans Holmberg (1):
      xfs: prevent race in zoned space reservations

Javier Tia (6):
      xfs: initialise error in xfs_defer_finish_one()
      xfs: give the deferred barrier op type a name
      xfs: report the error that made deferred work shut down the fs
      xfs: correct the parent pointer space reservation comment
      xfs: initialise args->total for parent pointer updates
      xfs: assert the reservation covers each da fork growth

Lin Jiapeng (1):
      xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Zizhi Wo (1):
      xfs: remove several unused and never-implemented declarations

 fs/xfs/libxfs/xfs_btree_mem.c        |   2 +
 fs/xfs/libxfs/xfs_btree_staging.c    |   4 +-
 fs/xfs/libxfs/xfs_da_btree.c         |   3 +-
 fs/xfs/libxfs/xfs_da_btree.h         |   2 +
 fs/xfs/libxfs/xfs_defer.c            |  18 ++++-
 fs/xfs/libxfs/xfs_exchmaps.c         |  10 +++
 fs/xfs/libxfs/xfs_parent.c           |  12 +++-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   7 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   6 +-
 fs/xfs/libxfs/xfs_trans_space.c      |  19 +++++-
 fs/xfs/scrub/agheader.c              |   7 ++
 fs/xfs/scrub/agheader_repair.c       |  39 ++++++++---
 fs/xfs/scrub/alloc_repair.c          |  18 +++--
 fs/xfs/scrub/attr_repair.c           |   2 +-
 fs/xfs/scrub/bmap.c                  |   7 +-
 fs/xfs/scrub/common.h                |   1 -
 fs/xfs/scrub/dabtree.h               |   2 -
 fs/xfs/scrub/dir_repair.c            |  31 +++++++--
 fs/xfs/scrub/dirtree.c               |  31 ++++++++-
 fs/xfs/scrub/dirtree_repair.c        |   2 +
 fs/xfs/scrub/findparent.c            |  54 ++++++++++-----
 fs/xfs/scrub/ialloc.c                |   4 ++
 fs/xfs/scrub/metapath.c              |  87 +++++++++++++++++++++++-
 fs/xfs/scrub/quota_repair.c          |  14 ++--
 fs/xfs/scrub/quotacheck.c            |   4 +-
 fs/xfs/scrub/reap.c                  |   6 +-
 fs/xfs/scrub/refcount.c              |   8 ++-
 fs/xfs/scrub/rgsuper.c               |   6 +-
 fs/xfs/scrub/rtrefcount.c            |  82 +++++++++++++++++-----
 fs/xfs/scrub/rtsummary_repair.c      |   3 +-
 fs/xfs/scrub/scrub.c                 |   3 +-
 fs/xfs/scrub/scrub.h                 |   1 -
 fs/xfs/scrub/stats.c                 |  69 ++++++++++++-------
 fs/xfs/scrub/stats.h                 |   4 +-
 fs/xfs/scrub/symlink_repair.c        |   2 +-
 fs/xfs/scrub/tempfile.c              |  29 ++++++--
 fs/xfs/scrub/tempfile.h              |   4 --
 fs/xfs/scrub/trace.h                 |  35 +++++++++-
 fs/xfs/xfs_buf.c                     |   4 +-
 fs/xfs/xfs_buf_item.h                |   1 -
 fs/xfs/xfs_exchmaps_item.c           |  19 +++++-
 fs/xfs/xfs_exchrange.c               |  12 +++-
 fs/xfs/xfs_extent_busy.c             |   4 +-
 fs/xfs/xfs_file.c                    |  47 ++++---------
 fs/xfs/xfs_healthmon.c               | 128 +++++++++++++++++++----------------
 fs/xfs/xfs_healthmon.h               |   5 +-
 fs/xfs/xfs_icache.c                  |   3 +-
 fs/xfs/xfs_inode.h                   |   1 -
 fs/xfs/xfs_iomap.h                   |   2 +
 fs/xfs/xfs_log.c                     |  78 ++++++++++++++-------
 fs/xfs/xfs_log.h                     |   2 -
 fs/xfs/xfs_log_cil.c                 |  10 +--
 fs/xfs/xfs_log_priv.h                |   4 +-
 fs/xfs/xfs_mru_cache.c               |   2 +-
 fs/xfs/xfs_trace.h                   |   4 +-
 fs/xfs/xfs_trans_ail.c               |   4 +-
 fs/xfs/xfs_verify_media.c            |  24 +++++--
 fs/xfs/xfs_zone_alloc.c              |   2 +
 fs/xfs/xfs_zone_space_resv.c         |   8 +--
 59 files changed, 715 insertions(+), 287 deletions(-)"
