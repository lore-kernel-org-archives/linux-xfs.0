Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-libxfs-in-kernel-RFC,
	updated. xfs-for-linus-3.15-rc2-53-g70aadae
Message-Id: <20140508014324.C525C7F56@oss.sgi.com>
Date: Wed,  7 May 2014 20:43:24 -0500 (CDT)
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

The branch, xfs-libxfs-in-kernel-RFC has been updated
  70aadae libxfs: fix modular build
      from  6579dd808ddf0ddc10e59e715dc8f2eb09705203 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 70aadae524c437b3c38969316d2dbab5c2c811f2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu May 8 11:12:09 2014 +1000

    libxfs: fix modular build
    
    As reported by Brain Foster:
    
    Note that the Makefile structure between the core and libxfs/ subdir
    appears to be busted for module compiles. It attempts to create a
    libxfs.ko and doesn't appear to create any real link dependency between
    the logical modules:
    
    ...
    WARNING: "__tracepoint_xfs_dir2_sf_create" [fs/xfs/libxfs/libxfs.ko]
    undefined!
    WARNING: "__tracepoint_xfs_da_root_join" [fs/xfs/libxfs/libxfs.ko]
    undefined!
    WARNING: "xfs_trans_mod_sb" [fs/xfs/libxfs/libxfs.ko] undefined!
    WARNING: "xfs_extent_busy_insert" [fs/xfs/libxfs/libxfs.ko] undefined!
    WARNING: "__tracepoint_xfs_dir2_sf_addname" [fs/xfs/libxfs/libxfs.ko]
    undefined!
      CC      fs/xfs/xfs.mod.o
      CC      fs/xfs/libxfs/libxfs.mod.o
      LD [M]  fs/xfs/xfs.ko
      LD [M]  fs/xfs/libxfs/libxfs.ko
    
    Fix it by converting libxfs to be a static library, and hack the
    fs/xfs/xfs.o linker commands to include it directly and so
    completely avoid the need for a libxfs.ko module until we have
    sorted out all the circular dependency issues.
    
    Reported-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile        | 22 +++++++++++++++++++---
 fs/xfs/libxfs/Makefile | 12 +++++++-----
 2 files changed, 26 insertions(+), 8 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
