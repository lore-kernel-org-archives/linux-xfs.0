Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B75BC2BA19
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B5B821835
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:13:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TmoR1JMB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgDFMNj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:13:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39244 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727614AbgDFMNj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586175218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DJ53rkkpBsiHkNgetrPgHqXD0RyzmaalUBPi56hZEfA=;
        b=TmoR1JMB23SEJAn5cssVlCkv7vJmpp8lRVZl1AZqQAUAOl0PHuvd/1xcL++uz/YJ2XRZmm
        SQ9xv4bAb4NETUF6L5u+Ar6/AhmWdVHPSkTALL7gGJjs+SW84BqSuC7+LuAmLuOUgHdVGo
        XWr/KcOrKLZ9AiP+DhF5/u8YT+051D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-Xj0ONiCxN9CCsHM5ukPkOg-1; Mon, 06 Apr 2020 08:13:35 -0400
X-MC-Unique: Xj0ONiCxN9CCsHM5ukPkOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5F4E8017F5;
        Mon,  6 Apr 2020 12:13:34 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C4E9A63B5;
        Mon,  6 Apr 2020 12:13:34 +0000 (UTC)
Date:   Mon, 6 Apr 2020 08:13:32 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: factor out a new xfs_log_force_inode helper
Message-ID: <20200406121332.GA20207@bfoster>
References: <20200403125522.450299-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403125522.450299-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 03, 2020 at 02:55:21PM +0200, Christoph Hellwig wrote:
> Create a new helper to force the log up to the last LSN touching an
> inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_export.c | 14 +-------------
>  fs/xfs/xfs_file.c   | 12 +-----------
>  fs/xfs/xfs_inode.c  | 19 +++++++++++++++++++
>  fs/xfs/xfs_inode.h  |  1 +
>  4 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
> index f1372f9046e3..5a4b0119143a 100644
> --- a/fs/xfs/xfs_export.c
> +++ b/fs/xfs/xfs_export.c
> @@ -15,7 +15,6 @@
>  #include "xfs_trans.h"
>  #include "xfs_inode_item.h"
>  #include "xfs_icache.h"
> -#include "xfs_log.h"
>  #include "xfs_pnfs.h"
>  
>  /*
> @@ -221,18 +220,7 @@ STATIC int
>  xfs_fs_nfs_commit_metadata(
>  	struct inode		*inode)
>  {
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_lsn_t		lsn = 0;
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	if (!lsn)
> -		return 0;
> -	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> +	return xfs_log_force_inode(XFS_I(inode));
>  }
>  
>  const struct export_operations xfs_export_operations = {
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index b8a4a3f29b36..68e1cbb3cfcc 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -80,19 +80,9 @@ xfs_dir_fsync(
>  	int			datasync)
>  {
>  	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
> -	struct xfs_mount	*mp = ip->i_mount;
> -	xfs_lsn_t		lsn = 0;
>  
>  	trace_xfs_dir_fsync(ip);
> -
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip))
> -		lsn = ip->i_itemp->ili_last_lsn;
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> -
> -	if (!lsn)
> -		return 0;
> -	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
> +	return xfs_log_force_inode(ip);
>  }
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c5077e6326c7..e48fc835cb85 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3951,3 +3951,22 @@ xfs_irele(
>  	trace_xfs_irele(ip, _RET_IP_);
>  	iput(VFS_I(ip));
>  }
> +
> +/*
> + * Ensure all commited transactions touching the inode are written to the log.
> + */
> +int
> +xfs_log_force_inode(
> +	struct xfs_inode	*ip)
> +{
> +	xfs_lsn_t		lsn = 0;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	if (xfs_ipincount(ip))
> +		lsn = ip->i_itemp->ili_last_lsn;
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +
> +	if (!lsn)
> +		return 0;
> +	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
> +}
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 492e53992fa9..c6a63f6764a6 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -426,6 +426,7 @@ int		xfs_itruncate_extents_flags(struct xfs_trans **,
>  				struct xfs_inode *, int, xfs_fsize_t, int);
>  void		xfs_iext_realloc(xfs_inode_t *, int, int);
>  
> +int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
> -- 
> 2.25.1
> 

