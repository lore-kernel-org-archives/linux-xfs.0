Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B6217CCB
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 18:33:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 887ECAC001
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 16:33:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	S9rfUDm9c4WRnHHS for <xfs@oss.sgi.com>;
	Fri, 05 Aug 2016 16:32:58 -0700 (PDT)
Date: Sat, 6 Aug 2016 09:32:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: reverse mapping support for 4.8-rc1
Message-ID: <20160805233256.GA19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

This is the second part of the XFS updates for this merge cycle.
This pullreq contains the new reverse block mapping feature for XFS,
and can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-rmap-for-linus-4.8-rc1

The full request-pull output is at the bottom of this email.

I'm later with the pullreq than I wanted to be because of a few late
review issues that were spotted and needed fixing.  The result of
this is that the entire series of commits are new - I had to remove
a couple of patches from the start of the series (they went to Al
instead) and so everything effectively rebased.

Because everything rebased, I cleaned up all the commit messages and
tagged them appropriately, but otherwise left the code unchanged.
Fixes from reviews were appended as the last few commits rather than
merging them back in the original commits.

Given this, I'll be up front and state that I think asking you to
pull this is clearly trying to bend the rules a bit. However, it has
been in linux-next for two days now and there's been no reports of
build failures or regressions, so I think it is OK from a build
persepective. For existing users, I've done a substantial amount of
testing over the past 3-4 weeks and existing filesystems show no
functional or performance regressions. Hence I think there is
minimal risk for developers and existing users in merging this now.

I will, however, leave the final determination to your judgement -
if you have any problems with the code or reservations about what
has been done so far, we can leave merging it to the next cycle.

If you do merge it, then there will be a follow-up bug fix pullreq
in the next week or two - we have a couple of regression fixes from
the first pullreq being tested right now, and there will be more
fixes for the new rmap code as we shake it out. Overall, however,
it's looking pretty solid.

What it is:

Reverse mapping allows us to track the owner of a specific block on
disk precisely. It is implemented as a set of btrees (one per
allocation group) that track the owners of allocated extents.
Effectively it is a "used space tree" that is updated when we
allocate or free extents. i.e. it is coherent with the free space
btrees we already maintain and never overlaps with them.

This reverse mapping infrastructure is the building block of several
upcoming features - reflink, copy-on-write data, dedupe, online
metadata and data scrubbing, highly accurate bad sector/data loss
reporting to users, and significantly improved reconstruction of
damaged and corrupted filesystems. There's a lot of new stuff coming
along in the next couple of cycles,a nd it all builds in the rmap
infrastructure.

As such, it's a huge chunk of new code with new on-disk format
features and internal infrastructure. It warns at mount time as an
experimental feature and that it may eat data (as we do with all new
on-disk features until they stabilise).  We have not released
userspace suport for it yet - userspace support currently requires
download from Darrick's xfsprogs repo and build from source, so the
access to this feature is really developer/tester only at this
point. Initial userspace support will be released at the same time
kernel with this code in it is released.

The new rmap enabled code regresses 3 xfstests - all are ENOSPC
related corner cases, one of which Darrick posted a fix for a few
hours ago. The other two are fixed by infrastructure that is part of
the upcoming reflink patchset. This new ENOSPC infrastructure
requires a on-disk format tweak required to keep mount times in
check - we need to keep an on-disk count of allocated rmapbt blocks
so we don't have to scan the entire btrees at mount time to count
them. This is currently being tested and will be part of the fixes
sent in the next week or two so users will not be exposed to this
change.

-Dave.


