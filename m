Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1IMn1Ce081241 for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 16:49:01 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4130B1CDFE61
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 14:50:18 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id gjWf13sho9hcmU55 for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2010 14:50:18 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 97AFC9E7248
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2010 16:50:18 -0600 (CST)
Message-ID: <4B7DC42A.1030401@sandeen.net>
Date: Thu, 18 Feb 2010 16:50:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests 125: don't traverse through fs for su command
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

I often have xfstests in /root, and 125 fails for me like this:

--- 125.out	2009-08-05 20:19:40.380978986 -0500
+++ 125.out.bad	2010-02-18 16:48:57.507473627 -0600
@@ -1,4 +1,6 @@
 QA output created by 125
+bash: /root/git/xfstests-dev/src/ftrunc: Permission denied
+src/ftrunc returned non 0 status!
 direct write of 1's into file
 buffered write of 2's into file
 truncate file

I think this is becuase $here/src ... means going through
/root/git/xfstests-dev/src/ ... and the qa user can't
do that.

The below fixes it for me...

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/125 b/125
index e84109a..9a29941 100755
--- a/125
+++ b/125
@@ -61,7 +61,7 @@ touch $TESTFILE
 chmod a+rw $TESTDIR
 chmod a+rw $TESTFILE
 
-su $qa_user -c "$here/src/ftrunc -f $TESTFILE"
+su $qa_user -c "./src/ftrunc -f $TESTFILE"
 
 if [ "$?" != "0" ];  then
     echo src/ftrunc returned non 0 status!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
