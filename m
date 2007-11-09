Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 19:17:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA93GxfV001867
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 19:17:02 -0800
Date: Fri, 9 Nov 2007 14:16:55 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH, RFC] Move AIL pushing into a separate thread
Message-ID: <20071109031655.GQ66820511@sgi.com>
References: <20071105050706.GW66820511@sgi.com> <4733AB27.70208@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4733AB27.70208@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Nov 09, 2007 at 11:34:47AM +1100, Lachlan McIlroy wrote:
> I like the sound of this Dave.  I'm still going through the code in
> detail.
> 
> Could we convert the ail lock into a mutex to ease the load?  I know
> it may not improve throughput but it would at least relieve the CPUs
> to do other stuff.

Most of the time the ail lock is used for very short periods of
time, (e.g.  less than ten lines of code) so a spin lock is
appropriate. What we are seeing here is too many CPUs holding it for
to long trying to do the work one CPU could easily do.

i.e. the bug we are seeing here is the contention on the lock, not
the type of lock. If we change to a sleeping lock, all ppl will see
is a slowdown and that is much, much harder to diagnose on a
production system than spin lock contention....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
