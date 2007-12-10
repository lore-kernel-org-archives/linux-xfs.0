Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 13:55:18 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lBALsjUY013424
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 13:54:54 -0800
Date: Mon, 10 Dec 2007 17:19:46 +1100
Subject: [GIT PULL] XFS update for 2.6.24-rc5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071210061946.C08AD58C4C34@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_buf.c     |   37 +++++-------
 fs/xfs/linux-2.6/xfs_file.c    |  124 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_ioctl.c   |   20 +++----
 fs/xfs/linux-2.6/xfs_ioctl32.c |    3 +
 fs/xfs/linux-2.6/xfs_iops.c    |    4 +-
 fs/xfs/quota/xfs_qm.c          |    3 +
 fs/xfs/xfs_iget.c              |    2 +-
 fs/xfs/xfs_itable.c            |   43 +++++++++-----
 8 files changed, 186 insertions(+), 50 deletions(-)

through these commits:

commit cf10e82bdc0d38d09dfaf46d0daf56136138ef3f
Author: David Chinner <dgc@sgi.com>
Date:   Fri Dec 7 14:09:11 2007 +1100

    [XFS] Fix xfs_ichgtime()s broken usage of I_SYNC
    
    The recent I_LOCK->I_SYNC changes mistakenly changed xfs_ichgtime to look
    at I_SYNC instead of I_LOCK. This was incorrect and prevents newly created
    inodes from moving to the dirty list. Change this to the correct check
    which is for I_NEW, not I_LOCK or I_SYNC so that behaviour is correct.
    
    SGI-PV: 974225
    SGI-Modid: xfs-linux-melb:xfs-kern:30204a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 978c7b2ff49597ab76ff7529a933bd366941ac25
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Fri Dec 7 14:09:02 2007 +1100

    [XFS] Make xfsbufd threads freezable
    
    Fix breakage caused by commit 831441862956fffa17b9801db37e6ea1650b0f69
    that did not introduce the necessary call to set_freezable() in
    xfs/linux-2.6/xfs_buf.c .
    
    SGI-PV: 974224
    SGI-Modid: xfs-linux-melb:xfs-kern:30203a
    
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit e89bc612d61edbcefaeb6f2244f86c0f3ec89d23
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 7 14:07:53 2007 +1100

    [XFS] revert to double-buffering readdir
    
    The current readdir implementation deadlocks on a btree buffers locks
    because nfsd calls back into ->lookup from the filldir callback. The only
    short-term fix for this is to revert to the old inefficient
    double-buffering scheme.
    
    SGI-PV: 973377
    SGI-Modid: xfs-linux-melb:xfs-kern:30201a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit a7430847fcb19297d6db833f35b9c9645c4a6395
Author: David Chinner <dgc@sgi.com>
Date:   Fri Nov 23 16:30:23 2007 +1100

    [XFS] Fix broken inode cluster setup.
    
    The radix tree based inode caches did away with the inode cluster hashes,
    replacing them with a bunch of masking and gang lookups on the radix tree.
    
    This masking got broken when moving the code to per-ag radix trees and
    indexing by agino # rather than straight inode number. The result is
    clustered inode writeback does not cluster and things can go extremely
    slowly when there are lots of inodes to write.
    
    Fix it up by comparing the agino # of the inode we just looked up to the
    index of the cluster we are looking for.
    
    Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
    
    SGI-PV: 972915
    SGI-Modid: xfs-linux-melb:xfs-kern:30033a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 77be55a5a13d9c7ddf780a93861f2fba33f8be1a
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Nov 23 16:31:00 2007 +1100

    [XFS] Clear XBF_READ_AHEAD flag on I/O completion.
    
    SGI-PV: 972554
    SGI-Modid: xfs-linux-melb:xfs-kern:30128a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>

commit d1afb678ce77b930334a8a640a05b8e68178a377
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Tue Nov 27 17:01:24 2007 +1100

    [XFS] Fixed a few bugs in xfs_buf_associate_memory()
    
    - calculation of 'page_count' was incorrect as it did not
      consider the offset of 'mem' into the first page. The
      logic to bump 'page_count' didn't work if 'len' was <=
      PAGE_CACHE_SIZE (ie offset = 3k, len = 2k).
    - setting b_buffer_length to 'len' is incorrect if 'offset'
      is > 0. Set it to the total length of the buffer.
    - I suspect that passing a non-aligned address into
      mem_to_page() for the first page may have been causing
      issues - don't know but just tidy up that code anyway.
    
    SGI-PV: 971596
    SGI-Modid: xfs-linux-melb:xfs-kern:30143a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: Christoph Hellwig <hch@infradead.org>

commit cd57e594adc624dd9ee4c0ded3949da21ec24b2f
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Nov 23 16:30:32 2007 +1100

    [XFS] 971064 Various fixups for xfs_bulkstat().
    
    - sanity check for NULL user buffer in xfs_ioc_bulkstat[_compat]()
    - remove the special case for XFS_IOC_FSBULKSTAT with count == 1. This
      special case causes bulkstat to fail because the special case uses
      xfs_bulkstat_single() instead of xfs_bulkstat() and the two functions
      have different semantics.  xfs_bulkstat() will return the next inode
      after the one supplied while skipping internal inodes (ie quota inodes).
      xfs_bulkstate_single() will only lookup the inode supplied and return
      an error if it is an internal inode.
    - in xfs_bulkstat(), need to initialise 'lastino' to the inode supplied
      so in cases were we return without examining any inodes the scan wont
      restart back at zero.
    - sanity check for valid *ubcountp values. Cannot sanity check for valid
      ubuffer here because some users of xfs_bulkstat() don't supply a buffer.
    - checks against 'ubleft' (the space left in the user's buffer) should be
      against 'statstruct_size' which is the supplied minimum object size.
      The mixture of checks against statstruct_size and 0 was one of the
      reasons we were skipping inodes.
    - if the formatter function returns BULKSTAT_RV_NOTHING and an error and
      the error is not ENOENT or EINVAL then we need to abort the scan. ENOENT
      is for inodes that are no longer valid and we just skip them. EINVAL is
      returned if we try to lookup an internal inode so we skip them too. For
      a DMF scan if the inode and DMF attribute cannot fit into the space left
      in the user's buffer it would return ERANGE. We didn't handle this error
      and skipped the inode. We would continue to skip inodes until one fitted
      into the user's buffer or we completed the scan.
    - put back the recalculation of agino (that got removed with the last fix)
      at the end of the while loop. This is because the code at the start of
      the loop expects agino to be the last inode examined if it is non-zero.
    - if we found some inodes but then encountered an error, return success
      this time and the error next time. If the formatter aborted with ENOMEM
      we will now return this error but only if we couldn't read any inodes.
      Previously if we encountered ENOMEM without reading any inodes we
      returned a zero count and no error which falsely indicated the scan was
      complete.
    
    SGI-PV: 973431
    SGI-Modid: xfs-linux-melb:xfs-kern:30089a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>

commit d757762bf2f6aea954745c76b4d767067b85be9d
Author: Donald Douwsma <donaldd@sgi.com>
Date:   Fri Nov 23 16:27:42 2007 +1100

    [XFS] Fix dbflush panic in xfs_qm_sync.
    
    The recent behaviour layer removal dropped the check for quotas that have
    been requested at mount time but have subsequently been turned off. This
    results in a panic when accessing m_quotainfo which has been freed.
    
    This patch adds the check originally made by xfs_qm_syncall() to
    xfs_qm_sync().
    
    SGI-PV: 969769
    SGI-Modid: xfs-linux-melb:xfs-kern:29908a
    
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
