Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D83B635
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 17:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760030324; cv=none; b=lPbgKLS5tN0HUvHc5gkEYPwRYk7tjH9ssnxdARjd0lj8+k34wpOFuxW9RXwI39D6nVou9TYvd5aLtbAiAefve/lvPGhGvF1ogK5Wb2b00GCSrbySCRMXxfF7uazDAwYbu1eCZae1HmJdpy54uUjLrizZ2+sohfB3ViuIyrQpMoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760030324; c=relaxed/simple;
	bh=igkrnluKpbos0B06Xrzh9j5bEEtMH4MBJYmc10OOsMM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IVGn65B2InL+WunoMgkkREnVnGRIKyjhAZQPb/Rz1mchCneO1rA1nuugC6JlDdV454dwZeXQF8qPqH6m1dw6s2Wapu/Yy8wUYNDzMcx9RAkuYxE6BCv+il4OBAYq1lkiTLTy2SoqAjdFIaz4KtKv69TweOpIMEHi7TR9wQlWEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GxjfDhnZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GxjfDhnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFF0C4CEE7
	for <linux-xfs@vger.kernel.org>; Thu,  9 Oct 2025 17:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760030323;
	bh=igkrnluKpbos0B06Xrzh9j5bEEtMH4MBJYmc10OOsMM=;
	h=Date:From:To:Subject:From;
	b=GxjfDhnZR0h6TtO6wTt5J13OMhiqILlkEivYjCFkJ5VhJI/iS2adXrUSgIGERWe+W
	 6O2bhVuxRHTDUW2SKGO27DBfnbwDVPMzhtcB/usTkrnkss+b+uO+my+6eZ627pEsEy
	 kEPVFHQ3U7irAKu8drD1G+kd+l1enpS4WAmNueD0TWHY7j7X2l2YbHjD6Zh/cOcM1M
	 XU7y90AZgRbcY3c1mfmCw/92O/iIAoNTojvcPpk3uGVsTQfR9GIN05PMZOCYntPxc8
	 tDkr9/1/j1dm8YtqF7l4Egy0d0Z7K8GruKbAsZdAUh14RtzZjLk585rRtKdjOVZuNK
	 BeJ7TjkUYw1sQ==
Date: Thu, 9 Oct 2025 19:18:39 +0200
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org
Subject: [cem@kernel.org: [GIT PULL] XFS: New code for for v6.18]
Message-ID: <atuzyrtozsauk6aggcsaab6usfw3rceyejv6doqmmxgsaxc5y2@c5jlmh2bhxxx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, I sent it to Linus late night (or early morning :) and I forgot
to Cc linux-xfs. Just forwarding it to log it to the list.

----- Forwarded message from Carlos Maiolino <cem@kernel.org> -----

Date: Mon, 29 Sep 2025 04:50:11 +0200
From: Carlos Maiolino <cem@kernel.org>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS: New code for for v6.18
Message-ID: <zp7b3u7pg47hejezipnxmmqn3zgwg6vrwmobgs64h3r3mrgdcg@wz4in7iov4eg>

Hello Linus,

Could you please pull patches included in the tag below?

An attempt merge against your current TOT has been successful and the
diffstat is at the end.

For this merge window, there are really no new features, but there are a
few things worth to emphasize:

- Deprecated for years already, the (no)attr2 and (no)ikeep mount
  options have been removed for good.
- Several cleanups (specially from typedefs) and bug fixes.
- Improvements made in the online repair reap calculations
- online fsck is now enabled by default.

Thanks,
Carlos

The following changes since commit b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

  Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-merge-6.18

for you to fetch changes up to c91d38b57f2c4784d885c874b2a1234a01361afd:

  xfs: rework datasync tracking and execution (2025-09-23 15:12:43 +0200)

----------------------------------------------------------------
xfs: new code for 6.18

Signed-off-by: Carlos Maiolino <cem@kernel.org>

----------------------------------------------------------------
Andrey Albershteyn (3):
      xfs: allow renames of project-less inodes
      xfs: add .fileattr_set and fileattr_get callbacks for symlinks
      xfs: allow setting file attributes on special files

Bagas Sanjaya (1):
      xfs: extend removed sysctls table

Carlos Maiolino (2):
      Merge tag 'fix-scrub-reap-calculations_2025-09-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.18-merge
      Merge tag 'kconfig-2025-changes_2025-09-05' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.18-merge

Christoph Hellwig (27):
      xfs: implement XFS_IOC_DIOINFO in terms of vfs_getattr
      xfs: remove the xlog_op_header_t typedef
      xfs: remove the xfs_trans_header_t typedef
      xfs: remove the xfs_extent_t typedef
      xfs: remove the xfs_extent32_t typedef
      xfs: remove the xfs_extent64_t typedef
      xfs: remove the xfs_efi_log_format_t typedef
      xfs: remove the xfs_efi_log_format_32_t typedef
      xfs: remove the xfs_efi_log_format_64_t typedef
      xfs: remove the xfs_efd_log_format_t typedef
      xfs: remove the unused xfs_efd_log_format_32_t typedef
      xfs: remove the unused xfs_efd_log_format_64_t typedef
      xfs: remove the unused xfs_buf_log_format_t typedef
      xfs: remove the unused xfs_dq_logformat_t typedef
      xfs: remove the unused xfs_qoff_logformat_t typedef
      xfs: remove the unused xfs_log_iovec_t typedef
      xfs: rename the old_crc variable in xlog_recover_process
      xfs: fix log CRC mismatches between i386 and other architectures
      xfs: move the XLOG_REG_ constants out of xfs_log_format.h
      xfs: remove xfs_errortag_get
      xfs: remove xfs_errortag_set
      xfs: remove the expr argument to XFS_TEST_ERROR
      xfs: remove pointless externs in xfs_error.h
      xfs: centralize error tag definitions
      xfs: constify xfs_errortag_random_default
      xfs: track the number of blocks in each buftarg
      xfs: use bt_nr_sectors in xfs_dax_translate_range

