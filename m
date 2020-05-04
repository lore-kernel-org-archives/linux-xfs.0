Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052B7C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D48B22073E
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 13:27:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DXbQv9zi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgEDN13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 09:27:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51619 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727104AbgEDN13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 09:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588598847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bia+OX91HIpcrvT6r70f/sPVEoR9Mp4lkGT130dj0Bo=;
        b=DXbQv9ziOoY4CQYMRoM4K3lcCvw0LdPVORym2S9joDPlUtDzELwT3RErAkC50YHeOgdeox
        OvGmjNEpChzVbgC1ezXg2hlM/caFyoO+laxvjfNLfyOGadf8KTLWJpUsB/AchWO9vV8+pJ
        BlBsfD68B6IDl5DXs/LUOVMObACa5iM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-rDH5t7i2PoWSJJ_geHtJug-1; Mon, 04 May 2020 09:27:26 -0400
X-MC-Unique: rDH5t7i2PoWSJJ_geHtJug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0599818A072E;
        Mon,  4 May 2020 13:27:25 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F07D100238A;
        Mon,  4 May 2020 13:27:24 +0000 (UTC)
Date:   Mon, 4 May 2020 09:27:22 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v9 10/24] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200504132722.GA54625@bfoster>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430225016.4287-11-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 30, 2020 at 03:50:02PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to
> return EAGAIN for new transactions. We will use this later when we
> introduce delayed attributes.  This function will eventually replace
> xfs_attr_rmtval_remove
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---

Looks like the commit log needs some rewording now that this is a
refactor patch. With that fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 37 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4d51969..02d1a44 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
>  	xfs_dablk_t		lblkno;
>  	int			blkcnt;
>  	int			error = 0;
> -	int			done = 0;
> +	int			retval = 0;
>  
>  	trace_xfs_attr_rmtval_remove(args);
>  
> @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
>  	 */
>  	lblkno = args->rmtblkno;
>  	blkcnt = args->rmtblkcnt;
> -	while (!done) {
> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
> -				    XFS_BMAPI_ATTRFORK, 1, &done);
> -		if (error)
> -			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	do {
> +		retval = __xfs_attr_rmtval_remove(args);
> +		if (retval && retval != EAGAIN)
> +			return retval;
>  
>  		/*
>  		 * Close out trans and start the next one in the chain.
> @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
>  		error = xfs_trans_roll_inode(&args->trans, args->dp);
>  		if (error)
>  			return error;
> -	}
> +	} while (retval == -EAGAIN);
> +
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function
> + */
> +int
> +__xfs_attr_rmtval_remove(
> +	struct xfs_da_args	*args)
> +{
> +	int			error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	error = xfs_defer_finish(&args->trans);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return error;
> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index eff5f95..ee3337b 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 

