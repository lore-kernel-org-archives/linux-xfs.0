Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-49-g359d992
Message-Id: <20131106225817.B0AAE29E50@oss.sgi.com>
Date: Wed,  6 Nov 2013 16:58:17 -0600 (CST)
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
  359d992 xfs: simplify kmem_{zone_}zalloc
  d123031 xfs: add tracepoints to AGF/AGI read operations
  750b9c9 xfs: trace AIL manipulations
      from  273203699f82667296e1f14344c5a5a6c4600470 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 359d992bcd398273637cd9edde10afca953783c4
Author: Gu Zheng <guz.fnst@cn.fujitsu.com>
Date:   Mon Nov 4 18:21:05 2013 +0800

    xfs: simplify kmem_{zone_}zalloc
    
    Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
    kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
    in order to avoid the setting to zero step.
    And following Dave's suggestion, make kmem_{zone_}zalloc static inline
    into kmem.h as they're now just a simple wrapper.
    
    V2:
      Make kmem_{zone_}zalloc static inline into kmem.h as Dave suggested.
    
    Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit d123031a5673cd38a85ce66cc07243dfe5f424c9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 1 15:27:19 2013 +1100

    xfs: add tracepoints to AGF/AGI read operations
    
    To help track down AGI/AGF lock ordering issues, I added these
    tracepoints to tell us when an AGI or AGF is read and locked.  With
    these we can now determine if the lock ordering goes wrong from
    tracing captures.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 750b9c90668b173a92b20e747b9736b8537eda5a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 1 15:27:18 2013 +1100

    xfs: trace AIL manipulations
    
    I debugging a log tail issue on a RHEL6 kernel, I added these trace
    points to trace log items being added, moved and removed in the AIL
    and how that affected the log tail LSN that was written to the log.
    They were very helpful in that they immediately identified the cause
    of the problem being seen. Hence I'd like to always have them
    available for use.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c          | 22 -------------
 fs/xfs/kmem.h          | 21 +++++++++++--
 fs/xfs/xfs_alloc.c     |  5 ++-
 fs/xfs/xfs_ialloc.c    |  6 +++-
 fs/xfs/xfs_log.c       |  1 +
 fs/xfs/xfs_trace.h     | 84 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_ail.c |  3 ++
 7 files changed, 114 insertions(+), 28 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