The following changes since commit f2bdfda9a1c668539bc85baf5625f6f14bc510b1:

  Merge branch 'xfs-4.8-misc-fixes-4' into for-next (2016-07-22 14:10:56 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-rmap-for-linus-4.8-rc1

for you to fetch changes up to 3481b68285238054be519ad0c8cad5cc2425e26c:

  xfs: move (and rename) the deferred bmap-free tracepoints (2016-08-03 12:31:07 +1000)

----------------------------------------------------------------
xfs: reverse block mapping support for 4.8-rc1

----------------------------------------------------------------
Darrick J. Wong (52):
      xfs: in _attrlist_by_handle, copy the cursor back to userspace
      xfs: fix attr shortform structure alignment on cris
      xfs: fix locking of the rt bitmap/summary inodes
      xfs: set *stat=1 after iroot realloc
      xfs: during btree split, save new block key & ptr for future insertion
      xfs: add function pointers for get/update keys to the btree
      xfs: support btrees with overlapping intervals for keys
      xfs: introduce interval queries on btrees
      xfs: refactor btree owner change into a separate visit-blocks function
      xfs: move deferred operations into a separate file
      xfs: add tracepoints for the deferred ops mechanism
      xfs: clean up typedef usage in the EFI/EFD handling code
      xfs: enable the xfs_defer mechanism to process extents to free
      xfs: rework xfs_bmap_free callers to use xfs_defer_ops
      xfs: change xfs_bmap_{finish,cancel,init,free} -> xfs_defer_*
      xfs: rename flist/free_list to dfops
      xfs: refactor redo intent item processing
      xfs: add tracepoints and error injection for deferred extent freeing
      xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
      xfs: introduce rmap btree definitions
      xfs: add rmap btree stats infrastructure
      xfs: rmap btree add more reserved blocks
      xfs: add owner field to extent allocation and freeing
      xfs: introduce rmap extent operation stubs
      xfs: define the on-disk rmap btree format
      xfs: add rmap btree growfs support
      xfs: rmap btree transaction reservations
      xfs: rmap btree requires more reserved free space
      xfs: add rmap btree operations
      xfs: support overlapping intervals in the rmap btree
      xfs: teach rmapbt to support interval queries
      xfs: add tracepoints for the rmap functions
      xfs: add an extent to the rmap btree
      xfs: remove an extent from the rmap btree
      xfs: convert unwritten status of reverse mappings
      xfs: add rmap btree insert and delete helpers
      xfs: create rmap update intent log items
      xfs: log rmap intent items
      xfs: enable the xfs_defer mechanism to process rmaps to update
      xfs: propagate bmap updates to rmapbt
      xfs: add rmap btree geometry feature flag
      xfs: add rmap btree block detection to log recovery
      xfs: disable XFS_IOC_SWAPEXT when rmap btree is enabled
      xfs: don't update rmapbt when fixing agfl
      xfs: enable the rmap btree functionality
      xfs: remove the get*keys and update_keys btree ops pointers
      xfs: remove unnecesary lshift/rshift key initialization
      xfs: in btree_lshift, only allocate temporary cursor when needed
      xfs: remove the extents array from the rmap update done log item
      xfs: remove unnecessary parentheses from log redo item recovery functions
      xfs: collapse single use static functions
      xfs: move (and rename) the deferred bmap-free tracepoints

 fs/xfs/Makefile                  |    5 +
 fs/xfs/libxfs/xfs_alloc.c        |  149 +++-
 fs/xfs/libxfs/xfs_alloc.h        |   52 +-
 fs/xfs/libxfs/xfs_alloc_btree.c  |   12 -
 fs/xfs/libxfs/xfs_attr.c         |   71 +-
 fs/xfs/libxfs/xfs_attr_leaf.c    |    4 +-
 fs/xfs/libxfs/xfs_attr_remote.c  |   19 +-
 fs/xfs/libxfs/xfs_bmap.c         |  241 ++++---
 fs/xfs/libxfs/xfs_bmap.h         |   54 +-
 fs/xfs/libxfs/xfs_bmap_btree.c   |   32 +-
 fs/xfs/libxfs/xfs_btree.c        |  914 +++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h        |   88 ++-
 fs/xfs/libxfs/xfs_da_btree.c     |    6 +-
 fs/xfs/libxfs/xfs_da_btree.h     |    4 +-
 fs/xfs/libxfs/xfs_da_format.h    |    1 +
 fs/xfs/libxfs/xfs_defer.c        |  463 +++++++++++++
 fs/xfs/libxfs/xfs_defer.h        |   97 +++
 fs/xfs/libxfs/xfs_dir2.c         |   15 +-
 fs/xfs/libxfs/xfs_dir2.h         |    8 +-
 fs/xfs/libxfs/xfs_format.h       |  131 +++-
 fs/xfs/libxfs/xfs_fs.h           |    1 +
 fs/xfs/libxfs/xfs_ialloc.c       |   23 +-
 fs/xfs/libxfs/xfs_ialloc.h       |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   18 +-
 fs/xfs/libxfs/xfs_inode_buf.c    |    1 +
 fs/xfs/libxfs/xfs_log_format.h   |   63 +-
 fs/xfs/libxfs/xfs_rmap.c         | 1399 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h         |  209 ++++++
 fs/xfs/libxfs/xfs_rmap_btree.c   |  511 ++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h   |   61 ++
 fs/xfs/libxfs/xfs_sb.c           |    9 +
 fs/xfs/libxfs/xfs_shared.h       |    2 +
 fs/xfs/libxfs/xfs_trans_resv.c   |   62 +-
 fs/xfs/libxfs/xfs_trans_resv.h   |   10 -
 fs/xfs/libxfs/xfs_types.h        |    4 +-
 fs/xfs/xfs_bmap_util.c           |  139 +---
 fs/xfs/xfs_bmap_util.h           |    4 +-
 fs/xfs/xfs_discard.c             |    2 +-
 fs/xfs/xfs_dquot.c               |   13 +-
 fs/xfs/xfs_error.h               |    6 +-
 fs/xfs/xfs_extfree_item.c        |   69 ++
 fs/xfs/xfs_extfree_item.h        |    3 +
 fs/xfs/xfs_filestream.c          |    3 +-
 fs/xfs/xfs_fsops.c               |  106 ++-
 fs/xfs/xfs_inode.c               |   99 +--
 fs/xfs/xfs_inode.h               |    4 +-
 fs/xfs/xfs_ioctl.c               |    6 +
 fs/xfs/xfs_iomap.c               |   31 +-
 fs/xfs/xfs_log_recover.c         |  336 ++++++---
 fs/xfs/xfs_mount.c               |    7 +-
 fs/xfs/xfs_mount.h               |    6 +
 fs/xfs/xfs_ondisk.h              |    3 +
 fs/xfs/xfs_rmap_item.c           |  536 +++++++++++++++
 fs/xfs/xfs_rmap_item.h           |   95 +++
 fs/xfs/xfs_rtalloc.c             |   11 +-
 fs/xfs/xfs_stats.c               |    1 +
 fs/xfs/xfs_stats.h               |   18 +-
 fs/xfs/xfs_super.c               |   30 +-
 fs/xfs/xfs_symlink.c             |   25 +-
 fs/xfs/xfs_trace.c               |    2 +
 fs/xfs/xfs_trace.h               |  374 ++++++++++
 fs/xfs/xfs_trans.h               |   26 +-
 fs/xfs/xfs_trans_extfree.c       |  215 ++++--
 fs/xfs/xfs_trans_rmap.c          |  271 ++++++++
 64 files changed, 6267 insertions(+), 915 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_defer.c
 create mode 100644 fs/xfs/libxfs/xfs_defer.h
 create mode 100644 fs/xfs/libxfs/xfs_rmap.c
 create mode 100644 fs/xfs/libxfs/xfs_rmap.h
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.h
 create mode 100644 fs/xfs/xfs_rmap_item.c
 create mode 100644 fs/xfs/xfs_rmap_item.h
 create mode 100644 fs/xfs/xfs_trans_rmap.c
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
