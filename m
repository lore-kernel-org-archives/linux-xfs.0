Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-40-g632b89e
Message-Id: <20131030191905.22B517F5D@oss.sgi.com>
Date: Wed, 30 Oct 2013 14:19:04 -0500 (CDT)
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
  632b89e xfs: fix static and extern sparse warnings
  a629362 xfs: validity check the directory block leaf entry count
  b01ef65 xfs: make dir2 ftype offset pointers explicit
  1c9a5b2 xfs: convert directory vector functions to constants
  24dd0f5 xfs: convert directory vector functions to constants
  01ba43b xfs: vectorise encoding/decoding directory headers
  4bceb18 xfs: vectorise DA btree operations
  4141956 xfs: vectorise directory leaf operations
  2ca9877 xfs: vectorise directory data operations part 2
  9d23fc8 xfs: vectorise directory data operations
  4740175 xfs: vectorise remaining shortform dir2 ops
  32c5483 xfs: abstract the differences in dir2/dir3 via an ops vector
      from  c963c6193a5adaec58044e238ef23516d04e5a74 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 632b89e82bf1c04c251924b49adc689f7b346321
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:58 2013 +1100

    xfs: fix static and extern sparse warnings
    
    The kbuild test robot indicated that there were some new sparse
    warnings in fs/xfs/xfs_dquot_buf.c. Actually, there were a lot more
    that is wasn't warning about, so fix them all up.
    
    Reported-by: kbuild test robot
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a62936210525da2f46ae264e0bf9680eafac176e
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:56 2013 +1100

    xfs: validity check the directory block leaf entry count
    
    The directory block format verifier fails to check that the leaf
    entry count is in a valid range, and so if it is corrupted then it
    can lead to derefencing a pointer outside the block buffer. While we
    can't exactly validate the count without first walking the directory
    block, we can ensure the count lands in the valid area within the
    directory block and hence avoid out-of-block references.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b01ef655d8b9753c3d25e4c22e0a4e7c442fe5e1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:55 2013 +1100

    xfs: make dir2 ftype offset pointers explicit
    
    Rather than hiding the ftype field size accounting inside the dirent
    padding for the ".." and first entry offset functions for v2
    directory formats, add explicit functions that calculate it
    correctly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1c9a5b2e3045b91a10335adcc73267c304cb5dc0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 30 09:15:02 2013 +1100

    xfs: convert directory vector functions to constants
    
    Many of the vectorised function calls now take no parameters and
    return a constant value. There is no reason for these to be vectored
    functions, so convert them to constants
    
    Binary sizes:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
     789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
     789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
     791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
     791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
     791205   96802    1096  889103   d91cf fs/xfs/xfs.o.p9
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 24dd0f546c366da68f33bbf2ecef2306f8c2281d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 30 13:48:41 2013 -0500

    xfs: convert directory vector functions to constants
    
    Next step in the vectorisation process is the directory free block
    encode/decode operations. There are relatively few of these, though
    there are quite a number of calls to them.
    
    Binary sizes:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
     789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
     789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
     791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
     791701   96802    1096  889599   d92ff fs/xfs/xfs.o.p8
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 01ba43b873d9e91ba2e0341fe8cb7e89eaa41661
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:52 2013 +1100

    xfs: vectorise encoding/decoding directory headers
    
    Conversion from on-disk structures to in-core header structures
    currently relies on magic number checks. If the magic number is
    wrong, but one of the supported values, we do the wrong thing with
    the encode/decode operation. Split these functions so that there are
    discrete operations for the specific directory format we are
    handling.
    
    In doing this, move all the header encode/decode functions to
    xfs_da_format.c as they are directly manipulating the on-disk
    format. It should be noted that all the growth in binary size is
    from xfs_da_format.c - the rest of the code actaully shrinks.
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
     789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
     789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
     791421   96802    1096  889319   d91e7 fs/xfs/xfs.o.p7
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4bceb18f1551c8c047eeb54d48cda9f5453dc12f
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Oct 29 22:11:51 2013 +1100

    xfs: vectorise DA btree operations
    
    The remaining non-vectorised code for the directory structure is the
    node format blocks. This is shared with the attribute tree, and so
    is slightly more complex to vectorise.
    
    Introduce a "non-directory" directory ops structure that is attached
    to all non-directory inodes so that attribute operations can be
    vectorised for all inodes.
    
    Once we do this, we can vectorise all the da btree operations.
    Because this patch adds more infrastructure than it removes the
    binary size does not decrease:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
     789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
     789733   96802    1096  887631   d8b4f fs/xfs/xfs.o.p6
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4141956ae05e0685b14b30f92fdc8fb11b4a0cb2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:50 2013 +1100

    xfs: vectorise directory leaf operations
    
    Next step in the vectorisation process is the leaf block
    encode/decode operations. Most of the operations on leaves are
    handled by the data block vectors, so there are relatively few of
    them here.
    
    Because of all the shuffling of code and having to pass more state
    to some functions, this patch doesn't directly reduce the size of
    the binary. It does open up many more opportunities for factoring
    and optimisation, however.
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
     789061   96802    1096  886959   d88af fs/xfs/xfs.o.p5
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2ca9877410594dd321621efc9e1cbcd1ca24d0f3
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:49 2013 +1100

    xfs: vectorise directory data operations part 2
    
    Convert the rest of the directory data block encode/decode
    operations to vector format.
    
    This further reduces the size of the built binary:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
     789005   96802    1096  886903   d8997 fs/xfs/xfs.o.p4
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9d23fc8575de7012b8853bd6fefe10534665de2f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:48 2013 +1100

    xfs: vectorise directory data operations
    
    Following from the initial patches to vectorise the shortform
    directory encode/decode operations, convert half the data block
    operations to use the vector. The rest will be done in a second
    patch.
    
    This further reduces the size of the built binary:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
     789293   96802    1096  887191   d8997 fs/xfs/xfs.o.p3
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 4740175e75f70ab71f76ae98ab00f7db731a48f7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:47 2013 +1100

    xfs: vectorise remaining shortform dir2 ops
    
    Following from the initial patch to introduce the directory
    operations vector, convert the rest of the shortform directory
    operations to use vectored ops rather than superblock feature
    checks. This further reduces the size of the built binary:
    
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
     792350   96802    1096  890248   d9588 fs/xfs/xfs.o.p2
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 32c5483a8a13a43264809144210ec114dd70b611
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:46 2013 +1100

    xfs: abstract the differences in dir2/dir3 via an ops vector
    
    Lots of the dir code now goes through switches to determine what is
    the correct on-disk format to parse. It generally involves a
    "xfs_sbversion_hasfoo" check, deferencing the superblock version and
    feature fields and hence touching several cache lines per operation
    in the process. Some operations do multiple checks because they nest
    conditional operations and they don't pass the information in a
    direct fashion between each other.
    
    Hence, add an ops vector to the xfs_inode structure that is
    configured when the inode is initialised to point to all the correct
    decode and encoding operations.  This will significantly reduce the
    branchiness and cacheline footprint of the directory object decoding
    and encoding.
    
    This is the first patch in a series of conversion patches. It will
    introduce the ops structure, the setup of it and add the first
    operation to the vector. Subsequent patches will convert directory
    ops one at a time to keep the changes simple and obvious.
    
    Just this patch shows the benefit of such an approach on code size.
    Just converting the two shortform dir operations as this patch does
    decreases the built binary size by ~1500 bytes:
    
    $ size fs/xfs/xfs.o.orig fs/xfs/xfs.o.p1
       text    data     bss     dec     hex filename
     794490   96802    1096  892388   d9de4 fs/xfs/xfs.o.orig
     792986   96802    1096  890884   d9804 fs/xfs/xfs.o.p1
    $
    
    That's a significant decrease in the instruction cache footprint of
    the directory code for such a simple change, and indicates that this
    approach is definitely worth pursuing further.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile            |   1 +
 fs/xfs/xfs_alloc_btree.c   |   1 +
 fs/xfs/xfs_attr_inactive.c |   5 +-
 fs/xfs/xfs_attr_leaf.c     |   8 +-
 fs/xfs/xfs_attr_list.c     |  13 +-
 fs/xfs/xfs_attr_remote.c   |   1 +
 fs/xfs/xfs_bit.c           |   1 +
 fs/xfs/xfs_bmap_btree.c    |   1 +
 fs/xfs/xfs_buf_item.c      |   2 +-
 fs/xfs/xfs_da_btree.c      | 252 ++++++-------
 fs/xfs/xfs_da_btree.h      |   1 +
 fs/xfs/xfs_da_format.c     | 907 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_da_format.h     | 347 -----------------
 fs/xfs/xfs_dir2.c          |   7 +-
 fs/xfs/xfs_dir2.h          | 106 +++++-
 fs/xfs/xfs_dir2_block.c    |  97 ++---
 fs/xfs/xfs_dir2_data.c     | 150 ++++----
 fs/xfs/xfs_dir2_leaf.c     | 231 +++++-------
 fs/xfs/xfs_dir2_node.c     | 337 ++++++++---------
 fs/xfs/xfs_dir2_priv.h     |  20 +-
 fs/xfs/xfs_dir2_readdir.c  |  30 +-
 fs/xfs/xfs_dir2_sf.c       | 204 +++-------
 fs/xfs/xfs_dquot_buf.c     |   3 +-
 fs/xfs/xfs_ialloc_btree.c  |   1 +
 fs/xfs/xfs_inode.h         |   3 +
 fs/xfs/xfs_iops.c          |   2 +
 fs/xfs/xfs_mount.h         |   3 +
 fs/xfs/xfs_rtbitmap.c      |   1 +
 fs/xfs/xfs_sb.c            |   1 +
 fs/xfs/xfs_super.c         |   2 +-
 30 files changed, 1610 insertions(+), 1128 deletions(-)
 create mode 100644 fs/xfs/xfs_da_format.c


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
