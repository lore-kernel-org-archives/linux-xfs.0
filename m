Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-free-inode-btree,
	created. xfs-for-linus-3.15-rc1-14837-g53801fd
Message-Id: <20140424061509.0FF037F53@oss.sgi.com>
Date: Thu, 24 Apr 2014 01:15:08 -0500 (CDT)
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

The branch, xfs-free-inode-btree has been created
        at  53801fd97ae000793f51187b122b9475102199a8 (commit)

- Log -----------------------------------------------------------------
commit 53801fd97ae000793f51187b122b9475102199a8
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:01:42 2014 +1000

    xfs: enable the finobt feature on v5 superblocks
    
    Add the finobt feature bit to the list of known features. As of
    this point, the kernel code knows how to mount and manage both
    finobt and non-finobt formatted filesystems.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0c153c1e4326725e9d5e9de6a25fe8ec2353d5ee
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:01:41 2014 +1000

    xfs: report finobt status in fs geometry
    
    Define the XFS_FSOP_GEOM_FLAGS_FINOBT fs geometry flag and set the
    associated bit if the filesystem supports the free inode btree.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a3fa516dd81c49d9c276f59d57ed6e36aaefbe1d
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:01:39 2014 +1000

    xfs: add finobt support to growfs
    
    Add finobt support to growfs. Initialize the agi root/level fields
    and the root finobt block.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3efa4ffd58a04f859713daaf910f1f1ff8ef647f
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:53 2014 +1000

    xfs: update the finobt on inode free
    
    An inode free operation can have several effects on the finobt. If
    all inodes have been freed and the chunk deallocated, we remove the
    finobt record. If the inode chunk was previously full, we must
    insert a new record based on the existing inobt record. Otherwise,
    we modify the record in place.
    
    Create the xfs_difree_finobt() function to identify the potential
    scenarios and update the finobt appropriately.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2b64ee5cdc106704b5c0f8954a52aa598eee25eb
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:53 2014 +1000

    xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
    
    Refactor xfs_difree() in preparation for the finobt. xfs_difree()
    performs the validity checks against the ag and reads the agi
    header. The work of physically updating the inode allocation btree
    is pushed down into the new xfs_difree_inobt() helper.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6dd8638e4e8764e0d6557fc62840a815a99c136d
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:53 2014 +1000

    xfs: use and update the finobt on inode allocation
    
    Replace xfs_dialloc_ag() with an implementation that looks for a
    record in the finobt. The finobt only tracks records with at least
    one free inode. This eliminates the need for the intra-ag scan in
    the original algorithm. Once the inode is allocated, update the
    finobt appropriately (possibly removing the record) as well as the
    inobt.
    
    Move the original xfs_dialloc_ag() algorithm to
    xfs_dialloc_ag_inobt() and fall back as such if finobt support is
    not enabled.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0aa0a756ec255cfc8b733fe0d8993c1758b1240c
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:53 2014 +1000

    xfs: insert newly allocated inode chunks into the finobt
    
    A newly allocated inode chunk, by definition, has at least one
    free inode, so a record is always inserted into the finobt.
    
    Create the xfs_inobt_insert() helper from existing code to insert
    a record in an inobt based on the provided BTNUM. Update
    xfs_ialloc_ag_alloc() to invoke the helper for the existing
    XFS_BTNUM_INO tree and XFS_BTNUM_FINO tree, if enabled.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9d43b180af67cccd4bd1342f7f54f8131515b0a1
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:52 2014 +1000

    xfs: update inode allocation/free transaction reservations for finobt
    
    Create the xfs_calc_finobt_res() helper to calculate the finobt log
    reservation for inode allocation and free. Update
    XFS_IALLOC_SPACE_RES() to reserve blocks for the additional finobt
    insertion on inode allocation. Create XFS_IFREE_SPACE_RES() to
    reserve blocks for the potential finobt record insertion on inode
    free (i.e., if an inode chunk was previously fully allocated).
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit aafc3c24652924ea951d215d04a3f42e832e9d7d
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:52 2014 +1000

    xfs: support the XFS_BTNUM_FINOBT free inode btree type
    
    Define the AGI fields for the finobt root/level and add magic
    numbers. Update the btree code to add support for the new
    XFS_BTNUM_FINOBT inode btree.
    
    The finobt root block is reserved immediately following the inobt
    root block in the AG. Update XFS_PREALLOC_BLOCKS() to determine the
    starting AG data block based on whether finobt support is enabled.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8e2c84df20aa66ae9a6ee32831a9c622f4823118
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:52 2014 +1000

    xfs: reserve v5 superblock read-only compat. feature bit for finobt
    
    Reserve a v5 read-only compatibility feature bit for the finobt and
    create the xfs_sb_version_hasfinobt() helper to determine whether
    an fs has the feature enabled.
    
    The finobt does not change existing on-disk structures, but must
    remain consistent with the ialloc btree. Modifications from older
    kernels would violate that constrant. Therefore, we restrict older
    kernels to read-only mounts of finobt-enabled filesystems.
    
    Note that this does not yet enable the ability to rw mount a finobt
    fs (by setting the feature bit in the XFS_SB_FEAT_RO_COMPAT_ALL
    mask).
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 57bd3dbe4059c6fff7e39927e5aa789dfb2585b9
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Apr 24 16:00:50 2014 +1000

    xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
    
    The introduction of the free inode btree (finobt) requires that
    xfs_ialloc_btree.c handle multiple trees. Refactor xfs_ialloc_btree.c
    so the caller specifies the btree type on cursor initialization to
    prepare for addition of the finobt.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
