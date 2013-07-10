Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-7-g42c49d7
Message-Id: <20130710153820.B50BA7F53@oss.sgi.com>
Date: Wed, 10 Jul 2013 10:38:20 -0500 (CDT)
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
  42c49d7 xfs: fix sgid inheritance for subdirectories inheriting default acls [V3]
      from  b0a9dab78aee2a479d7c226e6939d553967e4024 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 42c49d7f249c2487f36d3314753d5d8ebcee8249
Author: Carlos Maiolino <cmaiolino@redhat.com>
Date:   Fri Jun 21 14:45:53 2013 -0300

    xfs: fix sgid inheritance for subdirectories inheriting default acls [V3]
    
    XFS removes sgid bits of subdirectories under a directory containing a default
    acl.
    
    When a default acl is set, it implies xfs to call xfs_setattr_nonsize() in its
    code path. Such function is shared among mkdir and chmod system calls, and
    does some checks unneeded by mkdir (calling inode_change_ok()). Such checks
    remove sgid bit from the inode after it has been granted.
    
    With this patch, we extend the meaning of XFS_ATTR_NOACL flag to avoid these
    checks when acls are being inherited (thanks hch).
    
    Also, xfs_setattr_mode, doesn't need to re-check for group id and capabilities
    permissions, this only implies in another try to remove sgid bit from the
    directories. Such check is already done either on inode_change_ok() or
    xfs_setattr_nonsize().
    
    Changelog:
    
    V2: Extends the meaning of XFS_ATTR_NOACL instead of wrap the tests into another
        function
    
    V3: Remove S_ISDIR check in xfs_setattr_nonsize() from the patch
    
    Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_iops.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
