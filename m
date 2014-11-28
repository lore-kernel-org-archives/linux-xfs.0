Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-consolidate-format-defs,
	created. v3.18-rc2-5-g508b6b3
Message-Id: <20141128111621.F0B4E7F56@oss.sgi.com>
Date: Fri, 28 Nov 2014 05:16:21 -0600 (CST)
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

The branch, xfs-consolidate-format-defs has been created
        at  508b6b3b73888e3296ff638b32f15327e63b7b42 (commit)

- Log -----------------------------------------------------------------
commit 508b6b3b73888e3296ff638b32f15327e63b7b42
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 28 14:27:10 2014 +1100

    xfs: merge xfs_inum.h into xfs_format.h
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bb58e6188a10f06dc65612a59ce3815da62ca3c1
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 28 14:27:09 2014 +1100

    xfs: move most of xfs_sb.h to xfs_format.h
    
    More on-disk format consolidation.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 4fb6e8ade2c70ef1a13f358963b3298fd8b72bcc
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 28 14:25:04 2014 +1100

    xfs: merge xfs_ag.h into xfs_format.h
    
    More on-disk format consolidation.  A few declarations that weren't on-disk
    format related move into better suitable spots.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5beda58bf269febe67eca91d5d5dc7c7d392232a
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 28 14:24:37 2014 +1100

    xfs: move acl structures to xfs_format.h
    
    Move the on-disk ACL format to xfs_format.h, so that repair can
    use the common defintion.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6d3ebaae7c20128bfa6965a8d5cee0d1deea8486
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Nov 28 14:24:06 2014 +1100

    xfs: merge xfs_dinode.h into xfs_format.h
    
    More consolidatation for the on-disk format defintions.  Note that the
    XFS_IS_REALTIME_INODE moves to xfs_linux.h instead as it is not related
    to the on disk format, but depends on a CONFIG_ option.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
