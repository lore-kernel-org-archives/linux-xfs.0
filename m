Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.14-rc3,
	updated. xfs-for-linus-v3.14-rc1-2-12923-g55daffa
Message-Id: <20140212214249.5816E7F53@oss.sgi.com>
Date: Wed, 12 Feb 2014 15:42:47 -0600 (CST)
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

The branch, xfs-fixes-for-3.14-rc3 has been updated
  55daffa xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      from  3895e51f6dbf6610519be070a3bede811f6ac4fb (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 55daffa4198b405c5f595d46b5556be2f650cdd4
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Feb 11 16:46:55 2014 -0600

    xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
    
    My earlier commit 10e6e65 deserves a layer or two of brown paper
    bags.  The logic in that commit means that a CRC failure on the
    primary superblock will *never* result in an error return.
    
    Hopefully this fixes it, so that we always return the error
    if it's a primary superblock, otherwise only if the filesystem
    has CRCs enabled.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
