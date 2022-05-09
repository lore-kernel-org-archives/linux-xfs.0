Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF60C433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 08:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiEIIzD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 May 2022 04:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbiEIIW5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 May 2022 04:22:57 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC3051F0185
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 01:18:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D30F610E641B
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 18:17:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnyaI-009pGQ-Ic
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 18:17:38 +1000
Date:   Mon, 9 May 2022 18:17:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs: use XFS_DA_OP flags in deferred attr ops
Message-ID: <20220509081738.GO1098723@dread.disaster.area>
References: <20220506094553.512973-1-david@fromorbit.com>
 <20220506094553.512973-17-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506094553.512973-17-david@fromorbit.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6278ce25
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=HmUQqCAQpMAkksBoIDYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 07:45:52PM +1000, Dave Chinner wrote:
> @@ -1357,46 +1370,45 @@ xfs_attr_node_hasname(
>  
>  STATIC int
>  xfs_attr_node_addname_find_attr(
> -	 struct xfs_attr_item		*attr)
> +	 struct xfs_attr_item	*attr)
>  {
> -	struct xfs_da_args		*args = attr->xattri_da_args;
> -	int				retval;
> +	struct xfs_da_args	*args = attr->xattri_da_args;
> +	int			error;
>  
>  	/*
>  	 * Search to see if name already exists, and get back a pointer
>  	 * to where it should go.
>  	 */
> -	retval = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> -	if (retval != -ENOATTR && retval != -EEXIST)
> -		goto error;
> -
> -	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
> -		goto error;
> -	if (retval == -EEXIST) {
> -		if (args->attr_flags & XATTR_CREATE)
> +	error = xfs_attr_node_hasname(args, &attr->xattri_da_state);
> +	switch (error) {
> +	case -ENOATTR:
> +		if (args->op_flags & XFS_DA_OP_REPLACE)
> +			goto error;
> +		break;
> +	case -EEXIST:
> +		if (!(args->op_flags & XFS_DA_OP_REPLACE))
>  			goto error;
>  
> -		trace_xfs_attr_node_replace(args);
> -
> -		/* save the attribute state for later removal*/
> -		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
> -		xfs_attr_save_rmt_blk(args);
>  
> +		trace_xfs_attr_node_replace(args);
>  		/*
> -		 * clear the remote attr state now that it is saved so that the
> -		 * values reflect the state of the attribute we are about to
> +		 * Save the existing remote attr state so that the current
> +		 * values reflect the state of the new attribute we are about to
>  		 * add, not the attribute we just found and will remove later.
>  		 */
> -		args->rmtblkno = 0;
> -		args->rmtblkcnt = 0;
> -		args->rmtvaluelen = 0;
> +		xfs_attr_save_rmt_blk(args);

Ok, removing the rmtblk zeroing right there is a bug. Not sure how I
introduced that, or why it didn't show up until this afternoon. The
leaf version of this same code is correct, and it triggers on
generic/026 when larp = 0 but not when larp = 1.

I've fixed it, but vger is constipated again and I patches sent 8
hours ago haven't reached the list yet so when I arrives I'll post
an updated version of this patch against it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
