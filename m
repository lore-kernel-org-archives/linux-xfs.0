Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741A42E06D2
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789643061; cv=none; b=VJutOYXVv4V3xcgJsf29mOMEcDGXcZO/wR2/lwFxv1efEARTF2h3dC53+4AZNlB16stRdVHOr21IbX8PtkUFYCqAIpPmYEPJLm2SEMXn6Zp0YNSU38cW35MnKlfKsqS11KxVo5KSb630trGF6xqnELuesubs6O/AycGcwkPunBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789643061; c=relaxed/simple;
	bh=38rN4dDeaf1EdcXsEwUDqAiZOmlJCAKmIF4u80b3G1U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tFjbVAHiBSdBZnbjFylBexew7ndRxcLtVGgcZYWFwFBRDgxvV6wKcPNw5LvZy0MRljsYWpONga6OeSHE9apdoiaW3CHYKwx3vMUzRrY5+nwq1oRebwwP1iGjtqUML5uTH3sdiT7hnYzoNZ5AiqxieV95VSWHcXc7JjLXrsJXaIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bj/zZwIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bj/zZwIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C001F00893
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 11:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789643053;
	bh=u43D8xWLHnjDpJxpUHeQrWuYenDTgnpeEpGG0jleIVU=;
	h=Date:From:To:Subject;
	b=Bj/zZwIYlcWiaU+e31A4+XJzh6QvbTrLCV9syqu7brzfJeSVRobmLEPx9I+kqoxfF
	 LBNvnHtdmA+1ASZvVc969h0QcFcxgAAuqD2ZE0qxTJU3OPZ+gfRMK4M8uic0aB4RCN
	 RIa1fI4wkrFtoFn4541JoQcqxDuhdQWgYP2psFAZZe2Ns1O6JZEXktVVkCRaoBMbR4
	 HcG8/FbSbDKstZK1YcdSH6T0XHiG2ytgERHtwOy9ENy3ukgW8dHX66i4Uu1ZN0hQC3
	 vEgrujRIw46DrvrlA732leJHWVAFYmQ/YiwcC5gzaMIVhtJUr+TqKlEBcYvJsgdKCM
	 4DYjGBpSIjlyQ==
Date: Thu, 17 Sep 2026 13:04:10 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next *REBASED* to 1c1058646d3b
Message-ID: <aqvI3wtcmrprZIIt@nidhogg.toxiclabs.cc>
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

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

1c1058646d3b xfs: remove unused mp argument from xfs_verify_fileext()

58 new commits:

Aditya Prakash Srivastava (1):
      [c1070e44033a] xfs: prevent close() from hanging on frozen filesystems

Anuj Gupta (1):
      [c16b885ad6b5] xfs: remove unused xfs_reflink_remap_range declaration

Christoph Hellwig (18):
      [14e379600d3e] xfs: don't try to get a reference to a NULL oz in xfs_get_cached_zone
      [c9096d7595b9] xfs: convert all !XFS_RT stubs to inline functions
      [345a1f9929bd] xfs: remove an outdated comment above xfs_file_ioctl
      [da8c47c24498] xfs: rename xfs_ioc_swapext to xfs_swapext
      [0018d49c3844] xfs: rename xfs_ioctl_fs_counts to xfs_ioc_fs_counts
      [5703154167aa] xfs: rename xfs_ioctl_getset_resblocks to xfs_ioc_getset_resblocks
      [79417ad07f90] xfs: split out the handler for XFS_IOC_DIOINFO
      [1300f918c972] xfs: split out the handlers for XFS_IOC_.*HANDLE
      [f7e07ea82396] xfs: split out the handler for XFS_IOC_SWAPEXT
      [71a7d9bdb8f4] xfs: split out the handlers for XFS_IOC_FSGROWFS*
      [1e787c1e5777] xfs: split out the handler for XFS_IOC_GOINGDOWN
      [809f7f37c83c] xfs: split out the handler for XFS_IOC_ERROR_INJECTION
      [284fac26cced] xfs: split out the handler for XFS_IOC_FREE_EOFBLOCKS
      [d6040e8c186a] xfs: split out the handlers for XFS_IOC_FSGROWFS_*_32
      [3b26e116e828] xfs: cleanup XFS_IOC_GETVERSION_32 handling
      [75331a4bd410] xfs: split out the handlers for XFS_IOC_SWAPEXT_32
      [3724aef91a0f] xfs: split out the handlers for XFS_IOC_*_BY_HANDLE_32
      [fa93b3a499e1] xfs: remove an extra cast in xfs_file_compat_ioctl

