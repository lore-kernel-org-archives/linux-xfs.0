Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.12-rc1-5-g997def2
Message-Id: <20130927141902.9E18F7F61@oss.sgi.com>
Date: Fri, 27 Sep 2013 09:19:02 -0500 (CDT)
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
  997def2 xfs: fix node forward in xfs_node_toosmall
      from  566055d33a91ddddb1cb31220b01ac4abd2d2bdd (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 997def25e4b9cee3b01609e18a52f926bca8bd2b
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Mon Sep 23 12:18:58 2013 -0500

    xfs: fix node forward in xfs_node_toosmall
    
    Commit f5ea1100 cleans up the disk to host conversions for
    node directory entries, but because a variable is reused in
    xfs_node_toosmall() the next node is not correctly found.
    If the original node is small enough (<= 3/8 of the node size),
    this change may incorrectly cause a node collapse when it should
    not. That will cause an assert in xfstest generic/319:
    
       Assertion failed: first <= last && last < BBTOB(bp->b_length),
       file: /root/newest/xfs/fs/xfs/xfs_trans_buf.c, line: 569
    
    Keep the original node header to get the correct forward node.
    
    (When a node is considered for a merge with a sibling, it overwrites the
     sibling pointers of the original incore nodehdr with the sibling's
     pointers.  This leads to loop considering the original node as a merge
     candidate with itself in the second pass, and so it incorrectly
     determines a merge should occur.)
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    [v3: added Dave Chinner's (slightly modified) suggestion to the commit header,
    	cleaned up whitespace.  -bpm]

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_da_btree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
