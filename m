Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2050B64C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tuVkcE5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A7BC433C7;
	Sun, 31 Dec 2023 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704052254;
	bh=DlPeNVQPdzNFp9fA0X9uEgx1BBcb7Aa+J/ckcmCGvkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tuVkcE5dSl2NYQLSaNkveDMjsP9hQ3MaRFNzYkiw8PX5GszZ77UFn+ZUSQ1m598tP
	 S5tNUPOzUccxcq0Y4E70mm2HEGs6stMrkgRJxV6lFZ8DVPmceSe8m+cNs/ncn3fK9w
	 PqDL4yJEAxApGETlVH++RfZbnwf4SUPfHupUoeWiLq9+Zg49/qv66Lt4cxZKNl4svH
	 UfOzn+0z1jV8PxgTLx7tgx6+Ly2EzRpX4Jh2lq6DWtg6uLVzX6Ti/Op+6mEfGPnXix
	 zMrKcY7/04HVxDEIOZTYVmeINasmh+vOzGtxsK55tL2/+fEZtUtsA/gfA168uQ5h0j
	 UuhHCinP/aD4Q==
Date: Sun, 31 Dec 2023 11:50:54 -0800
Subject: [PATCHSET v13.0 3/6] xfsprogs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>,
 Mark Tinguely <tinguely@sgi.com>, Dave Chinner <dchinner@redhat.com>,
 catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com
Message-ID: <170405006077.1804688.8762482665401724622.stgit@frogsfrogsfrogs>
In-Reply-To: <20231231181849.GT361584@frogsfrogsfrogs>
References: <20231231181849.GT361584@frogsfrogsfrogs>
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
 db/attr.c                       |   67 +++++
 db/attrshort.c                  |   51 ++++
 db/metadump.c                   |  325 +++++++++++++++++++++++-
 db/namei.c                      |  335 +++++++++++++++++++++++++
 db/sb.c                         |    2 
 include/handle.h                |    1 
 include/libxfs.h                |    1 
 include/xfs_inode.h             |    6 
 io/parent.c                     |  527 ++++++++++++++-------------------------
 libfrog/Makefile                |    2 
 libfrog/fsgeom.c                |    6 
 libfrog/getparents.c            |  348 ++++++++++++++++++++++++++
 libfrog/getparents.h            |   36 +++
 libfrog/paths.c                 |  183 ++++++++++++++
 libfrog/paths.h                 |   27 ++
 libhandle/handle.c              |    7 -
 libxfs/Makefile                 |    3 
 libxfs/init.c                   |    7 +
 libxfs/libxfs_api_defs.h        |   16 +
 libxfs/libxfs_priv.h            |    6 
 libxfs/util.c                   |   14 +
 libxfs/xfs_attr.c               |   15 +
 libxfs/xfs_attr.h               |   10 -
 libxfs/xfs_attr_leaf.c          |    6 
 libxfs/xfs_attr_sf.h            |    1 
 libxfs/xfs_da_format.h          |   33 ++
 libxfs/xfs_format.h             |    4 
 libxfs/xfs_fs.h                 |    2 
 libxfs/xfs_fs_staging.h         |   66 +++++
 libxfs/xfs_log_format.h         |    1 
 libxfs/xfs_log_rlimit.c         |   43 +++
 libxfs/xfs_ondisk.h             |    4 
 libxfs/xfs_parent.c             |  369 +++++++++++++++++++++++++++
 libxfs/xfs_parent.h             |  155 +++++++++++
 libxfs/xfs_sb.c                 |    4 
 libxfs/xfs_trans_resv.c         |  324 ++++++++++++++++++++----
 libxfs/xfs_trans_space.c        |  121 +++++++++
 libxfs/xfs_trans_space.h        |   25 +-
 logprint/log_redo.c             |   81 ++++++
 man/man2/ioctl_xfs_getparents.2 |  227 +++++++++++++++++
 man/man8/xfs_db.8               |    9 +
 man/man8/xfs_io.8               |   30 +-
 man/man8/xfs_spaceman.8         |    7 -
 mkfs/proto.c                    |   60 +++-
 mkfs/xfs_mkfs.c                 |   31 ++
 repair/attr_repair.c            |   25 +-
 repair/phase6.c                 |   14 +
 scrub/common.c                  |   41 +++
 spaceman/Makefile               |    4 
 spaceman/file.c                 |    7 +
 spaceman/health.c               |   53 +++-
 spaceman/space.h                |    3 
 52 files changed, 3247 insertions(+), 498 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h
 create mode 100644 libxfs/xfs_trans_space.c
 create mode 100644 man/man2/ioctl_xfs_getparents.2

