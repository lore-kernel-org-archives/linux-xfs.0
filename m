Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.15-rc5,
	created. xfs-for-linus-3.15-rc2-3-g8275cdd
Message-Id: <20140506004519.BB0FA7F96@oss.sgi.com>
Date: Mon,  5 May 2014 19:45:19 -0500 (CDT)
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

The branch, xfs-fixes-for-3.15-rc5 has been created
        at  8275cdd0e7ac550dcce2b3ef6d2fb3b808c1ae59 (commit)

- Log -----------------------------------------------------------------
commit 8275cdd0e7ac550dcce2b3ef6d2fb3b808c1ae59
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue May 6 07:37:31 2014 +1000

    xfs: remote attribute overwrite causes transaction overrun
    
    Commit e461fcb ("xfs: remote attribute lookups require the value
    length") passes the remote attribute length in the xfs_da_args
    structure on lookup so that CRC calculations and validity checking
    can be performed correctly by related code. This, unfortunately has
    the side effect of changing the args->valuelen parameter in cases
    where it shouldn't.
    
    That is, when we replace a remote attribute, the incoming
    replacement stores the value and length in args->value and
    args->valuelen, but then the lookup which finds the existing remote
    attribute overwrites args->valuelen with the length of the remote
    attribute being replaced. Hence when we go to create the new
    attribute, we create it of the size of the existing remote
    attribute, not the size it is supposed to be. When the new attribute
    is much smaller than the old attribute, this results in a
    transaction overrun and an ASSERT() failure on a debug kernel:
    
    XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
    
    Fix this by keeping the remote attribute value length separate to
    the attribute value length in the xfs_da_args structure. The enables
    us to pass the length of the remote attribute to be removed without
    overwriting the new attribute's length.
    
    Also, ensure that when we save remote block contexts for a later
    rename we zero the original state variables so that we don't confuse
    the state of the attribute to be removes with the state of the new
    attribute that we just added. [Spotted by Brain Foster.]
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d540e43b0ab134b22f015f725ce6e070d12b0244
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue May 6 07:34:28 2014 +1000

    xfs: initialize default acls for ->tmpfile()
    
    The current tmpfile handler does not initialize default ACLs. Doing so
    within xfs_vn_tmpfile() makes it roughly equivalent to xfs_vn_mknod(),
    which is already used as a common create handler.
    
    xfs_vn_mknod() does not currently have a mechanism to determine whether
    to link the file into the namespace. Therefore, further abstract
    xfs_vn_mknod() into a new xfs_generic_create() handler with a tmpfile
    parameter. This new handler calls xfs_create_tmpfile() and d_tmpfile()
    on the dentry when called via ->tmpfile().
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c99d609a16506602a7398eea7d12b13513f3d889
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon May 5 16:18:37 2014 +1000

    xfs: fully support v5 format filesystems
    
    We have had this code in the kernel for over a year now and have
    shaken all the known issues out of the code over the past few
    releases. It's now time to remove the experimental warnings during
    mount and fully support the new filesystem format in production
    systems.
    
    Remove the experimental warning, and add a version number to the
    initial "mounting filesystem" message to tell use what type of
    filesystem is being mounted. Also, remove the temporary inode
    cluster size output at mount time now we know that this code works
    fine.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
