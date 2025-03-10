Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B162A17A2E7
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741600182; cv=none; b=sk2VdQ/aeK+4psKhiV2g8tXplZdLvnHDWEsdPobxZYy0zBrUm5ORQ4vc+sx2W8Qdov1zgaL75m3Jbfre6GQGurE4JHXf4fvtA5yekIaz7lhvTsGZGHAb9I2m/2uw5MdkacIwPRvH0EkbJHR8jLB00x+0ybi3iq267qsiE57qswE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741600182; c=relaxed/simple;
	bh=IpwD7yc4Ne52k/s7uJa1r5GOomae4OQjBR7xJEFRYFg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ngVkoW4B/vDiwl5UQlEcc8qBoYXjcXyW37EZPN4PRhb96GqNY5dyfNjcwF3F34RMTvD2d7dRmqGuQmHI6Vp4Y5oFUp7BVU3gq4UU9g/YuJU/qhET32gJWAwhTJ4YMHuJ8UzKc8qedBv4n7qoapUskKXyQ1a9UQSXqRmOFJHDNog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NhpH69XB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NhpH69XB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E444C4CEE5
	for <linux-xfs@vger.kernel.org>; Mon, 10 Mar 2025 09:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741600182;
	bh=IpwD7yc4Ne52k/s7uJa1r5GOomae4OQjBR7xJEFRYFg=;
	h=Date:From:To:Subject:From;
	b=NhpH69XBMWPviAA4HfECXu0Z2Lzwr4OhiF6Tvbdh41c+j+rZWlfi08M3N03KqQePe
	 UW+kec5gSNJxfv4UQtBsgtpm02Nh5RTqLtm5n55WsHuheCduiqELcqv6sWkQP25ymd
	 VKg31tuvEUIrNPtDi5xn35hKwuYyjEPpEnYYZkFM6vf5RcP3Qs4U7dPaC3gyx2FrgH
	 IcCdBsjswDof6Jt+q69G5Hm7m5v15loRF2rMYqhtydA+Vee5vqHGimS3Yc19z7MdIC
	 miqSzImlP5H46ntSfztwMM1ZmGwbeKMJLZwn4udzfQYFCWpTCtSDzKhfI0Rv6SS0tO
	 p4eO7jxoAk2EQ==
Date: Mon, 10 Mar 2025 10:49:36 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 32f6987f9384
Message-ID: <hdj2rsk2nop4ehl2g4frsanl5z2tct7uescj7w76ypmakks6m3@eb5zf53xb62p>
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

This is the first for-next update after the discussion regarding for-next
usage.

This update includes patches for 6.14, for 6.15, and also some patches that were
included in iomap branch, pulled in for-next.

I left the script to generate the log below as-is for now, but I'll see if I can
improve it to only show XFS-related patches, and ignore patches merged from
another repositories.

Comments are welcome.

The new head of the for-next branch is commit:

32f6987f9384 Merge branch 'xfs-6.15-merge' into for-next

97 new commits:

Brian Foster (22):
      [abb0ea1923a6] iomap: factor out iomap length helper
      [2e4b0b6cf533] iomap: split out iomap check and reset logic from iter advance
      [f47998386623] iomap: refactor iomap_iter() length check and tracepoint
      [9183b2a0e439] iomap: lift error code check out of iomap_iter_advance()
      [b26f2ea1cd06] iomap: lift iter termination logic from iomap_iter_advance()
      [b51d30ff51f9] iomap: export iomap_iter_advance() and return remaining length
      [bc264fea0f6f] iomap: support incremental iomap_iter advances
      [1a1a3b574b97] iomap: advance the iter directly on buffered writes
      [e60837da4d9d] iomap: advance the iter directly on unshare range
      [cbad829cef3b] iomap: advance the iter directly on zero range
      [d9dc477ff6a2] iomap: advance the iter directly on buffered read
      [8fecec46d10b] iomap: advance the iter on direct I/O
      [f145377da150] iomap: convert misc simple ops to incremental advance
      [e1e6bae60732] dax: advance the iomap_iter in the read/write path
      [e1dae77b50e3] dax: push advance down into dax_iomap_iter() for read and write
      [80fce3058407] dax: advance the iomap_iter on zero range
      [9ba439cbdcf2] dax: advance the iomap_iter on unshare range
      [39eb05112987] dax: advance the iomap_iter on dedupe range
      [6fe32fe1bbc1] dax: advance the iomap_iter on pte and pmd faults
      [469739f1d8c5] iomap: remove unnecessary advance from iomap_iter()
      [edd3e3b7d210] iomap: rename iomap_iter processed field to status
      [d79c9cc51297] iomap: introduce a full map advance helper

Carlos Maiolino (5):
      [0a1fd78080c8] Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge
      [4c6283ec9284] Merge tag 'xfs-zoned-allocator-2025-03-03' of git://git.infradead.org/users/hch/xfs into xfs-6.15-zoned_devices
      [8657646d116d] Merge branch 'vfs-6.15.iomap' of git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs into xfs-6.15-merge
      [358cab79dd02] Merge branch 'xfs-6.15-zoned_devices' into xfs-6.15-merge
      [32f6987f9384] Merge branch 'xfs-6.15-merge' into for-next

