Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604B619E965
	for <linux-xfs@vger.kernel.org>; Mon, 24 Mar 2025 19:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742846085; cv=none; b=jes+2kOhq8txAYIMvsu4wd5ht7ZI588l/khc2F3qMbNWVFg9cbuJKqPF6MTcX59JxsnlDzDy2RM3DGDPXA6BfUeGQwau+8/QmpJvuvD9i/sTONgI2dpp+3TtHk3e59LaGovft0d+4GevYVS8Gh4YIcUPkIiLFkevwRLNLDG0fC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742846085; c=relaxed/simple;
	bh=COoesfJ0eFhpbCmQCAdQCUyhgjrnBxkZf/w3htdZN2s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YmYEvesrF7jTYL+Ffm7Z72KmUQV0jRsNArTuzQNTaWLWVAVkvQJECCmjW5rtlJZrjRXGAPW+LSBHY5FHpnbY1SyWbKoNXpiKsxLuqPbRWd4RCF/nnygmfVKaxWoPuRYHxaVT/mAv/aEG2LWrKkk9dsFLiXy5JbbRYqwtEIJciSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8I2vwNM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8I2vwNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CF3C4CEDD;
	Mon, 24 Mar 2025 19:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742846084;
	bh=COoesfJ0eFhpbCmQCAdQCUyhgjrnBxkZf/w3htdZN2s=;
	h=Date:From:To:Cc:Subject:From;
	b=W8I2vwNMj6hba42FY5cQDr9yIbC8wNOYI64jnHK4vasVJZfIBZg2YDg/gFGMbyVqr
	 ZtSB1GAzbDTAVYla+d9TnkNkUxIfeUfJXqAOAJVpc9X/S/nnlcZ2WIEXW9Ecg2rDAe
	 1uKp1PLMQVcMQwf02LVsPztCHMqt+sPxFPEN9uczBYoVldy7Q9p0Fp1+rhki07jAzq
	 /rkTwn6ncAw1Bt3WFl/uRSQRHyYrkKh4lvHCWd0IuYvQofKmwHImCtieFBIcZDXcUJ
	 1tOQr5NI+v+HFryAb6HkpecyEEbZY9qbRrc1R+SRmEXV3qJrlh2Gq2R6vTQSJoH87M
	 V5sp5oRCiwbOw==
Date: Mon, 24 Mar 2025 20:54:40 +0100
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS fixes for v6.15
Message-ID: <7osalttg7zzp5q5pee3zqjqde4tzspqjaix5q2suoxoewn4n5d@ausn55axx2z4>
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

This is the first release I used a different approach by maintaining
multiple branches due to the release cycle. Every patch included here
spent some time in linux-next, but merge commits will differ.

