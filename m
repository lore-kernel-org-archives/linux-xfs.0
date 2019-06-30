Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33280 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727131AbfF3WhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Jun 2019 18:37:17 -0400
Date: Mon, 1 Jul 2019 08:36:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Include 'xfs: speed up large directory modifications' in 5.3?
Message-ID: <20190630223605.GK7777@dread.disaster.area>
References: <56158aa8-c07a-f90f-a166-b2eeb226bb4a@applied-asynchrony.com>
 <20190630153955.GF1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190630153955.GF1404256@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Sun, Jun 30, 2019 at 08:39:55AM -0700, Darrick J. Wong wrote:
> On Sun, Jun 30, 2019 at 01:28:09PM +0200, Holger Hoffstätte wrote:
> > Hi,
> > 
> > I have been running with Dave's series for faster directory inserts since
> > forever without any issues, and the last revision [1] still applies cleanly
> > to current5.2-rc (not sure about xfs-next though).
> > Any chance this can be included in 5.3? IMHO it would be a shame if this
> > fell through the cracks again.
> > 
> > Thanks,
> > Holger
> > 
> > [1] https://patchwork.kernel.org/project/xfs/list/?series=34713
> 
> Christoph reviewed most of the series, but it looked like he and Dave
> went back and forth a bit on the second to last patch and Dave never
> sent a v2 series or a request to just merge it as is, so I didn't take
> any action.  Hey Dave, are you still working on a resubmission for this
> series?

It's in my stack somewhere. Not for this cycle. Can't even remember
what was the issue with it.  I'm pretty sure that was about when the
whole copy file range debacle exploded in our faces, which was why
there was no followup back then...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
