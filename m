Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF32CC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 16:51:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8CFD23103
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Dec 2020 16:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgLVQvl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Dec 2020 11:51:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727632AbgLVQvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Dec 2020 11:51:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608655814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RQtkabv2LibDe5Xdfj8tmJm1Jy6WFdMVPSvWmoKQq0U=;
        b=NXDuOpvRG2AkkJ8NTUq8DqQOPpjfT6H0fv0FMAVOfFePxM+n2DZ+SYp4qkBQDZWQxQJ9pv
        lcL+kVrHpa8s4P4ViEwLPaAR0XZphC12TqTflSA6EsyDhiBHg7fXfcBE9fWagyFJ5thwZ5
        kHKntIj1/hD/YuvyBwTSY7TFQ6TSdSY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-306-lxY640BQOfi98JQaZmnIQg-1; Tue, 22 Dec 2020 11:50:12 -0500
X-MC-Unique: lxY640BQOfi98JQaZmnIQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB57C107ACE3;
        Tue, 22 Dec 2020 16:50:11 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F93760C5B;
        Tue, 22 Dec 2020 16:50:11 +0000 (UTC)
Date:   Tue, 22 Dec 2020 11:50:09 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v14 01/15] xfs: Add helper xfs_attr_node_remove_step
Message-ID: <20201222165009.GA2808393@bfoster>
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218072917.16805-2-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 18, 2020 at 12:29:03AM -0700, Allison Henderson wrote:
> From: Allison Collins <allison.henderson@oracle.com>
> 
> This patch as a new helper function xfs_attr_node_remove_step.  This
> will help simplify and modularize the calling function
> xfs_attr_node_remove.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e641..8b55a8d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>   * the root node (a special case of an intermediate node).
>   */
>  STATIC int
> -xfs_attr_node_removename(
> -	struct xfs_da_args	*args)
> +xfs_attr_node_remove_step(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
>  {
> -	struct xfs_da_state	*state;
>  	struct xfs_da_state_blk	*blk;
>  	int			retval, error;
>  	struct xfs_inode	*dp = args->dp;
>  
> -	trace_xfs_attr_node_removename(args);
> -
> -	error = xfs_attr_node_removename_setup(args, &state);
> -	if (error)
> -		goto out;
>  
>  	/*
>  	 * If there is an out-of-line value, de-allocate the blocks.
> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>  	if (args->rmtblkno > 0) {
>  		error = xfs_attr_node_remove_rmt(args, state);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
>  	/*
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

