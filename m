Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GH1S8I047361 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 12:01:28 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C0B0A145
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 10:01:27 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id IYDRulolSpkqtEpy for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2011 10:01:27 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5GGXXL5016285
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 12:33:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5GH1QMP116132 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 13:01:26 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5GH1Ek9026620 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 13:01:14 -0400
Subject: [PATCH]: [xfstests] test 032: Run mkfs.xfs only if the prior
	mkfs.${fs} succeded
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 16 Jun 2011 10:01:11 -0700
Message-ID: <1308243671.5505.4.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>

This test fails when mkfs of a different filesystem fails, which is not
a failure case for this specific test.

Hence, change the test to run mkfs.xfs only if the prior mkfs.${fs} on 
different filesystem succeded.

Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
---

diff --git a/032 b/032
index 839b913..4261ca2 100755
--- a/032
+++ b/032
@@ -75,11 +75,15 @@ do
 	echo "    ( $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs )" >>$seq.full
 	eval $preop mkfs -t $fs $preargs $SCRATCH_DEV $postargs >>$seq.full 2>&1
 
-	# next, ensure we don't overwrite it
-	echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
-	/sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
+	if [ $? -eq 0 ] ; then
+		# next, ensure we don't overwrite it
+		echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
+		/sbin/mkfs.xfs $SCRATCH_DEV >>$seq.full 2>&1
 
-	[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
+		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
+	else
+		echo "mkfs of type ${fs} failed" >>$seq.full
+	fi
 done
 
 # success, all done


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
