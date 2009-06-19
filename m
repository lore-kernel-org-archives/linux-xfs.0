Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JKS00V078997 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 15:28:00 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Fix _require_scratch test for extN, resierfs, gfs2, and btrfs
Date: Fri, 19 Jun 2009 16:28:21 -0400
Message-Id: <1245443301-27495-1-git-send-email-tytso@mit.edu>
In-Reply-To: <7D909252-70A0-44C2-A5D7-D56A4B6CD244@sgi.com>
References: <7D909252-70A0-44C2-A5D7-D56A4B6CD244@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Theodore Ts'o <tytso@mit.edu>

The extN, reiserfs, gfs2, and btrfs filesysytem types should use the
same check for a block device as XFS and UDF, and not the test for
NFS, which was checking for host:/foo/bar/baz when checking for a
scratch device.

Also, the NFS logic was also incorrect, in that it would allow a
zero-length SCRATCH_DEV to continue.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

Oops, I sent the wrong version of the patch earlier.  Sorry about that!!

      	     	       	       	  - Ted
 common.rc |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common.rc b/common.rc
index 581cfba..cfab2cd 100644
--- a/common.rc
+++ b/common.rc
@@ -593,7 +593,7 @@ _supported_os()
 _require_scratch()
 {
     case "$FSTYP" in
-	xfs|udf)
+	xfs|udf|ext2|ext3|ext4|reiserfs|gfs2|btrfs)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
@@ -603,9 +603,9 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
-	nfs*|ext2|ext3|ext4|reiserfs|gfs2|btrfs)
+	nfs*)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
+		 if [ -z "$SCRATCH_DEV" -o "$?" != "0" ]
 		 then
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
-- 
1.6.3.2.1.gb9f7d.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
