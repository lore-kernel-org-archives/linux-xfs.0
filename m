Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41969 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbdLHEWZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:22:25 -0500
Date: Thu, 7 Dec 2017 20:22:17 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] mkfs: remove unused m_uuid in sb_feat_args
Message-ID: <20171208042217.GJ19219@magnolia>
References: <ba4823ed-fabd-d02c-42f3-40c8d5aa44a6@redhat.com>
 <591ad270-b882-f3ad-ca8a-ce15b3e75035@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591ad270-b882-f3ad-ca8a-ce15b3e75035@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Dec 07, 2017 at 10:13:51PM -0600, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
>  mkfs/xfs_mkfs.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0f7dd92..d30f73d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -773,7 +773,6 @@ struct sb_feat_args {
>  	bool	parent_pointers;
>  	bool	nodalign;
>  	bool	nortalign;
> -	uuid_t	m_uuid;
>  };
>  
>  struct cli_params {
> -- 
> 1.8.3.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
