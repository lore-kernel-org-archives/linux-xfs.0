Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 15:44:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OMicap008802
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:44:39 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E115227547C
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:45:38 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id lEecNMB425yDIw5p for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 15:45:38 -0700 (PDT)
Date: Wed, 25 Jun 2008 08:45:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] set minleft in xfs_bmbt_split()
Message-ID: <20080624224533.GM29319@disturbed>
References: <48605744.8070400@sgi.com> <20080624045841.GN16257@build-svl-1.agami.com> <4860847B.7070703@sgi.com> <20080624052556.GR16257@build-svl-1.agami.com> <48609152.7050208@sgi.com> <20080624062551.GU16257@build-svl-1.agami.com> <48609DD0.80604@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48609DD0.80604@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jun 24, 2008 at 05:10:08PM +1000, Lachlan McIlroy wrote:

[....]

> This is the fallback code.  Do you think I also need to make the same
> minleft change above and this change below to xfs_bmbt_newroot()?
>
> I'm inclined to change both xfs_bmbt_split() and xfs_bmbt_newroot()
> and keep them as similar as possible.  For the newroot case we know we
> only need one block and we know there will be no more allocations for
> this insert so using 'minleft = xfs_trans_get_block_res()' is silly but
> on the other hand we don't have any other way to detect the double
> insert case.

OTOH, if we do a double insert, is it even possible for that to
trigger a full tree double split? i.e. after the first split that
allocates a new root, the new root will only be partially full, so
we should be able to insert there in all cases without a split on
the second insert. The case of a second split occurring is when the
second insert goes into a different leaf block to the first insert
and that needs splitting as well. If it's a completely different
path up to the root of the tree, then the place where they will join
is the old root block (remember that the new root block contains the
old contents of the inode fork - it's not really a split but a move
operation) and so a second newroot allocation will not be necessary.
Hence I think that the newroot allocation will never be triggered
twice in the unwritten extent double insert case.

*However*, if the newroot function is first allocation, it still may
need to take into account the second insert which may split a leaf
as well. I don't think this can happen - the only time we'll do a
newroot allocation without having first done an allocation in
xfs_bmbt_split() is when adding an attribute fork and we need to
push the data fork root out to make room for the attr fork.  In this
case, we don't have a split occurring at all and so we only need one
block for the new root.

Hence I don't think the newroot case needs to reserve space for
entire splits or multiple splits at all - if that is going to happen
it should already have been taken into account by earlier allocations...

> --- 2.6.x-agno2.orig/fs/xfs/xfs_bmap_btree.c
> +++ 2.6.x-agno2/fs/xfs/xfs_bmap_btree.c
> @@ -1525,6 +1525,21 @@ xfs_bmbt_split(
> 		XFS_BMBT_TRACE_CURSOR(cur, ERROR);
> 		return error;
> 	}
> +	if (args.fsbno == NULLFSBLOCK && args.minleft) {
> +		/*
> +		 * Could not find an AG will enough free space to satisfy
> +		 * a full btree split.  Try again without minleft and if
> +		 * successful activate the lowspace algorithm.
> +		 */
> +		args.fsbno = 0;
> +		args.type = XFS_ALLOCTYPE_FIRST_AG;
> +		args.minleft = 0;
> +		if ((error = xfs_alloc_vextent(&args))) {
> +			XFS_BMBT_TRACE_CURSOR(cur, ERROR);
> +			return error;
> +		}
> +		cur->bc_private.b.flist->xbf_low = 1;
> +	}

Yes, that change makes sense for the split case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
