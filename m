Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4LKEx1p183008 for <xfs@oss.sgi.com>; Thu, 21 May 2009 15:14:59 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A099B19FBF2B
	for <xfs@oss.sgi.com>; Thu, 21 May 2009 13:15:09 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id yisvPwNctJ596FA9 for <xfs@oss.sgi.com>;
	Thu, 21 May 2009 13:15:09 -0700 (PDT)
Message-ID: <4A15B649.70801@redhat.com>
Date: Thu, 21 May 2009 15:15:05 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: enable many tests to run on ext2/3/4
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
To: xfs mailing list <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

This gets many of the tests running on ext4 (and should on ext2/ext3
as well).

A few things could still be cleaned up; rather than -xfs, -ext3, -ext4
etc it'd be better to do --fstype xfs or whatnot, and lose as much of
the special-casing as possible.  But this gets it going, so maybe
worth merging now as a first step.

This creates a new supported_fs "generic" type which should run on
any generic filesystem (well, assuming it supports acls & xattrs, along
with general posix-ness).

It also adds a "generic" group, so you can do:

./check -ext4 -g generic

and that way it'll avoid any fs-specific tests.  They wouldn't
fail anyway, but it gets noisy to see all the "notrun" tests.

Long term there's probably a better way to do this; maybe just
skip all output when there's a fs type mismatch, not sure.
Right now fs compat info is in the test itself, so putting "generic"
into the group file might kind of be a sort of layering violation,
whaddya think?  (OTOH "udf" was there already; maybe non-generic
tests -should- have fs types in the group file and then you could do:

./check -ext4 -g generic -g ext4

or that last part could be automatic...)

There are a few more tests which could almost work for ext4
with a bit more work:

020 runs into different attribute limits I think
051 ditto but for acls
075 uses the -x preallocation call for xfs
062 gets a different recursive walk of files
164 uses xfs_io to do file mapping
192 is doing something odd I haven't sorted out yet

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


 001       |    2 +-
 002       |    2 +-
 005       |    2 +-
 006       |    2 +-
 007       |    2 +-
 010       |    2 +-
 011       |    2 +-
 013       |    2 +-
 014       |    2 +-
 069       |    4 ++--
 070       |    2 +-
 074       |    2 +-
 076       |    2 +-
 093       |    2 +-
 097       |    2 +-
 099       |    2 +-
 100       |    2 +-
 105       |    2 +-
 123       |    2 +-
 124       |    2 +-
 125       |    2 +-
 128       |    2 +-
 131       |    2 +-
 184       |    2 +-
 193       |    2 +-
 common    |   18 ++++++++++++++++++
 common.rc |   17 +++++++++++++----
 group     |   50 +++++++++++++++++++++++++-------------------------
 new       |    2 +-
 29 files changed, 83 insertions(+), 56 deletions(-)


diff --git a/001 b/001
index 2ff2c05..2dddffb 100755
--- a/001
+++ b/001
@@ -33,7 +33,7 @@ done_cleanup=false
 trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 verbose=true
diff --git a/002 b/002
index 13c6be3..c2d2b5a 100755
--- a/002
+++ b/002
@@ -30,7 +30,7 @@ _cleanup()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/005 b/005
index d21dcb5..644f63d 100755
--- a/005
+++ b/005
@@ -53,7 +53,7 @@ _touch()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 
 # IRIX UDF does not support symlinks
 if [ $FSTYP == 'udf' ]; then
diff --git a/006 b/006
index 4da277f..49b5949 100755
--- a/006
+++ b/006
@@ -40,7 +40,7 @@ _count()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/007 b/007
index 290f716..7a97d71 100755
--- a/007
+++ b/007
@@ -34,7 +34,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/010 b/010
index c51ecb2..f1bc885 100755
--- a/010
+++ b/010
@@ -42,7 +42,7 @@ _filter_dbtest()
 [ -x $here/src/dbtest ] || _notrun "dbtest was not built for this platform"
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/011 b/011
index 655229b..e1a3d7d 100755
--- a/011
+++ b/011
@@ -32,7 +32,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/013 b/013
index 1c99e8f..e417d5a 100755
--- a/013
+++ b/013
@@ -78,7 +78,7 @@ _do_test()
 
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/014 b/014
index acc3696..f5b64d0 100755
--- a/014
+++ b/014
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.rc
 . ./common.filter
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/069 b/069
index 11efd98..8da6a68 100755
--- a/069
+++ b/069
@@ -23,7 +23,7 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
@@ -32,7 +32,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 
 echo "*** mkfs"
