Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56451 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966108AbeBMX6S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Feb 2018 18:58:18 -0500
Date: Wed, 14 Feb 2018 10:58:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Cleanup old XFS_BTREE_* traces
Message-ID: <20180213235814.GH6778@dastard>
References: <20180212130005.7199-1-cmaiolino@redhat.com>
 <20180212182948.GB5217@magnolia>
 <20180212212106.GD6778@dastard>
 <20180213231731.GF5217@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213231731.GF5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On Tue, Feb 13, 2018 at 03:17:31PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 13, 2018 at 08:21:06AM +1100, Dave Chinner wrote:
> > On Mon, Feb 12, 2018 at 10:29:48AM -0800, Darrick J. Wong wrote:
> > > On Mon, Feb 12, 2018 at 02:00:05PM +0100, Carlos Maiolino wrote:
> > > > Remove unused legacy btree traces from IRIX era.
> > > > 
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > ---
> > > > 
> > > > Talking to Dave about it, he mentioned XFS_BTREE_TRACE_CURSOR might be worth to
> > > > turn into a proper ftrace trace point, so I didn't touch _CURSOR traces in this
> > > > patchset, and a proper conversion will be sent later, unless it's not worth at
> > > > all, and I should send a V2 also removing TRACE_CURSOR.
> > > 
> > > TBH I wonder the opposite -- why not turn all of these into tracepoints?
> > 
> > TBH, we haven't used them in at least 15 years. What value do they
> > provide apart from making the traces even noisier (and potentially
> > more lossy) than they already are?
> 
> FWIW adding trace_printks to some of those functions was rather useful
> for checking that the unusual refcount and rmap btree semantics actually
> resulted in calls to the desired btree functions.  I wish I'd cleaned up
> that debugging patch and sent it, but it's lost now.

Ok, so the non-cursor traces would have been useful to you.
That's fine - I just don't want to add stuff that doesn't have any
specific use because it's already hard enough to filter traces down
to just the things we need to see....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
