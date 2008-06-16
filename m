Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 22:00:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5G50uhW010362
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 22:00:57 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60820234D2A
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 22:01:53 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id n3AEG1ixUiPVIvo8 for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 22:01:53 -0700 (PDT)
Date: Mon, 16 Jun 2008 15:01:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Always reset btree cursor after an insert
Message-ID: <20080616050150.GK3700@disturbed>
References: <4855CE2D.70505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4855CE2D.70505@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jun 16, 2008 at 12:21:33PM +1000, Lachlan McIlroy wrote:
> After a btree insert operation a cursor can be invalid due to block
> splits and a maybe a new root block.  We reset the cursor in
> xfs_bmbt_insert() in the cases where we think we need to but it
> isn't enough as we still see assertions.  Just do what we do elsewhere
> and reset the cursor unconditionally.

Ok, so you should also kill the new code in the btree insert that
revalidates the btree cursor. IIRC, this was the only place it was
needed for....

> --- fs/xfs/xfs_bmap.c_1.392	2008-06-03 12:20:14.000000000 +1000
> +++ fs/xfs/xfs_bmap.c	2008-06-16 12:11:47.000000000 +1000
> @@ -1745,11 +1745,17 @@ xfs_bmap_add_extent_unwritten_real(
> 			if ((error = xfs_bmbt_insert(cur, &i)))
> 				goto done;
> 			ASSERT(i == 1);
> -			if ((error = xfs_bmbt_increment(cur, 0, &i)))
> +			/*
> +			 * Reset the cursor, don't trust it after any insert
> +			 * operation.
> +			 */

/*
 * reset the cursor to the position of the new extent we are about
 * to insert as we can't trust it after the previous insert
 */

> +			if ((error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
> +					new->br_startblock, new->br_blockcount,
> +					&i)))
> 				goto done;


			error = xfs_bmbt_lookup_eq(cur, new->br_startoff,
					br_startblock, new->br_blockcount, &i);
			if (error)
				goto done;

> -			ASSERT(i == 1);
> +			ASSERT(i == 0);

ASSERT? How about a WANT_CORRUPTED_GOTO()?

> 			/* new middle extent - newext */
> -			cur->bc_rec.b = *new;
> +			cur->bc_rec.b.br_state = new->br_state;
> 			if ((error = xfs_bmbt_insert(cur, &i)))
> 				goto done;
> 			ASSERT(i == 1);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
