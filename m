Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Jul 2006 20:53:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6U3rKDW031248
	for <xfs@oss.sgi.com>; Sat, 29 Jul 2006 20:53:20 -0700
Message-ID: <44CC2D1A.3060805@sandeen.net>
Date: Sat, 29 Jul 2006 22:52:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: write back cache and barriers
References: <5545990.post@talk.nabble.com>
In-Reply-To: <5545990.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: calembour <mrcekets@gmail.com>
Cc: xfs@oss.sgi.com

calembour wrote:
> Hi,
> I don't have a deep knowledge about filesystems and I've few experiences
> with 
> raid configuration, so I need someone who can answer some questions about 
> write back cache and barriers.
> 
> I have two sata hd (sda, sdb) configured in bios-raid 0 and relative device 
> created by dmraid on boot (nvidia_ihfaaicb).
> 
> (1) what should I do to know if the write back cache is enabled or not ?

lots of this is in the faq:
http://oss.sgi.com/projects/xfs/faq.html#wcache

> (2) if the write cache is enabled on both sda and sdb this mean that is
> enabled 
> also on the raid device (/dev/mapper/nvidia_ihfaaicb) ?

I'd guess that if there's a write cache anywhere under your device, then in 
effect the raid device would be considered write-cached.

> (3) how should I do to enable/disable the write cache on the raid device ?

see faq

> If I try mounting a xfs filesystem I get a message like "barriers are not 
> supported by this device" but if I mount a ext3 or a reiserfs filesystem 
> respectively with options barrier=1 and barrier=flush they don't complain.
> If I mount the reiserfs I explicity get a message like "using barriers".
> So who tells the truth ?? 

I don't see ext3 or reiser actually checking whether the underlying device 
supports barriers.  xfs does, in xfs_mountfs_check_barriers().

> (4) is there a way to know if the raid device supports barrier or not ?

I'm not sure how barriers interact with multiple devices; perhaps someone else 
can answer....

> (5) is there a (not dangerous) test I can do to figure out if barriers are 
> really enabled and used with ext3 and reiserfs filesystems ?

Dunno :)

-Eric

> Thanks for reading the message
> Marco
