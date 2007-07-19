Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jul 2007 07:20:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6JEKdbm023710
	for <xfs@oss.sgi.com>; Thu, 19 Jul 2007 07:20:41 -0700
Message-ID: <469F7329.9080603@sgi.com>
Date: Fri, 20 Jul 2007 00:20:25 +1000
From: Tim Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: [GIT PULL] XFS update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the for-linus branch:
     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

  fs/buffer.c                 |   47 +++++++++++++++++++++++++++++++++++++++++++
  fs/xfs/linux-2.6/xfs_file.c |   16 ++++++++++++++
  fs/xfs/xfs_vnodeops.c       |   30 +++++++++++++++++++++++++-
  include/linux/buffer_head.h |    2 +
  4 files changed, 93 insertions(+), 2 deletions(-)

through these commits:

commit c32676eea19ce29cb74dba0f97b085e83f6b8915
Author: David Chinner <dgc@sgi.com>
Date:   Thu Jul 19 16:28:58 2007 +1000

     [XFS] Fix inode size update before data write in xfs_setattr

     When changing the file size by a truncate() call, we log the change in the
     inode size. However, we do not flush any outstanding data that might not
     have been written to disk, thereby violating the data/inode size update
     order. This can leave files full of NULLs on crash.

     Hence if we are truncating the file, flush any unwritten data that may lie
     between the curret on disk inode size and the new inode size that is being
     logged to ensure that ordering is preserved.

     SGI-PV: 966308
     SGI-Modid: xfs-linux-melb:xfs-kern:29174a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 91ebecc74eeeeea0a2aa50bf1964ec2214a229c9
Author: David Chinner <dgc@sgi.com>
Date:   Thu Jul 19 16:28:30 2007 +1000

     [XFS] Allow punching holes to free space when at ENOSPC

     Make the free file space transaction able to dip into the reserved blocks
     to ensure that we can successfully free blocks when the filesystem is at
     ENOSPC.

     SGI-PV: 967788
     SGI-Modid: xfs-linux-melb:xfs-kern:29167a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Vlad Apostolov <vapo@sgi.com>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 4f57dbc6b5bae5a3978d429f45ac597ca7a3b8c6
Author: David Chinner <dgc@sgi.com>
Date:   Thu Jul 19 16:28:17 2007 +1000

     [XFS] Implement ->page_mkwrite in XFS.

     Hook XFS up to ->page_mkwrite to ensure that we know about mmap pages
     being written to. This allows use to do correct delayed allocation and
     ENOSPC checking as well as remap unwritten extents so that they get
     converted correctly during writeback. This is done via the generic
     block_page_mkwrite code.

     SGI-PV: 940392
     SGI-Modid: xfs-linux-melb:xfs-kern:29149a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 5417169026c3df151adf5a65eb061278b0a72e69
Author: David Chinner <dgc@sgi.com>
Date:   Thu Jul 19 17:39:55 2007 +1000

     [FS] Implement block_page_mkwrite.

     Many filesystems need a ->page-mkwrite callout to correctly
     set up pages that have been written to by mmap. This is especially
     important when mmap is writing into holes as it allows filesystems
     to correctly account for and allocate space before the mmap
     write is allowed to proceed.

     Protection against truncate races is provided by locking the page
     and checking to see whether the page mapping is correct and whether
     it is beyond EOF so we don't end up allowing allocations beyond
     the current EOF or changing EOF as a result of a mmap write.

     SGI-PV: 940392
     SGI-Modid: 2.6.x-xfs-melb:linux:29146a

     Signed-off-by: David Chinner <dgc@sgi.com>
     Signed-off-by: Christoph Hellwig <hch@infradead.org>
     Signed-off-by: Tim Shimmin <tes@sgi.com>

Thanks,
Tim.
