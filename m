Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 01 Oct 2008 13:37:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m91KbcjK007312
	for <xfs@oss.sgi.com>; Wed, 1 Oct 2008 13:37:40 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE333134E1F8
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2008 13:39:15 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id O3szKCEBOFU5haKA for <xfs@oss.sgi.com>; Wed, 01 Oct 2008 13:39:15 -0700 (PDT)
Date: Wed, 1 Oct 2008 22:44:50 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: RAID5/6 writes
Message-ID: <20081001204450.GA25711@one.firstfloor.org>
References: <20081001175237.GJ32037@cordes.ca> <87k5csp0pe.fsf@basil.nowhere.org> <20081001201331.GL32037@cordes.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001201331.GL32037@cordes.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Cordes <peter@cordes.ca>
Cc: Andi Kleen <andi@firstfloor.org>, xfs@oss.sgi.com

On Wed, Oct 01, 2008 at 05:13:31PM -0300, Peter Cordes wrote:
> On Wed, Oct 01, 2008 at 09:36:13PM +0200, Andi Kleen wrote:
> > Peter Cordes <peter@cordes.ca> writes:
> > >
> > >  XFS knows (or should have been told by the admin with mkfs!) what the
> > > stripe geometry is: block size and stripe width.  So it could apply
> > > this optimization only if it would make a write cover more whole
> > > blocks or whole stripes.
> > 
> > It's a nice idea, but I don't think XFS knows the actual RAID level,
> > only the stripes. And for 0/1 it wouldn't be a good idea.
> 
>  Yeah, this would have to be a mount option, like stripewrite=1.
> There are already a few other essential mount options people need to
> learn about for big RAIDs, e.g. inode64.

The other problem I can think of is that determing if something is 
free data might need more read IO if the free extent tree is not completely
cached.

-Andi
