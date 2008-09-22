Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Sep 2008 20:53:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8M3r9lI008250
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:53:09 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4127B127F79E
	for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:54:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 44v4JeKneO6YOcPZ for <xfs@oss.sgi.com>; Sun, 21 Sep 2008 20:54:42 -0700 (PDT)
Message-ID: <48D71701.6070900@sandeen.net>
Date: Sun, 21 Sep 2008 22:54:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Remove xfs_iext_irec_compact_full()
References: <48D7160B.8020108@sgi.com>
In-Reply-To: <48D7160B.8020108@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: lachlan@sgi.com
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> Yet another bug was found in xfs_iext_irec_compact_full() and while the
> source of the bug was found it wasn't an easy task to track it down because
> the conditions are very difficult to reproduce.  Code that is difficult to
> reach is difficult to test and debug.

It might be nice to give credit to those who helped find it in the commit ;)

> xfs_iext_irec_compact_full() and xfs_iext_irec_compact_pages() are almost
> identical - they both compact indirect extent lists by moving extents from
> subsequent buffers into earlier ones.  xfs_iext_irec_compact_pages() only
> moves extents if all of the extents in the next buffer will fit into the
> empty space in the buffer before it.  xfs_iext_irec_compact_full() will go
> a step further and move part of the next buffer if all the extents wont fit.
> It will then shift the remaining extents in the next buffer up to the start
> of the buffer.  The bug here was that we did not update er_extoff and this
> caused extent list corruption.

I'd be half-tempted to commit the fix to the code before removing it,
just in case later generations ever resurrect any of this code?  *shrug*

Other than that, I think this looks ok.

-Eric

