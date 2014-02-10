Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAA6C7F50
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 20:20:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B0F978F8035
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:20:36 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qAOSwLWmwKtUiQ2Y for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 18:20:35 -0800 (PST)
Message-ID: <52F83771.9080202@sandeen.net>
Date: Sun, 09 Feb 2014 20:20:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/6] xfs: limit superblock corruption errors to actual
	corruption
References: <52F83630.4020008@redhat.com>
In-Reply-To: <52F83630.4020008@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

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

Thanks to Brian for pointing out this better solution to my
earlier patch.

 fs/xfs/xfs_sb.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index b7c9aea..efaef71 100644
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
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
