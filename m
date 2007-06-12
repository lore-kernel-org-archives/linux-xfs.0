Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Jun 2007 14:58:31 -0700 (PDT)
Received: from amd.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5CLwKWt001338
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2007 14:58:23 -0700
Date: Tue, 12 Jun 2007 23:31:59 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc3 hibernate(?) fails totally - regression (xfs on raid6)
Message-ID: <20070612213159.GB13747@elf.ucw.cz>
References: <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <46668EE0.2030509@dgreaves.com> <46679D56.7040001@gmail.com> <4667DE2D.6050903@dgreaves.com> <20070607110708.GS86004887@sgi.com> <46680F5E.6070806@dgreaves.com> <20070610184348.GA4417@ucw.cz> <466EDF24.2000806@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EDF24.2000806@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Hi!

> >>cu:~# mount -oremount,ro /huge
> >>cu:~# /usr/net/bin/hibernate
> >>[this works and resumes]
> >>
> >>cu:~# mount -oremount,rw /huge
> >>cu:~# /usr/net/bin/hibernate
> >>[this works and resumes too !]
> >>
> >>cu:~# touch /huge/tst
> >>cu:~# /usr/net/bin/hibernate
> >>[but this doesn't even hibernate]
> >
> >This is very probably separate problem... and you should have enough
> >data in dmesg to do something with it.
> 
> What makes you say it's a different problem - it's hanging at the same 
> point visually - it's just that one is pre suspend, one is post suspend.

Ok, I did not see the visuals.

> It all feels very related to me - the behaviour all hinges around the same 
> patch too.
> 
> I'll take a look in dmesg though...
> 
> David
> 
> PS, looks like some mail holdups somewhere...
> Received: from spitz.ucw.cz (gprs189-60.eurotel.cz [160.218.189.60])
> 	by mail.ukfsn.org (Postfix) with ESMTP id A9125E6AE9
> 	for <david@dgreaves.com>; Tue, 12 Jun 2007 15:41:23 +0100 (BST)
> Received: by spitz.ucw.cz (Postfix, from userid 0)
> 	id E05FC279F2; Sun, 10 Jun 2007 18:43:48 +0000 (UTC)
> Date: Sun, 10 Jun 2007 18:43:48 +0000

Yep, that's normal, spitz is 0.3kg machine connected over gprs. Okay,
I should probably try to sync it more often than once in two days.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
