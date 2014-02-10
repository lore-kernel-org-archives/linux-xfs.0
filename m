Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.15-1,
	created. xfs-for-linus-v3.14-rc1-2-12927-g492185e
Message-Id: <20140210031704.CB0577F52@oss.sgi.com>
Date: Sun,  9 Feb 2014 21:17:03 -0600 (CST)
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

The branch, xfs-fixes-for-3.15-1 has been created
        at  492185ef1dd261768203a6c3accfd445cde8c503 (commit)

- Log -----------------------------------------------------------------
commit 492185ef1dd261768203a6c3accfd445cde8c503
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Feb 7 15:26:11 2014 +1100

    xfs: remove XFS_TRANS_DEBUG dead code
    
    Remove the leftover XFS_TRANS_DEBUG dead code following the previous
    cleaning up of it in commits ec47eb6b0b450.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 4ae69fea588148360d470ce604714b6d619ea749
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Feb 7 15:26:11 2014 +1100

    xfs: return -E2BIG if hit the maximum size limits of ACLs
    
    We should return -E2BIG rather than -EINVAL if hit the maximum size
    limits of ACLS, as the former is consistent with VFS xattr syscalls.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 392c6de98af1fd7e2fc9c7bf5e52be16286f7b42
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Feb 7 15:26:11 2014 +1100

    xfs: sanitize sb_inopblock in xfs_mount_validate_sb
    
    xfs_mount_validate_sb doesn't check sb_inopblock for sanity
    (as does its xfs_repair counterpart, FWIW).
    
    If it's out of bounds, we can go off the rails in i.e.
    xfs_inode_buf_verify(), which uses sb_inopblock as a loop
    limit when stepping through a metadata buffer.
    
    The problem can be demonstrated easily by corrupting
    sb_inopblock with xfs_db and trying to mount the result:
    
    # mkfs.xfs -dfile,name=fsfile,size=1g
    # xfs_db -x fsfile
    xfs_db> sb 0
    xfs_db> write inopblock 512
    inopblock = 512
    xfs_db> quit
    
    # mount -o loop fsfile  mnt
    and we blow up in xfs_inode_buf_verify().
    
    With this patch, we get a (very noisy) corruption error,
    and fail the mount as we should.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c6f9726444c8f8c7df24950864bf1a4cb2c61b3e
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Feb 7 15:26:07 2014 +1100

    xfs: convert xfs_log_commit_cil() to void
    
    Convert xfs_log_commit_cil() to a void function since it return nothing
    but 0 in any case, after that we can simplify the relative code logic
    in xfs_trans_commit() accordingly.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 410b11a675dca827e893f07c3155691eda3b5887
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Feb 7 14:55:54 2014 +1100

    xfs: use tr_qm_dqalloc log reservation for dquot alloc
    
    The dquot allocation path in xfs_qm_dqread() currently uses the
    attribute set log reservation, which appears to be incorrect. We
    have reports of transaction reservation overruns with the current
    code. E.g., a repeated run of xfstests test generic/270 on a 512b
    block size fs occassionally produces the following in dmesg:
    
    	XFS (sdN): xlog_write: reservation summary:
    	  trans type  = QM_DQALLOC (30)
    	  unit res    = 7080 bytes
    	  current res = -632 bytes
    	  total reg   = 0 bytes (o/flow = 0 bytes)
    	  ophdrs      = 0 (ophdr space = 0 bytes)
    	  ophdr + reg = 0 bytes
    	  num regions = 0
    
    	XFS (sdN): xlog_write: reservation ran out. Need to up reservation
    
    The dquot allocation case should consist of a write reservation
    (i.e., we are allocating a range of the internal quota file) plus
    the size of the actual dquots. We already have a log reservation
    definition for this operation (tr_qm_dqalloc). Use it in
    xfs_qm_dqread() and update the log reservation calculation function
    to use the write res. calculation function rather than reading the
    assumed to be pre-calculated value directly.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c19ec235352c2a001c9dc7e86acdfd9f2b62150d
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Feb 7 14:54:22 2014 +1100

    xfs: remove unused tr_swrite
    
    tr_swrite is never used, remove it.
    
    From a very quick look, I think the usage of it (and its ancestor
    XFS_SWRITE_LOG_RES) went away in commit 13e6d5cd "xfs: merge fsync
    and O_SYNC handling" back in 2009.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 70bbca07766091be699736163a07ee016ed72482
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Feb 7 14:53:50 2014 +1100

    xfs: use tr_growrtalloc for growing rt files
    
    This is a regression from the following commit:
    
    3d3c8b5222b9 xfs: refactor xfs_trans_reserve() interface
    
    Use the tr_growrtalloc log reservation for growing the
    bitmap/summary files.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
