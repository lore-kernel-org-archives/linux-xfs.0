Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157F15915E
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798105; cv=none; b=INE0wAAsuRd9vOcZTOgUPry3d0dhgezvD3+Dfv8Sd8mmoGrW+mYP3y2jRaoft5ERD6qWnpj1ysoxksG32BPTF2y/4LHqhm1tZm/0xHLPQVXvHA/gjGckBm+Au2bi7EVrfuJqfat0fOv5JfFJc707K20u8PzSE4T+BFNEsaStPJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798105; c=relaxed/simple;
	bh=SqvZCooDNv/s9Rxe3p/2KSo8GlFCCdx3vE0244IrQ/0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CXraDi383pZW9gZ8mbO9TYP4FZqTBqzt8VR31+FovJnDuypF5mBddKKvQATIrEnYBuuQoggNT79ea5VrHQB4Atlm7u+xXuOMO0B2kQZGXwpJmpwKsOyF0ucVRDp4Y9oMVqt4lKfkwYHG8vH3gUiJATqNUB5IKotPlZ3IBs/0WB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKv06Qp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKv06Qp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9A5C433F1;
	Mon, 18 Mar 2024 21:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798104;
	bh=SqvZCooDNv/s9Rxe3p/2KSo8GlFCCdx3vE0244IrQ/0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mKv06Qp/UwmcAjEv8vSC2cgoJhnCoB25DfwXlWfS4Zaxgoie7aznVOuxaBg+GKfiM
	 HaaBi9ERqNaCOsAlV+MLO6WpswwZOjL0PKYOtytPbMSOE/xkNvCI9u8m1Mrn+Jgnh6
	 mbeotyj0cwGgVHIFU6iOTS3ZYvt9XIEqTjEeb3rSWMqklgkgcNoqOfV09PCyVI8o+Y
	 7cNJBNmoOlWV/IxcVZJbsgTkgVlLa4QN0KrSAym36vx/86bOsch7TnbHo9LIZMpac6
	 ZdU58xylbC2StntO9o+WJUptAOutwKOcBi2LHKde60qXS/ikP/o9xHHUHwhqzOHAaC
	 FKrbzdb7knWwg==
Date: Mon, 18 Mar 2024 14:41:44 -0700
Subject: [PATCHSET v13.0 1/2] xfs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>,
 Mark Tinguely <tinguely@sgi.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079801811.3806377.3956620644680630047.stgit@frogsfrogsfrogs>
In-Reply-To: <20240318213921.GJ6188@frogsfrogsfrogs>
References: <20240318213921.GJ6188@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This is the latest parent pointer attributes for xfs.  The goal of this
patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature
will enable future optimizations for online scrub, shrink, nfs handles,
verity, or any other feature that could make use of quickly deriving an
inodes path from the mount point.

At this point, Allison is moving on to other things, so I've merged her
patchset into djwong-dev for merging.

Updates since v12 [djwong]:

Rebase on 6.5-rc and update the online fsck design document.

Updates since v11 [djwong]:

Rebase on 6.4-rc and make some tweaks and bugfixes to enable the repair
prototypes.  Merge with djwong-dev and make online repair actually work.

Updates since v10 [djwong]:

Merge in the ondisk format changes to get rid of the diroffset conflicts
with the parent pointer repair code, rebase the entire series with the
attr vlookup changes first, and merge all the other random fixes.

Updates since v9:

Reordered patches 2 and 3 to be 6 and 7

xfs: Add xfs_verify_pptr
   moved parent pointer validators to xfs_parent

xfs: Add parent pointer ioctl
   Extra validation checks for fs id
   added missing release for the inode
   use GFP_KERNEL flags for malloc/realloc
   reworked ioctl to use pptr listenty and flex array

NEW
   xfs: don't remove the attr fork when parent pointers are enabled

NEW
   directory lookups should return diroffsets too

NEW
   xfs: move/add parent pointer validators to xfs_parent

Updates since v8:

xfs: parent pointer attribute creation
   Fix xfs_parent_init to release log assist on alloc fail
   Add slab cache for xfs_parent_defer
   Fix xfs_create to release after unlock
   Add xfs_parent_start and xfs_parent_finish wrappers
   removed unused xfs_parent_name_irec and xfs_init_parent_name_irec

xfs: add parent attributes to link
   Start/finish wrapper updates
   Fix xfs_link to disallow reservationless quotas

xfs: add parent attributes to symlink
   Fix xfs_symlink to release after unlock
   Start/finish wrapper updates

xfs: remove parent pointers in unlink
   Start/finish wrapper updates
   Add missing parent free

xfs: Add parent pointers to rename
   Start/finish wrapper updates
   Fix rename to only grab logged xattr once
   Fix xfs_rename to disallow reservationless quotas
   Fix double unlock on dqattach fail
   Move parent frees to out_release_wip

