Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. v3.10-rc1-32-g9222a9c
Message-Id: <20130614203052.7648E7F3F@oss.sgi.com>
Date: Fri, 14 Jun 2013 15:30:52 -0500 (CDT)
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
  9222a9c xfs: don't shutdown log recovery on validation errors
      from  ade1335afef556df6538eb02e8c0dc91fbd9cc37 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 9222a9cf86c0d64ffbedf567412b55da18763aa3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 12 12:19:06 2013 +1000

    xfs: don't shutdown log recovery on validation errors
    
    Unfortunately, we cannot guarantee that items logged multiple times
    and replayed by log recovery do not take objects back in time. When
    they are taken back in time, the go into an intermediate state which
    is corrupt, and hence verification that occurs on this intermediate
    state causes log recovery to abort with a corruption shutdown.
    
    Instead of causing a shutdown and unmountable filesystem, don't
    verify post-recovery items before they are written to disk. This is
    less than optimal, but there is no way to detect this issue for
    non-CRC filesystems If log recovery successfully completes, this
    will be undone and the object will be consistent by subsequent
    transactions that are replayed, so in most cases we don't need to
    take drastic action.
    
    For CRC enabled filesystems, leave the verifiers in place - we need
    to call them to recalculate the CRCs on the objects anyway. This
    recovery problem can be solved for such filesystems - we have a LSN
    stamped in all metadata at writeback time that we can to determine
    whether the item should be replayed or not. This is a separate piece
    of work, so is not addressed by this patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_log_recover.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
