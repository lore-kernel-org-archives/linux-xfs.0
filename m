Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727991AbeLSQP6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Dec 2018 11:15:58 -0500
Date: Thu, 20 Dec 2018 00:18:34 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [ANNOUNCE] xfs-linux: for-next updated to a9d25bde1e9b
Message-ID: <20181219161834.GL30999@dhcp-12-149.nay.redhat.com>
References: <20181218204731.GK27208@magnolia>
 <20181219033431.GH30999@dhcp-12-149.nay.redhat.com>
 <20181219045306.GX27208@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219045306.GX27208@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Dec 18, 2018 at 08:53:06PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 19, 2018 at 11:34:31AM +0800, Zorro Lang wrote:
> > On Tue, Dec 18, 2018 at 12:47:31PM -0800, Darrick J. Wong wrote:
> > > Hi folks,
> > > 
> > > The for-next branch of the xfs-linux repository at:
> > > 
> > > 	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
> > > 
> > > has just been updated.
> > > 
> > > Patches often get missed, so please check if your outstanding patches
> > > were in this update. If they have not been in this update, please
> > > resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
> > > the next update.  I'm still testing Christoph's always_cow patches, so
> > > they're not in this update.
> > > 
> > > The new head of the for-next branch is commit:
> > > 
> > > a9d25bde1e9b xfs: Fix x32 ioctls when cmd numbers differ from ia32.
> > 
> > Hi Darrick,
> > 
> > This update didn't trigger my test, due to my testing trigger base on new
> > xfs-xxxx-fixes-N tag.
> > Did you forget that, or you're planning to add a new tag after you merge
> > Christoph's always_cow patches?
> 
> I was planning to add a tag with whatever (if anything) I push tomorrow.
> That said, I also found that I had questions about the always_cow
> patchset so you might as well start whatever testing you want to do
> right now.

Sure, thanks. I'm testing now. BTW, most of test jobs are still running, just
one of them find a xfs corruption on s390x[1]. I'm trying to reproduce it
again, due to it looks not easy to reproduce.

If there's nothing come to your mind by reading these information, I'll keep
tracking.

Thanks,
Zorro

# mkfs.xfs -f /dev/loop0
meta-data=/dev/loop0             isize=512    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount -t nfs -o hard,intr,vers=4.2 127.0.0.1:/mnt/scratch /mnt/client
# mount -l
/dev/loop0                          10G  2.0G  8.1G  20% /mnt/scratch
127.0.0.1:/mnt/scratch              10G  2.0G  8.1G  20% /mnt/client
# fsstress -d /mnt/client/testdir  -p 100 -n 1000 -v
Then umount nfs and /dev/loop0
# xfs_repair -n /dev/loop0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
would have reset inode 8391532 nlinks from 3 to 5
No modify flag set, skipping filesystem flush and exiting.



> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > New Commits:
> > > 
> > > Colin Ian King (1):
> > >       [8c4ce794ee7a] xfs: clean up indentation issues, remove an unwanted space
> > > 
> > > Darrick J. Wong (10):
> > >       [d6f215f35963] xfs: split up the xfs_reflink_end_cow work into smaller transactions
> > >       [bc9f2b7c8a73] xfs: idiotproof defer op type configuration
> > >       [02b100fb83f9] xfs: streamline defer op type handling
> > >       [66e3237e724c] xfs: const-ify xfs_owner_info arguments
> > >       [7280fedaf3a0] xfs: remove xfs_rmap_ag_owner and friends
> > >       [43004b2a8da2] xfs: add a block to inode count converter
> > >       [83dcdb4469e7] xfs: precalculate inodes and blocks per inode cluster
> > >       [c1b4a321ede0] xfs: precalculate cluster alignment in inodes and blocks
> > >       [2c2d9d3a205a] xfs: count inode blocks correctly in inobt scrub
> > >       [64bafd2f1e48] xfs: require both realtime inodes to mount
> > > 
> > > Dave Chinner (1):
> > >       [43feeea88c9c] xfs: zero length symlinks are not valid
> > > 
> > > Nick Bowler (3):
> > >       [c456d64449ef] xfs: Align compat attrlist_by_handle with native implementation.
> > >       [7ca860e3c1a7] xfs: Fix bulkstat compat ioctls on x32 userspace.
> > >       [a9d25bde1e9b] xfs: Fix x32 ioctls when cmd numbers differ from ia32.
> > > 
> > > Omar Sandoval (1):
> > >       [355e3532132b] xfs: cache minimum realtime summary level
> > > 
> > > Pan Bian (1):
> > >       [fe5ed6c22e94] xfs: libxfs: move xfs_perag_put late
> > > 
> > > 
> > > Code Diffstat:
> > > 
> > >  fs/xfs/libxfs/xfs_ag.c             |   9 +-
> > >  fs/xfs/libxfs/xfs_alloc.c          |  79 ++++++------
> > >  fs/xfs/libxfs/xfs_alloc.h          |   4 +-
> > >  fs/xfs/libxfs/xfs_bmap.c           |   6 +-
> > >  fs/xfs/libxfs/xfs_bmap.h           |   4 +-
> > >  fs/xfs/libxfs/xfs_defer.c          |  67 ++++++-----
> > >  fs/xfs/libxfs/xfs_defer.h          |  37 +++---
> > >  fs/xfs/libxfs/xfs_format.h         |   2 +
> > >  fs/xfs/libxfs/xfs_ialloc.c         |  54 ++++-----
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c   |   7 +-
> > >  fs/xfs/libxfs/xfs_refcount_btree.c |   6 +-
> > >  fs/xfs/libxfs/xfs_rmap.c           | 240 +++++++++++++++++++++----------------
> > >  fs/xfs/libxfs/xfs_rmap.h           |  54 ++++-----
> > >  fs/xfs/libxfs/xfs_rtbitmap.c       |   6 +
> > >  fs/xfs/libxfs/xfs_symlink_remote.c |  14 ++-
> > >  fs/xfs/libxfs/xfs_types.c          |   9 +-
> > >  fs/xfs/scrub/agheader.c            |  25 ++--
> > >  fs/xfs/scrub/agheader_repair.c     |   5 +-
> > >  fs/xfs/scrub/alloc.c               |   4 +-
> > >  fs/xfs/scrub/btree.c               |  45 +++----
> > >  fs/xfs/scrub/btree.h               |  22 ++--
> > >  fs/xfs/scrub/common.c              |  14 +--
> > >  fs/xfs/scrub/common.h              |   2 +-
> > >  fs/xfs/scrub/ialloc.c              |  64 +++++-----
> > >  fs/xfs/scrub/inode.c               |   4 +-
> > >  fs/xfs/scrub/refcount.c            |  16 +--
> > >  fs/xfs/scrub/repair.c              |  54 ++++-----
> > >  fs/xfs/scrub/repair.h              |   7 +-
> > >  fs/xfs/scrub/rmap.c                |  35 +++---
> > >  fs/xfs/scrub/scrub.h               |   4 +-
> > >  fs/xfs/xfs_extfree_item.c          |   5 +-
> > >  fs/xfs/xfs_fsops.c                 |   2 +-
> > >  fs/xfs/xfs_inode.c                 |  16 +--
> > >  fs/xfs/xfs_ioctl32.c               |  58 +++++++--
> > >  fs/xfs/xfs_itable.c                |  14 +--
> > >  fs/xfs/xfs_log_recover.c           |   8 +-
> > >  fs/xfs/xfs_mount.c                 |   4 +
> > >  fs/xfs/xfs_mount.h                 |  11 ++
> > >  fs/xfs/xfs_reflink.c               | 232 ++++++++++++++++++++---------------
> > >  fs/xfs/xfs_rtalloc.c               |  29 +++--
> > >  fs/xfs/xfs_super.c                 |  10 +-
> > >  fs/xfs/xfs_symlink.c               |  33 ++---
> > >  fs/xfs/xfs_trace.h                 |   6 +-
> > >  fs/xfs/xfs_trans.h                 |   7 +-
> > >  fs/xfs/xfs_trans_bmap.c            |  11 +-
> > >  fs/xfs/xfs_trans_extfree.c         |  40 +++----
> > >  fs/xfs/xfs_trans_refcount.c        |  11 +-
> > >  fs/xfs/xfs_trans_rmap.c            |  11 +-
> > >  48 files changed, 737 insertions(+), 670 deletions(-)
