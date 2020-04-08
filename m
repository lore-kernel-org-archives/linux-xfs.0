Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29EEBC2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FB22051A
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:10:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TykbZrqj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgDHMKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:10:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30914 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728072AbgDHMKM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586347811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8DYRAysWrQ3x+SJcr1ON0QhpRu3rGc5apEIQ77419lQ=;
        b=TykbZrqjt+kt42P7aWqpZTo/tpO/jSAuwQ44NcFhkt+f7+hv838rDM/dLT6O3+oIR1R3ew
        cwrctcFu0MEAKdMCemqwpxYKpfEHftEH6SDeLmsW/A2nnuJaenToPUjNMjeSf8HQutJMIU
        7a4tNp4FlcPqAq5PKS8C8HRqa/SvWNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-RUEKsFC1Ni2HnHRPLkN7_w-1; Wed, 08 Apr 2020 08:10:09 -0400
X-MC-Unique: RUEKsFC1Ni2HnHRPLkN7_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4F41084426;
        Wed,  8 Apr 2020 12:10:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D3F89DD6B;
        Wed,  8 Apr 2020 12:10:08 +0000 (UTC)
Date:   Wed, 8 Apr 2020 08:10:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 17/20] xfs: Add helper function
 xfs_attr_node_removename_rmt
Message-ID: <20200408121006.GD33192@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-18-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-18-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:26PM -0700, Allison Collins wrote:
> This patch adds another new helper function
> xfs_attr_node_removename_rmt. This will also help modularize
> xfs_attr_node_removename when we add delay ready attributes later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 3c33dc5..d735570 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1221,6 +1221,28 @@ int xfs_attr_node_removename_setup(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_attr_node_removename_rmt (
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int			error = 0;
> +
> +	error = xfs_attr_rmtval_remove(args);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Refill the state structure with buffers, the prior calls
> +	 * released our buffers.
> +	 */

The comment can be widened to 80 chars now that indentation has been
reduced.

> +	error = xfs_attr_refillstate(state);
> +	if (error)
> +		return error;
> +
> +	return 0;

	return xfs_attr_refillstate(state);

With those nits fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +}
> +
>  /*
>   * Remove a name from a B-tree attribute list.
>   *
> @@ -1249,15 +1271,7 @@ xfs_attr_node_removename(
>  	 * overflow the maximum size of a transaction and/or hit a deadlock.
>  	 */
>  	if (args->rmtblkno > 0) {
> -		error = xfs_attr_rmtval_remove(args);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Refill the state structure with buffers, the prior calls
> -		 * released our buffers.
> -		 */
> -		error = xfs_attr_refillstate(state);
> +		error = xfs_attr_node_removename_rmt(args, state);
>  		if (error)
>  			goto out;
>  	}
> -- 
> 2.7.4
> 

