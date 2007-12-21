Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Dec 2007 16:43:34 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBL0gtIl023228
	for <xfs@oss.sgi.com>; Thu, 20 Dec 2007 16:42:59 -0800
Date: Fri, 21 Dec 2007 11:42:59 +1100
Subject: [GIT PULL] XFS update for 2.6.24-rc6
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071221004259.8C12858C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_file.c |    1 +
 fs/xfs/linux-2.6/xfs_iops.c |    4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

through these commits:

commit 4743e0ec1217fd00f57461ebdd7979d31af18700
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Fri Dec 21 11:00:23 2007 +1100

    [XFS] Initialise current offset in xfs_file_readdir correctly
    
    After reading the directory contents into the temporary buffer, we grab
    each dirent and pass it to filldir witht eh current offset of the dirent.
    The current offset was not being set for the first dirent in the temporary
    buffer, which coul dresult in bad offsets being set in the f_pos field
    result in looping and duplicate entries being returned from readdir.
    
    SGI-PV: 974905
    SGI-Modid: xfs-linux-melb:xfs-kern:30282a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit bad60fdd14df32459e31cc75ab681e4458bf25cf
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 21 10:58:56 2007 +1100

    [XFS] Fix mknod regression
    
    This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
    which assigned the re-shuffled ondisk dev_t back to the rdev variable in
    xfs_vn_mknod. Because of that i_rdev is set to the ondisk dev_t instead of
    the linux dev_t later down the function.
    
    Fortunately the fix for it is trivial: we can just remove the assignment
    because xfs_revalidate_inode has done the proper job before unlocking the
    inode.
    
    SGI-PV: 974873
    SGI-Modid: xfs-linux-melb:xfs-kern:30273a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
