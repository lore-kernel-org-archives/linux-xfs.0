Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.18-3,
	updated. v3.16-11826-ga8b1ee8
Message-Id: <20141013002908.A03D07F50@oss.sgi.com>
Date: Sun, 12 Oct 2014 19:29:07 -0500 (CDT)
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

The branch, xfs-misc-fixes-for-3.18-3 has been updated
  a8b1ee8 xfs: fix agno increment in xfs_inumbers() loop
      from  52177937e9ac4573391143065b250403d3a6ae4b (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit a8b1ee8bafc765ebf029d03c5479a69aebff9693
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon Oct 13 10:21:53 2014 +1100

    xfs: fix agno increment in xfs_inumbers() loop
    
    caused a regression in xfs_inumbers, which in turn broke
    xfsdump, causing incomplete dumps.
    
    The loop in xfs_inumbers() needs to fill the user-supplied
    buffers, and iterates via xfs_btree_increment, reading new
    ags as needed.
    
    But the first time through the loop, if xfs_btree_increment()
    succeeds, we continue, which triggers the ++agno at the bottom
    of the loop, and we skip to soon to the next ag - without
    the proper setup under next_ag to read the next ag.
    
    Fix this by removing the agno increment from the loop conditional,
    and only increment agno if we have actually hit the code under
    the next_ag: target.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_itable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
