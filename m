Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14K45wF237323 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 14:04:05 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mvirDc9k3LcybLw4 for
	<xfs@oss.sgi.com>; Sat, 04 Feb 2012 12:04:03 -0800 (PST)
Message-ID: <4F2D8F30.3090802@redhat.com>
Date: Sat, 04 Feb 2012 14:04:00 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: sparsify - utility to punch out blocks of 0s in a file
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
To: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
"re-sparsify" a file by punching out ranges of 0s might be in order.

I whipped this up fast, it probably has bugs & off-by-ones but thought
I'd send it out.  It's not terribly efficient doing 4k reads by default
I suppose.

I'll see if util-linux wants it after it gets beat into shape.
(or did a tool like this already exist and I missed it?)

(Another mode which does a file copy, possibly from stdin
might be good, like e2fsprogs/contrib/make-sparse.c ?  Although
that can be hacked up with cp already).

It works like this:

[root@inode sparsify]# ./sparsify  -h
Usage: sparsify [-m min hole size] [-o offset] [-l length] filename

[root@inode sparsify]# dd if=/dev/zero of=fsfile bs=1M count=512
[root@inode sparsify]# mkfs.xfs fsfile >/dev/null
[root@inode sparsify]# du -hc fsfile
512M	fsfile
512M	total
[root@inode sparsify]# ./sparsify fsfile
punching out holes of minimum size 4096 in range 0-536870912
[root@inode sparsify]# du -hc fsfile
129M	fsfile
129M	total
[root@inode sparsify]# xfs_repair fsfile
Phase 1 - find and verify superblock...
<snip>
Phase 7 - verify and correct link counts...
done
[root@inode sparsify]# echo $?
0
[root@inode sparsify]# 

/*
 * sparsify - utility to punch out blocks of 0s in a file
 *
 * Copyright (C) 2011 Red Hat, Inc. All rights reserved.
 * Written by Eric Sandeen <sandeen@redhat.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it would be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <string.h>

#include <linux/falloc.h>

#ifndef FALLOC_FL_PUNCH_HOLE
#define FALLOC_FL_PUNCH_HOLE    0x02 /* de-allocates range */
#endif

void usage(void)
{
	printf("Usage: sparsify [-m min hole size] [-o offset] [-l length] filename\n");
	exit(EXIT_FAILURE);
}

#define EXABYTES(x)     ((long long)(x) << 60)
#define PETABYTES(x)    ((long long)(x) << 50)
#define TERABYTES(x)    ((long long)(x) << 40)
#define GIGABYTES(x)    ((long long)(x) << 30)
#define MEGABYTES(x)    ((long long)(x) << 20)
#define KILOBYTES(x)    ((long long)(x) << 10)

#define __round_mask(x, y) ((__typeof__(x))((y)-1))
#define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
#define round_down(x, y) ((x) & ~__round_mask(x, y))

int debug;

long long
cvtnum(char *s)
{
	long long	i;
	char		*sp;
	int		c;

	i = strtoll(s, &sp, 0);
	if (i == 0 && sp == s)
		return -1LL;
	if (*sp == '\0')
		return i;
	if (sp[1] != '\0')
		return -1LL;

	c = tolower(*sp);
	switch (c) {
	case 'k':
		return KILOBYTES(i);
	case 'm':
		return MEGABYTES(i);
	case 'g':
		return GIGABYTES(i);
	case 't':
		return TERABYTES(i);
	case 'p':
		return PETABYTES(i);
	case 'e':
		return  EXABYTES(i);
	}

	return -1LL;
}

int punch_hole(int fd, off_t offset, off_t len)
{
	int error = 0;

	if (debug)
		printf("punching at %lld len %lld\n", offset, len);
	//error = fallocate(fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
	//		  offset, len);
	if (error < 0) {
		perror("punch failed");
		exit(EXIT_FAILURE);
	}
}

