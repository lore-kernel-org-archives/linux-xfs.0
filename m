Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582DDF60
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 02:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722307500; cv=none; b=Wt3JGVls0Bmb1kpSAGLUsCzcUaG5YzXcx4jLihy4TRm0l3a56y5sRGHHpbhAwyAoYJCtAaEoeQ1Zxm2i99VIgAG5acAOL4OAbhyvPUDUOKDBofWIHSZ94iOms0RkCwA5JOGfz0H7FxKu+iyxR1HuKF5Zqk5jayaz5XFdyh+N7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722307500; c=relaxed/simple;
	bh=trjwItPMM2KsZzBOy6w2DolJ6U/S7tUOvCbJtfZH234=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=hooRUJOiDJIRmlHa689TjoJhhUeN+5pdRX0N/XO3SOTgtj4Fh1wzrdpMRInVoB/Q7WZuSZ9c3UMGseW6U6F2rhqGX6ozFz+Y5vUij/r5/4sIYX0coDUutmpjZSKMf2n4b83mfq5iw5fnWPpsRxeYQeTqp3uuFCp9HqdQRTdFGf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tv3F02Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tv3F02Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9B2C32786;
	Tue, 30 Jul 2024 02:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722307500;
	bh=trjwItPMM2KsZzBOy6w2DolJ6U/S7tUOvCbJtfZH234=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tv3F02WzSbZbdhYJKw3YyvG1sffii9VsvMHWi1y2HvIhFEkTKTRylQGfYsZycUoQE
	 GFO2xsHCpY+0KdIjeIlsxKe3uQd7JbqEkyoFUgGLF5D+z6MV80y5pU3IAwkCTwK0h9
	 zqz2GoR+DGEcpbL06MZZoFCko+UkXhff64OXZvrJ9hDEyVYBCM1R56YU4wR8Tfh8Vx
	 Lo2KFDdS/SDaEM93KCrIArIpfGcDQqbgFFfT8L/i1m9VqxhcNGUV4AIlT39W2R4Kbc
	 E8SYo2ZCQAnaS0XmJzhE1XM/eyULUbxrQDn4DYTZz945VuWb+4UDZRdNILa8P2J508
	 jDFBJzmACKD2Q==
Date: Mon, 29 Jul 2024 19:44:59 -0700
Subject: [GIT PULL 18/23] xfsprogs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172230459610.1455085.1608305874091471699.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>
References: <20240730013626.GF6352@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Carlos,

Please pull this branch with changes for xfsprogs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

The following changes since commit 2823d8ed93da2bd3880abb52a58e91a920961e27:

