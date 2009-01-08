Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n082914G024420 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 20:09:01 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A23A317B9611
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 18:09:00 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.241]) by cuda.sgi.com with ESMTP id
	kCaGF4IAutjvaGkl for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 18:09:00 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so8070495rvb.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 18:09:00 -0800 (PST)
Message-Id: <20090108015419.101811540@ifup.org>
Date: Wed, 07 Jan 2009 17:53:59 -0800
From: brandon@ifup.org
Subject: [patch 4/5] [PATCH] acl: move nfs tests to their own folder
References: <20090108015355.613058570@ifup.org>
Content-Disposition: inline;
	filename=acl-move-nfs-tests-to-their-own-folder.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tes@sgi.com
Cc: Brandon Philips <bphilips@suse.de>, xfs@oss.sgi.com

Since these tests require nfs mounts to run move them into a seperate
folder so they don't run by default.

Signed-off-by: Brandon Philips <bphilips@suse.de>

---
 test/nfs-dir.test     |   50 --------------------------------------------------
 test/nfs/nfs-dir.test |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 test/nfs/nfsacl.test  |   42 ++++++++++++++++++++++++++++++++++++++++++
 test/nfsacl.test      |   42 ------------------------------------------
 4 files changed, 92 insertions(+), 92 deletions(-)

