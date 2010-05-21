Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4LDfxaL009982 for <xfs@oss.sgi.com>; Fri, 21 May 2010 08:42:00 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87CC91571A76
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 06:45:36 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id DJCVl4bevd3CSoCf
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 06:45:36 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 50B5A6C264
	for <xfs@oss.sgi.com>; Fri, 21 May 2010 08:44:17 -0500 (CDT)
Message-ID: <4BF68E74.8040305@hardwarefreak.com>
Date: Fri, 21 May 2010 08:45:24 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Tuning XFS for real time audio on a laptop with encrypted LVM
References: <AANLkTilJD2Jfr4W97BiAlyc_7C9jLEhEzuEWSDyVKXYP@mail.gmail.com>	<20100521041415.GW8120@dastard>
	<4BF62766.8070105@hardwarefreak.com>
	<AANLkTinobXUKRN0s_3Ia-5XBix05Tvhp36K5fUsysjh-@mail.gmail.com>
In-Reply-To: <AANLkTinobXUKRN0s_3Ia-5XBix05Tvhp36K5fUsysjh-@mail.gmail.com>
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
To: xfs@oss.sgi.com

Pedro Ribeiro put forth on 5/21/2010 6:29 AM:
 
> So it is agreed that CFQ sucks right now. I'll continue my testing but
> now with proper daily use to see which is better, deadline or noop.

I'd be curious to see what your seek performance is with each elevator on that laptop drive.  Give this basic parallel seek tester a spin.

Make runs with 1, 8, 16, 32, and 64 threads to find peak seek throughput and number of threads required to reach it.  Each run takes about 30 seconds.  For 7.2k rpm and up mechanical drives and SSDs you'd want to test 128 and 256 threads also.  Due to the threaded nature good command queuing will have a substantial effect on results, as will elevator choice on some systems.  For background info and evolution of this code, see this thread:  http://www.linuxinsight.com/how_fast_is_your_disk.html

compile with:
gcc -o seeker_baryluk -O2 -march=native seeker_baryluk.c -pthread

run command:
./seeker_baryluk device number_of_threads

A nice feature is that you can test an entire drive or individual partitions (or an entire SAN LUN or just partitions on said LUN).  This can tell you how much slower inner cylinders are compared to outer cylinders, and even works for local RAID and SAN LUNs.

./seeker_baryluk /dev/sda 64
./seeker_baryluk /dev/sda2 64
...
./seeker_baryluk /dev/sda9 64

I find this a much more informative simple test of storage subsystem performance than something like hdparm which is very small sequential I/O.

--- seeker_baryluk.c ---

#define _LARGEFILE64_SOURCE

#ifndef _REENTRANT
#define _REENTRANT
#endif
#include <pthread.h>

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <errno.h>
#include <time.h>
#include <signal.h>
#include <sys/fcntl.h>
#include <sys/ioctl.h>
#include <linux/fs.h>

#define BLOCKSIZE 512
#define TIMEOUT 30

pthread_mutex_t muteks = PTHREAD_MUTEX_INITIALIZER;

int count;
time_t start;
off64_t maxoffset = 0;
off64_t minoffset = 249994674176000uLL;


int threads;

typedef struct {
	int id;
	int fd;
	int run;
	char* filename;
	unsigned int seed;
	unsigned long long numbytes;
	char* buffer;
	int count;
	off64_t maxoffset;
	off64_t minoffset;
} parm;

parm *p;

void done() {
	int i;
	time_t end;

	time(&end);

	if (end < start + TIMEOUT) {
		printf(".");
		alarm(1);
		return;
	}

	for (i = 0; i < threads; i++) {
		p[i].run = 0;
	}
}

void report() {
	if (count) {
		printf(".\nResults: %d seeks/second, %.3f ms random access time (%llu < offsets < %llu)\n",
			count / TIMEOUT, 1000.0 * TIMEOUT / count, (unsigned long long)minoffset, (unsigned long long)maxoffset);
	}
	exit(EXIT_SUCCESS);
}

void handle(const char *string, int error) {
	if (error) {
		perror(string);
		exit(EXIT_FAILURE);
	}
}

