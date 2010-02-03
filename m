Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13Ldsf9245713 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 15:39:55 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 219FD1AA7ED
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 13:41:03 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SZLVtJwBn91yLe9m for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 13:41:03 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13Lf34U017053
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:41:03 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13Lf2HL021587
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:41:02 -0500
Message-ID: <4B69ED6D.6030902@sandeen.net>
Date: Wed, 03 Feb 2010 15:41:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfstests: rename _acl_requirements to _require_acls
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

Most requirement tests are named _require_foo, so just
make this more consistent.

Also remove a few redundant tests for /usr/bin/chacl
since _require_acls covers that.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/051 b/051
index 238abe9..12febd3 100755
--- a/051
+++ b/051
@@ -73,7 +73,6 @@ _cleanup()
 _supported_fs xfs udf
 _supported_os Linux
 
-[ -x /usr/bin/chacl ] || _notrun "chacl executable not found"
 [ -x $runas ] || _notrun "$runas executable not found"
 
 rm -f $seq.full
@@ -82,7 +81,7 @@ _setup_testdir
 
 _need_to_be_root
 _acl_setup_ids
-_acl_requirements
+_require_acls
 
 # get dir
 cd $testdir
diff --git a/053 b/053
index 439cbe6..ac2162d 100755
--- a/053
+++ b/053
@@ -42,7 +42,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_scratch
-_acl_requirements
+_require_acls
 _acl_setup_ids
 _do_die_on_error=y
 test=$SCRATCH_MNT/test
diff --git a/067 b/067
index 5ab743e..f1c211f 100755
--- a/067
+++ b/067
@@ -41,10 +41,8 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs xfs
 _supported_os Linux
 
-[ -x /usr/bin/chacl ] || _notrun "chacl executable not found"
-
 _need_to_be_root
-_acl_requirements
+_require_acls
 _require_scratch
 
 # set up fs for 1K inodes
diff --git a/077 b/077
index a3d9334..ea81c07 100755
--- a/077
+++ b/077
@@ -53,7 +53,7 @@ _supported_os Linux
 [ ! -d $filler ] && _notrun "No directory to source files from"
 
 _require_scratch
-_acl_requirements
+_require_acls
 
 echo "*** create filesystem"
 
diff --git a/099 b/099
index 90af18f..b68bfcd 100755
--- a/099
+++ b/099
@@ -81,7 +81,8 @@ _supported_fs generic
 _supported_os IRIX
 
 _acl_setup_ids
-_acl_requirements
+_require_acls
+
 [ -x $runas ] || _notrun "$runas executable not found"
 
 # get dir
diff --git a/105 b/105
index 9544c66..aba1f6d 100755
--- a/105
+++ b/105
@@ -56,7 +56,7 @@ rm -f $seq.full
 _require_scratch
 
 _acl_setup_ids
-_acl_requirements
+_require_acls
 
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
diff --git a/common.attr b/common.attr
index d12cc02..5019884 100644
--- a/common.attr
+++ b/common.attr
@@ -112,7 +112,7 @@ _filter_aces_notypes()
 
 # test if acl code will work
 #
-_acl_requirements()
+_require_acls()
 {
     xfsdir=$TEST_DIR
     

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
