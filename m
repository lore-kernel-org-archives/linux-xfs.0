Return-Path: <SRS0=ttQi=5Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50914C2D0EA
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E90CD20747
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Apr 2020 12:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gZKSehyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgDHMJz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Apr 2020 08:09:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56596 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728040AbgDHMJz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Apr 2020 08:09:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586347794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iVznKEMRu6tKS86USWmQ0NBahJdhWNHWq52LLKpA2TQ=;
        b=gZKSehyOgcJwLT6MFqtQppTQzJfv1wPaq3uaIJ5jnBJZIb2cx5SKhvHRYdtWH18yV1CMYE
        CnU/zdGx1Sq6J7Y136ViI+CUVhn3Os8E/yNDdw+nTIa4tNYoFRj8qSzQhiNZpXxYtSCBzu
        fozWo3RYf+Rs3F47B5FNxtVmbw7x+AU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-MWuff7OnNou0IwgGM0xjYA-1; Wed, 08 Apr 2020 08:09:52 -0400
X-MC-Unique: MWuff7OnNou0IwgGM0xjYA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 493111005509;
        Wed,  8 Apr 2020 12:09:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAFB360BF7;
        Wed,  8 Apr 2020 12:09:50 +0000 (UTC)
Date:   Wed, 8 Apr 2020 08:09:48 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 15/20] xfs: Add remote block helper functions
Message-ID: <20200408120948.GB33192@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-16-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:24PM -0700, Allison Collins wrote:
> This patch adds two new helper functions xfs_attr_store_rmt_blk and
> xfs_attr_restore_rmt_blk. These two helpers assist to remove redundant
> code associated with storing and retrieving remote blocks during the
> attr set operations.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 50 +++++++++++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 8d7a5db..f70b4f2 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -565,6 +565,30 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   * External routines when attribute list is one block
>   *========================================================================*/
>  
> +/* Store info about a remote block */
> +STATIC void
> +xfs_attr_save_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno2 = args->blkno;
> +	args->index2 = args->index;
> +	args->rmtblkno2 = args->rmtblkno;
> +	args->rmtblkcnt2 = args->rmtblkcnt;
> +	args->rmtvaluelen2 = args->rmtvaluelen;
> +}
> +
> +/* Set stored info about a remote block */
> +STATIC void
> +xfs_attr_restore_rmt_blk(
> +	struct xfs_da_args	*args)
> +{
> +	args->blkno = args->blkno2;
> +	args->index = args->index2;
> +	args->rmtblkno = args->rmtblkno2;
> +	args->rmtblkcnt = args->rmtblkcnt2;
> +	args->rmtvaluelen = args->rmtvaluelen2;
> +}
> +
>  /*
>   * Tries to add an attribute to an inode in leaf form
>   *
> @@ -599,11 +623,7 @@ xfs_attr_leaf_try_add(
>  
>  		/* save the attribute state for later removal*/
>  		args->op_flags |= XFS_DA_OP_RENAME;	/* an atomic rename */
> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
> -		args->index2 = args->index;
> -		args->rmtblkno2 = args->rmtblkno;
> -		args->rmtblkcnt2 = args->rmtblkcnt;
> -		args->rmtvaluelen2 = args->rmtvaluelen;
> +		xfs_attr_save_rmt_blk(args);
>  
>  		/*
>  		 * clear the remote attr state now that it is saved so that the
> @@ -702,11 +722,8 @@ xfs_attr_leaf_addname(
>  		 * Dismantle the "old" attribute/value pair by removing
>  		 * a "remote" value (if it exists).
>  		 */
> -		args->index = args->index2;
> -		args->blkno = args->blkno2;
> -		args->rmtblkno = args->rmtblkno2;
> -		args->rmtblkcnt = args->rmtblkcnt2;
> -		args->rmtvaluelen = args->rmtvaluelen2;
> +		xfs_attr_restore_rmt_blk(args);
> +
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
> @@ -934,11 +951,7 @@ xfs_attr_node_addname(
>  
>  		/* save the attribute state for later removal*/
>  		args->op_flags |= XFS_DA_OP_RENAME;	/* atomic rename op */
> -		args->blkno2 = args->blkno;		/* set 2nd entry info*/
> -		args->index2 = args->index;
> -		args->rmtblkno2 = args->rmtblkno;
> -		args->rmtblkcnt2 = args->rmtblkcnt;
> -		args->rmtvaluelen2 = args->rmtvaluelen;
> +		xfs_attr_save_rmt_blk(args);
>  
>  		/*
>  		 * clear the remote attr state now that it is saved so that the
> @@ -1050,11 +1063,8 @@ xfs_attr_node_addname(
>  		 * Dismantle the "old" attribute/value pair by removing
>  		 * a "remote" value (if it exists).
>  		 */
> -		args->index = args->index2;
> -		args->blkno = args->blkno2;
> -		args->rmtblkno = args->rmtblkno2;
> -		args->rmtblkcnt = args->rmtblkcnt2;
> -		args->rmtvaluelen = args->rmtvaluelen2;
> +		xfs_attr_restore_rmt_blk(args);
> +
>  		if (args->rmtblkno) {
>  			error = xfs_attr_rmtval_remove(args);
>  			if (error)
> -- 
> 2.7.4
> 

