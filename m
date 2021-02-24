Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E6C4C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1D2964EC8
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbhBXQB6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:01:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27082 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233431AbhBXPhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614180962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xG003ciwoeG3Lo4tRJ9VASYWosCMQY+Anr/ZQEVkzLI=;
        b=Ril7XMW/s5YJZLKmfDLU47ADU89P4Yc1jFG6KYpQetEzDVSqh4GgKFvQdjlJGsOrPGpKez
        IVgsqhiL9gETSnuuXQx09OLIDsoMg2dFXb1gUVvu/ULG581fDW8Mwk7gn3vEeWnCq3+qoQ
        0CZc/zBUbXnr2OjRdmbAvysFUoSJLKM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-YFYSLtCpOPGVA9qHyxY44g-1; Wed, 24 Feb 2021 10:35:57 -0500
X-MC-Unique: YFYSLtCpOPGVA9qHyxY44g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7443229CAAA;
        Wed, 24 Feb 2021 15:03:17 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8025D9D7;
        Wed, 24 Feb 2021 15:03:17 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:03:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 01/22] xfs: Add helper xfs_attr_node_remove_step
Message-ID: <20210224150315.GB981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-2-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:27AM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> This patch adds a new helper function xfs_attr_node_remove_step.  This
> will help simplify and modularize the calling function
> xfs_attr_node_removename.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 472b303..28ff93d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>  	if (retval && (state->path.active > 1)) {
>  		error = xfs_da3_join(state);
>  		if (error)
> -			goto out;
> +			return error;
>  		error = xfs_defer_finish(&args->trans);
>  		if (error)
> -			goto out;
> +			return error;
>  		/*
>  		 * Commit the Btree join operation and start a new trans.
>  		 */
>  		error = xfs_trans_roll_inode(&args->trans, dp);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
> +	return error;

Maybe just return 0 here since it looks like error might not have been
assigned..? With that fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +}
> +
> +/*
> + * Remove a name from a B-tree attribute list.
> + *
> + * This routine will find the blocks of the name to remove, remove them and
> + * shrink the tree if needed.
> + */
> +STATIC int
> +xfs_attr_node_removename(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state = NULL;
> +	int			error;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
> +		goto out;
> +
> +	error = xfs_attr_node_remove_step(args, state);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -- 
> 2.7.4
> 

