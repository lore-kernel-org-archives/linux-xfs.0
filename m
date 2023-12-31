Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234AFB645
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 19:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+7yLckz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3BCC433C8;
	Sun, 31 Dec 2023 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704051222;
	bh=QGJm75RrIKa/hspUOjLOkN/B753xowCFkoyqK6qEZbk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H+7yLckzJMVpeUPxtU7uAYXqbPaNTpRnarEtK3CbO5hfrHaYLhJs8rZCxcABzor+n
	 UHrDluKlNXLnLW/A+1D0sF3KdRj2JV38kCsccs1UnyeUCUhIc/o+k1fvYIcTVOMRWb
	 iWC4AXEf0xJz4XIc67R8BKyMuSDqLFwzmXzeJBFqBCRcuI9C2mcYqcM2nANXMPnehs
	 OwsAK+lBBj08xc+JFIuXzkYrKD7lMjtqSw95Rqgvjl05tmixY4ZWmXmXXj4kPg1sPB
	 kOYPP7kNHu4yStjqGxbFJ6dZjINSXfGbzIAc08g+oYsETQVr0aVRCC9VB69dv+VzMO
	 +Q93S40IxnRuw==
Date: Sun, 31 Dec 2023 11:33:42 -0800
Subject: [PATCHSET v13.0 4/7] xfs: Parent Pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Mark Tinguely <tinguely@sgi.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 Dave Chinner <dchinner@redhat.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <170404840995.1756905.18018727013229504371.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_attr.c        |   15 +-
 fs/xfs/libxfs/xfs_attr.h        |   10 +
 fs/xfs/libxfs/xfs_attr_leaf.c   |    6 -
 fs/xfs/libxfs/xfs_attr_sf.h     |    1 
 fs/xfs/libxfs/xfs_da_format.h   |   33 +++
 fs/xfs/libxfs/xfs_format.h      |    4 
 fs/xfs/libxfs/xfs_fs.h          |    2 
 fs/xfs/libxfs/xfs_fs_staging.h  |   66 +++++++
 fs/xfs/libxfs/xfs_log_format.h  |    1 
 fs/xfs/libxfs/xfs_log_rlimit.c  |   43 +++++
 fs/xfs/libxfs/xfs_ondisk.h      |    4 
 fs/xfs/libxfs/xfs_parent.c      |  368 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  155 ++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    4 
 fs/xfs/libxfs/xfs_trans_resv.c  |  326 +++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_trans_space.c |  121 +++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |   25 +--
 fs/xfs/scrub/attr.c             |    4 
 fs/xfs/scrub/dir_repair.c       |    2 
 fs/xfs/scrub/orphanage.c        |    5 -
 fs/xfs/scrub/parent_repair.c    |    3 
 fs/xfs/scrub/symlink_repair.c   |    2 
 fs/xfs/scrub/tempfile.c         |    2 
 fs/xfs/xfs_attr_item.c          |   42 ++++
 fs/xfs/xfs_attr_list.c          |   25 ++-
 fs/xfs/xfs_inode.c              |  199 +++++++++++++++++----
 fs/xfs/xfs_inode.h              |    2 
 fs/xfs/xfs_ioctl.c              |  146 +++++++++++++++
 fs/xfs/xfs_iops.c               |   15 +-
 fs/xfs/xfs_parent_utils.c       |  161 +++++++++++++++++
 fs/xfs/xfs_parent_utils.h       |   20 ++
 fs/xfs/xfs_super.c              |   14 +
 fs/xfs/xfs_symlink.c            |   28 ++-
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   76 ++++++++
 fs/xfs/xfs_xattr.c              |    8 +
 fs/xfs/xfs_xattr.h              |    2 
 38 files changed, 1806 insertions(+), 138 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

