Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVvnY255563 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:57 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D8076162AF8E
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:56 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6Qi1u7ppI8zAesZ0 for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:56 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/8] xfstests: always us test option when checking large
	scratch device
Date: Mon, 21 Nov 2011 22:31:27 +1100
Message-Id: <1321875088-30801-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Some tests call _check_scratch_device directly and when using a
large filesystem this needs to run with a -t option to avoid
consuming large amounts of memory. Make this happen in all cases
that the scratch device is checked.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 017       |    7 ++-----
 common.rc |    2 ++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/017 b/017
index 9ca0e72..0a3ede3 100755
--- a/017
+++ b/017
@@ -48,9 +48,6 @@ _supported_os Linux
 
 _require_scratch
 
-checkopts=""
-[ "$USE_BIG_LOOPFS" = yes ] && checkopts=-t
-
 echo "*** init FS"
 
 rm -f $seq.full
@@ -81,8 +78,8 @@ do
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
index 12bd349..9b9041f 100644
--- a/common.rc
+++ b/common.rc
@@ -470,6 +470,8 @@ _scratch_xfs_check()
     SCRATCH_OPTIONS=""
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
+    [ "$LARGE_SCRATCH_DEV" = yes ] && \
+        SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
     $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
