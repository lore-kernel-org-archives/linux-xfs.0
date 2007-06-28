Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 15:09:35 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5SM9OtL028848
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 15:09:26 -0700
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Date: Fri, 29 Jun 2007 00:16:44 +0200
References: <46744065.6060605@dgreaves.com> <200706281727.35430.rjw@sisk.pl> <20070628220045.GA4521@elf.ucw.cz>
In-Reply-To: <20070628220045.GA4521@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706290016.45719.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Pavel Machek <pavel@ucw.cz>
Cc: David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>, LVM general discussion and development <linux-lvm@redhat.com>, David Robinson <zxvdr.au@gmail.com>, David Greaves <david@dgreaves.com>, Oleg Nesterov <oleg@tv-sign.ru>

On Friday, 29 June 2007 00:00, Pavel Machek wrote:
> On Thu 2007-06-28 17:27:34, Rafael J. Wysocki wrote:
> > On Wednesday, 27 June 2007 22:49, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> > > > filesystem for a suspend/resume to work safely and have argued that the only
> > > 
> > > Hmm, so XFS writes to disk even when its threads are frozen?
> > > 
> > > > safe thing to do is freeze the filesystem before suspend and thaw it after
> > > > resume. This is why I originally asked you to test that with the other problem
> > > 
> > > Could you add that to the XFS threads if it is really required? They
> > > do know that they are being frozen for suspend.
> > 
> > Well, do you remember the workqueues?  They are still nonfreezable.
> 
> Oops, that would explain it :-(. Can we make XFS stop using them?

I'm afraid that we can't.

There are two solutions possible, IMO.  One would be to make these workqueues
freezable, which is possible, but hacky and Oleg didn't like that very much.
The second would be to freeze XFS from within the hibernation code path,
using freeze_bdev().

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
