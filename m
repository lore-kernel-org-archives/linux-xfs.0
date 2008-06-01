Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 01 Jun 2008 02:44:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m519ilF4015130
	for <xfs@oss.sgi.com>; Sun, 1 Jun 2008 02:44:47 -0700
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D71F1D889D
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2008 02:45:39 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id oE1GTadybxOot5ce for <xfs@oss.sgi.com>; Sun, 01 Jun 2008 02:45:39 -0700 (PDT)
Date: Sun, 1 Jun 2008 05:45:39 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Limits of the 965 chipset & 3 PCI-e cards/southbridge? ~774MiB/s
 peak for read, ~650MiB/s peak for write?
Message-ID: <alpine.DEB.1.10.0806010539430.24757@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com

I have 12 enterprise-class seagate 1TiB disks on a 965 desktop board and 
it appears I have hit the limit, if I were able to get the maximum speed 
of all drives, ~70MiB/avg * 12 = 840MiB/s but it seems to stop aound 774 
MiB/s (currently running badblocks on all drives)..

I am testing some drives for someone and was curious to see how far one 
can push the disks/backplane to their theoretical limit.

dstat output:
----total-cpu-usage---- -dsk/total- -net/total- ---paging-- ---system--
usr sys idl wai hiq siq| read  writ| recv  send|  in   out | int   csw
   1  12   0  83   3   2|   -     0 |   0     0 |   0     0 |  13k   23k
   1  11   0  84   2   2| 774M    0 |2100B 7373B|   0     0 |  13k   23k
   1  12   0  83   3   2| 774M    0 |   0     0 |   0     0 |  13k   23k
   1  11   0  82   4   2| 774M    0 |2030B 5178B|   0     0 |  13k   23k
   1  11   0  83   4   2| 774M    0 |   0     0 |   0     0 |  13k   23k
   1  11   0  83   3   2| 774M    0 |2264B 6225B|   0     0 |  13k   23k

vmstat 1 output:
~$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  0 12    124 3841772      8  13012    0    0 12595 163880  379  352  0 31 37 32
  2 12    124 3841772      8  12992    0    0 791744     8 12796 23033  1 18  0 82
  0 12    124 3841772      8  12992    0    0 792192     0 12677 22918  1 15  0 84
  0 12    124 3841772      8  12992    0    0 792960     0 12894 22929  1 15  0 84

When I was writing to all of the drives it was maxing out around ~650 
MiB/s.

I also have 2 raptors on a PCI card (as I ran out of PCI-e cards) and:
When I read from 1 of the raptors (w/ dd/example shown below) the speed 
drops:

   1  13   0  79   5   3| 764M    0 |2240B 7105B|   0     0 |  12k   21k
   1  13   0  80   5   2| 764M    0 |   0     0 |   0     0 |  12k   21k
   1  11   0  82   5   2| 764M    0 |2170B 5446B|   0     0 |  12k   21k
   1  12   0  81   5   2| 762M    0 |   0     0 |   0     0 |  12k   21k

Does/has anyone done this with server intel board/would greater speeds be 
achievable?

Also, how does AMD fair in this regard?  Has anyone run similar tests?
For instance if you have 12 disks in your host you could:

dd if=/dev/disk1 of=/dev/null bs=1M
dd if=/dev/disk2 of=/dev/null bs=1M

What rate(s) do you get?

Justin.
