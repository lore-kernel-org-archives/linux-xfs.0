Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Oct 2007 04:01:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9UB150v018226
	for <xfs@oss.sgi.com>; Tue, 30 Oct 2007 04:01:08 -0700
Date: Tue, 30 Oct 2007 10:05:23 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Clean up sparse warnings
Message-ID: <20071030100523.GA23489@infradead.org>
References: <20071029233442.GP995458@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029233442.GP995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Tue, Oct 30, 2007 at 10:34:42AM +1100, David Chinner wrote:
> 
> Clean up most outstanding sparse warnings.
> 
> These are mostly locking annotations, marking things static,
> casts where needed and declaring stuff in header files.

Nice.  Note that once we start on making things static there's also a lot
of things not really used non-static but exported which we should cleanup
aswell.  I'll look at that when I get some time.

Note that we'll also always get tons of sparse warnings for debug builds
because STATIC is defined away..

> @@ -2733,21 +2733,13 @@ xlog_recover_do_efd_trans(
>  				 * AIL lock.
>  				 */
>  				xfs_trans_delete_ail(mp, lip);
> -				break;
> +				xfs_efi_item_free(efip);
> +				return;
>  			}
>  		}
>  		lip = xfs_trans_next_ail(mp, lip, &gen, NULL);
>  	}
> -
> -	/*
> -	 * If we found it, then free it up.  If it wasn't there, it
> -	 * must have been overwritten in the log.  Oh well.
> -	 */
> -	if (lip != NULL) {
> -		xfs_efi_item_free(efip);
> -	} else {
> -		spin_unlock(&mp->m_ail_lock);
> -	}
> +	spin_unlock(&mp->m_ail_lock);

Imho non-trivial changes like this hunk always deserve beeing a patch of
it's own where they're described in details.


Note that I also get warnings from the lock annotations prover in sparse
about some conditional locking in xfs_mount.c.  I have patches I still need
to run through testing for those which clean the code up quite nicely aswell.
