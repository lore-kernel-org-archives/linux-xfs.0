Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0C4ij5i217442 for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 22:44:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 810981C44458
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 20:45:39 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	OaMoCcEqHkVuZ7ZZ for <xfs@oss.sgi.com>;
	Mon, 11 Jan 2010 20:45:39 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11326442-1927428
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 15:15:37 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NUYdL-0004g5-MV
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:45:35 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NUYZJ-0005zX-5d
	for xfs@oss.sgi.com; Tue, 12 Jan 2010 15:41:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfsqa: filter the fsstress seed output in 104
Date: Tue, 12 Jan 2010 15:41:06 +1100
Message-Id: <1263271269-18997-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263271269-18997-1-git-send-email-david@fromorbit.com>
References: <1263271269-18997-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Otherwise it fails to match the golden output. Also add
the test to the auto group so that it is run regularly now
that the growfs problems are fixed.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 104   |    2 +-
 group |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/104 b/104
index 6dea1d3..5f18d08 100755
--- a/104
+++ b/104
@@ -60,7 +60,7 @@ _stress_scratch()
 	procs=3
 	nops=1000
 	# -w ensures that the only ops are ones which cause write I/O
-	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID &
+	$FSSTRESS_PROG -d $SCRATCH_MNT -w -p $procs -n $nops $FSSTRESS_AVOID > /dev/null &
 }
 
 # real QA test starts here
diff --git a/group b/group
index 8d055a2..2c2e293 100644
--- a/group
+++ b/group
@@ -210,7 +210,7 @@ prealloc
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
-104 growfs ioctl prealloc
+104 growfs ioctl prealloc auto
 105 acl auto quick
 106 quota
 107 quota
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
