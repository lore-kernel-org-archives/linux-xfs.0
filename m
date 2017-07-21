Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:37266 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdGUEkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:10 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 02/15] tests: port generic/097 to Linux
Date: Thu, 20 Jul 2017 21:38:40 -0700
Message-Id: <20170721043853.364-3-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

This IRIX-specific test did some basic testing of extended attributes.
Port it to Linux; this mainly involved updating it to use the 'getfattr'
and 'setfattr' programs instead 'attr'.  Note that although 'attr' is
available on Linux, it's mainly for IRIX compatibility, the man page
recommends against using it on non-XFS filesystems, and it doesn't
support listing user xattrs only.  (In the last point it actually
differs from IRIX 'attr', but probably no one cares anymore.)  getfattr
also sorts its output by xattr name, so its output will be the same on
all filesystems unlike 'attr -l'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .gitignore                |   1 -
 tests/generic/097         | 253 ++++++++++++++++++++--------------------------
 tests/generic/097.out     | 177 ++++++++++++++++++++++++++++++++
 tests/generic/097.out.udf | 132 ------------------------
 tests/generic/097.out.xfs | 132 ------------------------
 tests/generic/group       |   2 +-
 6 files changed, 287 insertions(+), 410 deletions(-)
 create mode 100644 tests/generic/097.out
 delete mode 100644 tests/generic/097.out.udf
 delete mode 100644 tests/generic/097.out.xfs

diff --git a/.gitignore b/.gitignore
index 1e994889..c0736486 100644
--- a/.gitignore
+++ b/.gitignore
@@ -235,7 +235,6 @@
 
 # Symlinked files
 /tests/generic/088.out
-/tests/generic/097.out
 /tests/xfs/018.op
 /tests/xfs/022.out
 /tests/xfs/023.out
diff --git a/tests/generic/097 b/tests/generic/097
index 637c73b7..13abe9e3 100755
--- a/tests/generic/097
+++ b/tests/generic/097
@@ -10,6 +10,7 @@
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -27,7 +28,6 @@
 #-----------------------------------------------------------------------
 #
 
-seqfull=$0
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
 echo "QA output created by $seq"
@@ -35,215 +35,180 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-TARGET_DIR=
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
+file=$TEST_DIR/foo
+
 _cleanup()
 {
-    rm -f $tmp.*
-    cd $TARGET_DIR
-    rm -f foo
+	rm -f $tmp.* $file
+}
+
+getfattr()
+{
+	$GETFATTR_PROG --absolute-names "$@" |& _filter_test_dir
 }
 
-_umount_and_mount()
+setfattr()
 {
-    cd /
-    umount $TARGET_DIR
-    if [ "$FSTYP" == "xfs" ]; then
-	_test_mount
-    else
-	_scratch_mount
-    fi
-    
-    cd $TARGET_DIR
+	$SETFATTR_PROG "$@" |& _filter_test_dir
 }
 
 # get standard environment, filters and checks
 . ./common/rc
+. ./common/attr
 . ./common/filter
 
-# link correct .out file
-# This is done bacause udf and xfs print attrs in different orders.
-rm -rf $seqfull.out
-if [ "$FSTYP" == "xfs" ]; then
-    ln -s $seq.out.xfs $seqfull.out
-else
-    ln -s $seq.out.udf $seqfull.out
-fi
-
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX
+_supported_os Linux
 
 _require_test
-_require_scratch
 _require_attrs
 
-TARGET_DIR=$SCRATCH_MNT
-[ "$FSTYP" == "xfs" ] && TARGET_DIR=$TEST_DIR
-cd $TARGET_DIR
-
-echo "create file foo"
-rm -f foo 
-touch foo
-
-echo "should be no EAs for foo:"
-${ATTR_PROG} -l foo
-
-echo "set EA <noise,woof>:"
-${ATTR_PROG} -s noise -V woof foo
-
-echo "set EA <colour,blue>:"
-${ATTR_PROG} -s colour -V blue foo
-
-echo "set EA <size,small>:"
-${ATTR_PROG} -s size -V small foo
-
-echo "list the EAs for foo: noise, colour, size" 
-${ATTR_PROG} -l foo
+echo -e "\ncreate file foo"
+rm -f $file
+touch $file
 
-echo "check the list again for foo"
-${ATTR_PROG} -l foo
+echo -e "\nshould be no EAs for foo:"
+getfattr -d $file
 
