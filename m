Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35710 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966071AbdD0VEv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 17:04:51 -0400
Date: Thu, 27 Apr 2017 14:04:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Allow user to kill fstrim process
Message-ID: <20170427210445.GJ23371@birch.djwong.org>
References: <1493282368-32422-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1493282368-32422-1-git-send-email-lczerner@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2017 at 10:39:28AM +0200, Lukas Czerner wrote:
> fstrim can take really long time on big, slow device or on file system
> with a lots of allocation groups. Currently there is no way for the user
> to cancell the operation. This patch makes it possible for the user to
> kill fstrim pocess by adding the check for fatal_signal_pending() in
> xfs_trim_extents().
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_discard.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index d796ffa..6a05d27 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -132,6 +132,11 @@ xfs_trim_extents(
>  		error = xfs_btree_decrement(cur, 0, &i);
>  		if (error)
>  			goto out_del_cursor;
> +
> +		if (fatal_signal_pending(current)) {
> +			error = -ERESTARTSYS;
> +			goto out_del_cursor;
> +		}
>  	}
>  
>  out_del_cursor:
> @@ -196,8 +201,11 @@ xfs_ioc_trim(
>  	for (agno = start_agno; agno <= end_agno; agno++) {
>  		error = xfs_trim_extents(mp, agno, start, end, minlen,
>  					  &blocks_trimmed);
> -		if (error)
> +		if (error) {
>  			last_error = error;
> +			if (error == -ERESTARTSYS)
> +				break;
> +		}
>  	}
>  
>  	if (last_error)
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
