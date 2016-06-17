Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B630856B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 98306AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:10 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5HHODkqca3lU35vh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:09 -0700 (PDT)
Subject: [PATCH 19/20] xfs: run xfs_repair at the end of each test
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:48:01 -0700
Message-ID: <146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
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

Run xfs_repair twice at the end of each test -- once to rebuild
the btree indices, and again with -n to check the rebuild work.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/common/rc b/common/rc
index 1225047..847191e 100644
--- a/common/rc
+++ b/common/rc
@@ -2225,6 +2225,9 @@ _check_xfs_filesystem()
         ok=0
     fi
 
+    $XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
+    cat $tmp.repair | _fix_malloc		>>$seqres.full
+
     $XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