-echo "unmount the FS and see if EAs are persistent"
-_umount_and_mount
+echo -e "\nset EA <noise,woof>:"
+setfattr -n user.noise -v woof $file
 
-echo "check the list again for foo after umount/mount"
-${ATTR_PROG} -l foo
+echo -e "\nset EA <colour,blue>:"
+setfattr -n user.colour -v blue $file
 
-echo "get the value of the noise EA"
-${ATTR_PROG} -g noise foo
+echo -e "\nset EA <size,small>:"
+setfattr -n user.size -v small $file
 
-echo "get the value of the colour EA which was removed earlier"
-${ATTR_PROG} -g colour foo
+echo -e "\nlist the EAs for foo: noise, colour, size"
+getfattr -d $file
 
-echo "get the value of the size EA"
-${ATTR_PROG} -g size foo
+echo -e "\ncheck the list again for foo"
+getfattr -d $file
 
-echo "remove the colour EA on foo"
-${ATTR_PROG} -r colour foo
+echo -e "\nunmount the FS and see if EAs are persistent"
+_test_cycle_mount
 
-echo "list EAs for foo: noise, size"
-${ATTR_PROG} -l foo
+echo -e "\ncheck the list again for foo after umount/mount"
+getfattr -d $file
 
-echo "get the value of the noise EA"
-${ATTR_PROG} -g noise foo
+echo -e "\nremove the colour EA on foo"
+setfattr -x user.colour $file
 
-echo "get the value of the colour EA which was removed earlier"
-${ATTR_PROG} -g colour foo
+echo -e "\nlist EAs for foo: noise, size"
+getfattr -d $file
 
-echo "get the value of the size EA"
-${ATTR_PROG} -g size foo
+echo -e "\nget the value of the noise EA"
+getfattr -n user.noise $file
 
-echo "list all the EAs again: noise, size"
-${ATTR_PROG} -l foo
+echo -e "\nget the value of the colour EA which was removed earlier"
+getfattr -n user.colour $file
 
-echo "change the value of the size EA from small to huge"
-${ATTR_PROG} -s size -V huge foo
+echo -e "\nget the value of the size EA"
+getfattr -n user.size $file
 
-echo "get the size EA which should now have value huge"
-${ATTR_PROG} -g size foo
+echo -e "\nlist all the EAs again: noise, size"
+getfattr -d $file
 
-echo "list EAs: noise, size"
-${ATTR_PROG} -l foo
+echo -e "\nchange the value of the size EA from small to huge"
+setfattr -n user.size -v huge $file
 
-echo "remove the size EA from foo"
-${ATTR_PROG} -r size foo
+echo -e "\nget the size EA which should now have value huge"
+getfattr -n user.size $file
 
-echo "list EAs: noise (size EA has been removed)"
-${ATTR_PROG} -l foo
+echo -e "\nlist EAs: noise, size"
+getfattr -d $file
 
-echo "get the noise EA: woof"
-${ATTR_PROG} -g noise foo
+echo -e "\nremove the size EA from foo"
+setfattr -x user.size $file
 
-echo "try removing non-existent EA named woof"
-${ATTR_PROG} -r woof foo
+echo -e "\nlist EAs: noise (size EA has been removed)"
+getfattr -d $file
 
-echo "try removing already removed EA size"
-${ATTR_PROG} -r size foo
+echo -e "\ntry removing non-existent EA named woof"
+setfattr -x user.woof $file
 
-echo "list EAs: noise"
-${ATTR_PROG} -l foo
+echo -e "\ntry removing already removed EA size"
+setfattr -x user.size $file
 
-echo "try removing already removed EA colour"
-${ATTR_PROG} -r colour foo
+echo -e "\nlist EAs: noise"
+getfattr -d $file
 
-echo "list EAs: noise"
-${ATTR_PROG} -l foo
+echo -e "\ntry removing already removed EA colour"
+setfattr -x user.colour $file
 
-echo "remove remaining EA noise"
-${ATTR_PROG} -r noise foo
+echo -e "\nlist EAs: noise"
+getfattr -d $file
 
-echo "list EAs: should be no EAs left now"
-${ATTR_PROG} -l foo
+echo -e "\nremove remaining EA noise"
+setfattr -x user.noise $file
 
-echo "unmount the FS and see if EAs are persistent"
-_umount_and_mount
+echo -e "\nlist EAs: should be no EAs left now"
+getfattr -d $file
 
-echo "list EAs: should still be no EAs left"
-${ATTR_PROG} -l foo
+echo -e "\nunmount the FS and see if EAs are persistent"
+_test_cycle_mount
 
