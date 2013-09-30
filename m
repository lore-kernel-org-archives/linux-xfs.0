Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-v3.12-rc3-3-g519ccb8
Message-Id: <20130930225338.676FB7F7C@oss.sgi.com>
Date: Mon, 30 Sep 2013 17:53:38 -0500 (CDT)
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
  519ccb8 xfs: fix memory leak in xlog_recover_add_to_trans
      from  367993e7c6428cb7617ab7653d61dca54e2fdede (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 519ccb81ac1c8e3e4eed294acf93be00b43dcad6
Author: tinguely@sgi.com <tinguely@sgi.com>
Date:   Fri Sep 27 09:00:55 2013 -0500

    xfs: fix memory leak in xlog_recover_add_to_trans
    
    Free the memory in error path of xlog_recover_add_to_trans().
    Normally this memory is freed in recovery pass2, but is leaked
    in the error path.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_log_recover.c | 1 +
 1 file changed, 1 insertion(+)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
