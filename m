Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0460DC47254
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7DE320836
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:12:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBkQ7NaO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgEENMt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:12:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27476 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728512AbgEENMt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:12:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588684368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xm1KmG3zmVlj9bZ+qtfqdWhkLL8eiUcF/6nT+YszK1g=;
        b=eBkQ7NaOyuuHcDqDFRy3H6k+inbVfJNs82efTItPvOzuo1dVmvmZnzmlUHv18xl0hHdWvD
        goD6rVSEljG20msMbIzU4zbEJrg141tjPPzXgehpZs6LqsV1JfXmP4oXlrs7wUMTNIkh0B
        vFiQnDV2qDY9lzkDwEs3/6cGc580XWo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-sHiGol0TPSGRa2K_rZD5CQ-1; Tue, 05 May 2020 09:12:46 -0400
X-MC-Unique: sHiGol0TPSGRa2K_rZD5CQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC6C5461;
        Tue,  5 May 2020 13:12:45 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D4476292F;
        Tue,  5 May 2020 13:12:45 +0000 (UTC)
Date:   Tue, 5 May 2020 09:12:43 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 21/24] xfs: Lift -ENOSPC handler from
 xfs_attr_leaf_addname
Message-ID: <20200505131243.GE60048@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-22-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-22-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:13PM -0700, Allison Collins wrote:
> Lift -ENOSPC handler from xfs_attr_leaf_addname.  This will help to
> reorganize transitions between the attr forms later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 9171895..c8cae68 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -299,6 +299,13 @@ xfs_attr_set_args(
>  			return error;
>  
>  		/*
> +		 * Promote the attribute list to the Btree format.
> +		 */
> +		error = xfs_attr3_leaf_to_node(args);
> +		if (error)
> +			return error;
> +
> +		/*
>  		 * Commit that transaction so that the node_addname()
>  		 * call can manage its own transactions.
>  		 */
> @@ -602,7 +609,7 @@ xfs_attr_leaf_try_add(
>  	struct xfs_da_args	*args,
>  	struct xfs_buf		*bp)
>  {
> -	int			retval, error;
> +	int			retval;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -634,20 +641,10 @@ xfs_attr_leaf_try_add(
>  	}
>  
>  	/*
> -	 * Add the attribute to the leaf block, transitioning to a Btree
> -	 * if required.
> +	 * Add the attribute to the leaf block
>  	 */
> -	retval = xfs_attr3_leaf_add(bp, args);
> -	if (retval == -ENOSPC) {
> -		/*
> -		 * Promote the attribute list to the Btree format. Unless an
> -		 * error occurs, retain the -ENOSPC retval
> -		 */
> -		error = xfs_attr3_leaf_to_node(args);
> -		if (error)
> -			return error;
> -	}
> -	return retval;
> +	return xfs_attr3_leaf_add(bp, args);
> +
>  out_brelse:
>  	xfs_trans_brelse(args->trans, bp);
>  	return retval;
> -- 
> 2.7.4
> 

