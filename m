Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5AA23098A
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736850420; cv=none; b=R3ymmLy7rxn+u3mkS8dcHdUrowvlaEe1rl8ivxVdIv7xT5dTexHJFvYeYJ/YgDjZytbuWoPgIFs9N7A9YZtu3misnm4if1pnVkLGlTirqGWcf8rHbTc3L9g016cIyLeYdnbN9SjWsK54iAlJ1fd1OpZ6NoypsrqYSX0VGGEUaq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736850420; c=relaxed/simple;
	bh=NN6FfZvoDSx6X7tqsu8aEp9rzvL1VnjPnOyoyd+T9y0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qQmJT6XhgUanp6/7rFi0YSBTtyhEKYzYGLREj+vzWrVVE/ck01O6LD81686xanBx6f7eoF/ly2ou7eFyqo1zHzr+p4FJU8r3flnAe1ERUCwHEzG/iFrU8HZsC2+hYvBV+1rlr57YL0/Ll+qpNkbFqvP6HOqFilOfWsSwVlw27N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAswCiSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAswCiSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA25C4CEDD
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736850420;
	bh=NN6FfZvoDSx6X7tqsu8aEp9rzvL1VnjPnOyoyd+T9y0=;
	h=Date:From:To:Subject:From;
	b=ZAswCiScMd9yKr3/KpusiSE5zS63LA29m27MOfwmBlvLqo+uj4I8TzHdeGfq/V3MR
	 jcOKpo1z5LE6+ocAYtqFHbZscOXh0z410J9etZjiTMhuJhGGxhJEoTlAfJW2PksFDZ
	 d+5pKug3ETHOzdSWfC0DoYnqMhpShiD+xH6fqIPc4yC57xdy3apaY00UKRivPKAsiB
	 McG05hqdYLYwGDUXKvIXKKhBXitoxeryJfDSfxgyS4XhF1s2t/0RvPjK6aK1sN66Rj
	 ovFaRT7exZBmL7BC3lV8qBYl+obWT/TQ/yabWKwnUbgwSxj6ZfyFIJRLjyGkvZ/Dn4
	 BV5zq+zo5T2cw==
Date: Tue, 14 Jan 2025 11:26:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 9d9b72472631
Message-ID: <q375pb7cshaauinadcych7ax62id7afouvxg4ym6ofrete4bib@zpw6fu4hzclc>
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

9d9b72472631 xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()

109 new commits:

Carlos Maiolino (5):
      [69bf6cd7f38d] Merge tag 'xfs-6.13-fixes_2024-12-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into for-next
      [9a2ce7254c1e] Merge tag 'btree-ifork-records_2024-12-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into for-next
      [8a092f440e03] Merge tag 'reserve-rt-metadata-space_2024-12-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into for-next
      [a938bbe4739f] Merge tag 'realtime-rmap_2024-12-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into for-next
      [156d1c389c54] Merge tag 'realtime-reflink_2024-12-23' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into for-next

Christoph Hellwig (8):
      [4e87047539c7] xfs: refactor xfs_reflink_find_shared
      [23ebf6392598] xfs: mark xfs_dir_isempty static
      [415dee1e06da] xfs: remove XFS_ILOG_NONCORE
      [471511d6ef7d] xfs: remove the t_magic field in struct xfs_trans
      [f4752daf472b] xfs: fix the comment above xfs_discard_endio
      [72843ca62417] xfs: don't take m_sb_lock in xfs_fs_statfs
      [dd324cb79e54] xfs: refactor xfs_fs_statfs
      [183d988ae9e7] xfs: constify feature checks

