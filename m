Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E7EC47247
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A962078C
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 13:11:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vyn+APfA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEENLy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 May 2020 09:11:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728512AbgEENLy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 May 2020 09:11:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588684312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iCVhpe4PUQlDMp522ecCv5GJXgarbbG8Sz/NaiTsiac=;
        b=Vyn+APfAk47kd5MvVRddSz3q+Y/ROUiD13q8poeeViWtP9nJfRxwLXqvSYtW36SuAUYwHF
        8WlsECDDyGItQ4Os40btrl1iWjy6hI0vfJe6jBY5ZB7tVIMhmDLrOoRXrGsgTvJqFrBz/o
        8u+vQOcS5e74M6PQCEn8uML3nmVB1tM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-ZQFlxuvaNKmixFhDy_BceQ-1; Tue, 05 May 2020 09:11:50 -0400
X-MC-Unique: ZQFlxuvaNKmixFhDy_BceQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8525A100CCC3;
        Tue,  5 May 2020 13:11:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 154D560621;
        Tue,  5 May 2020 13:11:48 +0000 (UTC)
Date:   Tue, 5 May 2020 09:11:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 19/24] xfs: Simplify xfs_attr_leaf_addname
Message-ID: <20200505131147.GC60048@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-20-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-20-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:11PM -0700, Allison Collins wrote:
> Quick patch to unnest the rename logic in the leaf code path.  This will
> help simplify delayed attr logic later.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---

With Darrick's cleanups:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 108 +++++++++++++++++++++++------------------------
>  1 file changed, 53 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ab1c9fa..1810f90 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -694,73 +694,71 @@ xfs_attr_leaf_addname(
>  			return error;
>  	}
>  
> -	/*
> -	 * If this is an atomic rename operation, we must "flip" the
> -	 * incomplete flags on the "new" and "old" attribute/value pairs
> -	 * so that one disappears and one appears atomically.  Then we
> -	 * must remove the "old" attribute/value pair.
> -	 */
> -	if (args->op_flags & XFS_DA_OP_RENAME) {
> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
>  		/*
> -		 * In a separate transaction, set the incomplete flag on the
> -		 * "old" attr and clear the incomplete flag on the "new" attr.
> -		 */
> -		error = xfs_attr3_leaf_flipflags(args);
> -		if (error)
> -			return error;
> -		/*
> -		 * Commit the flag value change and start the next trans in
> -		 * series.
> +		 * Added a "remote" value, just clear the incomplete flag.
>  		 */
> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
> -		if (error)
> -			return error;
> +		if (args->rmtblkno > 0)
> +			error = xfs_attr3_leaf_clearflag(args);
>  
> -		/*
> -		 * Dismantle the "old" attribute/value pair by removing
> -		 * a "remote" value (if it exists).
> -		 */
> -		xfs_attr_restore_rmt_blk(args);
> +		return error;
> +	}
>  
> -		if (args->rmtblkno) {
> -			error = xfs_attr_rmtval_invalidate(args);
> -			if (error)
> -				return error;
> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the incomplete
> +	 * flags on the "new" and "old" attribute/value pairs so that one
> +	 * disappears and one appears atomically.  Then we must remove the "old"
> +	 * attribute/value pair.
> +	 *
> +	 * In a separate transaction, set the incomplete flag on the "old" attr
> +	 * and clear the incomplete flag on the "new" attr.
> +	 */
>  
> -			error = xfs_attr_rmtval_remove(args);
> -			if (error)
> -				return error;
> -		}
> +	error = xfs_attr3_leaf_flipflags(args);
> +	if (error)
> +		return error;
> +	/*
> +	 * Commit the flag value change and start the next trans in series.
> +	 */
> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
> +	if (error)
> +		return error;
>  
> -		/*
> -		 * Read in the block containing the "old" attr, then
> -		 * remove the "old" attr from that block (neat, huh!)
> -		 */
> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> -					   &bp);
> +	/*
> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
> +	 * (if it exists).
> +	 */
> +	xfs_attr_restore_rmt_blk(args);
> +
> +	if (args->rmtblkno) {
> +		error = xfs_attr_rmtval_invalidate(args);
>  		if (error)
>  			return error;
>  
> -		xfs_attr3_leaf_remove(bp, args);
> -
> -		/*
> -		 * If the result is small enough, shrink it all into the inode.
> -		 */
> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> -			/* bp is gone due to xfs_da_shrink_inode */
> -			if (error)
> -				return error;
> -		}
> -
> -	} else if (args->rmtblkno > 0) {
> -		/*
> -		 * Added a "remote" value, just clear the incomplete flag.
> -		 */
> -		error = xfs_attr3_leaf_clearflag(args);
> +		error = xfs_attr_rmtval_remove(args);
>  		if (error)
>  			return error;
>  	}
> +
> +	/*
> +	 * Read in the block containing the "old" attr, then remove the "old"
> +	 * attr from that block (neat, huh!)
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
> +				   &bp);
> +	if (error)
> +		return error;
> +
> +	xfs_attr3_leaf_remove(bp, args);
> +
> +	/*
> +	 * If the result is small enough, shrink it all into the inode.
> +	 */
> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
> +	if (forkoff)
> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
> +		/* bp is gone due to xfs_da_shrink_inode */
> +
>  	return error;
>  }
>  
> -- 
> 2.7.4
> 

