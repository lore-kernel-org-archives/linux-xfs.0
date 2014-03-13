Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-collapse-range,
	updated. xfs-for-linus-v3.14-rc1-2-12924-g376ba31
Message-Id: <20140313083440.44F1A7F7E@oss.sgi.com>
Date: Thu, 13 Mar 2014 03:34:39 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, xfs-collapse-range has been updated
  376ba31 xfs: Add support for FALLOC_FL_ZERO_RANGE
      from  e1d8fb88a64c1f8094b9f6c3b6d2d9e6719c970d (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 376ba313147b4172f3e8cf620b9fb591f3e8cdfa
Author: Lukas Czerner <lczerner@redhat.com>
Date:   Thu Mar 13 19:07:58 2014 +1100

    xfs: Add support for FALLOC_FL_ZERO_RANGE
    
    Introduce new FALLOC_FL_ZERO_RANGE flag for fallocate. This has the same
    functionality as xfs ioctl XFS_IOC_ZERO_RANGE.
    
    We can also preallocate blocks past EOF in the same was as with
    fallocate. Flag FALLOC_FL_KEEP_SIZE will cause the inode size to remain
    the same even if we preallocate blocks past EOF.
    
    It uses the same code to zero range as it is used by the
    XFS_IOC_ZERO_RANGE ioctl.
    
    Signed-off-by: Lukas Czerner <lczerner@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
