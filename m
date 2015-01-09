Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.19-rc1-18-gad7df6e
Message-Id: <20150109024803.BF3E27F47@oss.sgi.com>
Date: Thu,  8 Jan 2015 20:48:03 -0600 (CST)
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
  ad7df6e Merge branch 'xfs-sb-logging-rework' into for-next
  6bcf093 Merge branch 'xfs-misc-fixes-for-3.20-2' into for-next
  324f8e7 xfs: sanitise sb_bad_features2 handling
  7b2b916 xfs: consolidate superblock logging functions
  82a0064 xfs: remove bitfield based superblock updates
  43fd1fc xfs: fix implicit bool to int conversion
  d32057f xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten
  64af7a6 xfs: remove deprecated sysctls
  aa5d95c xfs: move xfs_bmap_finish prototype
  9799b43 xfs: move struct xfs_bmalloca to libxfs
  5ebdc21 xfs: move xfs_types.h to libxfs
  2155355 xfs: move xfs_fs.h to libxfs
      from  efdca7aa3c41bce7a092019b3f675fbaa3b8d23f (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit ad7df6e858efe516e5f0d85832140307e8bb2966
Merge: 6bcf093 324f8e7
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Jan 9 11:08:31 2015 +1100

    Merge branch 'xfs-sb-logging-rework' into for-next
    
    Conflicts:
    	fs/xfs/xfs_mount.c

commit 6bcf0939ff12464c7ea24c056826b8a26def9b06
Merge: efdca7a 43fd1fc
Author: Dave Chinner <david@fromorbit.com>
Date:   Fri Jan 9 11:06:17 2015 +1100

    Merge branch 'xfs-misc-fixes-for-3.20-2' into for-next

commit 324f8e7e534a19771a567bd54600605ce948fa17
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 11:05:47 2015 +1100

    xfs: sanitise sb_bad_features2 handling
    
    We currently have to ensure that every time we update sb_features2
    that we update sb_bad_features2. Now that we log and format the
    superblock in it's entirety we actually don't have to care because
    we can simply update the sb_bad_features2 when we format it into the
    buffer. This removes the need for anything but the mount and
    superblock formatting code to care about sb_bad_features2, and
    hence removes the possibility that we forget to update bad_features2
    when necessary in the future.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7b2b9162b882688113c876a6f2fc2eebea5f8a18
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 11:04:48 2015 +1100

    xfs: consolidate superblock logging functions
    
    We now have several superblock loggin functions that are identical
    except for the transaction reservation and whether it shoul dbe a
    synchronous transaction or not. Consolidate these all into a single
    function, a single reserveration and a sync flag and call it
    xfs_sync_sb().
    
    Also, xfs_mod_sb() is not really a modification function - it's the
    operation of logging the superblock buffer. hence change the name of
    it to reflect this.
    
    Note that we have to change the mp->m_update_flags that are passed
    around at mount time to a boolean simply to indicate a superblock
    update is needed.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 82a0064d5954394c55ef76cafdf563b2373cb21f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 11:02:44 2015 +1100

    xfs: remove bitfield based superblock updates
    
    When we log changes to the superblock, we first have to write them
    to the on-disk buffer, and then log that. Right now we have a
    complex bitfield based arrangement to only write the modified field
    to the buffer before we log it.
    
    This used to be necessary as a performance optimisation because we
    logged the superblock buffer in every extent or inode allocation or
    freeing, and so performance was extremely important. We haven't done
    this for years, however, ever since the lazy superblock counters
    pulled the superblock logging out of the transaction commit
    fast path.
    
    Hence we have a bunch of complexity that is not necessary that makes
    writing the in-core superblock to disk much more complex than it
    needs to be. We only need to log the superblock now during
    management operations (e.g. during mount, unmount or quota control
    operations) so it is not a performance critical path anymore.
    
    As such, remove the complex field based logging mechanism and
    replace it with a simple conversion function similar to what we use
    for all other on-disk structures.
    
    This means we always log the entirity of the superblock, but again
    because we rarely modify the superblock this is not an issue for log
    bandwidth or CPU time. Indeed, if we do log the superblock
    frequently, delayed logging will minimise the impact of this
    overhead.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 43fd1fce9643586e0995ee5d11fb40641575348a
Author: Nicholas Mc Guire <der.herr@hofr.at>
Date:   Fri Jan 9 10:48:58 2015 +1100

    xfs: fix implicit bool to int conversion
    
    try_wait_for_completion returns bool so the wrapper function
    xfs_dqflock_nowait should probably also return bool and not int.
    
    Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d32057fc84c141af22ddf07b58e52570e52369cd
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jan 9 10:48:12 2015 +1100

    xfs: pass a 64-bit count argument to xfs_iomap_write_unwritten
    
    The code is already ready for it, and the pnfs layout commit code expects
    to be able to pass a larger than 32-bit argument.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 64af7a6ea5a4c7e12ae79415250d054424b7e0c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 10:47:43 2015 +1100

    xfs: remove deprecated sysctls
    
    xfsbufd_centisecs and age_buffer_centisecs were due for removal in
    3.14. We forgot to do that - it's now well past time to remove these
    deprecated, unused sysctls.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit aa5d95c1b57792119804c587b9a468019219d7e0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 10:47:14 2015 +1100

    xfs: move xfs_bmap_finish prototype
    
    This function is used libxfs code, but is implemented separately in
    userspace. Move the function prototype to xfs_bmap.h so that the
    prototype is shared even if the implementations aren't.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9799b438ce21662fa173ffc0b30d93567a71dfa0
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 10:46:49 2015 +1100

    xfs: move struct xfs_bmalloca to libxfs
    
    It no long is used for stack splits, so strip the kernel workqueue
    bits from it and push it back into libxfs/xfs_bmap.h so that
    it can be shared with the userspace code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5ebdc213ac02877e23fe7594d4b92b120488aac9
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 10:46:31 2015 +1100

    xfs: move xfs_types.h to libxfs
    
    The types used by the core XFS code are common between kernel and
    userspace. xfs_types.h is duplicated in both kernel and userspace,
    so move it to libxfs along with all the other shared code.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2155355fda502e75cd942db101fbb08e1a826ba8
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Jan 9 10:45:13 2015 +1100

    xfs: move xfs_fs.h to libxfs
    
    Ioctl API definitions are shared with userspace, so move the header
    file that defines them all to libxfs along with all the other code
    shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/libxfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/libxfs/xfs_bmap.c        |  14 +-
 fs/xfs/libxfs/xfs_bmap.h        |  33 ++++
 fs/xfs/libxfs/xfs_format.h      |  14 +-
 fs/xfs/{ => libxfs}/xfs_fs.h    |   0
 fs/xfs/libxfs/xfs_sb.c          | 333 +++++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_sb.h          |  11 +-
 fs/xfs/libxfs/xfs_shared.h      |  33 ++--
 fs/xfs/libxfs/xfs_trans_resv.c  |  14 --
 fs/xfs/libxfs/xfs_trans_resv.h  |   1 -
 fs/xfs/{ => libxfs}/xfs_types.h |   0
 fs/xfs/xfs_bmap_util.h          |  37 +----
 fs/xfs/xfs_dquot.h              |   2 +-
 fs/xfs/xfs_fsops.c              |  33 +---
 fs/xfs/xfs_iomap.c              |   2 +-
 fs/xfs/xfs_iomap.h              |   2 +-
 fs/xfs/xfs_log.c                |  18 ++-
 fs/xfs/xfs_mount.c              | 106 +++----------
 fs/xfs/xfs_mount.h              |   5 +-
 fs/xfs/xfs_qm.c                 |  43 +-----
 fs/xfs/xfs_qm.h                 |   1 -
 fs/xfs/xfs_qm_syscalls.c        |  14 +-
 fs/xfs/xfs_super.c              |  13 +-
 fs/xfs/xfs_sysctl.c             |  18 ---
 24 files changed, 265 insertions(+), 484 deletions(-)
 rename fs/xfs/{ => libxfs}/xfs_fs.h (100%)
 rename fs/xfs/{ => libxfs}/xfs_types.h (100%)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
