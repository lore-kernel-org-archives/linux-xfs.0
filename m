Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AIjcvW002193 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:45:38 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB1F54B1E3A
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:45:37 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id LyrhdyQgkXkEERTK for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:45:37 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5AIYPmt018156
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:34:25 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5AIjaoi1216658
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 14:45:36 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5AEjOZa017180 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 11:45:24 -0300
Subject: [PATCH]: [xfstests] Make ext2 requirement explicit for test 049
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 10 Jun 2011 11:45:33 -0700
Message-ID: <1307731533.7661.436.camel@chandra-lucid.beaverton.ibm.com>
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
To: XFS <xfs@oss.sgi.com>
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
index c510c66..531a43e 100644
--- a/common.rc
+++ b/common.rc
@@ -769,6 +769,23 @@ _require_loop()
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
+    if modprobe ext2 >/dev/null 2>&1
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
