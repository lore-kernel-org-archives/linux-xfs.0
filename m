Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-sysfs-support,
	created. xfs-for-linus-3.16-rc1-13117-ga087481
Message-Id: <20140714222517.EA0117F72@oss.sgi.com>
Date: Mon, 14 Jul 2014 17:25:17 -0500 (CDT)
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

The branch, xfs-sysfs-support has been created
        at  a087481811bed920eb5eedbb5574b915881adbea (commit)

- Log -----------------------------------------------------------------
commit a087481811bed920eb5eedbb5574b915881adbea
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 08:09:06 2014 +1000

    xfs: document log sysfs attributes in testing ABI
    
    Create a sysfs-fs-xfs ABI documentation file for newly added sysfs
    attributes. This is created under the testing section.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 80d6d69821a27c3cd4687c2eefe409cbd1b7f458
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 08:07:48 2014 +1000

    xfs: add log attributes for log lsn and grant head data
    
    Create log attributes to export the current runtime state of the log to
    sysfs. Note that the filesystem should be frozen for consistency across
    attributes.
    
    The following per-mount attributes are created: log_head_lsn,
    log_tail_lsn, reserve_grant_head and write_grant_head. These represent
    the physical log head, tail and reserve and write grant heads
    respectively. Attribute values are exported in the following format:
    
    	"cycle:[block,byte]"
    
    ... where cycle represents the log cycle and [block,bytes] represents
    either the basic block or byte offset of the log, depending on the
    attribute.  Log sequence number (LSN) values are encoded in basic blocks
    and grant heads are encoded in bytes. All values are in decimal format.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit baff4e44b92aad363dcce176b907a369ee8b348e
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 08:07:29 2014 +1000

    xfs: add xlog sysfs kobject and attribute handlers
    
    Embed a kobject into the xfs log data structure (xlog). This creates a
    'log' subdirectory for every XFS mount instance in sysfs. The lifecycle
    of the log kobject is tied to the lifecycle of the log.
    
    Also define a set of generic attribute handlers associated with the log
    kobject in preparation for the addition of attributes.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a31b1d3d89e40f585a1c6745b066774ee3263eb2
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 08:07:01 2014 +1000

    xfs: add xfs_mount sysfs kobject
    
    Embed a base kobject into xfs_mount. This creates a kobject associated
    with each XFS mount and a subdirectory in sysfs with the name of the
    filesystem. The subdirectory lifecycle matches that of the mount. Also
    add the new xfs_sysfs.[c,h] source files with some XFS sysfs
    infrastructure to facilitate attribute creation.
    
    Note that there are currently no attributes exported as part of the
    xfs_mount kobject. It exists solely to serve as a per-mount container
    for child objects.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 3d8712265c26546823b38eb97487262500ff13db
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 07:41:37 2014 +1000

    xfs: add a sysfs kset
    
    Create a sysfs kset to contain all sub-objects associated with the XFS
    module. The kset is created and removed on module initialization and
    removal respectively. The kset uses fs_obj as a parent. This leads to
    the creation of a /sys/fs/xfs directory when the kset exists.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a70a4fa528faf6f22adce9a9067d1f4dfc332ade
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Jul 15 07:41:25 2014 +1000

    xfs: fix a couple error sequence jumps in xfs_mountfs()
    
    xfs_mountfs() has a couple failure conditions that do not jump to the
    correct labels. Specifically:
    
    - xfs_initialize_perag_data() failure does not deallocate the log even
      though it occurs after log initialization
    - xfs_mount_reset_sbqflags() failure returns the error directly rather
      than jump to the error sequence
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7f8a058f6dc52219117bc2469b1fb816f7fa1a4b
Merge: 03e0134 2451337
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Jul 15 07:37:18 2014 +1000

    Merge branch 'xfs-libxfs-restructure' into for-next

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
