Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F9F87F55
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 16:01:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7ED33304077
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:01:31 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id GsrZKBXHUPl07hlQ
	for <xfs@oss.sgi.com>; Thu, 30 Jan 2014 14:01:27 -0800 (PST)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: generic/299 can have truncate fail
Date: Thu, 30 Jan 2014 17:01:23 -0500
Message-ID: <1391119283-11116-1-git-send-email-jbacik@fb.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

So this test does lots of fallocate/truncate noise while doing aio overwrites to
try and exercise a deadlock found in ext4.  Because it runs so hard with ENOSPC
it can sometimes cause truncate to fail on btrfs.  This is ok and doesn't affect
the validity of the test, we just need to catch the output so it doesn't cause
the test to fail.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 tests/generic/299 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/299 b/tests/generic/299
index 14cce96..bf02c94 100755
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -130,7 +130,7 @@ _workout()
 	    done
 	    for ((k=1; k <= NUM_JOBS; k++))
 	    do
-		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0
+		truncate -s 0 $SCRATCH_MNT/direct_aio.$k.0 >> $seqres.full 2>&1
 	    done
 	    # Following like will check that pid is still run.
 	    # Once fio exit we can stop fallocate/truncate loop
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
