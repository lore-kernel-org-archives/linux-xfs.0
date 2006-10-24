Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Oct 2006 09:41:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9OGf8aG027407
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 09:41:10 -0700
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87A69D1A56E6
	for <xfs@oss.sgi.com>; Tue, 24 Oct 2006 08:31:20 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Date: Tue, 24 Oct 2006 17:29:59 +0200
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610231236.54317.rjw@sisk.pl> <20061024144446.GD11034@melbourne.sgi.com>
In-Reply-To: <20061024144446.GD11034@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610241730.00488.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, xfs@oss.sgi.com

On Tuesday, 24 October 2006 16:44, David Chinner wrote:
> On Mon, Oct 23, 2006 at 12:36:53PM +0200, Rafael J. Wysocki wrote:
> > On Monday, 23 October 2006 06:12, Nigel Cunningham wrote:
> > > XFS can continue to submit I/O from a timer routine, even after
> > > freezeable kernel and userspace threads are frozen. This doesn't seem to
> > > be an issue for current swsusp code,
> > 
> > So it doesn't look like we need the patch _now_.
> > 
> > > but is definitely an issue for Suspend2, where the pages being written could
> > > be overwritten by Suspend2's atomic copy.
> > 
> > And IMO that's a good reason why we shouldn't use RCU pages for storing the
> > image.  XFS is one known example that breaks things if we do so and
> > there may be more such things that we don't know of.  The fact that they
> > haven't appeared in testing so far doesn't mean they don't exist and
> > moreover some things like that may appear in the future.
> 
> Could you please tell us which XFS bits are broken so we can get
> them fixed?  The XFS daemons should all be checking if they are
> supposed to freeze (i.e. they call try_to_freeze() after they wake
> up due to timer expiry) so I thought they were doing the right
> thing.
> 
> However, I have to say that I agree with freezing the filesystems
> before suspend - at least XFS will be in a consistent state that can
> be recovered from without corruption if your machine fails to
> resume....

Do you mean calling sys_sync() after the userspace has been frozen
may not be sufficient?

Greetings,
Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
