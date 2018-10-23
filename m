Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36186 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeJWMo0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Oct 2018 08:44:26 -0400
Date: Mon, 22 Oct 2018 21:22:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs_repair: continue after xfs_bunmapi deadlock
 avoidance
Message-ID: <20181023042241.GZ28243@magnolia>
References: <9070c949-2720-75ea-01c3-74261bf62f87@sandeen.net>
 <18102abe-0101-bd08-dc5b-2f288dc0d8d3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18102abe-0101-bd08-dc5b-2f288dc0d8d3@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 22, 2018 at 11:08:49PM -0500, Eric Sandeen wrote:
> After commit:
> 
> 15a8bcc xfs: fix multi-AG deadlock in xfs_bunmapi
> 
> xfs_bunmapi can legitimately return before all work is done.
> Sadly nobody told xfs_repair, so it fires an assert:
> 
>  phase6.c:1410: longform_dir2_rebuild: Assertion `done' failed. 
> 
> Fix this by calling back in until all work is done, as we do
> in the kernel.

Looking at the rest of xfsprogs, I think the other directory-related
xfs_bunmapi callers probably need to be able to roll-and-continue, but
that seems like a topic for (a) the kernel and (b) separate patches.

> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1641116
> Reported-by: Tomasz Torcz <tomek@pipebreaker.pl>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index e017326..b87c751 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1317,7 +1317,7 @@ longform_dir2_rebuild(
>  	xfs_fileoff_t		lastblock;
>  	xfs_inode_t		pip;
>  	dir_hash_ent_t		*p;
> -	int			done;
> +	int			done = 0;
>  
>  	/*
>  	 * trash directory completely and rebuild from scratch using the
> @@ -1352,12 +1352,25 @@ longform_dir2_rebuild(
>  			error);
>  
>  	/* free all data, leaf, node and freespace blocks */
> -	error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA, 0,
> -				&done);
> -	if (error) {
> -		do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
> -		goto out_bmap_cancel;
> -	}
> +	while (!done) {
> +	       error = -libxfs_bunmapi(tp, ip, 0, lastblock, XFS_BMAPI_METADATA,
> +			               0, &done);
> +	       if (error) {
> +		       do_warn(_("xfs_bunmapi failed -- error - %d\n"), error);
> +		       goto out_bmap_cancel;
> +	       }
> +	       error = xfs_defer_finish(&tp);

error = -libxfs_defer_finish(...);

> +	       if (error) {
> +		       do_warn(("defer_finish failed -- error - %d\n"), error);
> +		       goto out_bmap_cancel;
> +	       }
> +	       /*
> +		* Close out trans and start the next one in the chain.
> +		*/
> +	       error = xfs_trans_roll_inode(&tp, ip);

error = -libxfs_trans_roll_inode(...);

> +	       if (error)
> +			goto out_bmap_cancel;
> +        }
>  
>  	ASSERT(done);

This assert can go away since !done is the loop test condition.

--D

>  
> 
