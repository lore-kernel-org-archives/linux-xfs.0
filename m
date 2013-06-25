Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E78F77F56
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 14:34:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85206AC006
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 12:34:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id NxkKIPoxEKksPyDG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 12:34:47 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5PJSSFS020249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:28:28 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5PJYjMH007426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:34:46 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5PJYj7L017672 for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 19:34:45 GMT
Date: Tue, 25 Jun 2013 15:34:43 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] xfstests: 313,314: user namespace uid/gids in inode, ACL
Message-ID: <20130625153443.08142635@oracle.com>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

These tests verify that the uid/gids in an inode and in ACLs get translated
from/to a user namespace to/from disk correctly.

I had to use getfacl instead of the chacl -l because I need numeric uids
to make the output consistent.

A new program nsexec was added to facilitate creating/entering a user
namespace for testing. The orignal source for the program is
https://lwn.net/Articles/539940. I added the -s option to become "root"
in the user namespace.

Tested against btrfs, ext4, and xfs with my proposed user namespace changes.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 .gitignore            |   1 +
 common/attr           |  14 +++
 src/Makefile          |   2 +-
 src/nsexec.c          | 239 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/313     | 107 ++++++++++++++++++++++
 tests/generic/313.out |  20 +++++
 tests/generic/314     | 102 +++++++++++++++++++++
 tests/generic/314.out |  51 +++++++++++
 tests/generic/group   |   2 +
 9 files changed, 537 insertions(+), 1 deletion(-)
 create mode 100644 src/nsexec.c
 create mode 100755 tests/generic/313
 create mode 100644 tests/generic/313.out
 create mode 100755 tests/generic/314
 create mode 100644 tests/generic/314.out

diff --git a/.gitignore b/.gitignore
index 5aa68c3..fc5050a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -63,6 +63,7 @@
 /src/mmapcat
 /src/multi_open_unlink
 /src/nametest
+/src/nsexec
 /src/permname
 /src/preallo_rw_pattern_reader
 /src/preallo_rw_pattern_writer
diff --git a/common/attr b/common/attr
index e5070bf..4a3ac9e 100644
--- a/common/attr
+++ b/common/attr
@@ -54,6 +54,20 @@ _acl_filter_id()
        -e "s/ $acl3 / id3 /"
 }
 
+_getfacl_filter_id()
+{
+    sed \
+       -e "s/user:$acl1/user:id1/" \
+       -e "s/user:$acl2/user:id2/" \
+       -e "s/user:$acl3/user:id3/" \
+       -e "s/group:$acl1/group:id1/" \
+       -e "s/group:$acl2/group:id2/" \
+       -e "s/group:$acl3/group:id3/" \
+       -e "s/: $acl1/: id1/" \
+       -e "s/: $acl2/: id2/" \
+       -e "s/: $acl3/: id3/"
+}
+
 # filtered ls
 #
 _acl_ls()
diff --git a/src/Makefile b/src/Makefile
index c18ffc9..4eabdc7 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
 
 SUBDIRS =
 