int main(int argc, char **argv)
{
	int	fd;
	char	*fname;
	int	opt;
	loff_t	min_hole = 0;
	loff_t	punch_range_start = 0;
	loff_t	punch_range_len = 0;
	loff_t	punch_range_end = 0;
	loff_t	cur_offset = 0;
	unsigned long blocksize;
	struct statvfs statvfsbuf;
	struct stat statbuf;
	ssize_t	ret;
	off_t	punch_offset, punch_len;
	char	*readbuf, *zerobuf;

	while ((opt = getopt(argc, argv, "m:l:o:vh")) != -1) {
		switch(opt) {
		case 'm':
			min_hole = cvtnum(optarg);
			break;
		case 'o':
			punch_range_start = cvtnum(optarg);
			break;
		case 'l':
			punch_range_len = cvtnum(optarg);
			break;
		case 'v':
			debug++;
			break;
		case 'h':
		default:
			usage();
		}
	}

	if (min_hole < 0) {
		printf("Error: invalid min hole value specified\n");
		usage();
	}

	if (punch_range_len < 0) {
		printf("Error: invalid length value specified\n");
		usage();
	}

	if (punch_range_start < 0) {
		printf("Error: invalid offset value specified\n");
		usage();
	}

	if (optind == argc) {
		printf("Error: no filename specified\n");
		usage();
	}

	fname = argv[optind++];

	fd = open(fname, O_RDWR);
	if (fd < 0) {
		perror("Error opening file");
		exit(EXIT_FAILURE);
	}

	if (fstat(fd, &statbuf) < 0) {
		perror("Error stat-ing file");
		exit(EXIT_FAILURE);
	}

	if (fstatvfs(fd, &statvfsbuf) < 0) {
		perror("Error stat-ing fs");
		exit(EXIT_FAILURE);
	}

	blocksize = statvfsbuf.f_bsize;
	if (debug)
		printf("blocksize is %lu\n", blocksize);

	/* default range end is end of file */
	if (!punch_range_len)
		punch_range_end = statbuf.st_size;
	else
		punch_range_end = punch_range_start + punch_range_len;

	if (punch_range_end > statbuf.st_size) {
		printf("Error: range extends past EOF\n");
		exit(EXIT_FAILURE);
	}

	if (debug)
		printf("orig start/end %lld/%lld/%lld\n", punch_range_start, punch_range_end, min_hole);

	/*
	 * Normalize to blocksize-aligned range:
	 * round start down, round end up - get all blocks including the range specified
	 */

	punch_range_start = round_down(punch_range_start, blocksize);
	punch_range_end = round_up(punch_range_end, blocksize);
	min_hole = round_up(min_hole, blocksize);
	if (!min_hole)
		min_hole = blocksize;

	if (debug)
		printf("new start/end/min %lld/%lld/%lld\n", punch_range_start, punch_range_end, min_hole);

	if (punch_range_end <= punch_range_start) {
		printf("Range too small, nothing to do\n");
		exit(0);
	}

	readbuf = malloc(min_hole);
	zerobuf = malloc(min_hole);

	if (!readbuf || !zerobuf) {
		perror("buffer allocation failed");
		exit(EXIT_FAILURE);
	}

	memset(zerobuf, 0, min_hole);

	punch_offset = -1;
	punch_len = 0;

	/* Move to the start of our requested range */
	if (punch_range_start)
		lseek(fd, punch_range_start, SEEK_SET);
	cur_offset = punch_range_start;

	printf("punching out holes of minimum size %lld in range %lld-%lld\n",
		min_hole, punch_range_start, punch_range_end);

	/*
	 * Read through the file, finding block-aligned regions of 0s.
	 * If the region is at least min_hole, punch it out.
	 * This should be starting at a block-aligned offset
	 */

	while ((ret = read(fd, readbuf, min_hole)) > 0) {

		if (!memcmp(readbuf, zerobuf, min_hole)) {
			/* Block of zeros, so extend punch range */
			if (punch_offset < 0)
				punch_offset = cur_offset;
			punch_len += min_hole;
			if (debug > 1)
				printf("found zeros at %lld, hole len now %lld\n", cur_offset, punch_len);
		} else if (punch_offset > 0) {
			/* Found nonzero byte; punch accumulated hole if it's big enough */
 			if (punch_len >= min_hole)
				punch_hole(fd, punch_offset, punch_len);
			else if (debug > 1)
				printf("skipping hole of insufficient size %lld\n", punch_len);

			/* reset punch range */
			punch_offset = -1;
			punch_len = 0;
		}

		cur_offset += ret;
		/* Quit if we've moved beyond the specified range to punch */
		if (cur_offset >= punch_range_end) {
			/* punch out last hole in range if needed */
			if (punch_offset > 0 && punch_len >= min_hole)
				punch_hole(fd, punch_offset, punch_len);
			break;
		}
	}

	if (ret < 0) {
		perror("read failed");
		exit(EXIT_FAILURE);
	}

	free(readbuf);
	free(zerobuf);
	close(fd);
	return 0;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
