Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3N0XfW1233547 for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 19:33:41 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 612F11440D71
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 17:36:22 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id LG0KhR5q9DqidLv0 for
	<xfs@oss.sgi.com>; Wed, 22 Apr 2009 17:36:22 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id CED4CA9B0D7
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2009 19:33:31 -0500 (CDT)
Message-ID: <49EFB75B.5030700@sandeen.net>
Date: Wed, 22 Apr 2009 19:33:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add aio-dio-regress tests
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
To: xfs-oss <xfs@oss.sgi.com>

Think it's worth pulling this in?
Also not sure where to put it, under the top dir or under src ...

Takes about 250s to run them all.  Could break out the longer
one into a separate test so the rest could be in quick.

-Eric

diff --git a/206 b/206
new file mode 100755
index 0000000..026059f
--- /dev/null
+++ b/206
@@ -0,0 +1,50 @@
+#! /bin/sh
+# FS QA Test No. 206
+#
+# Run the aio-dio-regress testsuite
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2009 Eric Sandeen.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+
+_supported_fs xfs udf nfs
+_supported_os Linux
+
+AIO_TESTS="aio-dio-extend-stat aio-dio-invalidate-failure \
+		aio-dio-invalidate-readahead aio-dio-subblock-eof-read \
+		aio-free-ring-with-bogus-nr-pages	\
+		aio-io-setup-with-nonwritable-context-pointer"
+
+for AIO_TEST in $AIO_TESTS; do
+	rm -f $TEST_DIR/aio-testfile
+	echo "==${AIO_TEST}=="
+	aio-dio-regress/$AIO_TEST $TEST_DIR/aio-testfile 2>&1
+done
+rm -f $TEST_DIR/aio-testfile
+
+# success, all done
+status=0
+exit
diff --git a/206.out b/206.out
new file mode 100644
index 0000000..e5da95b
--- /dev/null
+++ b/206.out
@@ -0,0 +1,13 @@
+QA output created by 206
+==aio-dio-extend-stat==
+4000 iterations of racing extensions and collection passed
+==aio-dio-invalidate-failure==
+ran for 200 seconds without error, passing
+==aio-dio-invalidate-readahead==
+test ran for 30 seconds without error
+==aio-dio-subblock-eof-read==
+AIO read of last block in file succeeded.
+==aio-free-ring-with-bogus-nr-pages==
+aio-free-ring-with-bogus-nr-pages: Success!
+==aio-io-setup-with-nonwritable-context-pointer==
+aio-io-setup-with-nonwritable-context-pointer: Success!
diff --git a/Makefile b/Makefile
index b017580..41cae71 100644
--- a/Makefile
+++ b/Makefile
@@ -19,6 +19,10 @@ LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
 LIB_SUBDIRS = include lib
 TOOL_SUBDIRS = ltp src m4
 
+ifeq ($(HAVE_AIO), true)
+TOOL_SUBDIRS += aio-dio-regress
+endif
+
 SUBDIRS = $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
 default: include/builddefs include/config.h $(DMAPI_MAKEFILE) new remake check $(TESTS)
