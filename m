Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BAB257F9E
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 17:06:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B41318F804B
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 15:06:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hmPKtCNmkNHONATI for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 15:06:45 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0SN6jdG023056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 18:06:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0SN6jno021760
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 18:06:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: don't use TEST_DIR before initialized in generic/313
Date: Tue, 28 Jan 2014 18:06:43 -0500
Message-Id: <1390950403-19755-1-git-send-email-bfoster@redhat.com>
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

The 'testfile' environment variable is initialized before the
xfstests environment is included into generic/313. TEST_DIR is not
defined at this point and causes the test to operate on the root.
Move the testfile initialization down after the general environment
is sourced.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/313 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/313 b/tests/generic/313
index 1237ded..623c777 100755
--- a/tests/generic/313
+++ b/tests/generic/313
@@ -29,7 +29,6 @@ seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
 
 here=`pwd`
-testfile=$TEST_DIR/testfile.$seq
 status=1	# failure is the default!
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
@@ -47,6 +46,8 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
+testfile=$TEST_DIR/testfile.$seq
+
 echo "Silence is golden"
 
 $here/src/t_truncate_cmtime $testfile 2>&1
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