Christian Brauner (7):
      [f87897339a4c] Merge patch series "iomap: allow the file system to submit the writeback bios"
      [30f530096166] Merge patch series "iomap: incremental per-operation iter advance"
      [53cfafdd1530] Merge patch series "iomap: incremental advance conversion -- phase 2"
      [13368df520f1] Merge patch series "iomap: make buffered writes work with RWF_DONTCACHE"
      [51bd73d92f89] Merge branch 'vfs-6.15.shared.iomap' of gitolite.kernel.org:pub/scm/linux/kernel/git/vfs/vfs
      [1743d385e704] Merge branch 'vfs-6.15.shared.iomap' of gitolite.kernel.org:pub/scm/linux/kernel/git/vfs/vfs
      [c7be0d72d551] Merge patch series "iomap preliminaries for large atomic write for xfs with CoW"

Christoph Hellwig (53):
      [c50105933f0c] iomap: allow the file system to submit the writeback bios
      [710273330663] iomap: simplify io_flags and io_type in struct iomap_ioend
      [034c29fb3e7c] iomap: add a IOMAP_F_ANON_WRITE flag
      [5fcbd555d483] iomap: split bios to zone append limits in the submission handlers
      [63b66913d11c] iomap: move common ioend code to ioend.c
      [ae2f33a519af] iomap: factor out a iomap_dio_done helper
      [e523f2d4c974] iomap: optionally use ioends for direct I/O
      [d06244c60aec] iomap: add a io_private field to struct iomap_ioend
      [02b39c4655d5] iomap: pass private data to iomap_page_mkwrite
      [c6d1b8d15450] iomap: pass private data to iomap_zero_range
      [ddd402bbbf66] iomap: pass private data to iomap_truncate_page
      [cc3d2f55c43a] xfs: reflow xfs_dec_freecounter
      [712bae966318] xfs: generalize the freespace and reserved blocks handling
      [c8c4e8bc692a] xfs: support reserved blocks for the rt extent counter
      [a0760cca8e10] xfs: trace in-memory freecounter reservations
      [c0bd736d3384] xfs: fixup the metabtree reservation in xrep_reap_metadir_fsblocks
      [1df8d75030b7] xfs: make metabtree reservations global
      [272e20bb24dc] xfs: reduce metafile reservations
      [a581de0d613a] xfs: factor out a xfs_rt_check_size helper
      [012482b3308a] xfs: add a rtg_blocks helper
      [7c879c8275c0] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
      [8ae4c8cec0bb] xfs: skip always_cow inodes in xfs_reflink_trim_around_shared
      [6fff175279e4] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write
      [f42c652434de] xfs: support XFS_BMAPI_REMAP in xfs_bmap_del_extent_delay
      [aacde95a3716] xfs: add a xfs_rtrmap_highest_rgbno helper
      [2167eaabe2fa] xfs: define the zoned on-disk format
      [bdc03eb5f98f] xfs: allow internal RT devices for zoned mode
      [1fd8159e7ca4] xfs: export zoned geometry via XFS_FSOP_GEOM
      [1d319ac6fe1b] xfs: disable sb_frextents for zoned file systems
      [f044dda35124] xfs: disable FITRIM for zoned RT devices
      [fc04408c4718] xfs: don't call xfs_can_free_eofblocks from ->release for zoned inodes
      [0cb53d773bba] xfs: skip zoned RT inodes in xfs_inodegc_want_queue_rt_file
      [720c2d583483] xfs: parse and validate hardware zone information
      [4e4d52075577] xfs: add the zoned space allocator
      [0bb2193056b5] xfs: add support for zoned space reservations
      [080d01c41d44] xfs: implement zoned garbage collection
      [058dd70c65ab] xfs: implement buffered writes to zoned RT devices
      [2e2383405824] xfs: implement direct writes to zoned RT devices
      [859b692711c6] xfs: wire up zoned block freeing in xfs_rtextent_free_finish_item
      [55ef6e7a401f] xfs: hide reserved RT blocks from statfs
      [01b71e64bb87] xfs: support growfs on zoned file systems
      [1cf4554e7bd8] xfs: allow COW forks on zoned file systems in xchk_bmap
      [48b9ac681995] xfs: support xchk_xref_is_used_rt_space on zoned file systems
      [14d355dceca2] xfs: support xrep_require_rtext_inuse on zoned file systems
      [e50ec7fac81a] xfs: enable fsmap reporting for internal RT devices
      [af4f88330df3] xfs: disable reflink for zoned file systems
      [ad35e362bfac] xfs: disable rt quotas for zoned file systems
      [be458049ffe3] xfs: enable the zoned RT device feature
      [97c69ba1c08d] xfs: support zone gaps
      [7452a6daf9f9] xfs: add a max_open_zones mount option
      [099bf44f9c90] xfs: wire up the show_stats super operation
      [243f40d0c776] xfs: contain more sysfs code in xfs_sysfs.c
      [9c477912b2f5] xfs: export max_open_zones in sysfs

