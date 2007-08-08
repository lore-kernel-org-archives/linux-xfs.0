Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 05:22:18 -0700 (PDT)
Received: from mx2.suse.de (ns2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l78CMBbm024435
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 05:22:13 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: XFS thread inflation in 2.6.23rc
Date: Wed, 8 Aug 2007 14:22:10 +0200
References: <200708081240.21548.ak@suse.de> <20070808121359.GP52011508@sgi.com>
In-Reply-To: <20070808121359.GP52011508@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081422.10373.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wednesday 08 August 2007 14:13:59 David Chinner wrote:
> On Wed, Aug 08, 2007 at 12:40:21PM +0200, Andi Kleen wrote:
> > 
> > In 2.6.23rc I have a new kernel thread running from XFS:
> > 
> > 30137 ?        S<     0:00 [xfs_mru_cache]
> > 
> > Is that one really needed? Can it be started only on demand when that MRU
> > feature is used? 
> 
> It uses a single threaded workqueue for reaping objects and the thread comes
> along with that. Creating the workqueue on demand would require creating a
> kernel thread inside a transaction and that's not some thing we want to do.

Why not? I can't think of any possible problem except memory allocation
recursion, but even that should be handled.

> Besides, what's the point of having nice constructs like dedicated
> workqueues

It's a resource that shouldn't be overused.

Especially for such a obscure feature -- i remember reviewing your rationale
for the MRU cache and the probability of this applying to 99.9+% of users ever 
is pretty small. If you insist adding such things make them as least 
as unobtrusive as possible.

> if people complain when they get used to solve problems? 

Does XFS really need that many threads? Seems doubtful to me.

Ok part of the problem is that the workqueues are a little dumb.
e.g. it's highly doubtful per SMT thread workqueues really make any sense.
It would be probably enough to have one per socket or one per node.
But that's a separate issue from just gratuitously adding new ones.

-Andi