Damien Le Moal (2):
      xfs: improve zone statistics message
      xfs: improve default maximum number of open zones

Darrick J. Wong (13):
      xfs: use deferred intent items for reaping crosslinked blocks
      xfs: prepare reaping code for dynamic limits
      xfs: convert the ifork reap code to use xreap_state
      xfs: compute per-AG extent reap limits dynamically
      xfs: compute data device CoW staging extent reap limits dynamically
      xfs: compute realtime device CoW staging extent reap limits dynamically
      xfs: compute file mapping reap limits dynamically
      xfs: disable deprecated features by default in Kconfig
      xfs: remove deprecated mount options
      xfs: remove static reap limits from repair.h
      xfs: remove deprecated sysctl knobs
      xfs: use deferred reaping for data device cow extents
      xfs: enable online fsck by default in Kconfig

Dave Chinner (2):
      xfs: rearrange code in xfs_inode_item_precommit
      xfs: rework datasync tracking and execution

Dmitry Antipov (1):
      xfs: scrub: use kstrdup_const() for metapath scan setups

Hans Holmberg (3):
      fs: add an enum for number of life time hints
      xfs: refactor hint based zone allocation
      xfs: adjust the hint based zone allocation policy

Marcelo Moreira (1):
      xfs: Replace strncpy with memcpy

 Documentation/admin-guide/xfs.rst |  69 +----
 fs/xfs/Kconfig                    |  22 +-
 fs/xfs/libxfs/xfs_ag_resv.c       |   7 +-
 fs/xfs/libxfs/xfs_alloc.c         |   5 +-
 fs/xfs/libxfs/xfs_attr_leaf.c     |  25 +-
 fs/xfs/libxfs/xfs_bmap.c          |  31 +-
 fs/xfs/libxfs/xfs_btree.c         |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2.c          |   2 +-
 fs/xfs/libxfs/xfs_errortag.h      | 114 ++++---
 fs/xfs/libxfs/xfs_exchmaps.c      |   4 +-
 fs/xfs/libxfs/xfs_ialloc.c        |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.c     |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c    |   3 +-
 fs/xfs/libxfs/xfs_inode_util.c    |  11 -
 fs/xfs/libxfs/xfs_log_format.h    | 150 +++++----
 fs/xfs/libxfs/xfs_log_recover.h   |   2 +-
 fs/xfs/libxfs/xfs_metafile.c      |   2 +-
 fs/xfs/libxfs/xfs_ondisk.h        |   2 +
 fs/xfs/libxfs/xfs_refcount.c      |   7 +-
 fs/xfs/libxfs/xfs_rmap.c          |   2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c      |   2 +-
 fs/xfs/libxfs/xfs_sb.c            |   9 +-
 fs/xfs/libxfs/xfs_zones.h         |   7 +
 fs/xfs/scrub/cow_repair.c         |   4 +-
 fs/xfs/scrub/metapath.c           |  12 +-
 fs/xfs/scrub/newbt.c              |   9 +
 fs/xfs/scrub/reap.c               | 620 ++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/repair.c             |   2 +-
 fs/xfs/scrub/repair.h             |   8 -
 fs/xfs/scrub/symlink_repair.c     |   2 +-
 fs/xfs/scrub/trace.c              |   1 +
 fs/xfs/scrub/trace.h              |  45 +++
 fs/xfs/xfs_attr_item.c            |   2 +-
 fs/xfs/xfs_buf.c                  |  46 +--
 fs/xfs/xfs_buf.h                  |   4 +-
 fs/xfs/xfs_buf_item_recover.c     |  10 +
 fs/xfs/xfs_error.c                | 216 ++-----------
 fs/xfs/xfs_error.h                |  47 ++-
 fs/xfs/xfs_extfree_item.c         |   4 +-
 fs/xfs/xfs_extfree_item.h         |   4 +-
 fs/xfs/xfs_file.c                 |  75 +++--
 fs/xfs/xfs_globals.c              |   2 -
 fs/xfs/xfs_icache.c               |   6 +-
 fs/xfs/xfs_inode.c                | 117 +++----
 fs/xfs/xfs_inode_item.c           | 125 +++++---
 fs/xfs/xfs_inode_item.h           |  10 +-
 fs/xfs/xfs_ioctl.c                |  24 +-
 fs/xfs/xfs_iomap.c                |  19 +-
 fs/xfs/xfs_iops.c                 |  14 +-
 fs/xfs/xfs_linux.h                |   2 -
 fs/xfs/xfs_log.c                  |  35 +--
 fs/xfs/xfs_log.h                  |  37 +++
 fs/xfs/xfs_log_priv.h             |   4 +-
 fs/xfs/xfs_log_recover.c          |  34 ++-
 fs/xfs/xfs_mount.c                |  13 -
 fs/xfs/xfs_mount.h                |  12 +-
 fs/xfs/xfs_notify_failure.c       |   2 +-
 fs/xfs/xfs_super.c                |  67 +---
 fs/xfs/xfs_sysctl.c               |  29 +-
 fs/xfs/xfs_sysctl.h               |   3 -
 fs/xfs/xfs_trans.c                |  23 +-
 fs/xfs/xfs_trans_ail.c            |   2 +-
 fs/xfs/xfs_zone_alloc.c           | 120 ++++----
 include/linux/rw_hint.h           |   1 +
 65 files changed, 1249 insertions(+), 1053 deletions(-)


----- End forwarded message -----
