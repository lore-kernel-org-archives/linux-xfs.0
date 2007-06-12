Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 02:49:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5C9nRWt024715
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 02:49:30 -0700
Date: Tue, 12 Jun 2007 19:49:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: factor extracting extent size hints from the inode
Message-ID: <20070612094922.GW86004887@sgi.com>
References: <20070604052333.GR85884050@sgi.com> <466E2B76.7010707@sgi.com> <20070612060800.GP86004887@sgi.com> <1181630386.3758.90.camel@edge.yarra.acx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181630386.3758.90.camel@edge.yarra.acx>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>
Cc: David Chinner <dgc@sgi.com>, Vlad Apostolov <vapo@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 12, 2007 at 04:39:46PM +1000, Nathan Scott wrote:
> On Tue, 2007-06-12 at 16:08 +1000, David Chinner wrote:
> > 
> > If you use this method of setting the extent size hint, then you will
> > *always* get the XFS_DIFLAG_EXTSIZE flag set when you have an extent
> > size hint, regardless of whether it is a realtime file or not. 
> 
> The extsize flag is relatively recent though, and traditionally
> realtime files could have had their extsize explicitly set with
> no associated extsize flag (thats just how it was implemented,
> originally, in realtime).

*nod*

We've got recent bugs reported because of this assumption and lack
of checking of the extent size hint flag where it needs to be
checked.

Either we have a flag to indicate the di_extsize field is valid or
we don't - it's too confusing to have different interfaces just
because an inode has a different, unrelated flag set on it.
Now that we have a flag, we can't remove support for it.....

> But, not many people use realtime, even fewer would be using the
> extent size option with realtime (like, none?, on Linux anyway)
> ... so, you could pretty much make whatever rule you like.

I sorta left that unsaid, but that is yet another reason I think
the change should stand.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