diff --git a/aio-dio-regress/Makefile b/aio-dio-regress/Makefile
new file mode 100644
index 0000000..eb9109d
--- /dev/null
+++ b/aio-dio-regress/Makefile
@@ -0,0 +1,20 @@
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+TARGETS = $(basename $(wildcard *.c))
+
+CFILES = $(TARGETS:=.c)
+LDIRT = $(TARGETS)
+
+LIBAIO = -laio -lpthread
+
+default: $(TARGETS)
+
+include $(BUILDRULES)
+
+$(TARGETS): %: %.c
+	gcc -ggdb -Wall -laio -lpthread -o $@ $*.c
+
+install:
+	$(INSTALL) -m 755 -d $(PKG_LIB_DIR)/aio-dio-regress
+	$(INSTALL) -m 755 $(TARGETS) $(PKG_LIB_DIR)/aio-dio-regress
diff --git a/aio-dio-regress/aio-dio-extend-stat.c b/aio-dio-regress/aio-dio-extend-stat.c
new file mode 100644
index 0000000..bdc8299
--- /dev/null
+++ b/aio-dio-regress/aio-dio-extend-stat.c
@@ -0,0 +1,163 @@
+#define __USE_GNU
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <libaio.h>
+#include <malloc.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <errno.h>
+
+#ifndef O_DIRECT
+#define O_DIRECT         040000 /* direct disk access hint */
+#endif
+
+
+/*
+ * This was originally submitted to
+ * http://bugzilla.kernel.org/show_bug.cgi?id=6831 by 
+ * Rafal Wijata <wijata@nec-labs.com>.  It caught a race in dio aio completion
+ * that would call aio_complete() before the dio callers would update i_size.
+ * A stat after io_getevents() would not see the new file size.
+ *
+ * The bug was fixed in the fs/direct-io.c completion reworking that appeared
+ * in 2.6.20.  This test should fail on 2.6.19.
+ */
+
+#define BUFSIZE 1024
+
+static unsigned char buf[BUFSIZE] __attribute((aligned (512)));
+
+/* 
+ * this was arbitrarily chosen to take about two seconds on a dual athlon in a
+ * debugging kernel.. it trips up long before that.
+ */
+#define MAX_AIO_EVENTS 4000
+
+#define fail(fmt , args...) do {\
+	printf(fmt , ##args);	\
+	exit(1);		\
+} while (0)
+
+void fun_write1(void* ptr);
+void fun_writeN(void* ptr);
+void fun_read(void* ptr);
+
+int  handle = 0;
+io_context_t ctxp;
+struct iocb *iocbs[MAX_AIO_EVENTS];
+struct io_event ioevents[MAX_AIO_EVENTS];
+
+volatile int submittedSize = 0; //synchronization
+
+int main(int argc, char **argv)
+{
+	pthread_t thread_read; 
+	pthread_t thread_write;
+	int i;
+	int ret;
+
+	if (argc != 2)
+		fail("only arg should be file name\n");
+
+	for (i = 0; i < BUFSIZE; ++i)
+		buf[i] = 'A' + (char)(i % ('Z'-'A'+1));
+
+	buf[BUFSIZE-1] = '\n';
+
+	handle = open(argv[1], O_CREAT | O_TRUNC | O_DIRECT | O_RDWR, 0600); 
+	if (handle == -1) 
+		fail("failed to open test file %s, errno: %d\n",
+			argv[1], errno);
+
+	memset(&ctxp, 0, sizeof(ctxp));
+	ret = io_setup(MAX_AIO_EVENTS, &ctxp);
+	if (ret)
+		fail("io_setup returned %d\n", ret);
+
+	for (i = 0; i < MAX_AIO_EVENTS; ++i) {
+
+		iocbs[i] = calloc(1, sizeof(struct iocb));
+		if (iocbs[i] == NULL)
+			fail("failed to allocate an iocb\n");
+	
+/*		iocbs[i]->data = i; */
+		iocbs[i]->aio_fildes = handle;
+		iocbs[i]->aio_lio_opcode = IO_CMD_PWRITE;
+		iocbs[i]->aio_reqprio = 0;
+		iocbs[i]->u.c.buf = buf;
+		iocbs[i]->u.c.nbytes = BUFSIZE;
+		iocbs[i]->u.c.offset = BUFSIZE*i;
+	}
+
+	pthread_create(&thread_read, NULL, (void*)&fun_read, NULL);
+	pthread_create(&thread_write, NULL, (void*)&fun_writeN, NULL);
+
+	pthread_join(thread_read, NULL);
+	pthread_join(thread_write, NULL);
+
+	io_destroy(ctxp);
+	close(handle);
+
+	printf("%u iterations of racing extensions and collection passed\n",
+		MAX_AIO_EVENTS);
+
+	return 0;
+}
+
+void fun_read(void *ptr)
+{
+	long n = MAX_AIO_EVENTS;
+	struct stat filestat;
+	long long exSize;
+	long i;
+	long r;
+
+	while (n > 0) {
+		r = io_getevents(ctxp, 1, MAX_AIO_EVENTS, ioevents, NULL);
+		if (r < 0) 
+			fail("io_getevents returned %ld\n", r);
+
+		n -= r;
+		for (i = 0; i < r; ++i) {
+			if (ioevents[i].obj->u.c.nbytes != BUFSIZE)
+				fail("error in block: expacted %d bytes, "
+				     "receiced %ld\n", BUFSIZE,
+				     ioevents[i].obj->u.c.nbytes);
+
+			exSize = ioevents[i].obj->u.c.offset +
+				 ioevents[i].obj->u.c.nbytes;
+			fstat(handle, &filestat);
+			if (filestat.st_size < exSize)
+				fail("write of %lu bytes @%llu finished, "
+				     "expected filesize at least %llu, but "
+				     "got %ld\n", ioevents[i].obj->u.c.nbytes,
+				     ioevents[i].obj->u.c.offset, exSize,
+				     filestat.st_size);
+		}
+	}
+}
+
+void fun_writeN(void *ptr)
+{
+	int i;
+	int ret;
+
+	for(i = 0; i < MAX_AIO_EVENTS; ++i) {
+		ret = io_submit(ctxp, 1, &(iocbs[i]));
+		if (ret != 1)
+			fail("io_subit returned %d instead of 1\n", ret);
+	}
+}
+
+void fun_write1(void *ptr)
+{
+	int ret;
+    
+	ret = io_submit(ctxp, MAX_AIO_EVENTS, iocbs);
+	if (ret !=  MAX_AIO_EVENTS)
+		fail("io_subit returned %d instead of %u\n", ret,
+		     MAX_AIO_EVENTS);
+}
diff --git a/aio-dio-regress/aio-dio-invalidate-failure.c b/aio-dio-regress/aio-dio-invalidate-failure.c
new file mode 100644
index 0000000..7cc4a4b
--- /dev/null
+++ b/aio-dio-regress/aio-dio-invalidate-failure.c
@@ -0,0 +1,155 @@
+#define _XOPEN_SOURCE 500 /* pwrite */
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <libaio.h>
+#include <errno.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+/*
+ * DIO invalidates the read cache after it writes.  At one point it tried to
+ * return EIO if this failed.  When called from AIO, though, this EIO return
+ * would clobber EIOCBQUEUED and cause fs/aio.c and fs/direct-io.c to complete
+ * an iocb twice.  This typically references freed memory from an interrupt
+ * handler and oopses.
+ *
+ * This test hits the race after at most two minutes on a single spindle.  It
+ * spins performing large dio writes.  It also spins racing buffered writes.
+ * It assumes it's on ext3 using ordered writes.  The ordered write bhs can be
+ * pinned by jbd as a transaction commits.  If invalidate_inode_pages2_range()
+ * hits pages backed by those buffers ->releasepage will fail and it'll try to
+ * return -EIO.
+ */
+#ifndef O_DIRECT
+#define O_DIRECT         040000 /* direct disk access hint */
+#endif
+
+#define GINORMOUS (32 * 1024 * 1024)
+
+
+/* This test never survived to 180 seconds on a single spindle */
+#define SECONDS 200
+
+static unsigned char buf[GINORMOUS] __attribute((aligned (512)));
+
+#define fail(fmt , args...) do {\
+	printf(fmt , ##args);	\
+	exit(1);		\
+} while (0)
+
+void spin_dio(int fd)
+{
+	io_context_t ctx;
+	struct iocb iocb;
+	struct iocb *iocbs[1] = { &iocb };
+	struct io_event event;
+	int ret;
+
+        io_prep_pwrite(&iocb, fd, buf, GINORMOUS, 0);
+
+	ret = io_queue_init(1, &ctx);
+	if (ret)
+		fail("io_queue_init returned %d", ret);
+
+	while (1) {
+		ret = io_submit(ctx, 1, iocbs);
+		if (ret != 1)
+			fail("io_submit returned %d instead of 1", ret);
+
+		ret = io_getevents(ctx, 1, 1, &event, NULL);
+		if (ret != 1)
+			fail("io_getevents returned %d instead of 1", ret);
+
+		if (event.res == -EIO) {
+			printf("invalidation returned -EIO, OK\n");
+			exit(0);
+		}
+
+		if (event.res != GINORMOUS)
+			fail("event res %ld\n", event.res);
+	}
+}
+
+void spin_buffered(int fd)
+{
+	int ret;
+
+	while (1) {
+		ret = pwrite(fd, buf, GINORMOUS, 0);
+		if (ret != GINORMOUS)
+			fail("buffered write returned %d", ret);
+	}
+}
+
+static void alarm_handler(int signum)
+{
+}
+
+int main(int argc, char **argv)
+{
+	pid_t buffered_pid;
+	pid_t dio_pid;
+	pid_t pid;
+	int fd;
+	int fd2;
+	int status;
+
+	if (argc != 2)
+		fail("only arg should be file name");
+
+	fd = open(argv[1], O_DIRECT|O_CREAT|O_RDWR, 0644);
+	if (fd < 0)
+		fail("open dio failed: %d\n", errno);
+
+	fd2 = open(argv[1], O_RDWR, 0644);
+	if (fd < 0)
+		fail("open failed: %d\n", errno);
+
+	buffered_pid = fork();
+	if (buffered_pid < 0)
+		fail("fork failed: %d\n", errno);
+
+	if (buffered_pid == 0) {
+		spin_buffered(fd2);
+		exit(0);
+	}
+
+	dio_pid = fork();
+	if (dio_pid < 0) {
+		kill(buffered_pid, SIGKILL);
+		fail("fork failed: %d\n", errno);
+	}
+
+	if (dio_pid == 0) {
+		spin_dio(fd);
+		exit(0);
+	}
+
+	signal(SIGALRM, alarm_handler);
+	alarm(SECONDS);
+
+	pid = wait(&status);
+	if (pid < 0 && errno == EINTR) {
+		/* if we timed out then we're done */
+		kill(buffered_pid, SIGKILL);
+		kill(dio_pid, SIGKILL);
+		printf("ran for %d seconds without error, passing\n", SECONDS);
+		exit(0);
+	}
+
+	if (pid == dio_pid)
+		kill(buffered_pid, SIGKILL);
+	else
+		kill(dio_pid, SIGKILL);
+
+	/* 
+	 * pass on the child's pass/fail return code or fail if the child 
+	 * didn't exit cleanly.
+	 */
+	exit(WIFEXITED(status) ? WEXITSTATUS(status) : 1);
+}
diff --git a/aio-dio-regress/aio-dio-invalidate-readahead.c b/aio-dio-regress/aio-dio-invalidate-readahead.c
new file mode 100644
index 0000000..3d72b13
--- /dev/null
+++ b/aio-dio-regress/aio-dio-invalidate-readahead.c
@@ -0,0 +1,172 @@
+#define _XOPEN_SOURCE 500 /* pwrite */
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <libaio.h>
+#include <errno.h>
+#include <time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <pthread.h>
+#include <malloc.h>
+
+/*
+ * sync DIO invalidates the read cache after it finishes the write.  This
+ * is to invalidate cached pages which might have been brought in during
+ * the write.
+ *
+ * In http://lkml.org/lkml/2007/10/26/478 a user reported this failing
+ * for his case of readers and writers racing.  It turned out that his
+ * reader wasn't actually racing with the writer, but read-ahead from
+ * the reader pushed reads up into the region that the writer was working
+ * on.
+ *
+ * This test reproduces his case.  We have a writing thread tell
+ * a reading thread how far into the file it will find new data.
+ * The reader reads behind the writer, checking for stale data.
+ * If the kernel fails to invalidate the read-ahead after the
+ * write then the reader will see stale data.
+ */
+#ifndef O_DIRECT
+#define O_DIRECT         040000 /* direct disk access hint */
+#endif
+
+#define FILE_SIZE (8 * 1024 * 1024)
+
+/* this test always failed before 10 seconds on a single spindle */
+#define SECONDS 30
+
+#define fail(fmt , args...) do {\
+	printf(fmt , ##args);	\
+	exit(1);		\
+} while (0)
+
+int page_size;
+
+pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
+pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
+loff_t write_pos = 0;
+loff_t read_pos = 0;
+unsigned char byte = 0;
+
+static void *writer(void *arg)
+{
+	char *path = arg;
+	loff_t off;
+	void *buf;
+	int ret;
+	int fd;
+	time_t start = time(NULL);
+
+	buf = memalign(page_size, page_size);
+	if (buf == NULL)
+		fail("failed to allocate an aligned page");
+
+	fd = open(path, O_DIRECT|O_CREAT|O_RDWR|O_TRUNC, 0644);
+	if (fd < 0)
+		fail("dio open failed: %d\n", errno);
+
+	while (1) {
+		if ((time(NULL) - start) > SECONDS) {
+			printf("test ran for %u seconds without error\n",
+			       SECONDS);
+			exit(0);
+		}
+
+		pthread_mutex_lock(&mut);
+		while (read_pos != write_pos)
+			pthread_cond_wait(&cond, &mut);
+		byte++;
+		write_pos = 0;
+		pthread_mutex_unlock(&mut);
+
+		memset(buf, byte, page_size);
+
+		for (off = 0; off < FILE_SIZE; off += page_size) {
+
+			ret = pwrite(fd, buf, page_size, off);
+			if (ret != page_size)
+				fail("write returned %d", ret);
+
+			if ((rand() % 4) == 0) {
+				pthread_mutex_lock(&mut);
+				write_pos = off;
+				pthread_cond_signal(&cond);
+				pthread_mutex_unlock(&mut);
+			};
+		}
+	}
+}
+
+static void *reader(void *arg)
+{
+	char *path = arg;
+	unsigned char old;
+	loff_t read_to = 0;
+	void *found;
+	int fd;
+	int ret;
+	void *buf;
+	loff_t off;
+
+	setvbuf(stdout, NULL, _IONBF, 0);
+
+	buf = memalign(page_size, page_size);
+	if (buf == NULL)
+		fail("failed to allocate an aligned page");
+
+	fd = open(path, O_CREAT|O_RDONLY, 0644);
+	if (fd < 0)
+		fail("buffered open failed: %d\n", errno);
+
+	while (1) {
+		pthread_mutex_lock(&mut);
+		read_pos = read_to;
+		pthread_cond_signal(&cond);
+		while (read_pos == write_pos)
+			pthread_cond_wait(&cond, &mut);
+		read_to = write_pos;
+		off = read_pos;
+		old = byte - 1;
+		pthread_mutex_unlock(&mut);
+
+		for (; off < read_to; off += page_size) {
+
+			ret = pread(fd, buf, page_size, off);
+			if (ret != page_size)
+				fail("write returned %d", ret);
+
+			found = memchr(buf, old, page_size);
+			if (found)
+				fail("reader found old byte at pos %lu",
+				     (unsigned long)off +
+				     (unsigned long)found -
+				     (unsigned long)buf);
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	pthread_t reader_thread;
+	pthread_t writer_thread;
+	int ret;
+
+	page_size = getpagesize();
+
+	if (argc != 2)
+		fail("only arg should be file name");
+
+	ret = pthread_create(&writer_thread, NULL, writer, argv[1]);
+	if (ret == 0)
+		ret = pthread_create(&reader_thread, NULL, reader, argv[1]);
+	if (ret)
+		fail("failed to start reader and writer threads: %d", ret);
+
+	pthread_join(writer_thread, NULL);
+	pthread_join(reader_thread, NULL);
+	exit(0);
+}
diff --git a/aio-dio-regress/aio-dio-subblock-eof-read.c b/aio-dio-regress/aio-dio-subblock-eof-read.c
new file mode 100644
index 0000000..f92d361
--- /dev/null
+++ b/aio-dio-regress/aio-dio-subblock-eof-read.c
@@ -0,0 +1,95 @@
+/*
+ *  Code taken from an example posted to linux-aio at kvack.org
+ *  Original Author: Drangon Zhou
+ *  Munged by Jeff Moyer.
+ *
+ *  Description:  This source code implements a test to ensure that an AIO
+ *  read of the last block in a file opened with O_DIRECT returns the proper
+ *  amount of data.  In the past, there was a bug that resulted in a return
+ *  value of the requested block size, when in fact there was only a fraction
+ *  of that data available.  Thus, if the last data block contained 300 bytes
+ *  worth of data, and the user issued a 4k read, we want to ensure that
+ *  the return value is 300, not 4k.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <libaio.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+
+/* Create a file of a size that is not a multiple of block size */
+#define FILE_SIZE	300
+
+#define fail(fmt , args...) 	\
+do {				\
+	printf(fmt , ##args);	\
+	exit(1);		\
+} while (0)
+
+static unsigned char buffer[4096] __attribute((aligned (512)));
+
+int
+main(int argc, char **argv)
+{
+	int ret;
+	int fd;
+	const char *filename;
+	struct iocb myiocb;
+	struct iocb *cb = &myiocb;
+	io_context_t ioctx;
+	struct io_event ie;
+    
+	if (argc != 2)
+		fail("only arg should be file name");
+
+	filename = argv[1];
+	fd = open(filename, O_CREAT|O_RDWR|O_DIRECT, 0600);
+	if (fd < 0)
+		fail("open returned error %d\n", errno);
+
+	ret = ftruncate(fd, FILE_SIZE);
+	if (ret < 0)
+		fail("truncate returned error %d\n", errno);
+
+	/* <1> use normal disk read, this should be ok */
+	ret = read(fd, buffer, 4096);
+	if (ret != FILE_SIZE)
+		fail("buffered read returned %d, should be 300\n", ret);
+
+	/* <2> use AIO disk read, it sees error. */
+	memset(&myiocb, 0, sizeof(myiocb));
+	cb->data = 0;
+	cb->key = 0;
+	cb->aio_lio_opcode = IO_CMD_PREAD;
+	cb->aio_reqprio = 0; 
+	cb->aio_fildes = fd; 
+	cb->u.c.buf = buffer;
+	cb->u.c.nbytes = 4096;
+	cb->u.c.offset = 0;
+    
+	ret = io_queue_init(1, &ioctx);
+	if (ret != 0)
+		fail("io_queue_init returned error %d\n", ret);
+
+	ret = io_submit(ioctx, 1, &cb);
+	if (ret != 1)
+		fail("io_submit returned error %d\n", ret);
+
+	ret = io_getevents(ioctx, 1, 1, &ie, NULL);
+	if (ret != 1)
+		fail("io_getevents returned %d\n", ret);
+
+	/*
+	 *  If all goes well, we should see 300 bytes read.  If things
+	 *  are broken, we may very well see a result of 4k.
+	 */
+	if (ie.res != FILE_SIZE)
+		fail("AIO read of last block in file returned %d bytes, "
+		     "expected %d\n", ret, FILE_SIZE);
+
+	printf("AIO read of last block in file succeeded.\n");
+	return 0;
+}
diff --git a/aio-dio-regress/aio-free-ring-with-bogus-nr-pages.c b/aio-dio-regress/aio-free-ring-with-bogus-nr-pages.c
new file mode 100644
index 0000000..e91f344
--- /dev/null
+++ b/aio-dio-regress/aio-free-ring-with-bogus-nr-pages.c
@@ -0,0 +1,65 @@
+/*
+ *  Code taken from an example posted to Red Hat bugzilla #220971
+ *
+ *  Original Author: Kostantin Khorenko from OpenVZ/Virtuozzo
+ *  Munged by Jeff Moyer.
+ *
+ *  Description: "aio_setup_ring() function initializes info->nr_pages
+ *    variable incorrectly, then this variable can be used in error path
+ *    to free the allocated resources. By this way an unprivileged user
+ *    can crash the node."
+ *
+ *  At the beginning of aio_setup_ring, info->nr_pages is initialized
+ *  to the requested number of pages.  However, it is supposed to
+ *  indicate how many pages are mapped in info->ring_pages.  Thus, if
+ *  the call to do_mmap fails:
+ *
+ *	info->mmap_base = do_mmap(NULL, 0, info->mmap_size, 
+ *				  PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE,
+ *				  0);
+ *	if (IS_ERR((void *)info->mmap_base)) {
+ *		up_write(&ctx->mm->mmap_sem);
+ *		printk("mmap err: %ld\n", -info->mmap_base);
+ *		info->mmap_size = 0;
+ *		aio_free_ring(ctx);    <---------
+ *		return -EAGAIN;
+ *	}
+ *
+ *  we end up calling aio_free_ring with a bogus array and cause an oops.
+ *
+ *  This is a destructive test.
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <errno.h>
+#include <libgen.h>
+#include <libaio.h>
+
+int main(int __attribute__((unused)) argc, char **argv)
+{
+	long res;
+	io_context_t ctx;
+	void* map;
+
+	while (1) {
+		map = mmap(NULL, 100, PROT_READ, MAP_ANONYMOUS|MAP_PRIVATE,
+			   0, 0);
+		if (map == MAP_FAILED)
+			break;
+		map = mmap(NULL, 100, PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
+			   0, 0);
+		if (map == MAP_FAILED)
+			break;
+	}
+
+	memset(&ctx, 0, sizeof(ctx));
+	res = io_setup(10000, &ctx);
+	if (res != -ENOMEM) {
+		printf("%s: Error: io_setup returned %ld, expected -ENOMEM\n",
+		       basename(argv[0]), res);
+		return 1;
+	} else
+		printf("%s: Success!\n", basename(argv[0]));
+	return 0;
+}
diff --git a/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c b/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c
new file mode 100644
index 0000000..c0ba09f
--- /dev/null
+++ b/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c
@@ -0,0 +1,31 @@
+/*
+ *  Author:  Jeff Moyer
+ *
+ *  Description: Pass a non-writable context pointer to io_setup to see if
+ *  the kernel deals with it correctly.  In the past, the reference counting
+ *  in this particular error path was off and this operation would cause an
+ *  oops.
+ *
+ *  This is a destructive test.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <libgen.h>
+#include <libaio.h>
+
+int
+main(int __attribute__((unused)) argc, char **argv)
+{
+	void *addr;
+
+	addr = mmap(NULL, 4096, PROT_READ, MAP_SHARED|MAP_ANONYMOUS, 0, 0);
+	if (!addr) {
+		perror("mmap");
+		exit(1);
+	}
+	io_setup(1, addr /* un-writable pointer */);
+
+	printf("%s: Success!\n", basename(argv[0]));
+	return 0;
+}
diff --git a/group b/group
index 0ac33c2..ca74d54 100644
--- a/group
+++ b/group
@@ -310,3 +310,4 @@ atime
 203 ioctl auto
 204 metadata rw auto
 205 metadata rw auto
+206 auto aio

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