Notice though (as we spoke previously), I needed to pull in a VFS shared
branch due to some iomap dependent patches, I haven't detailed it on the
merge commit at the time though (I'll make sure I do that on a next time).
Due that, the shortlog below will contain patches already included in another
trees.

The highlights for this PR are:

	- XFS zoned allocator: Enables XFS to support zoned devices using
			       its real-time allocator
	- Use folios/vmalloc for buffer cache backing memory
	- Some code cleanups and bug fixes

An attempt merge against your current tree (586de92313fc) has been
successful, and the diffstat is also included below.

Thanks,
Carlos

The following changes since commit 4701f33a10702d5fc577c32434eb62adde0a1ae1:

  Linux 6.14-rc7 (2025-03-16 12:55:17 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.15-merge

for you to fetch changes up to b3f8f2903b8cd48b0746bf05a40b85ae4b684034:

  xfs: remove the flags argument to xfs_buf_get_uncached (2025-03-18 14:47:45 +0100)

----------------------------------------------------------------
XFS - new code for 6.15

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Brian Foster (22):
      iomap: factor out iomap length helper
      iomap: split out iomap check and reset logic from iter advance
      iomap: refactor iomap_iter() length check and tracepoint
      iomap: lift error code check out of iomap_iter_advance()
      iomap: lift iter termination logic from iomap_iter_advance()
      iomap: export iomap_iter_advance() and return remaining length
      iomap: support incremental iomap_iter advances
      iomap: advance the iter directly on buffered writes
      iomap: advance the iter directly on unshare range
      iomap: advance the iter directly on zero range
      iomap: advance the iter directly on buffered read
      iomap: advance the iter on direct I/O
      iomap: convert misc simple ops to incremental advance
      dax: advance the iomap_iter in the read/write path
      dax: push advance down into dax_iomap_iter() for read and write
      dax: advance the iomap_iter on zero range
      dax: advance the iomap_iter on unshare range
      dax: advance the iomap_iter on dedupe range
      dax: advance the iomap_iter on pte and pmd faults
      iomap: remove unnecessary advance from iomap_iter()
      iomap: rename iomap_iter processed field to status
      iomap: introduce a full map advance helper

Carlos Maiolino (7):
      Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge
      Merge tag 'xfs-zoned-allocator-2025-03-03' of git://git.infradead.org/users/hch/xfs into xfs-6.15-zoned_devices
      Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge
      Merge branch 'xfs-6.15-zoned_devices' into xfs-6.15-merge
      Merge branch 'xfs-6.15-merge' into for-next
      Merge branch 'xfs-6.15-zoned_devices' into XFS-for-linus-6.15-merge
      Merge branch 'xfs-6.15-folios_vmalloc' into XFS-for-linus-6.15-merge

Chen Ni (1):
      xfs: remove unnecessary NULL check before kvfree()

Christian Brauner (7):
      Merge patch series "iomap: allow the file system to submit the writeback bios"
      Merge patch series "iomap: incremental per-operation iter advance"
      Merge patch series "iomap: incremental advance conversion -- phase 2"
      Merge patch series "iomap: make buffered writes work with RWF_DONTCACHE"
      Merge branch 'vfs-6.15.shared.iomap' of gitolite.kernel.org:pub/scm/linux/kernel/git/vfs/vfs
      Merge branch 'vfs-6.15.shared.iomap' of gitolite.kernel.org:pub/scm/linux/kernel/git/vfs/vfs
      Merge patch series "iomap preliminaries for large atomic write for xfs with CoW"

Christoph Hellwig (70):
      iomap: allow the file system to submit the writeback bios
      iomap: simplify io_flags and io_type in struct iomap_ioend
      iomap: add a IOMAP_F_ANON_WRITE flag
      iomap: split bios to zone append limits in the submission handlers
      iomap: move common ioend code to ioend.c
      iomap: factor out a iomap_dio_done helper
      iomap: optionally use ioends for direct I/O
      iomap: add a io_private field to struct iomap_ioend
      iomap: pass private data to iomap_page_mkwrite
      iomap: pass private data to iomap_zero_range
      iomap: pass private data to iomap_truncate_page
      xfs: reflow xfs_dec_freecounter
      xfs: generalize the freespace and reserved blocks handling
      xfs: support reserved blocks for the rt extent counter
      xfs: trace in-memory freecounter reservations
      xfs: fixup the metabtree reservation in xrep_reap_metadir_fsblocks
      xfs: make metabtree reservations global
      xfs: reduce metafile reservations
      xfs: factor out a xfs_rt_check_size helper
      xfs: add a rtg_blocks helper
      xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
      xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
      xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
      xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
      xfs: add a xfs_rtrmap_highest_rgbno helper
      xfs: define the zoned on-disk format
      xfs: allow internal RT devices for zoned mode
      xfs: export zoned geometry via XFS_FSOP_GEOM
      xfs: disable sb_frextents for zoned file systems
      xfs: disable FITRIM for zoned RT devices
      xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
      xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
      xfs: parse and validate hardware zone information
      xfs: add the zoned space allocator
      xfs: add support for zoned space reservations
      xfs: implement zoned garbage collection
      xfs: implement buffered writes to zoned RT devices
      xfs: implement direct writes to zoned RT devices
      xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
      xfs: hide reserved RT blocks from statfs
      xfs: support growfs on zoned file systems
      xfs: allow COW forks on zoned file systems in xchk_bmap
      xfs: support xchk_xref_is_used_rt_space on zoned file systems
      xfs: support xrep_require_rtext_inuse on zoned file systems
      xfs: enable fsmap reporting for internal RT devices
      xfs: disable reflink for zoned file systems
      xfs: disable rt quotas for zoned file systems
      xfs: enable the zoned RT device feature
      xfs: support zone gaps
      xfs: add a max_open_zones mount option
      xfs: wire up the show_stats super operation
      xfs: contain more sysfs code in xfs_sysfs.c
      xfs: export max_open_zones in sysfs
      xfs: add a fast path to xfs_buf_zero when b_addr is set
      xfs: remove xfs_buf.b_offset
      xfs: remove xfs_buf_is_vmapped
      xfs: refactor backing memory allocations for buffers
      xfs: remove the kmalloc to page allocator fallback
      xfs: convert buffer cache to use high order folios
      xfs: kill XBF_UNMAPPED
      xfs: use vmalloc instead of vm_map_area for buffer backing memory
      xfs: cleanup mapping tmpfs folios into the buffer cache
      xfs: trace what memory backs a buffer
      xfs: fix a missing unlock in xfs_growfs_data
      xfs: don't increment m_generation for all errors in xfs_growfs_data
      xfs: call xfs_buf_alloc_backing_mem from _xfs_buf_alloc
      xfs: remove xfs_buf_get_maps
      xfs: remove xfs_buf_free_maps
      xfs: remove the flags argument to xfs_buf_read_uncached
      xfs: remove the flags argument to xfs_buf_get_uncached

Darrick J. Wong (1):
      xfs: don't wake zone space waiters without m_zone_info

Dave Chinner (2):
      xfs: unmapped buffer item size straddling mismatch
      xfs: buffer items don't straddle pages anymore

Hans Holmberg (3):
      xfs: support write life time based data placement
      xfs: export zone stats in /proc/*/mountstats
      xfs: trigger zone GC when out of available rt blocks

Jens Axboe (4):
      iomap: make buffered writes work with RWF_DONTCACHE
      xfs: flag as supporting FOP_DONTCACHE
      iomap: make buffered writes work with RWF_DONTCACHE
      xfs: flag as supporting FOP_DONTCACHE

Jiapeng Chong (1):
      xfs: Remove duplicate xfs_rtbitmap.h header

John Garry (2):
      iomap: Rename IOMAP_ATOMIC -> IOMAP_ATOMIC_HW
      iomap: Support SW-based atomic writes

Matthew Wilcox (Oracle) (1):
      xfs: Use abs_diff instead of XFS_ABSDIFF

Ritesh Harjani (IBM) (1):
      iomap: Lift blocksize restriction on atomic writes

 Documentation/filesystems/iomap/design.rst     |    9 +
 Documentation/filesystems/iomap/operations.rst |   33 +-
 fs/dax.c                                       |  111 ++-
 fs/ext4/inode.c                                |    2 +-
 fs/gfs2/bmap.c                                 |    3 +-
 fs/iomap/Makefile                              |    1 +
 fs/iomap/buffered-io.c                         |  347 +++----
 fs/iomap/direct-io.c                           |  174 ++--
 fs/iomap/fiemap.c                              |   21 +-
 fs/iomap/internal.h                            |   10 +
 fs/iomap/ioend.c                               |  216 +++++
 fs/iomap/iter.c                                |   97 +-
 fs/iomap/seek.c                                |   16 +-
 fs/iomap/swapfile.c                            |    7 +-
 fs/iomap/trace.h                               |   10 +-
 fs/xfs/Makefile                                |    7 +-
 fs/xfs/libxfs/xfs_ag.c                         |    2 +-
 fs/xfs/libxfs/xfs_bmap.c                       |  316 +-----
 fs/xfs/libxfs/xfs_bmap.h                       |    7 +-
 fs/xfs/libxfs/xfs_format.h                     |   20 +-
 fs/xfs/libxfs/xfs_fs.h                         |   14 +-
 fs/xfs/libxfs/xfs_group.h                      |   31 +-
 fs/xfs/libxfs/xfs_ialloc.c                     |    4 +-
 fs/xfs/libxfs/xfs_inode_buf.c                  |   23 +-
 fs/xfs/libxfs/xfs_inode_util.c                 |    1 +
 fs/xfs/libxfs/xfs_log_format.h                 |    7 +-
 fs/xfs/libxfs/xfs_metafile.c                   |  167 ++--
 fs/xfs/libxfs/xfs_metafile.h                   |    6 +-
 fs/xfs/libxfs/xfs_ondisk.h                     |    6 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                   |   11 +
 fs/xfs/libxfs/xfs_rtgroup.c                    |   39 +-
 fs/xfs/libxfs/xfs_rtgroup.h                    |   50 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c               |   19 +
 fs/xfs/libxfs/xfs_rtrmap_btree.h               |    2 +
 fs/xfs/libxfs/xfs_sb.c                         |   81 +-
 fs/xfs/libxfs/xfs_types.h                      |   28 +
 fs/xfs/libxfs/xfs_zones.c                      |  186 ++++
 fs/xfs/libxfs/xfs_zones.h                      |   35 +
 fs/xfs/scrub/agheader.c                        |    2 +
 fs/xfs/scrub/bmap.c                            |    4 +-
 fs/xfs/scrub/fscounters.c                      |   22 +-
 fs/xfs/scrub/fscounters_repair.c               |   12 +-
 fs/xfs/scrub/inode.c                           |    7 +
 fs/xfs/scrub/inode_repair.c                    |    7 +-
 fs/xfs/scrub/newbt.c                           |    2 +-
 fs/xfs/scrub/reap.c                            |    9 +-
 fs/xfs/scrub/repair.c                          |   37 +-
 fs/xfs/scrub/rtbitmap.c                        |   11 +-
 fs/xfs/scrub/rtrefcount_repair.c               |   34 +-
 fs/xfs/scrub/rtrmap_repair.c                   |   29 +-
 fs/xfs/scrub/scrub.c                           |    2 +
 fs/xfs/xfs_aops.c                              |  194 +++-
 fs/xfs/xfs_aops.h                              |    3 +-
 fs/xfs/xfs_bmap_util.c                         |   32 +-
 fs/xfs/xfs_bmap_util.h                         |   12 +-
 fs/xfs/xfs_buf.c                               |  558 ++++-------
 fs/xfs/xfs_buf.h                               |   29 +-
 fs/xfs/xfs_buf_item.c                          |  114 ---
 fs/xfs/xfs_buf_item_recover.c                  |    8 +-
 fs/xfs/xfs_buf_mem.c                           |   43 +-
 fs/xfs/xfs_buf_mem.h                           |    6 +-
 fs/xfs/xfs_discard.c                           |    3 +-
 fs/xfs/xfs_extent_busy.c                       |    2 +-
 fs/xfs/xfs_extfree_item.c                      |   35 +-
 fs/xfs/xfs_file.c                              |  351 ++++++-
 fs/xfs/xfs_fsmap.c                             |   86 +-
 fs/xfs/xfs_fsops.c                             |   67 +-
 fs/xfs/xfs_fsops.h                             |    3 +-
 fs/xfs/xfs_icache.c                            |    6 +-
 fs/xfs/xfs_inode.c                             |    6 +-
 fs/xfs/xfs_inode.h                             |   28 +-
 fs/xfs/xfs_inode_item.c                        |    1 +
 fs/xfs/xfs_inode_item_recover.c                |    1 +
 fs/xfs/xfs_ioctl.c                             |   12 +-
 fs/xfs/xfs_iomap.c                             |  528 +++++++++-
 fs/xfs/xfs_iomap.h                             |    7 +-
 fs/xfs/xfs_iops.c                              |   31 +-
 fs/xfs/xfs_log.c                               |    4 +
 fs/xfs/xfs_message.c                           |    4 +
 fs/xfs/xfs_message.h                           |    1 +
 fs/xfs/xfs_mount.c                             |  212 ++--
 fs/xfs/xfs_mount.h                             |  131 ++-
 fs/xfs/xfs_qm.c                                |    3 +-
 fs/xfs/xfs_reflink.c                           |   18 +-
 fs/xfs/xfs_rtalloc.c                           |  244 +++--
 fs/xfs/xfs_rtalloc.h                           |    5 -
 fs/xfs/xfs_super.c                             |  165 +++-
 fs/xfs/xfs_sysfs.c                             |   75 +-
 fs/xfs/xfs_sysfs.h                             |    5 +-
 fs/xfs/xfs_trace.c                             |    2 +
 fs/xfs/xfs_trace.h                             |  218 ++++-
 fs/xfs/xfs_zone_alloc.c                        | 1220 ++++++++++++++++++++++++
 fs/xfs/xfs_zone_alloc.h                        |   70 ++
 fs/xfs/xfs_zone_gc.c                           | 1165 ++++++++++++++++++++++
 fs/xfs/xfs_zone_info.c                         |  105 ++
 fs/xfs/xfs_zone_priv.h                         |  119 +++
 fs/xfs/xfs_zone_space_resv.c                   |  263 +++++
 fs/zonefs/file.c                               |    2 +-
 include/linux/iomap.h                          |  118 ++-
 99 files changed, 6668 insertions(+), 1944 deletions(-)
 create mode 100644 fs/iomap/internal.h
 create mode 100644 fs/iomap/ioend.c
 create mode 100644 fs/xfs/libxfs/xfs_zones.c
 create mode 100644 fs/xfs/libxfs/xfs_zones.h
 create mode 100644 fs/xfs/xfs_zone_alloc.c
 create mode 100644 fs/xfs/xfs_zone_alloc.h
 create mode 100644 fs/xfs/xfs_zone_gc.c
 create mode 100644 fs/xfs/xfs_zone_info.c
 create mode 100644 fs/xfs/xfs_zone_priv.h
 create mode 100644 fs/xfs/xfs_zone_space_resv.c

