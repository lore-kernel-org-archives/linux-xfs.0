Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7NHrZBQ037467 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 12:53:35 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9C674304062
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 10:54:19 -0700 (PDT)
Received: from cxfsxe4.americas.sgi.com (cxfsxe4.americas.sgi.com
	[128.162.240.177])
	by estes.americas.sgi.com (Postfix) with ESMTP id 7CDB27001ABC
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 12:54:19 -0500 (CDT)
Received: by cxfsxe4.americas.sgi.com (Postfix, from userid 48222)
	id 6822BCDA4F; Thu, 23 Aug 2012 12:54:19 -0500 (CDT)
Message-Id: <20120823174424.235978735@sgi.com>
Date: Thu, 23 Aug 2012 12:43:58 -0500
From: rjohnston@sgi.com
Subject: [PATCH V2] xfstests: Replace lstat64 with cat in test 120
References: <20120823174357.065135717@sgi.com>
Content-Disposition: inline; filename=replace_lstat64_with_cat.patch
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

Test 120 only copies src/lstat64 to $SCRATCH_MNT without verifying it is a
standalone binary.  If xfstests is compiled with a version of libtools that
creates the wrapper as described above, then only the wrapper is copied to
$SCRATCH_MNT and the wrapper will fail to find $SCRATCH_MNT/.libs/lstat64.

   ~/xfstests # diff 120.out 120.out.bad
   /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
   This script is just a wrapper for lstat64.
   See the libtool documentation for more information.

This patch copies /bin/cat (which is readily availible on unix systems) to
$SCRATCH_MNT instead of src/lstat64.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>
Reviewed-by: Alex Elder <elder@inktank.com>

---
 120 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: b/120
===================================================================
--- a/120
+++ b/120
@@ -68,12 +68,12 @@ fi
 
 #executable file
 echo "*** copying file ***"
-cp src/lstat64 $SCRATCH_MNT
-src/lstat64 $SCRATCH_MNT/lstat64 >$tmp.out
+cp /bin/cat $SCRATCH_MNT
+src/lstat64 $SCRATCH_MNT/cat >$tmp.out
 sleep 5
 echo "*** executing file ***"
-$SCRATCH_MNT/lstat64 $SCRATCH_MNT/lstat64 >/dev/null
-_compare_access_times $SCRATCH_MNT/lstat64 "executing file"
+$SCRATCH_MNT/cat $SCRATCH_MNT/cat >/dev/null
+_compare_access_times $SCRATCH_MNT/cat "executing file"
 
 #reading file
 echo "*** creating file ***"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
