Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbeCURmu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Mar 2018 13:42:50 -0400
Date: Wed, 21 Mar 2018 13:42:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 8/9] xfs: record inode buf errors as a xref error in
 inode scrubber
Message-ID: <20180321174248.GJ11127@bfoster.bfoster>
References: <152107377037.19571.8618901963505842632.stgit@magnolia>
 <152107382051.19571.2865600595521884732.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152107382051.19571.2865600595521884732.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 14, 2018 at 05:30:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> During the inode btree scrubs we try to confirm the freemask bits
> against the inode records.  If the inode buffer read fails, this is a
> cross-referencing error, not a corruption of the inode btree itself.
> Use the xref_process_error call here.  Found via core.version middlebit
> fuzz in xfs/415.
> 

What's the difference/consequence of this change?

Brian

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/ialloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 63ab3f9..32e0d1a 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -259,7 +259,8 @@ xfs_scrub_iallocbt_check_freemask(
>  
>  		error = xfs_imap_to_bp(mp, bs->cur->bc_tp, &imap,
>  				&dip, &bp, 0, 0);
> -		if (!xfs_scrub_btree_process_error(bs->sc, bs->cur, 0, &error))
> +		if (!xfs_scrub_btree_xref_process_error(bs->sc, bs->cur, 0,
> +				&error))
>  			continue;
>  
>  		/* Which inodes are free? */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
