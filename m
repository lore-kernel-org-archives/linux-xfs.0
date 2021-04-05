Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDF32C433ED
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA8160FDB
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 16:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242404AbhDEQeH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 12:34:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242403AbhDEQeH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 12:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8CSpSYkZW0eQfVwhnBhysLvn43b+jYEKWO94AiTcPEE=;
        b=YlpRoFulHA6pnnTZa+KiiZrGTH1Ylwvvcgdlmc6zOK4dCvGvzkWcQW7aZtmLMYVNm8YO1A
        lMYTS1tvMUdT3jpkYAybbEWp13M5R9ScnEaimMt8O98r86fZFTzeCmuh2KGYbIDtd5Vuh8
        wVkQ5ftkvMbjE8G69bCPkbvA+P4LuTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-bfpMiImwPGOJjV0ygVttCg-1; Mon, 05 Apr 2021 12:33:54 -0400
X-MC-Unique: bfpMiImwPGOJjV0ygVttCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 052F7190A7A0;
        Mon,  5 Apr 2021 16:33:54 +0000 (UTC)
Received: from bfoster (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E8B75C257;
        Mon,  5 Apr 2021 16:33:53 +0000 (UTC)
Date:   Mon, 5 Apr 2021 12:33:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: simplify xfs_attr_remove_args
Message-ID: <YGs7717L9ySazvAB@bfoster>
References: <20210402142409.372050-1-hch@lst.de>
 <20210402142409.372050-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402142409.372050-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 02, 2021 at 04:24:05PM +0200, Christoph Hellwig wrote:
> Directly return from the subfunctions and avoid the error variable.  Also
> remove the not really needed dp local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 0146f70b71b1e2..6d1854d506d5ad 100644
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

