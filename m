Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5138FC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B2E61246
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Apr 2021 00:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhDNAHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 20:07:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhDNAHF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 20:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6CD160249;
        Wed, 14 Apr 2021 00:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618358804;
        bh=o7AqRO4iyOWKK2LVD3/KYy8zbU64/E7+MmeyPIUKLx0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgk7HSQ7v6hcNMv1Kq61b/9s/oYahKeAhXucYgkgprUaXeqN51rtVv3+DkHLv9enq
         0j3H6Wqv3yyDc2isLrQbJioh5mlI5htDpYSYg8l/BXd5MQdU99YCt1/J55E6/Pz4sg
         E+EZASYc7PSy4Epfm2KfZkwl6h1iqAtx8y2Xqhy3svo9eAqQ2PscpYXG38Gr6+6mHq
         3mZicsZa4Ko5owdN3sb1NDmsoNsg2u40QdL2WwDgJiROmCcqLBIGoMcA+ZphhN+JY/
         lXN7r8qDwzQWL1+Nu32Qr7tXUNIwviqagL4JmFg7lrMrfyQj4/SvggsfMxGx6wsLqB
         RpJkAzUhiNfUg==
Date:   Tue, 13 Apr 2021 17:06:43 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/7] xfs: simplify xfs_attr_remove_args
Message-ID: <20210414000643.GQ3957620@magnolia>
References: <20210412133819.2618857-1-hch@lst.de>
 <20210412133819.2618857-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412133819.2618857-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 12, 2021 at 03:38:15PM +0200, Christoph Hellwig wrote:
> Directly return from the subfunctions and avoid the error variable.  Also
> remove the not really needed dp local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd61c67f573925..43ef85678cba6b 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -386,21 +386,16 @@ int
>  xfs_attr_remove_args(
>  	struct xfs_da_args      *args)
>  {
> -	struct xfs_inode	*dp = args->dp;
> -	int			error;
> +	if (!xfs_inode_hasattr(args->dp))
> +		return -ENOATTR;
>  
> -	if (!xfs_inode_hasattr(dp)) {
> -		error = -ENOATTR;
> -	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> -		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
> -		error = xfs_attr_shortform_remove(args);
> -	} else if (xfs_attr_is_leaf(dp)) {
> -		error = xfs_attr_leaf_removename(args);
> -	} else {
> -		error = xfs_attr_node_removename(args);
> +	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
> +		ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
> +		return xfs_attr_shortform_remove(args);
>  	}
> -
> -	return error;
> +	if (xfs_attr_is_leaf(args->dp))
> +		return xfs_attr_leaf_removename(args);
> +	return xfs_attr_node_removename(args);
>  }
>  
>  /*
> -- 
> 2.30.1
> 
