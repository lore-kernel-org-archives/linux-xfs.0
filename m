Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Oct 2006 01:50:45 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9Q8oWaG012020
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 01:50:33 -0700
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3E0D4D0557
	for <xfs@oss.sgi.com>; Thu, 26 Oct 2006 01:49:44 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Date: Thu, 26 Oct 2006 10:48:15 +0200
References: <1161576735.3466.7.camel@nigel.suspend2.net> <20061026073022.GG8394166@melbourne.sgi.com> <1161850709.17293.23.camel@nigel.suspend2.net>
In-Reply-To: <1161850709.17293.23.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200610261048.15819.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nigel Cunningham <ncunningham@linuxmail.org>
Cc: David Chinner <dgc@sgi.com>, Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thursday, 26 October 2006 10:18, Nigel Cunningham wrote:
> Hi Dave.
> 
> On Thu, 2006-10-26 at 17:30 +1000, David Chinner wrote:
> > On Wed, Oct 25, 2006 at 09:05:56PM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, 25 October 2006 15:23, Nigel Cunningham wrote:
> > > > > 
> > > > > Well, my impression is that this is exactly what happens here: Something
> > > > > in the XFS code causes metadata to be written to disk _after_ the atomic
> > > > > snapshot.
> > > > > 
> > > > > That's why I asked if the dirty XFS metadata were flushed by a kernel thread.
> > > > 
> > > > When I first added bdev freezing it was because there was an XFS timer
> > > > doing writes.
> > > 
> > > Yes, I noticed you said that, but I'd like someone from the XFS team to either
> > > confirm or deny it.
> > 
> > We have daemons running in the background that can definitely do stuff
> > after a sync. hmm - one does try_to_freeze() after a wakeup, the
> > other does:
> > 
> >                 if (unlikely(freezing(current))) {
> >                         set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> >                         refrigerator();
> >                 } else {
> >                         clear_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> >                 }
> > 
> > before it goes to sleep. So that one (xfsbufd - metadata buffer flushing)
> > can definitely wake up after the sync and do work,

Once it's entered the refrigerator, it won't return from it before
freeze_processes() is called (usually during the resume).

> > and the other could if the kernel thread freeze occurs after the sync.

Even if it does anything after the sync, it's okay as long as that's before we
create the image.  And it is, because both threads are frozen before we do it.

> > Another good question at this point - exactly how should we be putting
> > these thread to to sleep? Are both these valid methods for freezing them?
> > And should we be freezing when we wake up instead of before we go to
> > sleep? i.e. what are teh rules we are supposed to be following?
> 
> As you have them at the moment, the threads seem to be freezing fine.

Yes.  IMO they are freezing fine.

In fact the suspend would fail if they didn't freeze unless one of them had
PF_NOFREEZE set.

Greetings,
Rafael


-- 
You never change things by fighting the existing reality.
		R. Buckminster Fuller
