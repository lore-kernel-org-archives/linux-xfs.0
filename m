Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A57F17CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 16:27:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5A43B8F8049
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 14:27:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dRWJwdwsuHK9g6f0 for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 14:26:54 -0700 (PDT)
Date: Thu, 15 Sep 2016 07:26:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: detect AGFL size mismatches
Message-ID: <20160914212651.GN30497@dastard>
References: <1472783257-15941-1-git-send-email-david@fromorbit.com>
	<1472783257-15941-4-git-send-email-david@fromorbit.com>
	<28b962d6-aa0c-076d-be74-99006252eab4@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <28b962d6-aa0c-076d-be74-99006252eab4@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Sep 13, 2016 at 06:39:23PM -0500, Eric Sandeen wrote:
> On 9/1/16 9:27 PM, Dave Chinner wrote:
> > +	 * still considered a corruption.
> > +	 */
> > +	if (flfirst > agfl_size)
> > +		return false;
> > +	if (flfirst == agfl_size)
> > +		xfs_warn(mp, "AGF %u: first freelist index needs correction",
> > +			be32_to_cpu(agf->agf_seqno));
> > +
> > +	if (fllast > agfl_size)
> > +		return false;
> > +	if (fllast == agfl_size)
> > +		xfs_warn(mp, "AGF %u: last freelist index needs correction",
> > +			be32_to_cpu(agf->agf_seqno));
> > +
> > +	if (flcount > agfl_size + 1)
> > +		return false;
> > +	if (flcount == agfl_size)
> > +		xfs_warn(mp, "AGF %u: freelist count needs correction(1)",
> > +			be32_to_cpu(agf->agf_seqno));
> 
> <thinking cap>
> 
> Hang on, doesn't this miss the flcount == agfl_size + 1 case in between?
> 
> agfl size is now one shorter than expected, but it's still our working
> maximum size for validity.  So flcount == agfl_size should be *ok* right?
> flcount == agfl_size + 1 needs fixing.  flcount > agfl_size is baroque.
> 
> So I'd have expected:
> 
> +	if (flcount > agfl_size + 1)
> +		return false;
> +	if (flcount == agfl_size + 1)
> +		xfs_warn(mp, "AGF %u: freelist count needs correction(1)",
> +			be32_to_cpu(agf->agf_seqno));
> 
> > +
> > +	/*
> > +	 * range check flcount - if it's out by more than 1 count or is too
> 
> ok maybe "out by" is just what you say down there.  ;)
> 
> > +	 * small, we've got a corruption that isn't a result of the structure
> > +	 * size screwup so that throws a real corruption error.
> > +	 */
> > +	active = fllast - flfirst + 1;
> 
> <thinking cap>
> Ok, flfirst or fllast *could* be occupying the "extra" slot, as warned
> above.  So active could be "1 bigger" than agfl_size
> 
> > +	if (active <= 0)
> > +		active += agfl_size;
> 
> and here we handle the wrap w/ that smaller agfl_size.  Hm...
> 
> Pretend agfl_size is 10 (slots 0->9).  Actual size is possibly 11 (0->10).
> We could have flfirst at 10, fllast at 0.
> fllast - flfirst + 1 then
> is -9.  We add back in agfl_size of 10, and get active == 1.

The free list indexes, as I've said before, are /very badly named/.
The actual situation when flfirst > fllast is this (taken from the
next patch):

        /*
         * Pure wrap, first and last are valid.
         *                        flfirst
         *                           |
         *      +oo------------------oo+
         *        |
         *      fllast
         *
         * We need to determine if the count includes the last slot in the AGFL
         * which we no longer use. If the flcount does not match the expected
         * size based on the first/last indexes, we need to fix it up.
         */

i.e. flfirst is the /tail/ of the list where we allocate blocks from,
fllast is the /head/ of the list where we put newly freed blocks.

hence if we have agfl_size = 10, flfirst = 9, flast = 0, we have 2
blocks on the freelist. i.e. flcount = 2.

