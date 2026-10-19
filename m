Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E6855A2AB
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 14:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792419316; cv=none; b=XWK1XSzgODr3LI48Gl1gba454O1kIA8D4UICT0dN9bNWZjIUKAT7PdBynKA+eH7yVj5rApGAcr998YlBJA9etjECdHB4eos9NNq1qM0VJKPYHvcwdwo9mXSVUMNdFUVkoDCmXLLlUYsd54qszdYW1hq1jXShiRhVENHl7Fi6yp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792419316; c=relaxed/simple;
	bh=Pr1AYrm5fxu2AicVSz6DMi48RX6yLGiDXic8HZ+0OnE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QrWdlCMP+gmjOST3Q6bQsjc838we7jSOSV5DEhAxzgMFd4rLaePWu924gDq3VMTQSF8JYFNvF4r4MLg8t4qsgFjU2uF1GbJfJCLuImjo+my0Pb0HDL1PNZesCuUnWvOvTfQQzqa3pL8bU2EEVG27HqFi2S2Zwna7CI62QleJvdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zr6vcJvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zr6vcJvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5887D1F000C5;
	Mon, 19 Oct 2026 14:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792419314;
	bh=TnY+N0yjamhvBWh9tgF3G2U9AZpTLM2QqantHgAJp1Y=;
	h=Date:From:To:Cc:Subject;
	b=Zr6vcJvyrmlszWLsZbQurezngLKU3H6fCWrXSh5qMZx5jdao3sP5gnAr/BEnxU152
	 jtHA1k2VatgavzTAFW1OzvthqG+8GyNhEQxd/CUMtTWcjoadyswsQxVZASx6rOYN0q
	 USusMeUgdZdmTUVFJzKQZ6gg6SsItYNtONbB/ApIO/oPJKZnPhDPjxauvwduoaN4X0
	 iBi7opVsFkHRUXXYezm+xVz+Vd3DFRsQZ91TkPrAgj5GVJUQCFwGFQrjxmi9VAKwLm
	 dIiAMcDDI/Ng+E9HfR44Eha6/6DB0huDa41+4FvUFp267A9vJ6vVR/dOX5uFe2NU/p
	 z749ZbmCp3YVQ==
Date: Mon, 19 Oct 2026 16:15:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-xfs@vger.kernel.org
Subject: [GIT PULL] XFS: New code for v7.4
Message-ID: <atYYuPvLQkQvqESk@nidhogg.toxiclabs.cc>
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

Before anything, I have the following Jens Axboe's branch merged into
this because some of Christoph's work related to data checksums depends
on that:

linux-axboe/for-7.4/lazy-bounce-buffering

The bulk of this pull-request are bug fixes, cleanups and code
refactoring, lots of them. Majority of those bug fixes are targeting
scrub and online repair code. There are no real new features here but
lots of prep code for future work. There are also some small performance
optimizations but nothing major.

The following patch deserves attention:

23f91a51425e xfs: fix NOFS state corruption in btree split worker

This will conflict with another patch on the MM tree:

2e6a6ca06fec xfs: remove dead kswapd flag inheritance from btree split worker

The merge conflict resolution of both patches on linux-next ended up
dropping the memalloc_nofs_{save, restore} calls added by 23f91a51425e
and re-added current_{set, restore}_flags_nested() calls removed by
2e6a6ca06fec which is wrong.

I just attempted a merge of this pull-request against your current TOT
(linux v7.3 tag) and it has been smoothly successful. After, I attempted
to pull in MM's tree which generated the expected conflict.

Below is a sample resolution for the conflict I did here in case it may
be useful. But you're much better on merge conflict resolutions so
please use your best judgement.

Thanks,
Carlos


@@ -2994,7 +2994,6 @@ struct xfs_btree_split_args {
        struct xfs_btree_cur    **curp;
        int                     *stat;          /* success/failure */
        int                     result;
-       bool                    kswapd; /* allocation in kswapd context */
        struct completion       *done;
        struct work_struct      work;
 };
