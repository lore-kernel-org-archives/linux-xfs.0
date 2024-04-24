Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7713E13C3C1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929666; cv=none; b=c8SewnxbFub14vNgQ+jt8Fbw8VwFM/RKbQBnFpqkQvpq1u9oblkK5jD50iYRgEXTmV9Z2+aaFz35ARb7/rs7xcVexPmmJ2GoH8tXn7NqZDtmcREj6mcHytVY5d+uuhJPLogtolvdKuZLYLfwA8eNwCRv5V3PtNWtWU2zxvUGNaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929666; c=relaxed/simple;
	bh=yjkeVMSAW7G7K9INTwkfonNXlol4Fxmx2dYjzXvx6jc=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:In-Reply-To:
	 References:Content-Type; b=cckRvBsr5pcQXrvmnEJujCKTBvQhWm76h1NEoir1dcrNUmjP01LvZGM1jMrNPGKr+2nL0nEKUzVK5hwDSobRrBxbdZ4HWmw9/fFuwrrbXIsFTlvnIvgjsBCg9Lx/H7SVnTOin0URgykErGwlmP5GQaEggZun/LVgmJ/4aWA0XZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rQExiCSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rQExiCSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DF6C2BD11;
	Wed, 24 Apr 2024 03:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929666;
	bh=yjkeVMSAW7G7K9INTwkfonNXlol4Fxmx2dYjzXvx6jc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rQExiCSx0gw9F74OOYSaKszTZvPifOMyz4LGYAA8TJeMIjGKA16ZGRSwIagHkD62M
	 bRxoS6soyzPbNf+V3u9dPZn10Vz0LZJhfkgsF3HgXPHQBjmbnncd6KjfVRg0z9uh5V
	 Z/xkymLWDwjmeE7EhLc5R3dUBBw3dEO3OGV9tclGPZVfgIyIOFs0/gefgiuDb5nV6E
	 CpRbvuWk+iiFoPnrAIlSY7G9SSsTVBd1pamxQhQgWH1Wm3pF9JSH/Ht07EpAMRXcxb
	 bgp+W7LXvyeZ7YdXexHs39/kCEmZlRNfW8pK76UuallBy3ubxXdXSRiGgYjU6Md5Xk
	 rxVgDulry9onA==
Date: Tue, 23 Apr 2024 20:34:25 -0700
Subject: [GIT PULL 3/9] xfs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com, darrick.wong@oracle.com, dchinner@redhat.com, hch@lst.de, linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Message-ID: <171392950848.1941278.17369768789928295836.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240424033018.GB360940@frogsfrogsfrogs>
References: <20240424033018.GB360940@frogsfrogsfrogs>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Chandan,

Please pull this branch with changes for xfs for 6.10-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit ea0b3e814741fb64e7785b564ea619578058e0b0:

