Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13LbUe2245631 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 15:37:30 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 501611C9EDF7
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 13:38:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6WfDqYw4KPDcG5jr for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 13:38:39 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13LcdwD000617
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:38:39 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13LcbY8020879
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:38:38 -0500
Message-ID: <4B69ECDD.8050806@sandeen.net>
Date: Wed, 03 Feb 2010 15:38:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfstests: make 053 and 077 generic
References: <4B69EC23.8040207@sandeen.net>
In-Reply-To: <4B69EC23.8040207@sandeen.net>
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

053 and 077 can be generic w/ a little tweaking.

Also change 077's filler to something more likely
to be on a random system under test, and add it
to the enospc group.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/053 b/053
index 98644a7..439cbe6 100755
--- a/053
+++ b/053
@@ -38,18 +38,17 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.attr
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
-[ ! -x /bin/chacl -a ! -x /usr/bin/chacl ] && _notrun "chacl command not found"
-
 _require_scratch
+_acl_requirements
 _acl_setup_ids
 _do_die_on_error=y
 test=$SCRATCH_MNT/test
 
 # make filesystem on scratch using the defaults
-_do 'make filesystem on $SCRATCH_DEV' '_scratch_mkfs_xfs'
+_do 'make filesystem on $SCRATCH_DEV' '_scratch_mkfs'
 _do 'mount filesytem' '_scratch_mount'
 
 # create test files and set acls
@@ -84,7 +83,7 @@ list_acls()
 echo "acls before repair:"
 list_acls
 _do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
-_do 'repair filesystem' '_scratch_xfs_repair'
+_do 'repair filesystem' '_check_scratch_fs'
 _do 'mount filesytem' '_scratch_mount'
 echo "acls after repair: "
 list_acls
diff --git a/077 b/077
index cdee8da..a3d9334 100755
--- a/077
+++ b/077
@@ -30,8 +30,8 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1
-#filler=$here/../../linux
-filler=/home/fsgqa/isms/2.4.x-xfs
+# Something w/ enough data to fill 50M of fs...
+filler=/lib/modules/
 
 _cleanup()
 {
@@ -44,14 +44,16 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common.rc
 . ./common.filter
+. ./common.attr
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux
 
-[ ! -d $filler ] && _notrun "No linux directory to source files from"
+[ ! -d $filler ] && _notrun "No directory to source files from"
 
 _require_scratch
+_acl_requirements
 
 echo "*** create filesystem"
 
@@ -59,7 +61,8 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-_scratch_mkfs_xfs -dsize=50m                >>$seq.full 2>&1 \
+let SIZE=50*1024*1024
+_scratch_mkfs_sized $SIZE                   >>$seq.full 2>&1 \
 	|| _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
 	|| _fail "mount failed"
diff --git a/group b/group
index 6b8528f..c66d965 100644
--- a/group
+++ b/group
@@ -187,7 +187,7 @@ deprecated
 074 rw udf auto
 075 rw udf auto quick
 076 metadata rw udf auto quick
-077 acl attr auto
+077 acl attr auto enospc
 078 growfs auto quick
 079 acl attr ioctl metadata auto quick
 080 rw ioctl

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