xfs_repair: check for unknown flags in attr entries (2024-07-29 17:01:11 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/pptrs-6.10_2024-07-29

for you to fetch changes up to b2677fa4f4009abf8de4c15960a2e97dd5370d41:

mkfs: enable formatting with parent pointers (2024-07-29 17:01:12 -0700)

----------------------------------------------------------------
xfsprogs: Parent Pointers [v13.8 18/28]

This is the latest parent pointer attributes for xfs.  The goal of this
patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature
will enable future optimizations for online scrub, shrink, nfs handles,
verity, or any other feature that could make use of quickly deriving an
inodes path from the mount point.

Directory parent pointers are stored as namespaced extended attributes
of a file.  Because parent pointers are an indivisible tuple of
(dirent_name, parent_ino, parent_gen) we cannot use the usual attr name
lookup functions to find a parent pointer.  This is solvable by
introducing a new lookup mode that checks both the name and the value of
the xattr.

Therefore, introduce this new name-value lookup mode that's gated on the
XFS_ATTR_PARENT namespace.  This requires the introduction of new
opcodes for the extended attribute update log intent items, which
actually means that parent pointers (itself an INCOMPAT feature) does
not depend on the LOGGED_XATTRS log incompat feature bit.

To reduce collisions on the dirent names of parent pointers, introduce a
new attr hash mode that is the dir2 namehash of the dirent name xor'd
with the parent inode number.

At this point, Allison has moved on to other things, so I've merged her
patchset into djwong-dev for merging.

Updates since v12 [djwong]:

Rebase on 6.9-rc and update the online fsck design document.
Redesign the ondisk format to use the name-value lookups to get us back
to the point where the attr is (dirent_name -> parent_ino/gen).

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

This has been running on the djcloud for months with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Allison Henderson (4):
xfs_io: Add i, n and f flags to parent command
xfs_logprint: decode parent pointers in ATTRI items fully
mkfs: Add parent pointers during protofile creation
mkfs: enable formatting with parent pointers

Darrick J. Wong (20):
libxfs: create attr log item opcodes and formats for parent pointers
xfs_{db,repair}: implement new attr hash value function
xfs_logprint: dump new attr log item fields
man: document the XFS_IOC_GETPARENTS ioctl
libfrog: report parent pointers to userspace
libfrog: add parent pointer support code
xfs_io: adapt parent command to new parent pointer ioctls
xfs_spaceman: report file paths
xfs_scrub: use parent pointers when possible to report file operations
xfs_scrub: use parent pointers to report lost file data
xfs_db: report parent pointers in version command
xfs_db: report parent bit on xattrs
xfs_db: report parent pointers embedded in xattrs
xfs_db: obfuscate dirent and parent pointer names consistently
libxfs: export attr3_leaf_hdr_from_disk via libxfs_api_defs.h
xfs_db: add a parents command to list the parents of a file
xfs_db: make attr_set and attr_remove handle parent pointers
xfs_db: add link and unlink expert commands
xfs_db: compute hashes of parent pointers
libxfs: create new files with attr forks if necessary

db/attr.c                       |  33 +-
db/attrset.c                    | 202 +++++++++---
db/attrshort.c                  |  27 ++
db/field.c                      |  10 +
db/field.h                      |   3 +
db/hash.c                       |  44 ++-
db/metadump.c                   | 322 ++++++++++++++++--
db/namei.c                      | 701 ++++++++++++++++++++++++++++++++++++++++
db/sb.c                         |   2 +
include/handle.h                |   1 +
include/xfs_inode.h             |   4 +
io/parent.c                     | 541 +++++++++++--------------------
libfrog/Makefile                |   2 +
libfrog/fsgeom.c                |   6 +-
libfrog/getparents.c            | 355 ++++++++++++++++++++
libfrog/getparents.h            |  42 +++
libfrog/paths.c                 | 168 ++++++++++
libfrog/paths.h                 |  25 ++
libhandle/handle.c              |   7 +-
libxfs/defer_item.c             |  52 ++-
libxfs/init.c                   |   4 +
libxfs/libxfs_api_defs.h        |  19 ++
libxfs/util.c                   |  19 +-
logprint/log_redo.c             | 217 +++++++++++--
logprint/logprint.h             |   5 +-
man/man2/ioctl_xfs_getparents.2 | 212 ++++++++++++
man/man8/xfs_db.8               |  59 +++-
man/man8/xfs_io.8               |  32 +-
man/man8/xfs_spaceman.8         |   7 +-
mkfs/lts_4.19.conf              |   3 +
mkfs/lts_5.10.conf              |   3 +
mkfs/lts_5.15.conf              |   3 +
mkfs/lts_5.4.conf               |   3 +
mkfs/lts_6.1.conf               |   3 +
mkfs/lts_6.6.conf               |   3 +
mkfs/proto.c                    |  62 +++-
mkfs/xfs_mkfs.c                 |  45 ++-
repair/attr_repair.c            |  24 +-
scrub/common.c                  |  41 ++-
scrub/phase6.c                  |  75 ++++-
spaceman/Makefile               |  16 +-
spaceman/file.c                 |   7 +
spaceman/health.c               |  53 ++-
spaceman/space.h                |   3 +
44 files changed, 2941 insertions(+), 524 deletions(-)
create mode 100644 libfrog/getparents.c
create mode 100644 libfrog/getparents.h
create mode 100644 man/man2/ioctl_xfs_getparents.2

