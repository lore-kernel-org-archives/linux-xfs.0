Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37947 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdGUEkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:08 -0400
From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH v2 01/15] tests: port generic/093 to Linux
Date: Thu, 20 Jul 2017 21:38:39 -0700
Message-Id: <20170721043853.364-2-ebiggers3@gmail.com>
In-Reply-To: <20170721043853.364-1-ebiggers3@gmail.com>
References: <20170721043853.364-1-ebiggers3@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>

From: Eric Biggers <ebiggers@google.com>

This IRIX-specific test mainly tested whether a file's capabilities are
cleared when it is written to.  Port the test to the Linux libcap tools
and update it to expect the Linux semantics which are a little simpler:
capabilities are always cleared even if the program is root (or has
CAP_FSETID).  The test also tests that chmod doesn't affect open file
descriptors; this is mostly unrelated, but keep it in for now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/writemod.c        |   4 +-
 tests/generic/093     | 113 ++++++++++----------------------------------------
 tests/generic/093.out | Bin 917 -> 372 bytes
 tests/generic/group   |   2 +-
 4 files changed, 26 insertions(+), 93 deletions(-)

diff --git a/src/writemod.c b/src/writemod.c
index 0c9ff1a5..16b3fa0c 100644
--- a/src/writemod.c
+++ b/src/writemod.c
@@ -35,7 +35,7 @@ main(int argc, char* argv[])
 {
     char *path;
     int fd;
-    char *buf = "hi there";
+    char *buf = "hi there\n";
     ssize_t x;
     int sts;
 
@@ -59,7 +59,7 @@ main(int argc, char* argv[])
         return 1;
     }
     printf("write to the file\n");
-    x = write(fd, buf, strlen(buf)+1); 
+    x = write(fd, buf, strlen(buf));
     if (x == -1) {
 	perror("write");
         return 1;
diff --git a/tests/generic/093 b/tests/generic/093
index 824e9b27..807d886f 100755
--- a/tests/generic/093
+++ b/tests/generic/093
@@ -1,13 +1,11 @@
 #! /bin/bash
 # FS QA Test No. 093
 #
-# Test out for IRIX the removal of file capabilities when
-# writing to the file (when it doesn't have CAP_FSETID & CAP_SETFCAP)
-# i.e. not root.
-# Test out fix for pv#901019
+# Test clearing of capabilities on write.
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -43,23 +41,18 @@ _cleanup()
     [ -n "$TEST_DIR" ] && rm -f $file
 }
 
-_testfilter()
+filefilter()
 {
-    sed -e "s#$TEST_DIR#TESTDIR#g"
-}
-
-_filefilter()
-{
-    sed -e "s#$tmp##" -e "s#$file#file#"
+    sed -e "s#$file#file#"
 }
 
 # real QA test starts here
 _supported_fs generic
-_supported_os IRIX
+_supported_os Linux
 
 _require_test
 _require_attrs
-_require_runas
+_require_user
 
 rm -f $seqres.full
 
@@ -67,91 +60,31 @@ echo "QA output created by $seq"
 echo ""
 file=$TEST_DIR/$seq.file
 
-user=`grep ':all=:all=' /etc/capability | tail -1 | $AWK_PROG -F: '{print $1}'`
-uid=`_cat_passwd | grep $user | $AWK_PROG -F: '{print $3}'`
-
-cat >$tmp.append <<EOF
-#!/bin/bash
-echo data >>$file
-EOF
-chmod ugo+x $tmp.append
-
-echo "touch file"
+rm -f $file
 touch $file
-chmod ugo+w $file 
-
-echo "chcap on file"
-chcap CAP_CHOWN+p $file
-
-echo "ls -P on file"
-ls -P $file | _testfilter
-
-echo "append to file as root"
-$tmp.append
-
-echo "ls -P on file"
-ls -P $file | _testfilter
-
-echo "cat file"
-echo "----"
-cat $file
-echo "----"
-
-echo "append to file as user without caps"
-# in particular user doesn't have FSETID or SETFCAP
-_runas -u $uid $tmp.append
 
-echo "cat file"
-echo "----"
+echo "**** Verifying that appending to file clears capabilities ****"
+setcap cap_chown+ep $file
+getcap $file | filefilter
+echo data1 >> $file
 cat $file
-echo "----"
+getcap $file | filefilter
+echo
 
