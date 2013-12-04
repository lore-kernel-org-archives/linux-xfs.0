Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-v3.13-rc1-2-13365-gf9fd013
Message-Id: <20131204215526.2BFBE29E1A@oss.sgi.com>
Date: Wed,  4 Dec 2013 15:55:25 -0600 (CST)
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
  f9fd013 xfs: don't perform discard if the given range length is less than block size
  10f73d2 xfs: fix the comment explaining xfs_trans_dqlockedjoin
  071c529 xfs: underflow bug in xfs_attrlist_by_handle()
  f230077 xfs: remove unused FI_ flags
  3fefdee xfs: simplify xfs_setsize_buftarg callchain; remove unused arg
      from  dc1ccc48159d63eca5089e507c82c7d22ef60839 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit f9fd0135610084abef6867d984e9951c3099950d
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Wed Nov 20 16:08:53 2013 +0800

    xfs: don't perform discard if the given range length is less than block size
    
    For discard operation, we should return EINVAL if the given range length
    is less than a block size, otherwise it will go through the file system
    to discard data blocks as the end range might be evaluated to -1, e.g,
    # fstrim -v -o 0 -l 100 /xfs7
    /xfs7: 9811378176 bytes were trimmed
    
    This issue can be triggered via xfstests/generic/288.
    
    Also, it seems to get the request queue pointer via bdev_get_queue()
    instead of the hard code pointer dereference is not a bad thing.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 10f73d27c8e977fb6fbd6058517069be830c6c9a
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Nov 6 03:45:36 2013 -0800

    xfs: fix the comment explaining xfs_trans_dqlockedjoin
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 071c529eb672648ee8ca3f90944bcbcc730b4c06
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu Oct 31 21:00:10 2013 +0300

    xfs: underflow bug in xfs_attrlist_by_handle()
    
    If we allocate less than sizeof(struct attrlist) then we end up
    corrupting memory or doing a ZERO_PTR_SIZE dereference.
    
    This can only be triggered with CAP_SYS_ADMIN.
    
    Reported-by: Nico Golde <nico@ngolde.de>
    Reported-by: Fabian Yamaguchi <fabs@goesec.de>
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit f23007784570278ca5963c35d5b3847d710ed695
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Nov 15 09:38:48 2013 -0800

    xfs: remove unused FI_ flags
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com.>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 3fefdeee92686995ff03e847cbd7bf5ebcd85ff8
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Wed Nov 13 14:53:45 2013 -0600

    xfs: simplify xfs_setsize_buftarg callchain; remove unused arg
    
    The "verbose" argument to xfs_setsize_buftarg_flags() has been
    unused since:
    
    ffe37436 xfs: stop using the page cache to back the buffer cache
    
    Remove it, and fold the function into xfs_setsize_buftarg()
    now that there's no need for different types of callers.
    
    Fix inconsistent comment spacing while we're at it.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_buf.c         | 26 ++++++++------------------
 fs/xfs/xfs_discard.c     |  5 +++--
 fs/xfs/xfs_ioctl.c       |  3 ++-
 fs/xfs/xfs_ioctl32.c     |  3 ++-
 fs/xfs/xfs_trans_dquot.c |  4 ++--
 fs/xfs/xfs_vnode.h       |  9 ---------
 6 files changed, 17 insertions(+), 33 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
