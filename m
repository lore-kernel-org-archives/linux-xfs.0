Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5F1AEk4147601 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 20:10:14 -0500
Received: from e35.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C3B915E33A9
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 18:10:13 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id fRC178dgvJSBbOAL for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 18:10:13 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5F0qGeZ027500
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 18:52:16 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5F1A8Vt122848 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 19:10:08 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5F1A7wu006079
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 19:10:07 -0600
Subject: [PATCH]: [xfstests] Make the requirement of projid32bit explicit
	in test 244
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 14 Jun 2011 18:10:06 -0700
Message-ID: <1308100206.7661.486.camel@chandra-lucid.beaverton.ibm.com>
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

Test 244 depends on projid32bit feature in mkfs.xfs. Not all versions
of xfsprogs provide that feature in mkfs.xfs.

This patch makes it an explicit requirement and avoids running the test
if the feature doesn't exist, instead of failing the test with an obscure
message.

Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/244 b/244
index 99762a5..e9f8a3d 100755
--- a/244
+++ b/244
@@ -48,6 +48,7 @@ _cleanup()
 _supported_fs xfs
 _require_xfs_quota
 _require_scratch
+_require_projid32bit_in_xfs
 
 export MOUNT_OPTIONS="-opquota"
 
diff --git a/common.rc b/common.rc
index c510c66..4e051dc 100644
--- a/common.rc
+++ b/common.rc
@@ -797,6 +797,15 @@ _require_command()
     [ -n "$1" -a -x "$1" ] || _notrun "$_cmd utility required, skipped this test"
 }
 
+# this test requires the projid32bit feature to be available in
+# mkfs.xfs
+#
+_require_projid32bit_in_xfs()
+{
+        _scratch_mkfs_xfs -f -i projid32bit=0 2>&1 >/dev/null \
+	   || _notrun "mkfs.xfs doesn't have projid32bit feature"
+}
+
 # this test requires that external log/realtime devices are not in use
 #
 _require_nonexternal()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
