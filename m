Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3NITJ6o019226 for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 13:29:19 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 760811CE1B76
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 11:29:15 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id IJkrbncdQu0nPDIS for <xfs@oss.sgi.com>;
	Thu, 23 Apr 2009 11:29:15 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n3NITFDf021562
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 14:29:15 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3NITEc4009376
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 14:29:14 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n3NITDi6015000
	for <xfs@oss.sgi.com>; Thu, 23 Apr 2009 14:29:13 -0400
Message-ID: <49F0B379.2060309@sandeen.net>
Date: Thu, 23 Apr 2009 13:29:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix 130, 132 for inifinitely-fast disks
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
To: xfs mailing list <xfs@oss.sgi.com>

Due to the new quantum/holographic storage I'm testing, my 
disks go infinitely fast, thereby breaking some filters:

-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+3 KiB, 1 ops; 0.0000 sec (inf EiB/sec and inf ops/sec)

I'm no regexp expert but I think the below change will fix it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/130 b/130
index f287d20..b0bbe73 100755
--- a/130
+++ b/130
@@ -51,7 +51,7 @@ common_line_filter()
 
 _filter_xfs_io()
 {
-    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([0-9/.]* [GMKiBbytes]*\/sec and [0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
+    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([inf0-9/.]* [EPGMKiBbytes]*\/sec and [inf0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
 }
 
 # real QA test starts here
diff --git a/132 b/132
index df3d3d3..f373256 100755
--- a/132
+++ b/132
@@ -43,7 +43,7 @@ common_line_filter()
 
 _filter_xfs_io()
 {
-    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([0-9/.]* [GMKiBbytes]*\/sec and [0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
+    common_line_filter | sed -e "s/[0-9/.]* [GMKiBbytes]*, [0-9]* ops\; [0-9/:. sec]* ([inf0-9/.]* [EPGMKiBbytes]*\/sec and [inf0-9/.]* ops\/sec)/XXX Bytes, X ops\; XX:XX:XX.X (XXX YYY\/sec and XXX ops\/sec)/"
 }
 
 # real QA test starts here

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