xfs: Add parent pointers to xfs_cross_rename
   Hoist parent pointers into rename

Questions comments and feedback appreciated!

Thanks all!
Allison

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=pptrs
---
Commits in this patchset:
 * xfs: Expose init_xattrs in xfs_create_tmpfile
 * xfs: add parent pointer support to attribute code
 * xfs: define parent pointer ondisk extended attribute format
 * xfs: add parent pointer validator functions
 * xfs: extend transaction reservations for parent attributes
 * xfs: parent pointer attribute creation
 * xfs: add parent attributes to link
 * xfs: add parent attributes to symlink
 * xfs: remove parent pointers in unlink
 * xfs: Add parent pointers to rename
 * xfs: Add parent pointers to xfs_cross_rename
 * xfs: Filter XFS_ATTR_PARENT for getfattr
 * xfs: pass the attr value to put_listent when possible
 * xfs: add a libxfs header file for staging new ioctls
 * xfs: Add parent pointer ioctl
 * xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
 * xfs: drop compatibility minimum log size computations for reflink
 * xfs: don't remove the attr fork when parent pointers are enabled
 * xfs: Add the parent pointer support to the superblock version 5.
 * xfs: only clear some log incompat bits at unmount
 * xfs: allow adding multiple log incompat feature bits
 * xfs: make XFS_SB_FEAT_INCOMPAT_LOG_XATTRS sticky for parent pointers
 * xfs: make XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS sticky for parent pointers
---
 .../filesystems/xfs/xfs-online-fsck-design.rst     |    2 
 fs/xfs/Kconfig                                     |   11 +
 fs/xfs/Makefile                                    |    3 
 fs/xfs/libxfs/xfs_attr.c                           |   15 +
 fs/xfs/libxfs/xfs_attr.h                           |   10 -
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    6 
 fs/xfs/libxfs/xfs_attr_sf.h                        |    1 
 fs/xfs/libxfs/xfs_da_format.h                      |   33 ++
 fs/xfs/libxfs/xfs_format.h                         |    9 
 fs/xfs/libxfs/xfs_fs.h                             |    3 
 fs/xfs/libxfs/xfs_fs_staging.h                     |   84 +++++
 fs/xfs/libxfs/xfs_log_format.h                     |    1 
 fs/xfs/libxfs/xfs_log_rlimit.c                     |   43 ++
 fs/xfs/libxfs/xfs_ondisk.h                         |    4 
 fs/xfs/libxfs/xfs_parent.c                         |  368 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h                         |  155 ++++++++
 fs/xfs/libxfs/xfs_sb.c                             |    4 
 fs/xfs/libxfs/xfs_trans_resv.c                     |  326 +++++++++++++++---
 fs/xfs/libxfs/xfs_trans_space.c                    |  121 +++++++
 fs/xfs/libxfs/xfs_trans_space.h                    |   25 +
 fs/xfs/scrub/agheader.c                            |    7 
 fs/xfs/scrub/agheader_repair.c                     |    4 
 fs/xfs/scrub/attr.c                                |    4 
 fs/xfs/scrub/dir_repair.c                          |    2 
 fs/xfs/scrub/orphanage.c                           |    5 
 fs/xfs/scrub/parent_repair.c                       |    3 
 fs/xfs/scrub/symlink_repair.c                      |    2 
 fs/xfs/scrub/tempfile.c                            |    2 
 fs/xfs/xfs_attr_item.c                             |   42 ++
 fs/xfs/xfs_attr_list.c                             |   22 +
 fs/xfs/xfs_exchrange.c                             |    2 
 fs/xfs/xfs_inode.c                                 |  199 +++++++++--
 fs/xfs/xfs_inode.h                                 |    2 
 fs/xfs/xfs_ioctl.c                                 |  150 ++++++++
 fs/xfs/xfs_iops.c                                  |   15 +
 fs/xfs/xfs_linux.h                                 |    1 
 fs/xfs/xfs_mount.c                                 |   68 +++-
 fs/xfs/xfs_mount.h                                 |    5 
 fs/xfs/xfs_parent_utils.c                          |  164 +++++++++
 fs/xfs/xfs_parent_utils.h                          |   20 +
 fs/xfs/xfs_super.c                                 |   17 +
 fs/xfs/xfs_symlink.c                               |   28 +-
 fs/xfs/xfs_trace.c                                 |    1 
 fs/xfs/xfs_trace.h                                 |   76 ++++
 fs/xfs/xfs_xattr.c                                 |    8 
 fs/xfs/xfs_xattr.h                                 |    2 
 46 files changed, 1918 insertions(+), 157 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_fs_staging.h
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

