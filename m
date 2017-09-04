Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36568 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753821AbdIDQRX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 12:17:23 -0400
Received: by mail-wm0-f46.google.com with SMTP id i145so7516020wmf.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Sep 2017 09:17:23 -0700 (PDT)
Date: Mon, 4 Sep 2017 18:17:20 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: don't unconditionally clear the reflink flag on
 zero-block files
Message-ID: <20170904161720.dkf5khwuzp2vbrv2@hades.localdomain>
References: <20170904154944.GG4671@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170904154944.GG4671@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Sep 04, 2017 at 08:49:44AM -0700, Darrick J. Wong wrote:
> If we have speculative cow preallocations hanging around in the cow
> fork, don't let a truncate operation clear the reflink flag because if
> we do then there's a chance we'll forget to free those extents when we
> destroy the incore inode.
> 
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_inode.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 5599dda..4ec5b7f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1624,10 +1624,12 @@ xfs_itruncate_extents(
>  		goto out;
>  
>  	/*
> -	 * Clear the reflink flag if we truncated everything.
> +	 * Clear the reflink flag if there are no data fork blocks and
> +	 * there are no extents staged in the cow fork.
>  	 */
> -	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
> -		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
> +	if (xfs_is_reflink_inode(ip) && ip->i_cnextents == 0) {
> +		if (ip->i_d.di_nblocks == 0)
> +			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
>  		xfs_inode_clear_cowblocks_tag(ip);
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
