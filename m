Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9277B7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 11:44:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F3FB3AC002
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 09:44:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ojYO5NHF11pk0uLr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 09:44:37 -0700 (PDT)
Date: Tue, 31 May 2016 09:43:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531164352.GC5053@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<20160527180231.GB5050@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160527180231.GB5050@birch.djwong.org>
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
To: david@fromorbit.com
Cc: hch@infradead.org, linux-btrfs@vger.kernel.org, Xiao Yang <yangx.jy@cn.fujitsu.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

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
