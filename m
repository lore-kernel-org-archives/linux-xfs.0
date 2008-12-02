Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2EKeYd023589 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 08:20:40 -0600
Date: Tue, 2 Dec 2008 09:20:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsqa: add testcase for ->setattr permission checking
Message-ID: <20081202142039.GA25155@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com


Index: xfs-cmds-git/xfstests/192
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds-git/xfstests/192	2008-12-02 14:16:12.000000000 +0000
@@ -0,0 +1,177 @@
+#! /bin/sh
+# FS QA Test No. 192
+#
+# Test permission checks in ->setattr
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Christoph Hellwig.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup_files; exit \$status" 0 1 2 3 15
+tag="added by qa $seq"
+
+#
+# For some tests we need a secondary group for the qa_user.  Currently
+# that's not available in the framework, so the tests using it are
+# commented out.
+#
+#group2=foo
+
+#
+# Create two files, one owned by root, one by the qa_user
+#
+_create_files()
+{
+	touch test.root
+	touch test.${qa_user}
+	chown ${qa_user}:${qa_user} test.${qa_user}
+}
+
+#
+# Remove our files again
+#
+_cleanup_files()
+{
+	rm -f test.${qa_user}
+	rm -f test.root
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs nfs udf
+_supported_os Linux
+
+_require_user
+_need_to_be_root
+
+
+#
+# make sure we have a normal umask set
+#
+umask 022
+
+
+#
+# Test the ATTR_UID case
+#
+echo
+echo "testing ATTR_UID"
+echo
+
+_create_files
+
+echo "user: chown root owned file to qa_user (should fail)"
+su ${qa_user} -c "chown root test.${qa_user}"
+
+echo "user: chown root owned file to root (should fail)"
+su ${qa_user} -c "chown root test.root"
+
+echo "user: chown qa_user owned file to qa_user (should succeed)"
+su ${qa_user} -c "chown ${qa_user} test.${qa_user}"
+
+# this would work without _POSIX_CHOWN_RESTRICTED
+echo "user: chown qa_user owned file to root (should fail)"
+su ${qa_user} -c "chown ${qa_user} test.root"
+
+_cleanup_files
+
+#
+# Test the ATTR_GID case
+#
+echo
+echo "testing ATTR_GID"
+echo
+
+_create_files
+
+echo "user: chgrp root owned file to root (should fail)"
+su ${qa_user} -c "chgrp root test.root"
+
+echo "user: chgrp qa_user owned file to root (should fail)"
+su ${qa_user} -c "chgrp root test.${qa_user}"
+
+echo "user: chgrp root owned file to qa_user (should fail)"
+su ${qa_user} -c "chgrp ${qa_user} test.root"
+
+echo "user: chgrp qa_user owned file to qa_user (should suceed)"
+su ${qa_user} -c "chgrp ${qa_user} test.${qa_user}"
+
+#echo "user: chgrp qa_user owned file to secondary group (should suceed)"
+#su ${qa_user} -c "chgrp ${group2} test.${qa_user}"
+
+_cleanup_files
+
+
+#
+# Test the ATTR_MODE case
+#
+echo
+echo "testing ATTR_MODE"
+echo
+
+_create_files
+
+echo "user: chmod a+r on qa_user owned file (should succeed)"
+su ${qa_user} -c "chmod a+r test.${qa_user}"
+
+echo "user: chmod a+r on root owned file (should fail)"
+su ${qa_user} -c "chmod a+r test.root"
+
+#
+# Setup a file owned by the qa_user, but with a group ID that
+# is not present in the qa_users group list (use root to make it easier for it)
+# and mark it with set sgid bit
+#
+echo "check that the sgid bit is cleared"
+chown ${qa_user}:root test.${qa_user}
+chmod g+s test.${qa_user}
+
+# and let the qa_user change permission bits
+su ${qa_user} -c "chmod a+w test.${qa_user}"
+stat -c '%A' test.${qa_user}
+
+#
+# Setup a file owned by the qa_user and with the suid bit set.
+# A chown by root should not clean the suid bit.
+#
+echo "check that suid bit is not cleared"
+chmod u+s test.${qa_user}
+chmod a+w test.${qa_user}
+stat -c '%A' test.${qa_user}
+
+_cleanup_files
+
+
+#
+# Test ATTR_*TIMES_SET
+#
+echo
+echo "testing ATTR_*TIMES_SET"
+echo
+
+_create_files
+
+echo "user: touch qa_user file (should succeed)"
+su ${qa_user} -c "touch test.${qa_user}"
+
+echo "user: touch root file (should fail)"
+su ${qa_user} -c "touch test.root"
+
+_cleanup_files
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfs-cmds-git/xfstests/group
===================================================================
--- xfs-cmds-git.orig/xfstests/group	2008-12-02 14:00:49.000000000 +0000
+++ xfs-cmds-git/xfstests/group	2008-12-02 14:01:01.000000000 +0000
@@ -291,3 +291,4 @@
 189 mount auto
 190 rw auto
 191 nfs4acl auto
+192 auto metadata
Index: xfs-cmds-git/xfstests/192.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds-git/xfstests/192.out	2008-12-02 14:14:49.000000000 +0000
@@ -0,0 +1,38 @@
+QA output created by 192
+
+testing ATTR_UID
+
+user: chown root owned file to qa_user (should fail)
+chown: changing ownership of `test.fsgqa': Operation not permitted
+user: chown root owned file to root (should fail)
+chown: changing ownership of `test.root': Operation not permitted
+user: chown qa_user owned file to qa_user (should succeed)
+user: chown qa_user owned file to root (should fail)
+chown: changing ownership of `test.root': Operation not permitted
+
+testing ATTR_GID
+
+user: chgrp root owned file to root (should fail)
+chgrp: changing group of `test.root': Operation not permitted
+user: chgrp qa_user owned file to root (should fail)
+chgrp: changing group of `test.fsgqa': Operation not permitted
+user: chgrp root owned file to qa_user (should fail)
+chgrp: changing group of `test.root': Operation not permitted
+user: chgrp qa_user owned file to qa_user (should suceed)
+
+testing ATTR_MODE
+
+user: chmod a+r on qa_user owned file (should succeed)
+user: chmod a+r on root owned file (should fail)
+chmod: changing permissions of `test.root': Operation not permitted
+check that the sgid bit is cleared
+-rw-rw-rw-
+check that suid bit is not cleared
+-rwSrw-rw-
+
+testing ATTR_*TIMES_SET
+
+user: touch qa_user file (should succeed)
+user: touch root file (should fail)
+touch: cannot touch `test.root': Permission denied
+*** done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
