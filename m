Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF6A3B47F6
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483175; cv=none; b=cS+wtHqFJO00KpAEnSvHK8IHLNxYNEao5KCiSNQbkBsfKX901I8F9JqQPVBzzVnYTgaVSWCe/WF0a0OOd8tEKDD5o1bzRbsT4kiWoVJNX7H34/wsQzkwAf+nx1zjs45pi40nTnbIwkAV7MmlVxYtZ6+YseGHUIYHaU7iRGiULRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483175; c=relaxed/simple;
	bh=pwPyjjmh7XCRnWUj8uuzrMbjGoxSeWmRiRpjsT6/NAU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P2jVCysfEnEHaMaMVfn05BtZUZUoCgiqwtIUSkpPbpH/gyYSYA3JlseY+cpZwI5tKfwOBnyOkbJUmwM93pk4dVHT8ISjMlOXEisl1ggq1B8vm736xCDOuqcV33bjjHudpa4kPglLWyALYBJLT4zu1PhFndj41rsL6n+wquTXZ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtrLWIH5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtrLWIH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B0E1F000FF
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 18:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483173;
	bh=pskmcGkPrmtlnLR2eG0MuaUywT+QxVUT5e0OXfYP3Fw=;
	h=Date:From:To:Subject;
	b=jtrLWIH5q6d+xBvDFQF6LflHhwmP7AWxRDY/Z3dvBZ2fSD8xvCiwxJ/Mr47KOcxvF
	 EigX5OirskMGkFWyIpYd8JgRjwcYA3tg3b0GCeAwoVD/iqDYfkL1V5UHjq7IOMXUs/
	 ZHwJ5xNs3qeO6IYqw7K0tr6IMwd2EM41UmMupy5YMRyxJtGupBLCi7Fbnp+jZsGe5a
	 f5BNXL8B/WP+saUAmwjWrmwUK8W/G1C4FOqMvrAVtvRk7V+zJB0WjpIntYCKkDuC9q
	 eERH/KMSuPXdNtDp19PhzX6LG+oJVFthyi6P/qgzWV0qxbw5GTyB2ha84XPSLnKAxg
	 3Mh8e+zybfgkg==
Date: Thu, 8 Oct 2026 20:12:49 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfs-linux: for-next updated to 0be6da616ab5
Message-ID: <asfdBFm6IxCd4_cE@cronus.toxiclabs.cc>
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

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

0be6da616ab5 xfs: fix exchange-range-to-eof file size exchange

26 new commits:

Aldo Ariel Panzardo (4):
      [9232301894a0] xfs: bound inode fork length against the fork size during log recovery
      [3df5e5aaa3bc] xfs: bound da-node entry count against the correct geometry
      [0643549ffeca] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
      [15ccd92a782a] xfs: reject remote xattr entries with an out-of-range value length

Christoph Hellwig (4):
      [6fe0d151eaad] xfs: remove various unused includes in libxfs/
      [5e68008e9c0d] xfs: include <linux/iversion.h> in xfs_platform.h
      [834a6a1e9633] xfs: move xfs_*_item.h to libxfs
      [ce47e8aab95d] xfs: move xfs_trans.h to libxfs

Daejun Park (1):
      [e3c682dd1130] xfs: map pNFS layouts to the end of the extent again

Darrick J. Wong (13):
      [2b47be015a5e] xfs: flag excessive delalloc rt extents as corruption
      [f5b4d8c8ce16] xfs: zero out di_metatype when removing the metadir file iflag
      [780212c8d810] xfs: forcibly reset quota timers when upgrading to bigtime during repair
      [7f5e8bf335e5] xfs: don't pass iget failures up when marking ondisk inodes
      [71cb13685e72] xfs: always reset incore attr fork buffer when resetting fork
      [e5bde75a816b] xfs: propagate errors while checking null siblings
      [1e7337a3eceb] xfs: don't try to scrub self-referential dirent in metapath checker
      [20c5a56bc4f2] xfs: don't allow sm_agno for non-group metadir path checking
      [e98643f794d0] xfs: init inode number for tracepoint
      [9a263723d7c9] xfs: release ip after unlinked list store failure
      [52aa50cea408] xfs: always zero the whole shortform header when zeroing attr fork
      [41ee987f5378] xfs: always forget cached ACLs if the attr fork swap succeeds
      [0be6da616ab5] xfs: fix exchange-range-to-eof file size exchange

