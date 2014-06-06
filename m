Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-da-geom,
	created. xfs-for-linus-3.15-rc6-74-gb2a21e7
Message-Id: <20140606070050.20B537F47@oss.sgi.com>
Date: Fri,  6 Jun 2014 02:00:49 -0500 (CDT)
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

The branch, xfs-da-geom has been created
        at  b2a21e7a6bfa6aa1b712fb6167d37a96f332d3d5 (commit)

- Log -----------------------------------------------------------------
commit b2a21e7a6bfa6aa1b712fb6167d37a96f332d3d5
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:22:04 2014 +1000

    xfs: remove redundant geometry information from xfs_da_state
    
    It's carried in state->args->geo, so there's no need to duplicate it
    and use more stack space than necessary.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c2c4c477e0d02b0b352a71a25be56c9d35537265
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:21:45 2014 +1000

    xfs: replace attr LBSIZE with xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit c59f0ad23af0f4d7f64d2c2cdd85ceb49f6337fa
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:21:27 2014 +1000

    xfs: pass xfs_da_args to xfs_attr_leaf_newentsize
    
    As it's only ever called from contexts where the xfs_da_args is
    present and contains all the information needed inside the args
    structure.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 33a6039007af112509f48910e62640dadd064322
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:21:10 2014 +1000

    xfs: use xfs_da_geometry for block size in attr code
    
    Rather than using the superblock value obtained through the
    xfs_mount.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit bc85178a7668db835666c6a5bd53436eebfc94b1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:20:54 2014 +1000

    xfs: remove mp->m_dir_geo from directory logging
    
    We don't pass the xfs_da_args or the geometry all the way down to
    the directory buffer logging code, hence we have to use
    mp->m_dir_geo here. Fix this to use the geometry passed via the
    xfs_da_args, and convert all the directory logging functions for
    consistency.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 53f82db003900822ff828b792b1690a53a57c028
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:20:32 2014 +1000

    xfs: reduce direct usage of mp->m_dir_geo
    
    There are many places in the directory code were we don't pass the
    args into and so have to extract the geometry direct from the mount
    structure. Push the args or the geometry into these leaf functions
    so that we don't need to grab it from the struct xfs_mount.
    
    This, in turn, brings use to the point where directory geometry is
    no longer a property of the struct xfs_mount; it is not a global
    property anymore, and hence we can start to consider per-directory
    configuration of physical geometries.
    
    Start by converting the xfs_dir_isblock/leaf code - pass in the
    xfs_da_args and convert the readdir code to use xfs_da_args like
    the rest of the directory code to pass information around.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7ab610f9e0f1701b7b319bdc946b9804fb79e780
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:20:02 2014 +1000

    xfs: move node entry counts to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ed358c0058fc7d97807c92333a4e06117a4be5fe
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:18:10 2014 +1000

    xfs: convert dir/attr btree threshold to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8f66193c89f0b0259db6b27b4df3deb828c294f9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:15:59 2014 +1000

    xfs: convert m_dirblksize to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d6cf13051f31bf1a54b65643d0e578b3ca2f0692
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:14:11 2014 +1000

    xfs: convert m_dirblkfsbs to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7dda6e8644a31c366484bbcb564ea6c6225e5963
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:11:18 2014 +1000

    xfs: convert directory segment limits to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 30028030b14d083123c88e3ab45990a8c375abf1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:08:18 2014 +1000

    xfs: convert directory db conversion to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2998ab1d450a526a9a3a6292f91239b4fc209db0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:07:53 2014 +1000

    xfs: convert directory dablk conversion to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9b3b5522d3f55215ce51c87b0467926c57a6f182
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:06:53 2014 +1000

    xfs: convert dir byte/off conversion to xfs_da_geometry
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8c44a28561625d36591cc1540eb5f9033a9d1815
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:04:41 2014 +1000

    xfs: kill XFS_DIR2...FIRSTDB macros
    
    They are just simple wrappers around xfs_dir2_byte_to_db(), and
    we've already removed one usage earlier in the patch set. Kill
    the rest before we start removing the xfs_mount from conversion
    functions.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 892e3f342f9888066f1ce56f3683572f0ca9b8e9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:04:05 2014 +1000

    xfs: move directory block translatiosn to xfs_dir2_priv.h
    
    Because they aren't actually part of the on-disk format, and so
    shouldn't be in xfs_da_format.h.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 0650b55497ef583c43d6afc80e11a39e92d9a525
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jun 6 15:01:58 2014 +1000

    xfs: introduce directory geometry structure
    
    The directory code has a dependency on the struct xfs_mount to
    supply the directory block geometry. Block size, block log size,
    and other parameters are pre-caclulated in the struct xfs_mount or
    access directly from the superblock embedded in the struct
    xfs_mount.
    
    Extract all of this geometry information out of the struct xfs_mount
    and superblock and place it into a new struct xfs_da_geometry
    defined by the directory code. Allocate and initialise it at mount
    time, and attach it to the struct xfs_mount so it canbe passed back
    into the directory code appropriately rather than using the struct
    xfs_mount.
    
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
