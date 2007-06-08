Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 09:04:03 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58G3wWt002739
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 09:03:59 -0700
Date: Fri, 8 Jun 2007 18:03:18 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS shrink functionality
Message-ID: <20070608160318.GA25579@teal.hq.k1024.org>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost> <20070608101532.GA18788@teal.hq.k1024.org> <20070608151223.GF86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608151223.GF86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Ruben Porras <nahoo82@gmail.com>, xfs@oss.sgi.com, cw@f00f.org

On Sat, Jun 09, 2007 at 01:12:23AM +1000, David Chinner wrote:
> > I took a look at both items since this discussion started. And honestly,
> > I think 1) is harder that 4), so you're welcome to work on it :) The
> > points that make it harder is that, per David's suggestion, there needs
> > to be:
> >  - define two new transaction types
> 
> one new transaction type:
> 
> XFS_TRANS_AGF_FLAGS
> 
> and and extension to xfs_alloc_log_agf(). Is about all that is
> needed there.
> 
> See the patch here:
> 
> http://oss.sgi.com/archives/xfs/2007-04/msg00103.html

Ah, I see now. I was wondering how one can enable the new bits (CVS
xfs_db shows the btreeblks but 'version' cmd doesn't allow to change
them), it seems that manual xfs_db work + xfs_repair allows them.

> For an example of a very simlar transaction to what is needed
> (look at xfs_log_sbcount()) and very similar addition to
> the AGF (xfs_btreeblks).
Just a question: why do you think this per-ag-bit to be persistent? I'm
just curious. When I first thought about this, I was thinking more like
this should be an in-core flag only, like the freeze flag is for the
filesystem. The idea being that you don't need to recover this state
after a crash - there is no actual state, just restart the shrink
operation if you want. And no actual filesystem state (e.g. space
allocation or such) is happenning when you toggle the AGs not
allocatable. This would allow a much simpler implementation of the
'no-alloc' part.

> >  - update the ondisk-format (!), if we want persistence of these flags;
> >    luckily, there are two spare fields in the AGF structure.
> 
> Better to expand, I think. The AGF is a sector in length - we can
> expand the structure as we need to this size without fear, esp. as
> the part of the sector outside the structure is guaranteed to be
> zero.  i.e. we can add a fields flag to the end of the AGF
> structure - old filesystems simple read as "no flags set" and
> old kernels never look at those bits....
Yes, makes sense. Just to make sure: the xfs_agf_t, xfs_agi_t and
xfs_sb_t structures as defined in xfs_sb.h and xfs_ag.h are what
actually is on-disk, right? Adding to them, defining the new bits i.e.
XFS_AGF_FLAGS and bumping up XFS_AGF_ALL_BITS should take care of the
on-disk part?

> > Open questions (re. point 4):
> >  - the filesystem document says the agf->agf_btreeblks is held only in
> >    case we have an extended flag active for the filesystem
> >    (XFS_SB_VERSION2_LAZYSBCOUNTBIT); is this true? without this, I'm not
> >    sure how to calculate this number of blocks nicely
> 
> Yes, that is true. There's a pre-req for shrinking for the moment :/
> 
> >  - or can I assume that an empty AG will *always* have agf_levels = 1
> >    for both Btrees, so there are no extra blocks actually used for the
> >    btrees (except for the two reserved ones at the beggining of the AG
> 
> Yes, that is a valid assumption.
Ok, perfect. This then eliminates the need for LAZYSBCOUNTBIT. Just one
more question: can I *read* from the mp->m_perag structure or do I need
a lock (even for read), i.e. down_read, read the fields, up_read? (As
you can see, I don't have much experience w.r.t. kernel programming).

> >  - can I assume that an AG with agi->icount == agi->ifree == 0 will have
> >    no blocks used for the inode btrees (logically yes, but I'm not sure)
> 
> yes.

Good.

Thanks for your explanations. Patch for shrink if the AGs are empty will
be simpler and nicer then as opposed to what I have now.

iustin
