Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 08:24:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QFNtZi014527
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 08:23:55 -0700
Received: from server515.appriver.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34ACF1233969
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 08:24:54 -0700 (PDT)
Received: from server515.appriver.com (server515a.exghost.com [72.32.253.70]) by cuda.sgi.com with ESMTP id BXJH6gIEFnseNh3s for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 08:24:54 -0700 (PDT)
Reply-To: <David@santools.com>
Message-ID: <22f301c8d7a0$c5e87fc0$9201a8c0@exchange.rackspace.com>
Subject: Re: [PATCH] disable queue flag test in barrier check
From: "David Lethe" <david@santools.com>
Date: Thu, 26 Jun 2008 10:24:00 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe

Unflushed writes are 100% effective for losing data and corrupting file systems.  Data isn't saved until it is on the magnetic media.  Batterybackup modules for disk controllers help, but there is no substitute for a ups.  Even with a bbu on disk controller, if the kernel hasn't flushed write to the controller, and system crashes or loses power, the kernel io queue will never reach the controllers bbu.

You have a moral obligation to use a ups... And if you work for a US company, then Sarbox pretty much makes this a legal obligation and a criminal offense if you don't protect certain databases with something as reasonable and cheap as a ups

-----Original Message-----

From:  "Eric Sandeen" <sandeen@sandeen.net>
Subj:  Re: [PATCH] disable queue flag test in barrier check
Date:  Thu Jun 26, 2008 9:57 am
Size:  1K
To:  "David Lethe" <david@santools.com>
cc:  "Timothy Shimmin" <tes@sgi.com>; "xfs-oss" <xfs@oss.sgi.com>; "LinuxRaid" <linux-raid@vger.kernel.org>; "NeilBrown" <neilb@suse.de>; "jeremy@sgi.comwe" <jeremy@sgi.comwe>

David Lethe wrote: 
> Fyi - related problem is seen with solaris & zfs when users attach them 
> to hardware-based RAID subsystems.  The vendors had 
> to make firmware tweaks to address solaris's 
> flush-to-disk-after-all-writes.   
>  
> Not sure what you mean about non-volatile vs. volatile write cache, 
> however.  If you want to see if write cache is enabled on a disk drive, 
> or  
> Even a logical disk on a hardware-based RAId, under Linux, then google 
> "mode page editor" for lots of choices.  Also look up zfs write cache 
> raid and you'll get information that you can just as easily apply to 
> Linux implementations of md.  
 
I'm not so interested in whether it is enabled; I'd like to know if it 
is safe (to varying degrees) in the event of a power failure, and I 
don't think there's any way we can know that. 
 
So the administrator, if she's sure that all cached writes will hit disk 
even if a breaker pops, can disable barriers.  If it's just a 32MB cache 
seagate drive plugged  into the wall, you probably had better be sure 
barriers are enabled or you may well have a scrambled filesystem 
post-power-outage. 
 
-Eric 
 
