Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPHINuW253971 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 11:18:23 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B7A54C70B6
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 09:18:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mum1pifz7p0Yt7qH for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 09:18:48 -0800 (PST)
Received: from int-mx03.intmail.prod.int.phx2.redhat.com
	(int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAPHIl7v005489
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 12:18:48 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAPHIlol003303
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 12:18:47 -0500
Message-ID: <4B0D66F7.5080704@redhat.com>
Date: Wed, 25 Nov 2009 11:18:47 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 213: Add enospc case to fallocate test
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

Add a test for ENOSPC when fallocating.

Also, add an expected output, not sure how that went missing!

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/213 b/213
index 3cd55f7..7d66338 100755
--- a/213
+++ b/213
@@ -61,8 +61,6 @@ _require_xfs_io_falloc
 avail=`df -P $TEST_DIR | awk 'END {print $4}'`
 [ "$avail" -ge 1049600 ] || _notrun "Test device is too small ($avail KiB)"
 
-echo Silence is golden
-
 # reserve 1GiB, truncate at 100bytes
 $XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'truncate 100' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
@@ -79,6 +77,14 @@ rm -f $TEST_DIR/ouch
 $XFS_IO_PROG -F -f -c 'falloc 0 1g' -c 'falloc 2g 1m' -c 'truncate 3g' $TEST_DIR/ouch
 rm -f $TEST_DIR/ouch
 
+# Try to reserve more space than we have
+echo "We should get: fallocate: No space left on device"
+echo "Strangely, xfs_io sometimes says \"Success\" when something went wrong, FYI"
+
+let toobig=$avail*2
+$XFS_IO_PROG -F -f -c "falloc 0 ${toobig}k" $TEST_DIR/ouch
+rm -f $TEST_DIR/ouch
+
 # success, all done
 status=0
 exit
diff --git a/213.out b/213.out
new file mode 100644
index 0000000..521fca3
--- /dev/null
+++ b/213.out
@@ -0,0 +1,4 @@
+QA output created by 213
+We should get: fallocate: No space left on device
+Strangely, xfs_io sometimes says "Success" when something went wrong, FYI
+fallocate: No space left on device
diff --git a/group b/group
index b0254dd..8d055a2 100644
--- a/group
+++ b/group
@@ -322,7 +322,7 @@ prealloc
 210 auto aio quick
 211 auto aio quick
 212 auto aio quick
-213 rw auto prealloc quick
+213 rw auto prealloc quick enospc
 214 rw auto prealloc quick
 215 auto metadata quick
 216 log metadata auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
