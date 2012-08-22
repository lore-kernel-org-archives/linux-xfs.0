Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7MIsDDl038389 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 13:54:13 -0500
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 64A938F8084
	for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 11:54:56 -0700 (PDT)
Subject: xfstests: Replace lstat64 with cat in test 120
Message-Id: <20120822185456.4F189B010E6D@gulag1.americas.sgi.com>
Date: Wed, 22 Aug 2012 13:54:56 -0500 (CDT)
From: rjohnston@sgi.com (Rich Johnston)
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

The later versions of libtool (i.e.2.4+) create a wrapper (bash script) for
lstat64 in the src directory.  The wrapper calls the real binary created by
libtool (.libs/lstat64)

Test 120 only copies src/lstat64 to $SCRATCH_MNT.  If a later version of
libtool is used then only the wrapper is copied to $SCRATCH_MNT and the wrapper
will fail to find .libs/lstat64.

   ~/xfstests # diff 120.out 120.out.bad
   /mnt/scratch/lstat64: error: `/mnt/scratch/.libs/lstat64' does not exist
   This script is just a wrapper for lstat64.
   See the libtool documentation for more information.

This patch copies /usr/bin/cat (which is readily availible on unix systems) to
$SCRATCH_MNT instead of src/lstat64.

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

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
