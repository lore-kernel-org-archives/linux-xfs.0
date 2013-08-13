Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12162-g2c2bcc0
Message-Id: <20130813191950.255047F78@oss.sgi.com>
Date: Tue, 13 Aug 2013 14:19:49 -0500 (CDT)
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

The branch, master has been updated
  2c2bcc0 xfs: call roundup_64() to calculate the min_logblks
      from  3e7b91cf8c19d89e55df5f05e3010446dbdaba77 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2c2bcc0735f4ab052559b539f3fcab4087187232
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Aug 13 13:32:00 2013 +0800

    xfs: call roundup_64() to calculate the min_logblks
    
    Replace roundup() with roundup_64() as we calculate min_logblks
    with 64-bit divisions.  Hence, call roundup() will cause the
    following error while compiling a 32-bit kernel:
    
    fs/built-in.o: In function `xfs_log_calc_minimum_size':
    fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'
    
    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Cc: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_log_rlimit.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
