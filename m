Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-v3.12-rc3-2-g367993e
Message-Id: <20130930225114.775D67F67@oss.sgi.com>
Date: Mon, 30 Sep 2013 17:51:14 -0500 (CDT)
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
  367993e xfs: dirent dtype presence is dependent on directory magic numbers
  f112a04 xfs: lockdep needs to know about 3 dquot-deep nesting
      from  997def25e4b9cee3b01609e18a52f926bca8bd2b (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 367993e7c6428cb7617ab7653d61dca54e2fdede
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 09:37:04 2013 +1000

    xfs: dirent dtype presence is dependent on directory magic numbers
    
    The determination of whether a directory entry contains a dtype
    field originally was dependent on the filesystem having CRCs
    enabled. This meant that the format for dtype beign enabled could be
    determined by checking the directory block magic number rather than
    doing a feature bit check. This was useful in that it meant that we
    didn't need to pass a struct xfs_mount around to functions that
    were already supplied with a directory block header.
    
    Unfortunately, the introduction of dtype fields into the v4
    structure via a feature bit meant this "use the directory block
    magic number" method of discriminating the dirent entry sizes is
    broken. Hence we need to convert the places that use magic number
    checks to use feature bit checks so that they work correctly and not
    by chance.
    
    The current code works on v4 filesystems only because the dirent
    size roundup covers the extra byte needed by the dtype field in the
    places where this problem occurs.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f112a049712a5c07de25d511c3c6587a2b1a015e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 30 09:37:03 2013 +1000

    xfs: lockdep needs to know about 3 dquot-deep nesting
    
    Michael Semon reported that xfs/299 generated this lockdep warning:
    
    =============================================
    [ INFO: possible recursive locking detected ]
    3.12.0-rc2+ #2 Not tainted
    ---------------------------------------------
    touch/21072 is trying to acquire lock:
     (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    but task is already holding lock:
     (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    other info that might help us debug this:
     Possible unsafe locking scenario:
    
           CPU0
           ----
      lock(&xfs_dquot_other_class);
      lock(&xfs_dquot_other_class);
    
     *** DEADLOCK ***
    
     May be due to missing lock nesting notation
    
    7 locks held by touch/21072:
     #0:  (sb_writers#10){++++.+}, at: [<c11185b6>] mnt_want_write+0x1e/0x3e
     #1:  (&type->i_mutex_dir_key#4){+.+.+.}, at: [<c11078ee>] do_last+0x245/0xe40
     #2:  (sb_internal#2){++++.+}, at: [<c122c9e0>] xfs_trans_alloc+0x1f/0x35
     #3:  (&(&ip->i_lock)->mr_lock/1){+.+...}, at: [<c126cd1b>] xfs_ilock+0x100/0x1f1
     #4:  (&(&ip->i_lock)->mr_lock){++++-.}, at: [<c126cf52>] xfs_ilock_nowait+0x105/0x22f
     #5:  (&dqp->q_qlock){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
     #6:  (&xfs_dquot_other_class){+.+...}, at: [<c12902fb>] xfs_trans_dqlockedjoin+0x57/0x64
    
    The lockdep annotation for dquot lock nesting only understands
    locking for user and "other" dquots, not user, group and quota
    dquots. Fix the annotations to match the locking heirarchy we now
    have.
    
    Reported-by: Michael L. Semon <mlsemon35@gmail.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dir2_block.c   |  6 +++---
 fs/xfs/xfs_dir2_format.h  | 51 +++++++++++++++++++----------------------------
 fs/xfs/xfs_dir2_readdir.c |  4 ++--
 fs/xfs/xfs_dir2_sf.c      |  6 +++---
 fs/xfs/xfs_dquot.c        | 19 +++++++++++++++---
 5 files changed, 44 insertions(+), 42 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
