Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C09497F63
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 17:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 201ABAC003
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:22 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id J3x7NVWIBgtaj21b (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:18 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id F0BEBC0A1613
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 23:41:17 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v3 5/6] generic/178: Add richacl tests
Date: Tue, 15 Dec 2015 00:41:01 +0100
Message-Id: <1450136462-11521-6-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450136462-11521-1-git-send-email-agruenba@redhat.com>
References: <1450136462-11521-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Add the Rich Access Control List tests from the richacl package as
generic/178.  The new test requires SCRATCH_DEV and SCRATCH_MNT to be
set.  It tries to create and mount a scratch filesystem with richacl
support before running the tests; if that fails, the richacl tests will
be skipped.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 Makefile                  |   2 +-
 common/rc                 |  30 ++++++++
 richacl/Makefile          |  23 ++++++
 richacl/apply-masks       | 163 +++++++++++++++++++++++++++++++++++++++
 richacl/auto-inheritance  | 191 ++++++++++++++++++++++++++++++++++++++++++++++
 richacl/basic             |  97 +++++++++++++++++++++++
 richacl/chmod             |  40 ++++++++++
 richacl/chown             |  42 ++++++++++
 richacl/create            |  36 +++++++++
 richacl/ctime             |  35 +++++++++
 richacl/delete            |  89 +++++++++++++++++++++
 richacl/setrichacl-modify |  57 ++++++++++++++
 richacl/test-lib.sh       | 154 +++++++++++++++++++++++++++++++++++++
 richacl/write-vs-append   |  54 +++++++++++++
 tests/generic/178         |  77 +++++++++++++++++++
 tests/generic/group       |   1 +
 16 files changed, 1090 insertions(+), 1 deletion(-)
 create mode 100644 richacl/Makefile
 create mode 100755 richacl/apply-masks
 create mode 100755 richacl/auto-inheritance
 create mode 100755 richacl/basic
 create mode 100755 richacl/chmod
 create mode 100755 richacl/chown
 create mode 100755 richacl/create
 create mode 100755 richacl/ctime
 create mode 100755 richacl/delete
 create mode 100755 richacl/setrichacl-modify
 create mode 100644 richacl/test-lib.sh
 create mode 100755 richacl/write-vs-append
 create mode 100755 tests/generic/178

diff --git a/Makefile b/Makefile
index 30d8747..3eec26f 100644
--- a/Makefile
+++ b/Makefile
@@ -57,7 +57,7 @@ TOOL_SUBDIRS += dmapi
 endif
 
 export TESTS_DIR = tests
-SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR)
+SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS) $(TESTS_DIR) richacl
 
 default: include/builddefs $(DMAPI_MAKEFILE)
 ifeq ($(HAVE_BUILDDEFS), no)
diff --git a/common/rc b/common/rc
index ce6ae3d..b00fd17 100644
--- a/common/rc
+++ b/common/rc
@@ -1657,6 +1657,36 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
 }
 
