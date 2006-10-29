Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Oct 2006 09:36:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9THanaG025124
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 09:36:50 -0800
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA0DAD1B2079
	for <xfs@oss.sgi.com>; Sun, 29 Oct 2006 09:36:02 -0800 (PST)
Date: Sun, 29 Oct 2006 18:35:37 +0100
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Freeze bdevs when freezing processes.
Message-ID: <20061029173537.GA3022@elf.ucw.cz>
References: <1161576735.3466.7.camel@nigel.suspend2.net> <1161850709.17293.23.camel@nigel.suspend2.net> <20061026085700.GI8394166@melbourne.sgi.com> <200610261111.30486.rjw@sisk.pl> <20061027013802.GQ8394166@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061027013802.GQ8394166@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Nigel Cunningham <ncunningham@linuxmail.org>, Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

Hi!

> > > > As you have them at the moment, the threads seem to be freezing fine.
> > > > The issue I've seen in the past related not to threads but to timer
> > > > based activity. Admittedly it was 2.6.14 when I last looked at it, but
> > > > there used to be a possibility for XFS to submit I/O from a timer when
> > > > the threads are frozen but the bdev isn't frozen. Has that changed?
> > > 
> > > I didn't think we've ever done that - periodic or delayed operations
> > > are passed off to the kernel threads to execute. A stack trace
> > > (if you still have it) would be really help here.
> > > 
> > > Hmmm - we have a couple of per-cpu work queues as well that are
> > > used on I/O completion and that can, in some circumstances,
> > > trigger new transactions. If we are only flush metadata, then
> > > I don't think that any more I/o will be issued, but I could be
> > > wrong (maze of twisty passages).
> > 
> > Well, I think this exactly is the problem, because worker_threads run with
> > PF_NOFREEZE set (as I've just said in another message).
> 
> Ok, so freezing the filesystem is the only way you can prevent
> this as the workqueues are flushed as part of quiescing the filesystem.

Well, alternative is to teach XFS to sense that we are being frozen
and stop disk writes in such case.

OTOH freeze_bdevs is perhaps not that bad solution... 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
