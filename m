Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C495223
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230403; cv=none; b=eIbzGOg0F1xxCWjtXFQ/6N9rUtFv+9SyP9wT0QWwloshMvhY6gFAJenLVaxq2gLLIfhtCHBd28Kxh4zkQ2CC04pU8ty6QDjBcBG1kxJkKobU6ycsBMLP2CuHVlylgC7Hdr87SC3Y6cHmLW7+s6cNqFLELun+6/fWpBWYnvJjjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230403; c=relaxed/simple;
	bh=bxCdkDkWXuSKiMsGzjwkGQYhuVVzRafdqJlW8Lw6l8g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/DwqG5gUk/3FJCDv2p3PflKBjj73HEBoa0x8No8fL6X4LpMoklyiwj9ix+8ZVg+lBAMjW2fP+tksUkedvR5IZRK20Txbwgy45A4XltRdw+m/Mc0OPY9Oej3nqrF7yBz0YVyurKRebVfiZDoPnGO8wy/TOEIpfcXNMiPiwVsr68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mm9kt3vU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mm9kt3vU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3E6C113CC;
	Tue, 16 Apr 2024 01:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230403;
	bh=bxCdkDkWXuSKiMsGzjwkGQYhuVVzRafdqJlW8Lw6l8g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mm9kt3vU+z9UN7jOkq6bZobuRk0AXD5DzA8CsLH55GhhDGHZ25GBb1VaWwj3LzsWf
	 OQyNrjWgjtIJpKqRoK2krDRTPBpex/E/4vfouc4OacJ5WbRAiC42OJAjgs1XicK8iS
	 u7pSUHljGWMc9lFdDQOQzO01PnVn2OpYCkBfhBG8XTJiO1HTBUO0XrC2C2xeR3ErVb
	 sjJctTb1GeEW1eAB2Iy/UZ0CUNijSHWxnzz/siAHiHpgWirv5ljFidwjV2FNrIG79f
	 WewxDlzXvvcmhoFQU+wereu0Q7PRr1D9wGma8KTPSrKA/QwzqJ0wM+MMYDqes5TV62
	 1TF4uThexeeQw==
Date: Mon, 15 Apr 2024 18:20:02 -0700
Subject: [PATCHSET v13.2 3/7] xfs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>,
 Dave Chinner <dchinner@redhat.com>, Mark Tinguely <mark.tinguely@oracle.com>,
 allison.henderson@oracle.com, hch@infradead.org, linux-xfs@vger.kernel.org,
 catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
In-Reply-To: <20240416011640.GG11948@frogsfrogsfrogs>
References: <20240416011640.GG11948@frogsfrogsfrogs>
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
 * xfs: rearrange xfs_attr_match parameters
 * xfs: check the flags earlier in xfs_attr_match
 * xfs: move xfs_attr_defer_add to xfs_attr_item.c
 * xfs: create a separate hashname function for extended attributes
 * xfs: add parent pointer support to attribute code
 * xfs: define parent pointer ondisk extended attribute format
 * xfs: allow xattr matching on name and value for parent pointers
 * xfs: refactor xfs_is_using_logged_xattrs checks in attr item recovery
 * xfs: create attr log item opcodes and formats for parent pointers
 * xfs: record inode generation in xattr update log intent items
 * xfs: Expose init_xattrs in xfs_create_tmpfile
 * xfs: add parent pointer validator functions
 * xfs: extend transaction reservations for parent attributes
 * xfs: create a hashname function for parent pointers
 * xfs: parent pointer attribute creation
 * xfs: add parent attributes to link
 * xfs: add parent attributes to symlink
 * xfs: remove parent pointers in unlink
 * xfs: Add parent pointers to rename
 * xfs: Add parent pointers to xfs_cross_rename
 * xfs: don't return XFS_ATTR_PARENT attributes via listxattr
 * xfs: pass the attr value to put_listent when possible
 * xfs: move handle ioctl code to xfs_handle.c
 * xfs: split out handle management helpers a bit
 * xfs: actually check the fsid of a handle
 * xfs: add parent pointer ioctls
 * xfs: don't remove the attr fork when parent pointers are enabled
 * xfs: add a incompat feature bit for parent pointers
 * xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
 * xfs: drop compatibility minimum log size computations for reflink
 * xfs: enable parent pointers
---
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_attr.c        |   92 ++--
 fs/xfs/libxfs/xfs_attr.h        |   23 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |   83 +++
 fs/xfs/libxfs/xfs_attr_sf.h     |    1 
 fs/xfs/libxfs/xfs_da_btree.h    |    4 
 fs/xfs/libxfs/xfs_da_format.h   |   25 +
 fs/xfs/libxfs/xfs_format.h      |    4 
 fs/xfs/libxfs/xfs_fs.h          |   78 +++
 fs/xfs/libxfs/xfs_log_format.h  |   25 +
 fs/xfs/libxfs/xfs_log_rlimit.c  |   46 ++
 fs/xfs/libxfs/xfs_ondisk.h      |    6 
 fs/xfs/libxfs/xfs_parent.c      |  293 ++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   99 ++++
 fs/xfs/libxfs/xfs_sb.c          |    4 
 fs/xfs/libxfs/xfs_trans_resv.c  |  326 +++++++++++--
 fs/xfs/libxfs/xfs_trans_space.c |  121 +++++
 fs/xfs/libxfs/xfs_trans_space.h |   25 +
 fs/xfs/scrub/attr.c             |   15 -
 fs/xfs/scrub/dir_repair.c       |    2 
 fs/xfs/scrub/orphanage.c        |    5 
 fs/xfs/scrub/parent_repair.c    |    3 
 fs/xfs/scrub/symlink_repair.c   |    2 
 fs/xfs/scrub/tempfile.c         |    2 
 fs/xfs/xfs_attr_item.c          |  327 ++++++++++++--
 fs/xfs/xfs_attr_item.h          |   12 
 fs/xfs/xfs_attr_list.c          |   13 -
 fs/xfs/xfs_export.c             |    2 
 fs/xfs/xfs_export.h             |    2 
 fs/xfs/xfs_handle.c             |  944 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_handle.h             |   33 +
 fs/xfs/xfs_inode.c              |  218 ++++++++-
 fs/xfs/xfs_inode.h              |    2 
 fs/xfs/xfs_ioctl.c              |  595 -------------------------
 fs/xfs/xfs_ioctl.h              |   28 -
 fs/xfs/xfs_ioctl32.c            |    1 
 fs/xfs/xfs_iops.c               |   15 +
 fs/xfs/xfs_super.c              |   14 +
 fs/xfs/xfs_symlink.c            |   30 +
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   95 ++++
 fs/xfs/xfs_xattr.c              |    7 
 fs/xfs/xfs_xattr.h              |    2 
 43 files changed, 2795 insertions(+), 833 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c
 create mode 100644 fs/xfs/xfs_handle.c
 create mode 100644 fs/xfs/xfs_handle.h

