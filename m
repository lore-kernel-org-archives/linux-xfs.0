Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc1-3-g0f295a2
Message-Id: <20130909225428.27A2A7F6B@oss.sgi.com>
Date: Mon,  9 Sep 2013 17:54:27 -0500 (CDT)
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
  0f295a2 xfs: check magic numbers in dir3 leaf verifier first
  a30b036 xfs: fix some minor sparse warnings
  e9fbbad xfs: fix endian warning in xlog_recover_get_buf_lsn()
      from  1d03c6fa88af35e55047a1f2ab116f0fdf2f55aa (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 0f295a214bb7658ca37bd61a8a1f0cd4a9d86c1f
Author: Dave Chinner <david@fromorbit.com>
Date:   Tue Sep 3 10:06:58 2013 +1000

    xfs: check magic numbers in dir3 leaf verifier first
    
    Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
    validating the magic numbers in the buffer results in ASSERT
    failures due to mismatching magic numbers when a corruption occurs.
    Seeing as the verifier is supposed to catch the corruption and pass
    it back to the caller, having the verifier assert fail on error
    defeats the purpose of detecting the errors in the first place.
    
    Check the magic numbers direct from the buffer before decoding the
    header.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a30b0367978f75a2659c71b33739e5e445a363c8
Author: Dave Chinner <david@fromorbit.com>
Date:   Mon Sep 2 20:49:36 2013 +1000

    xfs: fix some minor sparse warnings
    
    A couple of simple locking annotations and 0 vs NULL warnings.
    Nothing that changes any code behaviour, just removes build noise.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit e9fbbad8d8b2cbd6df7f237e0b4de02d63837ce1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Sep 2 13:22:58 2013 +1000

    xfs: fix endian warning in xlog_recover_get_buf_lsn()
    
    sparse reports:
    
    fs/xfs/xfs_log_recover.c:2017:24: sparse: cast to restricted __be64
    
    Because I used the wrong structure for the on-disk superblock cast
    in 50d5c8d ("xfs: check LSN ordering for v5 superblocks during
    recovery"). Fix it.
    
    Reported-by: kbuild test robot
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap.c        |  2 +-
 fs/xfs/xfs_dir2_leaf.c   | 20 +++++++++++++-------
 fs/xfs/xfs_dquot_item.c  |  3 ++-
 fs/xfs/xfs_extent_busy.c |  3 ++-
 fs/xfs/xfs_ioctl.c       |  2 +-
 fs/xfs/xfs_itable.c      |  5 +++--
 fs/xfs/xfs_log.c         |  3 ++-
 fs/xfs/xfs_log_recover.c |  2 +-
 8 files changed, 25 insertions(+), 15 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
