Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5DGIUCI257218 for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 11:18:31 -0500
Received: from e2.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3476114EE8AD
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 09:18:29 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142]) by
	cuda.sgi.com with ESMTP id CPrsSM9ZQfQ0deTZ for
	<xfs@oss.sgi.com>; Mon, 13 Jun 2011 09:18:29 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5DFw382031265
	for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 11:58:03 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5DGIRP9056042 for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 12:18:27 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5DCIFuR021351 for <xfs@oss.sgi.com>; Mon, 13 Jun 2011 09:18:15 -0300
Subject: [PATCH]: [xfstests] Change test 202 to create a filesystem with
	small enough filesystem for a single AG
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 13 Jun 2011 09:18:25 -0700
Message-ID: <1307981905.7661.461.camel@chandra-lucid.beaverton.ibm.com>
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

Test 202 fails when the filesystem size is greater than 1TB with
not so clear message. 

Call mkfs with a small enough filesystem size even with older 
versions of XFS.

Signed-Off-By: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/202 b/202
index cbdcb57..f3030fc 100755
--- a/202
+++ b/202
@@ -41,8 +41,14 @@ _supported_os Linux
 
 _require_scratch
 
+#
+# The AG size is limited to 1TB (or even less with historic xfsprogs),
+# so chose a small enough filesystem to make sure we can actually create
+# a single AG filesystem.
+#
 echo "== Creating single-AG filesystem =="
-_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
+_scratch_mkfs_xfs -d agcount=1 -d size=$((1024*1024*1024)) >/dev/null 2>&1 \
+ || _fail "!!! failed to make filesystem with single AG"
 
 echo "== Trying to repair it (should fail) =="
 _scratch_xfs_repair


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