-echo ""
-echo "*** Test out the root namespace ***"
-echo ""
+echo -e "\nlist EAs: should still be no EAs left"
+getfattr -d $file
 
-echo "set EA <root:colour,marone>:"
-${ATTR_PROG} -R -s colour -V marone foo
+echo -e "\n*** Test out the trusted namespace ***"
 
-echo "set EA <user:colour,beige>:"
-${ATTR_PROG} -s colour -V beige foo
+echo -e "\nset EA <trusted:colour,marone>:"
+setfattr -n trusted.colour -v marone $file
 
-echo "set EA <user:vomit,pizza>:"
-${ATTR_PROG} -s vomit -V pizza foo
+echo -e "\nset EA <user:colour,beige>:"
+setfattr -n user.colour -v beige $file
 
-echo "set EA <root:noise,whack>:"
-${ATTR_PROG} -R -s noise -V whack foo
+echo -e "\nset EA <user:vomit,pizza>:"
+setfattr -n user.vomit -v pizza $file
 
-echo "list root EAs: <root:colour,noise>:"
-${ATTR_PROG} -R -l foo
+echo -e "\nset EA <trusted:noise,whack>:"
+setfattr -n trusted.noise -v whack $file
 
-echo "list user EAs: <user:colour,vomit>:"
-${ATTR_PROG} -l foo
+echo -e "\nlist trusted EAs: <trusted:colour,noise>:"
+getfattr -d -m '^trusted\.' $file
 
-echo "get root EA colour: marone"
-${ATTR_PROG} -R -g colour foo
+echo -e "\nlist user EAs: <user:colour,vomit>:"
+getfattr -d $file
 
-echo "get root EA noise: whack"
-${ATTR_PROG} -R -g noise foo
+echo -e "\nget trusted EA colour: marone"
+getfattr -n trusted.colour $file
 
-echo "get root EA vomit which is a user EA => find nothing"
-${ATTR_PROG} -R -g vomit foo
+echo -e "\nget trusted EA noise: whack"
+getfattr -n trusted.noise $file
 
-echo ""
-echo "unmount the FS and see if EAs are persistent"
-echo ""
-_umount_and_mount
+echo -e "\nget trusted EA vomit which is a user EA => find nothing"
+getfattr -n trusted.vomit $file
 
-echo "get root EA colour: marone"
-${ATTR_PROG} -R -g colour foo
+echo -e "\nunmount the FS and see if EAs are persistent"
+_test_cycle_mount
 
-echo "get root EA noise: whack"
-${ATTR_PROG} -R -g noise foo
+echo -e "\nget trusted EA colour: marone"
+getfattr -n trusted.colour $file
 
-echo "get user EA vomit: pizza" 
-${ATTR_PROG} -g vomit foo
+echo -e "\nget trusted EA noise: whack"
+getfattr -n trusted.noise $file
 
-echo "remove the root colour EA"
-${ATTR_PROG} -R -r colour foo
+echo -e "\nget user EA vomit: pizza"
+getfattr -n user.vomit $file
 
-echo "list root EAs: <root:noise>:"
-${ATTR_PROG} -R -l foo
+echo -e "\nremove the trusted colour EA"
+setfattr -x trusted.colour $file
 
-echo "list user EAs: <user:colour,vomit>:"
-${ATTR_PROG} -l foo
+echo -e "\nlist trusted EAs: <trusted:noise>:"
+getfattr -d -m '^trusted\.' $file
 
-echo "remove the final root EA noise"
-${ATTR_PROG} -R -r noise foo
+echo -e "\nlist user EAs: <user:colour,vomit>:"
+getfattr -d $file
 
-echo "list root EAs: none"
-${ATTR_PROG} -R -l foo
+echo -e "\nremove the final trusted EA noise"
+setfattr -x trusted.noise $file
 
-cd /
+echo -e "\nlist trusted EAs: none"
+getfattr -d -m '^trusted\.' $file
 
 # success, all done
 status=0