diff --git a/src/nsexec.c b/src/nsexec.c
new file mode 100644
index 0000000..f033b1a
--- /dev/null
+++ b/src/nsexec.c
@@ -0,0 +1,239 @@
+/* userns_child_exec.c
+
+   Copyright 2013, Michael Kerrisk
+   Licensed under GNU General Public License v2 or later
+
+   Create a child process that executes a shell command in new
+   namespace(s); allow UID and GID mappings to be specified when
+   creating a user namespace.
+*/
+
+#ifndef  _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sched.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/wait.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <limits.h>
+#include <errno.h>
+
+/* A simple error-handling function: print an error message based
+   on the value in 'errno' and terminate the calling process */
+
+#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
+                        } while (0)
+
+struct child_args {
+    char **argv;        /* Command to be executed by child, with arguments */
+    int    pipe_fd[2];  /* Pipe used to synchronize parent and child */
+};
+
+static int verbose, setid;
+
+static void
+usage(char *pname)
+{
+    fprintf(stderr, "Usage: %s [options] cmd [arg...]\n\n", pname);
+    fprintf(stderr, "Create a child process that executes a shell command "
+            "in a new user namespace,\n"
+            "and possibly also other new namespace(s).\n\n");
+    fprintf(stderr, "Options can be:\n\n");
+#define fpe(str) fprintf(stderr, "    %s", str);
+    fpe("-i          New IPC namespace\n");
+    fpe("-m          New mount namespace\n");
+    fpe("-n          New network namespace\n");
+    fpe("-p          New PID namespace\n");
+    fpe("-u          New UTS namespace\n");
+    fpe("-U          New user namespace\n");
+    fpe("-M uid_map  Specify UID map for user namespace\n");
+    fpe("-G gid_map  Specify GID map for user namespace\n");
+    fpe("            If -M or -G is specified, -U is required\n");
+    fpe("-s          Set uid/gid to 0 in the new user namespace\n");
+    fpe("-v          Display verbose messages\n");
+    fpe("\n");
+    fpe("Map strings for -M and -G consist of records of the form:\n");
+    fpe("\n");
+    fpe("    ID-inside-ns   ID-outside-ns   len\n");
+    fpe("\n");
+    fpe("A map string can contain multiple records, separated by commas;\n");
+    fpe("the commas are replaced by newlines before writing to map files.\n");
+
+    exit(EXIT_FAILURE);
+}
+
+/* Update the mapping file 'map_file', with the value provided in
+   'mapping', a string that defines a UID or GID mapping. A UID or
+   GID mapping consists of one or more newline-delimited records
+   of the form:
+
+       ID_inside-ns    ID-outside-ns   length
+
+   Requiring the user to supply a string that contains newlines is
+   of course inconvenient for command-line use. Thus, we permit the
+   use of commas to delimit records in this string, and replace them
+   with newlines before writing the string to the file. */
+
+static void
+update_map(char *mapping, char *map_file)
+{
+    int fd, j;
+    size_t map_len;     /* Length of 'mapping' */
+
+    /* Replace commas in mapping string with newlines */
+
+    map_len = strlen(mapping);
+    for (j = 0; j < map_len; j++)
+        if (mapping[j] == ',')
+            mapping[j] = '\n';
+
+    fd = open(map_file, O_RDWR);
+    if (fd == -1) {
+        fprintf(stderr, "open %s: %s\n", map_file, strerror(errno));
+        exit(EXIT_FAILURE);
+    }
+
+    if (write(fd, mapping, map_len) != map_len) {
+        fprintf(stderr, "write %s: %s\n", map_file, strerror(errno));
+        exit(EXIT_FAILURE);
+    }
+
+    close(fd);
+}
+
+static int              /* Start function for cloned child */
+childFunc(void *arg)
+{
+    struct child_args *args = (struct child_args *) arg;
+    char ch;
+
+    /* Wait until the parent has updated the UID and GID mappings. See
+       the comment in main(). We wait for end of file on a pipe that will
+       be closed by the parent process once it has updated the mappings. */
+
+    close(args->pipe_fd[1]);    /* Close our descriptor for the write end
+                                   of the pipe so that we see EOF when
+                                   parent closes its descriptor */
+    if (read(args->pipe_fd[0], &ch, 1) != 0) {
+        fprintf(stderr, "Failure in child: read from pipe returned != 0\n");
+        exit(EXIT_FAILURE);
+    }
+
+    if (setid) {
+    if (setgid(0) < 0)
+        fprintf(stderr, "Failure in child to setgid 0: %s\n", strerror(errno));
+    if (setuid(0) < 0)
+        fprintf(stderr, "Failure in child to setuid 0: %s\n", strerror(errno));
+    }
+
+    /* Execute a shell command */
+
+    execvp(args->argv[0], args->argv);
+    errExit("execvp");
+}
+
+#define STACK_SIZE (1024 * 1024)
+
+static char child_stack[STACK_SIZE];    /* Space for child's stack */
+
+int
+main(int argc, char *argv[])
+{
+    int flags, opt;
+    pid_t child_pid;
+    struct child_args args;
+    char *uid_map, *gid_map;
+    char map_path[PATH_MAX];
+
+    /* Parse command-line options. The initial '+' character in
+       the final getopt() argument prevents GNU-style permutation
+       of command-line options. That's useful, since sometimes
+       the 'command' to be executed by this program itself
+       has command-line options. We don't want getopt() to treat
+       those as options to this program. */
+
+    flags = 0;
+    verbose = 0;
+    setid = 0;
+    gid_map = NULL;
+    uid_map = NULL;
+    while ((opt = getopt(argc, argv, "+imnpuUM:G:vs")) != -1) {
+        switch (opt) {
+        case 'i': flags |= CLONE_NEWIPC;        break;
+        case 'm': flags |= CLONE_NEWNS;         break;
+        case 'n': flags |= CLONE_NEWNET;        break;
+        case 'p': flags |= CLONE_NEWPID;        break;
+        case 'u': flags |= CLONE_NEWUTS;        break;
+        case 'v': verbose = 1;                  break;
+        case 'M': uid_map = optarg;             break;
+        case 'G': gid_map = optarg;             break;
+        case 'U': flags |= CLONE_NEWUSER;       break;
+        case 's': setid = 1;                    break;
+        default:  usage(argv[0]);
+        }
+    }
+
+    /* -M or -G without -U is nonsensical */
+
+    if ((uid_map != NULL || gid_map != NULL) &&
+            !(flags & CLONE_NEWUSER))
+        usage(argv[0]);
+
+    args.argv = &argv[optind];
+
+    /* We use a pipe to synchronize the parent and child, in order to
+       ensure that the parent sets the UID and GID maps before the child
+       calls execve(). This ensures that the child maintains its
+       capabilities during the execve() in the common case where we
+       want to map the child's effective user ID to 0 in the new user
+       namespace. Without this synchronization, the child would lose
+       its capabilities if it performed an execve() with nonzero
+       user IDs (see the capabilities(7) man page for details of the
+       transformation of a process's capabilities during execve()). */
+
+    if (pipe(args.pipe_fd) == -1)
+        errExit("pipe");
+
+    /* Create the child in new namespace(s) */
+
+    child_pid = clone(childFunc, child_stack + STACK_SIZE,
+                      flags | SIGCHLD, &args);
+    if (child_pid == -1)
+        errExit("clone");
+
+    /* Parent falls through to here */
+
+    if (verbose)
+        printf("%s: PID of child created by clone() is %ld\n",
+                argv[0], (long) child_pid);
+
+    /* Update the UID and GID maps in the child */
+
+    if (uid_map != NULL) {
+        snprintf(map_path, PATH_MAX, "/proc/%ld/uid_map",
+                (long) child_pid);
+        update_map(uid_map, map_path);
+    }
+    if (gid_map != NULL) {
+        snprintf(map_path, PATH_MAX, "/proc/%ld/gid_map",
+                (long) child_pid);
+        update_map(gid_map, map_path);
+    }
+
+    /* Close the write end of the pipe, to signal to the child that we
+       have updated the UID and GID maps */
+
+    close(args.pipe_fd[1]);
+
+    if (waitpid(child_pid, NULL, 0) == -1)      /* Wait for child */
+        errExit("waitpid");
+
+    if (verbose)
+        printf("%s: terminating\n", argv[0]);
+
+    exit(EXIT_SUCCESS);
+}
diff --git a/tests/generic/313 b/tests/generic/313
new file mode 100755
index 0000000..0dd6213
--- /dev/null
+++ b/tests/generic/313
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# Check uid/gid to/from disk with a user namespace. A new file
+# will be created from inside a userns. We check that the uid/gid
+# is correct from both inside the userns and also from init_user_ns.
+# We will then unmount and remount the file system and check the
+# uid/gid from both inside the userns and from init_user_ns to show
+# that the correct uid was flushed and brought back from disk.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 Oracle, Inc.  All Rights Reserved.
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
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_DEV >/dev/null 2>&1
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+nsexec=$here/src/nsexec
+lstat64=$here/src/lstat64
+file=$SCRATCH_MNT/file1
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports user namespace
+_supported_os Linux
+
+[ -x $nsexec  ] || _notrun "$nsexec executable not found"
+[ -x $lstat64 ] || _notrun "$lstat64 executable not found"
+
+rm -f $seqres.full
+
+_require_scratch
+_need_to_be_root
+_require_user
+qa_user_id=`grep $qa_user /etc/passwd |awk -F: '{print $3}'`
+
+_filter_output()
+{
+    sed \
+      -e "s/$qa_user_id/qa_user/g" \
+      -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+}
+
+_print_numeric_uid()
+{
+    echo "From init_user_ns"
+    $here/src/lstat64 $file |head -3 |_filter_output
+
+    echo "From user_ns"
+    $nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" $here/src/lstat64 $file |head -3 |_filter_output
+}
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***" >>$seqres.full
+echo ""             >>$seqres.full
+_scratch_mkfs       >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+chmod 777 $SCRATCH_MNT
+
+# create $file as "root" in userns, which is $qa_user in parent namespace
+$nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" touch $file
+
+_print_numeric_uid
+
+echo ""
+echo "*** Remounting ***"
+echo ""
+sync
+umount $SCRATCH_MNT >>$seqres.full 2>&1
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+_print_numeric_uid
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+status=0
+exit
diff --git a/tests/generic/313.out b/tests/generic/313.out
new file mode 100644
index 0000000..eab14c4
--- /dev/null
+++ b/tests/generic/313.out
@@ -0,0 +1,20 @@
+QA output created by 313
+From init_user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
+From user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
+
+*** Remounting ***
+
+From init_user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
+From user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
diff --git a/tests/generic/314 b/tests/generic/314
new file mode 100755
index 0000000..40228b8
--- /dev/null
+++ b/tests/generic/314
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 314
+#
+# Check get/set ACLs to/from disk with a user namespace. A new file
+# will be created and ACLs set on it from both inside a userns and
+# from init_user_ns. We check that the ACL is is correct from both
+# inside the userns and also from init_user_ns. We will then unmount
+# and remount the file system and check the ACL from both inside the
+# userns and from init_user_ns to show that the correct uid/gid in
+# the ACL was flushed and brought back from disk.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 Oracle, Inc.  All Rights Reserved.
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
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_DEV >/dev/null 2>&1
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+nsexec=$here/src/nsexec
+file=$SCRATCH_MNT/file1
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports user namespace
+_supported_os Linux
+
+[ -x $nsexec ] || _notrun "$nsexec executable not found"
+
+rm -f $seqres.full
+
+_require_scratch
+_need_to_be_root
+_acl_setup_ids
+_require_acls
+
+_print_getfacls()
+{
+    echo "From init_user_ns"
+    getfacl -n $file 2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+
+    echo "From user_ns"
+    $nsexec -U -M "0 $acl1 1000" -G "0 $acl2 1000" getfacl -n $file  2>/dev/null | _getfacl_filter_id | sed -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+}
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***" >>$seqres.full
+echo ""             >>$seqres.full
+_scratch_mkfs       >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+touch $file
+chown $acl1.$acl1 $file
+
+# set acls from init_user_ns, to be checked from inside the userns
+setfacl -n -m u:$acl2:rw,g:$acl2:r $file
+# set acls from inside userns, to be checked from init_user_ns
+$nsexec -s -U -M "0 $acl1 1000" -G "0 $acl2 1000" setfacl -n -m u:root:rx,g:root:x $file
+
+_print_getfacls
+
+echo "*** Remounting ***"
+echo ""
+sync
+umount $SCRATCH_MNT >>$seqres.full 2>&1
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+_print_getfacls
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+status=0
+exit
diff --git a/tests/generic/314.out b/tests/generic/314.out
new file mode 100644
index 0000000..b88354c
--- /dev/null
+++ b/tests/generic/314.out
@@ -0,0 +1,51 @@
+QA output created by 314
+From init_user_ns
+# file: mnt/xfs-scratch/file1
+# owner: id1
+# group: id1
+user::rw-
+user:id1:r-x	#effective:r--
+user:id2:rw-	#effective:r--
+group::r--
+group:id2:--x	#effective:---
+mask::r--
+other::r--
+
+From user_ns
+# file: mnt/xfs-scratch/file1
+# owner: 0
+# group: 65534
+user::rw-
+user:0:r-x	#effective:r--
+user:1:rw-	#effective:r--
+group::r--
+group:0:--x	#effective:---
+mask::r--
+other::r--
+
+*** Remounting ***
+
+From init_user_ns
+# file: mnt/xfs-scratch/file1
+# owner: id1
+# group: id1
+user::rw-
+user:id1:r-x	#effective:r--
+user:id2:rw-	#effective:r--
+group::r--
+group:id2:--x	#effective:---
+mask::r--
+other::r--
+
+From user_ns
+# file: mnt/xfs-scratch/file1
+# owner: 0
+# group: 65534
+user::rw-
+user:0:r-x	#effective:r--
+user:1:rw-	#effective:r--
+group::r--
+group:0:--x	#effective:---
+mask::r--
+other::r--
+
diff --git a/tests/generic/group b/tests/generic/group
index bd443c1..ead1cb1 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -115,3 +115,5 @@
 310 auto
 311 auto metadata log
 312 auto quick prealloc enospc
+313 auto metadata quick
+314 acl attr auto quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