Darrick J. Wong (22):
      [5b644229bd67] xfs: guard against igrab failure in xrep_findparent_from_dcache
      [afbccf99f7f8] xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY scans return corruption
      [bb991b7f79dd] xfs: fix attr fork block count checks in xrep_inode_blockcounts
      [1c32cdc98646] xfs: release orphanage dir inode if chown fails
      [8b4ad2814274] xfs: release AGFL after walking it during rmapbt repair
      [984aab2d905a] xfs: use correct jiffies comparison function in xchk_maybe_relax
      [3083ba8dde76] xfs: check padding field in xfs_ioc_commit_range
      [8fc18580ec17] xfs: don't call xfs_exchange_range_finish for a dry run
      [471e0b6e2dda] xfs: use the correct reservations for rtrmap/refcount recovery
      [46c1b6674a7b] xfs: fix integer overflows in xbitmap set functions
      [c54110d814c3] xfs: only flag zero padding for dir3 data blocks, not dir3 block blocks
      [e9193f2f1ce3] xfs: check di_forkoff correctly in scrub
      [065f3ce5936e] xfs: call xfs_dquot_set_prealloc_limits if we installed default rtb limits
      [41c4c41cf6c4] xfs: fix rtgroup repair estimations
      [d7b92cbe566f] xfs: don't cross reference rmapbt with bitmaps if they're incomplete
      [ab1c416d2377] xfs: don't let memory failures leak blocks and kill repairs
      [d80993655f7b] xfs: don't merge different file IO error types
      [f8f6382ff131] xfs: fix blockgc group quota scanning when usrquota isn't enforced
      [65f39d09d737] xfs: fix cursor and pointer handling when recovering iunlink buckets
      [ffb48dccce19] xfs: drop dquot flush lock when we can't find a buffer to flush
      [476582d754cd] xfs: don't let hidden_space go negative in xfs_metafile_resv_init
      [fe2f9135df43] xfs: fix wild memcpy access when formatting ondisk rtrefcount btree roots

Eric Sandeen (14):
      [9821d9dfca71] xfs: remove unused args argument from xfs_attr_node_lookup()
      [168757e7d709] xfs: remove unused rsvd argument from xfs_bmap_add_attrfork()
      [0d498f3385e5] xfs: remove unused mp and ops arguments from xfbtree_rec_bytes()
      [4f4f0e78aab5] xfs: remove unused mp argument from xfs_exchmaps_check_forks()
      [383641abd3cc] xfs: remove unused mp argument from xfs_inobt_rec_check_count()
      [76a2796d4a67] xfs: remove unused mp argument from xfs_parent_finish()
      [da86bd00b853] xfs: remove unused tp argument from xfs_rmap_update_hook()
      [4e7d4c62ab0e] xfs: remove unused mp argument from xfs_rtrefcount_broot_space_calc()
      [0f08a3703f5f] xfs: remove unused mp argument from xfs_rtrefcount_broot_space()
      [1eaea71e8b99] xfs: remove unused mp argument from xfs_rtrmap_broot_space_calc()
      [be0168dffd69] xfs: remove unused mp argument from xfs_calc_default_atomic_ioend_reservation()
      [323b208c3c38] xfs: remove unused mp argument from xfs_verify_dablk()
      [06a83d006c8c] xfs: remove unused mp argument from xfs_verify_fileoff()
      [1c1058646d3b] xfs: remove unused mp argument from xfs_verify_fileext()

Hemanth Selam (1):
      [2f3c2a6f963e] xfs: fix typos and repeated words in comments

Jiangshan Yi (1):
      [ce2b91bebc7b] xfs: remove duplicate INO1_WRITTEN check

