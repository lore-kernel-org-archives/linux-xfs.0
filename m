Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96MsxIK206111 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 17:54:59 -0500
Subject: Re: [PATCH 2/2] repair: fix some valgrind reported errors on i686
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006221542.GU3159@dastard>
References: <1317862891-3033-1-git-send-email-david@fromorbit.com>
	<1317862891-3033-3-git-send-email-david@fromorbit.com>
	<1317903472.3139.30.camel@doink>  <20111006221542.GU3159@dastard>
Date: Thu, 6 Oct 2011 17:54:18 -0500
Message-ID: <1317941658.2870.50.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, 2011-10-07 at 09:15 +1100, Dave Chinner wrote:
> On Thu, Oct 06, 2011 at 07:17:52AM -0500, Alex Elder wrote:
> > On Thu, 2011-10-06 at 12:01 +1100, Dave Chinner wrote:
. . .

> > > @@ -47,6 +47,17 @@ blkmap_alloc(
> > >  	if (nex < 1)
> > >  		nex = 1;
> > >  
> > > +#if (BITS_PER_LONG != 64)
> > 
> > This should be == 32, not != 64.
> 
> OK.
> 
> >  (And if it
> > were possible, sizeof (int) == 32.)
> 
> The BITS_PER_LONG are derived from the output of the configure
> process, and that's what the other code uses as well. So I'm just
> being consistent ;).

Well, it isn't possible anyway because sizeof is a compile-time
operator, so it can't be used during preprocessing.  You did
the right thing.

> 
> > > +	if (nex > (INT_MAX / sizeof(bmap_ext_t) - 1)) {
> > 
> > See the comment below about this calculation.
> > 
> > > +		do_warn(
> > > +	_("Number of extents requested in blkmap_alloc (%u) overflows 32 bits.\n"
> > > +	  "If this is not a corruption, then will need a 64 bit system\n"
> > 		...then you will need...
> > 
> > > +	  "to repair this filesystem.\n"),
> > > +			nex);
> > > +		return NULL;
> > > +	}
> > > +#endif
> > > +
> > >  	key = whichfork ? ablkmap_key : dblkmap_key;
> > >  	blkmap = pthread_getspecific(key);
> > >  	if (!blkmap || blkmap->naexts < nex) {
> > 
> > . . .
> > 
> > > @@ -218,6 +244,15 @@ blkmap_grow(
> > >  	}
> > >  
> > >  	blkmap->naexts += 4;
> > 
> > The check needs to go *before* you update naexts.
> 
> It's in the right place - adding 4 to the unchecked extent count can
> push it over the limit, so we have to check it after adding 4 to it.

My point was that I'd rather see the check be whether it *will*
overflow, rather than allowing it to overflow.

The other reason though, even if you do the calculation
at that spot, is that you shouldn't update what blkmap
records as the number of allocated extents unless you
have actually updated it the amount of allocated memory.
As it stands, you will have updated blkmap->naexts, then
if it overflows you return before actually attempting
to reallocate.

In other words, blkmap->naexts should reflect the actual
amount of memory allotted in the blkmap->exts array, which
is not going to be the case if it returns early (and this
can be avoided).


> > > +#if (BITS_PER_LONG != 64)
> > > +	if (blkmap->naexts > (INT_MAX / sizeof(bmap_ext_t) - 1)) {
> > 
> > I don't really follow this calculation. I would expect
> > it to be based more closely on how BLKMAP_SIZE() is
> > defined.
> 
> > 
> > If you move it before the increment I think it would
> > be better to use:
> > 	if (BLKMAP_SIZE(nex) >= INT_MAX - sizeof (blkent_t *))
> 
> We can't use BLKMAP_SIZE(), because it will overflow 32 bits.

Which is also a reason I was suggesting to check whether we'd
be exceeding the max *before* calling the macro.

> Indeed, use of BLKMAP_SIZE() on unchecked extent counts is
> *precisely* the cause of the memory corruption this fix addresses.
> In more detail:
> 
> typedef struct blkmap {
>         int             naexts;
>         int             nexts;
>         bmap_ext_t      exts[1];
> } blkmap_t;
> 
> #define BLKMAP_SIZE(n)  \
>         (offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
> 
> sizeof()/offsetof() on 32 bit platforms return a 32 bit number,
> naexts is a 32 bit number, so BLKMAP_SIZE() will overflow if
> blkmap->naexts >= INT_MAX / sizeof(bmap_ext_t).
> 
> IOWs, we can't use BLKMAP_SIZE to detect an overflow, because it
> is the code that overflows...

I understand that argument.  I'm in a hurry at the moment so
I haven't thought through this very well right now.

But if you do have BLKMAP_NENTS_MAX, you could check nex
against that before attempting to use BLKMAP_SIZE to
compute how many bytes need to be allocated.


> > And since this would expose the internals of what
> > BLKMAP_SIZE() does, it might be nicer if some sort of
> > BLKMAP_NENTS_MAX constant were defined next to the
> > definition of BLKMAP_SIZE().
> 
> I can add a BLKMAP_NENTS_MAX constant to repair/bmap.h.
> 

OK.  I'll check for an update later.  Thanks for the
explanation.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
