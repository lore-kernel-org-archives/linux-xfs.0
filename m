Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DB627F47
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 12:29:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DB8F28F804C
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 10:29:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q4ZgVQWDQaS0FGAL for
	<xfs@oss.sgi.com>; Wed, 14 May 2014 10:29:44 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4EHTi8j031422
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 14 May 2014 13:29:44 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4EHTiVS015210
	for <xfs@oss.sgi.com>; Wed, 14 May 2014 13:29:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: make sure tests check for loop device support
Date: Wed, 14 May 2014 13:29:42 -0400
Message-Id: <1400088582-16916-1-git-send-email-bfoster@redhat.com>
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

Several tests happen to make use of loop device support without the
requisite pre-test checks. This results in spurious failures for systems
that might not have loop device support. Add _require_loop checks to
shared/298, xfs/206 and xfs/259.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/shared/298 | 1 +
 tests/xfs/206    | 1 +
 tests/xfs/259    | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/shared/298 b/tests/shared/298
index f13c14b..8211da3 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -32,6 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _supported_fs ext4 xfs
 _supported_os Linux
+_require_loop
 _require_fstrim
 _require_xfs_io_command "fiemap"
 _require_fs_space $TEST_DIR 307200
diff --git a/tests/xfs/206 b/tests/xfs/206
index 0bbd595..f739597 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -53,6 +53,7 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs xfs
 _supported_os IRIX Linux
+_require_loop
 
 bitsperlong=`src/feature -w`
 if [ "$bitsperlong" -ne 64 ]; then
diff --git a/tests/xfs/259 b/tests/xfs/259
index b8bd69a..8241d94 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -41,7 +41,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # real QA test starts here
 _supported_fs xfs
 _supported_os Linux
-
+_require_loop
 _require_math
 
 testfile=$TEST_DIR/259.image
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
