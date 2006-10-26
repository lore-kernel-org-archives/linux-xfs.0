Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 00:31:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9Q7VPaG025363
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 00:31:28 -0700
Date: Thu, 26 Oct 2006 17:30:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061026073022.GG8394166@melbourne.sgi.com>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <200610251432.41958.rjw@sisk.pl> <1161782620.3638.0.camel@nigel.suspend2.net> <200610252105.56862.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200610252105.56862.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <ncunningham@linuxmail.org>, Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Oct 25, 2006 at 09:05:56PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, 25 October 2006 15:23, Nigel Cunningham wrote:
> > > 
> > > Well, my impression is that this is exactly what happens here: Something
> > > in the XFS code causes metadata to be written to disk _after_ the atomic
> > > snapshot.
> > > 
> > > That's why I asked if the dirty XFS metadata were flushed by a kernel thread.
> > 
> > When I first added bdev freezing it was because there was an XFS timer
> > doing writes.
> 
> Yes, I noticed you said that, but I'd like someone from the XFS team to either
> confirm or deny it.

We have daemons running in the background that can definitely do stuff
after a sync. hmm - one does try_to_freeze() after a wakeup, the
other does:

                if (unlikely(freezing(current))) {
                        set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
                        refrigerator();
                } else {
                        clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
                }

before it goes to sleep. So that one (xfsbufd - metadata buffer flushing)
can definitely wake up after the sync and do work, and the other could if
the kernel thread freeze occurs after the sync.

Another good question at this point - exactly how should we be putting
these thread to to sleep? Are both these valid methods for freezing them?
And should we be freezing when we wake up instead of before we go to
sleep? i.e. what are teh rules we are supposed to be following?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
