Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 23:49:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G6mjDW002274
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 23:48:57 -0700
Date: Wed, 16 Aug 2006 16:47:25 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: fsblock zero - don't panic
Message-ID: <20060816064725.GK51703024@melbourne.sgi.com>
References: <20060810155851.C2591606@wobbly.melbourne.sgi.com> <20060811032626.GF50254148@melbourne.sgi.com> <20060816142800.D2762042@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060816142800.D2762042@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 16, 2006 at 02:28:01PM +1000, Nathan Scott wrote:
> On Fri, Aug 11, 2006 at 01:26:26PM +1000, David Chinner wrote:
> > ...
> > Looks OK.
> 
> Thanks mate.
> 
> > ...
> > If you are hinting this branch to be unlikely, then we should also
> > check the start block first before checking the io_flags.  We only
> > need to check the io_flags if we are actually accessing block zero.
> 
> I've rolled this into a new version.  I also got prodded to still
> provide an option to panic on detecting this, for debugging - so I
> rewrote this to report through the panic_mask mechanism, which now
> gives us the option to optionally panic if need be... could you do
> a second pass over this for me?

Couple of things:

> Index: xfs-linux/xfs_iomap.c
> ===================================================================
> --- xfs-linux.orig/xfs_iomap.c	2006-08-15 15:22:53.238190250 +1000
> +++ xfs-linux/xfs_iomap.c	2006-08-16 12:40:41.385000250 +1000
> @@ -536,23 +536,27 @@ xfs_iomap_write_direct(
>  	 * Copy any maps to caller's array and return any error.
>  	 */
>  	if (nimaps == 0) {
> -		error = (ENOSPC);
> +		error = ENOSPC;
>  		goto error_out;
>  	}
>  
> -	*ret_imap = imap;
> -	*nmaps = 1;
> -	if ( !(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {

Here we check imap for block zero access....

> -                cmn_err(CE_PANIC,"Access to block zero:  fs <%s> inode: %lld "
> -                        "start_block : %llx start_off : %llx blkcnt : %llx "
> -                        "extent-state : %x \n",
> -                        (ip->i_mount)->m_fsname,
> -                        (long long)ip->i_ino,
> -                        (unsigned long long)ret_imap->br_startblock,
> +	if (unlikely(!ret_imap->br_startblock &&

and now you're checking ret_imap for zero block access. Shouldn't that
be checking imap?

> +		     !(io->io_flags & XFS_IOCORE_RT))) {
> +		xfs_cmn_err(XFS_PTAG_FSBLOCK_ZERO, CE_ALERT, ip->i_mount,
> +				"Access to block zero in inode %llu "
> +				"start_block: %llx start_off: %llx "
> +				"blkcnt: %llx extent-state: %x\n",
> +			(unsigned long long)ip->i_ino,
> +			(unsigned long long)ret_imap->br_startblock,
>  			(unsigned long long)ret_imap->br_startoff,
> -                        (unsigned long long)ret_imap->br_blockcount,
> +			(unsigned long long)ret_imap->br_blockcount,
>  			ret_imap->br_state);

FWIW, given the number of times this exact same code is given, a
wrapper function for it would clean up the code quite a bit. i.e.

		xfs_cmn_err_fsblock_zero(ip, ret_imap);

would replace the above mess....

> -        }
> +		error = EFSCORRUPTED;
> +		goto error_out;
> +	}
> +
> +	*ret_imap = imap;
> +	*nmaps = 1;
>  	return 0;
>  
>  error0:	/* Cancel bmap, unlock inode, unreserve quota blocks, cancel trans */
> @@ -715,16 +719,18 @@ retry:
>  		goto retry;
>  	}
>  
> -	if (!(io->io_flags & XFS_IOCORE_RT)  && !ret_imap->br_startblock) {

And this one checks ret_imap for block zero, not imap[0].

One of these original checks was buggy - which one should we be checking,
ret_imap that is being passed into the function or imap that is what was
returned  by the XFS_BMAPI call?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
