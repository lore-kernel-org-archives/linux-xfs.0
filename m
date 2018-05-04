Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751621AbeEDWJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 18:09:06 -0400
Date: Fri, 4 May 2018 15:08:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] xfs: check type in quota verifier during quotacheck
Message-ID: <20180504220834.GP26569@magnolia>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <8e4dd8ff-5202-0b9d-e3c6-193976d5b3cf@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4dd8ff-5202-0b9d-e3c6-193976d5b3cf@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 04, 2018 at 12:34:22PM -0500, Eric Sandeen wrote:
> During quotacheck we send in the quota type, so verify that as well.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index a926058f7b0c..c00174f32f0d 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -47,7 +47,7 @@ xfs_dquot_verify(
>  	struct xfs_mount *mp,
>  	xfs_disk_dquot_t *ddq,
>  	xfs_dqid_t	 id,
> -	uint		 type)	  /* used only when IO_dorepair is true */
> +	uint		 type)	  /* used only during quotacheck */
>  {
>  	/*
>  	 * We can encounter an uninitialized dquot buffer for 2 reasons:
> @@ -69,6 +69,8 @@ xfs_dquot_verify(
>  	if (ddq->d_version != XFS_DQUOT_VERSION)
>  		return __this_address;
>  
> +	if (type && ddq->d_flags != type)
> +		return __this_address;
>  	if (ddq->d_flags != XFS_DQ_USER &&
>  	    ddq->d_flags != XFS_DQ_PROJ &&
>  	    ddq->d_flags != XFS_DQ_GROUP)
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
