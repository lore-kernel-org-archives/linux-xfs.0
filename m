Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 02:55:31 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l929tPCS031536
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 02:55:26 -0700
Date: Tue, 2 Oct 2007 10:55:25 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
Message-ID: <20071002095525.GA25405@infradead.org>
References: <200710021010.58284.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710021010.58284.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com

On Tue, Oct 02, 2007 at 10:10:58AM +0200, Andi Kleen wrote:
> 
> XFS had some own functions to find high and low bits.
> 
> This patch replaces them with a call to the respective Linux functions.
> The semantics of the Linux functions differ a little, but i checked
> all call sites that they can deal with that. I think all callers 
> are ok; but i added a few more asserts for the 0 case (where Linux
> and old XFS differ) just to make it easy to detect mistakes.
> 
> The resulting xfs.ko is about 500 bytes smaller on x86-64
> 
> This is similar to the patch Eric sent some days ago, but does
> it more efficiently imho. It replaces his patch.
> 
> I wasn't able to do a full XFS QA run over this unfortunately; but did careful
> review.

The patch looks like it's against mainline, so there might be some
problems applying it to the xfs tree.  At least some of the touched
functions have changed names and maybe content aswell.

>  	while (fields) {
> -		f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> +		f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields,64);

I don't think we should add the case here but rather pass the fields
varialble as an unsigned long to start with.

> @@ -1428,11 +1428,11 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fi
>  
>  	/* find modified range */
>  
> -	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
> +	f = (xfs_sb_field_t)find_first_bit((unsigned long *)&fields, 64);
>  	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
>  	first = xfs_sb_info[f].offset;
>  
> -	f = (xfs_sb_field_t)xfs_highbit64((__uint64_t)fields);
> +	f = (xfs_sb_field_t)fls64((__uint64_t)fields) - 1;

Same here.

> +/* All callers check for 0 arguments already; so no -1 handling */
> +static inline int xfs_rtlobit(unsigned long v)
> +{
> +	return find_first_bit(&v, 32);
> +}
> +
> +#define	XFS_RTLOBIT(w)  xfs_rtlobit(w)

I think just a

#define	XFS_RTLOBIT(w)	find_first_bit(&(w), 32)

should be fine.  Or make it just an inline, but not both a macro an
an inline.
