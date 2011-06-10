Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5AKdqEQ009962 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 15:39:53 -0500
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9085816EA165
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:39:51 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id 6X3xecqZu4rM5Kix for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2011 13:39:51 -0700 (PDT)
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5AKSCKR026835
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:28:12 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5AKdpXZ112216 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:39:51 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5AKdpcg025209 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:39:51 -0400
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p5AKdobf024995 for <xfs@oss.sgi.com>; Fri, 10 Jun 2011 16:39:50 -0400
Subject: Failure of xfstests test case 202
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 10 Jun 2011 13:39:47 -0700
Message-ID: <1307738387.7661.450.camel@chandra-lucid.beaverton.ibm.com>
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

Hi all,

Test case 202 tries to create a single AG filesystem and runs xfs_repair
on it expecting it to fail.

But, when I run the test with a filesystem that is bigger than 1TB it
fails (not pleasantly) since the max AG size is 1TB.

I am thinking of the following solution, please let me know if there is
any other elegant fix.

chandra
------------------------
diff --git a/202 b/202
index cbdcb57..b871d8b 100755
--- a/202
+++ b/202
@@ -42,10 +42,12 @@ _supported_os Linux
 _require_scratch
 
 echo "== Creating single-AG filesystem =="
-_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1
+_scratch_mkfs_xfs -d agcount=1 >/dev/null 2>&1 \
+ || _scratch_mkfs_xfs -d agcount=1 -d size=268435455b >/dev/null 2>&1 
+ || _fail "!!! failed to make filesystem"
 
 echo "== Trying to repair it (should fail) =="
-_scratch_xfs_repair
+_scratch_xfs_repair && _fail "!!! xfs_repair of single AG filesystem
succeeded"
 
 echo "== Trying to repair it with -o force_geometry =="
 _scratch_xfs_repair -o force_geometry 2>&1 | _filter_repair
-------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
