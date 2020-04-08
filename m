Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AB7C2BA1A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0EB42051A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DvX79n24"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgDHMKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:10:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58964 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726521AbgDHMKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586347802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vMygplPbE7hMyK5VgpiVA4f8LCRgZIIjk6H4ukmPOz8=;
        b=DvX79n24oJqSEdBHxGHbzXFO000iYrG8dLlWswxP6Tyh9MOkpfCbdtI9N0a5cPSeHmosjT
        pjVRDTpQhxfWjrOJqqHdSGJLVwMbmP410q/zg3zafL7xZN1P2EkSI4NZZcjcC3SnywrRgW
        Q0cYP7yO9f3UFcGla63s4CFXrDJ2Lpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-BLJsW2vINEOH055HaDr9SQ-1; Wed, 08 Apr 2020 08:09:59 -0400
X-MC-Unique: BLJsW2vINEOH055HaDr9SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 972A88017FF;
        Wed,  8 Apr 2020 12:09:58 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 274906EF88;
        Wed,  8 Apr 2020 12:09:58 +0000 (UTC)
Date:   Wed, 8 Apr 2020 08:09:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 16/20] xfs: Add helper function
 xfs_attr_node_removename_setup
Message-ID: <20200408120956.GC33192@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-17-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-17-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:25PM -0700, Allison Collins wrote:
> This patch adds a new helper function xfs_attr_node_removename_setup.
> This will help modularize xfs_attr_node_removename when we add delay
> ready attributes later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index f70b4f2..3c33dc5 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1193,6 +1193,35 @@ xfs_attr_leaf_mark_incomplete(
>  }
>  
>  /*
> + * Initial setup for xfs_attr_node_removename.  Make sure the attr is there and
> + * the blocks are valid.  Any remote blocks will be marked incomplete.
> + */
> +STATIC
> +int xfs_attr_node_removename_setup(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	**state)
> +{
> +	int			error;
> +	struct xfs_da_state_blk	*blk;
> +
> +	error = xfs_attr_node_hasname(args, state);
> +	if (error != -EEXIST)
> +		return error;
> +
> +	blk = &(*state)->path.blk[(*state)->path.active - 1];
> +	ASSERT(blk->bp != NULL);
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
> +	if (args->rmtblkno > 0) {
> +		error = xfs_attr_leaf_mark_incomplete(args, *state);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1210,8 +1239,8 @@ xfs_attr_node_removename(
>  
>  	trace_xfs_attr_node_removename(args);
>  
> -	error = xfs_attr_node_hasname(args, &state);
> -	if (error != -EEXIST)
> +	error = xfs_attr_node_removename_setup(args, &state);
> +	if (error)
>  		goto out;
>  
>  	/*
> @@ -1219,14 +1248,7 @@ xfs_attr_node_removename(
>  	 * This is done before we remove the attribute so that we don't
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
> -	blk = &state->path.blk[ state->path.active-1 ];
> -	ASSERT(blk->bp != NULL);
> -	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_leaf_mark_incomplete(args, state);
> -		if (error)
> -			goto out;
> -
>  		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			goto out;
> -- 
> 2.7.4
> 