Darrick J. Wong (91):
      [4b8d867ca6e2] xfs: don't over-report free space or inodes in statvfs
      [4f13f0a3fc6a] xfs: tidy up xfs_iroot_realloc
      [1aacd3fac248] xfs: release the dquot buf outside of qli_lock
      [6c1c55ac3c05] xfs: refactor the inode fork memory allocation functions
      [6a92924275ec] xfs: make xfs_iroot_realloc take the new numrecs instead of deltas
      [eb9bff22311c] xfs: make xfs_iroot_realloc a bmap btree function
      [c914081775e2] xfs: tidy up xfs_bmap_broot_realloc a bit
      [7708951ae521] xfs: hoist the node iroot update code out of xfs_btree_new_iroot
      [505248719fcb] xfs: hoist the node iroot update code out of xfs_btree_kill_iroot
      [af32541081ed] xfs: add some rtgroup inode helpers
      [d415fb34b4c2] xfs: prepare rmap btree cursor tracepoints for realtime
      [84140a96cf7a] xfs: prepare to reuse the dquot pointer space in struct xfs_inode
      [953f76bf7a36] xfs: simplify the xfs_rmap_{alloc,free}_extent calling conventions
      [2f63b20b7a26] xfs: support storing records in the inode core root
      [05290bd5c623] xfs: allow inode-based btrees to reserve space in the data device
      [fc6856c6ff08] xfs: introduce realtime rmap btree ondisk definitions
      [e1c76fce50bb] xfs: realtime rmap btree transaction reservations
      [d386b4024372] xfs: add realtime rmap btree operations
      [adafb31c80e6] xfs: prepare rmap functions to deal with rtrmapbt
      [9e823fc27419] xfs: add a realtime flag to the rmap update log redo items
      [5e0679d1c62f] xfs: support recovering rmap intent items targetting realtime extents
      [219ee99d3673] xfs: pretty print metadata file types in error messages
      [702c90f45162] xfs: support file data forks containing metadata btrees
      [6b08901a6e8f] xfs: add realtime reverse map inode to metadata directory
      [8491a55cfc73] xfs: add metadata reservations for realtime rmap btrees
      [f33659e8a114] xfs: wire up a new metafile type for the realtime rmap
      [609a592865c9] xfs: wire up rmap map and unmap to the realtime rmapbt
      [71b8acb42be6] xfs: create routine to allocate and initialize a realtime rmap btree inode
      [b3683c74bf17] xfs: wire up getfsmap to the realtime reverse mapping btree
      [59a57acbce28] xfs: check that the rtrmapbt maxlevels doesn't increase when growing fs
      [6d4933c22195] xfs: report realtime rmap btree corruption errors to the health system
      [428e4884656d] xfs: allow queued realtime intents to drain before scrubbing
      [9a6cc4f6d081] xfs: scrub the realtime rmapbt
      [1ebecab5adba] xfs: cross-reference realtime bitmap to realtime rmapbt scrubber
      [037a44d8277a] xfs: cross-reference the realtime rmapbt
      [a5542712f983] xfs: scan rt rmap when we're doing an intense rmap check of bmbt mappings
      [366243cc99b7] xfs: scrub the metadir path of rt rmap btree files
      [2e0629e17c31] xfs: walk the rt reverse mapping tree when rebuilding rmap
      [f1a6d9b4c317] xfs: online repair of realtime file bmaps
      [1bd084302716] xfs: repair inodes that have realtime extents
      [3dd3aba6b92b] xfs: repair rmap btree inodes
      [8defee8dff2b] xfs: online repair of realtime bitmaps for a realtime group
      [c6904f6788b7] xfs: support repairing metadata btrees rooted in metadir inodes
      [6a849bd81b69] xfs: online repair of the realtime rmap btree
      [4a61f12eb119] xfs: create a shadow rmap btree during realtime rmap repair
      [9515572be65e] xfs: hook live realtime rmap operations during a repair operation
      [f4ed93037966] xfs: don't shut down the filesystem for media failures beyond end of log
      [799e7e6566df] xfs: react to fsdax failure notifications on the rt device
      [c2358439af37] xfs: enable realtime rmap btree
      [0d89af530c8c] xfs: prepare refcount btree cursor tracepoints for realtime
      [70fcf6866578] xfs: namespace the maximum length/refcount symbols
      [9abe03a0e4f9] xfs: introduce realtime refcount btree ondisk definitions
      [2003c6a8754e] xfs: realtime refcount btree transaction reservations
      [1a6f88ea538d] xfs: add realtime refcount btree operations
      [01cef1db246e] xfs: prepare refcount functions to deal with rtrefcountbt
      [fd9300679cce] xfs: add a realtime flag to the refcount update log redo items
      [ee6d43447923] xfs: support recovering refcount intent items targetting realtime extents
      [e08d0f2004cd] xfs: add realtime refcount btree block detection to log recovery
      [eaed472c4052] xfs: add realtime refcount btree inode to metadata directory
      [bf0b99411335] xfs: add metadata reservations for realtime refcount btree
      [f0415af60f48] xfs: wire up a new metafile type for the realtime refcount
      [e5a171729baf] xfs: wire up realtime refcount btree cursors
      [4ee3113aaf3f] xfs: create routine to allocate and initialize a realtime refcount btree inode
      [0bada8233123] xfs: update rmap to allow cow staging extents in the rt rmap
      [c2694ff678c9] xfs: compute rtrmap btree max levels when reflink enabled
      [3639c63d4643] xfs: refactor reflink quota updates
      [26e97d9b4b76] xfs: enable CoW for realtime data
      [5519251da0b0] xfs: enable sharing of realtime file blocks
      [c3d3605f9661] xfs: allow inodes to have the realtime and reflink flags
      [51e232674975] xfs: recover CoW leftovers in the realtime volume
      [6853d23badd0] xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
      [4de1a7ba4171] xfs: apply rt extent alignment constraints to CoW extsize hint
      [8e84e8052bc2] xfs: enable extent size hints for CoW operations
      [88a70768df13] xfs: check that the rtrefcount maxlevels doesn't increase when growing fs
      [026c8ed8d458] xfs: report realtime refcount btree corruption errors to the health system
      [c27929670de1] xfs: scrub the realtime refcount btree
      [91683bb3f264] xfs: cross-reference checks with the rt refcount btree
      [2d9a3e98053e] xfs: allow overlapping rtrmapbt records for shared data extents
      [30f47950dc2e] xfs: check reference counts of gaps between rt refcount records
      [48bc170f2cb5] xfs: allow dquot rt block count to exceed rt blocks on reflink fs
      [a9600db96f74] xfs: detect and repair misaligned rtinherit directory cowextsize hints
      [ca757af07fcc] xfs: scrub the metadir path of rt refcount btree files
      [cca34a305446] xfs: don't flag quota rt block usage on rtreflink filesystems
      [6470ceef325c] xfs: check new rtbitmap records against rt refcount btree
      [477493082fe8] xfs: walk the rt reference count tree when rebuilding rmap
      [fe2efe95082a] xfs: capture realtime CoW staging extents when rebuilding rt rmapbt
      [83ccffc48997] xfs: online repair of the realtime refcount btree
      [92b2019493d1] xfs: repair inodes that have a refcount btree in the data fork
      [12f4d203289d] xfs: check for shared rt extents when rebuilding rt file's data fork
      [fd97fe111208] xfs: fix CoW forks for realtime files
      [155debbe7e62] xfs: enable realtime reflink

