Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A2417F76
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 02:06:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E8D6AC002
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 00:06:29 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vEA4dB9Zk77B0YK5 for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 00:06:24 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXR70-0007yg-Tn
	for xfs@oss.sgi.com; Wed, 01 May 2013 17:05:58 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXR70-0008Sf-PJ
	for xfs@oss.sgi.com; Wed, 01 May 2013 17:05:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix incorrect redirect in generic/232
Date: Wed,  1 May 2013 17:05:58 +1000
Message-Id: <1367391958-32494-1-git-send-email-david@fromorbit.com>
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

generic/232 attempts to direct output to tee, but instead of using a
pipe it uses an append operator. Hence it leaves a file named "tee"
in the root directory of the xfstests execution path. Just direct
the output to the $seqres.full file rather than trying to tee it
into the test output as well.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/generic/232 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/generic/232 b/tests/generic/232
index 2402c45..8ada8aa 100755
--- a/tests/generic/232
+++ b/tests/generic/232
@@ -55,7 +55,7 @@ _fsstress()
 	count=2000
 	args=`_scale_fsstress_args -d $out -n $count -p 7`
 
-	echo "fsstress $args" >> tee -a $seqres.full
+	echo "fsstress $args" >> $seqres.full
 	if ! $FSSTRESS_PROG $args | tee -a $seqres.full | _filter_num
 	then
 		echo "    fsstress $args returned $?"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
