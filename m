Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D3CC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A42121744
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:27:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ELPLzahF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgBYQ15 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:27:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52336 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728981AbgBYQ15 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:27:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582648076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cru8vgyG8Om+e0+hvXj5xzllYUmcYBPAs1sJ9pNKFXc=;
        b=ELPLzahF23elOuMi5vT5T2elWNPGJpo5m3IqAGAUqQnzKb06VoAmxa9FnO8e2u/GvbCvXh
        V5JMGZnWgairdrjEX9619WK15ST0F1UuG0Mk9txEfEzlqVkMeOc4VDgDP33EsK4v18M4RS
        7o9eY+y67S/UI2jm6gIpdmXEL6DQSts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-MvGBcKWTO9O_MpfksGdMNQ-1; Tue, 25 Feb 2020 11:27:53 -0500
X-MC-Unique: MvGBcKWTO9O_MpfksGdMNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75E818A6EC8;
        Tue, 25 Feb 2020 16:27:51 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EAF1C8C073;
        Tue, 25 Feb 2020 16:27:50 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:27:49 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 5/7] xfs: xfs_attr_calc_size: Explicitly pass
 mp, namelen and valuelen args
Message-ID: <20200225162749.GE54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-6-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:42AM +0530, Chandan Rajendra wrote:
> In a future commit, xfs_attr_calc_size() will be invoked from a function that
> does not have a 'struct xfs_da_args' handy. Hence this commit changes
> xfs_attr_calc_size() to let invokers to explicitly pass 'struct xfs_mount *',
> namelen and valuelen arguments.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 921acac71e5d9..f781724bf85ce 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -138,22 +138,24 @@ xfs_attr_get(
>   */
>  STATIC void
>  xfs_attr_calc_size(
> -	struct xfs_da_args		*args,
> +	struct xfs_mount		*mp,
>  	struct xfs_attr_set_resv	*resv,
> +	int				namelen,
> +	int				valuelen,
>  	int				*local)
>  {
> -	struct xfs_mount		*mp = args->dp->i_mount;
> +	unsigned int			blksize = mp->m_attr_geo->blksize;
>  	int				size;
>  
>  	/*
>  	 * Determine space new attribute will use, and if it would be
>  	 * "local" or "remote" (note: local != inline).
>  	 */
> -	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
> -			args->valuelen, local);
> +	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
> +			local);
>  	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
>  	if (*local) {
> -		if (size > (args->geo->blksize / 2)) {
> +		if (size > (blksize / 2)) {
>  			/* Double split possible */
>  			resv->total_dablks *= 2;
>  		}
> @@ -163,7 +165,7 @@ xfs_attr_calc_size(
>  		 * Out of line attribute, cannot double split, but
>  		 * make room for the attribute value itself.
>  		 */
> -		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> +		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
>  	}
>  
>  	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
> @@ -329,7 +331,8 @@ xfs_attr_set(
>  		XFS_STATS_INC(mp, xs_attr_set);
>  
>  		args->op_flags |= XFS_DA_OP_ADDNAME;
> -		xfs_attr_calc_size(args, &resv, &local);
> +		xfs_attr_calc_size(mp, &resv, args->namelen, args->valuelen,
> +				&local);
>  		args->total = resv.alloc_blks;
>  
>  		/*
> -- 
> 2.19.1
> 

