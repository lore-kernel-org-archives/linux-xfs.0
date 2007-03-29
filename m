Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 08:33:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2TFXL6p030157
	for <linux-xfs@oss.sgi.com>; Thu, 29 Mar 2007 08:33:23 -0700
Date: Fri, 30 Mar 2007 02:18:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070329151858.GI32597093@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown> <17927.19372.553410.527506@notabene.brown> <20070326090456.GO32597093@melbourne.sgi.com> <200703291656.22084.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200703291656.22084.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Thu, Mar 29, 2007 at 04:56:21PM +0200, Martin Steigerwald wrote:
> Am Montag 26 März 2007 schrieb David Chinner:
> 
> > > Is there some mount flag to say "cope without barriers" or "require
> > > barriers" ??
> >
> > XFs has "-o nobarrier" to say don't use barriers, and this is
> > *not* the default. If barriers don't work, we drop back to "-o
> > nobarrier" after leaving a loud warning inthe log....
> 
> Hello David!
> 
> Just a thought, maybe it shouldn't do that automatically, but require the 
> sysadmin to explicitely state "-o nobarrier" in that case. 

And prevent most existing XFS filesystems from mounting after
a kernel upgrade? Think about the problems that might cause
with XFs root filesystems on hardware/software that doesn't
support barriers....

Default behaviour is tolerant - it tries the safest method
known and if it can't use that it tells you and then continues
onwards. That's a good default to have.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