-echo "ls -P on file"
-ls -P $file | _testfilter
-
-# try again when it doesn't have the EA
-echo "append to file as user without caps a 2nd time"
-_runas -u $uid $tmp.append
-
-echo "ls -P on file"
-ls -P $file | _testfilter
-
-echo "cat file"
-echo "----"
+echo "**** Verifying that appending to file doesn't clear other xattrs ****"
+setcap cap_chown+ep $file
+$SETFATTR_PROG -n trusted.name -v value $file
+echo data2 >> $file
 cat $file
-echo "----"
-
-echo "only let root write to file"
-chmod 700 $file
-chown root $file 
-
-echo "as non-root try to append to file"
-_runas -u $uid $tmp.append 2>&1 | _filefilter
-
-echo "restore perms on file"
-chmod 777 $file
+$GETFATTR_PROG -m '^trusted\.*' --absolute-names $file | filefilter
 
-echo "set a root EA on file"
-${ATTR_PROG} -R -s test -V testval $file | _filefilter
-
-echo "list EA on file"
-${ATTR_PROG} -R -l $file | _filefilter
-
-echo "as non-root try to append to file"
-_runas -u $uid $tmp.append 2>&1 | _filefilter
-
-echo "list EA on file"
-${ATTR_PROG} -R -l $file | _filefilter
-
-chown $uid $file
+echo "**** Verifying that chmod doesn't affect open file descriptors ****"
+rm -f $file
+touch $file
+chown $qa_user $file
 chmod ugo+w $TEST_DIR
-echo "as non-root call writemod"
-_runas -u $uid src/writemod $file 2>&1 | _filefilter
-
-echo "cat file"
-echo "----"
+su $qa_user -c "src/writemod $file" | filefilter
 cat $file
-echo "----"
 
 # success, all done
 status=0
diff --git a/tests/generic/093.out b/tests/generic/093.out
index 0113a48ca00c2637080cbaa3bcf9bb5cc90dd473..cb29153ebfb94b066e2c1c77eebb4a1c097dbd0d 100644
GIT binary patch
literal 372
zcma)&y-vh15QKX_#po!IKtlW!5l9p~0?oB(&)#55N!D6#F5KH=$GVOJ7b{z1&o|@G
z56EhHHF#w*4me%#`1<19U0pb`rty-NZ&)M)<;+XikAg8x3_mexfu~HTG$l)1&|bP-
zeQ&~-kFqWIoLwNJr~f(!;j-M;T#W#+$ci5_tF#@^&Dwl+H+z`3eLB;%)FKZH&HOja
z$5{fd02)X32C3D0r@+N)$|hG-mqf8?GRC2GJ77x|F${xKp5@HQtaE{M6W6br)Q{ty
JE2g$rcE3cCe3<|M

literal 917
zcmb_b!A=4(5cS-znC#Vn1`iuaJP;(&i=vWvAcU0NA={+eZrWK0fA6$a2m+#sd+JQ5
zGw;25`!WFAQqvL?4kcj;iw#`g-UvaqEh<<ljiRUu*?=`E(jGeFZ8RCZP3|9GulP+j
z6vI?%eFwwAcs_i1et)`bW<oX%ni9yy1|U5+Yf1dQQ6VW|=<p{>Nm9hq;eghogSDcH
z*#V>X;>g=wgL6=haX1(O5_*BAs_`th*-1P*P}b-TXr!nXteqnK(onF5#+pvh5y)*q
zeqRL9P4Toh>qpJ{EQ2vzo)+DQF}hlLuXwK|8il2B=*c>ShHw0K!=4eygki*P`E<d6
z$f-rkkTT+D8HBQc0&=zxr&m(92uthIbP=jJC$#beKQ*eD+lel}p#5*{3-)mmy|$&W
s?BGZytsx6m&!WK~&vRC;wyW>LZ8t_03lV>$J^xk;_{QNya`JBRANmR_wg3PC

diff --git a/tests/generic/group b/tests/generic/group
index e626820c..d93aa06d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -95,7 +95,7 @@
 090 metadata auto quick
 091 rw auto quick
 092 auto quick prealloc
-093 attr cap udf auto
+093 attr cap auto
 094 auto quick prealloc
 095 auto rw stress
 096 auto prealloc quick zero
-- 
2.13.3

