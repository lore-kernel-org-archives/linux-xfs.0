Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-filestreams-lookup,
	created. xfs-for-linus-3.15-rc1-14835-gb94acd4
Message-Id: <20140422222935.B180B7F52@oss.sgi.com>
Date: Tue, 22 Apr 2014 17:29:35 -0500 (CDT)
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

The branch, xfs-filestreams-lookup has been created
        at  b94acd4786dce4379e986e6d58bdd74f8986af2f (commit)

- Log -----------------------------------------------------------------
commit b94acd4786dce4379e986e6d58bdd74f8986af2f
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:52 2014 +1000

    xfs: add filestream allocator tracepoints
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3b8d90766a85e079fefaee74ca9dde43ce75edea
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:52 2014 +1000

    xfs: remove xfs_filestream_associate
    
    There is no good reason to create a filestream when a directory entry
    is created.  Delay it until the first allocation happens to simply
    the code and reduce the amount of mru cache lookups we do.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 1919adda0732e661c6163a6505dddb0bc423b8d8
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:51 2014 +1000

    xfs: don't create a slab cache for filestream items
    
    We only have very few of these around, and allocation isn't that
    much of a hot path.  Remove the slab cache to simplify the code,
    and to not waste any resources for the usual case of not having
    any inodes that use the filestream allocator.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2cd2ef6a300b1ac912bb515b75451585c3d33ea9
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:51 2014 +1000

    xfs: rewrite the filestream allocator using the dentry cache
    
    In Linux we will always be able to find a parent inode for file that are
    undergoing I/O.  Use this to simply the file stream allocator by only
    keeping track of parent inodes.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>

commit f37211c336d722805493aec8b13afdbb92bbfd98
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:51 2014 +1000

    xfs: remove XFS_IFILESTREAM
    
    We never test the flag except in xfs_inode_is_filestream, but that
    function already tests the on-disk flag or filesystem wide flags,
    and is used to decide if we want to set XFS_IFILESTREAM in the
    first place.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 22328d712dd7fdc984d17da2121be840d1f844cd
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:51 2014 +1000

    xfs: embedd mru_elem into parent structure
    
    There is no need to do a separate allocation for each mru element, just
    embedd the structure into the parent one in the user.  Besides saving
    a memory allocation and the infrastructure required for it this also
    simplifies the API.
    
    While we do major surgery on xfs_mru_cache.c also de-typedef it and
    make struct mru_cache private to the implementation file.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ce695c6551f9488e75247ac1eefcd173fda0c029
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:50 2014 +1000

    xfs: handle duplicate entries in xfs_mru_cache_insert
    
    The radix tree code can detect and reject duplicate keys at insert
    time.  Make xfs_mru_cache_insert handle this case so that future
    changes to the filestream allocator can take advantage of this.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c977eb1065612bf64e18c61437e290c22183add8
Author: Christoph Hellwig <hch@lst.de>
Date:   Wed Apr 23 07:11:41 2014 +1000

    xfs: split xfs_bmap_btalloc_nullfb
    
    Split xfs_bmap_btalloc_nullfb into one function for filestream allocations
    and one for everything else that share a few helpers.  This dramatically
    simplifies the control flow.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>

commit 8b90a33f476436ad6a49b7138d8a00ecbc62f9a6
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Apr 14 19:37:42 2014 +1000

    xfs: don't try to use the filestream allocator for metadata allocations
    
    xfs_bmap_btalloc_nullfb has two entirely different control flows when
    using the filestream allocator vs the regular one, but it get the
    conditionals wrong and ends up mixing the two for metadata allocations.
    Fix this by adding a missing userdata check and slight refactoring.
    
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
