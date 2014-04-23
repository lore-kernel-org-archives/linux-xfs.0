Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DECF7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 19:30:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82306304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 17:30:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	n7aT9Ma1QP6FCXtS for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 17:29:57 -0700 (PDT)
Date: Wed, 23 Apr 2014 10:29:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
Message-ID: <20140423002953.GP18672@dastard>
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>
	<20140422141743.GA55823@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140422141743.GA55823@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 10:17:44AM -0400, Brian Foster wrote:
> On Tue, Apr 22, 2014 at 04:59:09PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit e461fcb ("xfs: remote attribute lookups require the value
> > length") passes the remote attribute length in the xfs_da_args
> > structure on lookup so that CRC calculations and validity checking
> > can be performed correctly by related code. This, unfortunately has
> > the side effect of changing the args->valuelen parameter in cases
> > where it shouldn't.
> > 
> > That is, when we replace a remote attribute, the incoming
> > replacement stores the value and length in args->value and
> > args->valuelen, but then the lookup which finds the existing remote
> > attribute overwrites args->valuelen with the length of the remote
> > attribute being replaced. Hence when we go to create the new
> > attribute, we create it of the size of the existing remote
> > attribute, not the size it is supposed to be. When the new attribute
> > is much smaller than the old attribute, this results in a
> > transaction overrun and an ASSERT() failure on a debug kernel:
> > 
> > XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
> > 
> > Fix this by keeping the remote attribute value length separate to
> > the attribute value length in the xfs_da_args structure. The enables
> > us to pass the length of the remote attribute to be removed without
> > overwriting the new attribute's length.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_attr.c        |  7 ++++++-
> >  fs/xfs/xfs_attr_leaf.c   | 21 +++++++++++----------
> >  fs/xfs/xfs_attr_remote.c | 11 ++++++++---
> >  fs/xfs/xfs_da_btree.h    |  2 ++
> >  4 files changed, 27 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
> > index 01b6a01..dbaa674 100644
> > --- a/fs/xfs/xfs_attr.c
> > +++ b/fs/xfs/xfs_attr.c
> > @@ -213,7 +213,7 @@ xfs_attr_calc_size(
> >  		 * Out of line attribute, cannot double split, but
> >  		 * make room for the attribute value itself.
> >  		 */
> > -		uint	dblocks = XFS_B_TO_FSB(mp, valuelen);
> > +		uint	dblocks = xfs_attr3_rmt_blocks(mp, valuelen);
> >  		nblks += dblocks;
> >  		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> >  	}
> > @@ -703,6 +703,7 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
> >  		args->index2 = args->index;
> >  		args->rmtblkno2 = args->rmtblkno;
> >  		args->rmtblkcnt2 = args->rmtblkcnt;
> > +		args->rmtvaluelen2 = args->rmtvaluelen;
> >  	}
> 
> Why don't we zero out the first set of values here similar to the node
> case?

I hadn't looked. I was just doing what was consistent with the
current code.

/me looks.

xfs_attr3_leaf_add -> xfs_attr3_leaf_add_work overwrites the rmt*
variables with new values if the newly added attribute needs to be
made remote. But, if it is local, it doesn't zero them.

So, yes, there is potential for the wrong thing to be done later
in this same function as it checks args->rmtblkno assuming that it
is only set when the new attribute is remote.

Different bug, well spotted. :/

I'll add zeroing here.

[FWIW, I've always disliked and been confused by the set of
rmtblkno/rmtblkno2 variables in the xfs_da_args. Mainly their naming
is horrible. Some day I'll write a patch to make it clear what the
two sets of variables are actually for, and maybe write helper
functions for switching between the two sets... ]

> > diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> > index 6e37823..2324c66 100644
> > --- a/fs/xfs/xfs_attr_remote.c
> > +++ b/fs/xfs/xfs_attr_remote.c
> > @@ -337,7 +337,7 @@ xfs_attr_rmtval_get(
> >  	struct xfs_buf		*bp;
> >  	xfs_dablk_t		lblkno = args->rmtblkno;
> >  	__uint8_t		*dst = args->value;
> > -	int			valuelen = args->valuelen;
> > +	int			valuelen;
> >  	int			nmap;
> >  	int			error;
> >  	int			blkcnt = args->rmtblkcnt;
> > @@ -348,6 +348,11 @@ xfs_attr_rmtval_get(
> >  
> >  	ASSERT(!(args->flags & ATTR_KERNOVAL));
> >  
> > +	/* remote value might be different size to the buffer supplied. */
> > +	if (args->rmtvaluelen = args->valuelen)
> > +		args->valuelen = args->rmtvaluelen;
> > +	valuelen = args->valuelen;
> > +
> 
> Jeff already called this out as a potential typo...
> 
> I'm guessing the intent is to handle the case where we call from
> xfs_attr3_leaf_list_int().

Not really, it was just defensive to ensure that if args->valuelen
and args->rmtvaluelen are different we don't overrun the buffer
supplied by the caller, which is only args->valuelen in size...

> The other callers call
> xfs_attr3_leaf_getvalue() first, which sets rmtvaluelen and fixes up
> valuelen or returns an error (if short). The list_int() case looks like
> it queries the remote length just the same, but only sets valuelen...
> Why not just set both valuelen and rmtvaluelen there?

Seems reasonable. I'll replace the above check with an ASSERT so
that we catch any future mismatches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
