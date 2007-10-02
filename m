Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 05:59:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l92Cxess004963
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 05:59:45 -0700
Date: Tue, 2 Oct 2007 22:59:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
Message-ID: <20071002125923.GH995458@sgi.com>
References: <200710021010.58284.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710021010.58284.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <ak@suse.de>
Cc: xfs@oss.sgi.com, cattelan@thebarn.com

On Tue, Oct 02, 2007 at 10:10:58AM +0200, Andi Kleen wrote:
> XFS had some own functions to find high and low bits.
> 
> This patch replaces them with a call to the respective Linux functions.
> The semantics of the Linux functions differ a little, but i checked
> all call sites that they can deal with that. I think all callers 
> are ok; but i added a few more asserts for the 0 case (where Linux
> and old XFS differ) just to make it easy to detect mistakes.
>  
> Index: linux-2.6.23-rc8-misc/fs/xfs/xfs_iget.c
> ===================================================================
> --- linux-2.6.23-rc8-misc.orig/fs/xfs/xfs_iget.c
> +++ linux-2.6.23-rc8-misc/fs/xfs/xfs_iget.c
> @@ -55,8 +55,7 @@ xfs_ihash_init(xfs_mount_t *mp)
>  	if (!mp->m_ihsize) {
>  		icount = mp->m_maxicount ? mp->m_maxicount :
>  			 (mp->m_sb.sb_dblocks << mp->m_sb.sb_inopblog);
> -		mp->m_ihsize = 1 << max_t(uint, 8,
> -					(xfs_highbit64(icount) + 1) / 2);
> +		mp->m_ihsize = 1 << max_t(uint, 8, fls64(icount) / 2);
>  		mp->m_ihsize = min_t(uint, mp->m_ihsize,
>  					(64 * NBPP) / sizeof(xfs_ihash_t));
>  	}

This is well out of date with where the XFS tree is now.
You might want to rebase this on the XFS CVS code or the master
branch of the XFS git tree...

So the conversion is:

	xfs_highbit64 -> fls64() - 1
	xfs_lowbit64(v) -> find_first_bit(&v, 64)
	xfs_highbit32 -> fls - 1
	xfs_lowbit32(v) -> find_first_bit(&v, 32)

and touching lots of places where the xfs functions are used.

One thing that is notable here is that the XFS code returns
-1 if no bits are set. fls/fls64 return 0 in the same case, so
the magic "- 1" will make them behave the same. however, it
appears that find_first_bit() will return the number of bits
searched. That might leave us with som nasty, non-obvious error
cases....

Also, I don't really like the fact it requires sprinkling magic "-
1" adjustments to the return value of the replacement functions.  If
that is the way the functions work and relate to the XFS bitmaps,
then that *should* be hidden away in a macro/static inline so it
doesn't get screwed up in future.

Hence I'd prefer to keep the xfs wrappers whilst replacing the guts of
them with the more efficient generic code. I'm not too concerned,
though, but Russell might want to comment here...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