> It does not appear that this extra functionality gains us much.  Calling
> xfs_iext_irec_compact_pages() instead will do a good enough job at compacting
> the indirect list and will be quicker too.
> 
> For the case in xfs_iext_indirect_to_direct() the total number of extents
> in the indirect list will fit into one buffer so we will never need the
> extra functionality of xfs_iext_irec_compact_full() there.
> 
> Also xfs_iext_irec_compact_pages() doesn't need to do a memmove() (the
> buffers will never overlap) so we don't want the performance hit that
> can incur.
> 
> --- a/fs/xfs/xfs_inode.c	2008-09-22 13:15:33.000000000 +1000
> +++ b/fs/xfs/xfs_inode.c	2008-09-22 13:24:24.000000000 +1000
> @@ -4157,7 +4157,7 @@ xfs_iext_indirect_to_direct(
>  	ASSERT(nextents <= XFS_LINEAR_EXTS);
>  	size = nextents * sizeof(xfs_bmbt_rec_t);
>  
> -	xfs_iext_irec_compact_full(ifp);
> +	xfs_iext_irec_compact_pages(ifp);
>  	ASSERT(ifp->if_real_bytes == XFS_IEXT_BUFSZ);
>  
>  	ep = ifp->if_u1.if_ext_irec->er_extbuf;
> @@ -4488,8 +4488,7 @@ xfs_iext_irec_remove(
>   * compaction policy is as follows:
>   *
>   *    Full Compaction: Extents fit into a single page (or inline buffer)
> - *    Full Compaction: Extents occupy less than 10% of allocated space
> - * Partial Compaction: Extents occupy > 10% and < 50% of allocated space
> + * Partial Compaction: Extents occupy less than 50% of allocated space
>   *      No Compaction: Extents occupy at least 50% of allocated space
>   */
>  void
> @@ -4510,8 +4509,6 @@ xfs_iext_irec_compact(
>  		xfs_iext_direct_to_inline(ifp, nextents);
>  	} else if (nextents <= XFS_LINEAR_EXTS) {
>  		xfs_iext_indirect_to_direct(ifp);
> -	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 3) {
> -		xfs_iext_irec_compact_full(ifp);
>  	} else if (nextents < (nlists * XFS_LINEAR_EXTS) >> 1) {
>  		xfs_iext_irec_compact_pages(ifp);
>  	}
> @@ -4535,7 +4532,7 @@ xfs_iext_irec_compact_pages(
>  		erp_next = erp + 1;
>  		if (erp_next->er_extcount <=
>  		    (XFS_LINEAR_EXTS - erp->er_extcount)) {
> -			memmove(&erp->er_extbuf[erp->er_extcount],
> +			memcpy(&erp->er_extbuf[erp->er_extcount],
>  				erp_next->er_extbuf, erp_next->er_extcount *
>  				sizeof(xfs_bmbt_rec_t));
>  			erp->er_extcount += erp_next->er_extcount;
> @@ -4555,91 +4552,6 @@ xfs_iext_irec_compact_pages(
>  }
>  
>  /*
> - * Fully compact the extent records managed by the indirection array.
> - */
> -void
> -xfs_iext_irec_compact_full(
> -	xfs_ifork_t	*ifp)			/* inode fork pointer */
> -{
> -	xfs_bmbt_rec_host_t *ep, *ep_next;	/* extent record pointers */
> -	xfs_ext_irec_t	*erp, *erp_next;	/* extent irec pointers */
> -	int		erp_idx = 0;		/* extent irec index */
> -	int		ext_avail;		/* empty entries in ex list */
> -	int		ext_diff;		/* number of exts to add */
> -	int		nlists;			/* number of irec's (ex lists) */
> -
> -	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
> -
> -	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> -	erp = ifp->if_u1.if_ext_irec;
> -	ep = &erp->er_extbuf[erp->er_extcount];
> -	erp_next = erp + 1;
> -	ep_next = erp_next->er_extbuf;
> -
> -	while (erp_idx < nlists - 1) {
> -		/*
> -		 * Check how many extent records are available in this irec.
> -		 * If there is none skip the whole exercise.
> -		 */
> -		ext_avail = XFS_LINEAR_EXTS - erp->er_extcount;
> -		if (ext_avail) {
> -
> -			/*
> -			 * Copy over as many as possible extent records into
> -			 * the previous page.
> -			 */
> -			ext_diff = MIN(ext_avail, erp_next->er_extcount);
> -			memcpy(ep, ep_next, ext_diff * sizeof(xfs_bmbt_rec_t));
> -			erp->er_extcount += ext_diff;
> -			erp_next->er_extcount -= ext_diff;
> -
> -			/*
> -			 * If the next irec is empty now we can simply
> -			 * remove it.
> -			 */
> -			if (erp_next->er_extcount == 0) {
> -				/*
> -				 * Free page before removing extent record
> -				 * so er_extoffs don't get modified in
> -				 * xfs_iext_irec_remove.
> -				 */
> -				kmem_free(erp_next->er_extbuf);
> -				erp_next->er_extbuf = NULL;
> -				xfs_iext_irec_remove(ifp, erp_idx + 1);
> -				erp = &ifp->if_u1.if_ext_irec[erp_idx];
> -				nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> -
> -			/*
> -			 * If the next irec is not empty move up the content
> -			 * that has not been copied to the previous page to
> -			 * the beggining of this one.
> -			 */
> -			} else {
> -				memmove(erp_next->er_extbuf, &ep_next[ext_diff],
> -					erp_next->er_extcount *
> -					sizeof(xfs_bmbt_rec_t));
> -				ep_next = erp_next->er_extbuf;
> -				memset(&ep_next[erp_next->er_extcount], 0,
> -					(XFS_LINEAR_EXTS -
> -						erp_next->er_extcount) *
> -					sizeof(xfs_bmbt_rec_t));
> -			}
> -		}
> -
> -		if (erp->er_extcount == XFS_LINEAR_EXTS) {
> -			erp_idx++;
> -			if (erp_idx < nlists)
> -				erp = &ifp->if_u1.if_ext_irec[erp_idx];
> -			else
> -				break;
> -		}
> -		ep = &erp->er_extbuf[erp->er_extcount];
> -		erp_next = erp + 1;
> -		ep_next = erp_next->er_extbuf;
> -	}
> -}
> -
> -/*
>   * This is called to update the er_extoff field in the indirection
>   * array when extents have been added or removed from one of the
>   * extent lists. erp_idx contains the irec index to begin updating
> 
> 
