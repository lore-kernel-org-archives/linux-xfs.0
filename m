Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8e4X4001371 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:04 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	kFrLr1VW3LFvEXiz for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJbr-00013c-SQ
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003uc-Os
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/10] xfstests: rename RETAIN_AG_BYTES
Date: Thu, 26 Jul 2012 18:39:42 +1000
Message-Id: <1343291989-14987-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Rename the $RETAIN_AG_BYTES variable to be more generic so that it
reflects the fact that it is designed to retain a certain amount of
extra free space above the default amount in the filesystem when
doing large scratch device testing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/common.rc b/common.rc
index 9517904..b0af482 100644
--- a/common.rc
+++ b/common.rc
@@ -311,8 +311,8 @@ _scratch_mkfs_xfs()
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
     if [ "$LARGE_SCRATCH_DEV" = yes ]; then
-        [ -z "$RETAIN_AG_BYTES" ] && RETAIN_AG_BYTES=0
-        ./tools/ag-wipe -q -r $RETAIN_AG_BYTES $SCRATCH_DEV
+        [ -z "$SCRATCH_DEV_EMPTY_SPACE" ] && SCRATCH_DEV_EMPTY_SPACE=0
+        ./tools/ag-wipe -q -r $SCRATCH_DEV_EMPTY_SPACE $SCRATCH_DEV
     fi
 
     return $mkfs_status
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
