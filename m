Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:47:49 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8JFlQv4001339
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:47:41 -0700
Date: Tue, 18 Sep 2007 21:24:47 +1000
Subject: [GIT PULL] XFS update for 2.6.23
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070918112447.4315C58C4C09@chook.melbourne.sgi.com>
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Hi Linus,

A couple of fixes for potential fs corruption.
And one fix to ensure that xfs_mru_cache is not
doing anything unless the cache has active objects.


Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_aops.c  |    1 +
 fs/xfs/linux-2.6/xfs_super.c |    4 ++-
 fs/xfs/xfs_buf_item.h        |    5 +++
 fs/xfs/xfs_filestream.c      |    3 +-
 fs/xfs/xfs_log_recover.c     |   51 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_mru_cache.c       |   72 ++++++++++++++++-------------------------
 fs/xfs/xfs_mru_cache.h       |    6 +--
 fs/xfs/xfs_trans_buf.c       |    1 +
 fs/xfs/xfs_vnodeops.c        |   20 +++++++-----
 9 files changed, 101 insertions(+), 62 deletions(-)

through these commits:

commit b394e43e995d08821588a22561c6a71a63b4ff27
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:23:04 2007 +1000

    [XFS] Avoid replaying inode buffer initialisation log items if on-disk version is newer.
    
    SGI-PV: 969656
    SGI-Modid: xfs-linux-melb:xfs-kern:29676a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 776a75fa5cfb8f3602d3ca9d221dc34497133f4b
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Fri Sep 14 15:22:50 2007 +1000

    [XFS] Ensure file size updates have been completed before writing inode to disk.
    
    SGI-PV: 968767
    SGI-Modid: xfs-linux-melb:xfs-kern:29675a
    
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

commit 65de5567564e70edd01b6d4e95e548d7ba284872
Author: David Chinner <dgc@sgi.com>
Date:   Thu Aug 16 15:21:11 2007 +1000

    [XFS] On-demand reaping of the MRU cache
    
    Instead of running the mru cache reaper all the time based on a timeout,
    we should only run it when the cache has active objects. This allows CPUs
    to sleep when there is no activity rather than be woken repeatedly just to
    check if there is anything to do.
    
    SGI-PV: 968554
    SGI-Modid: xfs-linux-melb:xfs-kern:29305a
    
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

--Tim
