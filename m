Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05857C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1E7323132
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 15:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387648AbhALPfU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:35:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390169AbhALPfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 10:35:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610465632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d+8am/m3tezG92qp7H/Fxn99xKqSmRQsQyWg2ExJTpc=;
        b=KBcaWRBCLf/SkI1eySY55TXjktotpZ4tCL4prcVqIWekYe6SBxeEUhRUGFMcSR4bSXLHqK
        Pc3i3E+Ouh+1bB/SY3QXufhdIpHAWKndZMdnwipVS+Cx9g1ugPc8/LLd08oXdItaN1SQzf
        gzEfxKPNNDRL2LSHLEQ+8YFvqBLN91I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-yNZgbp2vPrGpxqczeEcHNQ-1; Tue, 12 Jan 2021 10:33:51 -0500
X-MC-Unique: yNZgbp2vPrGpxqczeEcHNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C3A9180E461;
        Tue, 12 Jan 2021 15:33:50 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 996C01F0;
        Tue, 12 Jan 2021 15:33:49 +0000 (UTC)
Date:   Tue, 12 Jan 2021 10:33:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: refactor xfs_file_fsync
Message-ID: <20210112153347.GB1137163@bfoster>
References: <20210111161544.1414409-1-hch@lst.de>
 <20210111161544.1414409-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111161544.1414409-2-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:15:43PM +0100, Christoph Hellwig wrote:
> Factor out the log syncing logic into two helpers to make the code easier
> to read and more maintainable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks fine, though it might be nice to find some commonality with
xfs_log_force_inode():

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 81 +++++++++++++++++++++++++++++------------------
>  1 file changed, 50 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 5b0f93f738372d..414d856e2e755a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -118,6 +118,54 @@ xfs_dir_fsync(
>  	return xfs_log_force_inode(ip);
>  }
>  
> +static xfs_lsn_t
> +xfs_fsync_lsn(
> +	struct xfs_inode	*ip,
> +	bool			datasync)
> +{
> +	if (!xfs_ipincount(ip))
> +		return 0;
> +	if (datasync && !(ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> +		return 0;
> +	return ip->i_itemp->ili_last_lsn;
> +}
> +
> +/*
> + * All metadata updates are logged, which means that we just have to flush the
> + * log up to the latest LSN that touched the inode.
> + *
> + * If we have concurrent fsync/fdatasync() calls, we need them to all block on
> + * the log force before we clear the ili_fsync_fields field. This ensures that
> + * we don't get a racing sync operation that does not wait for the metadata to
> + * hit the journal before returning.  If we race with clearing ili_fsync_fields,
> + * then all that will happen is the log force will do nothing as the lsn will
> + * already be on disk.  We can't race with setting ili_fsync_fields because that
> + * is done under XFS_ILOCK_EXCL, and that can't happen because we hold the lock
> + * shared until after the ili_fsync_fields is cleared.
> + */
> +static  int
> +xfs_fsync_flush_log(
> +	struct xfs_inode	*ip,
> +	bool			datasync,
> +	int			*log_flushed)
> +{
> +	int			error = 0;
> +	xfs_lsn_t		lsn;
> +
> +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> +	lsn = xfs_fsync_lsn(ip, datasync);
> +	if (lsn) {
> +		error = xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC,
> +					  log_flushed);
> +
> +		spin_lock(&ip->i_itemp->ili_lock);
> +		ip->i_itemp->ili_fsync_fields = 0;
> +		spin_unlock(&ip->i_itemp->ili_lock);
> +	}
> +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	return error;
> +}
> +
>  STATIC int
>  xfs_file_fsync(
>  	struct file		*file,
> @@ -125,13 +173,10 @@ xfs_file_fsync(
>  	loff_t			end,
>  	int			datasync)
>  {
> -	struct inode		*inode = file->f_mapping->host;
> -	struct xfs_inode	*ip = XFS_I(inode);
> -	struct xfs_inode_log_item *iip = ip->i_itemp;
> +	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = 0;
>  	int			log_flushed = 0;
> -	xfs_lsn_t		lsn = 0;
>  
>  	trace_xfs_file_fsync(ip);
>  
> @@ -155,33 +200,7 @@ xfs_file_fsync(
>  	else if (mp->m_logdev_targp != mp->m_ddev_targp)
>  		xfs_blkdev_issue_flush(mp->m_ddev_targp);
>  
> -	/*
> -	 * All metadata updates are logged, which means that we just have to
> -	 * flush the log up to the latest LSN that touched the inode. If we have
> -	 * concurrent fsync/fdatasync() calls, we need them to all block on the
> -	 * log force before we clear the ili_fsync_fields field. This ensures
> -	 * that we don't get a racing sync operation that does not wait for the
> -	 * metadata to hit the journal before returning. If we race with
> -	 * clearing the ili_fsync_fields, then all that will happen is the log
> -	 * force will do nothing as the lsn will already be on disk. We can't
> -	 * race with setting ili_fsync_fields because that is done under
> -	 * XFS_ILOCK_EXCL, and that can't happen because we hold the lock shared
> -	 * until after the ili_fsync_fields is cleared.
> -	 */
> -	xfs_ilock(ip, XFS_ILOCK_SHARED);
> -	if (xfs_ipincount(ip)) {
> -		if (!datasync ||
> -		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> -			lsn = iip->ili_last_lsn;
> -	}
> -
> -	if (lsn) {
> -		error = xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, &log_flushed);
> -		spin_lock(&iip->ili_lock);
> -		iip->ili_fsync_fields = 0;
> -		spin_unlock(&iip->ili_lock);
> -	}
> -	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	error = xfs_fsync_flush_log(ip, datasync, &log_flushed);
>  
>  	/*
>  	 * If we only have a single device, and the log force about was
> -- 
> 2.29.2
> 

