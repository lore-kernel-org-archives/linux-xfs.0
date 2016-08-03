Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F2E3C7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 16:57:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7715CAC002
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 14:57:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id r4qc9VkEqDeaRrxm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 14:57:01 -0700 (PDT)
Date: Wed, 3 Aug 2016 14:56:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to 3481b68
Message-ID: <20160803215656.GH8593@birch.djwong.org>
References: <20160803120901.GT16044@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803120901.GT16044@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 10:09:01PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> has just been updated.
> 
> I've just pushed the initial reverse block mapping support code from
> Darrick out to the for-next branch. The code as it stands will work
> for most cases, but it is still definitely considered experimental -
> don't put any data you want to keep on rmap enable filesystems at
> this point. It passes all of xfstests and other local testing
> without regressions for non-rmap filesystems, so existing
> filesystems should be unaffected by this merge.
> 
> Known problems when rmapbt is enabled are:
> 
> 	- On disk format needs a minor tweak to keep a persistent
> 	  count of allocated rmapbt blocks.  This is required for
> 	  sensible mount time behaviour of the upcoming AG
> 	  reservation code, and will be merged as soon as the patch
> 	  Darrick posted earlier this evening is reviewed and
> 	  tested.
> 	- hangs/corrupts/assert fails at ENOSPC because of
> 	  insufficient free block reservations. I can reproduce this
> 	  with generic/274, it will be solved by the AG reservation
> 	  code that currently sits in the reflink patchset.
> 	- assert fails on generic/299. This is another ENOSPC test,
> 	  but we haven't got to the bottom of this failure yet.
> 
> There are still some pending code cleanups as a result of review;
> these don't affect operation or the on-disk format, so they will be
> merged when they are done and tested. I expect we'll end up doing a
> -rc2 or -rc3 update with the bug fixes and tweaks we accumulate over
> the next week or two.
> 
> The plan now is to leave this in for-next for the next two
> days. If no showstoppers are reported, I will send Linus a pull
> request for this code, and hopefully he'll merge it. Ultimately
> merging will be his call because we are /very/ late in the cycle
> with this.
> 
> It would be a good idea for anyone who has a spare cycle or two to
> build rmap enabled filesysetms and smoke test them through xfstests
> on their test machines in the next couple of days. Darrick's latest
> userspace tree is at https://github.com/djwong/xfsprogs.git, and
> IIRC I've been using the "djwong-devel" branch for testing. Darrick
> can clarify which is best to use at this point.

https://github.com/djwong/xfsprogs/tree/for-dave-for-4.8

This is xfsprogs#for-next with just the reverse mapping patches applied.
The last patch is a little sloppy, but it does add agf_rmap_blocks support
to the three tools that really need it.

As a warning to anyone who's been testing rmap/reflink filesystems, we're
adding two fields to the AGF to track the # of blocks used by the rmap
and refcount trees, which is an on-disk format change.  The familiar
-devel/-experimental/-wtf trees haven't been updated to reflect this
and probably won't until after the merge window closes.

--D