diff --git a/tests/generic/097.out b/tests/generic/097.out
new file mode 100644
index 00000000..948d57b6
--- /dev/null
+++ b/tests/generic/097.out
@@ -0,0 +1,177 @@
+QA output created by 097
+
+create file foo
+
+should be no EAs for foo:
+
+set EA <noise,woof>:
+
+set EA <colour,blue>:
+
+set EA <size,small>:
+
+list the EAs for foo: noise, colour, size
+# file: TEST_DIR/foo
+user.colour="blue"
+user.noise="woof"
+user.size="small"
+
+
+check the list again for foo
+# file: TEST_DIR/foo
+user.colour="blue"
+user.noise="woof"
+user.size="small"
+
+
+unmount the FS and see if EAs are persistent
+
+check the list again for foo after umount/mount
+# file: TEST_DIR/foo
+user.colour="blue"
+user.noise="woof"
+user.size="small"
+
+
+remove the colour EA on foo
+
+list EAs for foo: noise, size
+# file: TEST_DIR/foo
+user.noise="woof"
+user.size="small"
+
+
+get the value of the noise EA
+# file: TEST_DIR/foo
+user.noise="woof"
+
+
+get the value of the colour EA which was removed earlier
+TEST_DIR/foo: user.colour: No such attribute
+
+get the value of the size EA
+# file: TEST_DIR/foo
+user.size="small"
+
+
+list all the EAs again: noise, size
+# file: TEST_DIR/foo
+user.noise="woof"
+user.size="small"
+
+
+change the value of the size EA from small to huge
+
+get the size EA which should now have value huge
+# file: TEST_DIR/foo
+user.size="huge"
+
+
+list EAs: noise, size
+# file: TEST_DIR/foo
+user.noise="woof"
+user.size="huge"
+
+
+remove the size EA from foo
+
+list EAs: noise (size EA has been removed)
+# file: TEST_DIR/foo
+user.noise="woof"
+
+
+try removing non-existent EA named woof
+setfattr: TEST_DIR/foo: No such attribute
+
+try removing already removed EA size
+setfattr: TEST_DIR/foo: No such attribute
+
+list EAs: noise
+# file: TEST_DIR/foo
+user.noise="woof"
+
+
+try removing already removed EA colour
+setfattr: TEST_DIR/foo: No such attribute
+
+list EAs: noise
+# file: TEST_DIR/foo
+user.noise="woof"
+
+
+remove remaining EA noise
+
+list EAs: should be no EAs left now
+
+unmount the FS and see if EAs are persistent
+
+list EAs: should still be no EAs left
+
+*** Test out the trusted namespace ***
+
+set EA <trusted:colour,marone>:
+
+set EA <user:colour,beige>:
+
+set EA <user:vomit,pizza>:
+
+set EA <trusted:noise,whack>:
+
+list trusted EAs: <trusted:colour,noise>:
+# file: TEST_DIR/foo
+trusted.colour="marone"
+trusted.noise="whack"
+
+
+list user EAs: <user:colour,vomit>:
+# file: TEST_DIR/foo
+user.colour="beige"
+user.vomit="pizza"
+
+
+get trusted EA colour: marone
+# file: TEST_DIR/foo
+trusted.colour="marone"
+
+
+get trusted EA noise: whack
+# file: TEST_DIR/foo
+trusted.noise="whack"
+
+
+get trusted EA vomit which is a user EA => find nothing
+TEST_DIR/foo: trusted.vomit: No such attribute
+
+unmount the FS and see if EAs are persistent
+
+get trusted EA colour: marone
+# file: TEST_DIR/foo
+trusted.colour="marone"
+
+
+get trusted EA noise: whack
+# file: TEST_DIR/foo
+trusted.noise="whack"
+
+
+get user EA vomit: pizza
+# file: TEST_DIR/foo
+user.vomit="pizza"
+
+
+remove the trusted colour EA
+
+list trusted EAs: <trusted:noise>:
+# file: TEST_DIR/foo
+trusted.noise="whack"
+
+
+list user EAs: <user:colour,vomit>:
+# file: TEST_DIR/foo
+user.colour="beige"
+user.vomit="pizza"
+
+
+remove the final trusted EA noise
+
+list trusted EAs: none
diff --git a/tests/generic/097.out.udf b/tests/generic/097.out.udf
deleted file mode 100644
index 1d36ff76..00000000
diff --git a/tests/generic/097.out.xfs b/tests/generic/097.out.xfs
deleted file mode 100644
index 0024bf23..00000000
diff --git a/tests/generic/group b/tests/generic/group
index d93aa06d..20c278cc 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -99,7 +99,7 @@
 094 auto quick prealloc
 095 auto rw stress
 096 auto prealloc quick zero
-097 udf auto
+097 attr auto quick
 098 auto quick metadata
 099 udf auto
 100 udf auto
-- 
2.13.3

