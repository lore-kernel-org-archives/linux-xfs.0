Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-restructure,
	updated. xfs-for-linus-3.16-rc1-13107-g2451337
Message-Id: <20140625060305.87CBA7F47@oss.sgi.com>
Date: Wed, 25 Jun 2014 01:03:04 -0500 (CDT)
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
  discards  c59a5aca071806ce2ed7279bbaf78336da49ce85 (commit)
  discards  63d512e1df8acffc3aa0068c6efab100c623968f (commit)
  discards  547a71f18113e33ff2420ad8b1712c6ab497a1dc (commit)
  discards  62c94547670f715923950a326daf8b129ca05ee5 (commit)
  2451337 xfs: global error sign conversion
  30f712c libxfs: move source files
  84be0ff libxfs: move header files
  69116a1 xfs: create libxfs infrastructure
      from  c59a5aca071806ce2ed7279bbaf78336da49ce85 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2451337dd043901b5270b7586942abe564443e3d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:58:08 2014 +1000

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
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 30f712c9dd69348aa51351d5cb6d366bf4fae31d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:53 2014 +1000

    libxfs: move source files
    
    Move all the source files that are shared with userspace into
    libxfs/. This is done as one big chunk simpy to get it done
    quickly
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 84be0ffc9043f7c56044294eb775a2200452c76d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:36 2014 +1000

    libxfs: move header files
    
    Move all the header files that are shared with userspace into
    libxfs. This is done as one big chunk simpy to get it done quickly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 69116a1317ce3d2292e062bfb1a22757b95dcd06
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 25 14:57:22 2014 +1000

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
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------

Summary of changes:


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
