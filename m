Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58746 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfBBEcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Feb 2019 23:32:14 -0500
Date: Fri, 1 Feb 2019 20:31:59 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] xfs: cache unlinked pointers in an rhashtable
Message-ID: <20190202043159.GN5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897672012.26065.1375987197453969157.stgit@magnolia>
 <20190201080343.GD22295@infradead.org>
 <20190201235900.GX6173@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201235900.GX6173@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Sat, Feb 02, 2019 at 10:59:00AM +1100, Dave Chinner wrote:
> On Fri, Feb 01, 2019 at 12:03:43AM -0800, Christoph Hellwig wrote:
> > On Thu, Jan 31, 2019 at 03:18:40PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Use a rhashtable to cache the unlinked list incore.  This should speed
> > > up unlinked processing considerably when there are a lot of inodes on
> > > the unlinked list because iunlink_remove no longer has to traverse an
> > > entire bucket list to find which inode points to the one being removed.
> > 
> > This sounds pretty reasonable and a real review will follow.  But can
> > you quantify the considerably speedups for real life workloads?
> 
> When you have more than a few hundred open-but-unlinked inodes in an
> AG, the unlinked list walking starts to take a significant amount of
> time when the final reference to an inode goes away. It's
> essentially an O(N) buffer walk, so takes a lot of CPU time when a
> list gets more than a few inode long.
> 
> With darrick's background inactivation, the lists grow to tens of
> thousands of inodes very quickly. I was seeing >95% of CPU time
> being spend in unlinked list walking on large scale 'rm -rf'
> workloads and performance absolutely dropped off a cliff. My initial
> code (from years and years ago) used a
> double linked list, and when I forward ported that and ran it up,
> the CPU overhead of unlink list removal was cut to almost nothing and
> all the performance regressions with background inactivation went
> away. i.e. Unlink list removal went from an O(N) overhead to always
> being O(1), so the length of the list didnt' affect performance any
> more.
> 
> Darrick's code replaces the list_head in each inode I used with a
> rhashtable - it removes the 16 bytes per-inode memory footprint my
> implementation required, but otherwise is identical.  Hence I expect
> that it'll show exactly the same performance characteristics as the
> existing code.
> 
> IOWs, it's really required for backgrounding and parallelising inode
> inactivation, but otherwise it won't make any noticable/measurable
> difference to most workloads because the unlinked lists almost never
> grows more than one inode in length and so O(N) ~= O(1) almost all
> the time...

I wrote a silly program to open as many O_TMPFILE files as it can and
then close them all.  I wrapped that in a script to crank up ulimit -n
to fs.file_max (which on this VM was about 194000 files) and came up
with this on a 5.0-rc4 kernel with deferred inactivation and iunlink
backref caching:

+ /d/t/tmpfile/tmpfile
Opened 193519 files in 6.44s.
Closed 193519 files in 1.37s

real    0m7.818s
user    0m0.083s
sys     0m7.373s
+ cd /
+ umount /mnt

real    0m5.681s
user    0m0.008s
sys     0m0.000s

I then repeated the experiment with a vanilla 5.0-rc2 kernel I had lying
around and saw much slower results:

+ /d/t/tmpfile/tmpfile
Opened 193588 files in 6.35s.
Closed 193588 files in 751.61s

real    12m38.853s
user    0m0.084s
sys     12m34.470s
+ cd /
+ umount /mnt

real    0m0.086s
user    0m0.000s
sys     0m0.060s

The VM had 2G of RAM and a 3GB SCSI disk backed by a tmpfs file.

--D

Wrapper script:

#!/bin/bash -x

dir="$(dirname "$0")"

umount /mnt
rmmod xfs
mkfs.xfs -f /dev/sda
mount /dev/sda /mnt

ulimit -n $(cat /proc/sys/fs/file-max)

cd /mnt
time $dir/tmpfile
cd /
time umount /mnt

and tmpfile.c:

/* Open files and leak them. */
#define _GNU_SOURCE
#include <time.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>

static int min_fd = -1;
static int max_fd = -1;
static unsigned int nr_opened = 0;
static float start_time;

void clock_time(float *time)
{
	static clockid_t clkid = CLOCK_MONOTONIC;
	struct timespec ts;
	int ret;

retry:
	ret = clock_gettime(clkid, &ts);
	if (ret) {
		if (clkid == CLOCK_MONOTONIC) {
			clkid = CLOCK_REALTIME;
			goto retry;
		}
		perror("clock_gettime");
		exit(2);
	}
	*time = ts.tv_sec + ((float)ts.tv_nsec / 1000000000);
}

/*
 * Exit the program due to an error.
 *
 * If we've exhausted all the file descriptors, make sure we close all the
 * open fds in the order we received them in order to exploit a quirk of ext4
 * and xfs where the oldest unlinked inodes are at the /end/ of the unlinked
 * lists, which will make removing the unlinked files maximally painful.
 *
 * If it's some other error, just die and let the kernel sort it out.
 */
void die(void)
{
	float end_time;
	int fd;

	switch (errno) {
	case EMFILE:
	case ENFILE:
	case ENOSPC:
		clock_time(&end_time);
		printf("Opened %u files in %.2fs.\n", nr_opened,
				end_time - start_time);
		clock_time(&start_time);

		for (fd = min_fd; fd <= max_fd; fd++)
			close(fd);
		clock_time(&end_time);
		printf("Closed %u files in %.2fs\n", nr_opened,
				end_time - start_time);
		exit(0);
		break;
	default:
		perror("open?");
		exit(2);
		break;
	}
}

/* Remember how many file we open and all that. */
void remember_fd(int fd)
{
	if (min_fd == -1 || min_fd > fd)
		min_fd = fd;
	if (max_fd == -1 || max_fd < fd)
		max_fd = fd;
	nr_opened++;
}

/* Put an opened file on the unlinked list and leak the fd. */
void leak_tmpfile(void)
{
	int fd = -1;
	int ret;

	/* Try to create an O_TMPFILE and leak the fd. */
#ifdef O_TMPFILE
	fd = open(".", O_TMPFILE | O_RDWR, 0644);
	if (fd >= 0) {
		remember_fd(fd);
		return;
	}
	if (fd < 0)
		die();
#endif

	/* Oh well, create a new file, unlink it, and leak the fd. */
	fd = open("./moo", O_CREAT | O_RDWR, 0644);
	if (fd < 0)
		die();
	ret = unlink("./moo");
	if (ret)
		die();
	remember_fd(fd);
}

/* Try to put as many files on the unlinked list and then kill them. */
int main(int argc, char *argv[])
{
	clock_time(&start_time);
	while (1)
		leak_tmpfile();
	return 0;
}
