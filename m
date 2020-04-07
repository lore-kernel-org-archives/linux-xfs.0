Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DC9C2BA80
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2D12076E
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 15:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dInmZROm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgDGPXR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 11:23:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36366 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728306AbgDGPXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 11:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586272995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d2hvuKkcTjGoR2+kFTtXD67Qvh1L/taohs1LHZsd+4E=;
        b=dInmZROmU8lwMg1mdK/wtQPbZ/h6LBuVG/WlicaKTzhIgE41L8BV7aBzTRn+87dhQaGbyd
        9PmEuQc4GGBWun80ICxajlAqEHRmQydFRVSFHPffbJM02pkpdDzJPB5GWmSbpXwugsuQs9
        /lEO5rPblePYI98wf2gf6pmkkWr8mjk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-GWC7xLggP7SUU8JrLypXdw-1; Tue, 07 Apr 2020 11:23:13 -0400
X-MC-Unique: GWC7xLggP7SUU8JrLypXdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE3D28017CE;
        Tue,  7 Apr 2020 15:23:12 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 639BE5C1A2;
        Tue,  7 Apr 2020 15:23:12 +0000 (UTC)
Date:   Tue, 7 Apr 2020 11:23:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 14/20] xfs: Add helper function
 xfs_attr_leaf_mark_incomplete
Message-ID: <20200407152310.GF28936@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-15-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-15-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:23PM -0700, Allison Collins wrote:
> This patch helps to simplify xfs_attr_node_removename by modularizing
> the code around the transactions into helper functions.  This will make
> the function easier to follow when we introduce delayed attributes.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 45 +++++++++++++++++++++++++++++++--------------
>  1 file changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ba26ffe..8d7a5db 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1153,6 +1153,36 @@ xfs_attr_node_shrink(
>  }
>  
>  /*
> + * Mark an attribute entry INCOMPLETE and save pointers to the relevant buffers
> + * for later deletion of the entry.
> + */
> +STATIC int
> +xfs_attr_leaf_mark_incomplete(
> +	struct xfs_da_args	*args,
> +	struct xfs_da_state	*state)
> +{
> +	int error;

	int			error;

> +
> +	/*
> +	 * Fill in disk block numbers in the state structure
> +	 * so that we can get the buffers back after we commit
> +	 * several transactions in the following calls.
> +	 */
> +	error = xfs_attr_fillstate(state);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Mark the attribute as INCOMPLETE
> +	 */
> +	error = xfs_attr3_leaf_setflag(args);
> +	if (error)
> +		return error;
> +
> +	return 0;

	return xfs_attr3_leaf_setflag(args);

Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +}
> +
> +/*
>   * Remove a name from a B-tree attribute list.
>   *
>   * This will involve walking down the Btree, and may involve joining
> @@ -1183,20 +1213,7 @@ xfs_attr_node_removename(
>  	ASSERT(blk->bp != NULL);
>  	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
>  	if (args->rmtblkno > 0) {
> -		/*
> -		 * Fill in disk block numbers in the state structure
> -		 * so that we can get the buffers back after we commit
> -		 * several transactions in the following calls.
> -		 */
> -		error = xfs_attr_fillstate(state);
> -		if (error)
> -			goto out;
> -
> -		/*
> -		 * Mark the attribute as INCOMPLETE, then bunmapi() the
> -		 * remote value.
> -		 */
> -		error = xfs_attr3_leaf_setflag(args);
> +		error = xfs_attr_leaf_mark_incomplete(args, state);
>  		if (error)
>  			goto out;
>  
> -- 
> 2.7.4
> 

