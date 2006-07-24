Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Jul 2006 17:03:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6O02YDW031087
	for <xfs@oss.sgi.com>; Sun, 23 Jul 2006 17:02:47 -0700
Date: Mon, 24 Jul 2006 10:01:48 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: review: fix remount vs barrier options
Message-ID: <20060724100147.F2083275@wobbly.melbourne.sgi.com>
References: <20060721152807.D1998769@wobbly.melbourne.sgi.com> <20060723190650.GA22180@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060723190650.GA22180@infradead.org>; from hch@infradead.org on Sun, Jul 23, 2006 at 08:06:50PM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, jeremy@sgi.com

On Sun, Jul 23, 2006 at 08:06:50PM +0100, Christoph Hellwig wrote:
> > It finally clicked that we are not clearing the buffer flag
> > from a previously written log buffer, even though we'll no
> > longer set a new flag into a buffer (due to the mount flag
> > being cleared), so we _can_ still issue barrier writes when
> > remounted without barriers.
> 
> That's true.  Ooops.
> 
> > This was made more complicated by the way a freshly mounted
> > filesystem with 8 log buffers wouldn't show up the problem,
> > since we have to slowly cycle through the "clear" log buffers
> > before we see the bug.  This seems like the simplest fix...
> > 
> > (Hmmm, actually, I wonder if this will also resolve the quota
> > log I/O problem that was reported the other day too).
> 
> Shouldn't we make sure we clear all flags when reusing a log buffer?
> Relying on clearing individual flags seems rather fragile to me.

*nod* - good idea.  I'll rework xlog_sync, and resend later.

thanks.

-- 
Nathan
