Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E21E84E0
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:46:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 149D5AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:46:19 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kOct3ZBgW4relyXz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:46:17 -0700 (PDT)
Subject: [PATCH 01/20] xfs/104: don't enospc when ag metadata overhead grows
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:46:08 -0700
Message-ID: <146612796843.25024.7729638172520969379.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Adapt to different metadata overhead sizes by trying to reserve
decreasing amounts of disk space until we actually succeed at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/104 |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/104 b/tests/xfs/104
index 17f9b62..785027e 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -88,9 +88,14 @@ sizeb=`expr $size / $dbsize`	# in data blocks
 echo "*** creating scratch filesystem"
 _create_scratch -lsize=10m -dsize=${size} -dagcount=${nags}
 
-fillsize=`expr 110 \* 1048576`	# 110 megabytes of filling
 echo "*** using some initial space on scratch filesystem"
-_fill_scratch $fillsize
+for i in `seq 125 -1 90`; do
+	fillsize=`expr $i \* 1048576`
+	out="$(_fill_scratch $fillsize 2>&1)"
+	echo "$out" | grep -q 'No space left on device' && continue
+	test -n "${out}" && echo "$out"
+	break
+done
 
 #
 # Grow the filesystem while actively stressing it...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
