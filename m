Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3371851B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A5189304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:00 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5vzvBjJbIF6jlHk2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:46:59 -0700 (PDT)
Subject: [PATCH 08/20] xfs/122: don't break on old xfsprogs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:46:52 -0700
Message-ID: <146612801269.25024.6120665241562735488.stgit@birch.djwong.org>
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

If we're running against a old version of xfsprogs that lacks some of
the structures that the golden output knows about, copy the structure
size definition from the golden output to the program output.  This
way we can check for structure size mutations on old xfsprogs without
generating false error reports for structs that don't exist in the
old release.

v2: Remove the xfsprogs 2.9.8 compatibility cruft.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |   17 ++++++-----------
 tests/xfs/122.out |    1 +
 2 files changed, 7 insertions(+), 11 deletions(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 845cdd2..330d3ac 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ _attribute_filter()
 cprog=$tmp.get_structs.c
 oprog=$tmp.get_structs
 progout=$tmp.output
+keyfile=$tmp.keys
 
 cat >$cprog <<EOF
 #define _GNU_SOURCE
@@ -226,18 +227,12 @@ cc -o $oprog $cprog >> $seqres.full 2>&1 || \
   _notrun "Could not compile test program (see end of $seqres.full)"
 $oprog | _type_size_filter | _type_name_filter > $progout
 
-#
-# add addition sizes and xfs_sb_t fields that don't exist in the version
-# being tested.
-#
+# Find all the items that only exist in the golden output
+comm -23 <(grep '=' $0.out | sed -e 's/ =.*$//g' | LC_COLLATE=POSIX sort) \
+	 <(sed -e 's/ =.*$//g' < $progout | LC_COLLATE=POSIX sort) > $keyfile
 
-# xfsprogs 2.9.8: sb_bad_features2 in pv 978822
-if [ $XFSPROGS_VERSION -lt 20908 ]; then
-	echo 'offsetof(xfs_sb_t, sb_bad_features2 ) = 204' >>$progout
-fi
-if [ $XFSPROGS_VERSION -lt 30000 ]; then
-	echo 'sizeof( xfs_dsb_t ) = 208' >>$progout;
-fi
+# Copy those items to the program output
+grep -F -f $keyfile $0.out >> $progout
 
 LC_COLLATE=POSIX sort $progout
 
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 451871e..46d1dd4 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -147,3 +147,4 @@ sizeof(xfs_lookup_t) = 4
 sizeof(xfs_qoff_logformat_t) = 20
 sizeof(xfs_timestamp_t) = 8
 sizeof(xfs_trans_header_t) = 16
+sizeof(xfs_zzzz_test_the_test_program) = -47

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