Long Li (4):
      [efebe42d95fb] xfs: fix mount hang during primary superblock recovery failure
      [99fc33d16b24] xfs: clean up xfs_end_ioend() to reuse local variables
      [adcaff355bd8] xfs: remove redundant update for ticket->t_curr_res in xfs_log_ticket_regrant
      [09f7680dea87] xfs: remove bp->b_error check in xfs_attr3_root_inactive

Mirsad Todorovac (1):
      [9d9b72472631] xfs/libxfs: replace kmalloc() and memcpy() with kmemdup()

Code Diffstat:

 fs/xfs/Makefile                      |    6 +
 fs/xfs/libxfs/xfs_ag_resv.c          |    3 +
 fs/xfs/libxfs/xfs_attr.c             |    4 +-
 fs/xfs/libxfs/xfs_bmap.c             |   34 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       |  111 ++++
 fs/xfs/libxfs/xfs_bmap_btree.h       |    3 +
 fs/xfs/libxfs/xfs_btree.c            |  411 +++++++++++---
 fs/xfs/libxfs/xfs_btree.h            |   28 +-
 fs/xfs/libxfs/xfs_btree_mem.c        |    1 +
 fs/xfs/libxfs/xfs_btree_staging.c    |   10 +-
 fs/xfs/libxfs/xfs_defer.h            |    2 +
 fs/xfs/libxfs/xfs_dir2.c             |    9 +-
 fs/xfs/libxfs/xfs_dir2.h             |    1 -
 fs/xfs/libxfs/xfs_errortag.h         |    4 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |    4 +-
 fs/xfs/libxfs/xfs_format.h           |   51 +-
 fs/xfs/libxfs/xfs_fs.h               |   10 +-
 fs/xfs/libxfs/xfs_health.h           |    6 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |   65 ++-
 fs/xfs/libxfs/xfs_inode_fork.c       |  201 +++----
 fs/xfs/libxfs/xfs_inode_fork.h       |    6 +-
 fs/xfs/libxfs/xfs_log_format.h       |   16 +-
 fs/xfs/libxfs/xfs_log_recover.h      |    4 +
 fs/xfs/libxfs/xfs_metadir.c          |    4 +
 fs/xfs/libxfs/xfs_metafile.c         |  223 ++++++++
 fs/xfs/libxfs/xfs_metafile.h         |   13 +
 fs/xfs/libxfs/xfs_ondisk.h           |    4 +
 fs/xfs/libxfs/xfs_refcount.c         |  278 +++++++--
 fs/xfs/libxfs/xfs_refcount.h         |   23 +-
 fs/xfs/libxfs/xfs_rmap.c             |  178 ++++--
 fs/xfs/libxfs/xfs_rmap.h             |   12 +-
 fs/xfs/libxfs/xfs_rtbitmap.c         |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.h         |    9 +
 fs/xfs/libxfs/xfs_rtgroup.c          |   74 ++-
 fs/xfs/libxfs/xfs_rtgroup.h          |   58 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  757 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  189 +++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     | 1035 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h     |  210 +++++++
 fs/xfs/libxfs/xfs_sb.c               |   14 +
 fs/xfs/libxfs/xfs_shared.h           |   21 +
 fs/xfs/libxfs/xfs_trans_resv.c       |   37 +-
 fs/xfs/libxfs/xfs_trans_space.h      |   13 +
 fs/xfs/libxfs/xfs_types.h            |    7 +
 fs/xfs/scrub/agheader_repair.c       |    2 +-
 fs/xfs/scrub/alloc_repair.c          |    5 +-
 fs/xfs/scrub/bmap.c                  |  126 ++++-
 fs/xfs/scrub/bmap_repair.c           |  148 ++++-
 fs/xfs/scrub/common.c                |  170 +++++-
 fs/xfs/scrub/common.h                |   26 +-
 fs/xfs/scrub/cow_repair.c            |  180 +++++-
 fs/xfs/scrub/health.c                |    2 +
 fs/xfs/scrub/inode.c                 |   41 +-
 fs/xfs/scrub/inode_repair.c          |  193 ++++++-
 fs/xfs/scrub/metapath.c              |    6 +
 fs/xfs/scrub/newbt.c                 |   42 ++
 fs/xfs/scrub/newbt.h                 |    1 +
 fs/xfs/scrub/quota.c                 |    8 +-
 fs/xfs/scrub/quota_repair.c          |    2 +-
 fs/xfs/scrub/reap.c                  |  288 +++++++++-
 fs/xfs/scrub/reap.h                  |    9 +
 fs/xfs/scrub/refcount.c              |    2 +-
 fs/xfs/scrub/refcount_repair.c       |    6 +-
 fs/xfs/scrub/repair.c                |  197 +++++++
 fs/xfs/scrub/repair.h                |   24 +
 fs/xfs/scrub/rgb_bitmap.h            |   37 ++
 fs/xfs/scrub/rgsuper.c               |    6 +-
 fs/xfs/scrub/rmap_repair.c           |   91 ++-
 fs/xfs/scrub/rtb_bitmap.h            |   37 ++
 fs/xfs/scrub/rtbitmap.c              |   77 ++-
 fs/xfs/scrub/rtbitmap.h              |   55 ++
 fs/xfs/scrub/rtbitmap_repair.c       |  451 ++++++++++++++-
 fs/xfs/scrub/rtrefcount.c            |  661 ++++++++++++++++++++++
 fs/xfs/scrub/rtrefcount_repair.c     |  783 +++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c                |  323 +++++++++++
 fs/xfs/scrub/rtrmap_repair.c         | 1006 +++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtsummary.c             |   17 +-
 fs/xfs/scrub/rtsummary_repair.c      |    3 +-
 fs/xfs/scrub/scrub.c                 |   18 +-
 fs/xfs/scrub/scrub.h                 |   28 +-
 fs/xfs/scrub/stats.c                 |    2 +
 fs/xfs/scrub/tempexch.h              |    2 +-
 fs/xfs/scrub/tempfile.c              |   21 +-
 fs/xfs/scrub/trace.c                 |    1 +
 fs/xfs/scrub/trace.h                 |  280 ++++++++-
 fs/xfs/xfs_aops.c                    |    2 +-
 fs/xfs/xfs_attr_inactive.c           |    5 -
 fs/xfs/xfs_buf.c                     |    1 +
 fs/xfs/xfs_buf_item_recover.c        |   19 +-
 fs/xfs/xfs_discard.c                 |    2 +-
 fs/xfs/xfs_dquot.c                   |   12 +-
 fs/xfs/xfs_dquot.h                   |    3 +
 fs/xfs/xfs_drain.c                   |   20 +-
 fs/xfs/xfs_drain.h                   |    7 +-
 fs/xfs/xfs_error.c                   |    3 +
 fs/xfs/xfs_exchrange.c               |    3 +
 fs/xfs/xfs_fsmap.c                   |  193 ++++++-
 fs/xfs/xfs_fsops.c                   |   30 +
 fs/xfs/xfs_health.c                  |    2 +
 fs/xfs/xfs_inode.c                   |   19 +-
 fs/xfs/xfs_inode.h                   |   16 +-
 fs/xfs/xfs_inode_item.c              |   16 +
 fs/xfs/xfs_inode_item_recover.c      |   48 +-
 fs/xfs/xfs_ioctl.c                   |   21 +-
 fs/xfs/xfs_log.c                     |    2 -
 fs/xfs/xfs_log_recover.c             |    4 +
 fs/xfs/xfs_mount.c                   |   14 +
 fs/xfs/xfs_mount.h                   |   25 +-
 fs/xfs/xfs_notify_failure.c          |  230 +++++---
 fs/xfs/xfs_notify_failure.h          |   11 +
 fs/xfs/xfs_qm.c                      |   10 +-
 fs/xfs/xfs_qm_bhv.c                  |   26 +-
 fs/xfs/xfs_quota.h                   |    5 -
 fs/xfs/xfs_refcount_item.c           |  240 +++++++-
 fs/xfs/xfs_reflink.c                 |  321 ++++++++---
 fs/xfs/xfs_reflink.h                 |    4 +-
 fs/xfs/xfs_rmap_item.c               |  216 ++++++-
 fs/xfs/xfs_rtalloc.c                 |  121 +++-
 fs/xfs/xfs_rtalloc.h                 |   20 +
 fs/xfs/xfs_stats.c                   |    5 +-
 fs/xfs/xfs_stats.h                   |    3 +
 fs/xfs/xfs_super.c                   |  142 +++--
 fs/xfs/xfs_super.h                   |    1 -
 fs/xfs/xfs_trace.h                   |  260 ++++++---
 fs/xfs/xfs_trans.c                   |    6 +-
 fs/xfs/xfs_trans.h                   |    1 -
 fs/xfs/xfs_trans_dquot.c             |    8 +-
 127 files changed, 10613 insertions(+), 1012 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h
 create mode 100644 fs/xfs/scrub/rgb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtrefcount.c
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c
 create mode 100644 fs/xfs/scrub/rtrmap.c
 create mode 100644 fs/xfs/scrub/rtrmap_repair.c
 create mode 100644 fs/xfs/xfs_notify_failure.h
