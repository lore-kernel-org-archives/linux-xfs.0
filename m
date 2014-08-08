Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 28A927F74
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 09:35:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1671A304062
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 07:35:50 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id bGSBu67MVNsVKP4X
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 07:35:50 -0700 (PDT)
Message-ID: <53E4E03A.7050101@fb.com>
Date: Fri, 8 Aug 2014 10:35:38 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: don't zero partial page cache pages during O_DIRECT
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>


xfs is using truncate_pagecache_range to invalidate the page cache
during DIO reads.  This is different from the other filesystems who only
invalidate pages during DIO writes.

truncate_pagecache_range is meant to be used when we are freeing the
underlying data structs from disk, so it will zero any partial ranges
in the page.  This means a DIO read can zero out part of the page cache
page, and it is possible the page will stay in cache.

buffered reads will find an up to date page with zeros instead of the
data actually on disk.

This patch fixes things by leaving the page cache alone during DIO
reads.

We discovered this when our buffered IO program for distributing
database indexes was finding zero filled blocks.  I think writes
are broken too, but I'll leave that for a separate patch because I don't
fully understand what XFS needs to happen during a DIO write.

Test program:

/*
 * gcc -Wall -o read-race read-race.c
 * ./read-race filename
 */
#define _XOPEN_SOURCE 600
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/time.h>

#ifndef O_DIRECT
#define O_DIRECT	00040000
#endif

#define READ_SIZE 512
#define BUF_SIZE 1024 * 1024

static void usage(char *name)
{
	fprintf(stderr, "usage: %s filename\n", name);
	exit(1);
}

/* return 1 if the buffer is full of zeros */
static int all_zeros(char *buf, int sz)
{
	int i;
	for (i = 0; i < sz; i++) {
		if (*buf++)
			return 0;
	}
	return 1;
}

static void run_test(char *filename, char *buf, int direct)
{
	int fd;
	int ret;
	struct timeval start;
	struct timeval now;

	fd = open(filename, O_RDONLY | direct);
	if (fd < 0) {
		perror("open");
		exit(1);
	}

	/*
	 * seek to a 512b aligned offset in the page and then do a
	 * read.  Check the read for zeros, and if we're buffered
	 * use FADV_DONTNEED to drop the page cache.  repeat for 15 seconds
	 */
	gettimeofday(&start, NULL);
	while (1) {
		ret = lseek(fd, 5120, SEEK_SET);
		if (ret < 0) {
			perror("lseek");
			exit(1);
		}
		if (!direct) {
			ret = posix_fadvise(fd, 0, 8192, POSIX_FADV_DONTNEED);
			if (ret) {
				perror("fadvise");
				exit(1);
			}
		}
		ret = read(fd, buf, READ_SIZE);
		if (ret < READ_SIZE) {
			fprintf(stderr, "invalid read\n");
			exit(1);
		}

		if (all_zeros(buf, READ_SIZE)) {
			fprintf(stderr, "error: found zero range direct: %d\n",
				direct ? 1 : 0);
			exit(255);
		}

		gettimeofday(&now, NULL);
		if (now.tv_sec - start.tv_sec > 15)
			exit(0);
	}
}

int main(int ac, char **av)
{
	int ret;
	int fd;
	char *filename;
	char *buf;
	int pagesize = sysconf(_SC_PAGESIZE);
	pid_t buffered_pid = 0;
	pid_t direct_pid = 0;
	pid_t wait_pid;
	int status = 0;
	int test_failure = 0;

	if (ac != 2)
		usage(av[0]);
	else
		filename = av[1];

	ret = posix_memalign((void **)&buf, pagesize, BUF_SIZE);
	if (ret) {
		perror("posix_memalign");
		exit(1);
	}

	/* step one, create our test file and fill with non-zero */
	fd = open(filename, O_WRONLY | O_CREAT, 0700);
	if (fd < 0) {
		perror("open for writing");
		exit(1);
	}
	memset(buf, 1, BUF_SIZE);

	ret = write(fd, buf, BUF_SIZE);
	if (ret != BUF_SIZE) {
		fprintf(stderr, "failed to fill the test file\n");
		exit(1);
	}
	close(fd);

	/* start the buffered reader */
	buffered_pid = fork();
	if (buffered_pid < 0) {
		perror("fork");
		exit(1);
	} else if (buffered_pid == 0) {
		run_test(filename, buf, 0);
		exit(0);
	}

	/* start the direct reader */
	direct_pid = fork();
	if (direct_pid < 0) {
		perror("fork");
		goto cleanup;
	} else if (direct_pid == 0) {
		run_test(filename, buf, O_DIRECT);
		exit(0);
	}

	/* wait for buffered to finish */
	wait_pid = waitpid(buffered_pid, &status, 0);
	if (wait_pid < 0) {
		perror("waitpid buffered");
		goto cleanup;
	}
	if (WIFEXITED(status)) {
		int ret = WEXITSTATUS(status);
		printf("buffered exits with %d\n", ret);
		if (ret) {
			buffered_pid = 0;
			test_failure = ret;
			goto cleanup;
		}
	} else {
		test_failure = 1;
	}


	/* wait for direct to finish */
	wait_pid = waitpid(direct_pid, &status, 0);
	if (wait_pid < 0) {
		perror("waitpid direct");
		goto cleanup;
	}
	if (WIFEXITED(status)) {
		int ret = WEXITSTATUS(status);
		printf("direct exits with %d\n", ret);
		test_failure |= ret;
	} else {
		test_failure |= 1;
	}

	exit(test_failure);

cleanup:

	if (direct_pid > 0)
		kill(direct_pid, SIGTERM);
	if (buffered_pid > 0)
		kill(buffered_pid, SIGTERM);

	exit(test_failure);
}

Signed-off-by: Chris Mason <clm@fb.com>
cc: stable@vger.kernel.org

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1f66779..8d25d98 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -295,7 +295,11 @@ xfs_file_read_iter(
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
 			}
-			truncate_pagecache_range(VFS_I(ip), pos, -1);
+
+			/* we don't remove any pages here.  A direct read
+			 * does not invalidate any contents of the page
+			 * cache
+			 */
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
