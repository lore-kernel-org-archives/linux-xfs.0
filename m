Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6DDA29E0D
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 20:21:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E5DBAC001
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 18:21:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2FwfAVZOQjUaaIaG for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 18:21:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UaFYF-00039O-RB
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UaFYF-0003vT-Nt
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfstests: fix incorrect redirect in generic/233
Date: Thu,  9 May 2013 11:21:39 +1000
Message-Id: <1368062501-15046-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-1-git-send-email-david@fromorbit.com>
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
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

generic/233 attempts to direct output to tee, but instead of using a
pipe it uses an append operator. Hence it leaves a file named "tee"
in the root directory of the xfstests execution path. Just direct
the output to the $seqres.full file rather than trying to tee it
into the test output as well.

Reported-by: "Michael L. Semon" <mlsemon35@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 tests/generic/233 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/233 b/tests/generic/233
index 2b6cd2f..58b3672 100755
--- a/tests/generic/233
+++ b/tests/generic/233
@@ -62,7 +62,7 @@ _fsstress()
 -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
 -n $count -d $out -p 7`
 
-	echo "fsstress $args" >> tee -a $seqres.full
+	echo "fsstress $args" >> $seqres.full
 	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $seqres.full | _filter_num
 	then
 		echo "    fsstress $args returned $?"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