void* f(void *arg) {
	int retval;
	off64_t offset;

	parm *p = (parm*)arg;

	srand(p->seed);

	/* wait for all processes */
	pthread_mutex_lock(&muteks);
	pthread_mutex_unlock(&muteks);

	while (p->run) {
		offset = (off64_t) ( (unsigned long long) (p->numbytes * (rand_r(&(p->seed)) / (RAND_MAX + 1.0) )));
		//printf("%d %llu\n", p->id, (unsigned long long )offset);
		retval = lseek64(p->fd, offset, SEEK_SET);
		handle("lseek64", retval == (off64_t) -1);
		retval = read(p->fd, p->buffer, BLOCKSIZE);
		handle("read", retval < 0);

		p->count++;
		if (offset > p->maxoffset) {
			p->maxoffset = offset;
		} else if (offset < p->minoffset) {
			p->minoffset = offset;
		}
	}

	//pthread_exit(NULL);
	return NULL;
}

int main(int argc, char **argv) {
	int fd, retval;
	int physical_sector_size = 0;
	size_t logical_sector_size = 0ULL;
	unsigned long long numblocks, numbytes;
	unsigned long long ull;
	unsigned long ul;
	pthread_t *t_id;
	pthread_attr_t pthread_custom_attr;
	int i;

	setvbuf(stdout, NULL, _IONBF, 0);

	printf("Seeker v3.0, 2009-06-17, "
	       "http://www.linuxinsight.com/how_fast_is_your_disk.html\n");

	if (!(argc == 2 || argc == 3)) {
		printf("Usage: %s device [threads]\n", argv[0]);
		exit(1);
	}

	threads = 1;
	if (argc == 3) {
		threads = atoi(argv[2]);
	}

	//pthread_mutex_init(&muteks, NULL); 

	fd = open(argv[1], O_RDONLY | O_LARGEFILE);
	handle("open", fd < 0);

#ifdef BLKGETSIZE64
	retval = ioctl(fd, BLKGETSIZE64, &ull);
	numbytes = (unsigned long long)ull;
#else
	retval = ioctl(fd, BLKGETSIZE, &ul);
	numbytes = (unsigned long long)ul;
#endif
	handle("ioctl", retval == -1);
	retval = ioctl(fd, BLKBSZGET, &logical_sector_size);
	handle("ioctl", retval == -1 && logical_sector_size > 0);
	retval = ioctl(fd, BLKSSZGET, &physical_sector_size);
	handle("ioctl", retval == -1 && physical_sector_size > 0);
	numblocks = ((unsigned long long)numbytes)/(unsigned long long)BLOCKSIZE;
	printf("Benchmarking %s [%llu blocks, %llu bytes, %llu GB, %llu MB, %llu GiB, %llu MiB]\n",
		argv[1], numblocks, numbytes, numbytes/(1024uLL*1024uLL*1024uLL), numbytes / (1024uLL*1024uLL), numbytes/(1000uLL*1000uLL*1000uLL), numbytes / (1000uLL*1000uLL));
	printf("[%d logical sector size, %d physical sector size]\n", physical_sector_size, physical_sector_size);
	printf("[%d threads]\n", threads);
	printf("Wait %d seconds", TIMEOUT);

	t_id = (pthread_t *)malloc(threads*sizeof(pthread_t));
	handle("malloc", t_id == NULL);
	pthread_attr_init(&pthread_custom_attr);
	p = (parm *)malloc(sizeof(parm)*threads);
	handle("malloc", p == NULL);

	time(&start);

	pthread_mutex_lock(&muteks);


	srand((unsigned int)start*(unsigned int)getpid());

	for (i = 0; i < threads; i++) {
		p[i].id = i;
		p[i].filename = argv[1];
		p[i].seed = rand()+i;
		p[i].fd = dup(fd);
		handle("dup", p[i].fd < 0);
		p[i].buffer = malloc(sizeof(char)*BLOCKSIZE);
		p[i].numbytes = numbytes;
		handle("malloc", p[i].buffer == NULL);
		p[i].run = 1;
		p[i].count = 0;
		p[i].minoffset = minoffset;
		p[i].maxoffset = maxoffset;

		retval = pthread_create(&(t_id[i]), NULL, f, (void*)(p+i));
		handle("pthread_create", retval != 0);
	}

	sleep(1);

	time(&start);
	signal(SIGALRM, &done);
	alarm(1);

	pthread_mutex_unlock(&muteks);

	for (i = 0; i < threads; i++) {
		pthread_join(t_id[i], NULL);
	}

	for (i = 0; i < threads; i++) {
		count += p[i].count;
		if (p[i].maxoffset > maxoffset) {
			maxoffset = p[i].maxoffset;
		}
		if (p[i].minoffset < minoffset) {
			minoffset = p[i].minoffset;
		}
	}

	report();

	/* notreached */
	return 0;
}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
