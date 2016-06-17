Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EF58855B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 709B630404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nUqfVHDfCQlLWhye (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:52 -0700 (PDT)
Subject: [PATCH 17/20] generic/204: increase log size for rmap/reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:49 -0700
Message-ID: <146612806917.25024.2970222019985115835.stgit@birch.djwong.org>
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

We're going to need a bigger log for rmap & reflink on XFS, so
increase the size of the log and the fs appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/204 b/tests/generic/204
index 42985ab..7b0dc2a 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -55,9 +55,9 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 # versions of mkfs create. All should be valid with a 7MB log, so use that.
 # And v4/512 v5/1k xfs don't have enough free inodes, set imaxpct=50 at mkfs
 # time solves this problem.
-[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m -i maxpct=50"
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=16m -i maxpct=50"
 
-SIZE=`expr 106 \* 1024 \* 1024`
+SIZE=`expr 115 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
 		| _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
