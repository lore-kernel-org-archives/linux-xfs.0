Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TIQMVs127759 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 13:26:22 -0500
Subject: Re: [Fwd: PATCH: remove varibale that serve no purpose in
	xfs_alloc_ag_vextent_exact()]
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309308374.5505.6212.camel@chandra-lucid.beaverton.ibm.com>
References: <1309308374.5505.6212.camel@chandra-lucid.beaverton.ibm.com>
Date: Wed, 29 Jun 2011 13:26:17 -0500
Message-ID: <1309371977.4646.44.camel@doink>
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
To: sekharan@us.ibm.com
Cc: xfs@oss.sgi.com

On Tue, 2011-06-28 at 17:46 -0700, Chandra Seetharaman wrote:
> Hi Alex,
> 
> Looks like this patch fell into the cracks.
> 
> Just wanted to bring it to your attention.

It did make it to the mailing list but I can't
find it in my mailbox for some reason.

> regards,
> 
> chandra
> -------- Forwarded Message --------
> From: Chandra Seetharaman <sekharan@us.ibm.com>
> Reply-to: sekharan@us.ibm.com
> To: xfs@oss.sgi.com
> Cc: Alex Elder <aelder@sgi.com>
> Subject: PATCH: remove varibale that serve no purpose in
> xfs_alloc_ag_vextent_exact()
> Date: Thu, 09 Jun 2011 09:48:01 -0700
> 
> Hi,
> 
> As per Alex Elder suggestion, here is a patch to remove non-purpose
> variables in xfs_alloc_ag_vextent_exact()
> 
> chandra
> 
> --------------------

This looks good.

I expect to get this in this week.  I plan to
tweak the description slightly--hope that's OK.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Remove the variables that serves no purpose.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 95862bb..7a53c8f 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -570,9 +570,7 @@ xfs_alloc_ag_vextent_exact(
>  	xfs_agblock_t	tbno;	/* start block of trimmed extent */
>  	xfs_extlen_t	tlen;	/* length of trimmed extent */
>  	xfs_agblock_t	tend;	/* end block of trimmed extent */
> -	xfs_agblock_t	end;	/* end of allocated extent */
>  	int		i;	/* success/failure of operation */
> -	xfs_extlen_t	rlen;	/* length of returned extent */
>  
>  	ASSERT(args->alignment == 1);
>  
> @@ -625,18 +623,16 @@ xfs_alloc_ag_vextent_exact(
>  	 *
>  	 * Fix the length according to mod and prod if given.
>  	 */
> -	end = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen);
> -	args->len = end - args->agbno;
> +	args->len = XFS_AGBLOCK_MIN(tend, args->agbno + args->maxlen)
> +						- args->agbno;
>  	xfs_alloc_fix_len(args);
>  	if (!xfs_alloc_fix_minleft(args))
>  		goto not_found;
>  
> -	rlen = args->len;
> -	ASSERT(args->agbno + rlen <= tend);
> -	end = args->agbno + rlen;
> +	ASSERT(args->agbno + args->len <= tend);
>  
>  	/*
> -	 * We are allocating agbno for rlen [agbno .. end]
> +	 * We are allocating agbno for args->len
>  	 * Allocate/initialize a cursor for the by-size btree.
>  	 */
>  	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> ---
> 
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
