Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AKS1d8009564 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 15:28:02 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27C23DA3476
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:27:59 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id SEXmpaDtXaLd1sOB for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:27:59 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5AKGC91032383
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:16:12 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5AKRope141172 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:27:50 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5AKRof8014238
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:27:50 -0600
Subject: [PATCH]: [xfstests] v2: Make ext2 requirement explicit for test 049
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 10 Jun 2011 13:27:48 -0700
Message-ID: <1307737668.7661.438.camel@chandra-lucid.beaverton.ibm.com>
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

Test 049 depends on ext2 module being supported by the kernel.

This patch makes it a explicit, instead of failing the test with
obscure message.

Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
---

diff --git a/049 b/049
index 3d3f030..c6c4faa 100755
--- a/049
+++ b/049
@@ -64,6 +64,7 @@ _require_nobigloopfs
 _require_nonexternal
 _require_scratch
 _require_loop
+_require_ext2
 
 rm -f $seq.full
 
diff --git a/common.rc b/common.rc
index c510c66..44c746d 100644
--- a/common.rc
+++ b/common.rc
@@ -769,6 +769,24 @@ _require_loop()
     fi
 }
 
+# this test requires ext2 filesystem support
+#
+_require_ext2()
+{
+    if [ "$HOSTOS" != "Linux" ]
+    then
+	_notrun "This test requires linux for ext2 filesystem support"
+    fi
+
+    modprobe ext2 >/dev/null 2>&1
+    if grep ext2 /proc/filesystems >/dev/null 2>&1
+    then
+	:
+    else
+	_notrun "This test requires ext2 filesystem support"
+    fi
+}
+
 # this test requires that (large) loopback device files are not in use
 #
 _require_nobigloopfs()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
