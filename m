Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05735C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7DEE64E56
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhBBTjr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:39:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233576AbhBBTj0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:39:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612294680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PLhH3UO/C9sVU+Gk6ErHSHU1/zgxhDPylJpuUvFxKts=;
        b=JUmOOA80eDSsd9/aPb4LhCFlxUBQk0HFrgiIutblwvrAPue8+wMxE9yxsZ+4wQ1JQT0IT1
        mH0/qZ4zDztDkWYcZaDYKvz4rFfKvUVRmNx8PaI4RCZFWvvhfCjAJGX25K5iblrf6yxymO
        dUbbwTSIPrzV+1vw3tAdR7N7FhGy2v0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-_0zSGNpeNl-xOTr7A3GHrw-1; Tue, 02 Feb 2021 14:37:58 -0500
X-MC-Unique: _0zSGNpeNl-xOTr7A3GHrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39D43134C44;
        Tue,  2 Feb 2021 19:37:57 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A266B1F0;
        Tue,  2 Feb 2021 19:37:50 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:37:48 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v6 2/7] xfs: get rid of xfs_growfs_{data,log}_t
Message-ID: <20210202193748.GM3336100@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126125621.3846735-3-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:56:16PM +0800, Gao Xiang wrote:
> Such usage isn't encouraged by the kernel coding style. Leave the
> definitions alone in case of userspace users.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c | 12 ++++++------
>  fs/xfs/xfs_fsops.h |  4 ++--
>  fs/xfs/xfs_ioctl.c |  4 ++--
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 62600d78bbf1..a2a407039227 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -25,8 +25,8 @@
>   */
>  static int
>  xfs_growfs_data_private(
> -	xfs_mount_t		*mp,		/* mount point for filesystem */
> -	xfs_growfs_data_t	*in)		/* growfs data input struct */
> +	struct xfs_mount	*mp,		/* mount point for filesystem */
> +	struct xfs_growfs_data	*in)		/* growfs data input struct */
>  {
>  	struct xfs_buf		*bp;
>  	int			error;
> @@ -35,7 +35,7 @@ xfs_growfs_data_private(
>  	xfs_rfsblock_t		nb, nb_div, nb_mod;
>  	xfs_rfsblock_t		delta;
>  	xfs_agnumber_t		oagcount;
> -	xfs_trans_t		*tp;
> +	struct xfs_trans	*tp;
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> @@ -170,8 +170,8 @@ xfs_growfs_data_private(
>  
>  static int
>  xfs_growfs_log_private(
> -	xfs_mount_t		*mp,	/* mount point for filesystem */
> -	xfs_growfs_log_t	*in)	/* growfs log input struct */
> +	struct xfs_mount	*mp,	/* mount point for filesystem */
> +	struct xfs_growfs_log	*in)	/* growfs log input struct */
>  {
>  	xfs_extlen_t		nb;
>  
> @@ -268,7 +268,7 @@ xfs_growfs_data(
>  int
>  xfs_growfs_log(
>  	xfs_mount_t		*mp,
> -	xfs_growfs_log_t	*in)
> +	struct xfs_growfs_log	*in)
>  {
>  	int error;
>  
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 92869f6ec8d3..2cffe51a31e8 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -6,8 +6,8 @@
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
>  
> -extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
> -extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
> +extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
> +extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
>  extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
>  extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
>  				xfs_fsop_resblks_t *outval);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3fbd98f61ea5..a62520f49ec5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -2260,7 +2260,7 @@ xfs_file_ioctl(
>  	}
>  
>  	case XFS_IOC_FSGROWFSDATA: {
> -		xfs_growfs_data_t in;
> +		struct xfs_growfs_data in;
>  
>  		if (copy_from_user(&in, arg, sizeof(in)))
>  			return -EFAULT;
> @@ -2274,7 +2274,7 @@ xfs_file_ioctl(
>  	}
>  
>  	case XFS_IOC_FSGROWFSLOG: {
> -		xfs_growfs_log_t in;
> +		struct xfs_growfs_log in;
>  
>  		if (copy_from_user(&in, arg, sizeof(in)))
>  			return -EFAULT;
> -- 
> 2.27.0
> 

