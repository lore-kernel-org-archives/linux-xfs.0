Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 528E229DFE
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:12:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 198798F8059
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:12:36 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id J1ZLffp31Mbj5vEs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:12:31 -0800 (PST)
Subject: [PATCH 06/23] dio unwritten conversion bug tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:12:23 -0800
Message-ID: <20160209011223.23099.3987.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that we don't expose old disk contents when a directio write to
an unwritten extent fails due to IO errors.  This primarily affects
XFS and ext4.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .gitignore                  |    1 
 src/aio-dio-regress/aiocp.c |  489 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/250           |  104 +++++++++
 tests/generic/250.out       |   10 +
 tests/generic/252           |  107 +++++++++
 tests/generic/252.out       |   10 +
 tests/generic/group         |    2 
 7 files changed, 723 insertions(+)
 create mode 100644 src/aio-dio-regress/aiocp.c
 create mode 100755 tests/generic/250
 create mode 100644 tests/generic/250.out
 create mode 100755 tests/generic/252
 create mode 100644 tests/generic/252.out


diff --git a/.gitignore b/.gitignore
index a6f47d3..bbe7c1a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -112,6 +112,7 @@
 /src/aio-dio-regress/aio-free-ring-with-bogus-nr-pages
 /src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
 /src/aio-dio-regress/aio-last-ref-held-by-io
+/src/aio-dio-regress/aiocp
 /src/aio-dio-regress/aiodio_sparse2
 /src/aio-dio-regress/aio-dio-eof-race
 /src/cloner
