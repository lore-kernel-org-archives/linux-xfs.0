Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0716A7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:04:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D920304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 15:04:44 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6LKU8jOC0kOLYYYV for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 15:04:42 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wcinv-0002PL-DU
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wcinv-0000oC-Ci
	for xfs@oss.sgi.com; Wed, 23 Apr 2014 08:04:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] generic: cleanup space after test in TESTDIR
Date: Wed, 23 Apr 2014 08:04:32 +1000
Message-Id: <1398204274-2113-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1398204274-2113-1-git-send-email-david@fromorbit.com>
References: <1398204274-2113-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

A couple of tests leave behind large files or directory structures
when they complete, which leads to small TEST_DEVs running out of
space during other tests. Make those space hogs clean up after
themselves so that random tests don't fail with ENOSPC errors.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/070 | 1 +
 tests/xfs/292     | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/tests/generic/070 b/tests/generic/070
index 3c88df0..f593d84 100755
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
+    rm -rf $TEST_DIR/fsstress
     rm -f $tmp.*
 }
 
diff --git a/tests/xfs/292 b/tests/xfs/292
index d67db47..2910118 100755
--- a/tests/xfs/292
+++ b/tests/xfs/292
@@ -57,6 +57,8 @@ mkfs.xfs -f $fsfile 2>&1 | sed -e "s:$fsfile:FILENAME:g" | grep meta-data
 echo "mkfs.xfs with cmdline geometry"
 mkfs.xfs -f -d su=16k,sw=5 $fsfile 2>&1 | sed -e "s:$fsfile:FILENAME:g" | grep meta-data
 
+rm -f $fsfile
+
 # success, all done
 status=0
 exit
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
