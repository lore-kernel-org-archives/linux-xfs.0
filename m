Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mALM6Mi4013175 for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 16:06:22 -0600
Received: from zero.voxel.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C08EA15C07D9
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 14:06:20 -0800 (PST)
Received: from zero.voxel.net (zero.voxel.net [69.9.191.6]) by cuda.sgi.com
	with ESMTP id cF0W3Mq2SzVtLHiu for <xfs@oss.sgi.com>;
	Fri, 21 Nov 2008 14:06:20 -0800 (PST)
Received: from mail.magoazul.com (localhost [127.0.0.1])
	by zero.voxel.net (Postfix) with ESMTP id 911EA1BB0056
	for <xfs@oss.sgi.com>; Fri, 21 Nov 2008 16:45:23 -0500 (EST)
Message-ID: <a2da1d27af9a31cc891cfeeafc27abf4.squirrel@mail.voxel.net>
Date: Fri, 21 Nov 2008 13:45:23 -0800 (PST)
Subject: couple small xfstest patches
From: "Matthew Kent" <mkent@magoazul.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20081121134523_90109"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

------=_20081121134523_90109
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

* 189 fails with external devices
* add a unified diff output option, find it easier on the eyes ;)

Thanks!
-- 
Matthew Kent <mkent@magoazul.com>
http://magoazul.com
------=_20081121134523_90109
Content-Type: text/x-diff; name="xfstest-unified_diff.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="xfstest-unified_diff.patch"

--- xfs-cmds/xfstests/common.orig	2008-11-21 13:19:47.000000000 -0800
+++ xfs-cmds/xfstests/common	2008-11-21 13:22:04.000000000 -0800
@@ -107,7 +107,7 @@
     -nfs                test NFS
     -l			line mode diff (default)
     -xdiff		graphical mode diff
-    -diffu		show unified diff
+    -udiff		show unified diff
     -n			show me, do not run tests
     -q			quick [deprecated]
     -T			output timestamps
@@ -158,7 +158,7 @@
 	    fi
 	    ;;
 
-	-diffu)	# show unified diff
+	-udiff)	# show a unified diff
 	    xpand=false
 	    diff="$diff -u"
 	    ;;
------=_20081121134523_90109
Content-Type: text/x-diff; name="xfstest-189_fixexternal.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="xfstest-189_fixexternal.patch"

--- xfs-cmds/xfstests/189.orig	2008-11-21 13:43:33.000000000 -0800
+++ xfs-cmds/xfstests/189	2008-11-21 13:42:48.000000000 -0800
@@ -188,8 +188,8 @@
 _need_to_be_root
 _require_scratch
 
-unset SCRATCH_OPTIONS
-unset MOUNT_OPTIONS
+unset SCRATCH_RTDEV
+unset SCRATCH_LOGDEV
 
 _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
 
------=_20081121134523_90109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_20081121134523_90109--
