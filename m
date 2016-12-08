Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47130 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbcLHGgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 01:36:04 -0500
Date: Wed, 7 Dec 2016 22:36:00 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfs: for-next branch updated to a444d72e6090
Message-ID: <20161208063600.GY16813@birch.djwong.org>
References: <20161207202501.GK4326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207202501.GK4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 08, 2016 at 07:25:01AM +1100, Dave Chinner wrote:
> Hi folks,
> 
> The for-next branch of the xfs kernel repository at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git
> 
> has just been updated. This update contains a bunch of verification
> enhancments to detect field corruptions as metadata is read from
> disk, faster CRC calculations, a faster buffer cache indexing
> structure and some cleanups.
> 
> With the merge window likely to open next week, this may be the last
> update for the 4.10-rc1 cycle.  Let me know if there's anything
> critical that I've missed for 4.10 so I can sort it out before the
> end of the week.

Well I /was/ sorta hoping that you'd have time to review the online
scrub patches for 4.10, but unless you're already digging through them I
probably ought to just put out a call for online scrub reviewers for 4.11.

You're not missing anything critical from my trees, however.

--D

> 
> -Dave.
> 
> The new head of the for-next branch is commit:
> 
> a444d72e6090 Merge branch 'xfs-4.10-misc-fixes-3' into for-next
> 
> New Commits:
> 
> Darrick J. Wong (7):
>       [d2a047f31e86] xfs: forbid AG btrees with level == 0
>       [bb3be7e7c1c1] xfs: check for bogus values in btree block headers
>       [356a3225222e] xfs: complain if we don't get nextents bmap records
>       [96a3aefb8ffd] xfs: don't crash if reading a directory results in an unexpected hole
>       [0f352f8ee841] xfs: error out if trying to add attrs and anextents > 0
>       [ef388e2054fe] xfs: don't allow di_size with high bit set
>       [1bb33a98702d] xfs: don't cap maximum dedupe request length
> 
> Dave Chinner (3):
>       [11ef38afe98c] xfs: make xfs btree stats less huge
>       [cae028df5344] xfs: optimise CRC updates
>       [a444d72e6090] Merge branch 'xfs-4.10-misc-fixes-3' into for-next
> 
> Eric Sandeen (5):
>       [6b10b23ca944] xfs: set AGI buffer type in xlog_recover_clear_agi_bucket
>       [200237d6746f] xfs: Move AGI buffer type setting to xfs_read_agi
>       [7710517fc37b] xfs: pass state not whichfork to trace_xfs_extlist
>       [c44a1f22626c] xfs: handle cow fork in xfs_bmap_trace_exlist
>       [f7a136aee3c1] xfs: several xattr functions can be void
> 
> Lucas Stach (1):
>       [6031e73a5b3f] xfs: use rhashtable to track buffer cache
> 
> 
> Code Diffstat:
> 
>  fs/xfs/libxfs/xfs_alloc.c          |  10 +-
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   4 +
>  fs/xfs/libxfs/xfs_attr_leaf.h      |   2 +-
>  fs/xfs/libxfs/xfs_bmap.c           |  14 ++-
>  fs/xfs/libxfs/xfs_bmap_btree.c     |   1 +
>  fs/xfs/libxfs/xfs_btree.c          |  20 ++++
>  fs/xfs/libxfs/xfs_btree.h          |  43 +-------
>  fs/xfs/libxfs/xfs_cksum.h          |  26 ++++-
>  fs/xfs/libxfs/xfs_dir2_data.c      |   2 +-
>  fs/xfs/libxfs/xfs_ialloc.c         |  13 ++-
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   2 +
>  fs/xfs/libxfs/xfs_inode_buf.c      |  10 +-
>  fs/xfs/libxfs/xfs_refcount_btree.c |   1 +
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   1 +
>  fs/xfs/xfs_attr.h                  |   4 +-
>  fs/xfs/xfs_attr_list.c             |  59 ++++-------
>  fs/xfs/xfs_buf.c                   | 120 +++++++++++++---------
>  fs/xfs/xfs_buf.h                   |   2 +-
>  fs/xfs/xfs_file.c                  |   9 --
>  fs/xfs/xfs_inode.c                 |   2 -
>  fs/xfs/xfs_linux.h                 |   1 +
>  fs/xfs/xfs_log.c                   |   2 +-
>  fs/xfs/xfs_log_recover.c           |  12 ++-
>  fs/xfs/xfs_mount.c                 |   7 +-
>  fs/xfs/xfs_mount.h                 |   7 +-
>  fs/xfs/xfs_stats.c                 |  10 +-
>  fs/xfs/xfs_stats.h                 | 200 +++++++++++++++----------------------
>  fs/xfs/xfs_xattr.c                 |  23 ++---
>  28 files changed, 306 insertions(+), 301 deletions(-)
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
