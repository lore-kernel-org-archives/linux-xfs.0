Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59I5PSU051264 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 13:05:25 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F8272E24ED
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 11:05:45 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id uaOKgYxtx5BxATV5 for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2009 11:05:45 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n59I5jt2027695
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 14:05:45 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n59I5ihJ032246
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 14:05:44 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n59I5hu7016818
	for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 14:05:43 -0400
Message-ID: <4A2EA474.7070401@sandeen.net>
Date: Tue, 09 Jun 2009 13:05:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: enable still more tests for generic filesystems
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

Make the following tests _supported_fs generic:

088 - test out CAP_DAC_OVERRIDE and CAP_DAC_SEARCH code
089 - Emulate the way Linux mount manipulates /etc/mtab
113 - aio-stress (explicitly mark as generic)
126 - tests various file permission options
129 - looptests

These all pass on ext3, ext4, btrfs, and gfs2 as well
as xfs.

Also remove "generic" group from "groups," which was 
accidentally added.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/088 b/088
index 81af19f..3ebda66 100755
--- a/088
+++ b/088
@@ -47,7 +47,7 @@ _filter()
 _link_out_file $seq.out
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 path=$TEST_DIR/t_access
diff --git a/089 b/089
index bd812e9..3fce2f8 100755
--- a/089
+++ b/089
@@ -49,7 +49,7 @@ addentries()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 rm -f $seq.full
diff --git a/113 b/113
index 261873b..f05275d 100755
--- a/113
+++ b/113
@@ -77,6 +77,7 @@ _do_test()
 
 
 # real QA test starts here
+_supported_fs generic
 _supported_os Linux
 
 [ -x $here/ltp/aio-stress ] || _notrun "aio-stress not built for this platform"
diff --git a/126 b/126
index 3550533..7bb10de 100755
--- a/126
+++ b/126
@@ -42,7 +42,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/129 b/129
index 02d14b9..66b4cb9 100755
--- a/129
+++ b/129
@@ -49,7 +49,7 @@ echo_and_run()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/group b/group
index b72fe7b..1268ddd 100644
--- a/group
+++ b/group
@@ -311,9 +311,9 @@ atime
 204 metadata rw auto
 205 metadata rw auto
 206 growfs auto quick
-207 generic auto aio quick
-208 generic auto aio
-209 generic auto aio
-210 generic auto aio quick
-211 generic auto aio quick
-212 generic auto aio quick
+207 auto aio quick
+208 auto aio
+209 auto aio
+210 auto aio quick
+211 auto aio quick
+212 auto aio quick


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