Eric Sandeen (3):
      [e029aeece84b] xfs: factor out xfs_dir2_sf_copy_entries helper
      [1e3f1adf6d53] xfs: factor out xrep_reset_fork_to_extents helper for scrub/repair
      [1d55a1027805] xfs: re-use refcount scrub/repair code for rtrefcount

Norbert Szetei (1):
      [80f76f654535] xfs: stop exchanging reflink flags when exchanging mappings

Code Diffstat:

 fs/xfs/{ => libxfs}/xfs_attr_item.h     |   2 -
 fs/xfs/libxfs/xfs_attr_leaf.c           |  13 ++
 fs/xfs/{ => libxfs}/xfs_bmap_item.h     |   2 -
 fs/xfs/{ => libxfs}/xfs_buf_item.h      |   2 -
 fs/xfs/libxfs/xfs_da_btree.c            |  14 ++
 fs/xfs/libxfs/xfs_defer.c               |   1 -
 fs/xfs/libxfs/xfs_dir2_sf.c             |  68 ++++-----
 fs/xfs/{ => libxfs}/xfs_dquot_item.h    |   0
 fs/xfs/libxfs/xfs_exchmaps.c            |  93 ++---------
 fs/xfs/{ => libxfs}/xfs_exchmaps_item.h |   2 -
 fs/xfs/{ => libxfs}/xfs_extfree_item.h  |   2 -
 fs/xfs/{ => libxfs}/xfs_icreate_item.h  |   0
 fs/xfs/libxfs/xfs_inode_buf.c           |   3 -
 fs/xfs/{ => libxfs}/xfs_inode_item.h    |   2 -
 fs/xfs/libxfs/xfs_inode_util.c          |   1 -
 fs/xfs/{ => libxfs}/xfs_iunlink_item.h  |   0
 fs/xfs/libxfs/xfs_log_format.h          |   4 +-
 fs/xfs/libxfs/xfs_refcount.c            |   1 -
 fs/xfs/{ => libxfs}/xfs_refcount_item.h |   2 -
 fs/xfs/{ => libxfs}/xfs_rmap_item.h     |   2 -
 fs/xfs/libxfs/xfs_rtbitmap.c            |   1 -
 fs/xfs/libxfs/xfs_rtgroup.c             |   1 -
 fs/xfs/libxfs/xfs_sb.c                  |   1 -
 fs/xfs/{ => libxfs}/xfs_trans.h         |   2 -
 fs/xfs/libxfs/xfs_trans_inode.c         |   2 -
 fs/xfs/scrub/agheader_repair.c          |  13 +-
 fs/xfs/scrub/attr_repair.c              |  29 +---
 fs/xfs/scrub/dabtree.c                  |   5 +-
 fs/xfs/scrub/dir_repair.c               |  16 +-
 fs/xfs/scrub/fscounters.c               |   7 +
 fs/xfs/scrub/inode_repair.c             |   4 +-
 fs/xfs/scrub/metapath.c                 |  17 ++-
 fs/xfs/scrub/quota_repair.c             |  17 ++-
 fs/xfs/scrub/refcount.c                 |  27 +---
 fs/xfs/scrub/refcount.h                 |  56 +++++++
 fs/xfs/scrub/refcount_repair.c          |   3 +-
 fs/xfs/scrub/repair.c                   |  31 ++++
 fs/xfs/scrub/repair.h                   |   1 +
 fs/xfs/scrub/rtrefcount.c               | 263 +-------------------------------
 fs/xfs/scrub/rtrefcount_repair.c        |  39 +----
 fs/xfs/scrub/symlink_repair.c           |  16 +-
 fs/xfs/xfs_bmap_util.c                  |  15 +-
 fs/xfs/xfs_exchrange.c                  |  51 +++++--
 fs/xfs/xfs_inode_item_recover.c         |  20 ++-
 fs/xfs/xfs_platform.h                   |   1 +
 fs/xfs/xfs_pnfs.c                       |  19 ++-
 46 files changed, 319 insertions(+), 552 deletions(-)
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
 rename fs/xfs/{ => libxfs}/xfs_trans.h (99%)
 create mode 100644 fs/xfs/scrub/refcount.h