xfs: enforce one namespace per attribute (2024-04-23 07:46:54 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/pptrs-6.10_2024-04-23

for you to fetch changes up to 67ac7091e35bd34b75c0ec77331b53ca052e0cb3:

xfs: enable parent pointers (2024-04-23 07:47:01 -0700)

----------------------------------------------------------------
xfs: Parent Pointers [v13.4 3/9]

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
Allison Henderson (15):
xfs: add parent pointer support to attribute code
xfs: define parent pointer ondisk extended attribute format
xfs: Expose init_xattrs in xfs_create_tmpfile
xfs: add parent pointer validator functions
xfs: extend transaction reservations for parent attributes
xfs: parent pointer attribute creation
xfs: add parent attributes to link
xfs: add parent attributes to symlink
xfs: remove parent pointers in unlink
xfs: Add parent pointers to rename
xfs: Add parent pointers to xfs_cross_rename
xfs: don't return XFS_ATTR_PARENT attributes via listxattr
xfs: pass the attr value to put_listent when possible
xfs: don't remove the attr fork when parent pointers are enabled
xfs: add a incompat feature bit for parent pointers

Christoph Hellwig (1):
xfs: check the flags earlier in xfs_attr_match

Darrick J. Wong (14):
xfs: rearrange xfs_attr_match parameters
xfs: move xfs_attr_defer_add to xfs_attr_item.c
xfs: create a separate hashname function for extended attributes
xfs: allow xattr matching on name and value for parent pointers
xfs: refactor xfs_is_using_logged_xattrs checks in attr item recovery
xfs: create attr log item opcodes and formats for parent pointers
xfs: record inode generation in xattr update log intent items
xfs: create a hashname function for parent pointers
xfs: move handle ioctl code to xfs_handle.c
xfs: split out handle management helpers a bit
xfs: add parent pointer ioctls
xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
xfs: drop compatibility minimum log size computations for reflink
xfs: enable parent pointers

fs/xfs/Makefile                 |   3 +
fs/xfs/libxfs/xfs_attr.c        |  92 ++--
fs/xfs/libxfs/xfs_attr.h        |  23 +-
fs/xfs/libxfs/xfs_attr_leaf.c   |  87 +++-
fs/xfs/libxfs/xfs_attr_sf.h     |   1 +
fs/xfs/libxfs/xfs_da_btree.h    |   4 +
fs/xfs/libxfs/xfs_da_format.h   |  25 +-
fs/xfs/libxfs/xfs_format.h      |   4 +-
fs/xfs/libxfs/xfs_fs.h          |  79 +++-
fs/xfs/libxfs/xfs_log_format.h  |  25 +-
fs/xfs/libxfs/xfs_log_rlimit.c  |  46 ++
fs/xfs/libxfs/xfs_ondisk.h      |   6 +
fs/xfs/libxfs/xfs_parent.c      | 293 +++++++++++++
fs/xfs/libxfs/xfs_parent.h      |  99 +++++
fs/xfs/libxfs/xfs_sb.c          |   4 +
fs/xfs/libxfs/xfs_trans_resv.c  | 326 +++++++++++---
fs/xfs/libxfs/xfs_trans_space.c | 121 +++++
fs/xfs/libxfs/xfs_trans_space.h |  25 +-
fs/xfs/scrub/attr.c             |  15 +-
fs/xfs/scrub/dir_repair.c       |   2 +-
fs/xfs/scrub/orphanage.c        |   5 +-
fs/xfs/scrub/parent_repair.c    |   3 +-
fs/xfs/scrub/symlink_repair.c   |   2 +-
fs/xfs/scrub/tempfile.c         |   2 +-
fs/xfs/xfs_attr_item.c          | 331 ++++++++++++--
fs/xfs/xfs_attr_item.h          |  10 +
fs/xfs/xfs_attr_list.c          |  13 +-
fs/xfs/xfs_export.c             |   2 +-
fs/xfs/xfs_export.h             |   2 +
fs/xfs/xfs_handle.c             | 952 ++++++++++++++++++++++++++++++++++++++++
fs/xfs/xfs_handle.h             |  33 ++
fs/xfs/xfs_inode.c              | 218 +++++++--
fs/xfs/xfs_inode.h              |   2 +-
fs/xfs/xfs_ioctl.c              | 595 +------------------------
fs/xfs/xfs_ioctl.h              |  28 --
fs/xfs/xfs_ioctl32.c            |   1 +
fs/xfs/xfs_iops.c               |  15 +-
fs/xfs/xfs_super.c              |  14 +
fs/xfs/xfs_symlink.c            |  30 +-
fs/xfs/xfs_trace.c              |   1 +
fs/xfs/xfs_trace.h              |  95 +++-
fs/xfs/xfs_xattr.c              |   5 +
42 files changed, 2807 insertions(+), 832 deletions(-)
create mode 100644 fs/xfs/libxfs/xfs_parent.c
create mode 100644 fs/xfs/libxfs/xfs_parent.h
create mode 100644 fs/xfs/libxfs/xfs_trans_space.c
create mode 100644 fs/xfs/xfs_handle.c
create mode 100644 fs/xfs/xfs_handle.h

