Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A62629E2E
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 01:04:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C1B0AC002
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 23:04:42 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	IVQQL1tjwNFYSfjh for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 23:04:41 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZxUV-0000pJ-JB
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZxUL-0002R7-Ed
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfstests: fix incorrect redirect in generic/233
Date: Wed,  8 May 2013 16:04:25 +1000
Message-Id: <1367993066-9313-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367993066-9313-1-git-send-email-david@fromorbit.com>
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
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