-_scratch_mkfs >/dev/null || _fail "mkfs failed"
+_scratch_mkfs &>/dev/null || _fail "mkfs failed"
 
 echo "*** mount FS"
 _scratch_mount >/dev/null || _fail "mount failed"
diff --git a/070 b/070
index 65e158a..9302500 100755
--- a/070
+++ b/070
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/074 b/074
index d5e0364..0bd0807 100755
--- a/074
+++ b/074
@@ -97,7 +97,7 @@ _process_args()
 # real QA test starts here
 rm -f $here/$seq.full
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 #
diff --git a/076 b/076
index 975de2e..c0f6675 100755
--- a/076
+++ b/076
@@ -39,7 +39,7 @@ trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
diff --git a/093 b/093
index c1243e2..1139788 100755
--- a/093
+++ b/093
@@ -43,7 +43,7 @@ _filefilter()
 }
 
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX
 
 [ -x $runas ] || _notrun "$runas executable not found"
diff --git a/097 b/097
index b7fe1f2..9c38d18 100755
--- a/097
+++ b/097
@@ -58,7 +58,7 @@ else
 fi
 
 # real QA test starts here
-_supported_fs udf xfs
+_supported_fs generic
 _supported_os IRIX
 
 _require_scratch
diff --git a/099 b/099
index 1c5daeb..6b824dd 100755
--- a/099
+++ b/099
@@ -62,7 +62,7 @@ rm -f $seq.full
 
 #-------------------------------------------------------
 # real QA test starts here
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX
 
 _acl_setup_ids
diff --git a/100 b/100
index aa6c4ca..57e9bb6 100755
--- a/100
+++ b/100
@@ -29,7 +29,7 @@ _cleanup()
 }
  
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 # Use _populate_fs() in common.rc to create a directory structure.
diff --git a/105 b/105
index cd201dd..f154422 100755
--- a/105
+++ b/105
@@ -32,7 +32,7 @@ _cleanup()
 . ./common.attr
 
 # Modify as appropriate.
-_supported_fs xfs udf
+_supported_fs generic
 _supported_os IRIX Linux
 
 # real QA test starts here
diff --git a/123 b/123
index 63cd48f..ba7c454 100755
--- a/123
+++ b/123
@@ -57,7 +57,7 @@ _user_do()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_user
diff --git a/124 b/124
index 29af340..5adef48 100755
--- a/124
+++ b/124
@@ -33,7 +33,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/125 b/125
index ff538ef..f432034 100755
--- a/125
+++ b/125
@@ -28,7 +28,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _require_user
diff --git a/128 b/128
index 24bdac7..227d05c 100755
--- a/128
+++ b/128
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/131 b/131
index 78627f5..67adb81 100755
--- a/131
+++ b/131
@@ -28,7 +28,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _setup_testdir
diff --git a/184 b/184
index 30839cb..408e645 100755
--- a/184
+++ b/184
@@ -30,7 +30,7 @@ _cleanup()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
diff --git a/193 b/193
index 54c51a2..743c70f 100755
--- a/193
+++ b/193
@@ -50,7 +50,7 @@ _cleanup_files()
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs nfs udf
+_supported_fs generic
 _supported_os Linux
 
 _require_user
diff --git a/common b/common
index 92ec9e2..ea31375 100644
--- a/common
+++ b/common
@@ -105,6 +105,9 @@ check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
+    -ext2		test ext2
+    -ext3		test ext3
+    -ext4		test ext4
     -l			line mode diff
     -xdiff		graphical mode diff
     -udiff		show unified diff (default)
@@ -132,6 +135,21 @@ testlist options
 	    xpand=false
 	    ;;
 
+	-ext2)	# -ext2 ... set FSTYP to ext2
+	    FSTYP=ext2
+	    xpand=false
+	    ;;
+
+	-ext3)	# -ext3 ... set FSTYP to ext3
+	    FSTYP=ext3
+	    xpand=false
+	    ;;
+
+	-ext4)	# -ext4 ... set FSTYP to ext4
+	    FSTYP=ext4
+	    xpand=false
+	    ;;
+
 	-nfs)	# -nfs ... set FSTYP to nfs
 	    FSTYP=nfs
 	    xpand=false
diff --git a/common.rc b/common.rc
index 317e009..06304c8 100644
--- a/common.rc
+++ b/common.rc
@@ -49,6 +49,10 @@ _mount_opts()
     nfs)
 	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
 	;;
