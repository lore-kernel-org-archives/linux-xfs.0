Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710FFC433E9
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AF5D64F03
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Feb 2021 16:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhBXQBv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:01:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233383AbhBXPh2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 10:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614180951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BlGg7XK/aRe9+o15hKox1UcM01iSuHpvSJwse8CKrpg=;
        b=Vq/M/uLYyuzieQxWYHFF2LHaPmOhWJ2cc6rrSI0nxL9hmuaGWTWOwJhG02pQb8h4f46n6/
        X4E4JLH40GRzgUdV2CkrAl1zcGbQf5LXHqFxlckvTLEK1NTQjheOLzddVcvEBe2TkA/KFG
        ykcEOIL2Cq0EjbzWjRXTgQRrlM4Dj8o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-93h74f7eP-mnj1xH6zBYhQ-1; Wed, 24 Feb 2021 10:35:45 -0500
X-MC-Unique: 93h74f7eP-mnj1xH6zBYhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE2C61876550;
        Wed, 24 Feb 2021 15:04:54 +0000 (UTC)
Received: from bfoster (ovpn-119-92.rdu2.redhat.com [10.10.119.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62D5C2BFC7;
        Wed, 24 Feb 2021 15:04:54 +0000 (UTC)
Date:   Wed, 24 Feb 2021 10:04:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v15 07/22] xfs: Add helper xfs_attr_node_addname_find_attr
Message-ID: <20210224150452.GH981777@bfoster>
References: <20210218165348.4754-1-allison.henderson@oracle.com>
 <20210218165348.4754-8-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218165348.4754-8-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 09:53:33AM -0700, Allison Henderson wrote:
> This patch separates the first half of xfs_attr_node_addname into a
> helper function xfs_attr_node_addname_find_attr.  It also replaces the
> restart goto with with an EAGAIN return code driven by a loop in the
> calling function.  This looks odd now, but will clean up nicly once we
> introduce the state machine.  It will also enable hoisting the last
> state out of xfs_attr_node_addname with out having to plumb in a "done"
> parameter to know if we need to move to the next state or not.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 80 ++++++++++++++++++++++++++++++------------------
>  1 file changed, 51 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index bee8d3fb..4333b61 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> @@ -941,6 +931,38 @@ xfs_attr_node_addname(
>  		args->rmtvaluelen = 0;
>  	}
>  
> +	return 0;
> +out:

Nit: can we call this label 'error' since it appears to be used when we
want to return the current retval as an operational error?

> +	if (*state)
> +		xfs_da_state_free(*state);
> +	return retval;
> +}
> +
> +/*
> + * Add a name to a Btree-format attribute list.
> + *
> + * This will involve walking down the Btree, and may involve splitting
> + * leaf nodes and even splitting intermediate nodes up to and including
> + * the root node (a special case of an intermediate node).
> + *
> + * "Remote" attribute values confuse the issue and atomic rename operations
> + * add a whole extra layer of confusion on top of that.
> + */
> +STATIC int
> +xfs_attr_node_addname(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_inode	*dp;
> +	int			retval, error;
> +
> +	trace_xfs_attr_node_addname(args);

This moves the tracepoint into the looping sequence whereas previously
it would only execute once. I don't see a clean way to fix that with the
breakdown as of this patch, and it's not a huge deal, but it would be
nice to fix that before the end of the series if we haven't already.
Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +
> +	dp = args->dp;
> +	blk = &state->path.blk[state->path.active-1];
> +	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
> +
>  	retval = xfs_attr3_leaf_add(blk->bp, state->args);
>  	if (retval == -ENOSPC) {
>  		if (state->path.active == 1) {
> @@ -966,7 +988,7 @@ xfs_attr_node_addname(
>  			if (error)
>  				goto out;
>  
> -			goto restart;
> +			return -EAGAIN;
>  		}
>  
>  		/*
> -- 
> 2.7.4
> 

