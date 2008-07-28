Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Jul 2008 21:35:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6S4Z2r0026062
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 21:35:03 -0700
Received: from serv2.oss.ntt.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 444FDEB30A8
	for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 21:36:13 -0700 (PDT)
Received: from serv2.oss.ntt.co.jp (serv2.oss.ntt.co.jp [222.151.198.100]) by cuda.sgi.com with ESMTP id yuOJiO2zsG1DcrgV for <xfs@oss.sgi.com>; Sun, 27 Jul 2008 21:36:13 -0700 (PDT)
Message-Id: <6.0.0.20.2.20080728115511.045088a8@172.19.0.2>
Date: Mon, 28 Jul 2008 13:34:12 +0900
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: partially uptodate page reads
In-Reply-To: <20080724120841.81c72be9.akpm@linux-foundation.org>
References: <200807250117.11331.nickpiggin@yahoo.com.au>
 <20080724175913.GA32117@infradead.org>
 <20080724120841.81c72be9.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, jack@ucw.cz, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi

>> > 
>> > Are there significant numbers of people using block size < page size in
>> > situations where performance is important and significantly improved by
>> > this patch? Can you give any performance numbers to illustrate perhaps?
>> 
>> With XFS lots of people use 4k blocksize filesystems on ia64 systems
>> with 16k pages, so an optimization like this would be useful.
>
>As Nick says, we really should have some measurement results which
>confirm this theory.  Maybe we did do some but they didn't find theor
>way into the changelog.
>
>I've put the patch on hold until this confirmation data is available.
>

I've got some performance number.
I wrote a benchmark program and got result number with this program.
This benchmark do:
	1, mount and open a test file.
	2, create a 512MB file.
	3, close a file and umount.
	4, mount and again open a test file.
	5, pwrite randomly 300000 times on a test file. offset is aligned by IO size(1024bytes).
	6, measure time of preading randomly 100000 times on a test file.

The result was:
	2.6.26
        330 sec

	2.6.26-patched
        226 sec

Arch:i386 
Filesystem:ext3
Blocksize:1024 bytes
Memory: 1GB

On ext3/4, a file is written through buffer/block. So random read/write mixed workloads
or random read after random write workloads are optimized with this patch under 
pagesize != blocksize environment. This test result showed this.


The benchmark program is as follows:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>

#define LEN 1024
#define LOOP 1024*512 /* 512MB */

main(void)
{
	unsigned long i, offset, filesize;
	int fd;
	char buf[LEN];
	time_t t1, t2;

	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	memset(buf, 0, LEN);
	fd = open("/root/test1/testfile", O_CREAT|O_RDWR|O_TRUNC);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}
	for (i = 0; i < LOOP; i++)
		write(fd, buf, LEN);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	fd = open("/root/test1/testfile", O_RDWR);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}

	filesize = LEN * LOOP;
	for (i = 0; i < 300000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pwrite(fd, buf, LEN, offset);
	}
	printf("start test\n");
	time(&t1);
	for (i = 0; i < 100000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pread(fd, buf, LEN, offset);
	}
	time(&t2);
	printf("%ld sec\n", t2-t1);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
}
