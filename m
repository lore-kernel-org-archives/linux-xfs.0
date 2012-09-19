Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JMqkDU258801 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 17:52:46 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wDVtX2UW49MMTcEL for
	<xfs@oss.sgi.com>; Wed, 19 Sep 2012 15:53:58 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8JMrvGH031098
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 18:53:57 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id q8JMrurE003393
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 18:53:57 -0400
Message-ID: <505A4D04.2080105@redhat.com>
Date: Wed, 19 Sep 2012 17:53:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add _require_freeze and minor cleanups
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

More filesystems have grown freeze capability, so rather than
hardcoding several in _supported_fs, make tests 068 and 280
generic and then add a new _require_freeze() which checks whether
the fs under test can be frozen before beginning the test.

Minor other cleanups to 280:
- remove extra _supported_fs line
- clear $seq.full before beginning

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/068 b/068
index b595d1d..617420c 100755
--- a/068
+++ b/068
@@ -51,10 +51,11 @@ trap "_cleanup" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs btrfs ext3 ext4 xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_scratch
+_require_freeze
 
 echo "*** init FS"
 
diff --git a/280 b/280
index 55849ed..5e26173 100755
--- a/280
+++ b/280
@@ -45,13 +45,15 @@ _cleanup()
 
 _require_scratch
 _require_quota
+_require_freeze
 
 # real QA test starts here
 
 # Modify as appropriate.
-_supported_fs generic
 _supported_os Linux
-_supported_fs ext3 ext4 xfs
+_supported_fs generic
+
+rm -f $seq.full
 
 umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs >> $seq.full 2>&1
diff --git a/common.rc b/common.rc
index 602513a..0e8a306 100644
--- a/common.rc
+++ b/common.rc
@@ -1758,6 +1758,15 @@ _require_btrfs()
 	[ $? -eq 0 ] || _notrun "$BTRFS_UTIL_PROG too old (must support $cmd)"
 }
 
+# Does freeze work on this fs?
+_require_freeze()
+{
+	xfs_freeze -f "$TEST_DIR" >/dev/null 2>&1
+	result=$? 
+	xfs_freeze -u "$TEST_DIR" >/dev/null 2>&1
+	[ $result -eq 0 ] || _notrun "$FSTYP does not support freezing"
+}
+
 # arg 1 is dev to remove and is output of the below eg.
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
