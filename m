Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82012D266
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881531; cv=none; b=YE6G+qUtd2br3dhWwd+G6FvuiB3Hg8CmrGPz5eHswQTJYGHKmXplpf/vrWbzjbfeEldXsPPm+fgt7aX//03mtILvlC8Tt/9rWFA6a3rw4Fp13cJ7hrd3ysmiPsK2QmBx40496akpeEkaKyg9n3ehGVpadvkUdjcdj8yIulnP2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881531; c=relaxed/simple;
	bh=mS49XhcjYhiZsQPFMqG/Alua5JinOgP/hrO1BigA130=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j25faXFraaoqS2ZB0p9DhLlqQqF4a99Hu46mLKZbWvK3QOLNJGDdA6qk8k2RgXRE7fb+p0TcdRAFGvplwLIB3Lh05WD1I2g+ixClLCJ5VPJHc1wTIO5TqxAmYp3Y6tJIrOHwYQSQ5yrcMlZjwE9Nbxh27TLGUMGB46G3sClpAb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ij9xfU37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ij9xfU37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AA1C116B1;
	Tue,  2 Jul 2024 00:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881531;
	bh=mS49XhcjYhiZsQPFMqG/Alua5JinOgP/hrO1BigA130=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ij9xfU37madSBwuUoCHQ9IIIplT9ZC0bT7J/GMHiEUDOmSEzqfTU/kHaueZ/6T0qa
	 gnTeuKJD6AiHHUWOOfbVWrQKdQ4zuhUJWMuqTsMJDi2nCcQpuCBIcsa84SIQOLK+u/
	 GowsqgW0E+Q0TKcUxUZMP8oUZy4dFJXfft1HfzMF+gIAnZL4ameaq6f6YmaCRDJIES
	 4ndI5zCBECJJkMmgkZldXCoQBGif328FN2fRgYe1FuK1k+TdhseZCbDa7dEcPInaFS
	 nvsVSsFHBNohMYMHpurdO8YdKcWLS0k5DECo0NkYDQSnUW0I1J0CQWPZlmVyqjCYJ/
	 eLonhzi02AUNw==
Date: Mon, 01 Jul 2024 17:52:10 -0700
Subject: [PATCHSET v13.7 11/16] xfsprogs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
In-Reply-To: <20240702004322.GJ612460@frogsfrogsfrogs>
References: <20240702004322.GJ612460@frogsfrogsfrogs>
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
 * libxfs: create attr log item opcodes and formats for parent pointers
 * xfs_{db,repair}: implement new attr hash value function
 * xfs_logprint: dump new attr log item fields
 * man: document the XFS_IOC_GETPARENTS ioctl
 * libfrog: report parent pointers to userspace
 * libfrog: add parent pointer support code
 * xfs_io: adapt parent command to new parent pointer ioctls
 * xfs_io: Add i, n and f flags to parent command
 * xfs_logprint: decode parent pointers in ATTRI items fully
 * xfs_spaceman: report file paths
 * xfs_scrub: use parent pointers when possible to report file operations
 * xfs_scrub: use parent pointers to report lost file data
 * xfs_db: report parent pointers in version command
 * xfs_db: report parent bit on xattrs
 * xfs_db: report parent pointers embedded in xattrs
 * xfs_db: obfuscate dirent and parent pointer names consistently
 * libxfs: export attr3_leaf_hdr_from_disk via libxfs_api_defs.h
 * xfs_db: add a parents command to list the parents of a file
 * xfs_db: make attr_set and attr_remove handle parent pointers
 * xfs_db: add link and unlink expert commands
 * xfs_db: compute hashes of parent pointers
 * libxfs: create new files with attr forks if necessary
 * mkfs: Add parent pointers during protofile creation
 * mkfs: enable formatting with parent pointers
---
 db/attr.c                       |   33 ++
 db/attrset.c                    |  202 +++++++++--
 db/attrshort.c                  |   27 ++
 db/field.c                      |   10 +
 db/field.h                      |    3 
 db/hash.c                       |   44 ++
 db/metadump.c                   |  322 +++++++++++++++++-
 db/namei.c                      |  701 +++++++++++++++++++++++++++++++++++++++
 db/sb.c                         |    2 
 include/handle.h                |    1 
 include/xfs_inode.h             |    4 
 io/parent.c                     |  541 +++++++++++-------------------
 libfrog/Makefile                |    2 
 libfrog/fsgeom.c                |    6 
 libfrog/getparents.c            |  355 ++++++++++++++++++++
 libfrog/getparents.h            |   42 ++
 libfrog/paths.c                 |  168 +++++++++
 libfrog/paths.h                 |   25 +
 libhandle/handle.c              |    7 
 libxfs/defer_item.c             |   52 +++
 libxfs/init.c                   |    4 
 libxfs/libxfs_api_defs.h        |   19 +
 libxfs/util.c                   |   19 +
 logprint/log_redo.c             |  217 +++++++++++-
 logprint/logprint.h             |    6 
 man/man2/ioctl_xfs_getparents.2 |  212 ++++++++++++
 man/man8/xfs_db.8               |   59 +++
 man/man8/xfs_io.8               |   32 +-
 man/man8/xfs_spaceman.8         |    7 
 mkfs/lts_4.19.conf              |    3 
 mkfs/lts_5.10.conf              |    3 
 mkfs/lts_5.15.conf              |    3 
 mkfs/lts_5.4.conf               |    3 
 mkfs/lts_6.1.conf               |    3 
 mkfs/lts_6.6.conf               |    3 
 mkfs/proto.c                    |   62 +++
 mkfs/xfs_mkfs.c                 |   45 ++-
 repair/attr_repair.c            |   24 +
 scrub/common.c                  |   41 ++
 scrub/phase6.c                  |   75 ++++
 spaceman/Makefile               |   16 +
 spaceman/file.c                 |    7 
 spaceman/health.c               |   53 ++-
 spaceman/space.h                |    3 
 44 files changed, 2942 insertions(+), 524 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h
 create mode 100644 man/man2/ioctl_xfs_getparents.2

