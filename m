Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40034 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030221AbeBNNwE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Feb 2018 08:52:04 -0500
Received: by mail-wr0-f194.google.com with SMTP id o76so6795wrb.7
        for <linux-xfs@vger.kernel.org>; Wed, 14 Feb 2018 05:52:03 -0800 (PST)
Date: Wed, 14 Feb 2018 14:52:00 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] Cleanup old XFS_BTREE_* traces
Message-ID: <20180214135200.krlhiakaevsh5hi5@odin.usersys.redhat.com>
References: <20180212130005.7199-1-cmaiolino@redhat.com>
 <20180212182948.GB5217@magnolia>
 <20180212212106.GD6778@dastard>
 <20180213231731.GF5217@magnolia>
 <20180213235814.GH6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213235814.GH6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Feb 14, 2018 at 10:58:14AM +1100, Dave Chinner wrote:
> On Tue, Feb 13, 2018 at 03:17:31PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 13, 2018 at 08:21:06AM +1100, Dave Chinner wrote:
> > > On Mon, Feb 12, 2018 at 10:29:48AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Feb 12, 2018 at 02:00:05PM +0100, Carlos Maiolino wrote:
> > > > > Remove unused legacy btree traces from IRIX era.
> > > > > 
> > > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > > ---
> > > > > 
> > > > > Talking to Dave about it, he mentioned XFS_BTREE_TRACE_CURSOR might be worth to
> > > > > turn into a proper ftrace trace point, so I didn't touch _CURSOR traces in this
> > > > > patchset, and a proper conversion will be sent later, unless it's not worth at
> > > > > all, and I should send a V2 also removing TRACE_CURSOR.
> > > > 
> > > > TBH I wonder the opposite -- why not turn all of these into tracepoints?
> > > 
> > > TBH, we haven't used them in at least 15 years. What value do they
> > > provide apart from making the traces even noisier (and potentially
> > > more lossy) than they already are?
> > 
> > FWIW adding trace_printks to some of those functions was rather useful
> > for checking that the unusual refcount and rmap btree semantics actually
> > resulted in calls to the desired btree functions.  I wish I'd cleaned up
> > that debugging patch and sent it, but it's lost now.
> 

I see your point, although, for me, it sounds like a very specific debug case,
and not something which would add enough benefit to have these extra debug
traces lying around.

I mean, if we keep adding trace points for many single debug use-cases, we would
end up with tons of trace points in xfs, which are not used in 99% of the debugging
processes.

But well, I don't have a decent knowledge in the Btrees infra-structure yet to
give a more detailed reason if such extra trace points would be useful or not in
several situations. So, this is just my $0.02, based on the amount of trace
points we already have, where, most of time I use one or another, and yet, I
need to add my own trace_printks, so, particularly, I don't think adding such
extra traces in Btree code would be that useful in a long-term period, but well,
as I said, just my $0.02.

> Ok, so the non-cursor traces would have been useful to you.
> That's fine - I just don't want to add stuff that doesn't have any
> specific use because it's already hard enough to filter traces down
> to just the things we need to see....
> 

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
Carlos
