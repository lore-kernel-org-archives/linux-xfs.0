Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-9-gc31ad43
Message-Id: <20130711215153.E26667F53@oss.sgi.com>
Date: Thu, 11 Jul 2013 16:51:53 -0500 (CDT)
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
  c31ad43 xfs: Fix the logic check for all quotas being turned off
      from  92f8ff73f18672b03ec8b92197cdddf2b5de7ea0 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c31ad439e8d111bf911c9cc80619cebde411a44d
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Wed Jul 10 18:00:36 2013 -0500

    xfs: Fix the logic check for all quotas being turned off
    
    During the review of seperate pquota inode patches, David noticed
    that the test to detect all quotas being turned off was
    incorrect, and hence the block was not freeing all the quota
    information.
    
    The check made sense in Irix, but in Linux, quota is turned off
    one at a time, which makes the test invalid for Linux.
    
    This problem existed since XFS was ported to Linux.
    
    David suggested to fix the problem by detecting when all quotas are
    turned off by checking m_qflags.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_qm_syscalls.c | 5 ++---
 fs/xfs/xfs_quota.h       | 8 --------
 2 files changed, 2 insertions(+), 11 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