Code Diffstat:

 fs/xfs/libxfs/xfs_ag.h               |   2 +-
 fs/xfs/libxfs/xfs_alloc.c            |   4 +-
 fs/xfs/libxfs/xfs_attr.c             |  14 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        |   2 +-
 fs/xfs/libxfs/xfs_bmap.c             |   5 +-
 fs/xfs/libxfs/xfs_bmap.h             |   2 +-
 fs/xfs/libxfs/xfs_btree_mem.c        |   6 +-
 fs/xfs/libxfs/xfs_errortag.h         |   2 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |  13 +-
 fs/xfs/libxfs/xfs_exchmaps.h         |   3 +-
 fs/xfs/libxfs/xfs_format.h           |   2 +-
 fs/xfs/libxfs/xfs_ialloc.c           |   2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c     |   1 -
 fs/xfs/libxfs/xfs_ialloc_btree.h     |   5 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |   2 +-
 fs/xfs/libxfs/xfs_metadir.c          |   2 +-
 fs/xfs/libxfs/xfs_metafile.c         |   8 +-
 fs/xfs/libxfs/xfs_parent.h           |   1 -
 fs/xfs/libxfs/xfs_rmap.c             |  13 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  12 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |   5 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   6 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.h     |   3 +-
 fs/xfs/libxfs/xfs_trans_resv.c       |   7 +-
 fs/xfs/libxfs/xfs_types.c            |   7 +-
 fs/xfs/libxfs/xfs_types.h            |   7 +-
 fs/xfs/scrub/agheader_repair.c       |   2 +-
 fs/xfs/scrub/alloc_repair.c          |   2 +-
 fs/xfs/scrub/bitmap.c                |  26 ++-
 fs/xfs/scrub/bmap.c                  |  11 +-
 fs/xfs/scrub/bmap_repair.c           |   4 +-
 fs/xfs/scrub/dir.c                   |   2 +-
 fs/xfs/scrub/dirtree.c               |   2 +-
 fs/xfs/scrub/findparent.c            |   3 +
 fs/xfs/scrub/health.c                |   6 +-
 fs/xfs/scrub/inode.c                 |   2 +-
 fs/xfs/scrub/inode_repair.c          |   8 +-
 fs/xfs/scrub/newbt.c                 |   8 +-
 fs/xfs/scrub/orphanage.c             |   8 +-
 fs/xfs/scrub/quota.c                 |   2 +-
 fs/xfs/scrub/quota_repair.c          |   4 +-
 fs/xfs/scrub/reap.c                  |   2 +-
 fs/xfs/scrub/repair.c                |  19 +-
 fs/xfs/scrub/rmap.c                  |  20 +-
 fs/xfs/scrub/rmap_repair.c           |   1 +
 fs/xfs/scrub/rtrefcount_repair.c     |   3 +-
 fs/xfs/scrub/rtrmap_repair.c         |   2 +-
 fs/xfs/scrub/scrub.h                 |   2 +-
 fs/xfs/scrub/trace.h                 |  12 +-
 fs/xfs/xfs_bmap_item.c               |   4 +-
 fs/xfs/xfs_dquot.c                   |   8 +-
 fs/xfs/xfs_exchmaps_item.c           |   4 +-
 fs/xfs/xfs_exchrange.c               |  15 +-
 fs/xfs/xfs_file.c                    |  22 +-
 fs/xfs/xfs_healthmon.c               |   4 +-
 fs/xfs/xfs_icache.c                  |   2 +-
 fs/xfs/xfs_inode.c                   |  22 +-
 fs/xfs/xfs_ioctl.c                   | 385 +++++++++++++++++++++--------------
 fs/xfs/xfs_ioctl.h                   |   4 +-
 fs/xfs/xfs_ioctl32.c                 | 188 +++++++++--------
 fs/xfs/xfs_log_cil.c                 |   2 +-
 fs/xfs/xfs_log_recover.c             |  13 +-
 fs/xfs/xfs_platform.h                |   2 +-
 fs/xfs/xfs_qm.c                      |  10 +-
 fs/xfs/xfs_refcount_item.c           |   8 +-
 fs/xfs/xfs_reflink.h                 |   3 -
 fs/xfs/xfs_rmap_item.c               |  10 +-
 fs/xfs/xfs_rtalloc.h                 |  49 ++++-
 fs/xfs/xfs_super.c                   |   2 +-
 fs/xfs/xfs_symlink.c                 |   4 +-
 fs/xfs/xfs_zone_alloc.c              |   4 +-
 fs/xfs/xfs_zone_gc.c                 |   2 +-
 72 files changed, 614 insertions(+), 440 deletions(-)
