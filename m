Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A88F7F37
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 00:04:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A355AC00C
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 22:04:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SxcGrm9au5txIOdh for <xfs@oss.sgi.com>;
	Tue, 29 Sep 2015 22:04:28 -0700 (PDT)
Date: Wed, 30 Sep 2015 15:04:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests, xfs test 080 fails on arm 32bit
Message-ID: <20150930050425.GC3902@dastard>
References: <560A9307.6080600@nomovok.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <560A9307.6080600@nomovok.com>
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
To: Angelo Dureghello <angelo.dureghello@nomovok.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 29, 2015 at 03:32:55PM +0200, Angelo Dureghello wrote:
> Hi,
> 
> executing this test on a 32bit arm. i get (i traced mmapping sizes):
> 
> # ./start_xfs_test.sh
> QA output created by 080
> [  161.827446] XFS (mmcblk0p5): Mounting V4 Filesystem
> [  162.357952] XFS (mmcblk0p5): Ending clean mount
> 
> mmapping 512000000
> mmapping 512000000
> mmapping 512000000
> mmapping 512000000
> mmapping 512000000
> mmapping 512000000
> 
> oio ( 3241) 15:18:17
> ---------------------
> mmap() failed - 0xffffffff 12
> 
> doio ( 3241) 15:18:17
> ---------------------
> mmap-read() request failed:  Cannot allocate memory (12)
> Request number 15
>           fd 4 is file /media/p5/rwtest.file - open flags are 0 O_RDONLY,
>           read done at file offset 978498
>           number of requests is 1, strides per request is 1
>           i/o byte count = 119505
>           memory alignment is unaligned
> 
> syscall:  mmap-read(NULL, 512000000, PROT_READ, MAP_SHARED, 4, 0)
>     file is mmaped to: 0x0
>     file-mem=0xeee42, length=119505, buffer=0x484a6

Does it close/unmap the other files it mmaps? i.e. 32 bit only has a
3GB address space for user applications (IIRC), so the 6th 512MB
mapping will run the process out of address space and hence fail....

> doio ( 3241) 15:18:17
> ---------------------
> doio(): operation 120 returned != 0
> rwtest.sh : iogen reported errors (r=141)
> 
> 
> Is it possible the test was thought to pass on 64bit systems ?

Works just fine on 64 bit systems:

 $ sudo ./check xfs/080
 FSTYP         -- xfs (debug)
 PLATFORM      -- Linux/x86_64 test2 4.3.0-rc1-dgc+
 MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdg
 MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdg
 /mnt/scratch

 xfs/080 2s ... 7s
 Ran: xfs/080
 Passed all 1 tests

And looking at the memory footprint:

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 3300 root      20   0 3010672   1612   1344 D   4.7  0.0   0:00.14 doio

Yup, 3GB of virtual address space used, 1.6MB of actual memory used.

_require_64bit_userspace is probably needed here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
