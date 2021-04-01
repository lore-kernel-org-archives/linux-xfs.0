Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E10EC433ED
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC49760FEE
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 17:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhDARxK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:53:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236486AbhDARpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 13:45:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1xdcdHMFI37QSkI/Jx0ad0Tb67LRp/vej3WqqaEExgY=;
        b=efVCwUdz46nNBBBtQ8yfEbAqPLN9/EQYqZX2fzyQyRGB2DyCnqgk3geowf507OPdmXH4h3
        IpLMtkWAS/sFHk1BxwUc8/vMV6XQ3hc5Ug2uM6Jtz6Y+Bm7cYWJE2oLXVMjUtn7+oSrtiU
        kDjkBhELyo4AnOgA7gMhCigiq6GgyN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-YsCtxxK9OLuiYFHAZk3vKA-1; Thu, 01 Apr 2021 11:43:17 -0400
X-MC-Unique: YsCtxxK9OLuiYFHAZk3vKA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40940800D53;
        Thu,  1 Apr 2021 15:43:16 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8C1A1001281;
        Thu,  1 Apr 2021 15:43:15 +0000 (UTC)
Date:   Thu, 1 Apr 2021 11:43:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v16 01/11] xfs: Reverse apply 72b97ea40d
Message-ID: <YGXqEdJfzhES/xDz@bfoster>
References: <20210326003308.32753-1-allison.henderson@oracle.com>
 <20210326003308.32753-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326003308.32753-2-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 05:32:58PM -0700, Allison Henderson wrote:
> Originally we added this patch to help modularize the attr code in
> preparation for delayed attributes and the state machine it requires.
> However, later reviews found that this slightly alters the transaction
> handling as the helper function is ambiguous as to whether the
> transaction is diry or clean.  This may cause a dirty transaction to be
> included in the next roll, where previously it had not.  To preserve the
> existing code flow, we reverse apply this commit.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 472b303..b42144e 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1202,24 +1202,6 @@ int xfs_attr_node_removename_setup(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_attr_node_remove_rmt(
> -	struct xfs_da_args	*args,
> -	struct xfs_da_state	*state)
> -{
> -	int			error = 0;
> -
> -	error = xfs_attr_rmtval_remove(args);
> -	if (error)
> -		return error;
> -
> -	/*
> -	 * Refill the state structure with buffers, the prior calls released our
> -	 * buffers.
> -	 */
> -	return xfs_attr_refillstate(state);
> -}
> -
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1248,7 +1230,15 @@ xfs_attr_node_removename(
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_node_remove_rmt(args, state);
> +		error = xfs_attr_rmtval_remove(args);
> +		if (error)
> +			goto out;
> +
> +		/*
> +		 * Refill the state structure with buffers, the prior calls
> +		 * released our buffers.
> +		 */
> +		error = xfs_attr_refillstate(state);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 

