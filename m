Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3F7F7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9AFE1304064
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:15 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PToXQDwQvpfaJ2dG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:14 -0700 (PDT)
Subject: [PATCH 1/7] xfs/104: don't enospc when ag metadata overhead grows
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:08 -0700
Message-ID: <146424222875.6278.15144771781299434088.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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
