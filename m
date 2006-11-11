Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 22:33:49 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAB6XdaG031745
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 22:33:40 -0800
Date: Sat, 11 Nov 2006 16:34:22 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: XFS update for 2.6.19
Message-ID: <76708453565F2C45356A563E@timothy-shimmins-power-mac-g5.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org
Cc: akpm@osdl.org, xfs@oss.sgi.com

Hi Linus,

Please pull from:
	git://oss.sgi.com:8090/xfs/xfs-2.6

It contains some bug fixes (notably inode iunpin fix),
a couple of patches Andrew Morton was carrying and
a few other fixups/support.

This will update the following files:

 fs/xfs/linux-2.6/xfs_ioctl.c |    5 +--
 fs/xfs/linux-2.6/xfs_super.c |    4 ++-
 fs/xfs/support/move.c        |    2 +
 fs/xfs/support/move.h        |    2 +
 fs/xfs/xfs_dir2.c            |    2 +
 fs/xfs/xfs_iget.c            |   51 +++++++++------------------------
 fs/xfs/xfs_inode.c           |   64 ++++++++++++++++++++++++------------------
 fs/xfs/xfs_inode.h           |   41 ---------------------------
 fs/xfs/xfs_vnodeops.c        |   33 +++++++++-------------
 9 files changed, 72 insertions(+), 132 deletions(-)

through these commits:

commit de5ab811cd0fd738d78c24b970337121ea4c1e07
Author: David Chinner <dgc@sgi.com>
Date:   Sat Nov 11 15:23:35 2006 +1100

    [XFS] Remove KERNEL_VERSION macros from xfs_dmapi.h

    SGI-PV: 957005
    SGI-Modid: xfs-linux-melb:xfs-kern:27398a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit d716594813bf897e6f0255b03d0b43cc00f46c0c
Author: David Chinner <dgc@sgi.com>
Date:   Sat Nov 11 15:18:35 2006 +1100

    [XFS] Prevent a deadlock when xfslogd unpins inodes.

    The previous fixes for the use after free in xfs_iunpin left a nasty log
    deadlock when xfslogd unpinned the inode and dropped the last reference to
    the inode. the ->clear_inode() method can issue transactions, and if the
    log was full, the transaction could push on the log and get stuck trying
    to push the inode it was currently unpinning.

    To fix this, we provide xfs_iunpin a guarantee that it will always have a
    valid xfs_inode <-> linux inode link or a particular flag will be set on
    the inode. We then use log forces during lookup to ensure transactions are
    completed before we recycle the inode. This ensures that xfs_iunpin will
    never use the linux inode after it is being freed, and any lookup on an
    inode on the reclaim list will wait until it is safe to attach a new linux
    inode to the xfs inode.

    SGI-PV: 956832
    SGI-Modid: xfs-linux-melb:xfs-kern:27359a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Shailendra Tripathi <stripathi@agami.com>
    Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 283e9cb79215cc159386daba72363469640a4ddf
Author: David Chinner <dgc@sgi.com>
Date:   Sat Nov 11 15:07:41 2006 +1100

    [XFS] Clean up i_flags and i_flags_lock handling.

    SGI-PV: 956832
    SGI-Modid: xfs-linux-melb:xfs-kern:27358a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Nathan Scott <nscott@aconex.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 4debb1aff0c7a37a37a1fa200958d5b89668e474
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Sat Nov 11 15:07:34 2006 +1100

    [XFS] 956664: dm_read_invis() changes i_atime

    SGI-PV: 956664
    SGI-Modid: xfs-linux-melb:xfs-kern:27315a

    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Sam Vaughan <sjv@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit 9945a9f7fa5b394ea46ffb7da12846418bc418a9
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Sat Nov 11 15:07:28 2006 +1100

    [XFS] rename uio_read() to xfs_uio_read()

    SGI-PV: 957004
    SGI-Modid: xfs-linux-melb:xfs-kern:27231a

    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>


commit f8bfdc2384a51054d50a1fe3564b39c0f13327a6
Author: Tim Shimmin <tes@sgi.com>
Date:   Sat Nov 11 15:07:19 2006 +1100

    [XFS] Keep lockdep happy.

    SGI-PV: 956964
    SGI-Modid: xfs-linux-melb:xfs-kern:27200a

    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


commit f534f2a21d5b2979913bdbae05e74a1d015a62ef
Author: Vlad Apostolov <vapo@sgi.com>
Date:   Sat Nov 11 14:17:37 2006 +1100

    [XFS] 956618: Linux crashes on boot with XFS-DMAPI filesystem when
    CONFIG_XFS_TRACE is on

    SGI-PV: 956618
    SGI-Modid: xfs-linux-melb:xfs-kern:27196a

    Signed-off-by: Vlad Apostolov <vapo@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>

Thanks,
--Tim
