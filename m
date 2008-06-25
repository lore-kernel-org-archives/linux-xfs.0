Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 18:49:18 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5P1n5dd001595
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 18:49:08 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FFED181D21F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 18:50:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yW6Ex8HsPWaugrtQ for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 18:50:02 -0700 (PDT)
Message-ID: <4861A447.5090208@sandeen.net>
Date: Tue, 24 Jun 2008 20:49:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
References: <48605A8E.9070903@sandeen.net> <20080624225724.GN29319@disturbed>
In-Reply-To: <20080624225724.GN29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, LinuxRaid <linux-raid@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Jun 23, 2008 at 09:23:10PM -0500, Eric Sandeen wrote:


>> Maybe there should be a QUEUE_ORDERED_PASSTHRU flag?
>> Or should XFS just stick with the test write and ignore the flag?  I'm
>> not sure of the queue->ordered flag details, but it seems that XFS & md
>> raid1 both try hard to keep barriers in force, and there's a disconnect
>> here somewhere.
> 
> Yeah, the problem was that last time this check was removed was
> that a bunch of existing hardware had barriers enabled on them when
> not necessary (e.g. had NVRAM) and they went 5x slower on MD raid1
> devices. 

Hm,
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c#rev1.402,
 putting back what was removed in
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c#rev1.380
 I guess.  But this seems like a very weird argument to me.  Whether a
drive/raid has battery backed raid, is 1 spindle or 100, is connected to
a UPS or whatnot really is orthogonal to what should be set on the queue
flag... This should be an admin decision.  Leaving it this way for this
odd reason leaves smaller users w/ 2 raid1 spindles in the desktop box
actually completely unable to use barriers even if they wanted to;
removing the check at least lets the savvy admin mount with an option to
turn them off.

> Having to change the root drive config on a wide install
> base was considered much more of support pain than leaving the
> check there. I guess that was more of a distro upgrade issue than
> a mainline problem, but that's the history. Hence I think we
> should probably do whatever everyone else is doing here...

I'll submit a patch to remove the check ;)

-Eric

> 
> Cheers,
> 
> Dave.
