Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95A417CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 09:00:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 62BD9304039
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:00:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FqYbfB3wvFroIeel (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 07:00:31 -0800 (PST)
Date: Mon, 16 Nov 2015 10:00:29 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: AIO read returns negative number for bytes read
Message-ID: <20151116150028.GA60592@bfoster.bfoster>
References: <564883BD.8070607@scylladb.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <564883BD.8070607@scylladb.com>
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
To: Avi Kivity <avi@scylladb.com>
Cc: linux-aio@kvack.org, xfs@oss.sgi.com

On Sun, Nov 15, 2015 at 03:08:13PM +0200, Avi Kivity wrote:
> Due to a bug in my program, I initiated a read beyond eof. Specifically, the
> file size is 13002 bytes and the read offset is 13312 (0x3400).
> 
> I would expect such a read to return 0 bytes read, but io_getevents returns
> -310, which is suspiciously equal to (13002 - 13312).
> 
> I attach a reproducer.
> 
> 4.2.5-201.fc22.x86_64
> 
> Are my expectations incorrect, or is this a bug in aio or xfs?

FWIW, I added some printk()'s and reproduced. This looks like a dio
issue to me (a sync dio read reproduces just the same as aio). See the
short read check in dio_complete():


	...
        /* Check for short read case */
        if ((dio->rw == READ) && ((offset + transferred) > dio->i_size))
                transferred = dio->i_size - offset;
	...

So if offset starts beyond i_size, we set transferred to a negative
value. I suppose we could check for offset >= i_size here independently,
but I'm not necessarily sure something earlier doesn't need to change
(e.g., I see dio->result = 3072 in this case and I'm not familiar enough
with core dio to know if that's expected).

Brian

> #define _GNU_SOURCE
> 
> #include <libaio.h>
> #include <assert.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <sys/stat.h>
> #include <fcntl.h>
> 
> int main(int ac, char** av) {
>   int fd;
>   char* buf;
>   io_context_t ioc = NULL;
>   int r;
>   struct iocb iocb;
>   struct iocb *iocbp[1];
>   struct io_event ioev;
> 
>   buf = aligned_alloc(4096, 4096*4);
>   assert(buf);
>   r = io_setup(1, &ioc);
>   assert(r == 0);
>   fd = open("tmp.tmp", O_RDWR | O_CREAT | O_DIRECT, 0600);
>   assert(fd >= 0);
>   io_prep_pwrite(&iocb, fd, buf, 4096*4, 0);
>   iocbp[0] = &iocb;
>   r = io_submit(ioc, 1, iocbp);
>   assert(r == 1);
>   r = io_getevents(ioc, 1, 1, &ioev, NULL);
>   assert(r == 1);
>   assert(ioev.res == 4*4096);
>   ftruncate(fd, 13002);
>   io_prep_pread(&iocb, fd, buf, 8192, 13312);
>   r = io_submit(ioc, 1, iocbp);
>   assert(r == 1);
>   r = io_getevents(ioc, 1, 1, &ioev, NULL);
>   assert(r == 1);
>   printf("read result: %d\n", (int)ioev.res);
>   return 0;
> }

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
