Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 016C87FFA
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 06:53:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D91598F8049
	for <xfs@oss.sgi.com>; Fri, 15 Mar 2013 04:53:49 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DZYNXGgbM7TYr1zJ for <xfs@oss.sgi.com>;
	Fri, 15 Mar 2013 04:53:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UGTCj-0001Tv-F8
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UGTCj-0005i7-BD
	for xfs@oss.sgi.com; Fri, 15 Mar 2013 22:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/13] xfstests: always use test option when checking large
	scratch device
Date: Fri, 15 Mar 2013 22:53:26 +1100
Message-Id: <1363348411-21867-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1363348411-21867-1-git-send-email-david@fromorbit.com>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
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

Some tests call _check_scratch_device directly and when using a
large filesystem this needs to run with a -t option to avoid
consuming large amounts of memory. Make this happen in all cases
that the scratch device is checked.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Rich Johnston <rjohnston@sgi.com>
---
 017       |    7 ++-----
 common.rc |    2 ++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/017 b/017
index 7db4667..fb92375 100755
--- a/017
+++ b/017
@@ -48,9 +48,6 @@ _supported_os Linux
 
 _require_scratch
 
-checkopts=""
-[ "$USE_BIG_LOOPFS" = yes ] && checkopts=-t
-
 echo "*** init FS"
 
 rm -f $seq.full
@@ -82,8 +79,8 @@ do
         echo ""                             >>$seq.full
         echo "*** XFS_CHECK ***"            >>$seq.full
         echo ""                             >>$seq.full
-        _scratch_xfs_check $checkopts       >>$seq.full 2>&1 \
-            || _fail "xfs_check $checkopts failed"
+        _scratch_xfs_check                  >>$seq.full 2>&1 \
+            || _fail "xfs_check failed"
         _scratch_mount -o remount,rw \
             || _fail "remount rw failed"
 done
diff --git a/common.rc b/common.rc
index ee4f522..1026572 100644
--- a/common.rc
+++ b/common.rc
@@ -475,6 +475,8 @@ _scratch_xfs_check()
     SCRATCH_OPTIONS=""
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
+    [ "$LARGE_SCRATCH_DEV" = yes ] && \
+        SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
     $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
