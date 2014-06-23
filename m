Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-restructure,
	updated. xfs-for-linus-3.16-rc1-13107-gc59a5ac
Message-Id: <20140623072359.C16CF7F47@oss.sgi.com>
Date: Mon, 23 Jun 2014 02:23:59 -0500 (CDT)
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

The branch, xfs-libxfs-restructure has been updated
  discards  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)
  discards  e3584e38615389850684fcffd699d97e2e06f2d6 (commit)
  discards  f212d6fcf5c1cc3a3980dd320804c1dfb9f49b75 (commit)
  discards  e10404cf914273de8016d5992c7049bdb9a9a089 (commit)
  discards  f3a19b3ad85dcc4a073270e1fb594eff37709788 (commit)
  discards  d5a6cda3cf2c0860543db26bb5df7ed4404f74cd (commit)
  c59a5ac xfs: global error sign conversion
  63d512e libxfs: move source files
  547a71f libxfs: move header files
  62c9454 xfs: create libxfs infrastructure
  b474c7a xfs: Nuke XFS_ERROR macro
  d99831f xfs: return is not a function
  16b9057 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  9c1d528 Merge commit '9f12600fe425bc28f0ccba034a77783c09c15af4' into for-linus
  8d02076 ->splice_write() via ->write_iter()
  412dd3a Merge tag 'xfs-for-linus-3.16-rc1' of git://oss.sgi.com/xfs/xfs
  23adbe1 fs,userns: Change inode_capable to capable_wrt_inode_uidgid
  bf97f3b xfs: switch to ->write_iter()
  b4f5d2c xfs: switch to ->read_iter()
  b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
  0c94933 iov_iter_truncate()
  71d8e53 start adding the tag to iov_iter
  31b1403 switch {__,}blockdev_direct_IO() to iov_iter
  a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
  d8d3d94 pass iov_iter to ->direct_IO()
  cb66a7a kill generic_segment_checks()
  f8579f8 generic_file_direct_write(): switch to iov_iter
      from  fcec2eb6a31bde491f4ce9ddd94b41c8aacccd43 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c59a5aca071806ce2ed7279bbaf78336da49ce85
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Jun 23 16:50:54 2014 +1000

    xfs: global error sign conversion
    
    Convert all the errors the core XFs code to negative error signs
    like the rest of the kernel and remove all the sign conversion we
    do in the interface layers.
    
    Errors for conversion (and comparison) found via searches like:
    
    $ git grep " E" fs/xfs
    $ git grep "return E" fs/xfs
    $ git grep " E[A-Z].*;$" fs/xfs
    
    Negation points found via searches like:
    
    $ git grep "= -[a-z,A-Z]" fs/xfs
    $ git grep "return -[a-z,A-D,F-Z]" fs/xfs
    $ git grep " -[a-z].*;" fs/xfs
    
    [ with some bits I missed from Brian Foster ]
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 63d512e1df8acffc3aa0068c6efab100c623968f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Sun Jun 22 15:07:54 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/. This is done as one big chunk simpy to get it done
    quickly
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 547a71f18113e33ff2420ad8b1712c6ab497a1dc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Sun Jun 22 15:06:54 2014 +1000

    libxfs: move header files
    
    Move all the header files that are shared with userspace into
    libxfs. This is done as one big chunk simpy to get it done quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit 62c94547670f715923950a326daf8b129ca05ee5
Author: Dave Chinner <dchinner@redhat.com>
Date:   Sun Jun 22 15:05:54 2014 +1000

    xfs: create libxfs infrastructure
    
    To minimise the differences between kernel and userspace code,
    split the kernel code into the same structure as the userspace code.
    That is, the gneric core functionality of XFS is moved to a libxfs/
    directory and treat it as a layering barrier in the XFS code.
    
    This patch introduces the libxfs directory, the build infrastructure
    and an initial source and header file to build. The libxfs directory
    will contain the header files that are needed to build libxfs - most
    of userspace does not care about the location of these header files
    as they are accessed indirectly. Hence keeping them inside libxfs
    makes it easy to track the changes and script the sync process as
    the directory structure will be identical.
    
    To allow this changeover to occur in the kernel code, there are some
    temporary infrastructure in the makefiles to grab the header
    filesystem from both locations. Once all the files are moved,
    modifications will be made in the source code that will make the
    need for these include directives go away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

commit b474c7ae4395ba684e85fde8f55c8cf44a39afaf
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Jun 22 15:04:54 2014 +1000

    xfs: Nuke XFS_ERROR macro
    
    XFS_ERROR was designed long ago to trap return values, but it's not
    runtime configurable, it's not consistently used, and we can do
    similar error trapping with ftrace scripts and triggers from
    userspace.
    
    Just nuke XFS_ERROR and associated bits.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit d99831ff393ff2e28d6110b41f24d9fecf986222
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Sun Jun 22 15:03:54 2014 +1000

    xfs: return is not a function
    
    return is not a function.  "return(EIO);" is silly;
    "return (EIO);" moreso.  return is not a function.
    Nuke the pointless parens.
    
    [dchinner: catch a couple of extra cases in xfs_attr_list.c,
    xfs_acl.c and xfs_linux.h.]
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c      |  17 +++----
 fs/xfs/xfs_attr_list.c |   2 +-
 fs/xfs/xfs_file.c      | 119 +++++++++++--------------------------------------
 fs/xfs/xfs_ioctl.c     |   2 +-
 fs/xfs/xfs_ioctl32.c   |   4 +-
 fs/xfs/xfs_trace.h     |   1 -
 6 files changed, 38 insertions(+), 107 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