good wrap case w/ corrected agfl_size:

	flfirst = 9
	fllast = 0
	flcount = 10
	agfl_size = 10
	active = fllast - flfirst + 1
	       = 0 - 9 + 1
	       = -8 + agflsize
	       = 2 (correct!)

	if (flfirst > agfl_size)		not true
	if (flfirst == agfl_size)		not true

	if (fllast > agfl_size)			not true
	if (fllast == agfl_size)		not true

	if (flcount > agfl_size + 1)		not true
	if (flcount == agfl_size)		not true

	if (active <= 0)			not true
	if (flcount > active + 1)		not true
	if (flcount < active)			not true
	if (flcount != active)			not true

No errors, no warnings, all good!

Bad wrap case:

	flfirst = 10	(invalid!)
	fllast = 0
	flcount = 2
	agfl_size = 10
	active = 0 - 10 + 1
	       = -9 + agfl_size
	       = 1 (correct as flfirst is invalid!)

	if (flfirst > agfl_size)		not true
	if (flfirst == agfl_size)		true, warn

	if (fllast > agfl_size)			not true
	if (fllast == agfl_size)		not true

	if (flcount > agfl_size + 1)		not true
	if (flcount == agfl_size)		not true

	if (active <= 0)			not true
	if (flcount > active + 1)		not true
	if (flcount < active)			not true
	if (flcount != active)			true, warn

So, two correction needed warnings, which is correct because both
flfirst and flcount need fixing due to being off by one.

The bad fllast case:

	flfirst = 5
	fllast = 10	(invalid!)
	flcount = 6	
	agfl_size = 10
	active = fllast - flfirst + 1
	       = 10 - 5 + 1
	       = 6 (invalid as fllast is out of range)

	if (flfirst > agfl_size)		not true
	if (flfirst == agfl_size)		not true

	if (fllast > agfl_size)			not true
	if (fllast == agfl_size)		true, warn

	if (flcount > agfl_size + 1)		not true
	if (flcount == agfl_size)		not true

	if (active <= 0)			not true
	if (flcount > active + 1)		not true
	if (flcount < active)			not true
	if (flcount != active)			not true

So we've got a warning that a fllast correction will take place,
which will also correct the flcount once the fllast index is
updated.

But I think the case you are concerned about is a corner case of
this one - a full AGFL, right?  Something that, in practice, will
never happen as no single transaction will free or require a full
AGFL worth of blocks in a single allocation/free operation.

As such, I didn't actually consider it or test that case, so, it may
be wrong.  Let's run the numbers:

	flfirst = 0
	fllast = 10	(invalid!)
	flcount = 11	(invalid!)
	agfl_size = 10
	active = fllast - flfirst + 1
	       = 10 - 0 + 1
	       = 11 (invalid as fllast is out of range)

	if (flfirst > agfl_size)		not true
	if (flfirst == agfl_size)		not true

	if (fllast > agfl_size)			not true
	if (fllast == agfl_size)		true, warn

	if (flcount > agfl_size + 1)		not true
	if (flcount == agfl_size)		not true

	if (active <= 0)			not true
	if (flcount > active + 1)		not true
	if (flcount < active)			not true
	if (flcount != active)			not true

So it issues the same fllast warning as the not full, not wrapped
case, and that correction also fixes up the flcount. Maybe it's the
full wrapped case, which may be a pure flcount error?

	flfirst = 5
	fllast = 4
	flcount = 11	(invalid!)
	agfl_size = 10
	active = fllast - flfirst + 1
	       = 4 - 5 + 1
	       = 10 (different to flcount!)

	if (flfirst > agfl_size)		not true
	if (flfirst == agfl_size)		not true

	if (fllast > agfl_size)			not true
	if (fllast == agfl_size)		not true

	if (flcount > agfl_size + 1)		not true
	if (flcount == agfl_size)		not true
					(yes, that should warn)

	if (active <= 0)			not true
	if (flcount > active + 1)		not true
	if (flcount < active)			not true
	if (flcount != active)			true, warn

So we do get a warning about the flcount being wrong because it's
only one block different to the calculated active size (and hence it
will be corrected), but no warning from the flcount being out of
range by one block. So, yes, I think you are right, Eric, that the
check should be against agfl_size + 1, even it it means we get
multiple warnings...

Thanks for thinking about this case!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
