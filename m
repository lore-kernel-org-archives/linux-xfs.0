Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3KILrN2108169 for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 13:21:53 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D511112B955B
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 11:25:18 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id jTeqoh7VkAo6j9UW for
	<xfs@oss.sgi.com>; Wed, 20 Apr 2011 11:25:18 -0700 (PDT)
From: Chris Mason <chris.mason@oracle.com>
Subject: buffered writeback torture program
Date: Wed, 20 Apr 2011 14:23:29 -0400
Message-Id: <1303322378-sup-1722@think>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com, jack@suse.cz
Cc: axboe@kernel.dk

Hi everyone,

I dug out my old fsync latency tester to make sure Jens' new plugging
code hadn't caused regressions.  This started off as a program Ted wrote
during the firefox dark times, and I added some more code to saturate
spindles with random IO.

The basic idea is:

1) make a nice big sequential 8GB file
2) fork a process doing random buffered writes inside that file
3) overwrite a second 4K file in a loop, doing fsyncs as you go.

The test program times how long each write and fsync take in step three.
The idea is that if we have problems with concurrent buffered writes and
fsyncs, then all of our fsyncs will get stuck behind the random IO
writeback and our latencies will be high.

For a while, xfs, btrfs and ext4 did really well at this test.  Our
fsync latencies were very small and we all sent down synchronous IO that
the elevator dispatched straight to the drive.

Things have changed though, both xfs and ext4 have grown code to do
dramatically more IO than write_cache_pages has asked for (I'm pretty
sure I told everyone this was a good idea at the time).  When doing
sequential writes, this is a great idea.  When doing random IO, it leads
to unbound stalls in balance_dirty_pages.

Here's an example run on xfs:

# fsync-tester
setting up random write file
done setting up random write file
starting fsync run
starting random io!
write time 0.0009s fsync time: 2.0142s
write time 128.9305s fsync time: 2.6046s
run done 2 fsyncs total, killing random writer

In this case the 128s spent in write was on a single 4K overwrite on a
4K file.

ext4 is doing a blanket increase on wbc->nr_to_write, while xfs is
pushing down any other IO inside the same extent as the writepage it
just serviced.  The test program ends up being a worst case for both of
them.

I honestly don't know what the right answer is here, but I'd say we
should be backing off our nr_to_write bumps if we notice a lot of random
IO.

Btrfs does bump wbc->nr_to_write as well, but only as far as we have
sequential IO to process.  We also end up throttling the random IO
harder because it is a worst case for our delayed allocation reservation
code.

The test program is below, and can also be found at:

http://oss.oracle.com/~mason/fsync-tester.c

Usage: gcc -Wall -o fsync-tester fsync-tester.c

mkfs.your_favorite /dev/xxx
mount /dev/xxx /mnt
cd /mnt
fsync-tester

It creates a single 8GB file and one 4K file, so your FS must be at
least that big.

-chris

/*
 * fsync-tester.c
 *
 * Written by Theodore Ts'o, 3/21/09.  Updated by Chris Mason to include
 * the random writer thread
 *
 * This file may be redistributed under the terms of the GNU Public
 * License, version 2.
 */
#define _FILE_OFFSET_BITS 64
#define _XOPEN_SOURCE 500
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <signal.h>
#include <time.h>
#include <fcntl.h>
#include <string.h>

#define SIZE (32768*32)
static char bigbuf[4096];

static float timeval_subtract(struct timeval *tv1, struct timeval *tv2)
{
	return ((tv1->tv_sec - tv2->tv_sec) +
		((float) (tv1->tv_usec - tv2->tv_usec)) / 1000000);
}

static void random_io(int fd, loff_t total)
{
	loff_t cur = 0;
	int ret;

	/* just some constant so our runs are always the same */
	srand(4096);
	while(1) {
		/*
		 * we want a random offset into the file,
		 * but rand only returns max in.  So we make
		 * it a random block number instead, and multiply
		 * by 4096.
		 */
		cur = rand();
		cur = (cur * 4096) % (total - 4096);

		/* align our offset  to 4k */
		cur = cur / 4096;
		cur = cur * 4096;
		ret = pwrite(fd, bigbuf, 4096, cur);
		if (ret < 4096) {
			fprintf(stderr, "short write ret %d cur %llu\n",
				ret, (unsigned long long)cur);
			exit(1);
		}
	}
}

int main(int argc, char **argv)
{
	int	fd;
	struct timeval tv, tv2, start;
	char buf[SIZE];
	pid_t pid;
	loff_t total = ((loff_t)8) * 1024 * 1024 * 1024;
	loff_t cur = 0;
	int rand_fd;
	int ret;
	int i;
	int status;
	struct stat st;

	memset(bigbuf, 0, 4096);

	rand_fd = open("fsync-tester.rnd-file", O_WRONLY|O_CREAT);
	if (rand_fd < 0) {
		perror("open");
		exit(1);
	}

	ret = fstat(rand_fd, &st);
	if (ret < 0) {
		perror("fstat");
		exit(1);
	}

	if (st.st_size < total) {
		printf("setting up random write file\n");
		while(cur < total) {
			ret = write(rand_fd, bigbuf, 4096);
			if (ret <= 0) {
				fprintf(stderr, "short write\n");
				exit(1);
			}
			cur += ret;
		}
		printf("done setting up random write file\n");
	}

	fd = open("fsync-tester.tst-file", O_WRONLY|O_CREAT);
	if (fd < 0) {
		perror("open");
		exit(1);
	}
	memset(buf, 'a', SIZE);

	pid = fork();
	if (pid == 0) {
		printf("starting random io!\n");
		random_io(rand_fd, total);
		exit(0);
	}

	close(rand_fd);

	gettimeofday(&start, NULL);
	printf("starting fsync run\n");
	for(i = 0; i < 60; i++) {
		float pwrite_time;

		gettimeofday(&tv2, NULL);
		pwrite(fd, buf, SIZE, 0);
		gettimeofday(&tv, NULL);

		pwrite_time = timeval_subtract(&tv, &tv2);

		fsync(fd);
		gettimeofday(&tv2, NULL);

		printf("write time: %5.4fs fsync time: %5.4fs\n", pwrite_time,
		       timeval_subtract(&tv2, &tv));

		if (timeval_subtract(&tv2, &start) > 60)
			break;
		sleep(4);
	}
	printf("run done %d fsyncs total, killing random writer\n", i + 1);
	fflush(stdout);
	kill(pid, SIGTERM);
	wait(&status);

	return 0;
}



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
