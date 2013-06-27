Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16A4E7F50
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 11:03:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CCA5E8F8035
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:03:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5f6YKSSrZNH9xvTY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 09:03:38 -0700 (PDT)
Date: Thu, 27 Jun 2013 12:03:28 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 1/3] xfstests: add nsexec user namespace helper
Message-ID: <20130627120328.2ed716ef@oracle.com>
In-Reply-To: <20130626010931.GA29376@dastard>
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Add new program nsexec to facilitate creating/entering a user namespace. The
orignal source for the program is https://lwn.net/Articles/539940. I added
the -s option to become "root" in the user namespace.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 .gitignore   |   1 +
 src/Makefile |   2 +-
 src/nsexec.c | 239 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+), 1 deletion(-)
 create mode 100644 src/nsexec.c

diff --git a/.gitignore b/.gitignore
index ad7afbc..23e4c82 100644
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
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
