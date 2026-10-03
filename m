Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9892F3FBB46
	for <linux-xfs@vger.kernel.org>; Sat,  3 Oct 2026 12:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791028874; cv=none; b=ZHdxQw85XKBtUTPeG5LROs5mgyu2oivfxo0EoPQCT8NVXbM5EZ4NN2t7KCe8OUQEHoWwxKsttox75yGR1B9q1g9YF3VTejf1WqN1a9S7w0BLmj8tG7USozSc8H0aYD6vqzSBQGR4Bp2v9YzZgoiJbm1+FRoA+I25jAbTBUhY2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791028874; c=relaxed/simple;
	bh=hgH6dV0QKwE7GmRHQ/pz7JD1wyFK7XSE+KNdlOlS9Qk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cEQ8Li4rnWWBYi0fH1RNSIn4DhprbHx5bCzrIZbWpN96n6Q3JSKgkuYgn/5ExfCtOzHNOTkVGPxCNDdyGbsOyr5K17bxkQyrQCCGcZhr8D0l7mYkRz0Uk/kJX/+y++xTAbgua+FfG0wNopjYGKy8edIIAe8HA5SEEVz2FnhgGiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAumwP/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAumwP/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9F91F0089B
	for <linux-xfs@vger.kernel.org>; Sat,  3 Oct 2026 12:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791028873;
	bh=FpAL4AvcWSuvCeoRbDbxxz3TkdYZK1yHJLfWWo/QHAQ=;
	h=Date:From:To:Subject;
	b=TAumwP/Nz0XZS2lDYgY9u9yYhHXc7GAxj2Mrr9sD/LoelIEH2Rj3rluGUGQ+tDx4o
	 UKu8ikO3F6AGumvZ3w5prHFDA20/kt1X7MC7ExTwIv6D6lUMmvfqCKYJpfmI36HqE2
	 VBU/umAmdVdo5lGjsxRG3dqM7fJLkOPIZV1snbRUL8Poy5n8osvt//2euqJNEj/oj9
	 3HUe8AoRfqlwaVbuUJNy47zEiZuEfNqM4AXi3OAHJwaKKtYEbOJZ7+PzDokvB6Zc+A
	 pgbFsfjxk0oMsBkFfjXmOkSQG5M8LKKcqPkVdsX5GIHqeJMU8GEv80H2VsEvSAlMiC
	 V5Cbm4s83cY0g==
Date: Sat, 3 Oct 2026 14:01:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next rebased to 6b162dab8b76
Message-ID: <asDthUir0Ney-sze@nidhogg.toxiclabs.cc>
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

has just been rebased.

This is the current state of patches queued for 7.4 merge window. No
more patches will be going into 7.3 RCs unless something urgent comes
in.

Also as noted below, I also have merged Axboe's lazy bounce buffering
branch into xfs as this is a pre-req for some of the upcoming patches.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

6b162dab8b76 Merge remote-tracking branch 'linux-axboe/for-7.4/lazy-bounce-buffering' into xfs-7.4-merge

72 new commits:

Aditya Prakash Srivastava (1):
      [b3ddda322192] xfs: prevent close() from hanging on frozen filesystems

Carlos Maiolino (1):
      [6b162dab8b76] Merge remote-tracking branch 'linux-axboe/for-7.4/lazy-bounce-buffering' into xfs-7.4-merge

