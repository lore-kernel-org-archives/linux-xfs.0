Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Nov 2007 13:12:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lARLBvvf008710
	for <xfs@oss.sgi.com>; Tue, 27 Nov 2007 13:12:00 -0800
Date: Wed, 28 Nov 2007 08:11:58 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS related Oops (suspend/resume related)
Message-ID: <20071127211155.GK119954183@sgi.com>
References: <20071112064706.GA23595@dose.home.local> <20071126210844.GB119954183@sgi.com> <200711262307.56742.rjw@sisk.pl> <200711271651.39180.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711271651.39180.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Nov 27, 2007 at 04:51:38PM +0100, Rafael J. Wysocki wrote:
> On Monday, 26 of November 2007, Rafael J. Wysocki wrote:
> > On Monday, 26 of November 2007, David Chinner wrote:
> > > Now there's a message that I haven't seen in about 3 years.
> > > 
> > > It indicates that the linux inode connected to the xfs_inode is not
> > > the correct one. i.e. that the linux inode cache is out of step with
> > > the XFS inode cache.
> > > 
> > > Basically, that is not supposed to happen. I suspect that the way
> > > threads are frozen is resulting in an inode lookup racing with
> > > a reclaim. The reclaim thread gets stopped after any use threads,
> > > and so we could have the situation that a process blocked in lookup
> > > has the XFS inode reclaimed and reused before it gets unblocked.
> > > 
> > > The question is why is it happening now when none of that code in
> > > XFS has changed?
> > > 
> > > Rafael, when are threads frozen? Only when they schedule or call
> > > try_to_freeze()?
> > 
> > Kernel threads freeze only when they call try_to_freeze().  User space tasks
> > freeze while executing the signals handling code.
> > 
> > > Did the freezer mechanism change in 2.6.23 (this is on 2.6.23.1)?
> > 
> > Yes.  Kernel threads are not sent fake signals by the freezer any more.
> 
> Ah, sorry, this change has been merged after 2.6.23.  However, before 2.6.23
> we had another important change that caused all kernel threads to have
> PF_NOFREEZE set by default, unless they call set_freezable() explicitly.

So try_to_freeze() will never freeze a thread if it has not been
set_freezable()? And xfsbufd will never be frozen?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
