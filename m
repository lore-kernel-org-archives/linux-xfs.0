Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-O_TMPFILE-support,
	created. v3.12-11688-gab29743
Message-Id: <20140313083419.21C307F77@oss.sgi.com>
Date: Thu, 13 Mar 2014 03:34:18 -0500 (CDT)
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

The branch, xfs-O_TMPFILE-support has been created
        at  ab29743117f9f4c22ac44c13c1647fb24fb2bafe (commit)

- Log -----------------------------------------------------------------
commit ab29743117f9f4c22ac44c13c1647fb24fb2bafe
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Dec 18 08:22:41 2013 +0800

    xfs: allow linkat() on O_TMPFILE files
    
    The VFS allows an anonymous temporary file to be named at a later
    time via a linkat() syscall. The inodes for O_TMPFILE files are
    are marked with a special flag I_LINKABLE and have a zero link count.
    
    To support this in XFS, xfs_link() detects if this flag I_LINKABLE
    is set and behaves appropriately when detected. So in this case,
    its transaciton reservation takes into account the additional
    overhead of removing the inode from the unlinked list. Then the
    inode is removed from the unlinked list and the directory entry
    is added. Finally its link count is bumped accordingly.
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 99b6436bc29e4f10e4388c27a3e4810191cc4788
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Dec 18 08:22:40 2013 +0800

    xfs: add O_TMPFILE support
    
    Add two functions xfs_create_tmpfile() and xfs_vn_tmpfile()
    to support O_TMPFILE file creation.
    
    In contrast to xfs_create(), xfs_create_tmpfile() has a different
    log reservation to the regular file creation because there is no
    directory modification, and doesn't check if an entry can be added
    to the directory, but the reservation quotas is required appropriately,
    and finally its inode is added to the unlinked list.
    
    xfs_vn_tmpfile() add one O_TMPFILE method to VFS interface and directly
    invoke xfs_create_tmpfile().
    
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 163467d3753e77e1d77da75727975cc3803a1dbc
Author: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Date:   Wed Dec 18 08:22:39 2013 +0800

    xfs: factor prid related codes into xfs_get_initial_prid()
    
    It will be reused by the O_TMPFILE creation function.
    
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