Christoph Hellwig (25):
      [d457743d0055] iomap: add a IOMAP_IOEND_INTEGRITY flag
      [d3f30d94f1d9] iomap,xfs: move T10 PI handling for direct I/O into ->submit_io
      [793875070ab1] xfs: move PI generation into xfs_submit_zoned_bio
      [b69e24b7507c] xfs: use BIO_COMPLETE_IN_TASK for bounce buffered read I/Os
      [85fa731672d1] iomap,xfs: move integrity verification to the file system
      [a9a7b9e8686d] xfs: add support for lazy direct read bounce buffering
      [c7bfe2427953] xfs: add error injection for lazy bounce buffering
      [9fae7cbc54a5] xfs: log a message at mount time when using integrity protection
      [1bb7edd5bc4d] xfs: convert all !XFS_RT stubs to inline functions
      [ff2a4c988aff] xfs: remove an outdated comment above xfs_file_ioctl
      [3971243de212] xfs: rename xfs_ioc_swapext to xfs_swapext
      [1e4261a67989] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [35140faca278] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [acc2fac41094] xfs: split out the handler for XFS_IOC_DIOINFO
      [eb192c2925ae] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [ce519c04b51f] xfs: split out the handler for XFS_IOC_SWAPEXT
      [c11d2698f722] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [2516ea28aef3] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [232edc8c7616] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [5c66e713ae5f] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [bce4cb61fe03] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [dd570b3a17a9] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [0ec41ad27718] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [e3adbae8c875] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [0711e6b02b1b] xfs: remove an extra cast in xfs_file_compat_ioctl

Darrick J. Wong (13):
      [6620025ff272] xfs: fix missing xfs_qm_adjust_dqlimits call in quotacheck repair
      [2d72322bb2b7] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
      [9d13120c3446] xfs: fix buffer overruns in xfs_ioc_attr_list
      [37340d63ac1c] xfs: clean up after failed metafile relinking
      [25ba4acda6be] xfs: pass xfs_trans_resv object to reservation calculation helpers
      [a4d5e116f039] xfs: fix xfs_rename_space_res for non-pptr filesystems
      [469b4879f752] xfs: fix ondisk symlink target validation in xrep_dinode_check_dfork
      [713053a89e13] xfs: add missing healthmon trace strings
      [fdadc158cfbd] xfarray: don't crash when sorting if array element crosses a folio
      [c49f46a0cbcc] xfarray: don't allow users to unset in the middle of an array
      [c7a7aa2c2bcf] xfs: don't allow sorting sparse arrays
      [afbe48d6f8e8] xfs: simply the free space btree repair code
      [e22e1ac1f07e] xfarray: warn against sorting arrays with identical elements

Eric Sandeen (16):
      [9270eaecd352] xfs: remove unused args argument from xfs_attr_node_lookup()
      [0e35df96a865] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
      [9c1c0df2a5e9] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
      [b243258ac661] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
      [b580efface8e] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
      [c4b93433664c] xfs: remove unused mp argument from xfs_parent_finish()
      [e8b9abe5056d] xfs: remove unused tp argument from xfs_rmap_update_hook()
      [2c47857fdb47] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
      [a13ad9767995] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
      [45ac5db8634d] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
      [ea3393aef6c9] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
      [7d81a6ca9c4c] xfs: remove unused mp argument from xfs_verify_dablk()
      [0b73963b6ba1] xfs: remove unused mp argument from xfs_verify_fileoff()
      [06de4ce8069a] xfs: remove unused mp argument from xfs_verify_fileext()
      [a3b8a040d100] xfs: share the AG rmap btree with the rt rmap btree
      [acd88740eb9a] xfs: share the AG refcount btree with the rt refcount btree

Kefeng Wang (1):
      [26f42375404e] xfs: fix NOFS state corruption in btree split worker

Yun Zhou (1):
      [435dc35cc916] xfs: move xfs_sync_sb_buf() out of libxfs into xfs_ioctl.c