+_setup_scratch_richacl_xfs()
+{
+	_scratch_mkfs_xfs_supported -m richacl=1 >/dev/null 2>&1 \
+		|| _notrun "mkfs.xfs doesn't have richacl feature"
+
+	_scratch_mkfs_xfs -m richacl=1 >/dev/null 2>&1
+	_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel doesn't support richacl feature"
+}
+
+__setup_scratch_richacl()
+{
+	_scratch_mkfs -O richacl >/dev/null 2>&1 \
+		|| _notrun "can't mkfs $FSTYP with option -O richacl"
+	_scratch_mount >/dev/null 2>&1 \
+		|| _notrun "kernel doesn't support richacl feature on $FSTYP"
+}
+
+_setup_scratch_richacl()
+{
+	case "$FSTYP" in
+	xfs)	_setup_scratch_richacl_xfs
+		;;
+	ext4)	__setup_scratch_richacl
+		;;
+	*)	_notrun "this test requires richacl support on \$SCRATCH_DEV"
+		;;
+	esac
+}
+
 # check that kernel and filesystem support direct I/O
 _require_odirect()
 {
diff --git a/richacl/Makefile b/richacl/Makefile
new file mode 100644
index 0000000..8d19d1a
--- /dev/null
+++ b/richacl/Makefile
@@ -0,0 +1,23 @@
+#
+# Copyright (C) 2015  Red Hat, Inc.
+#
+
+TESTS = apply-masks basic chmod chown create delete setrichacl-modify \
+	write-vs-append ctime auto-inheritance
+
+LSRCFILES = test-lib.sh $(TESTS)
+
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+TARGET_DIR = $(PKG_LIB_DIR)/richacl
+
+include $(BUILDRULES)
+
+install:
+	$(INSTALL) -m 755 -d $(TARGET_DIR)
+	$(INSTALL) -m 755 $(TESTS) $(TARGET_DIR)
+	$(INSTALL) -m 644 test-lib.sh $(TARGET_DIR)
+
+# Nothing.
+install-dev install-lib:
diff --git a/richacl/apply-masks b/richacl/apply-masks
new file mode 100755
index 0000000..e690232
--- /dev/null
+++ b/richacl/apply-masks
@@ -0,0 +1,163 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_testdir
+
+ncheck "touch x"
+ncheck "setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:wp::allow owner@:r::allow group@:r::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:wp::deny owner@:rwp::allow group@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'owner@:rwCo::allow' x"
+check "getrichacl x" <<EOF
+x:
+ owner@:rw-------Co--::allow
+EOF
+
+ncheck "setrichacl --set 'owner@:rwpCo::allow' x"
+check "getrichacl x" <<EOF
+x:
+ owner@:rwp----------::allow
+EOF
+
+ncheck "chmod 644 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "chmod 644 x"
+check "getrichacl --numeric-ids x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:r------------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+    group@:r------------::deny
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow everyone@:r::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:r::allow everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+        77:rwp----------::allow
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:wp::deny everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:-wp----------::deny
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow 77:wp::deny everyone@:rwp::allow' x"
+ncheck "chmod 664 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+        77:rwp----------::allow
+        77:-wp----------::deny
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+ncheck "setrichacl --set 'everyone@:rwp::allow' x"
+ncheck "chmod 066 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 006 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::deny
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 606 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "setrichacl --set '77:rwp::allow everyone@:rwp::allow' x"
+ncheck "chmod 606 x"
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::deny
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "chmod 646 x"
+check "getrichacl x" <<EOF
+x:
+        77:r------------::allow
+    owner@:rwp----------::allow
+    group@:-wp----------::deny
+        77:-wp----------::deny
+ everyone@:rwp----------::allow
+EOF
diff --git a/richacl/auto-inheritance b/richacl/auto-inheritance
new file mode 100755
index 0000000..bd8a41d
--- /dev/null
+++ b/richacl/auto-inheritance
@@ -0,0 +1,191 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_testdir
+
+umask 022
+
+ncheck "mkdir d1"
+ncheck "setrichacl --modify 101:rw:fd:deny d1"
+ncheck "setrichacl --modify 102:rw:f:deny d1"
+ncheck "setrichacl --modify 103:rw:d:deny d1"
+ncheck "setrichacl --modify 101:rw:fdig:deny d1"
+
+ncheck "setrichacl --modify flags:a d1"
+
+check "getrichacl --numeric --raw d1" <<EOF
+d1:
+     flags:a
+     owner:rwpxd-----------::mask
+     group:r--x------------::mask
+     other:r--x------------::mask
+       101:rw--------------:fd:deny
+       102:rw--------------:f:deny
+       103:rw--------------:d:deny
+       101:rw--------------:fdig:deny
+    owner@:rwpxd-----------::allow
+ everyone@:r--x------------::allow
+EOF
+
+ncheck "mkdir d1/d2"
+ncheck "touch d1/d3"
+
+# Mode bits derived from inherited ACEs
+check "getrichacl --numeric --raw d1/d2" <<EOF
+d1/d2:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d3" <<EOF
+d1/d3:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+ncheck "mkdir d1/d2/d4"
+ncheck "touch d1/d2/d4/d5"
+
+# Protected files
+ncheck "mkdir d1/d6"
+ncheck "touch d1/d7"
+
+check "getrichacl --numeric --raw d1/d2/d4" <<EOF
+d1/d2/d4:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4/d5" <<EOF
+d1/d2/d4/d5:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+# Clear protected flag from all the ACLs
+ncheck "setrichacl --modify flags:a d1/d2"
+ncheck "setrichacl --modify flags:a d1/d3"
+ncheck "setrichacl --modify flags:a d1/d2/d4"
+ncheck "setrichacl --modify flags:a d1/d2/d4/d5"
+
+ncheck "getrichacl --numeric d1 | sed -e 's/:fd:deny/:fd:allow/' > acl.txt"
+check "cat acl.txt" <<EOF
+d1:
+     flags:a
+       101:rw-----------:fd:allow
+       102:rw-----------:f:deny
+       103:rw-----------:d:deny
+       101:rw-----------:fdig:deny
+    owner@:rwpxd--------::allow
+ everyone@:r--x---------::allow
+EOF
+
+ncheck "setrichacl --set-file acl.txt d1"
+
+check "getrichacl --numeric --raw d1" <<EOF
+d1:
+     flags:a
+     owner:rwpxd-----------::mask
+     group:rw-x------------::mask
+     other:r--x------------::mask
+       101:rw--------------:fd:allow
+       102:rw--------------:f:deny
+       103:rw--------------:d:deny
+       101:rw--------------:fdig:deny
+    owner@:rwpxd-----------::allow
+ everyone@:r--x------------::allow
+EOF
+
+check "getrichacl --numeric --raw d1/d2" <<EOF
+d1/d2:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:allow
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d3" <<EOF
+d1/d3:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:a:allow
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4" <<EOF
+d1/d2/d4:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:allow
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d2/d4/d5" <<EOF
+d1/d2/d4/d5:
+ flags:a
+ owner:rw--------------::mask
+ group:rw--------------::mask
+ other:----------------::mask
+   101:rw--------------:a:allow
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
+
+# No automatic inheritance for protected files
+check "getrichacl --numeric --raw d1/d6" <<EOF
+d1/d6:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:fda:deny
+   102:rw--------------:fia:deny
+   103:rw--------------:da:deny
+   101:rw--------------:fdiga:deny
+EOF
+
+check "getrichacl --numeric --raw d1/d7" <<EOF
+d1/d7:
+ flags:map
+ owner:----------------::mask
+ group:----------------::mask
+ other:----------------::mask
+   101:rw--------------:a:deny
+   102:rw--------------:a:deny
+   101:rw--------------:ga:deny
+EOF
diff --git a/richacl/basic b/richacl/basic
new file mode 100755
index 0000000..88e378b
--- /dev/null
+++ b/richacl/basic
@@ -0,0 +1,97 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+require_getfattr
+use_testdir
+
+umask 022
+
+ncheck "touch x"
+ncheck "setrichacl --set 'everyone@:rwp::allow' x"
+check "ls -l x | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-rw-
+EOF
+
+check "getrichacl x" <<EOF
+x:
+ everyone@:rwp----------::allow
+EOF
+
+ncheck 'chmod 664 x'
+check "ls -l x | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-r--
+EOF
+
+check "getrichacl x" <<EOF
+x:
+    owner@:rwp----------::allow
+    group@:rwp----------::allow
+ everyone@:r------------::allow
+EOF
+
+# Note that unlike how the test cases look at first sight, we do *not* require
+# a richacl-enabled version of ls here ...
+
+ncheck "mkdir sub"
+ncheck "setrichacl --set 'everyone@:rwpxd:fd:allow' sub"
+check "ls -dl sub | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxrwx+
+EOF
+
+#check 'getfattr sub | grep -e system\.richacl' <<EOF
+check 'getfattr -m system\.richacl sub' <<EOF
+# file: sub
+system.richacl
+EOF
+
+ncheck "chmod 775 sub"
+check "ls -dl sub | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxr-x+
+EOF
+
+check 'getfattr -m system\.richacl sub' <<EOF
+# file: sub
+system.richacl
+EOF
+
+check "getrichacl sub" <<EOF
+sub:
+    owner@:rwpxd--------::allow
+    group@:rwpxd--------::allow
+ everyone@:rwpxd--------:fdi:allow
+ everyone@:r--x---------::allow
+EOF
+
+ncheck "touch sub/f"
+check "ls -l sub/f | sed -e 's/[. ].*//'" <<EOF
+-rw-rw-rw-
+EOF
+
+check "getrichacl sub/f" <<EOF
+sub/f:
+ everyone@:rwp----------::allow
+EOF
+
+ncheck "mkdir sub/sub2"
+check "ls -dl sub/sub2 | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxrwxrwx+
+EOF
+
+check "getrichacl sub/sub2" <<EOF
+sub/sub2:
+ everyone@:rwpxd--------:fd:allow
+EOF
+
+ncheck "mkdir -m 750 sub/sub3"
+check "ls -dl sub/sub3 | sed -e 's/[.+ ].*/+/'" <<EOF
+drwxr-x---+
+EOF
+
+check "getrichacl sub/sub3" <<EOF
+sub/sub3:
+    owner@:rwpxd--------::allow
+    group@:r--x---------::allow
+ everyone@:rwpxd--------:fdi:allow
+EOF
diff --git a/richacl/chmod b/richacl/chmod
new file mode 100755
index 0000000..3ace58a
--- /dev/null
+++ b/richacl/chmod
@@ -0,0 +1,40 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+export LC_ALL=C
+
+# Create file as root
+ncheck "touch a"
+
+# We cannot set the acl as another user
+runas -u 99 -g 99
+check "setrichacl --set '99:rwc::allow' a || echo status: \$?" <<EOF
+a: Operation not permitted
+status: 1
+EOF
+
+# We cannot chmod as another user
+check "chmod 666 a || echo status: \$?" <<EOF
+chmod: changing permissions of 'a': Operation not permitted
+status: 1
+EOF
+
+# Give user 99 the write_acl permission
+runas
+ncheck "setrichacl --set '99:rwpC::allow' a"
+
+# Now user 99 can setrichacl and chmod ...
+runas -u 99 -g 99
+ncheck "setrichacl --set '99:rwpC::allow' a"
+ncheck "chmod 666 a"
+
+# ... but chmod disables the write_acl permission
+check "setrichacl --set '99:rwpC::allow' a || echo status: \$?" <<EOF
+a: Operation not permitted
+status: 1
+EOF
diff --git a/richacl/chown b/richacl/chown
new file mode 100755
index 0000000..675687c
--- /dev/null
+++ b/richacl/chown
@@ -0,0 +1,42 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+export LC_ALL=C
+
+# Create file as root
+ncheck "touch a"
+
+# Chown and chgrp with no take ownership permission fails
+runas -u 99 -g 99
+check "chown 99 a || echo status: \$?" <<EOF
+chown: changing ownership of 'a': Operation not permitted
+status: 1
+EOF
+check "chgrp 99 a || echo status: \$?" <<EOF
+chgrp: changing group of 'a': Operation not permitted
+status: 1
+EOF
+
+# Add the take_ownership permission
+runas
+ncheck "setrichacl --set '99:rwpo::allow' a"
+
+# Chown and chgrp to a user or group the process is not in fails
+runas -u 99 -g 99
+check "chown 100 a || echo status: \$?" <<EOF
+chown: changing ownership of 'a': Operation not permitted
+status: 1
+EOF
+check "chgrp 100 a || echo status: \$?" <<EOF
+chgrp: changing group of 'a': Operation not permitted
+status: 1
+EOF
+
+# Chown and chgrp to a user and group the process is in succeeds
+ncheck "chown 99 a"
+ncheck "chgrp 99 a"
diff --git a/richacl/create b/richacl/create
new file mode 100755
index 0000000..7230a45
--- /dev/null
+++ b/richacl/create
@@ -0,0 +1,36 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+export LC_ALL=C
+
+# Create directories as root with different permissions
+ncheck "mkdir d1 d2 d3"
+ncheck "setrichacl --set '99:wx::allow' d2"
+ncheck "setrichacl --set '99:px::allow' d3"
+
+runas -u 99 -g 99
+
+# Cannot create files or directories without permissions
+check "touch d1/f || :" <<EOF
+touch: cannot touch 'd1/f': Permission denied
+EOF
+check "mkdir d1/d || :" <<EOF
+mkdir: cannot create directory 'd1/d': Permission denied
+EOF
+
+# Can create files with add_file (w) permission
+ncheck "touch d2/f"
+check "mkdir d2/d || :" <<EOF
+mkdir: cannot create directory 'd2/d': Permission denied
+EOF
+
+# Can create directories with add_subdirectory (p) permission
+check "touch d3/f || :" <<EOF
+touch: cannot touch 'd3/f': Permission denied
+EOF
+ncheck "mkdir d3/d"
diff --git a/richacl/ctime b/richacl/ctime
new file mode 100755
index 0000000..2a57f8b
--- /dev/null
+++ b/richacl/ctime
@@ -0,0 +1,35 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+export LC_ALL=C
+
+ncheck "touch a"
+
+# Without write access, the ctime cannot be changed
+runas -u 99 -g 99
+check "touch a || :" <<EOF
+touch: cannot touch 'a': Permission denied
+EOF
+
+runas
+ncheck "setrichacl --set '99:rw::allow' a"
+
+# With write access, the ctime can be set to the current time, but not to
+# any other time
+runas -u 99 -g 99
+ncheck "touch a"
+check "touch -d '1 hour ago' a || :" <<EOF
+touch: setting times of 'a': Operation not permitted
+EOF
+
+runas
+ncheck "setrichacl --set '99:rwA::allow' a"
+
+# With set_attributes access, the ctime can be set to an arbitrary time
+runas -u 99 -g 99
+ncheck "touch -d '1 hour ago' a"
diff --git a/richacl/delete b/richacl/delete
new file mode 100755
index 0000000..b5ece6c
--- /dev/null
+++ b/richacl/delete
@@ -0,0 +1,89 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+umask 022
+export LC_ALL=C
+
+ncheck "chmod go+w ."
+ncheck "mkdir d1 d2 d3 d4 d5 d6 d7"
+ncheck "touch d1/f d1/g d2/f d3/f d4/f d5/f d6/f d7/f d7/g d7/h"
+ncheck "chmod o+w d1/g"
+ncheck "chown 99 d2"
+ncheck "chgrp 99 d3"
+ncheck "chmod g+w d3"
+ncheck "setrichacl --set '99:wx::allow' d4"
+ncheck "setrichacl --set '99:d::allow' d5"
+ncheck "setrichacl --set '99:xd::allow' d6"
+ncheck "setrichacl --set '99:D::allow' d7/f d7/g d7/h"
+ncheck "chmod 664 d7/g"
+
+ncheck "mkdir s2 s3 s4 s5 s6 s7"
+ncheck "chmod +t s2 s3 s4 s5 s6 s7"
+ncheck "touch s2/f s3/f s4/f s5/f s6/f s7/f s7/g s7/h"
+ncheck "chown 99 s2"
+ncheck "chgrp 99 s3"
+ncheck "chmod g+w s3"
+ncheck "setrichacl --set '99:wx::allow' s4"
+ncheck "setrichacl --set '99:d::allow' s5"
+ncheck "setrichacl --set '99:xd::allow' s6"
+ncheck "setrichacl --set '99:D::allow' s7/f s7/g s7/h"
+ncheck "chmod 664 s7/g"
+
+runas -u 99 -g 99
+
+# Cannot delete files with no or only with write permissions on the directory
+check "rm -f d1/f d1/g || :" <<EOF
+rm: cannot remove 'd1/f': Permission denied
+rm: cannot remove 'd1/g': Permission denied
+EOF
+
+# Can delete files in directories we own
+ncheck "rm -f d2/f s2/f"
+
+# Can delete files in non-sticky directories we have write access to
+check "rm -f d3/f s3/f || :" <<EOF
+rm: cannot remove 's3/f': Operation not permitted
+EOF
+
+# "Write_data/execute" access does not include delete_child access, so deleting
+# is not allowed:
+check "rm -f d4/f s4/f || :" <<EOF
+rm: cannot remove 'd4/f': Permission denied
+rm: cannot remove 's4/f': Permission denied
+EOF
+
+# "Delete_child" access alone also is not sufficient
+check "rm -f d5/f s5/f || :" <<EOF
+rm: cannot remove 'd5/f': Permission denied
+rm: cannot remove 's5/f': Permission denied
+EOF
+
+# "Execute/delete_child" access is sufficient for non-sticky directories
+check "rm -f d6/f s6/f || :" <<EOF
+rm: cannot remove 's6/f': Operation not permitted
+EOF
+
+# "Delete" access on the child is sufficient, even in sticky directories.
+check "rm -f d7/f s7/f || :" <<EOF
+EOF
+
+# Regression: Delete access must not override add_file / add_subdirectory
+# access.
+ncheck "touch h"
+check "mv h d7/h || :" <<EOF
+mv: cannot move 'h' to 'd7/h': Permission denied
+EOF
+check "mv h s7/h || :" <<EOF
+mv: cannot move 'h' to 's7/h': Permission denied
+EOF
+
+# A chmod turns off the "delete" permission
+check "rm -f d7/g s7/g || :" <<EOF
+rm: cannot remove 'd7/g': Permission denied
+rm: cannot remove 's7/g': Permission denied
+EOF
diff --git a/richacl/setrichacl-modify b/richacl/setrichacl-modify
new file mode 100755
index 0000000..10705d2
--- /dev/null
+++ b/richacl/setrichacl-modify
@@ -0,0 +1,57 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_richacls
+use_testdir
+
+umask 022
+
+ncheck "touch f"
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:w::deny' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   202:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:rw::allow' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   202:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify '202:w:a:deny' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   202:-w-----------:a:deny
+   101:rw-----------:a:allow
+EOF
+
+ncheck "setrichacl --set 'flags:a 101:w::deny 101:rw::allow 101:w:a:deny 101:rw:a:allow' f"
+ncheck "setrichacl --modify ' 202:rw:a:allow' f"
+check "getrichacl --numeric f" <<EOF
+f:
+ flags:a
+   101:-w-----------::deny
+   101:rw-----------::allow
+   101:-w-----------:a:deny
+   101:rw-----------:a:allow
+   202:rw-----------:a:allow
+EOF
diff --git a/richacl/test-lib.sh b/richacl/test-lib.sh
new file mode 100644
index 0000000..8705e50
--- /dev/null
+++ b/richacl/test-lib.sh
@@ -0,0 +1,154 @@
+# Library for simple test scripts
+# Copyright (C) 2009, 2011-2013 Free Software Foundation, Inc.
+#
+# Copying and distribution of this file, with or without modification,
+# in any medium, are permitted without royalty provided the copyright
+# notice and this notice are preserved.
+
+use_testdir() {
+    testdir=$PWD/testdir.`basename $0`
+    if [ -e "$testdir" ]; then
+	chmod -R u+rwx "$testdir" 2>/dev/null
+	rm -rf "$testdir" || exit 2
+    fi
+    mkdir "$testdir" || exit 2
+    cd "$testdir"
+}
+
+require_runas() {
+    if ! $here/src/runas -u 99 -g 99 true ; then
+	echo "This test must be run as root" >&2
+	exit 77
+    fi
+}
+
+require_richacls() {
+    if [ -e $here/src/require-richacls ]; then
+	$here/src/require-richacls || exit $?
+    fi
+    if ! type -f getrichacl setrichacl > /dev/null; then
+	echo "This test requires the getrichacl and setrichacl utilities" >&2
+	exit 77
+    fi
+}
+
+require_getfattr() {
+    if ! type -f getfattr > /dev/null ; then
+	echo "This test requires the getfattr utility" >&2
+	exit 77
+    fi
+}
+
+_RUNAS=
+runas() {
+    _start_test -1 runas "$*"
+    if [ $# = 0 ]; then
+	_RUNAS=
+    else
+	_RUNAS="$here/src/runas $* --"
+    fi
+    echo "ok"
+}
+
+if diff -u -L expected -L got /dev/null /dev/null 2> /dev/null; then
+    eval '_compare() {
+	diff -u -L expected -L got "$1" "$2"
+    }'
+else
+    eval '_compare() {
+	echo "expected:"
+	cat "$1"
+	echo "got:"
+	cat "$2"
+    }'
+fi
+
+_check() {
+    local frame=$1
+    shift
+    _start_test "$frame" "$*"
+    expected=`cat`
+    if got=`set +x; eval "$_RUNAS $*" 3>&2 </dev/null 2>&1` && \
+            test "$expected" = "$got" ; then
+	echo "ok"
+	checks_succeeded="$checks_succeeded + 1"
+    else
+	echo "FAILED"
+	if test "$expected" != "$got" ; then
+	    echo "$expected" > expected~
+	    echo "$got" > got~
+	    _compare expected~ got~
+	    rm -f expected~ got~
+	fi
+	checks_failed="$checks_failed + 1"
+    fi
+}
+
+check() {
+    _check 0 "$@"
+}
+
+ncheck() {
+    _check 0 "$@" < /dev/null
+}
+
+parent_check() {
+    _check 1 "$@"
+}
+
+parent_ncheck() {
+    _check 1 "$@" < /dev/null
+}
+
+cleanup() {
+    status=$?
+    checks_succeeded=`expr $checks_succeeded`
+    checks_failed=`expr $checks_failed`
+    checks_total=`expr $checks_succeeded + $checks_failed`
+    if test $checks_total -gt 0 ; then
+	if test $checks_failed -gt 0 && test $status -eq 0 ; then
+	    status=1
+	fi
+	echo "$checks_total tests ($checks_succeeded passed," \
+	     "$checks_failed failed)"
+    fi
+    if test $status = 0 -a -n "$testdir"; then
+	chmod -R u+rwx "$testdir" 2>/dev/null
+	cd / && rm -rf "$testdir"
+    fi
+    exit $status
+}
+
+if test -z "`echo -n`"; then
+    if eval 'test -n "${BASH_LINENO[0]}" 2>/dev/null'; then
+	eval '
+	    _start_test() {
+		local frame=$1
+		shift
+		printf "[${BASH_LINENO[2+frame]}] $* -- "
+	    }'
+    else
+	eval '
+	    _start_test() {
+		shift
+		printf "* $* -- "
+	    }'
+    fi
+else
+    eval '
+	_start_test() {
+	    shift
+	    printf "* $*\\n"
+	}'
+fi
+
+if ! type cat > /dev/null 2> /dev/null; then
+    echo "This test requires the cat utility" >&2
+    exit 77
+fi
+
+export PATH=$here/src:$PATH
+
+checks_succeeded=0
+checks_failed=0
+trap cleanup 0
diff --git a/richacl/write-vs-append b/richacl/write-vs-append
new file mode 100755
index 0000000..cad0240
--- /dev/null
+++ b/richacl/write-vs-append
@@ -0,0 +1,54 @@
+#! /bin/bash
+
+. ${0%/*}/test-lib.sh
+
+require_runas
+require_richacls
+use_testdir
+
+export LC_ALL=C
+
+ncheck "touch a b c d e f"
+ncheck "setrichacl --set 'owner@:rwp::allow' a"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:w::allow' b"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:p::allow' c"
+ncheck "setrichacl --set 'owner@:rwp::allow 99:wp::allow' d"
+ncheck "setrichacl --set '99:a::deny owner@:rwp::allow 99:w::allow' e"
+ncheck "setrichacl --set '99:w::deny owner@:rwp::allow 99:p::allow' f"
+
+runas -u 99 -g 99
+check "sh -c 'echo a > a' || :" <<EOF
+sh: a: Permission denied
+EOF
+ncheck "sh -c 'echo b > b' || :"
+check "sh -c 'echo c > c' || :" <<EOF
+sh: c: Permission denied
+EOF
+ncheck "sh -c 'echo d > d' || :"
+ncheck "sh -c 'echo e > e' || :"
+check "sh -c 'echo f > f' || :" <<EOF
+sh: f: Permission denied
+EOF
+
+check "sh -c 'echo A >> a' || :" <<EOF
+sh: a: Permission denied
+EOF
+check "sh -c 'echo B >> b' || :" <<EOF
+sh: b: Permission denied
+EOF
+ncheck "sh -c 'echo C >> c' || :"
+ncheck "sh -c 'echo D >> d' || :"
+check "sh -c 'echo E >> e' || :" <<EOF
+sh: e: Permission denied
+EOF
+ncheck "sh -c 'echo F >> f' || :"
+
+runas
+check "cat a b c d e f" <<EOF
+b
+C
+d
+D
+e
+F
+EOF
diff --git a/tests/generic/178 b/tests/generic/178
new file mode 100755
index 0000000..b37a5c5
--- /dev/null
+++ b/tests/generic/178
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test 178
+#
+# Richacl tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os IRIX Linux
+_require_scratch
+
+# require getrichacl and setrichacl
+_setup_scratch_richacl
+
+doit() {
+	local file=$1 status
+	echo "*** ${file##*/} ***"
+	"$@"
+	status=$?
+	echo
+	return $status
+}
+
+cd $SCRATCH_MNT
+
+failure=false
+for file in $here/richacl/*; do
+	[ -x "$file" ] || continue
+	doit "$file" | tee -a $seqres.full >$tmp.${file##*/}
+	if [ ${PIPESTATUS[0]} -ne 0 ]; then
+		cat $tmp.${file##*/}
+		failure=true
+	fi
+done
+
+$failure || status=0
diff --git a/tests/generic/group b/tests/generic/group
index 355603f..4d001e0 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -180,6 +180,7 @@
 175 clone_stress
 176 clone_stress
 177 auto quick prealloc metadata
+178 richacl auto
 184 metadata auto quick
 192 atime auto
 193 metadata auto quick
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
