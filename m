Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:45:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5P5jZdo017242
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:45:38 -0700
Date: Mon, 25 Jun 2007 13:53:15 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Multi-File Data Streams V2
Message-ID: <20070625035315.GL86004887@sgi.com>
References: <20070613041629.GI86004887@sgi.com> <467B8BFA.2050107@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467B8BFA.2050107@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 22, 2007 at 06:44:42PM +1000, Timothy Shimmin wrote:
> Hi Dave,
> 
> For the xfs_bmap.c/xfs_bmap_btalloc()
> 
> *
> Might be clearer something like this:
> ------------------
> if (nullfb) {
> 	if (ap->userdata && xfs_inode_is_filestream(ap->ip)) {
> 		ag = xfs_filestream_lookup_ag(ap->ip);
> 		ag = (ag != NULLAGNUMBER) ? ag : 0;
> 		ap->rval = XFS_AGB_TO_FSB(mp, ag, 0);		
> 	} else {
> 		ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
>         }
> } else
> 	ap->rval = ap->firstblock;
> -------------------
> Unless we need "ag" set for the non-userdata && filestream case.
> I think Barry was questioning this today.

ag gets overwritten from args.fsbno, which is set up from
ap->rval, which comes from XFS_AGB_TO_FSB(mp, ag, 0) which means
that ag is not needed outside this check. So yes, it would
probably be cleaner.

> *
> It is interesting that at the start we set up the fsb
> for (userdata & filestreams) and then in a bunch of other places
> it tests just for filestreams - although, there is one spot further
> down which also tests for userdata.

Yes, because the userdata case you refer to is the need to select
a new stream ag - failing to allocate metadata, which may be in a
different AG, shouldn't cause the data stream to move.

In other cases, we check for filestreams to set up the fallbacks
on failure correctly. Those are the same for data and metadata
for filestreams.

> I find this a bit confusing (as usual:) - I thought we were only interested
> in changing the allocation of userdata for the filestream.

Mostly, yes, but metadata and data tend to be allocated with the
same locality principles which filestreams does not follow.
Hence there are small differences in the way we treat them.

> *
> As we talked about before, this code seems to come up in a few places:
> 
> 	need = XFS_MIN_FREELIST_PAG(pag, mp);
> 	delta = need > pag->pagf_flcount ?
> 		need - pag->pagf_flcount : 0;
> 	longest = (pag->pagf_longest > delta) ?
> 		(pag->pagf_longest - delta) :
> 		(pag->pagf_flcount > 0 ||
> 		pag->pagf_longest > 0);
> 
> Perhaps we could macroize/inline-function it?

Sure. I'll do that as a separate patch, though.

> It confused me in _xfs_filestream_pick_ag() when I was trying
> to understand it and so could do with a comment for it too.
> As I said then, I don't like the way it uses a boolean as
> the number of blocks, in the case when the longest extent is
> is smaller than the excess over the freelist which
> the fresspace-btree-splits-overhead needs.

Actually, the logic statement is correct. If we have a delta greater
than the longest extent, we cannot find out what the next longest
extent is without searching the btree.  Hence we assume that the
longest extent is a single block, which means if the have free
extents in the tree (pag->pagf_longest > 0) or we have blocks in the
freelist (pag->pagf_flcount > 0) we are guaranteed to be able to
alocate a single block if there is space available. So the logic is:

	longest = 0;
	if pag->pagf_longest > delta
		longest = pag->pagf_longest - delta;
	else if pag->pagf_flcount > 0
		longest = 1;
	else if pag->pagf_longest > 0
		longest = 1;

And the above is simply more compact.

> Also, the variables "need" and "delta" look pretty local to it.

*nod*

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
