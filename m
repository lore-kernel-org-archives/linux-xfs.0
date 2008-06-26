Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 07:48:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QEm4U8005843
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 07:48:04 -0700
Received: from server515.appriver.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2277611D7315
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 07:49:04 -0700 (PDT)
Received: from server515.appriver.com (server515i.exghost.com [72.32.253.75]) by cuda.sgi.com with ESMTP id n8RWxALNiKaOYLAx for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 07:49:04 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] disable queue flag test in barrier check
Date: Thu, 26 Jun 2008 09:47:19 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CDBCF11@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <486398B7.50306@sandeen.net>
References: <486307EA.7080007@sandeen.net> <48635284.3060001@sgi.com> <486398B7.50306@sandeen.net>
From: "David Lethe" <david@santools.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Timothy Shimmin <tes@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, jeremy@sgi.comwe

Fyi - related problem is seen with solaris & zfs when users attach them
to hardware-based RAID subsystems.  The vendors had
to make firmware tweaks to address solaris's
flush-to-disk-after-all-writes.  

Not sure what you mean about non-volatile vs. volatile write cache,
however.  If you want to see if write cache is enabled on a disk drive,
or 
Even a logical disk on a hardware-based RAId, under Linux, then google
"mode page editor" for lots of choices.  Also look up zfs write cache
raid and you'll get information that you can just as easily apply to
Linux implementations of md. 


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Eric Sandeen
Sent: Thursday, June 26, 2008 8:25 AM
To: Timothy Shimmin
Cc: xfs-oss; LinuxRaid; NeilBrown; jeremy@sgi.comwe
Subject: Re: [PATCH] disable queue flag test in barrier check

Timothy Shimmin wrote:

> Also from memory, I believe Neil checked this removal into the
SLES10sp1 tree
> and some sgi boxes started having slow downs
> (looking at Dave's email below - we were not wanting to tell them
> to use nobarrier but needed it to work by default - I forget now).

But that's an admin issue.

The way it is now, for example a home user of md raid1 (me!) can't run
barriers even if they wanted to.

Until there is a way to know if a write cache is non-volatile the only
safe option is to enable barriers when possible.

> 6.
>> Date: Wed, 25 Jun 2008 08:57:24 +1000
>> From: Dave Chinner <david@fromorbit.com>
>> To: Eric Sandeen <sandeen@sandeen.net>
>> Cc: LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
>> Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
>>
>> Yeah, the problem was that last time this check was removed was
>> that a bunch of existing hardware had barriers enabled on them when
>> not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
>> devices. Having to change the root drive config on a wide install
>> base was considered much more of support pain than leaving the
>> check there. I guess that was more of a distro upgrade issue than
>> a mainline problem, but that's the history. Hence I think we
>> should probably do whatever everyone else is doing here....
>>
>> Cheers,
>>
>> Dave.
> 
> So I guess my question is whether there are cases where we are
> going to be in trouble again.
> Jeremy, do you see some problems?

FWIW, the problem *I* foresee is that some people are going to slow down
when using the defaults, yes, because barriers will start working again.
 But I don't see any other safe way around it.

Education would be in order, I suppose.  :)

-Eric

> --Tim
> 
> 
> 