diff --git a/src/aio-dio-regress/aiocp.c b/src/aio-dio-regress/aiocp.c
new file mode 100644
index 0000000..1abff9c
--- /dev/null
+++ b/src/aio-dio-regress/aiocp.c
@@ -0,0 +1,489 @@
+/*
+ * Copyright (c) 2004 Daniel McNeil <daniel@osdl.org>
+ *               2004 Open Source Development Lab
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program;  if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * Module: .c
+ */
+
+/*
+ * Change History:
+ *
+ *
+ * version of copy command using async i/o
+ * From:	Stephen Hemminger <shemminger@osdl.org>
+ * Modified by Daniel McNeil <daniel@osdl.org> for testing aio.
+ *	- added -a alignment
+ *	- added -b blksize option 
+ *	_ added -s size	option
+ *	- added -f open_flag option
+ *	- added -w (no write) option (reads from source only)
+ *	- added -n (num aio) option 
+ *	- added -z (zero dest) opton (writes zeros to dest only)
+ *	- added -D delay_ms option
+ *  - 2/2004  Marty Ridgeway (mridge@us.ibm.com) Changes to adapt to LTP
+ *
+ * Copy file by using a async I/O state machine.
+ * 1. Start read request
+ * 2. When read completes turn it into a write request
+ * 3. When write completes decrement counter and free resources
+ *
+ *
+ * Usage: aiocp [-b blksize] -n [num_aio] [-w] [-z] [-s filesize] 
+ *		[-f DIRECT|TRUNC|CREAT|SYNC|LARGEFILE] src dest
+ */
+
+//#define _GNU_SOURCE
+//#define DEBUG 1
+#undef DEBUG
+
+#include <unistd.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/param.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <sys/select.h>
+
+#include <libaio.h>
+
+#define AIO_BLKSIZE	(64*1024)
+#define AIO_MAXIO	32
+
+static int aio_blksize = AIO_BLKSIZE;
+static int aio_maxio = AIO_MAXIO;
+
+static int busy = 0;		// # of I/O's in flight
+static int tocopy = 0;		// # of blocks left to copy
+static int srcfd;		// source fd
+static int dstfd = -1;		// destination file descriptor
+static const char *dstname = NULL;
+static const char *srcname = NULL;
+static int source_open_flag = O_RDONLY;	/* open flags on source file */
+static int dest_open_flag = O_WRONLY;	/* open flags on dest file */
+static int no_write;			/* do not write */
+static int zero;			/* write zero's only */
+
+static int debug;
+static int count_io_q_waits;	/* how many time io_queue_wait called */
+
+struct iocb **iocb_free;	/* array of pointers to iocb */
+int iocb_free_count;		/* current free count */
+int alignment = 512;		/* buffer alignment */
+
+struct timeval delay;		/* delay between i/o */
+
+int init_iocb(int n, int iosize)
+{
+	void *buf;
+	int i;
+
+	if ((iocb_free = malloc(n * sizeof(struct iocb *))) == 0) {
+		return -1;
+	}
+
+	for (i = 0; i < n; i++) {
+		if (!(iocb_free[i] = (struct iocb *) malloc(sizeof(struct iocb))))
+			return -1;
+		if (posix_memalign(&buf, alignment, iosize))
+			return -1;
+		if (debug > 1) {
+			printf("buf allocated at 0x%p, align:%d\n",
+					buf, alignment);
+		}
+		if (zero) {
+			/*
+			 * We are writing zero's to dstfd
+			 */
+			memset(buf, 0, iosize);
+		}
+		io_prep_pread(iocb_free[i], -1, buf, iosize, 0);
+	}
+	iocb_free_count = i;
+	return 0;
+}
+
+struct iocb *alloc_iocb()
+{
+	if (!iocb_free_count)
+		return 0;
+	return iocb_free[--iocb_free_count];
+}
+
+void free_iocb(struct iocb *io)
+{
+	iocb_free[iocb_free_count++] = io;
+}
+
+/*
+ * io_wait_run() - wait for an io_event and then call the callback.
+ */
+int io_wait_run(io_context_t ctx, struct timespec *to)
+{
+	struct io_event events[aio_maxio];
+	struct io_event *ep;
+	int ret, n;
+
+	/*
+	 * get up to aio_maxio events at a time.
+	 */
+	ret = n = io_getevents(ctx, 1, aio_maxio, events, to);
+
+	/*
+	 * Call the callback functions for each event.
+	 */
+	for (ep = events; n-- > 0; ep++) {
+		io_callback_t cb = (io_callback_t)ep->data;
+		struct iocb *iocb = (struct iocb *)ep->obj;
+
+		cb(ctx, iocb, ep->res, ep->res2);
+	}
+	return ret;
+}
+
+/* Fatal error handler */
+static void io_error(const char *func, int rc)
+{
+	if (rc == -ENOSYS)
+		fprintf(stderr, "AIO not in this kernel\n");
+	else if (rc < 0)
+		fprintf(stderr, "%s: %s\n", func, strerror(-rc));
+	else
+		fprintf(stderr, "%s: error %d\n", func, rc);
+
+	if (dstfd > 0)
+		close(dstfd);
+	if (dstname && dest_open_flag & O_CREAT)
+		unlink(dstname);
+	exit(1);
+}
+
+/*
+ * Write complete callback.
+ * Adjust counts and free resources
+ */
+static void wr_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
+{
+	if (res2 != 0) {
+		io_error("aio write", res2);
+	}
+	if (res != iocb->u.c.nbytes) {
+		fprintf(stderr, "write missed bytes expect %lu got %ld\n",
+			iocb->u.c.nbytes, res2);
+		exit(1);
+	}
+	--tocopy;
+	--busy;
+	free_iocb(iocb);
+	if (debug)
+		write(2, "w", 1);
+}
+
+/*
+ * Read complete callback.
+ * Change read iocb into a write iocb and start it.
+ */
+static void rd_done(io_context_t ctx, struct iocb *iocb, long res, long res2)
+{
+	/* library needs accessors to look at iocb? */
+	int iosize = iocb->u.c.nbytes;
+	char *buf = iocb->u.c.buf;
+	off_t offset = iocb->u.c.offset;
+
+	if (res2 != 0)
+		io_error("aio read", res2);
+	if (res != iosize) {
+		fprintf(stderr, "read missing bytes expect %lu got %ld\n",
+			iocb->u.c.nbytes, res);
+		exit(1);
+	}
+
+
+	/* turn read into write */
+	if (no_write) {
+		--tocopy;
+		--busy;
+		free_iocb(iocb);
+	} else {
+		io_prep_pwrite(iocb, dstfd, buf, iosize, offset);
+		io_set_callback(iocb, wr_done);
+		if (1 != (res = io_submit(ctx, 1, &iocb)))
+			io_error("io_submit write", res);
+	}
+	if (debug)
+		write(2, "r", 1);
+	if (debug > 1)
+		printf("%d", iosize);
+}
+
+void usage()
+{
+	fprintf(stderr,
+		"Usage: aiocp [-a align] [-s size] [-b blksize] [-n num_io]"
+		" [-f open_flag] SOURCE DEST\n"
+		"This copies from SOURCE to DEST using AIO.\n\n"
+		"Usage: aiocp [options] -w SOURCE\n"
+		"This does sequential AIO reads (no writes).\n\n"
+		"Usage: aiocp [options] -z DEST\n"
+		"This does sequential AIO writes of zeros.\n");
+		
+	exit(1);
+}
+
+/*
+ * Scale value by kilo, mega, or giga.
+ */
+long long scale_by_kmg(long long value, char scale)
+{
+	switch (scale) {
+	case 'g':
+	case 'G':
+		value *= 1024;
+	case 'm':
+	case 'M':
+		value *= 1024;
+	case 'k':
+	case 'K':
+		value *= 1024;
+		break;
+	case '\0':
+		break;
+	default:
+		usage();
+		break;
+	}
+	return value;
+}
+
+int main(int argc, char *const *argv)
+{
+	struct stat st;
+	off_t length = 0, offset = 0;
+	io_context_t myctx;
+	int c;
+	extern char *optarg;
+	extern int optind, opterr, optopt;
+
+	while ((c = getopt(argc, argv, "a:b:df:n:s:wzD:")) != -1) {
+		char *endp;
+
+		switch (c) {
+		case 'a':	/* alignment of data buffer */
+			alignment = strtol(optarg, &endp, 0);
+			alignment = (long)scale_by_kmg((long long)alignment,
+							*endp);
+			break;
+		case 'f':	/* use these open flags */
+			if (strcmp(optarg, "LARGEFILE") == 0 ||
+			    strcmp(optarg, "O_LARGEFILE") == 0) {
+				source_open_flag |= O_LARGEFILE;
+				dest_open_flag |= O_LARGEFILE;
+			} else if (strcmp(optarg, "TRUNC") == 0 ||
+			           strcmp(optarg, "O_TRUNC") == 0) {
+				dest_open_flag |= O_TRUNC;
+			} else if (strcmp(optarg, "SYNC") == 0 ||
+				   strcmp(optarg, "O_SYNC") == 0) {
+				dest_open_flag |= O_SYNC | O_NONBLOCK;
+			} else if (strcmp(optarg, "DIRECT") == 0 ||
+				   strcmp(optarg, "O_DIRECT") == 0) {
+				source_open_flag |= O_DIRECT;
+				dest_open_flag |= O_DIRECT;
+			} else if (strncmp(optarg, "CREAT", 5) == 0 ||
+				   strncmp(optarg, "O_CREAT", 5) == 0) {
+				dest_open_flag |= O_CREAT;
+			}
+			break;
+		case 'd':
+			debug++;
+			break;
+		case 'D':
+			delay.tv_usec = atoi(optarg);
+			break;
+		case 'b':	/* block size */
+			aio_blksize = strtol(optarg, &endp, 0);
+			aio_blksize = (long)scale_by_kmg((long long)aio_blksize, *endp);
+			break;
+
+		case 'n':	/* num io */
+			aio_maxio = strtol(optarg, &endp, 0);
+			break;
+		case 's':	/* size to transfer */
+			length = strtoll(optarg, &endp, 0);
+			length = scale_by_kmg(length, *endp);
+			break;
+		case 'w':	/* no write */
+			no_write = 1;
+			break;
+		case 'z':	/* write zero's */
+			zero = 1;
+			break;
+
+		default:
+			usage();
+		}
+	}
+
+	argc -= optind;
+	argv += optind;
+	
+#ifndef DEBUG
+	if (argc < 1) {
+		usage();
+	}
+#else
+    source_open_flag |= O_DIRECT;
+    dest_open_flag |= O_DIRECT;
+    aio_blksize = 1;
+    aio_maxio=1;
+    srcname = "junkdata";
+    dstname = "ff2";
+#endif
+	if (!zero) {
+#ifndef DEBUG
+	       	if ((srcfd = open(srcname = *argv, source_open_flag)) < 0) {
+#else
+                if ((srcfd = open(srcname, source_open_flag)) < 0) {
+#endif
+			perror(srcname);
+			exit(1);
+		}
+		argv++;
+		argc--;
+		if (fstat(srcfd, &st) < 0) {
+			perror("fstat");
+			exit(1);
+		}
+		if (length == 0)
+			length = st.st_size;
+	}
+
+	if (!no_write) {
+		/*
+		 * We are either copying or writing zeros to dstname
+		 */
+#ifndef DEBUG
+		if (argc < 1) {
+			usage();
+		}
+		if ((dstfd = open(dstname = *argv, dest_open_flag, 0666)) < 0) {
+#else
+            if ((dstfd = open(dstname, dest_open_flag, 0666)) < 0) {
+#endif
+			perror(dstname);
+			exit(1);
+		}
+		if (zero) {
+			/*
+			 * get size of dest, if we are zeroing it.
+			 * TODO: handle devices.
+			 */
+			if (fstat(dstfd, &st) < 0) {
+				perror("fstat");
+				exit(1);
+			}
+			if (length == 0)
+				length = st.st_size;
+		}
+	}
+
+	/* initialize state machine */
+	memset(&myctx, 0, sizeof(myctx));
+	io_queue_init(aio_maxio, &myctx);
+	tocopy = howmany(length, aio_blksize);
+printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
+	if (init_iocb(aio_maxio, aio_blksize) < 0) {
+		fprintf(stderr, "Error allocating the i/o buffers\n");
+		exit(1);
+	}
+
+	while (tocopy > 0) {
+		int i, rc;
+		/* Submit as many reads as once as possible upto aio_maxio */
+		int n = MIN(MIN(aio_maxio - busy, aio_maxio),
+				howmany(length - offset, aio_blksize));
+		if (n > 0) {
+			struct iocb *ioq[n];
+
+			for (i = 0; i < n; i++) {
+				struct iocb *io = alloc_iocb();
+				int iosize = MIN(length - offset, aio_blksize);
+
+				if (zero) {
+					/*
+					 * We are writing zero's to dstfd
+					 */
+					io_prep_pwrite(io, dstfd, io->u.c.buf,
+							iosize, offset);
+					io_set_callback(io, wr_done);
+				} else {
+					io_prep_pread(io, srcfd, io->u.c.buf,
+							iosize, offset);
+					io_set_callback(io, rd_done);
+				}
+				ioq[i] = io;
+				offset += iosize;
+			}
+
+			rc = io_submit(myctx, n, ioq);
+			if (rc < 0)
+				io_error("io_submit", rc);
+
+			busy += n;
+			if (debug > 1)
+				printf("io_submit(%d) busy:%d\n", n, busy);
+			if (delay.tv_usec) {
+				struct timeval t = delay;
+				(void)select(0,0,0,0,&t);
+			}
+		}
+
+		/*
+		 * We have submitted all the i/o requests. Wait for at least one to complete
+		 * and call the callbacks.
+		 */
+		count_io_q_waits++;
+		rc = io_wait_run(myctx, 0);
+		if (rc < 0)
+			io_error("io_wait_run", rc);
+
+		if (debug > 1) {
+			printf("io_wait_run: rc == %d\n", rc);
+			printf("busy:%d aio_maxio:%d tocopy:%d\n",
+					busy, aio_maxio, tocopy);
+		}
+	}
+
+	if (srcfd != -1)
+		close(srcfd);
+	if (dstfd != -1)
+		close(dstfd);
+	exit(0);
+}
+
+/* 
+ * Results look like:
+ * [alanm@toolbox ~/MOT3]$ ../taio -d kernel-source-2.4.8-0.4g.ppc.rpm abc
+ * rrrrrrrrrrrrrrrwwwrwrrwwrrwrwwrrwrwrwwrrwrwrrrrwwrwwwrrwrrrwwwwwwwwwwwwwwwww
+ * rrrrrrrrrrrrrrwwwrrwrwrwrwrrwwwwwwwwwwwwwwrrrrrrrrrrrrrrrrrrwwwwrwrwwrwrwrwr
+ * wrrrrrrrwwwwwwwwwwwwwrrrwrrrwrrwrwwwwwwwwwwrrrrwwrwrrrrrrrrrrrwwwwwwwwwwwrww
+ * wwwrrrrrrrrwwrrrwwrwrwrwwwrrrrrrrwwwrrwwwrrwrwwwwwwwwrrrrrrrwwwrrrrrrrwwwwww
+ * wwwwwwwrwrrrrrrrrwrrwrrwrrwrwrrrwrrrwrrrwrwwwwwwwwwwwwwwwwwwrrrwwwrrrrrrrrrr
+ * rrwrrrrrrwrrwwwwwwwwwwwwwwwwrwwwrrwrwwrrrrrrrrrrrrrrrrrrrwwwwwwwwwwwwwwwwwww
+ * rrrrrwrrwrwrwrrwrrrwwwwwwwwrrrrwrrrwrwwrwrrrwrrwrrrrwwwwwwwrwrwwwwrwwrrrwrrr
+ * rrrwwwwwwwrrrrwwrrrrrrrrrrrrwrwrrrrwwwwwwwwwwwwwwrwrrrrwwwwrwrrrrwrwwwrrrwww
+ * rwwrrrrrrrwrrrrrrrrrrrrwwwwrrrwwwrwrrwwwwwwwwwwwwwwwwwwwwwrrrrrrrwwwwwwwrw
+ */
diff --git a/tests/generic/250 b/tests/generic/250
new file mode 100755
index 0000000..0953e26
--- /dev/null
+++ b/tests/generic/250
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 250
+#
+# Create an unwritten extent, set up dm-error, try a DIO write, then
+# make sure we can't read back old disk contents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$testdir"
+    _dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+_require_dm_target error
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+"$XFS_IO_PROG" -d -c "pwrite -S 0x69 -b 1048576 0 $((64 * 1048576))" "$SCRATCH_DEV" >> "$seqres.full"
+_scratch_mkfs_sized $((64 * 1048576)) > "$seqres.full" 2>&1
+_dmerror_init
+_dmerror_mount >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+#"$XFS_IO_PROG" -c "extsize $((blksz * bsz))" "$testdir" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/250.out b/tests/generic/250.out
new file mode 100644
index 0000000..710c80e
--- /dev/null
+++ b/tests/generic/250.out
@@ -0,0 +1,10 @@
+QA output created by 250
+Format and mount
+Create the original files
+Compare files
+ec8bb3b24d5b0f1b5bdf8c8f0f541ee6  SCRATCH_MNT/test-250/file2
+CoW and unmount
+pwrite64: Input/output error
+Compare files
+3ed86318f4ff8da26c1c2a6e3041f9be  SCRATCH_MNT/test-250/file2
+Check for damage
diff --git a/tests/generic/252 b/tests/generic/252
new file mode 100755
index 0000000..535b34b
--- /dev/null
+++ b/tests/generic/252
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 252
+#
+# Create an unwritten extent, set up dm-error, try an AIO DIO write, then
+# make sure we can't read back old disk contents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$testdir" "$TEST_DIR/moo"
+    _dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmerror
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch
+_require_dm_target error
+_require_xfs_io_command "falloc"
+AIO_TEST="src/aio-dio-regress/aiocp"
+test -x "$AIO_TEST" || _notrun "aiocp not built"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+"$XFS_IO_PROG" -d -c "pwrite -S 0x69 -b 1048576 0 $((64 * 1048576))" "$SCRATCH_DEV" >> "$seqres.full"
+_scratch_mkfs_sized $((64 * 1048576)) > "$seqres.full" 2>&1
+_dmerror_init
+_dmerror_mount >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+#"$XFS_IO_PROG" -c "extsize $((blksz * bsz))" "$testdir" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
+sync
+_dmerror_load_error_table
+"$AIO_TEST" -f DIRECT -b $((blksz * bsz)) "$TEST_DIR/moo" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/252.out b/tests/generic/252.out
new file mode 100644
index 0000000..3bc78c2
--- /dev/null
+++ b/tests/generic/252.out
@@ -0,0 +1,10 @@
+QA output created by 252
+Format and mount
+Create the original files
+Compare files
+ec8bb3b24d5b0f1b5bdf8c8f0f541ee6  SCRATCH_MNT/test-252/file2
+CoW and unmount
+write missed bytes expect 8388608 got 0
+Compare files
+3ed86318f4ff8da26c1c2a6e3041f9be  SCRATCH_MNT/test-252/file2
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index 860ff4a..1767484 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -252,7 +252,9 @@
 247 auto quick rw
 248 auto quick rw
 249 auto quick rw
+250 auto quick
 251 ioctl trim
+252 auto quick
 255 auto quick prealloc
 256 auto quick
 257 dir auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
