Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 19:15:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l592FnWt016208
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 19:15:51 -0700
Date: Sat, 9 Jun 2007 12:15:35 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070609021535.GG86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost> <20070608101532.GA18788@teal.hq.k1024.org> <20070608151223.GF86004887@sgi.com> <20070608160318.GA25579@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608160318.GA25579@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Ruben Porras <nahoo82@gmail.com>, xfs@oss.sgi.com, cw@f00f.org

On Fri, Jun 08, 2007 at 06:03:18PM +0200, Iustin Pop wrote:
> On Sat, Jun 09, 2007 at 01:12:23AM +1000, David Chinner wrote:
> > > I took a look at both items since this discussion started. And honestly,
> > > I think 1) is harder that 4), so you're welcome to work on it :) The
> > > points that make it harder is that, per David's suggestion, there needs
> > > to be:
> > >  - define two new transaction types
> > 
> > one new transaction type:
> > 
> > XFS_TRANS_AGF_FLAGS
> > 
> > and and extension to xfs_alloc_log_agf(). Is about all that is
> > needed there.
> > 
> > See the patch here:
> > 
> > http://oss.sgi.com/archives/xfs/2007-04/msg00103.html
> 
> Ah, I see now. I was wondering how one can enable the new bits (CVS
> xfs_db shows the btreeblks but 'version' cmd doesn't allow to change
> them), it seems that manual xfs_db work + xfs_repair allows them.

The xfs_db work needs to be wrapped up in xfs_admin. That's relatively
simple to do, but the repair stage is needed to count the btree blocks
and update the counter in eah AGF. That could probably also be wrapped
up in an xfs_db script so conversion wouldn't require you to run
repair....

> > For an example of a very simlar transaction to what is needed
> > (look at xfs_log_sbcount()) and very similar addition to
> > the AGF (xfs_btreeblks).
> Just a question: why do you think this per-ag-bit to be persistent?

Shrinking is not the only reason why you might want to prevent
allocation within an AG. While we might be able to get away with a
totally in memory flag for a shrink, I really don't want to have
multiple mechanisms for doing roughly the same thing.

e.g. Think of fault tolerance - you detect a free space btree
corruption, so you prevent allocation and freeing in that AG (by
setting the relevant bits) until you can come along and repair it.
If you want to do online repair of this sort of corruption, then you
need to be able to stop the trees from being used between the time
that the corruption is detected and the time it is repair. That may
be longer than the filesystem is currently mounted...

> I'm
> just curious. When I first thought about this, I was thinking more like
> this should be an in-core flag only, like the freeze flag is for the
> filesystem. The idea being that you don't need to recover this state
> after a crash

But a freeze is different - it's not modifying the filesystem,
just bringing it down into a consistent state. A shrink is a
modification operation, and so if it crashes half way though,
we need to ensure that recovery doesn't do silly things. Hence
it is best to have all the state associated with the shrink
journalled and recoverable. i.e. persistent.

> - there is no actual state, just restart the shrink
> operation if you want. And no actual filesystem state (e.g. space
> allocation or such) is happenning when you toggle the AGs not
> allocatable. This would allow a much simpler implementation of the
> 'no-alloc' part.

True, but much it would be much more limited in it's potential use.

> > >  - update the ondisk-format (!), if we want persistence of these flags;
> > >    luckily, there are two spare fields in the AGF structure.
> > 
> > Better to expand, I think. The AGF is a sector in length - we can
> > expand the structure as we need to this size without fear, esp. as
> > the part of the sector outside the structure is guaranteed to be
> > zero.  i.e. we can add a fields flag to the end of the AGF
> > structure - old filesystems simple read as "no flags set" and
> > old kernels never look at those bits....
> Yes, makes sense. Just to make sure: the xfs_agf_t, xfs_agi_t and
> xfs_sb_t structures as defined in xfs_sb.h and xfs_ag.h are what
> actually is on-disk, right? Adding to them, defining the new bits i.e.
> XFS_AGF_FLAGS and bumping up XFS_AGF_ALL_BITS should take care of the
> on-disk part?

Don't forget to modify xfs_alloc_log_agf() as well ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
