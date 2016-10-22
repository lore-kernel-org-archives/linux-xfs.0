Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25604 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754888AbcJVA6m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Oct 2016 20:58:42 -0400
Date: Fri, 21 Oct 2016 17:58:37 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: clear cowblocks tag when cow fork is emptied
Message-ID: <20161022005836.GB5256@birch.djwong.org>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
 <1477070533-59327-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477070533-59327-3-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 21, 2016 at 01:22:12PM -0400, Brian Foster wrote:
> The background cowblocks scan job takes care of scanning for inodes with
> potentially lingering blocks in the cow fork and clearing them out. If
> the background scanner reclaims the cow fork blocks, however, it doesn't
> immediately clear the cowblocks tag from the inode. Instead, the inode
> remains tagged until the background scanner comes around again,
> discovers the inode cow fork has no blocks, clears the tag and fires the
> trace_xfs_inode_free_cowblocks_invalid() tracepoint to indicate that the
> inode may have been incorrectly tagged.
> 
> This is not a major functional problem as the tag is ultimately cleared.
> Nonetheless, clear the tag when an inode cow fork is explicitly emptied
> to avoid the extra round trip through the background scanner and
> spurious "invalid" tracepoint.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok to me,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

(Will give this series a more thorough run through the spin cycle.)

> ---
>  fs/xfs/xfs_reflink.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cd308f1..a279b4e 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -567,10 +567,14 @@ xfs_reflink_cancel_cow_blocks(
>  		}
>  
>  		if (++idx >= ifp->if_bytes / sizeof(struct xfs_bmbt_rec))
> -			return 0;
> +			break;
>  		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
>  	}
>  
> +	/* clear tag if cow fork is emptied */
> +	if (!ifp->if_bytes)
> +		xfs_inode_clear_cowblocks_tag(ip);
> +
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
