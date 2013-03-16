Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A66F8057
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 02:25:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E92F18F804B
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 00:25:53 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oHuVFqmczNw0K1Mo for <xfs@oss.sgi.com>;
	Sat, 16 Mar 2013 00:25:52 -0700 (PDT)
Date: Sat, 16 Mar 2013 18:25:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests #078: Mild oops/kernel issue for small partitions
Message-ID: <20130316072550.GH6369@dastard>
References: <CAJzLF9mvztWUQq7X2o0BcYLvUDH2bjAjpZosgzVUERgPTNYLVg@mail.gmail.com>
	<5143EA55.9040209@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5143EA55.9040209@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Sat, Mar 16, 2013 at 11:43:17AM +0800, Jeff Liu wrote:
> Hi Michael,
> 
> Thanks for the report.
> On 03/16/2013 10:00 AM, Michael L. Semon wrote:
> > Hi!  I was making another run with xfstests, using smaller partitions
> > so I could use the larger ones for other tests, and I got a mild
> > oops/crash of some sort.  This applies only to small partitions, first
> > hit using 480MB partitions.  Also, CONFIG_XFS_DEBUG is set here, but I
> > haven't tested the non-debug case lately.  This has been repeatable
> > across various 3.8/3.9 kernels used recently.
> > 
> > PC in this test is my Pentium III boat anchor, 512 MB RAM, 768 MB
> > swap, no VGA/console, using serial and ssh to communicate.  Output was
> > taken from the remote syslog facility and trimmed down.
> So I just tried it against both 480MB and 512MB partitions, but I can not
> reproduce it on 3.8/3.9-rc1 with xfsprogs 3.1.8.
> 
> # gdisk -l /dev/sda
> Number  Start (sector)    End (sector)  Size       Code  Name
>    7       405682176       406730751   512.0 MiB   8300  Linux filesystem 
>    8       406732800       407781375   512.0 MiB   8300  Linux filesystem
>    9       407783424       408766463   480.0 MiB   8300  Linux filesystem
>   10       408768512       409751551   480.0 MiB   8300  Linux filesystem
> 
> # ./check 078
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 koala 3.9.0-rc1

64 bit system

> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda10
> MOUNT_OPTIONS -- /dev/sda10 /xfstest4
> 
> 078 46s ... - output mismatch (see 078.out.bad)
>     --- 078.out	2012-10-16 11:59:14.757395850 +0800
>     +++ 078.out.bad	2013-03-16 11:39:10.945051414 +0800
>     @@ -76,6 +76,7 @@
>      === GROWFS (from 1t to 2500g, 4096 blocksize)
>      
>      *** mkfs loop file (size=1t)
>     +mkfs.xfs: libxfs_device_zero write failed: No space left on device

it ran out of space creating the log device. That write error is
likely what triggered the reported oops , which occurred in the
buffered write error handling routine....

> > This is a crash report.  No fix is requested.  Let me know if this
> > needs to go somewhere else in the Linux development world as well.
....
> > XFS (loop0): Mounting Filesystem
> > XFS: Assertion failed: block_offset + from == pos, file:
> > fs/xfs/xfs_aops.c, line: 1504
> > ------------[ cut here ]------------
> > kernel BUG at fs/xfs/xfs_message.c:100!
> > invalid opcode: 0000 [#1]
> > Pid: 1203, comm: mkfs.xfs Not tainted 3.9.0-rc1+ #1
> > EIP: 0060:[<c10fa4f7>] EFLAGS: 00010286 CPU: 0
> > EIP is at assfail+0x27/0x30
> > EAX: 00000056 EBX: dfd7bd60 ECX: c141db1c EDX: 00000000
> > ESI: 1bb72000 EDI: 00000000 EBP: dd037d70 ESP: dd037d5c

Oops occurred on a 32 bit system. That might be relevant...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
