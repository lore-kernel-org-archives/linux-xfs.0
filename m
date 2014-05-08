Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41FA07F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 21:28:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D1FE304062
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 19:28:10 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 3RoPP5X5dy9kAc3N
	for <xfs@oss.sgi.com>; Wed, 07 May 2014 19:28:09 -0700 (PDT)
Message-ID: <536AEBB9.3020807@hardwarefreak.com>
Date: Wed, 07 May 2014 21:28:09 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Alignment: XFS + LVM2
References: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>
In-Reply-To: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Marc Caubet <mcaubet@pic.es>, xfs@oss.sgi.com

Everything begins and ends with the workload.

On 5/7/2014 7:43 AM, Marc Caubet wrote:
> Hi all,
> 
> I am trying to setup a storage pool with correct disk alignment and I hope
> somebody can help me to understand some unclear parts to me when
> configuring XFS over LVM2.

I'll try.  But to be honest, after my first read of your post, a few
things jump out as breaking traditional rules.

The first thing you need to consider is your workload and the type of
read/write patterns it will generate.  This document is unfinished, and
unformatted, but reading what is there should be informative:

http://www.hardwarefreak.com/xfs/storage-arch.txt

> Actually we have few storage pools with the following settings each:
> 
> - LSI Controller with 3xRAID6
> - Each RAID6 is configured with 10 data disks + 2 for double-parity.
> - Each disk has a capacity of 4TB, 512e and physical sector size of 4K.

512e drives may cause data loss.  See:
http://docs.oracle.com/cd/E26502_01/html/E28978/gmkgj.html#gmlfz

> - 3x(10+2) configuration was considered in order to gain best performance
> and data safety (less disks per RAID less probability of data corruption)

RAID6 is the worst performer of all the RAID levels but gives the best
resilience to multiple drive failure.  The reason for using fewer drives
per array has less to do with probability of corruption, but

1. Limiting RMW operations to as few drives as possible, especially for
controllers that do full stripe scrubbing on RMW

2.  Lowering bandwidth and time required to rebuild a dead drive, fewer
drives tied up during a rebuild

> From the O.S. side we see:
> 
> [root@stgpool01 ~]# fdisk -l /dev/sda /dev/sdb /dev/sdc
...

You omitted crucial information.  What is the stripe unit size of each
RAID6?

> The idea is to aggregate the above devices and show only 1 storage space.
> We did as follows:
> 
> vgcreate dcvg_a /dev/sda /dev/sdb /dev/sdc
> lvcreate -i 3 -I 4096 -n dcpool -l 100%FREE -v dcvg_a

You've told LVM that its stripe unit is 4MB, and thus the stripe width
of each RAID6 is 4MB.  This is not possible with 10 data spindles.
Again, show the RAID geometry from the LSI tools.

When creating a nested stripe, the stripe unit of the outer stripe (LVM)
must equal the stripe width of eachinner stripe (RAID6).

> Hence, stripe of the 3 RAID6 in a LV.

Each RAID6 has ~1.3GB/s of throughput.  By striping the 3 arrays into a
nested RAID60 this suggests you need single file throughput greater than
1.3GB/s and that all files are very large.  If not, you'd be better off
using a concatenation, and using md to accomplish that instead of LVM.

> And here is my first question: How can I check if the storage and the LV
> are correctly aligned?

Answer is above.  But the more important question is whether your
workload wants a stripe or a concatenation.

> On the other hand, I have formatted XFS as follows:
> 
> mkfs.xfs -d su=256k,sw=10 -l size=128m,lazy-count=1 /dev/dcvg_a/dcpool

This alignment is not correct.  XFS must be aligned to the LVM stripe
geometry.  Here you apparently aligned XFS to the RAID6 geometry
instead.  Why are you manually specifying a 128M log?  If you knew your
workload that well, you would not have made these other mistakes.

In a nutshell, you need to ditch all of this and start over.

> So my second question is, are the above 'su' and 'sw' parameters correct on
> the current LV configuration? If not, which values should I have and why?
> AFAIK su is the stripe size configured in the controller side, but in this
> case we have a LV. Also, sw is the number of data disks in a RAID, but
> again, we have a LV with 3 stripes, and I am not sure if the number of data
> disks should be 30 instead.

Describe your workload and we can tell you how to properly set this up.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
