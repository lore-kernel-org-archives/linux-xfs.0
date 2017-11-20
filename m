Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57276 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751301AbdKTPmu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 10:42:50 -0500
Date: Mon, 20 Nov 2017 15:42:33 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [patch V2 02/11] LICENSES: Add the GPL 2.0 license
Message-ID: <20171120154233.GC31757@n2100.armlinux.org.uk>
References: <20171116183306.103584007@linutronix.de>
 <20171116184358.475929943@linutronix.de>
 <CAFGhKbxbW87yowc7trkiczjXV=37SqswwmOriTdSoxCXzFk-0A@mail.gmail.com>
 <CA+55aFz06uWZwjdgod4wd=dCY3wbU+4SdbhgNwsNzMFqUn2SiA@mail.gmail.com>
 <20171120153105.38d2b892@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171120153105.38d2b892@alans-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Charlemagne Lasse <charlemagnelasse@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>, Rob Herring <rob.herring@linaro.org>, Jonas Oberg <jonas@fsfe.org>, Joe Perches <joe@perches.com>, linux-xfs <linux-xfs@vger.kernel.org>, Carmen Bianca Bakker <carmenbianca@fsfe.org>

On Mon, Nov 20, 2017 at 03:31:05PM +0000, Alan Cox wrote:
> On Sat, 18 Nov 2017 11:14:00 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > You may be confusing things because of a newer version.
> > 
> > On Sat, Nov 18, 2017 at 11:03 AM, Charlemagne Lasse
> > <charlemagnelasse@gmail.com> wrote:
> > >
> > > That should be "GNU Lesser General Public" and not "GNU Library General Public"  
> > 
> > That's just FSF revisionism.
> > 
> > It used to be called "Library" over "Lesser", in the original GPL2.
> > 
> > I suspect your other issues are similar "there's been different
> > versions over time" things. the address being one of them.
> > 
> > We've actually taken some of the FSF updates over the years ("19yy" ->
> > "<year>", and the address change) but the main COPYING file still
> > calls the LGPL the "GNU Library General Public License".
> > 
> > I refuse to change the original copyright wording due to idiotic
> > internal FSF politics that tried to change history.
> 
> Do we have any files which had the later LGPL text attached to them - if
> so then they should be keeping that header.
> 
> Which raises another question. If there are multiple GPL 2.0 texts which
> are *supposedly* legally identical but this has never been tested in law
> -that implies SPDX is wrong in tagging them identically in case they turn
> out not to be...

There are also licenses that have been amended (sometimes incorrectly)
to convert them from GPL2+ to GPL2 only, and in the process messing up
the wording.  My understanding is that, even though it's obvious that
the wording is wrong, only the author(s) have the authority to correct
it for exactly the reason you give.

I have some DTS files that are blocked from being merged into the kernel
because of the license wording being messed up - but as I'm not the
author, I can't do anything about it.  People have tried sending me
patches to fix the license text, but I can't merge them because... I'm
not the author.  I've tried to get the author to ack them, but to no
success.

So, since many of us have contributed code under the exact license
given in the top-level "COPYING" file, this is the license text that
applies, and not any other text that someone else happens to call
"GPL 2".

This is exactly why I'm so concerned about the SPDX stuff, and I'm
glad that Thomas is trying to address the concerns that I've raised
with it by including the corresponding license texts with the kernel,
thereby making the kernel independent of the SPDX website.

I haven't been able to fully review Thomas' patches, but they're
definitely a step in the right direction - provided there's a
statement which indicates which is the authoritive reference for the
SPDX tags used in code merged into the kernel.  Without such a
statement, I can see lawyers arguing over that point.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
