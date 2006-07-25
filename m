Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 03:51:38 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PAp7DZ001440
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 03:51:11 -0700
Date: Tue, 25 Jul 2006 10:44:38 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: fix remount vs barrier options
Message-ID: <20060725094438.GD29615@infradead.org>
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com> <20060723190650.GA22180@infradead.org> <20060724100147.F2083275@wobbly.melbourne.sgi.com> <20060724112737.D2085715@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060724112737.D2085715@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, jeremy@sgi.com

On Mon, Jul 24, 2006 at 11:27:37AM +1000, Nathan Scott wrote:
> On Mon, Jul 24, 2006 at 10:01:48AM +1000, Nathan Scott wrote:
> > On Sun, Jul 23, 2006 at 08:06:50PM +0100, Christoph Hellwig wrote:
> > > Shouldn't we make sure we clear all flags when reusing a log buffer?
> > > Relying on clearing individual flags seems rather fragile to me.
> > 
> > *nod* - good idea.  I'll rework xlog_sync, and resend later.
> 
> After looking more, I'm less convinced.  There's some flags we wont
> want to touch - the "internal" flags like PAGE_CACHE, etc (that one
> is obviously not relevent here, but still, at some point a flag may
> be introduced that we accidentally break by clearing all flags).
> 
> There is a ZEROFLAGS macro, I've added ORDERED to that and used it
> instead.  I also fixed the double barrier issue for the split log
> write case - here's an updated patch...

The flag clearing changes look good.  But why is it okay to skip the
ordered flag on the first block?  We want to make sure all previous I/O
is finished before even doing the first log block write, don't we?
