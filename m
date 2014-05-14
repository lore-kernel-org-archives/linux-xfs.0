Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-attr-cleanup,
	created. xfs-for-linus-3.15-rc1-14831-g6c888af
Message-Id: <20140514234909.BFDC27F51@oss.sgi.com>
Date: Wed, 14 May 2014 18:49:09 -0500 (CDT)
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

The branch, xfs-attr-cleanup has been created
        at  6c888af0b4ca66565b2aa73147ebc1d139c3bd1b (commit)

- Log -----------------------------------------------------------------
commit 6c888af0b4ca66565b2aa73147ebc1d139c3bd1b
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 13 16:40:19 2014 +1000

    xfs: pass struct da_args to xfs_attr_calc_size
    
    And remove a very confused comment.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 67fd718f30108db320ffc4bef205137b69e60d3a
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 13 16:34:43 2014 +1000

    xfs: simplify attr name setup
    
    Replace xfs_attr_name_to_xname with a new xfs_attr_args_init helper that
    sets up the basic da_args structure without using a temporary xfs_name
    structure.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1bc426a76b1a8ecf00d9a3ec8e9765a21ab4082f
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 13 16:34:33 2014 +1000

    xfs: fold xfs_attr_remove_int into xfs_attr_remove
    
    Also remove a useless ilock roundtrip for the first attr fork check, it's
    racy anyway and we redo it later under the ilock before we start the removal.
    
    Plus various minor style fixes to the new xfs_attr_remove.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b87d022c275bce66553a27b68790e7c91927875f
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 13 16:34:24 2014 +1000

    xfs: fold xfs_attr_get_int into xfs_attr_get
    
    This allows doing an unlocked check if an attr for is present at all and
    slightly reduce the lock hold time if we actually do an attr get.
    
    Plus various minor style fixes to the new xfs_attr_get.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c5b4ac39a4cb6a9a79025106a471f0738b3cb525
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue May 13 16:34:14 2014 +1000

    xfs: fold xfs_attr_set_int into xfs_attr_set
    
    Plus various minor style fixes to the new xfs_attr_set.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
