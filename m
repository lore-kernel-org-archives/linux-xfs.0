Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBEA17CAE
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 13:02:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F038A8F8033
	for <xfs@oss.sgi.com>; Fri, 27 May 2016 11:02:54 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id oSAioCicKUConUvA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 May 2016 11:02:52 -0700 (PDT)
Date: Fri, 27 May 2016 11:02:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160527180231.GB5050@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

If we're running against a old version of xfsprogs that lacks some of
the structures that the golden output knows about, copy the structure
size definition from the golden output to the program output.  This
way we can check for structure size mutations on old xfsprogs without
generating false error reports for structs that don't exist in the
old release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |    8 ++++++++
 tests/xfs/122.out |    1 +
 2 files changed, 9 insertions(+)

diff --git a/tests/xfs/122 b/tests/xfs/122
index 845cdd2..c944942 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ _attribute_filter()
 cprog=$tmp.get_structs.c
 oprog=$tmp.get_structs
 progout=$tmp.output
+keyfile=$tmp.keys
 
 cat >$cprog <<EOF
 #define _GNU_SOURCE
@@ -239,6 +240,13 @@ if [ $XFSPROGS_VERSION -lt 30000 ]; then
 	echo 'sizeof( xfs_dsb_t ) = 208' >>$progout;
 fi
 
+# Find all the items that only exist in the golden output
+comm -23 <(grep '=' $0.out | sed -e 's/ =.*$//g' | LC_COLLATE=POSIX sort) \
+	 <(sed -e 's/ =.*$//g' < $progout | LC_COLLATE=POSIX sort) > $keyfile
+
+# Copy those items to the program output
+grep -F -f $keyfile $0.out >> $progout
+
 LC_COLLATE=POSIX sort $progout
 
 status=0
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
