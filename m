Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12119-g7a378c9
Message-Id: <20130730181256.447B97F52@oss.sgi.com>
Date: Tue, 30 Jul 2013 13:12:55 -0500 (CDT)
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
  7a378c9 xfs: WQ_NON_REENTRANT is meaningless and going away
      from  e60896d8f2b81412421953e14d3feb14177edb56 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 7a378c9aeab3782a5f998c17313bc7027cee3454
Author: Tejun Heo <tj@kernel.org>
Date:   Tue Jul 30 08:40:26 2013 -0400

    xfs: WQ_NON_REENTRANT is meaningless and going away
    
    dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
    WQ_NON_REENTRANT no-op and the flag is going away.  Remove its usages.
    
    This patch doesn't introduce any behavior changes.
    
    Signed-off-by: Tejun Heo <tj@kernel.org>
    Cc: Ben Myers <bpm@sgi.com>
    Cc: Alex Elder <elder@kernel.org>
    Cc: xfs@oss.sgi.com
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
