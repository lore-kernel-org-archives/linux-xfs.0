Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57B2C433E6
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 716DD64F07
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhBXQCe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:02:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233633AbhBXPiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:38:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614180986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ztq8vPAkQTz/wAWEvTkdd/3s9jOpis3ST2dzAdKzOJI=;
        b=PHAhw/J8g/ohmu7tgxPER89f2YQE61BrtpQ/nx8WI4pyQItJgn4maVe0lPxWNpEQQUY5yW
        vhPmgsxYw16kqqljpLrr7/Ov6WYq/f9C3Z397GH7clGtoorhNxliXKaC1dF4MKAQMA8iu6
        VQvVpzruyeqnWjYk7tX0ZHwT94jLEFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-iw4-iVwbMjeFZN8SFurFiw-1; Wed, 24 Feb 2021 10:36:06 -0500
X-MC-Unique: iw4-iVwbMjeFZN8SFurFiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E82712A8735;
        Wed, 24 Feb 2021 15:04:05 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C92F19C71;
        Wed, 24 Feb 2021 15:04:05 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:04:03 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 03/22] xfs: Hoist transaction handling in
 xfs_attr_node_remove_step
Message-ID: <20210224150403.GD981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-4-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-4-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:29AM -0700, Allison Henderson wrote:
> This patch hoists transaction handling in xfs_attr_node_removename to
> xfs_attr_node_remove_step.  This will help keep transaction handling in
> higher level functions instead of buried in subfunctions when we
> introduce delay attributes
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 45 ++++++++++++++++++++++-----------------------
>  1 file changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 4e6c89d..3cf76e2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1251,9 +1251,7 @@ xfs_attr_node_remove_step(
>  	struct xfs_da_args	*args,
>  	struct xfs_da_state	*state)
>  {
> -	int			retval, error;
> -	struct xfs_inode	*dp = args->dp;
> -
> +	int			error = 0;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1265,25 +1263,6 @@ xfs_attr_node_remove_step(
>  		if (error)
>  			return error;
>  	}
> -	retval = xfs_attr_node_remove_cleanup(args, state);
> -
> -	/*
> -	 * Check to see if the tree needs to be collapsed.
> -	 */
> -	if (retval && (state->path.active > 1)) {
> -		error = xfs_da3_join(state);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the Btree join operation and start a new trans.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
> -	}
>  
>  	return error;
>  }
> @@ -1299,7 +1278,7 @@ xfs_attr_node_removename(
>  	struct xfs_da_args	*args)
>  {
>  	struct xfs_da_state	*state = NULL;
> -	int			error;
> +	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
>  	trace_xfs_attr_node_removename(args);
> @@ -1312,6 +1291,26 @@ xfs_attr_node_removename(
>  	if (error)
>  		goto out;
>  
> +	retval = xfs_attr_node_remove_cleanup(args, state);
> +
> +	/*
> +	 * Check to see if the tree needs to be collapsed.
> +	 */
> +	if (retval && (state->path.active > 1)) {
> +		error = xfs_da3_join(state);
> +		if (error)
> +			goto out;
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			goto out;
> +		/*
> +		 * Commit the Btree join operation and start a new trans.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			goto out;
> +	}
> +
>  	/*
>  	 * If the result is small enough, push it all into the inode.
>  	 */
> -- 
> 2.7.4
> 

