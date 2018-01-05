Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20540 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751100AbeAEBUh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jan 2018 20:20:37 -0500
Date: Fri, 5 Jan 2018 12:18:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/21] xfs: always grab transaction when scrubbing inode
Message-ID: <20180105011822.GR30682@dastard>
References: <151398977028.18741.12031215574014508438.stgit@magnolia>
 <151398979480.18741.932965977060944108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151398979480.18741.932965977060944108.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 22, 2017 at 04:43:14PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Always allocate a transaction for inode scrubbing, even if the _iget
> fails.  This is something that is nice to have now for consistency with
> the other scrubbers but will become critical when we get to online
> repair where we'll actually use the transaction + raw buffer read to fix
> the verifier errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> index 2be4b25..61cd112 100644
> --- a/fs/xfs/scrub/inode.c
> +++ b/fs/xfs/scrub/inode.c
> @@ -64,7 +64,7 @@ xfs_scrub_setup_inode(
>  		break;
>  	case -EFSCORRUPTED:
>  	case -EFSBADCRC:
> -		return 0;
> +		return xfs_scrub_trans_alloc(sc->sm, mp, &sc->tp);
>  	default:
>  		return error;
>  	}

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
