Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72718C2BA2B
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 457CB2078A
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 14:16:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ekuHX0Fg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgDGOQu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 10:16:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728768AbgDGOQu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 10:16:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586269009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dkvRdPhrHEKt4bCN7ReLfPVthJ+Hc8PjX9YNEwN1ITE=;
        b=ekuHX0FgtgcCIbXd/CO0gg1lQFtkgyiJAZGFMLtG7p36yMoBA7S4v/eidbrZm8lJNoqbmz
        DWDMbsiIUOFhQz4zy13xBB+fq/LIXJNpkd0Of0ez4m5hn2BTQj111Q0WZMCoCsBuXWNPXR
        OYQODS6TQ33VWqwek+dTFdxJ+bxfMkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-jmoSN1JSPSeXYzlKoYDGEw-1; Tue, 07 Apr 2020 10:16:47 -0400
X-MC-Unique: jmoSN1JSPSeXYzlKoYDGEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0906F800D50;
        Tue,  7 Apr 2020 14:16:46 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B10501001925;
        Tue,  7 Apr 2020 14:16:45 +0000 (UTC)
Date:   Tue, 7 Apr 2020 10:16:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v8 10/20] xfs: Add helper function
 __xfs_attr_rmtval_remove
Message-ID: <20200407141644.GA28936@bfoster>
References: <20200403221229.4995-1-allison.henderson@oracle.com>
 <20200403221229.4995-11-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403221229.4995-11-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 03:12:19PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to
> return EAGAIN for new transactions. We will use this later when we
> introduce delayed attributes.  This function will eventually replace
> xfs_attr_rmtval_remove
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 25 +++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 26 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 4d51969..fd4be9d 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -711,3 +711,28 @@ xfs_attr_rmtval_remove(
>  	}
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
> +	int	error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return 0;
> +}

We should let xfs_attr_rmtval_remove() call this function and do the
roll based on -EAGAIN, then eliminate the higher level function later if
it becomes unused.

Brian

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

