Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227145211.nk2x2uylo5joamdu@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from bombadil.infradead.org ([65.50.211.133]:56223 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdBUP7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Feb 2017 10:59:24 -0500
Date: Tue, 21 Feb 2017 16:59:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/7] fs, xfs: convert xfs_buf_log_item.bli_refcount from
 atomic_t to refcount_t
Message-ID: <20170221155922.GI6515@twins.programming.kicks-ass.net>
References: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
 <1487692147-17066-4-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487692147-17066-4-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>

On Tue, Feb 21, 2017 at 05:49:03PM +0200, Elena Reshetova wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

Changelog forgets to mention if this was runtime tested..


> @@ -371,7 +371,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>  	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
>  	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
>  	ASSERT(!(bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> -	ASSERT(atomic_read(&bip->bli_refcount) > 0);
> +	ASSERT(refcount_read(&bip->bli_refcount) > 0);
>  
>  	trace_xfs_trans_brelse(bip);
>  
> @@ -419,7 +419,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>  	/*
>  	 * Drop our reference to the buf log item.
>  	 */
> -	atomic_dec(&bip->bli_refcount);
> +	refcount_dec(&bip->bli_refcount);
>  
>  	/*
>  	 * If the buf item is not tracking data in the log, then
> @@ -432,7 +432,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>  /***
>  		ASSERT(bp->b_pincount == 0);
>  ***/
> -		ASSERT(atomic_read(&bip->bli_refcount) == 0);
> +		ASSERT(refcount_read(&bip->bli_refcount) == 0);
>  		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
>  		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
>  		xfs_buf_item_relse(bp);


This for example looks dodgy.

That seems to suggest the atomic_dec() there can actually hit 0, which
_will_ generate a WARN.
