Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 09:03:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HG36sA001003
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 09:03:06 -0700
Received: from mail.ukfsn.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50B5516DF5E6
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 08:30:49 -0700 (PDT)
Received: from mail.ukfsn.org (mx1.ukfsn.org [77.75.108.10]) by cuda.sgi.com with ESMTP id fWDNGyoJu1exZNQ5 for <xfs@oss.sgi.com>; Sat, 17 May 2008 08:30:49 -0700 (PDT)
Message-ID: <482EF7D0.2030309@dgreaves.com>
Date: Sat, 17 May 2008 16:20:48 +0100
From: David Greaves <david@dgreaves.com>
MIME-Version: 1.0
Subject: Re: Regression- XFS won't mount on partitioned md array
References: <482DC043.5000307@dgreaves.com>	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>	 <482DCCCD.8020503@dgreaves.com> <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com> <482EF026.9000206@dgreaves.com>
In-Reply-To: <482EF026.9000206@dgreaves.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>

David Greaves wrote:
> Oliver Pinter wrote:
>> this[1] patch fixed?
>>
>> 1:
> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020
> 
> 
> Looks like a possible candidate - thanks.
> 
> I think this patch is for mounting root on an md device when the partitions
> aren't yet initialised.
> 
> However:
> * When I run cfdisk I can read the partition table.
> * Subsequent attempts to mount the xfs when /proc/partitions is clearly present
> still fail.
> 
>> this patch is for 2.6.25.5 kernel
> ? there isn't a 2.6.25.5
Sorry, I understand; it's queued for 2.6.25.5.

> It doesn't apply to 2.6.25.4
> 
> I'll see if I can make it apply...
Yep - it was download corruption.

Applied but it didn't help.

David
