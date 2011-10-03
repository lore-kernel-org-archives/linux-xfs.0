Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93GqZ0Z252881 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 11:52:36 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FF851C62101
	for <xfs@oss.sgi.com>; Mon,  3 Oct 2011 09:52:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HS2pnq92EuNbY9gn for
	<xfs@oss.sgi.com>; Mon, 03 Oct 2011 09:52:34 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p93GqYIW002779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 12:52:34 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p93GqWcv015021
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 12:52:33 -0400
Message-ID: <4E89E851.80203@redhat.com>
Date: Mon, 03 Oct 2011 11:52:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make 258 more forgiving of timestamp rounding
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
To: xfs-oss <xfs@oss.sgi.com>

Rather than testing for an exact timestamp, which could vary
due to rounding, just check that it is not positive,
which is the failure case we're looking for.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/258 b/258
index 6fadca0..ad73494 100644
--- a/258
+++ b/258
@@ -53,8 +53,12 @@ TESTFILE=$TEST_DIR/timestamp-test.txt
 echo "Creating file with timestamp of Jan 1, 1960"
 touch -t 196001010101 $TESTFILE
 # Should yield -315593940 (prior to epoch)
-echo -n "Stat of file yields: "
-stat -c %X $TESTFILE
+echo "Testing for negative seconds since epoch"
+ts=`stat -c %X $TESTFILE`
+if [ "$ts" -ge 0 ]; then
+	echo "Timestamp wrapped: $ts"
+	_fail "Timestamp wrapped"
+fi
 
 # unmount, remount, and check the timestamp
 echo "Remounting to flush cache"
@@ -62,7 +66,12 @@ umount $TEST_DEV
 mount $TEST_DEV $TEST_DIR
 
 # Should yield -315593940 (prior to epoch)
-echo -n "Stat of file yields: "
-stat -c %X $TESTFILE
+echo "Testing for negative seconds since epoch"
+ts=`stat -c %X $TESTFILE`
+if [ "$ts" -ge 0 ]; then
+	echo "Timestamp wrapped: $ts"
+	_fail "Timestamp wrapped"
+fi
 
 status=0 ; exit
+
diff --git a/258.out b/258.out
index 11b9168..87fae0f 100644
--- a/258.out
+++ b/258.out
@@ -1,5 +1,5 @@
 QA output created by 258
 Creating file with timestamp of Jan 1, 1960
-Stat of file yields: -315593940
+Testing for negative seconds since epoch
 Remounting to flush cache
-Stat of file yields: -315593940
+Testing for negative seconds since epoch

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
