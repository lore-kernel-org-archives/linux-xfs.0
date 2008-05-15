Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 16:26:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4FNQEbb022517
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 16:26:16 -0700
Date: Fri, 16 May 2008 09:26:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] scale down 074 on lower end machines
Message-ID: <20080515232651.GA155679365@sgi.com>
References: <20080515173913.GA11494@lst.de> <20080515221510.GT155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515221510.GT155679365@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, May 16, 2008 at 08:15:10AM +1000, David Chinner wrote:
> On Thu, May 15, 2008 at 07:39:13PM +0200, Christoph Hellwig wrote:
> > 074 takes ages to complete on my kvm test VM, but scaling it back to the
> > level used on IRIX makes it complete in slightly under 10 minutes.
> > 
> > I'm not sure if checking for UP vs SMP is the right way to go into slow
> > mode, but I couldn't think of anything better.
> 
> Seems fair - I was wondering exactly the same thing yesterday
> as this is another test that takes >15min to run on UML. I didn't
> think of the UP vs SMP trigger, but it seems like a good way to
> go given all of the real QA boxes we have are SMP.
> 
> I'll give it a run and see how it goes.

FWIW - runtime on UML has dropped from 918s to 88s. Very reasonable
now, and makes the maximum single test runtime in UML about 330s....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
