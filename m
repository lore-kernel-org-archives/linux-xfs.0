Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O1fOVp125030 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 20:41:25 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id chnpR92f1KojEy7w for
	<xfs@oss.sgi.com>; Thu, 23 Aug 2012 18:42:10 -0700 (PDT)
Message-ID: <5036DBD6.4040301@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 09:41:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfstests: fix double set for SCRATCH_DEV when
	SCRATCH_DEV_POOL is set
Reply-To: miaox@cn.fujitsu.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Cc: anand.jain@oracle.com

check script has moved the first device of SCRATCH_DEV_POOL and used it to set
SCRATCH_DEV. But the case 265 does the same thing again when it includes
common.rc. Fix it by setting SCRATCH_DEV just by check script.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 common.config |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/common.config b/common.config
index 7bed1c5..a35954b 100644
--- a/common.config
+++ b/common.config
@@ -232,12 +232,13 @@ fi
 
 # a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
 # to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
-if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+if [ "$iam" == "check" -a ! -z "$SCRATCH_DEV_POOL" ]; then
     if [ ! -z "$SCRATCH_DEV" ]; then
         echo "common.config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
         exit 1
     fi
-    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+    # the user may forget to export SCRATCH_DEV when he/she set SCRATCH_DEV_POOL.
+    export SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
     SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
 fi
 
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
