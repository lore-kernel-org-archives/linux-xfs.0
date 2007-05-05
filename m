Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 May 2007 09:33:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l45GXofB000741
	for <xfs@oss.sgi.com>; Sat, 5 May 2007 09:33:51 -0700
Date: Sat, 5 May 2007 12:33:49 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux SW RAID: HW Raid Controller/JBOD vs. Multiple PCI-e Cards?
Message-ID: <Pine.LNX.4.64.0705051228300.12744@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-raid@vger.kernel.org
Cc: xfs@oss.sgi.com

Question,

I currently have a 965 chipset-based motherboard, use 4 port onboard and 
several PCI-e x1 controller cards for a raid 5 of 10 raptor drives.  I get 
pretty decent speeds:

user@host$ time dd if=/dev/zero of=100gb bs=1M count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 247.134 seconds, 434 MB/s

real 4m7.164s
user 0m0.223s
sys 3m3.505s
user@host$ time dd if=100gb of=/dev/null bs=1M count=102400
102400+0 records in
102400+0 records out
107374182400 bytes (107 GB) copied, 172.588 seconds, 622 MB/s

real 2m52.631s
user 0m0.212s
sys 1m50.905s
user@host$

Also, when I run simultaenous dd's from all of the drives, I see 
850-860MB/s, I am curious if there is some kind of limitation with 
software raid as to why I am not getting better than 500MB/s for 
sequential write speed?  With 7 disks, I got about the same speed, adding 
3 more for a total of 10 did not seem to help in regards to write. 
However, read improved to 622MBs/ from about 420-430MB/s.

However, if I want to upgrade to more than 12 disks, I am out of PCI-e 
slots, so I was wondering, does anyone on this list run a 16 port Areca or 
3ware card and use it for JBOD?  What kind of performance do you see when 
using mdadm with such a card?  Or if anyone uses mdadm with less than a 16 
port card, I'd like to hear what kind of experiences you have seen with 
that type of configuration.

Justin.
