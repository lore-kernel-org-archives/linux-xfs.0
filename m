Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39418C83000
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F016205C9
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 15:11:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsbQ1LO8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgD1PLM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 11:11:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:39473 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727915AbgD1PLM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 11:11:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588086671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pJgenK0QI+fi3yixX0O5e1q+62Zfu/t9rKZ+m50emyE=;
        b=BsbQ1LO8bZG0Win1dWHiaykReZeY32kc5dJ5n77vgU75fB2oFQLs9forTFQlwAQ/pz9Ro0
        N2cbPF7VAL4iFOVIrMR42OTTYpFOXbbyqfIRdL0N1xNH2daD0q/EvmJer57BqyUTnXZKx8
        v6LP94tCpnGaRLLC7lLaFLgVMTlkzhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-oTXKHZS-OkGF0NUC3uhssQ-1; Tue, 28 Apr 2020 11:11:09 -0400
X-MC-Unique: oTXKHZS-OkGF0NUC3uhssQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DDD5100CCC1;
        Tue, 28 Apr 2020 15:11:08 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33BDF5C1D4;
        Tue, 28 Apr 2020 15:11:08 +0000 (UTC)
Date:   Tue, 28 Apr 2020 11:11:06 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/2] xfs: simplify xlog_recover_inode_ra_pass2
Message-ID: <20200428151106.GD27954@bfoster>
References: <20200427135229.1480993-1-hch@lst.de>
 <20200427193349.GB24934@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427193349.GB24934@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 09:33:49PM +0200, Christoph Hellwig wrote:
> Don't bother to allocate memory and convert the log item when we
> only need the block number and the length.  Just extract them directly
> and call xlog_buf_readahead separately in each branch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 4cb8f24f3aa63..fe4dad5b77a95 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3890,22 +3890,17 @@ xlog_recover_inode_ra_pass2(
>  	struct xlog                     *log,
>  	struct xlog_recover_item        *item)
>  {
> -	struct xfs_inode_log_format	ilf_buf;
> -	struct xfs_inode_log_format	*ilfp;
> -	int			error;
> -
>  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> -		ilfp = item->ri_buf[0].i_addr;
> +		struct xfs_inode_log_format	*ilfp = item->ri_buf[0].i_addr;
> +
> +		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> +				   &xfs_inode_buf_ra_ops);
>  	} else {
> -		ilfp = &ilf_buf;
> -		memset(ilfp, 0, sizeof(*ilfp));
> -		error = xfs_inode_item_format_convert(&item->ri_buf[0], ilfp);
> -		if (error)
> -			return;
> -	}
> +		struct xfs_inode_log_format_32	*ilfp = item->ri_buf[0].i_addr;
>  
> -	xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> -			   &xfs_inode_buf_ra_ops);
> +		xlog_buf_readahead(log, ilfp->ilf_blkno, ilfp->ilf_len,
> +				   &xfs_inode_buf_ra_ops);
> +	}
>  }
>  
>  STATIC void
> -- 
> 2.26.1
> 

