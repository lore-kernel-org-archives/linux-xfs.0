Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 01:19:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9Q8JJaG004726
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 01:19:20 -0700
Received: from pop5-1.us4.outblaze.com (pop5-1.us4.outblaze.com [205.158.62.125])
	by cuda.sgi.com (Spam Firewall) with SMTP id 019CFD14CCE5
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 01:18:34 -0700 (PDT)
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
From: Nigel Cunningham <ncunningham@linuxmail.org>
In-Reply-To: <20061026073022.GG8394166@melbourne.sgi.com>
References: <1161576735.3466.7.camel@nigel.suspend2.net>
	 <200610251432.41958.rjw@sisk.pl>
	 <1161782620.3638.0.camel@nigel.suspend2.net>
	 <200610252105.56862.rjw@sisk.pl>
	 <20061026073022.GG8394166@melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 26 Oct 2006 18:18:29 +1000
Message-Id: <1161850709.17293.23.camel@nigel.suspend2.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi Dave.

On Thu, 2006-10-26 at 17:30 +1000, David Chinner wrote:
> On Wed, Oct 25, 2006 at 09:05:56PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 25 October 2006 15:23, Nigel Cunningham wrote:
> > > > 
> > > > Well, my impression is that this is exactly what happens here: Something
> > > > in the XFS code causes metadata to be written to disk _after_ the atomic
> > > > snapshot.
> > > > 
> > > > That's why I asked if the dirty XFS metadata were flushed by a kernel thread.
> > > 
> > > When I first added bdev freezing it was because there was an XFS timer
> > > doing writes.
> > 
> > Yes, I noticed you said that, but I'd like someone from the XFS team to either
> > confirm or deny it.
> 
> We have daemons running in the background that can definitely do stuff
> after a sync. hmm - one does try_to_freeze() after a wakeup, the
> other does:
> 
>                 if (unlikely(freezing(current))) {
>                         set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
>                         refrigerator();
>                 } else {
>                         clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
>                 }
> 
> before it goes to sleep. So that one (xfsbufd - metadata buffer flushing)
> can definitely wake up after the sync and do work, and the other could if
> the kernel thread freeze occurs after the sync.
> 
> Another good question at this point - exactly how should we be putting
> these thread to to sleep? Are both these valid methods for freezing them?
> And should we be freezing when we wake up instead of before we go to
> sleep? i.e. what are teh rules we are supposed to be following?

As you have them at the moment, the threads seem to be freezing fine.
The issue I've seen in the past related not to threads but to timer
based activity. Admittedly it was 2.6.14 when I last looked at it, but
there used to be a possibility for XFS to submit I/O from a timer when
the threads are frozen but the bdev isn't frozen. Has that changed?

Regards,

Nigel
