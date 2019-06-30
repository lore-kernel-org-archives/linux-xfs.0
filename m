Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726827AbfF3XLi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 19:11:38 -0400
Date: Sun, 30 Jun 2019 16:11:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630231130.GA1654093@magnolia>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
 <20190630153955.GF1404256@magnolia>
 <20190630223605.GK7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190630223605.GK7777@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jul 01, 2019 at 08:36:05AM +1000, Dave Chinner wrote:
> On Sun, Jun 30, 2019 at 08:39:55AM -0700, Darrick J. Wong wrote:
> > On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> > > Hi,
> > > 
> > > I have been running with Dave's series for faster directory inserts since
> > > forever without any issues, and the last revision [1] still applies cleanly
> > > to current5.2-rc (not sure about xfs-next though).
> > > Any chance this can be included in 5.3? IMHO it would be a shame if this
> > > fell through the cracks again.
> > > 
> > > Thanks,
> > > Holger
> > > 
> > > [1] https://patchwork.kernel.org/project/xfs/list/?series=34713
> > 
> > Christoph reviewed most of the series, but it looked like he and Dave
> > went back and forth a bit on the second to last patch and Dave never
> > sent a v2 series or a request to just merge it as is, so I didn't take
> > any action.  Hey Dave, are you still working on a resubmission for this
> > series?
> 
> It's in my stack somewhere. Not for this cycle. Can't even remember
> what was the issue with it.  I'm pretty sure that was about when the
> whole copy file range debacle exploded in our faces, which was why
> there was no followup back then...

I vague recollection is that I looked at it and remember thinking it was
fine except maybe for the tweaks hch suggested, and then copyfilerange
blew up and that was it, everything got derailed. :(

/me shakes fist at crAPIs....

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
