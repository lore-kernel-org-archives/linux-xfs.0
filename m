Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21126 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbdIVSrB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Sep 2017 14:47:01 -0400
Date: Fri, 22 Sep 2017 11:46:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Capture state of the right inode in xfs_iflush_done
Message-ID: <20170922184655.GJ5728@magnolia>
References: <20170922113555.17711-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922113555.17711-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Sep 22, 2017 at 01:35:55PM +0200, Carlos Maiolino wrote:
> My previous patch: d3a304b6292168b83b45d624784f973fdc1ca674 check for
> XFS_LI_FAILED flag xfs_iflush done, so the failed item can be properly
> resubmitted.
> 
> In the loop scanning other inodes being completed, it should check the
> current item for the XFS_LI_FAILED, and not the initial one.
> 
> The state of the initial inode is checked after the loop ends
> 
> Kudos to Eric for catching this.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode_item.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 6d0f74ec31e8..015e8ee793a3 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -745,7 +745,7 @@ xfs_iflush_done(
>  		 */
>  		iip = INODE_ITEM(blip);
>  		if ((iip->ili_logged && blip->li_lsn == iip->ili_flush_lsn) ||
> -		    lip->li_flags & XFS_LI_FAILED)
> +		    blip->li_flags & XFS_LI_FAILED)

/me grumbles about the braces here, but will just fix that on the way in...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  			need_ail++;
>  
>  		blip = next;
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
