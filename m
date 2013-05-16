Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 88FE57F37
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 07:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB9CAAC003
	for <xfs@oss.sgi.com>; Thu, 16 May 2013 05:07:53 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id eAOb9nf09tITIqrK (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 16 May 2013 05:07:47 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfstests: test data integrity under disk failure
Date: Thu, 16 May 2013 16:07:32 +0400
Message-Id: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org

Parallels team have old good tool called hwflush-check which is server/client
application for testing data integrity under system/disk failure conditions.
Usually we run hwflush-check on two different hosts and use PMU to trigger real
power failure of the client as a whole unit. This tests may be used for
SSD checking (some of them are known to have probelms with hwflush).
I hope it will be good to share it with community.

This tests simulate just one disk failure while client system should
survive this failure. This test extend idea of shared/305.
1) Run hwflush-check server and client on same host as usual
2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
3) Umount failed device
4) Makes disk operatable again
5) Mount filesystem
3) Check data integrity

Surprasingly this 'single disk failure test' uncover data loss on reccent kernel
(3.10-rc1) for EXT4 and XFS.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 aclocal.m4           |    1 +
 configure.ac         |    2 +
 include/builddefs.in |    1 +
 src/Makefile         |    4 +-
 src/hwflush-check.c  |  775 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/313     |  154 ++++++++++
 tests/shared/313.out |   64 ++++
 tests/shared/group   |    1 +
 8 files changed, 1000 insertions(+), 2 deletions(-)
 create mode 100644 src/hwflush-check.c
 mode change 100644 => 100755 tests/generic/311
 create mode 100755 tests/shared/313
 create mode 100644 tests/shared/313.out

diff --git a/aclocal.m4 b/aclocal.m4
index 5739004..9ae574b 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -44,6 +44,7 @@ m4_include([m4/package_attrdev.m4])
 m4_include([m4/package_dmapidev.m4])
 m4_include([m4/package_gdbmdev.m4])
 m4_include([m4/package_globals.m4])
+m4_include([m4/package_pthread.m4])
 m4_include([m4/package_utilies.m4])
 m4_include([m4/package_uuiddev.m4])
 m4_include([m4/package_xfslibs.m4])
diff --git a/configure.ac b/configure.ac
index bfae106..484fa43 100644
--- a/configure.ac
+++ b/configure.ac
@@ -70,6 +70,8 @@ in
 		AC_PACKAGE_WANT_FALLOCATE
 		AC_PACKAGE_WANT_LINUX_PRCTL_H
 		AC_PACKAGE_WANT_LINUX_FS_H
+		AC_PACKAGE_NEED_PTHREAD_H
+		AC_PACKAGE_NEED_PTHREADMUTEXINIT
 		;;
 esac
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 6519c13..f7a9a14 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -23,6 +23,7 @@ LIBGDBM = @libgdbm@
 LIBUUID = @libuuid@
 LIBHANDLE = @libhdl@
 LIBDM = @libdm@
+LIBPTHREAD = @libpthread@
 LIBTEST = $(TOPDIR)/lib/libtest.la
 
 PKG_NAME        = @pkg_name@
diff --git a/src/Makefile b/src/Makefile
index c18ffc9..cb0ca76 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,11 +18,11 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester hwflush-check
 
 SUBDIRS =
 
-LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
+LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL) $(LIBPTHREAD)
 
 ifeq ($(HAVE_XLOG_ASSIGN_LSN), true)
 LINUX_TARGETS += loggen
