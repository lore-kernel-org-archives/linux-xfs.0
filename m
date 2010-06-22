Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5MCSWBc237975 for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 07:28:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 618621514BC4
	for <xfs@oss.sgi.com>; Tue, 22 Jun 2010 05:31:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id slFGi7Vg4hWxCrOh for
	<xfs@oss.sgi.com>; Tue, 22 Jun 2010 05:31:13 -0700 (PDT)
Message-Id: <20100622122144.302857146@bombadil.infradead.org>
Date: Tue, 22 Jun 2010 08:21:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] Fix aio completion vs unwritten extents
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org

Some filesystems (XFS and ext4) have support for a concept called
unwritten extents, where we can write data into holes / preallocated
space and only mark them as allocated when the data I/O has finished.

Because the transaction to convert the extent can't be submitted from
I/O completion, which normally happens from IRQ context it needs to
be defered to a workqueue.  This is not a problem for buffered I/O
where we keep the data in cache at least until the I/O operation has
finished, but it is an issue for direct I/O.  XFS avoids that problem
for synchronous direct I/O by waiting for all unwritten extent conversions
to finish if we did one during direct I/O, but so far has ignored the
problem for asynchronous I/O.  Unfortunately the race is very easy
to hit by using QEMU with native AIO support on a sparse image, and
the result is filesystem corruption in the guest.

This contains core direct I/O changes to allow the filesystem to delay
AIO completion, as well as a patch to fix XFS.  ext4 also has the same
issue, and from a quick look also doesn't properly complete unwritten
extent conversions for synchronous direct I/O, but I'll leave that
for someone more familar to figure out.

Below is a minimal reproducer for the issue.  Given that we're dealing
with a race condition it doesn't always fail, but in 2 core laptop
it triggers 100% reproducibly in 20 runs in a loop.

---

#define _GNU_SOURCE

#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <libaio.h>

#define BUF_SIZE	4096
#define IO_PATTERN	0xab

int main(int argc, char *argv[])
{
	struct io_context *ctx = NULL;
	struct io_event ev;
	struct iocb iocb, *iocbs[] = { &iocb };
	void *buf;
	char cmp_buf[BUF_SIZE];
	int fd, err = 0;

	fd = open(argv[1], O_DIRECT | O_CREAT | O_TRUNC | O_RDWR, 0600);
	if (fd == -1) {
		perror("open");
		return 1;
	}

	err = posix_memalign(&buf, BUF_SIZE, BUF_SIZE);
	if (err) {
		fprintf(stderr, "error %s during %s\n",
			strerror(-err),
			"posix_memalign");
		return 1;
	}
	memset(buf, IO_PATTERN, BUF_SIZE);
	memset(cmp_buf, IO_PATTERN, BUF_SIZE);

	/*
	 * Truncate to some random large file size.  Just make sure
	 * it's not smaller than our I/O size.
	 */
	if (ftruncate(fd, 1024 * 1024 * 1024) < 0) {
		perror("ftruncate");
		return 1;
	}


	/*
	 * Do a simple 4k write into a hole using aio.
	 */
	err = io_setup(1, &ctx);
	if (err) {
		fprintf(stderr, "error %s during %s\n",
			strerror(-err),
			"io_setup");
		return 1;
	}

	io_prep_pwrite(&iocb, fd, buf, BUF_SIZE, 0);

	err = io_submit(ctx, 1, iocbs);
	if (err != 1) {
		fprintf(stderr, "error %s during %s\n",
			strerror(-err),
			"io_submit");
		return 1;
	}

	err = io_getevents(ctx, 1, 1, &ev, NULL);
	if (err != 1) {
		fprintf(stderr, "error %s during %s\n",
			strerror(-err),
			"io_getevents");
		return 1;
	}

	/*
	 * And then read it back.
	 *
	 * Using pread to keep it simple, but AIO has the same effect.
	 */
	if (pread(fd, buf, BUF_SIZE, 0) != BUF_SIZE) {
		perror("pread");
		return 1;
	}

	/*
	 * And depending on the machine we'll just get zeroes back quite
	 * often here.  That's because the unwritten extent conversion
	 * hasn't finished.
	 */
	if (memcmp(buf, cmp_buf, BUF_SIZE)) {
		unsigned long long *ubuf = (unsigned long long *)buf;
		int i;

		for (i = 0; i < BUF_SIZE / sizeof(unsigned long long); i++)
			printf("%d: 0x%llx\n", i, ubuf[i]);
			
		return 1;
	}

	return 0;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