@@ -3008,20 +3007,7 @@ xfs_btree_split_worker(
 {
        struct xfs_btree_split_args     *args = container_of(work,
                                                struct xfs_btree_split_args, work);
-       unsigned long           pflags;
-       unsigned long           new_pflags = 0;
-       unsigned int            nofs_flags;
-
-       /*
-        * we are in a transaction context here, but may also be doing work
-        * in kswapd context, and hence we may need to inherit that state
-        * temporarily to ensure that we don't block waiting for memory reclaim
-        * in any way.
-        */
-       if (args->kswapd)
-               new_pflags |= PF_MEMALLOC | PF_KSWAPD;
-
-       current_set_flags_nested(&pflags, new_pflags);
+       unsigned int                    nofs_flags;

        /*
         * Don't use xfs_trans_set_context() here: it would overwrite the
@@ -3033,14 +3019,12 @@ xfs_btree_split_worker(
                                         args->key, args->curp, args->stat);

        memalloc_nofs_restore(nofs_flags);
-       current_restore_flags_nested(&pflags, new_pflags);

        /*
         * Do not access args after complete() has run here. We don't own args
         * and the owner may run and free args before we return here.
         */
        complete(args->done);
-
 }


"The following changes since commit a90ee4305c4a5df72c11b31dacfdc76e00fcf78a:

  Linux 7.3-rc6 (2026-10-04 13:45:25 -0700)

are available in the Git repository at:

  git://git.kernel.org:/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-7.4

for you to fetch changes up to ec8f62cc109a3f596b3c65dc0f1011c209239051:

  xfs: don't limit software atomic writes by the group alignment (2026-10-14 10:18:10 +0200)

----------------------------------------------------------------
xfs: new code for v7.4

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Aditya Prakash Srivastava (1):
      xfs: prevent close() from hanging on frozen filesystems

Aldo Ariel Panzardo (4):
      xfs: bound inode fork length against the fork size during log recovery
      xfs: bound da-node entry count against the correct geometry
      xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
      xfs: reject remote xattr entries with an out-of-range value length

Brian Foster (4):
      xfs: set minleft correctly for sparse chunk errortag allocation
      xfs: support additional levels in the agfl minimum calculation
      xfs: calculate AGFL max to support multiple-alloc transactions
      xfs: incorporate increased AGFL min requirement for minleft allocs

Carlos Maiolino (4):
      Merge remote-tracking branch 'linux-axboe/for-7.4/lazy-bounce-buffering' into xfs-7.4-merge
      xfs: add xfs_error_report the ability to display an error code
      xfs: introduce xfs_trans_cancel_error()
      xfs: make xfs_iomap_write_direct() report an error to xfs_trans_cancel

Christoph Hellwig (55):
      block: avoid integer overflows in max_integrity_io_size
      block: cap atomic write size by PI buffer size constraints
      block: improve aligning down bios in bio_iov_iter_bounce_write
      block: split bio_iov_iter_bounce_write
      block: export fs_bio_integrity_{alloc,free}
      block: add a bio_prepare_reissue helper
      block: pass a maxlen argument to bio_iov_iter_get_pages
      block: warn on too larger integrity allocations
      iomap: respect maximum I/O size in iomap_dio_bio_iter_one
      iomap: add a iomap_ioend_flags helper
      iomap: add a IOMAP_IOEND_INTEGRITY flag
      iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
      xfs: move PI generation into xfs_submit_zoned_bio
      block,iomap: fix protection information verification with initial bvec offset
      iomap: better read bounce buffering support
      xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
      iomap,xfs: move integrity verification to the file system
      xfs: add support for lazy direct read bounce buffering
      xfs: add error injection for lazy bounce buffering
      xfs: log a message at mount time when using integrity protection
      block,iomap: remove the old read side bounce buffering support
      xfs: convert all !XFS_RT stubs to inline functions
      xfs: remove an outdated comment above xfs_file_ioctl
      xfs: rename xfs_ioc_swapext to xfs_swapext
      xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      xfs: split out the handler for XFS_IOC_DIOINFO
      xfs: split out the handlers for XFS_IOC_.*HANDLE
      xfs: split out the handler for XFS_IOC_SWAPEXT
      xfs: split out the handlers for XFS_IOC_FSGROWFS*
      xfs: split out the handler for XFS_IOC_GOINGDOWN
      xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      xfs: cleanup XFS_IOC_GETVERSION_32 handling
      xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      xfs: remove an extra cast in xfs_file_compat_ioctl
      xfs: clean up xfs_fsync_flush_log a bit
      xfs: optimize cache flushing for CIL commits on multi-device file systems
      xfs: flush multiple device caches in parallel in xlog_write_iclog
      xfs: centralize setting of buf_ops/buf_type/magic for rtblocks
      xfs: factor out a xfs_rtfile_initialize_buf helper
      xfs: add a xfs_rtblock_payload helper
      xfs: cleanup xfs_verify_media_error
      xfs: use bdev_rw_virt in xfs_verify_media
      xfs: lift setting the NOFS context to xfs_end_io
      xfs: split xfs_end_ioend_write
      xfs: factor out a xfs_zoned_fill_srcmap helper
      xfs: calculate end_fsb later in xfs_zoned_fill_srcmap
      xfs: remove various unused includes in libxfs/
      xfs: include <linux/iversion.h> in xfs_platform.h
      xfs: move xfs_*_item.h to libxfs
      xfs: move xfs_trans.h to libxfs
      xfs: handle NULL open_zone for merged ioends in xfs_end_ioend_write_zoned

Daejun Park (1):
      xfs: map pNFS layouts to the end of the extent again

Darrick J. Wong (95):
      xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
      xfs: online quotacheck must dirty dquot if enforcement adjustments needed
      xfs: fix buffer overruns in xfs_ioc_attr_list
      xfs: clean up after failed metafile relinking
      xfs: pass xfs_trans_resv object to reservation calculation helpers
      xfs: fix xfs_rename_space_res for non-pptr filesystems
      xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
      xfs: add missing healthmon trace strings
      xfarray: don't crash when sorting if array element crosses a folio
      xfarray: don't allow users to unset in the middle of an array
      xfs: don't allow sorting sparse arrays
      xfs: simply the free space btree repair code
      xfarray: warn against sorting arrays with identical elements
      xfs: compute the correct fdblocks/frextents for repair when they're negative
      xfs: mark cow extents bad if there's no rmap mapping for them
      xfs: clear the symlink zapped flag if inline symlink is ok
      xfs: reinitialize dquot block if non-first dquot can't load
      xfs: fix inode btree repair when a cluster is larger than a chunk
      xfs: fix integer overflow problem when setting large free areas
      xfs: fix buffer overflow in corrupt inline attr structure
      xfs: actually report corrupt xattrs as XFAIL during cross-referencing
      xfs: improve dir block reporting when cross-referencing dirents to pptrs
      xfs: fix unnecessary dapos truncation in xchk_dir_walk
      xfs: actually lock the metafile reservation when adjusting after repair
      xfs: avoid cross-rtgroup reaping after a repair
      xfs: adjust checks for cross-AG reaping issues
      xfs: actually check XFS_DIFLAG2_METADATA for metadata btree data forks
      xfs: fix xchk_stats_estimate_bufsize to allow for the trailing null
      xfs: cross-reference the primary superblock
      xfs: write the rt super immediately during repair
      xfs: read rt superblock from disk during scrub
      xfs: write the primary super immediately during repair
      xfs: read primary superblock from disk during scrub
      xfs: jump out of xchk_bmap_check_rmap if fatal signals
      xfs: mark overfull dabtree node blocks as corrupt
      xfs: check fork type against dabtree block magic number
      xfs: abort dirtree repair if the live update hook dies
      xfs: bail out of directory tree repairs on error
      xfs: fix revalidation of xchk_dquot_iter cached mappings
      xfs: don't repair fs summary counters with garbage
      xfs: allow softlimit with no hardlimit in quota scrub
      xfs: assign an owner to scrub_stats_fops
      xfs: fix lost errno returned from xfarray_foliosort
      xfs: fix skipped inode mask handling in iscan
      xfs: don't proceed with xattr repair if the live update fails
      xfs: don't fix the directory tree if live update fails
      xfs: flag excessive delalloc rt extents as corruption
      xfs: zero out di_metatype when removing the metadir file iflag
      xfs: forcibly reset quota timers when upgrading to bigtime during repair
      xfs: don't pass iget failures up when marking ondisk inodes
      xfs: always reset incore attr fork buffer when resetting fork
      xfs: propagate errors while checking null siblings
      xfs: don't try to scrub self-referential dirent in metapath checker
      xfs: don't allow sm_agno for non-group metadir path checking
      xfs: init inode number for tracepoint
      xfs: release ip after unlinked list store failure
      xfs: always zero the whole shortform header when zeroing attr fork
      xfs: always forget cached ACLs if the attr fork swap succeeds
      xfs: check for termination during rmap btree walk
      xfs: don't subtract excess usage twice when computing agf_btreeblks
      xfs: abort directory tree repair whenever dl->aborted is set
      xfs: reattach dquots after changing inode ids
      xfs: never reset the default quota timer
      xfs: fix correction of unwritten extents in quota file data fork
      xfs: always report inode repair setup failures
      xfs: range-check bc_levels array access in scrub tracepoints
      xfs: reject absurdly large xattr value lengths in xchk_xattr_actor
      xfs: break out xattr entry checks into separate functions
      xfs: check for buffer overruns when examining local/remote xattr entries
      xfs: clarify various parts of the bitmap API
      xfs: complain loudly when dirtree checker finds broken links
      xfs: don't overrun incore inode when cleaning attr forks
      xfs: fix data fork block count check in xrep_inode_blockcounts
      xfs: avoid oversized space allocations when regenerating metadata
      xfs: reduce new btree slack factor if free space is negative
      xfs: don't queue rmap update twice when reaping a fork
      xfs: only written file data blocks can be shared
      xfs: check for fragments when full-extent sharing matches
      xfs: don't clear COWEXTSIZE on directories on reflink filesystems
      xfs: clear set[ug]id mode bits when zapping attr fork
      xfs: opportunistically skip btree block checks
      xfs: always report scrub errors in tracepoints
      xfs: don't scan across metadata/regular directory trees for dirents
      xfs: don't set a metadata directory's parent to sb_rootino
      xfs: don't rescan ifree and icount when frozen
      xfs: rescan the AGs if incore delalloc counter is negative
      xfs: don't try to repair rtsummary if the summary file isn't computed
      xfs: update quota flags on secondary supers when metadir enabled
      xfs: refactor directory data block walking loops in scrub
      xfs: improve dirent bounds checking in scrub and repair
      xfs: drop unnecessary sa parameter from the xrep_ag init functions
      xfs: drop unnecessary sr parameter from xrep_rtgroup init functions
      xfs: drop unnecessary sa parameter from xchk_ag init functions
      xfs: drop unnecessary sr parameter from xchk_rtgroup init functions
      xfs: refactor inode forkoff to byte conversions

Eric Sandeen (22):
      xfs: remove unused args argument from xfs_attr_node_lookup()
      xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
      xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
      xfs: remove unused mp argument from xfs_exchmaps_check_forks()
      xfs: remove unused mp argument from xfs_inobt_rec_check_count()
      xfs: remove unused mp argument from xfs_parent_finish()
      xfs: remove unused tp argument from xfs_rmap_update_hook()
      xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
      xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
      xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
      xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
      xfs: remove unused mp argument from xfs_verify_dablk()
      xfs: remove unused mp argument from xfs_verify_fileoff()
      xfs: remove unused mp argument from xfs_verify_fileext()
      xfs: share the AG rmap btree with the rt rmap btree
      xfs: share the AG refcount btree with the rt refcount btree
      xfs: validate rc_domain in xchk_rtrefcount_mergeable
      xfs: factor out xfs_dir2_sf_copy_entries helper
      xfs: factor out xrep_reset_fork_to_extents helper for scrub/repair
      xfs: re-use refcount scrub/repair code for rtrefcount
      xfs: add missing cursor status check after xfs_inobt_get_rec
      xfs: add missing cursor stat checks after xfs_btree_delete

Hans Holmberg (1):
      xfs: don't let racing writers consume the free zones reserved for GC

Kefeng Wang (1):
      xfs: fix NOFS state corruption in btree split worker

Pankaj Raghav (1):
      xfs: don't limit software atomic writes by the group alignment

Vincent Mailhol (1):
      block: store GPT attributes as a raw value

Yun Zhou (1):
      xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c

 .../filesystems/xfs/xfs-online-fsck-design.rst     |  13 +-
 block/bio-integrity-fs.c                           |  15 +-
 block/bio-integrity.c                              |   1 +
 block/bio.c                                        | 219 ++++-------
 block/blk-map.c                                    |   2 +-
 block/blk-settings.c                               |   6 +
 block/fops.c                                       |   3 +-
 block/partitions/efi.h                             |   8 +-
 fs/iomap/bio.c                                     |   4 +-
 fs/iomap/direct-io.c                               |  44 +--
 fs/iomap/ioend.c                                   | 120 +++++-
 fs/xfs/libxfs/xfs_alloc.c                          | 106 +++--
 fs/xfs/libxfs/xfs_alloc.h                          |   7 +-
 fs/xfs/libxfs/xfs_attr.c                           |  14 +-
 fs/xfs/{ => libxfs}/xfs_attr_item.h                |   2 -
 fs/xfs/libxfs/xfs_attr_leaf.c                      |  25 +-
 fs/xfs/libxfs/xfs_bmap.c                           |  16 +-
 fs/xfs/libxfs/xfs_bmap.h                           |   8 +-
 fs/xfs/{ => libxfs}/xfs_bmap_item.h                |   2 -
 fs/xfs/libxfs/xfs_btree.c                          |  10 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   6 +-
 fs/xfs/{ => libxfs}/xfs_buf_item.h                 |   2 -
 fs/xfs/libxfs/xfs_da_btree.c                       |  14 +
 fs/xfs/libxfs/xfs_defer.c                          |   1 -
 fs/xfs/libxfs/xfs_dir2_sf.c                        |  68 ++--
 fs/xfs/libxfs/xfs_dquot_buf.c                      |  13 +-
 fs/xfs/{ => libxfs}/xfs_dquot_item.h               |   0
 fs/xfs/libxfs/xfs_errortag.h                       |   6 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |   1 -
 fs/xfs/libxfs/xfs_exchmaps.h                       |   3 +-
 fs/xfs/{ => libxfs}/xfs_exchmaps_item.h            |   2 -
 fs/xfs/{ => libxfs}/xfs_extfree_item.h             |   2 -
 fs/xfs/libxfs/xfs_format.h                         |   6 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  48 ++-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h                   |   5 +-
 fs/xfs/{ => libxfs}/xfs_icreate_item.h             |   0
 fs/xfs/libxfs/xfs_inode_buf.c                      |   7 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/{ => libxfs}/xfs_inode_item.h               |   2 -
 fs/xfs/libxfs/xfs_inode_util.c                     |   3 +-
 fs/xfs/{ => libxfs}/xfs_iunlink_item.h             |   0
 fs/xfs/libxfs/xfs_metadir.c                        |  32 +-
 fs/xfs/libxfs/xfs_metadir.h                        |   5 +-
 fs/xfs/libxfs/xfs_parent.h                         |   1 -
 fs/xfs/libxfs/xfs_refcount.c                       |   1 -
 fs/xfs/libxfs/xfs_refcount_btree.c                 |  16 +-
 fs/xfs/libxfs/xfs_refcount_btree.h                 |  26 ++
 fs/xfs/{ => libxfs}/xfs_refcount_item.h            |   2 -
 fs/xfs/libxfs/xfs_rmap.c                           |  13 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/libxfs/xfs_rmap_btree.h                     |  26 ++
 fs/xfs/{ => libxfs}/xfs_rmap_item.h                |   2 -
 fs/xfs/libxfs/xfs_rtbitmap.c                       |  80 ++--
 fs/xfs/libxfs/xfs_rtbitmap.h                       |  45 +--
 fs/xfs/libxfs/xfs_rtgroup.c                        |   1 -
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               | 121 +-----
 fs/xfs/libxfs/xfs_rtrefcount_btree.h               |   5 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   | 236 +-----------
 fs/xfs/libxfs/xfs_rtrmap_btree.h                   |   3 +-
 fs/xfs/libxfs/xfs_sb.c                             |  41 --
 fs/xfs/libxfs/xfs_sb.h                             |   1 -
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |   2 +-
 fs/xfs/{ => libxfs}/xfs_trans.h                    |  11 +-
 fs/xfs/libxfs/xfs_trans_inode.c                    |   2 -
 fs/xfs/libxfs/xfs_trans_resv.c                     |  45 +--
 fs/xfs/libxfs/xfs_trans_space.c                    |   6 +-
 fs/xfs/libxfs/xfs_types.c                          |   7 +-
 fs/xfs/libxfs/xfs_types.h                          |   7 +-
 fs/xfs/libxfs/xfs_zones.h                          |   6 +
 fs/xfs/scrub/agheader.c                            |  64 +++-
 fs/xfs/scrub/agheader_repair.c                     |  44 ++-
 fs/xfs/scrub/alloc_repair.c                        |  30 +-
 fs/xfs/scrub/attr.c                                | 119 ++++--
 fs/xfs/scrub/attr_repair.c                         |  51 +--
 fs/xfs/scrub/bitmap.c                              |  20 +
 fs/xfs/scrub/bmap.c                                |  31 +-
 fs/xfs/scrub/bmap_repair.c                         |  19 +-
 fs/xfs/scrub/btree.c                               |  20 +-
 fs/xfs/scrub/common.c                              |  57 +--
 fs/xfs/scrub/common.h                              |  46 +--
 fs/xfs/scrub/cow_repair.c                          |  96 +++--
 fs/xfs/scrub/dabtree.c                             |  27 +-
 fs/xfs/scrub/dir.c                                 | 130 ++++++-
 fs/xfs/scrub/dir_repair.c                          | 125 ++++--
 fs/xfs/scrub/dirtree.c                             |   4 +-
 fs/xfs/scrub/dirtree_repair.c                      |  76 +++-
 fs/xfs/scrub/dqiterate.c                           |   1 +
 fs/xfs/scrub/fscounters.c                          |  42 +-
 fs/xfs/scrub/ialloc_repair.c                       |  12 +-
 fs/xfs/scrub/inode.c                               |   8 +-
 fs/xfs/scrub/inode_repair.c                        | 197 +++++++++-
 fs/xfs/scrub/iscan.c                               |   2 +-
 fs/xfs/scrub/metapath.c                            |  17 +-
 fs/xfs/scrub/newbt.c                               |  19 +-
 fs/xfs/scrub/newbt.h                               |   1 -
 fs/xfs/scrub/orphanage.c                           |   2 +-
 fs/xfs/scrub/parent_repair.c                       |   4 +
 fs/xfs/scrub/quota.c                               |  10 +-
 fs/xfs/scrub/quota_repair.c                        |  76 +++-
 fs/xfs/scrub/quotacheck_repair.c                   |  54 ++-
 fs/xfs/scrub/readdir.c                             |   2 +-
 fs/xfs/scrub/reap.c                                |  65 +++-
 fs/xfs/scrub/refcount.c                            |  44 +--
 fs/xfs/scrub/refcount.h                            |  56 +++
 fs/xfs/scrub/refcount_repair.c                     |   7 +-
 fs/xfs/scrub/repair.c                              |  72 +++-
 fs/xfs/scrub/repair.h                              |  14 +-
 fs/xfs/scrub/rgsuper.c                             |  37 +-
 fs/xfs/scrub/rmap_repair.c                         |   8 +-
 fs/xfs/scrub/rtbitmap.c                            |   4 +-
 fs/xfs/scrub/rtbitmap_repair.c                     |  21 +-
 fs/xfs/scrub/rtrefcount.c                          | 273 +------------
 fs/xfs/scrub/rtrefcount_repair.c                   |  50 +--
 fs/xfs/scrub/rtrmap.c                              |   4 +-
 fs/xfs/scrub/rtrmap_repair.c                       |  14 +-
 fs/xfs/scrub/rtsummary.c                           |  13 +-
 fs/xfs/scrub/rtsummary.h                           |   1 +
 fs/xfs/scrub/rtsummary_repair.c                    |  17 +-
 fs/xfs/scrub/scrub.c                               |   6 +-
 fs/xfs/scrub/stats.c                               |   5 +-
 fs/xfs/scrub/symlink.c                             |  17 +-
 fs/xfs/scrub/symlink_repair.c                      |  16 +-
 fs/xfs/scrub/trace.c                               |  13 +
 fs/xfs/scrub/trace.h                               |  10 +-
 fs/xfs/scrub/xfarray.c                             | 205 +++++-----
 fs/xfs/scrub/xfarray.h                             |   9 +-
 fs/xfs/xfs_aops.c                                  |  13 +-
 fs/xfs/xfs_bmap_item.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |  11 +
 fs/xfs/xfs_dquot.c                                 |  20 +-
 fs/xfs/xfs_dquot.h                                 |   2 +-
 fs/xfs/xfs_error.c                                 |  16 +-
 fs/xfs/xfs_error.h                                 |   9 +-
 fs/xfs/xfs_exchmaps_item.c                         |  13 +-
 fs/xfs/xfs_exchrange.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |  36 +-
 fs/xfs/xfs_handle.c                                |   2 +-
 fs/xfs/xfs_inode.c                                 |  20 +-
 fs/xfs/xfs_inode.h                                 |  11 +-
 fs/xfs/xfs_inode_item.c                            |   3 +-
 fs/xfs/xfs_inode_item_recover.c                    |  20 +-
 fs/xfs/xfs_ioctl.c                                 | 425 +++++++++++++--------
 fs/xfs/xfs_ioctl.h                                 |   4 +-
 fs/xfs/xfs_ioctl32.c                               | 188 +++++----
 fs/xfs/xfs_ioend.c                                 | 222 +++++++++--
 fs/xfs/xfs_ioend.h                                 |   2 +
 fs/xfs/xfs_iomap.c                                 |  55 ++-
 fs/xfs/xfs_iops.c                                  |  30 +-
 fs/xfs/xfs_log.c                                   |  86 ++++-
 fs/xfs/xfs_log_cil.c                               |   9 +-
 fs/xfs/xfs_log_priv.h                              |  10 +-
 fs/xfs/xfs_log_recover.c                           |   3 +-
 fs/xfs/xfs_mount.c                                 |  44 ++-
 fs/xfs/xfs_mount.h                                 |  10 +
 fs/xfs/xfs_platform.h                              |   1 +
 fs/xfs/xfs_pnfs.c                                  |  19 +-
 fs/xfs/xfs_qm.c                                    |  42 +-
 fs/xfs/xfs_quota.h                                 |   9 +
 fs/xfs/xfs_rmap_item.c                             |   2 +-
 fs/xfs/xfs_rtalloc.h                               |  49 ++-
 fs/xfs/xfs_super.c                                 |   3 +-
 fs/xfs/xfs_symlink.c                               |   4 +-
 fs/xfs/xfs_sysfs.c                                 |  78 +++-
 fs/xfs/xfs_trace.h                                 |  29 +-
 fs/xfs/xfs_trans.c                                 |   8 +-
 fs/xfs/xfs_trans_dquot.c                           |   6 +-
 fs/xfs/xfs_verify_media.c                          |  87 ++---
 fs/xfs/xfs_zone_alloc.c                            |  40 +-
 include/linux/bio-integrity.h                      |   3 +-
 include/linux/bio.h                                |  11 +-
 include/linux/blkdev.h                             |   8 +-
 include/linux/iomap.h                              |  38 +-
 174 files changed, 3363 insertions(+), 2315 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_attr_item.h (97%)
 rename fs/xfs/{ => libxfs}/xfs_bmap_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_buf_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_dquot_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_exchmaps_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_extfree_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_icreate_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_inode_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_iunlink_item.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_refcount_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_rmap_item.h (98%)
 rename fs/xfs/{ => libxfs}/xfs_trans.h (98%)
 create mode 100644 fs/xfs/scrub/refcount.h"
