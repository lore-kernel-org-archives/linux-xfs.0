Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 07:46:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9OEjoaG007328
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 07:45:53 -0700
Date: Wed, 25 Oct 2006 00:44:46 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061024144446.GD11034@melbourne.sgi.com>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200610231236.54317.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com

On Mon, Oct 23, 2006 at 12:36:53PM +0200, Rafael J. Wysocki wrote:
> On Monday, 23 October 2006 06:12, Nigel Cunningham wrote:
> > XFS can continue to submit I/O from a timer routine, even after
> > freezeable kernel and userspace threads are frozen. This doesn't seem to
> > be an issue for current swsusp code,
> 
> So it doesn't look like we need the patch _now_.
> 
> > but is definitely an issue for Suspend2, where the pages being written could
> > be overwritten by Suspend2's atomic copy.
> 
> And IMO that's a good reason why we shouldn't use RCU pages for storing the
> image.  XFS is one known example that breaks things if we do so and
> there may be more such things that we don't know of.  The fact that they
> haven't appeared in testing so far doesn't mean they don't exist and
> moreover some things like that may appear in the future.

Could you please tell us which XFS bits are broken so we can get
them fixed?  The XFS daemons should all be checking if they are
supposed to freeze (i.e. they call try_to_freeze() after they wake
up due to timer expiry) so I thought they were doing the right
thing.

However, I have to say that I agree with freezing the filesystems
before suspend - at least XFS will be in a consistent state that can
be recovered from without corruption if your machine fails to
resume....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
