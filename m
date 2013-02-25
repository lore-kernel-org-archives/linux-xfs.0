Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0DF077F8D
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 17:47:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0BF9304032
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2013 15:47:10 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	imsqaYUxpwzdTUi0 for <xfs@oss.sgi.com>;
	Mon, 25 Feb 2013 15:47:09 -0800 (PST)
Date: Tue, 26 Feb 2013 10:46:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Consistent throughput challenge -- fragmentation?
Message-ID: <20130225234635.GK5551@dastard>
References: <CAEWpfG_DKJt1MmWS1tARH4OmYwpSt=A-DzwKkGcD67LuR6k=Bg@mail.gmail.com>
	<20130225221639.GJ5551@dastard>
	<CAEWpfG_imbrJiCYMXntQt3fxkj=F89QkTO4Y-ztAo_5c83-qvA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEWpfG_imbrJiCYMXntQt3fxkj=F89QkTO4Y-ztAo_5c83-qvA@mail.gmail.com>
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
To: Brian Cain <brian.cain@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 25, 2013 at 04:18:19PM -0600, Brian Cain wrote:
> + uname -a
> Linux sdac 2.6.32.27-0.2.2.3410.1.PTF-default #1 SMP 2010-12-29 15:03:02 +0100 x86_64 x86_64 x86_64 GNU/Linux

That's some weird special SLES 11 kernel. I've got no idea what is
in the kernel. You should be talking to your SuSE support contact
for diagnosis and triage, because if it is a kernel bug we can't
effectively diagnose it or fix it here....

So, I/O 101:

> Adapter 0 -- Virtual Drive Information:
> Virtual Drive: 0 (Target Id: 0)
> Name                :
> RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
> Size                : 341.333 GB
> State               : Optimal
> Strip Size          : 1.0 MB
> Number Of Drives    : 12

So, in XFS terms that RAID5 lun has a sunit of 1MB, and swidth =
12MB....

> Exit Code: 0x00
> + mdadm --detail /dev/md0
> /dev/md0:
>         Version : 0.90
>   Creation Time : Mon Feb 25 14:22:06 2013
>      Raid Level : raid0

And striped together with raid0 gives either sunit=1MB, swidth=36MB
or sunit=12MB , swidth=36MB...

>      Chunk Size : 64K

but you've told it a sunit of 64k. That means the md stripe is
cutting up large IOs into very small writes to the RAID5 LUNS. That
should have a chunk size equal to the stripe width of the hardware
RAID lun (ie 12MB).

> + xfs_info /raw_data
> meta-data=/dev/md0               isize=256    agcount=32, agsize=8388608 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=268435152, imaxpct=25
>          =                       sunit=16     swidth=48 blks

And this is aligning to the MD stripe, not your storage hardware.

> realtime =none                   extsz=4096   blocks=0, rtextents=0
> + dmesg

> + for i in '$(seq 0 15)'
> + iostat -x -d -m 5
> Linux 2.6.32.27-0.2.2.3410.1.PTF-default (sdac) 	02/25/2013 	_x86_64_
.....
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await  svctm  %util
> sdd               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sde               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
> sda               0.00  7486.00    0.00 16546.00     0.00  1502.19   185.93     7.62    0.46   0.05  82.96
> sdb               0.00  8257.00    0.00 15774.40     0.00  1502.03   195.01     8.47    0.54   0.06  89.84
> sdc               0.00  8284.80    0.00 15745.20     0.00  1501.81   195.34     8.81    0.56   0.06  92.08
> md0               0.00     0.00    0.00 72094.40     0.00  4505.86   128.00     0.00    0.00   0.00   0.00

This is a fair indication that you've configured something wrong -
this workload should be issuing large IO, tens of thousands of small
IOs....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