> If anyone has any questions or problems then send mail to the list
> or grab djwong or myself on the #xfs channel on freenode.
> 
> -Dave.
> 
> The new head of the for-next branch is commit:
> 
> 3481b68 xfs: move (and rename) the deferred bmap-free tracepoints
> 
> New Commits:
> 
> Darrick J. Wong (52):
>       [0facef7] xfs: in _attrlist_by_handle, copy the cursor back to userspace
>       [3dadf90] xfs: fix attr shortform structure alignment on cris
>       [f4a0660] xfs: fix locking of the rt bitmap/summary inodes
>       [0d30979] xfs: set *stat=1 after iroot realloc
>       [e5821e5] xfs: during btree split, save new block key & ptr for future insertion
>       [70b2265] xfs: add function pointers for get/update keys to the btree
>       [2c813ad] xfs: support btrees with overlapping intervals for keys
>       [105f7d8] xfs: introduce interval queries on btrees
>       [28a8956] xfs: refactor btree owner change into a separate visit-blocks function
>       [4e0cc29] xfs: move deferred operations into a separate file
>       [3cd48ab] xfs: add tracepoints for the deferred ops mechanism
>       [bba61cb] xfs: clean up typedef usage in the EFI/EFD handling code
>       [9749fee] xfs: enable the xfs_defer mechanism to process extents to free
>       [3ab78df] xfs: rework xfs_bmap_free callers to use xfs_defer_ops
>       [310a75a] xfs: change xfs_bmap_{finish,cancel,init,free} -> xfs_defer_*
>       [2c3234d] xfs: rename flist/free_list to dfops
>       [dc42375] xfs: refactor redo intent item processing
>       [ba9e780] xfs: add tracepoints and error injection for deferred extent freeing
>       [df3954f] xfs: increase XFS_BTREE_MAXLEVELS to fit the rmapbt
>       [b870494] xfs: introduce rmap btree definitions
>       [00f4e4f] xfs: add rmap btree stats infrastructure
>       [8018026] xfs: rmap btree add more reserved blocks
>       [340785c] xfs: add owner field to extent allocation and freeing
>       [673930c] xfs: introduce rmap extent operation stubs
>       [035e00a] xfs: define the on-disk rmap btree format
>       [e70d829] xfs: add rmap btree growfs support
>       [fa30f03] xfs: rmap btree transaction reservations
>       [5254885] xfs: rmap btree requires more reserved free space
>       [4b8ed67] xfs: add rmap btree operations
>       [cfed56a] xfs: support overlapping intervals in the rmap btree
>       [c543838] xfs: teach rmapbt to support interval queries
>       [aa966d8] xfs: add tracepoints for the rmap functions
>       [0a1b0b3] xfs: add an extent to the rmap btree
>       [f922cd9] xfs: remove an extent from the rmap btree
>       [fb7d926] xfs: convert unwritten status of reverse mappings
>       [abf0923] xfs: add rmap btree insert and delete helpers
>       [5880f2d7] xfs: create rmap update intent log items
>       [9e88b5d] xfs: log rmap intent items
>       [f8dbebe] xfs: enable the xfs_defer mechanism to process rmaps to update
>       [9c19464] xfs: propagate bmap updates to rmapbt
>       [5d650e9] xfs: add rmap btree geometry feature flag
>       [a650e8f] xfs: add rmap btree block detection to log recovery
>       [2b0eeb5] xfs: disable XFS_IOC_SWAPEXT when rmap btree is enabled
>       [04f1306] xfs: don't update rmapbt when fixing agfl
>       [1c0607a] xfs: enable the rmap btree functionality
>       [973b831] xfs: remove the get*keys and update_keys btree ops pointers
>       [1f704b2] xfs: remove unnecesary lshift/rshift key initialization
>       [c1d22ae] xfs: in btree_lshift, only allocate temporary cursor when needed
>       [722e251] xfs: remove the extents array from the rmap update done log item
>       [e127faf] xfs: remove unnecessary parentheses from log redo item recovery functions
>       [51ce9d0] xfs: collapse single use static functions
>       [3481b68] xfs: move (and rename) the deferred bmap-free tracepoints
> 
> 
> Code Diffstat:
> 
>  fs/xfs/Makefile                  |    5 +
>  fs/xfs/libxfs/xfs_alloc.c        |  149 ++++-
>  fs/xfs/libxfs/xfs_alloc.h        |   52 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c  |   12 -
>  fs/xfs/libxfs/xfs_attr.c         |   71 +--
>  fs/xfs/libxfs/xfs_attr_leaf.c    |    4 +-
>  fs/xfs/libxfs/xfs_attr_remote.c  |   19 +-
>  fs/xfs/libxfs/xfs_bmap.c         |  241 +++----
>  fs/xfs/libxfs/xfs_bmap.h         |   54 +-
>  fs/xfs/libxfs/xfs_bmap_btree.c   |   32 +-
>  fs/xfs/libxfs/xfs_btree.c        |  914 ++++++++++++++++++++++-----
>  fs/xfs/libxfs/xfs_btree.h        |   88 ++-
>  fs/xfs/libxfs/xfs_da_btree.c     |    6 +-
>  fs/xfs/libxfs/xfs_da_btree.h     |    4 +-
>  fs/xfs/libxfs/xfs_da_format.h    |    1 +
>  fs/xfs/libxfs/xfs_defer.c        |  463 ++++++++++++++
>  fs/xfs/libxfs/xfs_defer.h        |   97 +++
>  fs/xfs/libxfs/xfs_dir2.c         |   15 +-
>  fs/xfs/libxfs/xfs_dir2.h         |    8 +-
>  fs/xfs/libxfs/xfs_format.h       |  131 +++-
>  fs/xfs/libxfs/xfs_fs.h           |    1 +
>  fs/xfs/libxfs/xfs_ialloc.c       |   23 +-
>  fs/xfs/libxfs/xfs_ialloc.h       |    2 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   18 +-
>  fs/xfs/libxfs/xfs_inode_buf.c    |    1 +
>  fs/xfs/libxfs/xfs_log_format.h   |   63 +-
>  fs/xfs/libxfs/xfs_rmap.c         | 1399 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_rmap.h         |  209 ++++++
>  fs/xfs/libxfs/xfs_rmap_btree.c   |  511 +++++++++++++++
>  fs/xfs/libxfs/xfs_rmap_btree.h   |   61 ++
>  fs/xfs/libxfs/xfs_sb.c           |    9 +
>  fs/xfs/libxfs/xfs_shared.h       |    2 +
>  fs/xfs/libxfs/xfs_trans_resv.c   |   62 +-
>  fs/xfs/libxfs/xfs_trans_resv.h   |   10 -
>  fs/xfs/libxfs/xfs_types.h        |    4 +-
>  fs/xfs/xfs_bmap_util.c           |  139 +---
>  fs/xfs/xfs_bmap_util.h           |    4 +-
>  fs/xfs/xfs_discard.c             |    2 +-
>  fs/xfs/xfs_dquot.c               |   13 +-
>  fs/xfs/xfs_error.h               |    6 +-
>  fs/xfs/xfs_extfree_item.c        |   69 ++
>  fs/xfs/xfs_extfree_item.h        |    3 +
>  fs/xfs/xfs_filestream.c          |    3 +-
>  fs/xfs/xfs_fsops.c               |  106 +++-
>  fs/xfs/xfs_inode.c               |   99 +--
>  fs/xfs/xfs_inode.h               |    4 +-
>  fs/xfs/xfs_ioctl.c               |    6 +
>  fs/xfs/xfs_iomap.c               |   31 +-
>  fs/xfs/xfs_log_recover.c         |  336 +++++++---
>  fs/xfs/xfs_mount.c               |    7 +-
>  fs/xfs/xfs_mount.h               |    6 +
>  fs/xfs/xfs_ondisk.h              |    3 +
>  fs/xfs/xfs_rmap_item.c           |  536 ++++++++++++++++
>  fs/xfs/xfs_rmap_item.h           |   95 +++
>  fs/xfs/xfs_rtalloc.c             |   11 +-
>  fs/xfs/xfs_stats.c               |    1 +
>  fs/xfs/xfs_stats.h               |   18 +-
>  fs/xfs/xfs_super.c               |   30 +-
>  fs/xfs/xfs_symlink.c             |   25 +-
>  fs/xfs/xfs_trace.c               |    2 +
>  fs/xfs/xfs_trace.h               |  374 +++++++++++
>  fs/xfs/xfs_trans.h               |   26 +-
>  fs/xfs/xfs_trans_extfree.c       |  215 +++++--
>  fs/xfs/xfs_trans_rmap.c          |  271 ++++++++
>  64 files changed, 6267 insertions(+), 915 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_defer.c
>  create mode 100644 fs/xfs/libxfs/xfs_defer.h
>  create mode 100644 fs/xfs/libxfs/xfs_rmap.c
>  create mode 100644 fs/xfs/libxfs/xfs_rmap.h
>  create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.c
>  create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.h
>  create mode 100644 fs/xfs/xfs_rmap_item.c
>  create mode 100644 fs/xfs/xfs_rmap_item.h
>  create mode 100644 fs/xfs/xfs_trans_rmap.c
> -- 
> Dave Chinner
> david@fromorbit.com



> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