Code Diffstat:

 .../filesystems/xfs/xfs-online-fsck-design.rst     |  13 +-
 fs/xfs/libxfs/xfs_attr.c                           |  14 +-
 fs/xfs/libxfs/xfs_bmap.c                           |   5 +-
 fs/xfs/libxfs/xfs_bmap.h                           |   2 +-
 fs/xfs/libxfs/xfs_btree.c                          |  10 +-
 fs/xfs/libxfs/xfs_btree_mem.c                      |   6 +-
 fs/xfs/libxfs/xfs_dquot_buf.c                      |  13 +-
 fs/xfs/libxfs/xfs_errortag.h                       |   6 +-
 fs/xfs/libxfs/xfs_exchmaps.c                       |   1 -
 fs/xfs/libxfs/xfs_exchmaps.h                       |   3 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h                   |   5 +-
 fs/xfs/libxfs/xfs_inode_fork.c                     |   4 +-
 fs/xfs/libxfs/xfs_metadir.c                        |  32 +-
 fs/xfs/libxfs/xfs_metadir.h                        |   5 +-
 fs/xfs/libxfs/xfs_parent.h                         |   1 -
 fs/xfs/libxfs/xfs_refcount_btree.c                 |  16 +-
 fs/xfs/libxfs/xfs_refcount_btree.h                 |  26 ++
 fs/xfs/libxfs/xfs_rmap.c                           |  13 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |  16 +-
 fs/xfs/libxfs/xfs_rmap_btree.h                     |  26 ++
 fs/xfs/libxfs/xfs_rtrefcount_btree.c               | 121 +-----
 fs/xfs/libxfs/xfs_rtrefcount_btree.h               |   5 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c                   | 236 +-----------
 fs/xfs/libxfs/xfs_rtrmap_btree.h                   |   3 +-
 fs/xfs/libxfs/xfs_sb.c                             |  40 --
 fs/xfs/libxfs/xfs_sb.h                             |   1 -
 fs/xfs/libxfs/xfs_symlink_remote.c                 |   8 +-
 fs/xfs/libxfs/xfs_symlink_remote.h                 |   2 +-
 fs/xfs/libxfs/xfs_trans_resv.c                     |  45 +--
 fs/xfs/libxfs/xfs_trans_space.c                    |   6 +-
 fs/xfs/libxfs/xfs_types.c                          |   7 +-
 fs/xfs/libxfs/xfs_types.h                          |   7 +-
 fs/xfs/scrub/alloc_repair.c                        |  15 +-
 fs/xfs/scrub/bmap.c                                |  11 +-
 fs/xfs/scrub/bmap_repair.c                         |   4 +-
 fs/xfs/scrub/inode_repair.c                        |  32 +-
 fs/xfs/scrub/orphanage.c                           |   2 +-
 fs/xfs/scrub/quota.c                               |   2 +-
 fs/xfs/scrub/quota_repair.c                        |   9 +-
 fs/xfs/scrub/quotacheck_repair.c                   |  54 ++-
 fs/xfs/scrub/rtrefcount_repair.c                   |   3 +-
 fs/xfs/scrub/rtrmap_repair.c                       |   2 +-
 fs/xfs/scrub/xfarray.c                             | 201 ++++------
 fs/xfs/scrub/xfarray.h                             |   9 +-
 fs/xfs/xfs_aops.c                                  |  13 +-
 fs/xfs/xfs_bmap_item.c                             |   2 +-
 fs/xfs/xfs_buf.c                                   |  11 +
 fs/xfs/xfs_dquot.c                                 |  20 +-
 fs/xfs/xfs_dquot.h                                 |   2 +-
 fs/xfs/xfs_exchmaps_item.c                         |   4 +-
 fs/xfs/xfs_exchrange.c                             |   2 +-
 fs/xfs/xfs_file.c                                  |  33 +-
 fs/xfs/xfs_handle.c                                |   2 +-
 fs/xfs/xfs_inode.c                                 |  20 +-
 fs/xfs/xfs_ioctl.c                                 | 425 +++++++++++++--------
 fs/xfs/xfs_ioctl.h                                 |   4 +-
 fs/xfs/xfs_ioctl32.c                               | 188 +++++----
 fs/xfs/xfs_ioend.c                                 | 137 ++++++-
 fs/xfs/xfs_ioend.h                                 |   2 +
 fs/xfs/xfs_mount.h                                 |   8 +
 fs/xfs/xfs_qm.c                                    |   6 +-
 fs/xfs/xfs_rmap_item.c                             |   2 +-
 fs/xfs/xfs_rtalloc.h                               |  49 ++-
 fs/xfs/xfs_super.c                                 |   3 +-
 fs/xfs/xfs_symlink.c                               |   4 +-
 fs/xfs/xfs_sysfs.c                                 |  78 +++-
 fs/xfs/xfs_trace.h                                 |  29 +-
 fs/xfs/xfs_trans_dquot.c                           |   6 +-
 fs/xfs/xfs_zone_alloc.c                            |   4 +
 71 files changed, 1131 insertions(+), 968 deletions(-)
