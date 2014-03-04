Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B63A7F73
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49884AC002
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	S4MEpDawcCvJb5ic for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HY-Lq
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006yk-L4
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/13] libxfs: limit superblock corruption errors to actual
	corruption
Date: Tue,  4 Mar 2014 19:51:49 +1100
Message-Id: <1393923117-9559-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

[userspace port]

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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 6ad99a5..05bc860 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -266,8 +266,7 @@ xfs_mount_validate_sb(
 	    sbp->sb_dblocks == 0					||
 	    sbp->sb_dblocks > XFS_MAX_DBLOCKS(sbp)			||
 	    sbp->sb_dblocks < XFS_MIN_DBLOCKS(sbp))) {
-		XFS_CORRUPTION_ERROR("SB sanity check failed",
-				XFS_ERRLEVEL_LOW, mp, sbp);
+		xfs_notice(mp, "SB sanity check failed");
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 
@@ -580,7 +579,7 @@ xfs_sb_read_verify(
 
 out_error:
 	if (error) {
-		if (error != EWRONGFS)
+		if (error == EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
 					     mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
