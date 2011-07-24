Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OB6BZu204785 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:06:11 -0500
Message-ID: <4E2BFC9C.3060902@gmail.com>
Date: Sun, 24 Jul 2011 14:06:04 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: BUG: unable to handle kernel paging request xfs_is_delayed_page
References: <4E289228.4000208@gmail.com>
	<201107240914.04145.maciej.rutecki@gmail.com>
In-Reply-To: <201107240914.04145.maciej.rutecki@gmail.com>
Content-Type: multipart/mixed; boundary="------------070707050002040803000702"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: maciej.rutecki@gmail.com
Cc: xfs-masters@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------070707050002040803000702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 07/24/2011 10:14 AM, Maciej Rutecki wrote:
> On czwartek, 21 lipca 2011 o 22:55:04 Török Edwin wrote:
>> Hi,
>>
>> Just got this BUG in my dmesg:
>> [47504.938446] BUG: unable to handle kernel paging request at
>> ffff884058ec3270 [47504.938488] IP: [<ffffffff8127baf1>]
> [...]
> 
> 2.6.39 works OK?. It is regression?

I don't know, I was not able to reproduce the bug on 3.0 either.
Either the bug was fixed between 3.0-rc7 and 3.0, or it is very hard to reproduce.

I tried with the attached test program (which creates a mess^H some files in the current directory, performs I/O and dumps core
from 2 processes in parallel.).

All I got was 2 hung kernel threads for 2m+ in xfs_evict_inode + xfs_file_sync, trigerring the hung_check timer and NMI backtraces,
and the process was unkillable (by kill -9) for a while. It eventually recovered though, and its not surprising that this happened
: the test program generated 100Mb/s - 500Mb/s I/O.

I'll have to see if I can reproduce the BUG with 3.0-rc7. Although I don't see any XFS changes between 3.0-rc7 and 3.0
there were some RCU fixes to core VFS code.

Best regards,
--Edwin

--------------070707050002040803000702
Content-Type: text/x-csrc;
 name="alloc4.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alloc4.c"

#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
#include <errno.h>

void alloc_and_die(void)
{
    uint64_t i;
    uint64_t n = 4*1024*1024*1024ll;
    char *x = malloc(n);
    printf("touching pages\n");
    /* touch each page once */
    for (i=0;i<n;i += 4096) {
	x[i] = 42;
    }
    /* wait a bit */
    printf("sleeping\n");
    /* parallel coredump */
    fork();
    sleep(10);
    printf("Dumping core...\n");
    /* now die */
    abort();
}

void *iothread(void *dummy)
{
    uint16_t data[4000];
    char fname[128] = "iothreadXXXXXX";
    unsigned int seed = 0x42;
    unsigned i;
    uint64_t pos = 0;
    unsigned counter = 0;

    int fd = mkstemp(fname);

    if (fd == -1) {
	perror("mkstemp");
	abort();
    }

    for (i=0;i<sizeof(data)/sizeof(data[0]);i++) {
	data[i] = rand_r(&seed);
    }
    /* continously write to a 1MB sized file */
    while (1) {
	if (write(fd, data, sizeof(data)) != sizeof(data)) {
	    perror("write failed");
	    abort();
	}
	pos += sizeof(data);
	if (pos > 10*1024*1024ll) {
	    counter++;
	    if (counter%2) {
		fsync(fd);
		lseek(fd, 0, SEEK_SET);
	    } else {
		unlink(fname);
		close(fd);
		strncpy(fname, "iothreadXXXXXX", sizeof(fname));
		fd = mkstemp(fname);
		if (fd == -1) {
		    perror("mkstemp");
		    abort();
		}
	    }
	    for (i=0;i<sizeof(data)/sizeof(data[0]);i++) {
		data[i] = rand_r(&seed);
	    }
	}
    }

    return NULL;
}

void run_iothread(void)
{
    pthread_t thr;
    int rc;
    rc = pthread_create(&thr, NULL,
			iothread, NULL);
    if (rc) {
	errno = rc;
	perror("pthread_create");
	abort();
    }
}

int main()
{
    switch (fork()) {
	case 0:
	    run_iothread();
	    run_iothread();
	    alloc_and_die();
	    break;
	case -1:
	    perror("fork failed\n");
	    abort();
	    break;
	default:
	    run_iothread();
	    run_iothread();
	    run_iothread();
	    run_iothread();
	    iothread(NULL);
	    break;
    }
    return 0;
}


--------------070707050002040803000702
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------070707050002040803000702--