+    ext2|ext3|ext4)
+	# acls & xattrs aren't turned on by default on ext$FOO
+	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -546,7 +550,7 @@ _supported_fs()
 {
     for f
     do
-	if [ "$f" = "$FSTYP" ]
+	if [ "$f" = "$FSTYP" -o "$f" = "generic" ]
 	then
 	    return
 	fi
@@ -585,7 +589,7 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
-	nfs*|ext2|ext3|reiserfs)
+	nfs*|ext2|ext3|ext4|reiserfs)
 		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 		 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]
 		 then
@@ -988,6 +992,10 @@ _check_testdir()
     esac
 }
 
+_setup_generic_testdir()
+{
+    testdir=$TEST_DIR
+}
 
 _setup_xfs_testdir()
 {
@@ -1067,7 +1075,7 @@ _setup_testdir()
 	_setup_nfs_scratchdir
 	;;
     *)
-	_fail "\$FSTYP is not xfs, udf or nfs"
+	_setup_generic_testdir
 	;;
     esac
 }
@@ -1088,7 +1096,8 @@ _cleanup_testdir()
 	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
 	;;
     *)
-	_fail "\$FSTYP is not xfs, udf or nfs"
+	# do nothing, testdir is $TEST_DIR
+	:
 	;;
     esac
 }
diff --git a/group b/group
index 0ac33c2..6ce06b5 100644
--- a/group
+++ b/group
@@ -103,20 +103,20 @@ atime
 
 # test-group association ... one line per test
 #
-001 rw dir udf auto quick
-002 metadata udf auto quick
+001 generic rw dir auto quick
+002 generic metadata auto quick
 003 db auto quick
 004 db auto quick
-005 dir udf auto quick
-006 dir udf auto quick
-007 dir udf auto quick
+005 generic dir auto quick
+006 generic dir auto quick
+007 generic dir auto quick
 008 rw ioctl auto quick
 009 rw ioctl auto quick
-010 other udf auto
-011 dir udf auto quick
+010 generic other auto
+011 generic dir auto quick
 012 rw auto quick
-013 other ioctl udf auto quick
-014 rw udf auto quick
+013 generic other ioctl auto quick
+014 generic rw auto quick
 015 other auto quick
 016 rw auto quick
 017 mount auto quick
@@ -171,14 +171,14 @@ atime
 066 dump ioctl auto quick
 067 acl attr auto quick
 068 other auto
-069 rw udf auto quick
-070 attr udf auto quick
+069 generic rw auto quick
+070 generic attr auto quick
 071 rw
 072 rw auto quick
 073 copy auto
-074 rw udf auto
+074 generic rw auto
 075 rw udf auto quick
-076 metadata rw udf auto quick
+076 generic metadata rw auto quick
 077 acl attr auto
 078 growfs auto quick
 079 acl attr ioctl metadata auto quick
@@ -195,19 +195,19 @@ atime
 090 rw auto
 091 rw auto quick
 092 other auto quick
-093 attr cap udf auto
+093 generic attr cap auto
 094 metadata dir ioctl auto
 095 log v2log auto
 096 mkfs v2log auto quick
-097 udf auto
+097 generic auto
 098 udf auto
-099 udf auto
-100 udf auto
+099 generic auto
+100 generic auto
 101 udf
 102 udf
 103 metadata dir ioctl auto quick
 104 growfs ioctl
-105 acl auto quick
+105 generic acl auto quick
 106 quota
 107 quota
 108 quota
@@ -225,15 +225,15 @@ atime
 120 other auto quick
 121 log auto quick
 122 other auto quick
-123 perms auto quick
-124 pattern auto quick
-125 other auto
+123 generic perms auto quick
+124 generic pattern auto quick
+125 generic other auto
 126 perms auto quick
 127 rw auto
-128 perms auto quick
+128 generic perms auto quick
 129 rw auto quick
 130 pattern auto quick
-131 perms auto quick
+131 generic perms auto quick
 132 pattern auto
 133 rw auto
 134 quota auto quick
@@ -289,7 +289,7 @@ atime
 181 log auto quick
 182 metadata rw auto
 183 rw other auto quick
-184 metadata auto quick
+184 generic metadata auto quick
 185 dmapi auto
 186 attr auto quick
 187 attr auto quick
@@ -298,7 +298,7 @@ atime
 190 rw auto quick
 191 nfs4acl auto
 192 atime
-193 metadata auto quick
+193 generic metadata auto quick
 194 rw auto
 195 ioctl dump auto quick
 196 quota auto quick
diff --git a/new b/new
index c924ffe..ac61221 100755
--- a/new
+++ b/new
@@ -99,7 +99,7 @@ _cleanup()
 # real QA test starts here
 
 # Modify as appropriate.
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 # if error

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
