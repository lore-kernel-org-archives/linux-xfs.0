Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94F4C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 963BB205C9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gwncur5A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgD1PLF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:11:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:31989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727865AbgD1PLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 11:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588086663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Anr74eTPJbGPHyE58sm5YPMdmtPWf5WQEDcSk7ZSH1k=;
        b=gwncur5AxIBcKbJShzGHxCVboeMKQxMZaSzA7LuTl3hLdC+EYv2/dLae+ls4xXgj2EuBkl
        /Qd8CmMTyY6BRmWh/lEl+faLzgSI1m7hVnhpuZfS4FVHQDhZbf63QltzJNO/TyILxtkUz7
        1X5hZIeiTKDsJDtC4iyTjCG0HPEuTKI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-mevk6BPyNYeHj7wwY8PwNA-1; Tue, 28 Apr 2020 11:11:01 -0400
X-MC-Unique: mevk6BPyNYeHj7wwY8PwNA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A576E464;
        Tue, 28 Apr 2020 15:11:00 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 370D05C1D4;
        Tue, 28 Apr 2020 15:11:00 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:10:58 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/2] xfs: factor out a xlog_buf_readahead helper
Message-ID: <20200428151058.GC27954@bfoster>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427193332.GA24934@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427193332.GA24934@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 09:33:32PM +0200, Christoph Hellwig wrote:
> Add a little helper to readahead a buffer if it hasn't been cancelled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 33cac61570abe..4cb8f24f3aa63 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2034,6 +2034,17 @@ xlog_put_buffer_cancelled(
>  	return true;
>  }
>  
> +static void
> +xlog_buf_readahead(
> +	struct xlog		*log,
> +	xfs_daddr_t		blkno,
> +	uint			len,
> +	const struct xfs_buf_ops *ops)
> +{
> +	if (!xlog_is_buffer_cancelled(log, blkno, len))
> +		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
> +}
> +
>  /*
>   * Perform recovery for a buffer full of inodes.  In these buffers, the only
>   * data which should be recovered is that which corresponds to the
> @@ -3870,12 +3881,8 @@ xlog_recover_buffer_ra_pass2(
>  	struct xlog_recover_item        *item)
>  {
>  	struct xfs_buf_log_format	*buf_f = item->ri_buf[0].i_addr;
> -	struct xfs_mount		*mp = log->l_mp;
>  
> -	if (xlog_is_buffer_cancelled(log, buf_f->blf_blkno, buf_f->blf_len))
> -		return;
> -	xfs_buf_readahead(mp->m_ddev_targp, buf_f->blf_blkno,
> -				buf_f->blf_len, NULL);
> +	xlog_buf_readahead(log, buf_f->blf_blkno, buf_f->blf_len, NULL);
>  }
>  
>  STATIC void
> @@ -3885,7 +3892,6 @@ xlog_recover_inode_ra_pass2(
>  {
>  	struct xfs_inode_log_format	ilf_buf;
>  	struct xfs_inode_log_format	*ilfp;
> -	struct xfs_mount		*mp = log->l_mp;
>  	int			error;
>  
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> @@ -3898,10 +3904,8 @@ xlog_recover_inode_ra_pass2(
>  			return;
>  	}
>  
> -	if (xlog_is_buffer_cancelled(log, ilfp->ilf_blkno, ilfp->ilf_len))
> -		return;
> -	xfs_buf_readahead(mp->m_ddev_targp, ilfp->ilf_blkno,
> -				ilfp->ilf_len, &xfs_inode_buf_ra_ops);
> +	xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> +			   &xfs_inode_buf_ra_ops);
>  }
>  
>  STATIC void
> @@ -3913,8 +3917,6 @@ xlog_recover_dquot_ra_pass2(
>  	struct xfs_disk_dquot	*recddq;
>  	struct xfs_dq_logformat	*dq_f;
>  	uint			type;
> -	int			len;
> -
>  
>  	if (mp->m_qflags == 0)
>  		return;
> @@ -3934,11 +3936,9 @@ xlog_recover_dquot_ra_pass2(
>  	ASSERT(dq_f);
>  	ASSERT(dq_f->qlf_len == 1);
>  
> -	len = XFS_FSB_TO_BB(mp, dq_f->qlf_len);
> -	if (xlog_is_buffer_cancelled(log, dq_f->qlf_blkno, len))
> -		return;
> -	xfs_buf_readahead(mp->m_ddev_targp, dq_f->qlf_blkno, len,
> -			  &xfs_dquot_buf_ra_ops);
> +	xlog_buf_readahead(log, dq_f->qlf_blkno,
> +			XFS_FSB_TO_BB(mp, dq_f->qlf_len),
> +			&xfs_dquot_buf_ra_ops);
>  }
>  
>  STATIC void
> -- 
> 2.26.1
> 

