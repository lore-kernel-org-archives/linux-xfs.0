Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1A277F50
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B6308F8037
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:52:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PbgIsWSFKgHNE5wa for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:52:03 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4KHq3ab023701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 13:52:03 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests: fix typo in check
Date: Tue, 21 May 2013 01:51:59 +0800
Message-Id: <1369072319-13738-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

There is no $testname, should be $test_name

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 check | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check b/check
index a79747e..8d32486 100755
--- a/check
+++ b/check
@@ -242,7 +242,7 @@ if $have_test_arg; then
 			test_name=`basename $1`
 			group_file=$SRC_DIR/$test_dir/group
 
-			if grep "^$testname" $group_file >/dev/null ; then
+			if grep "^$test_name" $group_file >/dev/null ; then
 				# in group file ... OK
 				echo $SRC_DIR/$1 >>$tmp.list
 			else
-- 
1.8.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
