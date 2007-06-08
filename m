Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 03:15:45 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58AFdWt005106
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 03:15:41 -0700
Date: Fri, 8 Jun 2007 12:15:32 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: Re: XFS shrink functionality
Message-ID: <20070608101532.GA18788@teal.hq.k1024.org>
References: <1180715974.10796.46.camel@localhost> <20070604001632.GA86004887@sgi.com> <20070604084154.GA8273@teal.hq.k1024.org> <1181291033.7510.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181291033.7510.40.camel@localhost>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ruben Porras <nahoo82@gmail.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, cw@f00f.org

On Fri, Jun 08, 2007 at 10:23:53AM +0200, Ruben Porras wrote:
> Am Montag, den 04.06.2007, 10:41 +0200 schrieb Iustin Pop:
> > Good to know. If there is at least more documentation about the
> > internals, I could try to find some time to work on this again.
> 
> there is now a document explaining the XFS on disk format [0] and some
> presentations for training courses, I think none of this were available
> at the time you made the first try. Although they are not enough for our
> purpose. 
> 

Yes, just yesterday I found the document and it helps.

> > My suggestion would be to start implementing these steps in reverse. 4)
> > is the most important as it touches the entire FS. If 4) is working
> > correctly, then 1) would be simpler (I think)
> 
> Why do you think that 1) would be simpler after 4)? For what I
> understand, they are independent.
Not after that in the cronological sense, but in the importance part.
Yes, it was a bad choice of words.

> 3) worries me, if walking the entire filesystem is needed, it want
> scale...
>   
> Since I don't know yet the xfs code I would like to begin with 1), I see
> it independent from the other parts, and I can then learn more about the
> transactions, allocators, and walking through the xfs structures. As you
> did 4) one time, maybe you could try with this part of the problem if
> you find the needed time, taking David's suggestions into account.

I took a look at both items since this discussion started. And honestly,
I think 1) is harder that 4), so you're welcome to work on it :) The
points that make it harder is that, per David's suggestion, there needs
to be:
 - define two new transaction types
 - define two new ioctls
 - update the ondisk-format (!), if we want persistence of these flags;
   luckily, there are two spare fields in the AGF structure.
 - check the list of allocation functions that allocate space from the
   AG

I did some preliminary work on this but just a little.

I think that after the weekend I'll send an updated patch of 4). I have
one working now with the current CVS tree, just that it's still ugly and
needs polishing.

Open questions (re. point 4):
 - the filesystem document says the agf->agf_btreeblks is held only in
   case we have an extended flag active for the filesystem
   (XFS_SB_VERSION2_LAZYSBCOUNTBIT); is this true? without this, I'm not
   sure how to calculate this number of blocks nicely
 - or can I assume that an empty AG will *always* have agf_levels = 1
   for both Btrees, so there are no extra blocks actually used for the
   btrees (except for the two reserved ones at the beggining of the AG
 - can I assume that an AG with agi->icount == agi->ifree == 0 will have
   no blocks used for the inode btrees (logically yes, but I'm not sure)


thanks,
iustin
