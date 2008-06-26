Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 04:20:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QBKfDX005686
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:20:41 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15498286E1F
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:21:40 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ipdNIdDVGiY2LjG7 for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 04:21:40 -0700 (PDT)
Date: Thu, 26 Jun 2008 21:21:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080626112133.GJ11558@disturbed>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <20080626074636.GB7064@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080626074636.GB7064@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 03:46:36AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 26, 2008 at 02:41:12PM +1000, Dave Chinner wrote:
> > XFS object flushing doesn't quite match existing completion semantics.  It
> > mixed exclusive access with completion. That is, we need to mark an object as
> > being flushed before flushing it to disk, and then block any other attempt to
> > flush it until the completion occurs.
> > 
> > To do this we introduce:
> > 
> > void init_completion_flush(struct completion *x)
> > 	which initialises x->done = 1
> > 
> > void completion_flush_start(struct completion *x)
> > 	which blocks if done == 0, otherwise decrements done to zero and
> > 	allows the caller to continue.
> > 
> > bool completion_flush_start_nowait(struct completion *x)
> > 	returns a failure status if done == 0, otherwise decrements done
> > 	to zero and returns a "flush started" status. This is provided
> > 	to allow flushing to begin safely while holding object locks in
> > 	inverted order.
> > 
> > This replaces the use of semaphores for providing this exclusion
> > and completion mechanism.
> 
> Given that the only API call shared with normal completions is
> complete() I'd rather make this a primitive of it's own, even if
> internally implemented as completions.

Ok, so that involves exactly what? A new header file, a new API name
(ideas anyone?) and kerneldoc comments?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
