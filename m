Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751095AbdITNXY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Sep 2017 09:23:24 -0400
Date: Wed, 20 Sep 2017 09:23:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: perag initialization should only touch
 m_ag_max_usable for AG 0
Message-ID: <20170920132322.GC16481@bfoster.bfoster>
References: <20170919181041.GC7112@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170919181041.GC7112@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Tue, Sep 19, 2017 at 11:10:41AM -0700, Darrick J. Wong wrote:
> We call __xfs_ag_resv_init to make a per-AG reservation for each AG.
> This makes the reservation per-AG, not per-filesystem.  Therefore, it
> is incorrect to adjust m_ag_max_usable for each AG.  Adjust it only
> when we're reserving AG 0's blocks so that we only do it once per fs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag_resv.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index b008ff3..df3e600 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -156,7 +156,8 @@ __xfs_ag_resv_free(
>  	trace_xfs_ag_resv_free(pag, type, 0);
>  
>  	resv = xfs_perag_resv(pag, type);
> -	pag->pag_mount->m_ag_max_usable += resv->ar_asked;
> +	if (pag->pag_agno == 0)
> +		pag->pag_mount->m_ag_max_usable += resv->ar_asked;
>  	/*
>  	 * AGFL blocks are always considered "free", so whatever
>  	 * was reserved at mount time must be given back at umount.
> @@ -216,7 +217,14 @@ __xfs_ag_resv_init(
>  		return error;
>  	}
>  
> -	mp->m_ag_max_usable -= ask;
> +	/*
> +	 * Reduce the maximum per-AG allocation length by however much we're
> +	 * trying to reserve for an AG.  Since this is a filesystem-wide
> +	 * counter, we only make the adjustment for AG 0.  This assumes that
> +	 * there aren't any AGs hungrier for per-AG reservation than AG 0.
> +	 */
> +	if (pag->pag_agno == 0)
> +		mp->m_ag_max_usable -= ask;
>  
>  	resv = xfs_perag_resv(pag, type);
>  	resv->ar_asked = ask;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
