Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41975 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750753AbeBSFCL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Feb 2018 00:02:11 -0500
Date: Mon, 19 Feb 2018 16:02:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: freezing system for several second on high I/O [kernel 4.15]
Message-ID: <20180219050209.GY7000@dastard>
References: <1518255240.31843.6.camel@gmail.com>
 <1518255352.31843.8.camel@gmail.com>
 <20180211225657.GA6778@dastard>
 <1518643669.6070.21.camel@gmail.com>
 <20180214215245.GI7000@dastard>
 <1518666178.6070.25.camel@gmail.com>
 <20180215054436.GN7000@dastard>
 <CABXGCsOpJU4WU2w5DYBA+Q1nquh14zN0oCW6OfCbhTOFYLwO5w@mail.gmail.com>
 <20180215214858.GQ7000@dastard>
 <CABXGCsMK61J_+3c4JaXoi1e6aZzngvkQ29zRvQAj3nNcRpv5-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABXGCsMK61J_+3c4JaXoi1e6aZzngvkQ29zRvQAj3nNcRpv5-Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

On Sun, Feb 18, 2018 at 07:02:37PM +0500, Mikhail Gavrilov wrote:
> On 16 February 2018 at 02:48, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Feb 16, 2018 at 12:02:28AM +0500, Mikhail Gavrilov wrote:
> >> On 15 February 2018 at 10:44, Dave Chinner <david@fromorbit.com> wrote:
> >> > I've already explained that we can't annotate these memory
> >> > allocations to turn off the false positives because that will also
> >> > turning off all detection of real deadlock conditions.  Lockdep has
> >> > many, many limitations, and this happens to be one of them.
> >> >
> >> > FWIW, is there any specific reason you running lockdep on your
> >> > desktop system?
> >>
> >> Because I wanna make open source better (help fixing all freezing)
> >
> > lockdep isn't a user tool - most developers don't even understand
> > what it tries to tell them. Worse, it is likely contributing to your
> > problems as it has a significant runtime CPU and memory overhead....
> 
> I don't know how else collect debug info about freezes which occurring
> accidentally. Is there a better idea?

Lockdep tells us about locking problems, not arbitrary operational
latencies. Go look at the bcc collection of tools for tracking down
where latencies occur in the system.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
