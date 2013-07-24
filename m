Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12118-ge60896d
Message-Id: <20130724171712.73E5C7F58@oss.sgi.com>
Date: Wed, 24 Jul 2013 12:17:11 -0500 (CDT)
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
  e60896d xfs: di_flushiter considered harmful
      from  d892d5864f020c44cfa4e23e9165112d8df91093 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit e60896d8f2b81412421953e14d3feb14177edb56
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jul 24 15:47:30 2013 +1000

    xfs: di_flushiter considered harmful
    
    When we made all inode updates transactional, we no longer needed
    the log recovery detection for inodes being newer on disk than the
    transaction being replayed - it was redundant as replay of the log
    would always result in the latest version of the inode would be on
    disk. It was redundant, but left in place because it wasn't
    considered to be a problem.
    
    However, with the new "don't read inodes on create" optimisation,
    flushiter has come back to bite us. Essentially, the optimisation
    made always initialises flushiter to zero in the create transaction,
    and so if we then crash and run recovery and the inode already on
    disk has a non-zero flushiter it will skip recovery of that inode.
    As a result, log recovery does the wrong thing and we end up with a
    corrupt filesystem.
    
    Because we have to support old kernel to new kernel upgrades, we
    can't just get rid of the flushiter support in log recovery as we
    might be upgrading from a kernel that doesn't have fully transactional
    inode updates.  Unfortunately, for v4 superblocks there is no way to
    guarantee that log recovery knows about this fact.
    
    We cannot add a new inode format flag to say it's a "special inode
    create" because it won't be understood by older kernels and so
    recovery could do the wrong thing on downgrade. We cannot specially
    detect the combination of zero mode/non-zero flushiter on disk to
    non-zero mode, zero flushiter in the log item during recovery
    because wrapping of the flushiter can result in false detection.
    
    Hence that makes this "don't use flushiter" optimisation limited to
    a disk format that guarantees that we don't need it. And that means
    the only fix here is to limit the "no read IO on create"
    optimisation to version 5 superblocks....
    
    Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dinode.h      |  3 +++
 fs/xfs/xfs_inode.c       | 31 ++++++++++++++++++++++---------
 fs/xfs/xfs_log_recover.c | 13 +++++++++++--
 3 files changed, 36 insertions(+), 11 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
