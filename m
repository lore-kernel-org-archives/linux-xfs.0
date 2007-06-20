Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Jun 2007 14:23:59 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5KLNsdo003665
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2007 14:23:56 -0700
Date: Wed, 20 Jun 2007 17:23:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Poor performance -- poor config?
In-Reply-To: <46799939.2080503@bnl.gov>
Message-ID: <Pine.LNX.4.64.0706201723050.30471@p34.internal.lan>
References: <4679951E.8050601@bnl.gov> <Pine.LNX.4.64.0706201703310.27484@p34.internal.lan>
 <46799939.2080503@bnl.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Robert Petkus <rpetkus@bnl.gov>
Cc: xfs@oss.sgi.com



On Wed, 20 Jun 2007, Robert Petkus wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Wed, 20 Jun 2007, Robert Petkus wrote:
>> 
>>> Folks,
>>> I'm trying to configure a system (server + DS4700 disk array) that can 
>>> offer the highest performance for our application.  We will be reading and 
>>> writing multiple threads of 1-2GB files with 1MB block sizes.
>>> DS4700 config:
>>> (16) 500 GB SATA disks
>>> (3) 4+1 RAID 5 arrays and (1) hot spare == (3) 2TB LUNs.
>>> (2) RAID arrays are on controller A, (1) RAID array is on controller B.
>>> 512k segment size
>>> 
>>> Server Config:
>>> IBM x3550, 9GB RAM, RHEL 5 x86_64 (2.6.18)
>>> The (3) LUNs are sdb, sdc {both controller A}, sdd {controller B}
>>> 
>>> My original goal was to use XFS and create a highly optimized config. 
>>> Here is what I came up with:
>>> Create separate partitions for XFS log files: sdd1, sdd2, sdd3 each 150M 
>>> -- 128MB is the maximum allowable XFS log size.
>>> The XFS "stripe unit" (su) = 512k to match the DS4700 segment size
>>> The "stripe width" ( (n-1)*sunit )= swidth=2048k  = sw=4 (a multiple of 
>>> su)
>>> 4k is the max block size allowable on x86_64 since 4k is the max kernel 
>>> page size
>>> 
>>> [root@~]# mkfs.xfs -l logdev=/dev/sdd1,size=128m -d su=512k -d sw=4 -f 
>>> /dev/sdb
>>> [root@~]#  mount -t xfs -o 
>>> context=system_u:object_r:unconfined_t,noatime,nodiratime,logbufs=8,logdev=/dev/sdd1 
>>> /dev/sdb /data0
>>> 
>>> And the write performance is lousy compared to ext3 built like so:
>>> [root@~]# mke2fs -j -m 1 -b4096 -E stride=128 /dev/sdc
>>> [root@~]# mount -t ext3 -o 
>>> noatime,nodiratime,context="system_u:object_r:unconfined_t:s0",reservation 
>>> /dev/sdc /data1
>>> 
>>> What am I missing?
>>> 
>>> Thanks!
>>> 
>>> -- 
>>> Robert Petkus
>>> RHIC/USATLAS Computing Facility
>>> Brookhaven National Laboratory
>>> Physics Dept. - Bldg. 510A
>>> Upton, New York 11973
>>> 
>>> http://www.bnl.gov/RHIC
>>> http://www.acf.bnl.gov
>>> 
>>> 
>> 
>> What speeds are you getting?
> dd if=/dev/zero of=/data0/bigfile bs=1024k count=5000
> 5242880000 bytes (5.2 GB) copied, 149.296 seconds, 35.1 MB/s
>
> dd if=/data0/bigfile of=/dev/null bs=1024k count=5000
> 5242880000 bytes (5.2 GB) copied, 26.3148 seconds, 199 MB/s
>
> iozone.linux -w -r 1m -s 1g -i0 -t 4 -e -w -f /data0/test1
> Children see throughput for  4 initial writers  =   28528.59 KB/sec
>       Parent sees throughput for  4 initial writers   =   25212.79 KB/sec
>       Min throughput per process                      =    6259.05 KB/sec
>       Max throughput per process                      =    7548.29 KB/sec
>       Avg throughput per process                      =    7132.15 KB/sec
>
> iozone.linux -w -r 1m -s 1g -i1 -t 4 -e -w -f /data0/test1
> Children see throughput for  4 readers          = 3059690.19 KB/sec
>       Parent sees throughput for  4 readers           = 3055307.71 KB/sec
>       Min throughput per process                      =  757151.81 KB/sec
>       Max throughput per process                      =  776032.62 KB/sec
>       Avg throughput per process                      =  764922.55 KB/sec
>
>> 
>> Have you tried a SW RAID with the 16 drives, if you do that, XFS will 
>> auto-optimize per the physical characteristics of the md array.
> No because this would waste an expensive disk array.  I've done this with 
> various JBODs, even a SUN Thumper, with OK results...
>> 
>> Also, most of those mount options besides the logdev/noatime don't do much 
>> with XFS from my personal benchmarks, you're better off with the 
>> defaults+noatime.
> The security context stuff is in there since I run a strict SELinux policy. 
> Otherwise, I need logdev since it's on a different disk.  BTW, the same 
> filesystem w/out a separate log disk made no difference in performance.
>> 
>> What speed are you getting reads/writes, what do you expect?  How are the 
>> drives attached/what type of controller? PCI?
> I can get ~3x write performance with ext3.  I have a dual-port FC-4 PCIe HBA 
> connected to (2) IBM DS4700 FC-4 controllers.  There is lots of headroom.
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

EXT3 up to 3x fast? Hrm.. Have you tried default mkfs.xfs options 
[internal journal]?  What write speed do you get using the defaults?

What kernel version?

Justin.
