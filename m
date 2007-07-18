Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 03:23:26 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IANMbm007861
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 03:23:23 -0700
Date: Wed, 18 Jul 2007 06:23:25 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Software RAID5 Horrible Write Speed On 3ware Controller!!
Message-ID: <Pine.LNX.4.64.0707180614480.7659@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-ide-arrays@lists.math.uh.edu, xfs@oss.sgi.com
Cc: linux-raid@vger.kernel.org, linux@vger.kernel.org

I recently got a chance to test SW RAID5 using 750GB disks (10) in a RAID5 
on a 3ware card, model no: 9550SXU-12

The bottom line is the controller is doing some weird caching with writes 
on SW RAID5 which makes it not worth using.

Recall, with SW RAID5 using regular SATA cards with (mind you) 10 raptors:
write: 464MB/s
read: 627MB/s

Yes, these drives are different, 7200RPM 750GB drives, but write should 
not be 50-102MB/s as shown below.

First, lets test RAW performance of these 10 drives:

Create RAID 0 with 10 750GB Drives:
# mdadm /dev/md0 --create --level=0 -n 10 
/dev/sd[bcdefghjik]1
mdadm: array /dev/md0 started.

--> XFS: (xfs default options, no optimizations)
# dd if=/dev/zero of=10gb bs=1M count=10240
10737418240 bytes (11 GB) copied, 22.459 seconds, 478 MB/s
# dd if=10gb of=/dev/zero bs=1M count=10240
10737418240 bytes (11 GB) copied, 28.7843 seconds, 373 MB/s

--> XFS: (xfs default options, enabled md-raid read optimizations)
# dd if=/dev/zero of=10gb bs=1M count=10240
10737418240 bytes (11 GB) copied, 22.9623 seconds, 468 MB/s
# dd if=10gb of=/dev/zero bs=1M count=10240
10737418240 bytes (11 GB) copied, 17.7328 seconds, 606 MB/s

Software RAID 5 on a real HW raid controller over 10 750GB disks JBOD:

UltraDense-AS-3ware-R5-9-disks,16G,50676,89,96019,34,46379,9,60267,99,501098,56,248.5,0,16:100000:16/64,240,3,21959,84,1109,10,286,4,22923,91,544,6
UltraDense-AS-3ware-R5-9-disks,16G,49983,88,96902,37,47951,10,59002,99,529121,60,210.3,0,16:100000:16/64,250,3,25506,98,1163,10,268,3,18003,71,772,8
UltraDense-AS-3ware-R5-9-disks,16G,49811,87,95759,35,48214,10,60153,99,538559,61,276.8,0,16:100000:16/64,233,3,25514,97,1100,9,279,3,21398,84,839,9

Write seems significantly impacted, where read is fine, the HW RAID 
controller cache must be doing something strange:

--> XFS SW RAID 5: (xfs noatime only, enabled md-raid read optimizations)
# dd if=/dev/zero of=10gb bs=1M count=10240
10737418240 bytes (11 GB) copied, 105.178 seconds, 102 MB/s
# dd if=10gb of=/dev/zero bs=1M count=10240
10737418240 bytes (11 GB) copied, 17.4893 seconds, 614 MB/s

-----

I am sure one of your questions is, well, why use SW RAID5 on the 
controller?  Because SW RAID5 is usually much faster than HW RAID5, at 
least in my tests:

Ctl   Model        Ports   Drives   Units   NotOpt   RRate   VRate   BBU
------------------------------------------------------------------------
c0    9550SXU-12   12      12       3       0        1       4       -

Unit  UnitType  Status         %Cmpl  Stripe  Size(GB)  Cache  AVerify  IgnECC
------------------------------------------------------------------------------
u0    RAID-1    OK             -      -       698.481   ON     ON       OFF
u1    RAID-5    OK             -      64K     5587.85   ON     OFF      OFF
u2    SPARE     OK             -      -       698.629   -      OFF      -

--> XFS:
# dd if=/dev/zero of=10gb bs=1M count=10240
10737418240 bytes (11 GB) copied, 74.5648 seconds, 144 MB/s

--> JFS:
# dd if=/dev/zero of=10gb bs=1M count=10240
10737418240 bytes (11 GB) copied, 108.631 seconds, 98.8 MB/s

The controller is set to performance, and this is nothing close to 
performance.

In RAID0, the controller is ok with the disks JBOD, but I cannot recommend 
buying a controller (12,16,24 port) for Linux SW RAID 5.

Its too bad that there are no regular > 4 port SATA PCI-e controllers out 
there.

Justin.