Index: acl-2.2.47/test/nfs-dir.test
===================================================================
--- acl-2.2.47.orig/test/nfs-dir.test
+++ /dev/null
@@ -1,50 +0,0 @@
-This is a regression test for a bug in 2.4 kernels. The test must be run
-as root on a machine that has a loopback mounted NFS export. The mount
-must have root squashing enabled. The test must be run in the root of
-the nfs mount, and requires the following environment variable:
-
-EXPORT_PATH => the path that is mounted at the working directory.
-
-	Create a test directory and file.
-	
-	$ umask 022
-	$ mkdir %{EXPORT_PATH}/test
-	$ echo blah > %{EXPORT_PATH}/test/blah
-
-	Make sure the file can be accessed before.
-	
-	$ su bin
-	$ cat test/blah
-	> blah
-
-	Set up a situation that triggers the bug.
-
-	$ su
-	$ chmod go-rwx %{EXPORT_PATH}/test
-	$ setfacl -m u:bin:rx %{EXPORT_PATH}/test
-	$ ls -dl %{EXPORT_PATH}/test | awk '{print $1, $3, $4}'
-	> drwxr-x---+ root root
-	$ getfacl --omit-header %{EXPORT_PATH}/test 2> /dev/null
-	> user::rwx
-	> user:bin:r-x
-	> group::---
-	> mask::r-x
-	> other::---
-	>
-
-	This should also succeed. With the bug, reading the file would
-	fail with "Stale NFS file handle" or "Input/output error".
-
-	$ su bin
-	$ cat test/blah
-	> blah
-	$ sleep 3
-	$ cat test/blah
-	> blah
-	$ cat test/blah
-	> blah
-
-	Clean up.
-
-	$ su
-	$ rm -rf %{EXPORT_PATH}/test
Index: acl-2.2.47/test/nfs/nfs-dir.test
===================================================================
--- /dev/null
+++ acl-2.2.47/test/nfs/nfs-dir.test
@@ -0,0 +1,50 @@
+This is a regression test for a bug in 2.4 kernels. The test must be run
+as root on a machine that has a loopback mounted NFS export. The mount
+must have root squashing enabled. The test must be run in the root of
+the nfs mount, and requires the following environment variable:
+
+EXPORT_PATH => the path that is mounted at the working directory.
+
+	Create a test directory and file.
+
+	$ umask 022
+	$ mkdir %{EXPORT_PATH}/test
+	$ echo blah > %{EXPORT_PATH}/test/blah
+
+	Make sure the file can be accessed before.
+
+	$ su bin
+	$ cat test/blah
+	> blah
+
+	Set up a situation that triggers the bug.
+
+	$ su
+	$ chmod go-rwx %{EXPORT_PATH}/test
+	$ setfacl -m u:bin:rx %{EXPORT_PATH}/test
+	$ ls -dl %{EXPORT_PATH}/test | awk '{print $1, $3, $4}'
+	> drwxr-x---+ root root
+	$ getfacl --omit-header %{EXPORT_PATH}/test 2> /dev/null
+	> user::rwx
+	> user:bin:r-x
+	> group::---
+	> mask::r-x
+	> other::---
+	>
+
+	This should also succeed. With the bug, reading the file would
+	fail with "Stale NFS file handle" or "Input/output error".
+
+	$ su bin
+	$ cat test/blah
+	> blah
+	$ sleep 3
+	$ cat test/blah
+	> blah
+	$ cat test/blah
+	> blah
+
+	Clean up.
+
+	$ su
+	$ rm -rf %{EXPORT_PATH}/test
Index: acl-2.2.47/test/nfs/nfsacl.test
===================================================================
--- /dev/null
+++ acl-2.2.47/test/nfs/nfsacl.test
@@ -0,0 +1,42 @@
+This is a regression test for bugs in the nfsacl protocol extension.
+The test should be run on an NFS export mount with ACL support.
+
+	Create a test directory and file.
+
+	$ umask 022
+	$ mkdir -p test/sub
+	$ echo blah > test/sub/blah
+
+	$ cp -rp test/sub test/sub2
+	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
+	> drwxr-xr-x test/sub2
+	> -rw-r--r-- test/sub2/blah
+
+	$ rm -rf test/sub2
+
+	$ setfacl -m u:daemon:rwx test/sub
+	$ setfacl -dm u:daemon:rwx test/sub
+	$ getfattr -m- test/sub
+	> # file: test/sub
+	> system.posix_acl_access
+	> system.posix_acl_default
+	>
+
+	$ cp -rp test/sub test/sub2
+	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
+	> drwxrwxr-x+ test/sub2
+	> -rw-r--r-- test/sub2/blah
+
+	$ rm -rf test/sub2
+
+	$ setfacl -m u:daemon:rw test/sub/blah
+	$ cp -rp test/sub test/sub2
+	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
+	> drwxrwxr-x+ test/sub2
+	> -rw-rw-r--+ test/sub2/blah
+
+	$ rm -rf test/sub2
+
+	Clean up.
+
+	$ rm -rf test
Index: acl-2.2.47/test/nfsacl.test
===================================================================
--- acl-2.2.47.orig/test/nfsacl.test
+++ /dev/null
@@ -1,42 +0,0 @@
-This is a regression test for bugs in the nfsacl protocol extension.
-The test should be run on an NFS export mount with ACL support.
-
-	Create a test directory and file.
-
-	$ umask 022
-	$ mkdir -p test/sub
-	$ echo blah > test/sub/blah
-
-	$ cp -rp test/sub test/sub2
-	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
-	> drwxr-xr-x test/sub2
-	> -rw-r--r-- test/sub2/blah
-
-	$ rm -rf test/sub2
-
-	$ setfacl -m u:daemon:rwx test/sub
-	$ setfacl -dm u:daemon:rwx test/sub
-	$ getfattr -m- test/sub
-	> # file: test/sub
-	> system.posix_acl_access
-	> system.posix_acl_default
-	>
-
-	$ cp -rp test/sub test/sub2
-	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
-	> drwxrwxr-x+ test/sub2
-	> -rw-r--r-- test/sub2/blah
-
-	$ rm -rf test/sub2
-
-	$ setfacl -m u:daemon:rw test/sub/blah
-	$ cp -rp test/sub test/sub2
-	$ find test/sub2 | sort | xargs ls -dl | awk '{print $1,$8}'
-	> drwxrwxr-x+ test/sub2
-	> -rw-rw-r--+ test/sub2/blah
-
-	$ rm -rf test/sub2
-
-	Clean up.
-
-	$ rm -rf test

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