diff --git a/src/hwflush-check.c b/src/hwflush-check.c
new file mode 100644
index 0000000..aa2d1a5
--- /dev/null
+++ b/src/hwflush-check.c
@@ -0,0 +1,775 @@
+/*
+ * Copyright (c) 2011-2013 Parallels Inc.
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
+Compile:
+	gcc  hwflush-check.c -o hwflush-check -lpthread
+Usage example:
+-------
+  1. On a server with the hostname test_server, run: hwflush-check -l
+  2. On a client, run: hwflush-check -s test_server -d /mnt/test -t 100
+  3. Turn off the client, and then turn it on again.
+  4. Restart the client: hwflush-check -s test_server -d /mnt/test -t 100
+  5. Check the server output for lines containing the message "cache error detected!"
+
+*/
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <stdint.h>
+#include <signal.h>
+#include <netinet/tcp.h>
+#include <pthread.h>
+#include <unistd.h>
+
+enum prealloc_type {
+	PA_NONE = 0,
+	PA_POSIX_FALLOC = 1,
+	PA_WRITE = 2,
+	PA_LAST = PA_WRITE,
+};
+
+static int alloc_type = PA_POSIX_FALLOC;
+static int is_server = 0;
+static int is_check_stage = 0;
+static int is_prepare = 0;
+static int use_fdatasync = 0;
+static char *host = NULL;
+static char *port = "32000";
+static char *dir = NULL;
+/* block size should be a multiply of 8 */
+static off_t blocksize = 16 * 1024 - 104;
+static off_t blocksmax = 1024 + 1;
+static unsigned int threads = 32;
+#define THREADS_MAX	1024
+
+static int exit_flag = 0;
+
+/* returns 0 if ok or -errno if error */
+int swrite(int fd, void *buf, int sz)
+{
+	int w = sz;
+
+	while (w) {
+		int n = write(fd, buf, w);
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		}
+		if (n == 0)
+			return -EIO;
+		buf += n;
+		w -= n;
+	}
+	return sz;
+}
+
+/* returns number of bytes read */
+int sread(int fd, void *buf, int sz)
+{
+	int r = 0;
+	while (sz) {
+		int n = read(fd, buf, sz);
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			return -errno;
+		}
+		if (n == 0)
+			break;
+		buf += n;
+		r += n;
+		sz -= n;
+	}
+	return r;
+}
+
+static int connect_to_server(void)
+{
+	struct addrinfo *result, *rp, hints;
+	int sock = -1;
+	int ret;
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags = AI_V4MAPPED | AI_ADDRCONFIG;
+
+	/* resolve address */
+	ret = getaddrinfo(host, port, &hints, &result);
+	if (ret != 0) {
+		fprintf(stderr, "getaddrinfo() failed: %s\n", gai_strerror(ret));
+		return -1;
+	}
+
+	/* getaddrinfo() returns a list of address structures.
+	   Try each address until we successfully connect(2).
+	   If socket(2) (or connect(2)) fails, we (close the socket
+	   and) try the next address. */
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		sock = socket(rp->ai_family, rp->ai_socktype,
+				rp->ai_protocol);
+		if (sock < 0) {
+			fprintf(stderr, "Could not create socket: %s\n", strerror(errno));
+			continue;
+		}
+
+		if (connect(sock, rp->ai_addr, rp->ai_addrlen) < 0) {
+			fprintf(stderr, "connect() failed: %s\n", strerror(errno));
+			close(sock);
+			sock = -1;
+			continue;
+		}
+
+		fprintf(stderr, "Connected to %s:%s\n", host, port);
+		break;	/* Success */
+	}
+
+	if (rp == NULL) /* No address succeeded */
+		fprintf(stderr, "Could not connect to server\n");
+
+	/* addrinfo is not needed any longer, free it */
+	freeaddrinfo(result);
+
+	return sock;
+}
+
+static uint64_t find_last_counter(int fd, char *buf, off_t *offset)
+{
+	uint64_t cnt = 0;
+	off_t i, len;
+
+	for (i = 0; i < blocksmax; i++) {
+		uint64_t t;
+		unsigned int c, j;
+
+		len = sread(fd, buf, blocksize);
+		if (len < 0) {
+			fprintf(stderr, "read() failed: %s\n", strerror(-len));
+			break;
+		}
+		if (len != blocksize) {
+			fprintf(stderr, "Failed to read block %llu\n",
+					(unsigned long long)i);
+			break;
+		}
+
+		t = *(uint64_t*)buf;
+		if (cnt >= t)
+			break;
+
+		/* validate block */
+		memset(&c, t & 0xff, sizeof(c));
+		for (j = sizeof(t); j < blocksize; j += sizeof(c))
+			if (c != *(unsigned int*)(buf + j))
+				break;
+		if (j < blocksize) {
+			fprintf(stderr, "Block %llu with number %llu is invalid "
+				"at %d, blocksize %llu \n", (unsigned long long)i,
+				(unsigned long long)t, j,
+				(unsigned long long)blocksize);
+			break;
+		}
+
+		/* ok, block is good, store counter */
+		cnt = t;
+	}
+
+	*offset = blocksize * i;
+
+	return cnt;
+}
+
+/* press Ctrl-C twice on freeze */
+static void sighandler(int sig)
+{
+	if (exit_flag) {
+		signal(sig, SIG_DFL);
+		raise(sig);
+	}
+	exit_flag = 1;
+}
+
+struct client {
+	int sock;
+	pthread_mutex_t mutex;
+};
+
+struct worker {
+	pthread_t thr;
+	uint32_t id;
+	struct client *cl;
+};
+
+enum {
+	REP_FL_UPDATE = 1,
+};
+
+struct report {
+	uint32_t id;
+	uint32_t flags;
+	uint64_t cnt;
+} __attribute__((aligned(8)));
+
+static void *run_client_thread(void *arg)
+{
+	struct worker *w = arg;
+	int ret;
+	int fd;
+	off_t offset = 0;
+	char *buf;
+	char file[strlen(dir) + 6];
+	struct report rp = {
+		.id = w->id,
+		.flags = 0,
+		.cnt = 0
+	};
+
+	buf = malloc(blocksize);
+	if (!buf) {
+		fprintf(stderr, "malloc() failed\n");
+		return NULL;
+	}
+
+	snprintf(file, sizeof(file), "%s/%04u", dir, w->id);
+	/* first try to find last used counter */
+	fd = open(file, O_RDWR, 0666);
+	if (fd < 0) {
+		if (is_check_stage) {
+			fprintf(stderr, "Failed to open file '%s': %s\n", file, strerror(errno));
+			goto out_free;
+		}
+		if ((errno != ENOENT) || ((fd = creat(file, 0666)) < 0)) {
+			fprintf(stderr, "Failed to open file '%s': %s\n", file, strerror(errno));
+			goto out_free;
+		}
+		switch (alloc_type) {
+		case PA_NONE:
+			break;
+		case PA_POSIX_FALLOC:
+			if (posix_fallocate(fd, 0, blocksize * blocksmax) < 0) {
+				fprintf(stderr, "fallocate() failed: %s\n",
+					strerror(errno));
+				goto out_close_fd;
+			}
+			break;
+		case PA_WRITE: {
+			off_t num, count = blocksize * blocksmax;
+			int ret;
+			memset(buf, 0, blocksize);
+			while (count) {
+				num = blocksize < count ? blocksize : count;
+				ret = write(fd, buf, num);
+				if (ret < 0) {
+					fprintf(stderr, "write() failed: %s\n",
+						strerror(errno));
+					goto out_close_fd;
+				}
+				count -= ret;
+			}
+			lseek(fd, 0, SEEK_SET);
+			break;
+		}
+		default:
+			fprintf(stderr, "Incorrect prealloc type ");
+			goto out_close_fd;
+			break;
+		}
+
+	} else {
+		int r;
+		rp.cnt = find_last_counter(fd, buf, &offset);
+		if (lseek(fd, offset, SEEK_SET) < 0) {
+			fprintf(stderr, "lseek() failed: %s\n", strerror(errno));
+			goto out_close_fd;
+		}
+		fprintf(stderr, "id %u: latest valid id %llu\n", w->id, (unsigned long long)rp.cnt);
+		rp.id = w->id;
+		pthread_mutex_lock(&w->cl->mutex);
+		r = swrite(w->cl->sock, &rp, sizeof(rp));
+		pthread_mutex_unlock(&w->cl->mutex);
+		if (r < 0) {
+			fprintf(stderr, "Failed to write to socket: %s\n", strerror(-r));
+			goto out_close_fd;
+		}
+		if (is_check_stage)
+			goto out_close_fd;
+	}
+	if (fsync(fd)) {
+		fprintf(stderr, "fsync(2) failed: %s\n", strerror(errno));
+		goto out_close_fd;
+	}
+	if (is_prepare)
+		goto out_close_fd;
+
+	rp.flags = REP_FL_UPDATE;
+	while (!exit_flag) {
+		int r;
+
+		if (offset >= blocksize * blocksmax) {
+			offset = 0;
+			lseek(fd, 0, SEEK_SET);
+		}
+
+		rp.cnt++;
+		*(uint64_t*)buf = rp.cnt;
+		memset(buf + sizeof(rp.cnt), rp.cnt & 0xff, blocksize - sizeof(rp.cnt));
+		r = swrite(fd, buf, blocksize);
+		if (r != blocksize) {
+			fprintf(stderr, "Failed to write to file '%s': %s\n", file, strerror(-r));
+			break;
+		}
+		if (use_fdatasync)
+			ret = fdatasync(fd);
+		else
+			ret = fsync(fd);
+
+		if (ret < 0) {
+			fprintf(stderr, "%s failed: %s\n", use_fdatasync ?
+				"fdatasync()" : "fsync()", strerror(errno));
+			break;
+		}
+
+		pthread_mutex_lock(&w->cl->mutex);
+		r = swrite(w->cl->sock, &rp, sizeof(rp));
+		pthread_mutex_unlock(&w->cl->mutex);
+		if (r < 0) {
+			fprintf(stderr, "Failed to write to socket: %s\n", strerror(-r));
+			break;
+		}
+
+		offset += blocksize;
+	}
+
+out_close_fd:
+	close(fd);
+out_free:
+	free(buf);
+
+	return NULL;
+}
+
+static int run_client(void)
+{
+	struct stat st;
+	int ret = 0;
+	int flag = 1;
+	int i;
+	struct client clnt;
+	struct worker *thrs;
+
+	if (stat(dir, &st) < 0) {
+		if (errno != ENOENT) {
+			fprintf(stderr, "stat() for '%s' failed: %s\n", dir, strerror(errno));
+			return -1;
+		}
+		if (mkdir(dir, 0777) < 0) {
+			fprintf(stderr, "Failed to create directory '%s': %s\n", dir, strerror(errno));
+			return -1;
+		}
+	} else if (!S_ISDIR(st.st_mode)) {
+		fprintf(stderr, "'%s' is not a directory\n", dir);
+		return -1;
+	}
+
+	clnt.sock = connect_to_server();
+	if (clnt.sock < 0)
+		return -1;
+
+	if (setsockopt(clnt.sock, IPPROTO_TCP, TCP_NODELAY, (char*)&flag, sizeof(int)) < 0) {
+		fprintf(stderr, "setsockopt(TCP_NODELAY) failed: %s\n", strerror(errno));
+		ret = -1;
+		goto out_close_sock;
+	}
+
+	/* make things fancier for the server */
+	signal(SIGINT, sighandler);
+	signal(SIGTERM, sighandler);
+
+	thrs = malloc(threads * sizeof(struct worker));
+	if (!thrs) {
+		fprintf(stderr, "malloc() failed\n");
+		ret = -1;
+		goto out_close_sock;
+	}
+
+	pthread_mutex_init(&clnt.mutex, NULL);
+
+	for (i = 0; i < threads; i++) {
+		thrs[i].id = i;
+		thrs[i].cl = &clnt;
+		if (pthread_create(&thrs[i].thr, NULL, run_client_thread, (void*)&thrs[i])) {
+			fprintf(stderr, "Failed to start thread %u\n", i);
+			ret = -1;
+			break;
+		}
+	}
+
+	for (i--; i >= 0; i--)
+		pthread_join(thrs[i].thr, NULL);
+
+	free(thrs);
+out_close_sock:
+	close(clnt.sock);
+	
+	return ret;
+}
+
+static int prepare_for_listening(void)
+{
+	struct addrinfo *result, *rp, hints;
+	int sock = -1;
+	int ret;
+
+	memset(&hints, 0, sizeof(struct addrinfo));
+	hints.ai_family = AF_UNSPEC;
+	hints.ai_socktype = SOCK_STREAM;
+	hints.ai_flags = AI_PASSIVE; /* For wildcard IP address */
+
+	ret = getaddrinfo(NULL, port, &hints, &result);
+	if (ret != 0) {
+		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret));
+		return -1;
+	}
+
+	/* getaddrinfo() returns a list of address structures.
+	   Try each address until we successfully bind(2).
+	   If socket(2) (or bind(2)) fails, we (close the socket
+	   and) try the next address. */
+
+	for (rp = result; rp != NULL; rp = rp->ai_next) {
+		int flag = 1;
+
+		sock = socket(rp->ai_family, rp->ai_socktype,
+				rp->ai_protocol);
+		if (sock < 0) {
+			fprintf(stderr, "Could not create socket: %s\n", strerror(errno));
+			continue;
+		}
+
+		if (setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (char*)&flag, sizeof(int)) < 0) {
+			fprintf(stderr, "setsockopt(SO_REUSEADDR) failed: %s\n", strerror(errno));
+			close(sock);
+			sock = -1;
+			continue;
+		}
+
+		if (bind(sock, rp->ai_addr, rp->ai_addrlen) < 0) {
+			fprintf(stderr, "bind() failed: %s\n", strerror(errno));
+			close(sock);
+			sock = -1;
+			continue;
+		}
+
+		fprintf(stderr, "Listening on port %s\n", port);
+		break; /* Success */
+	}
+
+	if (rp == NULL) /* No address succeeded */
+		fprintf(stderr, "Could not bind\n");
+
+	freeaddrinfo(result); /* No longer needed */
+
+	return sock;
+}
+
+static int set_sock_keepalive(int sock)
+{
+	int val = 1;
+
+	/* enable TCP keepalives on socket */
+	if (setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, &val,
+				sizeof(val)) < 0) {
+		fprintf(stderr, "setsockopt() failed: %s\n", strerror(errno));
+		return -1;
+	}
+	/* set idle timeout to 1 second */
+	if (setsockopt(sock, SOL_TCP, TCP_KEEPIDLE, &val,
+				sizeof(val)) < 0) {
+		fprintf(stderr, "setsockopt() failed: %s\n", strerror(errno));
+		return -1;
+	}
+	/* set consecutive interval to 1 second */
+	if (setsockopt(sock, SOL_TCP, TCP_KEEPINTVL, &val,
+				sizeof(val)) < 0) {
+		fprintf(stderr, "setsockopt() failed: %s\n", strerror(errno));
+		return -1;
+	}
+	/* set number of keepalives before dropping to 3 */
+	val = 3;
+	if (setsockopt(sock, SOL_TCP, TCP_KEEPCNT, &val,
+				sizeof(val)) < 0) {
+		fprintf(stderr, "setsockopt() failed: %s\n", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static int run_server(void)
+{
+	int sock;
+	struct sockaddr_storage peer_addr;
+	socklen_t peer_addr_len;
+	char boundaddr[NI_MAXHOST] = "";
+	ssize_t nread;
+	uint64_t *rcv;
+	struct report rp;
+	int ret = 0;
+
+	signal(SIGINT, sighandler);
+	signal(SIGTERM, sighandler);
+
+	sock = prepare_for_listening();
+	if (sock < 0)
+		return -1;
+
+	if (listen(sock, 5) < 0) {
+		fprintf(stderr, "listen() failed: %s\n", strerror(errno));
+		ret = -1;
+		goto out_close_sock;
+	}
+
+	rcv = calloc(THREADS_MAX, sizeof(uint64_t));
+	if (!rcv) {
+		fprintf(stderr, "calloc() failed\n");
+		ret = -1;
+		goto out_close_sock;
+	}
+
+	while (!exit_flag) {
+		char claddr[NI_MAXHOST];
+		int conn;
+
+		peer_addr_len = sizeof(struct sockaddr_storage);
+		conn = accept(sock, (struct sockaddr *) &peer_addr, &peer_addr_len);
+		if (conn < 0) {
+			fprintf(stderr, "accept() failed: %s\n", strerror(errno));
+			ret = -1;
+			break;
+		}
+
+		ret = set_sock_keepalive(conn);
+		if (ret < 0) {
+			close(conn);
+			break;
+		}
+
+		ret = getnameinfo((struct sockaddr *) &peer_addr,
+				peer_addr_len, claddr, NI_MAXHOST,
+				NULL, 0, NI_NUMERICHOST);
+		if (ret < 0) {
+			fprintf(stderr, "getnameinfo() failed: %s\n", gai_strerror(ret));
+			close(conn);
+			break;
+		}
+
+		if (boundaddr[0] == 0) {
+			strncpy(boundaddr, claddr, NI_MAXHOST-1);
+			fprintf(stderr, "Accepting messages from %s\n", boundaddr);
+		} else {
+			if (strncmp(boundaddr, claddr, NI_MAXHOST) != 0) {
+				fprintf(stderr, "Skip connection from invalid address %s\n", claddr);
+				close(conn);
+				continue;
+			}
+			fprintf(stderr, "Restarted connection from %s\n", boundaddr);
+		}
+
+		while (!ret) {
+			uint32_t expected_id;
+
+			nread = sread(conn, &rp, sizeof(rp));
+			if (nread < 0) {
+				fprintf(stderr, "read() failed: %s\n", strerror(-nread));
+				break;
+			}
+			if (nread == 0)
+				break;
+			if (nread != sizeof(rp)) {
+				fprintf(stderr, "Failed to read counter\n");
+				break;
+			}
+
+			if ((rp.id < 0) || (rp.id >= THREADS_MAX)) {
+				fprintf(stderr, "Bad id received: %u\n", rp.id);
+				break;
+			}
+			if (rp.flags & REP_FL_UPDATE)
+				expected_id = rcv[rp.id] + 1;
+			else /* simple check */
+				expected_id = rcv[rp.id];
+
+			if (rp.cnt < expected_id) {
+				printf("id %u: %llu %s %llu, cache error detected!\n",
+				       rp.id, (unsigned long long)rcv[rp.id],
+				       rp.flags & REP_FL_UPDATE ? "->" : "!=",
+				       (unsigned long long)rp.cnt);
+				ret = 1;
+			} else if (rp.cnt > expected_id)
+				fprintf(stderr, "id %u: %llu -> %llu, probably missed some packets\n",
+						rp.id, (unsigned long long)rcv[rp.id],
+						(unsigned long long)rp.cnt);
+			if (rp.flags & REP_FL_UPDATE)
+				rcv[rp.id] = rp.cnt;
+		}
+		close(conn);
+		fprintf(stderr, "Connection closed\n");
+		if (ret)
+			exit_flag = 1;
+	}
+	free(rcv);
+out_close_sock:
+	close(sock);
+	return ret;
+}
+
+static const char *progname(const char *prog)
+{
+	char *s = strrchr(prog, '/');
+	return s ? s+1 : prog;
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr, "Flush test tool.\n");
+	fprintf(stderr, "Usage: %s [options...]\n", progname(prog));
+	fprintf(stderr, "Options:\n"
+			"  -l, --listen          Run as a server.\n"
+			"  -c, --check           Check data\n"
+			"  -P, --prepare         Perform only preparation stage\n"
+			"  -s, --server=IP       Set server host name or IP address\n"
+			"  -p, --port=PORT       Set server port\n"
+			"  -d, --dir=DIR         Set test directory\n"
+			"  -f, --fdatasync={0,1} Use fdatasync(2) instead of fsync(2)\n"
+			"  -b, --blocksize=SIZE  Set block size\n"
+			"  -n, --blocksmax=NUM   Set maximum number of blocks\n"
+			"  -t, --threads=NUM     Set number of client threads to use\n"
+			"  -a, --alloc_type=NUM  Set prealloc type 0:NONE, 1:posix_falloc, 2:write\n"
+			"  -h, --help            Show usage information\n"
+	       );
+
+	exit(-1);
+}
+
+static const struct option long_opts[] = {
+	{"listen",	0, 0, 'l'},
+	{"check",	0, 0, 'c'},
+	{"prepare",	0, 0, 'P'},
+	{"server",	1, 0, 's'},
+	{"port",	1, 0, 'p'},
+	{"dir",		1, 0, 'd'},
+	{"blocksize",	1, 0, 'b'},
+	{"fdatasync",	1, 0, 'f'},
+	{"blocksmax",	1, 0, 'n'},
+	{"threads",	1, 0, 't'},
+	{"alloc_type",	1, 0, 'a'},
+	{"help",	0, 0, 'h'},
+	{0, 0, 0, 0}
+};
+
+int main(int argc, char *argv[])
+{
+	int ch;
+
+	/* process options, stop at first nonoption */
+	while ((ch = getopt_long(argc, argv, "Pcls:p:d:a:b:f:n:t:h", long_opts, NULL)) != -1) {
+		switch (ch) {
+		case 'l':
+			is_server = 1;
+			break;
+		case 'c':
+			is_check_stage = 1;
+			break;
+		case 'P':
+			is_prepare = 1;
+			break;
+		case 's':
+			host = optarg;
+			break;
+		case 'p':
+			port = optarg;
+			break;
+		case 'd':
+			dir = optarg;
+			break;
+		case 'a':
+			alloc_type = atoi(optarg);
+			if (alloc_type > PA_LAST) {
+				fprintf(stderr, "Invalid prealloc type\n");
+				usage(argv[0]);
+			}
+			break;
+		case 'f':
+			use_fdatasync = atoi(optarg);
+			break;
+		case 'b': {
+			char *p;
+			blocksize = strtoull(optarg, &p, 10);
+			if (p[0] != '\0') {
+				fprintf(stderr, "Invalid block size\n");
+				usage(argv[0]);
+			}
+			blocksize &= ~7LL;
+			break;
+		}
+		case 'n': {
+			char *p;
+			blocksmax = strtoull(optarg, &p, 10);
+			if (p[0] != '\0') {
+				fprintf(stderr, "Invalid maximum number of blocks\n");
+				usage(argv[0]);
+			}
+			break;
+		}
+		case 't': {
+			char *p;
+			threads = strtoul(optarg, &p, 10);
+			if (p[0] != '\0') {
+				fprintf(stderr, "Invalid number of threads\n");
+				usage(argv[0]);
+			}
+			if (threads > THREADS_MAX) {
+				fprintf(stderr, "Number of threads is too big\n");
+				usage(argv[0]);
+			}
+			break;
+		}
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	if (!is_server) {
+		if (host == NULL) {
+			fprintf(stderr, "Please specify server address\n");
+			usage(argv[0]);
+		}
+		if (dir == NULL) {
+			fprintf(stderr, "Please specify test directory\n");
+			usage(argv[0]);
+		}
+		return run_client();
+	} else
+		return run_server();
+}
diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
diff --git a/tests/shared/313 b/tests/shared/313
new file mode 100755
index 0000000..75e8099
--- /dev/null
+++ b/tests/shared/313
@@ -0,0 +1,154 @@
+#! /bin/bash
+# FSQA Test No. 313
+#
+# fsync(2)/fdatasync(2) integrity test
+# Run hwflush-check simulate disk failure
+#
+#-----------------------------------------------------------------------
+# (c) 2013 Dmitry Monakhov
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
+#
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
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+_supported_fs ext3 ext4 xfs btrfs reiserfs
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_fail_make_request
+[ -x $here/src/hwflush-check ] || _notrun "hwflush-check not build"
+
+# TODO: Function are common enough to be moved to common/blkdev
+SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
+SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
+RUN_TIME=3
+allow_fail_make_request()
+{
+    echo "Allow global fail_make_request feature"
+    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
+    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
+}
+
+disallow_fail_make_request()
+{
+    echo "Disallow global fail_make_request feature"
+    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
+    echo 0 > $DEBUGFS_MNT/fail_make_request/times
+}
+
+start_fail_scratch_dev()
+{
+    echo "Force SCRATCH_DEV device failure"
+    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
+    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
+}
+
+stop_fail_scratch_dev()
+{
+    echo "Make SCRATCH_DEV device operable again"
+    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
+    echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
+}
+
+_cleanup()
+{
+    stop_fail_scratch_dev
+    disallow_fail_make_request
+}
+trap "_cleanup; exit \$status" 1 2 3 15
+
+_run_one()
+{
+	client_args=$@
+	echo ""
+	echo "Stage 0: start hwflush-check server"
+
+	$here/src/hwflush-check -l >> $seqres.full 2>&1 &
+	server_pid=$!
+
+	_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+	_scratch_mount || _fail "mount failed"
+	allow_fail_make_request
+
+	echo "Stage 1: hwflush-check client prepare args= $client_args" \
+	    | tee -a $seqres.client.full
+	run_check $here/src/hwflush-check -s 127.0.0.1 -d $SCRATCH_MNT --prep \
+	    $client_args >> $seqres.client.full 2>&1
+
+	echo "Stage 2: hwflush-check client run args= $client_args" \
+	    | tee -a $seqres.client.full
+	$here/src/hwflush-check -s 127.0.0.1 -d $SCRATCH_MNT \
+	     $client_args >> $seqres.client.full 2>&1 &
+	client_pid=$!
+
+	# Let's it work for awhile, and force device failure
+	sleep $RUN_TIME
+
+	start_fail_scratch_dev
+	wait $client_pid
+
+	# We expect that broken FS still can be umounted
+	run_check umount $SCRATCH_DEV
+	# Once filesystem was umounted no one is able to write to block device
+	# It is now safe to bring device back to normal state
+	stop_fail_scratch_dev
+	disallow_fail_make_request
+	run_check _scratch_mount
+
+	echo "Stage 3: hwflush-check client check args= $client_args" \
+	    | tee -a $seqres.client.full
+	# Send signal to server that it should exit after client finished it's job.
+	kill $server_pid
+	$here/src/hwflush-check -s 127.0.0.1 -d $SCRATCH_MNT --check \
+	     $client_args >> $seqres.client.full 2>&1
+	ret=$?
+	[ $ret -ne 0 ] && _fail "client exit with $ret"
+
+	wait $server_pid
+	ret=$?
+	[ $ret -ne 0 ] && _fail "server exit with $ret"
+
+	_scratch_unmount
+	_check_scratch_fs
+}
+
+
+# Simplest and most reliable testcase
+# write to preallocated file and use fsync(2)
+_run_one "-t30  -b 40960 -f0 -a2"
+
+
+# Use default blocksize = 16*1024 -8 and fsync(2)
+_run_one "-t30  -n1024 -f0 -a0"
+_run_one "-t30  -n1024 -f0 -a1"
+_run_one "-t30  -n1024 -f0 -a2"
+# Same as previous group, but with fdatasync(2)
+_run_one "-t30  -n1024 -f1 -a0"
+_run_one "-t30  -n1024 -f1 -a1"
+_run_one "-t30  -n1024 -f1 -a2"
+
+status=$?
diff --git a/tests/shared/313.out b/tests/shared/313.out
new file mode 100644
index 0000000..6a70adc
--- /dev/null
+++ b/tests/shared/313.out
@@ -0,0 +1,64 @@
+QA output created by 313
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -b 40960 -f0 -a2
+Stage 2: hwflush-check client run args= -t30 -b 40960 -f0 -a2
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -b 40960 -f0 -a2
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f0 -a0
+Stage 2: hwflush-check client run args= -t30 -n1024 -f0 -a0
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f0 -a0
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f0 -a1
+Stage 2: hwflush-check client run args= -t30 -n1024 -f0 -a1
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f0 -a1
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f0 -a2
+Stage 2: hwflush-check client run args= -t30 -n1024 -f0 -a2
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f0 -a2
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f1 -a0
+Stage 2: hwflush-check client run args= -t30 -n1024 -f1 -a0
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f1 -a0
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f1 -a1
+Stage 2: hwflush-check client run args= -t30 -n1024 -f1 -a1
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f1 -a1
+
+Stage 0: start hwflush-check server
+Allow global fail_make_request feature
+Stage 1: hwflush-check client prepare args= -t30 -n1024 -f1 -a2
+Stage 2: hwflush-check client run args= -t30 -n1024 -f1 -a2
+Force SCRATCH_DEV device failure
+Make SCRATCH_DEV device operable again
+Disallow global fail_make_request feature
+Stage 3: hwflush-check client check args= -t30 -n1024 -f1 -a2
diff --git a/tests/shared/group b/tests/shared/group
index 0ad640b..1160024 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -11,4 +11,5 @@
 289 auto quick
 298 auto trim
 305 aio dangerous enospc rw stress
+313 aio dangerous enospc rw stress
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