Hans Holmberg (2):
      [64d0361114fd] xfs: support write life time based data placement
      [5443041b9c63] xfs: export zone stats in /proc/*/mountstats

Jens Axboe (4):
      [b194bc4efae9] iomap: make buffered writes work with RWF_DONTCACHE
      [d47c670061b5] xfs: flag as supporting FOP_DONTCACHE
      [b2cd5ae693a3] iomap: make buffered writes work with RWF_DONTCACHE
      [974c5e6139db] xfs: flag as supporting FOP_DONTCACHE

John Garry (2):
      [b4de0e9be963] iomap: Rename IOMAP_ATOMIC -> IOMAP_ATOMIC_HW
      [794ca29dcc92] iomap: Support SW-based atomic writes

Matthew Wilcox (Oracle) (1):
      [5d138b6fb4da] xfs: Use abs_diff instead of XFS_ABSDIFF

Ritesh Harjani (IBM) (1):
      [786e3080cbe9] iomap: Lift blocksize restriction on atomic writes

Code Diffstat:

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
 fs/xfs/libxfs/xfs_alloc.c                      |    8 +-
 fs/xfs/libxfs/xfs_bmap.c                       |  316 +------
 fs/xfs/libxfs/xfs_bmap.h                       |    7 +-
 fs/xfs/libxfs/xfs_format.h                     |   20 +-
 fs/xfs/libxfs/xfs_fs.h                         |   14 +-
 fs/xfs/libxfs/xfs_group.h                      |   31 +-
 fs/xfs/libxfs/xfs_ialloc.c                     |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c                  |   21 +-
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
 fs/xfs/libxfs/xfs_sb.c                         |   82 +-
 fs/xfs/libxfs/xfs_types.h                      |   28 +
 fs/xfs/libxfs/xfs_zones.c                      |  186 ++++
 fs/xfs/libxfs/xfs_zones.h                      |   35 +
 fs/xfs/scrub/agheader.c                        |    2 +
 fs/xfs/scrub/bmap.c                            |    4 +-
 fs/xfs/scrub/fscounters.c                      |   22 +-
 fs/xfs/scrub/fscounters_repair.c               |   12 +-
 fs/xfs/scrub/inode.c                           |    7 +
 fs/xfs/scrub/inode_repair.c                    |    4 +-
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
 fs/xfs/xfs_discard.c                           |    3 +-
 fs/xfs/xfs_extent_busy.c                       |    2 +-
 fs/xfs/xfs_extfree_item.c                      |   35 +-
 fs/xfs/xfs_file.c                              |  351 ++++++-
 fs/xfs/xfs_fsmap.c                             |   86 +-
 fs/xfs/xfs_fsops.c                             |   50 +-
 fs/xfs/xfs_fsops.h                             |    3 +-
 fs/xfs/xfs_icache.c                            |    6 +-
 fs/xfs/xfs_inode.c                             |    3 +-
 fs/xfs/xfs_inode.h                             |   28 +-
 fs/xfs/xfs_inode_item.c                        |    1 +
 fs/xfs/xfs_inode_item_recover.c                |    1 +
 fs/xfs/xfs_ioctl.c                             |   12 +-
 fs/xfs/xfs_iomap.c                             |  528 ++++++++++-
 fs/xfs/xfs_iomap.h                             |    7 +-
 fs/xfs/xfs_iops.c                              |   31 +-
 fs/xfs/xfs_log.c                               |    4 +
 fs/xfs/xfs_message.c                           |    4 +
 fs/xfs/xfs_message.h                           |    1 +
 fs/xfs/xfs_mount.c                             |  206 ++--
 fs/xfs/xfs_mount.h                             |  131 ++-
 fs/xfs/xfs_qm.c                                |    3 +-
 fs/xfs/xfs_reflink.c                           |   18 +-
 fs/xfs/xfs_rtalloc.c                           |  237 +++--
 fs/xfs/xfs_rtalloc.h                           |    5 -
 fs/xfs/xfs_super.c                             |  165 +++-
 fs/xfs/xfs_sysfs.c                             |   75 +-
 fs/xfs/xfs_sysfs.h                             |    5 +-
 fs/xfs/xfs_trace.c                             |    2 +
 fs/xfs/xfs_trace.h                             |  214 ++++-
 fs/xfs/xfs_zone_alloc.c                        | 1211 ++++++++++++++++++++++++
 fs/xfs/xfs_zone_alloc.h                        |   70 ++
 fs/xfs/xfs_zone_gc.c                           | 1165 +++++++++++++++++++++++
 fs/xfs/xfs_zone_info.c                         |  105 ++
 fs/xfs/xfs_zone_priv.h                         |  119 +++
 fs/xfs/xfs_zone_space_resv.c                   |  253 +++++
 fs/zonefs/file.c                               |    2 +-
 include/linux/iomap.h                          |  118 ++-
 93 files changed, 6400 insertions(+), 1398 deletions(-)
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
