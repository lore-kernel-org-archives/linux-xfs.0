Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B84C35E01
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8122B2084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UD8aGY2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgBYQLg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:11:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51580 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729206AbgBYQLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:11:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582647094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rphvVOoq+xYmSQZ9ryQPz69lAfBAoD/TaxllZihgSxE=;
        b=UD8aGY2S3h6MSxbthVlakg+R6XQX76u1cj24F9GjgycQYmRpACYpZfVrPwolPm9iAcW2AJ
        6l2jnAMLJX5Qi+OtE7L5I4NJRPWBdi2jZ7tgz40X1ayyARq8C7rXXWCKmb21WXPb7YVRMt
        40diSmLNmO/eZKDp6YYO0QG65KASHlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-hwjB6Vr9MfeZq4DxL5c97A-1; Tue, 25 Feb 2020 11:11:27 -0500
X-MC-Unique: hwjB6Vr9MfeZq4DxL5c97A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C46D018A6EC8;
        Tue, 25 Feb 2020 16:11:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DA1F788859;
        Tue, 25 Feb 2020 16:11:24 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:11:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 2/7] xfs: xfs_attr_calc_size: Use local
 variables to track individual space components
Message-ID: <20200225161122.GB54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-3-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-3-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:39AM +0530, Chandan Rajendra wrote:
> The size calculated by xfs_attr_calc_size() is a sum of three components,
> 1. Number of dabtree blocks
> 2. Number of Bmbt blocks
> 3. Number of remote blocks
> 
> This commit introduces new local variables to track these numbers explicitly.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1875210cc8e40..942ba552e0bdd 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -142,8 +142,10 @@ xfs_attr_calc_size(
>  	int			*local)
>  {
>  	struct xfs_mount	*mp = args->dp->i_mount;
> +	unsigned int		total_dablks;
> +	unsigned int		bmbt_blks;
> +	unsigned int		rmt_blks;
>  	int			size;
> -	int			nblks;
>  
>  	/*
>  	 * Determine space new attribute will use, and if it would be
> @@ -151,23 +153,26 @@ xfs_attr_calc_size(
>  	 */
>  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
>  			args->valuelen, local);
> -	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
> +	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> +	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
>  			/* Double split possible */
> -			nblks *= 2;
> +			total_dablks *= 2;
> +			bmbt_blks *= 2;
>  		}
> +		rmt_blks = 0;

I'd just initialize this one to zero above. Otherwise looks fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	} else {
>  		/*
>  		 * Out of line attribute, cannot double split, but
>  		 * make room for the attribute value itself.
>  		 */
> -		uint	dblocks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> -		nblks += dblocks;
> -		nblks += XFS_NEXTENTADD_SPACE_RES(mp, dblocks, XFS_ATTR_FORK);
> +		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
> +				XFS_ATTR_FORK);
>  	}
>  
> -	return nblks;
> +	return total_dablks + rmt_blks + bmbt_blks;
>  }
>  
>  STATIC int
> -- 
> 2.19.1
> 

