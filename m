Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D4FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DE5F64F70
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 13:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhBBNTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 08:19:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231220AbhBBNTw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 08:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612271905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1pjU10uRigMeOgmBaF0haJZINH9sDUk+AMaAUolbIrM=;
        b=UvN7SRpnoofy80JQ8HoN31kY4XYqkO2+0OT9l2uASDmbGa6jdmVhGKXLXijJdno/32QcB/
        eRYrhaMNwz9iRB96lMl28HNcrmmjjn8Tg4wBc1TfAWj2+64wzdidCArSJuC1hMGvr+59WH
        u7EPTcHVpLlrnaz2n17HKrV2oZ2BObE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-yu76t3WUOnCGi--1pnArzg-1; Tue, 02 Feb 2021 08:13:47 -0500
X-MC-Unique: yu76t3WUOnCGi--1pnArzg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF506196632C;
        Tue,  2 Feb 2021 13:13:44 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09EB75D9C6;
        Tue,  2 Feb 2021 13:13:43 +0000 (UTC)
Date:   Tue, 2 Feb 2021 08:13:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 15/16] xfs: rename code to error in xfs_ioctl_setattr
Message-ID: <20210202131337.GE3336100@bfoster>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
 <161223148300.491593.4733623201150889540.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161223148300.491593.4733623201150889540.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 01, 2021 at 06:04:43PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rename the 'code' variable to 'error' to follow the naming convention of
> most other functions in xfs.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c |   38 +++++++++++++++++++-------------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 78ee201eb7cb..38ee66d999d8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1435,13 +1435,13 @@ xfs_ioctl_setattr(
>  	struct xfs_trans	*tp;
>  	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_dquot	*olddquot = NULL;
> -	int			code;
> +	int			error;
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> -	code = xfs_ioctl_setattr_check_projid(ip, fa);
> -	if (code)
> -		return code;
> +	error = xfs_ioctl_setattr_check_projid(ip, fa);
> +	if (error)
> +		return error;
>  
>  	/*
>  	 * If disk quotas is on, we make sure that the dquots do exist on disk,
> @@ -1452,36 +1452,36 @@ xfs_ioctl_setattr(
>  	 * because the i_*dquot fields will get updated anyway.
>  	 */
>  	if (XFS_IS_QUOTA_ON(mp)) {
> -		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
> +		error = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
>  				VFS_I(ip)->i_gid, fa->fsx_projid,
>  				XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
> -		if (code)
> -			return code;
> +		if (error)
> +			return error;
>  	}
>  
>  	xfs_ioctl_setattr_prepare_dax(ip, fa);
>  
>  	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
>  	if (IS_ERR(tp)) {
> -		code = PTR_ERR(tp);
> +		error = PTR_ERR(tp);
>  		goto error_free_dquots;
>  	}
>  
>  	xfs_fill_fsxattr(ip, false, &old_fa);
> -	code = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
> -	if (code)
> +	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
> +	if (error)
>  		goto error_trans_cancel;
>  
> -	code = xfs_ioctl_setattr_check_extsize(ip, fa);
> -	if (code)
> +	error = xfs_ioctl_setattr_check_extsize(ip, fa);
> +	if (error)
>  		goto error_trans_cancel;
>  
> -	code = xfs_ioctl_setattr_check_cowextsize(ip, fa);
> -	if (code)
> +	error = xfs_ioctl_setattr_check_cowextsize(ip, fa);
> +	if (error)
>  		goto error_trans_cancel;
>  
> -	code = xfs_ioctl_setattr_xflags(tp, ip, fa);
> -	if (code)
> +	error = xfs_ioctl_setattr_xflags(tp, ip, fa);
> +	if (error)
>  		goto error_trans_cancel;
>  
>  	/*
> @@ -1521,7 +1521,7 @@ xfs_ioctl_setattr(
>  	else
>  		ip->i_d.di_cowextsize = 0;
>  
> -	code = xfs_trans_commit(tp);
> +	error = xfs_trans_commit(tp);
>  
>  	/*
>  	 * Release any dquot(s) the inode had kept before chown.
> @@ -1529,13 +1529,13 @@ xfs_ioctl_setattr(
>  	xfs_qm_dqrele(olddquot);
>  	xfs_qm_dqrele(pdqp);
>  
> -	return code;
> +	return error;
>  
>  error_trans_cancel:
>  	xfs_trans_cancel(tp);
>  error_free_dquots:
>  	xfs_qm_dqrele(pdqp);
> -	return code;
> +	return error;
>  }
>  
>  STATIC int
> 

