Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 17:44:41 -0700 (PDT)
Received: from smtp114.sbc.mail.mud.yahoo.com (smtp114.sbc.mail.mud.yahoo.com [68.142.198.213])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6H0iHDW019901
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 17:44:23 -0700
Date: Sun, 16 Jul 2006 17:43:54 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: XFS and write barrier
Message-ID: <20060717004354.GA27193@tuatara.stupidest.org>
References: <200607151248.56603.Martin@lichtvoll.de> <20060715192857.GA11034@tuatara.stupidest.org> <200607161153.40130.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200607161153.40130.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

On Sun, Jul 16, 2006 at 11:53:39AM +0200, Martin Steigerwald wrote:

> yes, but for 2.6.17 which was still in development. The stable
> release of it appeared kernel.org on 18-Jun-2006 02:10 according to
> the date in the file listing there!

well, i guess it depends how you look at it

> What I would like to know whether its safe to use write barriers
> with 2.6.16 or even 2.6.15 (if it is possible at all) as well (I
> guess there are not many distributions that shipd with 2.6.17
> already) or whether one might face those "intermittent IO errors" -
> whatever they are - when using them.

some people (myself included) saw problems when write barriers were
enabled, but that was quite some time ago and it wasn't clear if this
was really an xfs, a write-barrier or some other coincidental problem
at the time

the problems never cause any significant on-disk damage (perhaps none
at all, i don't recall the details other than it would crash often
during large rsync jobs until i disabled it)

write barrier support appear november last year, so a lot has changed
since then

fwiw, w/o write barries if your disks have write caching enabled (most
will, they are horribly slow and worse some die without it) then you
can trivially create corrupted volumes (do something like cp -Rl src
dst and drop power or yank a hot-plug drive)

> If I do not find anything more on this I will recommend 2.6.17 for
> XFS with write barrier usages as I am pretty much convinced that it
> works stable from my own experience. (See my other post.)

you probably want 2.6.17.5+ as that has a fix for a very hard to hit
bug (that seemingly a few people may have hit)
