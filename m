Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K5vrfv242656 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 23:57:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97ACA124DFDF
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:58:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	wr9LXwSkfPtleFyR for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 21:58:51 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11455416-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 16:28:49 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXTaa-0005AY-4t
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 16:58:48 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXTaY-0001z9-VV
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 16:58:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: kill in 131 needs to be quiet
Date: Wed, 20 Jan 2010 16:58:46 +1100
Message-Id: <1263967126-7603-1-git-send-email-david@fromorbit.com>
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

If the kill fails because the processes have already terminates,
the output from kill (no such process) will cause the test to
fail. Make sure kill doesn't output anything.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 131 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/131 b/131
index 9be0a14..783765e 100755
--- a/131
+++ b/131
@@ -34,8 +34,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    kill $locktest_pid2
-    kill $locktest_pid1
+    kill $locktest_pid2 2&>1 /dev/null
+    kill $locktest_pid1 2&>1 /dev/null
     _cleanup_testdir
 }
 
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
