Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Mar 2007 14:33:21 -0700 (PDT)
Received: from smtp107.sbc.mail.mud.yahoo.com (smtp107.sbc.mail.mud.yahoo.com [68.142.198.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2ILXG6p005661
	for <linux-xfs@oss.sgi.com>; Sun, 18 Mar 2007 14:33:18 -0700
Date: Sun, 18 Mar 2007 14:33:13 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: cache+barriers vs cache+nobarriers vs disabled cache+barriers vs disabled cache+nobarriers
Message-ID: <20070318213313.GA23121@tuatara.stupidest.org>
References: <200703151339.36259.Martin@lichtvoll.de> <20070318101304.BAA2E193E9@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070318101304.BAA2E193E9@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Martin Steigerwald' <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com

On Sun, Mar 18, 2007 at 12:07:11PM +0200, Leon Kolchinsky wrote:

> My goal is to avoid filesystem corruption at any cost

doing what?  applications can still lose data if they're not careful

> (while trying to use fastest FS for linux) and according to the FAQ
> disabling write cache is the right way to do it.

unless you applications are care, it's typical that reliability is
going to cost in terms of performance

> Power/Hardware failure may occur in-between the flushes (with write
> barrier enabled) so the safe way (I think) is to disable write
> cache.

i've heard (but nobody has been able to give conrete details on this)
that disabling the write-cache on modern drives will lessen their
lifespan, often considerably

with write barriers sane applications should be just as safe as when
you disable the write cache

> It's interesting if there is a significant drop in the performance
> with disabled disk "write cache" and XFS filesystem comparing to
> ext3+enabled "write cache".

that's expected, w/o the write-cache drives are typically a lot slower
for many loads (why else would they put a write cache in disks afetr
all)

> Has anyone some statistics or tests comparing ext3+enabled write
> cache vs.  xfs+disabled write cache?

why would you compare those two?  why ext3 w/ caches enabled and xfs
w/ caches disabled?


anyhow, it depends on your load, for some loads ext3 is faster and
others xfs is faster


what access patterns are you expecting?
