Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62AD8801B
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 17:52:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4F8B530408F
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:52:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BXNV7HkCMpRhwnQK for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 15:52:31 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/9] xfs: limit superblock corruption errors to actual
	corruption
Date: Tue, 18 Feb 2014 17:52:22 -0600
Message-Id: <1392767549-25574-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
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

Today, if

xfs_sb_read_verify
  xfs_sb_verify
    xfs_mount_validate_sb

detects superblock corruption, it'll be extremely noisy, dumping
2 stacks, 2 hexdumps, etc.

This is because we call XFS_CORRUPTION_ERROR in xfs_mount_validate_sb
as well as in xfs_sb_read_verify.

Also, *any* errors in xfs_mount_validate_sb which are not corruption
per se; things like too-big-blocksize, bad version, bad magic, v1 dirs,
rw-incompat etc - things which do not return EFSCORRUPTED - will
still do the whole XFS_CORRUPTION_ERROR spew when xfs_sb_read_verify
sees any error at all.  And it suggests to the user that they
should run xfs_repair, even if the root cause of the mount failure
is a simple incompatibility.

I'll submit that the probably-not-corrupted errors don't warrant
this much noise, so this patch removes the warning for anything
other than EFSCORRUPTED returns, and replaces the lower-level
XFS_CORRUPTION_ERROR with an xfs_notice().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/xfs_sb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 359b19a..1e11679 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -295,8 +295,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_dblocks == 0					||
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
 	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
-		XFS_CORRUPTION_ERROR("SB sanity check failed",
-				XFS_ERRLEVEL_LOW, mp, sbp);
+		xfs_notice(mp, "SB sanity check failed");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -625,7 +624,7 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		if (error != EWRONGFS)
+		if (error == EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
