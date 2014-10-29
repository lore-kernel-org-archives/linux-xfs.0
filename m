Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.18-rc2-5-g31692c5
Message-Id: <20141029103218.E549E7F47@oss.sgi.com>
Date: Wed, 29 Oct 2014 05:32:18 -0500 (CDT)
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

The branch, for-next has been updated
  31692c5 xfs: bulkstat needs to delete cursor at end of AG
      from  bae09893f6a5260c7030499ddfd0911899ae3d0c (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 31692c5fe617d28d8099a9308d345e26f3e22dca
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Oct 29 21:22:39 2014 +1100

    xfs: bulkstat needs to delete cursor at end of AG
    
    Colliding bug fixes meant one fix breaks from the bulkstat loop
    ("xfs: Check error during inode btree iteration in xfs_bulkstat()")
    when in fact it should do what the other patch did introduced and
    jump to the del_cursor label ("xfs: bulkstat doesn't release AGI
    buffer on error").
    
    Failure to do so causes the end of AG detection
    to hang on a locked AGI.
    
    Reported by: Tommy Wu <wu.tommy@gmail.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_itable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
