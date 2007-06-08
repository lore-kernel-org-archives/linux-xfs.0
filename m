Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 08:12:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l58FCYWt022306
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 08:12:36 -0700
Date: Sat, 9 Jun 2007 01:12:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS shrink functionality
Message-ID: <20070608151223.GF86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost> <20070608101532.GA18788@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608101532.GA18788@teal.hq.k1024.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, cw@f00f.org

On Fri, Jun 08, 2007 at 12:15:32PM +0200, Iustin Pop wrote:
> On Fri, Jun 08, 2007 at 10:23:53AM +0200, Ruben Porras wrote:
> > Am Montag, den 04.06.2007, 10:41 +0200 schrieb Iustin Pop:
> > > Good to know. If there is at least more documentation about the
> > > internals, I could try to find some time to work on this again.
> > 
> > there is now a document explaining the XFS on disk format [0] and some
> > presentations for training courses, I think none of this were available
> > at the time you made the first try. Although they are not enough for our
> > purpose. 
> > 
> 
> Yes, just yesterday I found the document and it helps.
> 
> > > My suggestion would be to start implementing these steps in reverse. 4)
> > > is the most important as it touches the entire FS. If 4) is working
> > > correctly, then 1) would be simpler (I think)
> > 
> > Why do you think that 1) would be simpler after 4)? For what I
> > understand, they are independent.
> Not after that in the cronological sense, but in the importance part.
> Yes, it was a bad choice of words.
> 
> > 3) worries me, if walking the entire filesystem is needed, it want
> > scale...
> >   
> > Since I don't know yet the xfs code I would like to begin with 1), I see
> > it independent from the other parts, and I can then learn more about the
> > transactions, allocators, and walking through the xfs structures. As you
> > did 4) one time, maybe you could try with this part of the problem if
> > you find the needed time, taking David's suggestions into account.
> 
> I took a look at both items since this discussion started. And honestly,
> I think 1) is harder that 4), so you're welcome to work on it :) The
> points that make it harder is that, per David's suggestion, there needs
> to be:
>  - define two new transaction types

one new transaction type:

XFS_TRANS_AGF_FLAGS

and and extension to xfs_alloc_log_agf(). Is about all that is
needed there.

See the patch here:

http://oss.sgi.com/archives/xfs/2007-04/msg00103.html

For an example of a very simlar transaction to what is needed
(look at xfs_log_sbcount()) and very similar addition to
the AGF (xfs_btreeblks).

>  - define two new ioctls

XFS_IOC_ALLOC_ALLOW_AG, parameter xfsagnumber_t.
XFS_IOC_ALLOC_DENY_AG, parameter xfsagnumber_t.

>  - update the ondisk-format (!), if we want persistence of these flags;
>    luckily, there are two spare fields in the AGF structure.

Better to expand, I think. The AGF is a sector in length - we can
expand the structure as we need to this size without fear, esp. as
the part of the sector outside the structure is guaranteed to be
zero.  i.e. we can add a fields flag to the end of the AGF
structure - old filesystems simple read as "no flags set" and
old kernels never look at those bits....

>  - check the list of allocation functions that allocate space from the
>    AG

> I did some preliminary work on this but just a little.
> 
> I think that after the weekend I'll send an updated patch of 4). I have
> one working now with the current CVS tree, just that it's still ugly and
> needs polishing.
> 
> Open questions (re. point 4):
>  - the filesystem document says the agf->agf_btreeblks is held only in
>    case we have an extended flag active for the filesystem
>    (XFS_SB_VERSION2_LAZYSBCOUNTBIT); is this true? without this, I'm not
>    sure how to calculate this number of blocks nicely

Yes, that is true. There's a pre-req for shrinking for the moment :/

>  - or can I assume that an empty AG will *always* have agf_levels = 1
>    for both Btrees, so there are no extra blocks actually used for the
>    btrees (except for the two reserved ones at the beggining of the AG

Yes, that is a valid assumption.

>  - can I assume that an AG with agi->icount == agi->ifree == 0 will have
>    no blocks used for the inode btrees (logically yes, but I'm not sure)

yes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
