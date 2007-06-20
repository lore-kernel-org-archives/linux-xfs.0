Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Jun 2007 14:05:01 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5KL4udo025929
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2007 14:04:57 -0700
Date: Wed, 20 Jun 2007 17:04:57 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Poor performance -- poor config?
In-Reply-To: <4679951E.8050601@bnl.gov>
Message-ID: <Pine.LNX.4.64.0706201703310.27484@p34.internal.lan>
References: <4679951E.8050601@bnl.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Petkus <rpetkus@bnl.gov>
Cc: xfs@oss.sgi.com



On Wed, 20 Jun 2007, Robert Petkus wrote:

> Folks,
> I'm trying to configure a system (server + DS4700 disk array) that can offer 
> the highest performance for our application.  We will be reading and writing 
> multiple threads of 1-2GB files with 1MB block sizes.
> DS4700 config:
> (16) 500 GB SATA disks
> (3) 4+1 RAID 5 arrays and (1) hot spare == (3) 2TB LUNs.
> (2) RAID arrays are on controller A, (1) RAID array is on controller B.
> 512k segment size
>
> Server Config:
> IBM x3550, 9GB RAM, RHEL 5 x86_64 (2.6.18)
> The (3) LUNs are sdb, sdc {both controller A}, sdd {controller B}
>
> My original goal was to use XFS and create a highly optimized config.  Here 
> is what I came up with:
> Create separate partitions for XFS log files: sdd1, sdd2, sdd3 each 150M -- 
> 128MB is the maximum allowable XFS log size.
> The XFS "stripe unit" (su) = 512k to match the DS4700 segment size
> The "stripe width" ( (n-1)*sunit )= swidth=2048k  = sw=4 (a multiple of su)
> 4k is the max block size allowable on x86_64 since 4k is the max kernel page 
> size
>
> [root@~]# mkfs.xfs -l logdev=/dev/sdd1,size=128m -d su=512k -d sw=4 -f 
> /dev/sdb
> [root@~]#  mount -t xfs -o 
> context=system_u:object_r:unconfined_t,noatime,nodiratime,logbufs=8,logdev=/dev/sdd1 
> /dev/sdb /data0
>
> And the write performance is lousy compared to ext3 built like so:
> [root@~]# mke2fs -j -m 1 -b4096 -E stride=128 /dev/sdc
> [root@~]# mount -t ext3 -o 
> noatime,nodiratime,context="system_u:object_r:unconfined_t:s0",reservation 
> /dev/sdc /data1
>
> What am I missing?
>
> Thanks!
>
> -- 
> Robert Petkus
> RHIC/USATLAS Computing Facility
> Brookhaven National Laboratory
> Physics Dept. - Bldg. 510A
> Upton, New York 11973
>
> http://www.bnl.gov/RHIC
> http://www.acf.bnl.gov
>
>

What speeds are you getting?

Have you tried a SW RAID with the 16 drives, if you do that, XFS will 
auto-optimize per the physical characteristics of the md array.

Also, most of those mount options besides the logdev/noatime don't do much 
with XFS from my personal benchmarks, you're better off with the 
defaults+noatime.

What speed are you getting reads/writes, what do you expect?  How are the 
drives attached/what type of controller? PCI?
