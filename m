Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D3B8D29DF7
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 21:21:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 659ADAC001
	for <xfs@oss.sgi.com>; Sat, 15 Mar 2014 19:21:12 -0700 (PDT)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id jqMW65hKUP3kmVIB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 15 Mar 2014 19:21:07 -0700 (PDT)
Date: Sun, 16 Mar 2014 02:21:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: fs corruption exposed by "xfs: increase prealloc size to double
	that of the previous extent"
Message-ID: <20140316022105.GQ18016@ZenIV.linux.org.uk>
References: <20140315210216.GP18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140315210216.GP18016@ZenIV.linux.org.uk>
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
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Sat, Mar 15, 2014 at 09:02:16PM +0000, Al Viro wrote:

> And that's essentially what makes generic/263 complain.  Note, BTW, that
> fallocate and hole-punching is irrelevant - test in generic/263 steps into
> those, but the same thing happens with these operations disabled (by -F -H).
> 
> I've found the thread from last June where you've mentioned generic/263
> regression; AFAICS, Dave's comments there had been wrong...

BTW, experimenting with that thing shows that junk in the tail of the page
actually comes from some unused sectors on the same device.  So it's an
information leak at the very least - I have seen it pick bits and pieces of
previously removed files that way.

While we are at it, the following creates such a buggered file in about
a half of runs:

#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>
#define O_DIRECT 00040000

main()
{
        int n = 0x5cf2e - 0x47000;
        int fd = open("/mnt/junk", O_RDWR|O_CREAT|O_TRUNC|O_DIRECT, 0666);
        char *p;
        ftruncate(fd, 0x5cf2e);
        p = mmap(NULL, n, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0x47000);
        memset(p, 'x', n);
        msync(p, n, MS_SYNC);
        munmap(p, n);
        lseek(fd, 0x59000, SEEK_SET);
        p = malloc(0x13a00 + 512);
        memset(p, 'z', 0x13a00 + 512);
        write(fd, p + 512 - ((unsigned long)p & 511), 0x13a00);
}

The frequency depends on the fraction of unused sectors with non-zero
contents - for all I know it might hit that bug in 100% of runs, but
I can only detect that if the junk it picks contains non-zero data.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
