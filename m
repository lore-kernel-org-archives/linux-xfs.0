Return-Path: <SRS0=TKSY=YI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFDAC10F14
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A9852084B
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Oct 2019 17:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfJORHF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 13:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46432 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfJORHF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 15 Oct 2019 13:07:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 68F69308A98C;
        Tue, 15 Oct 2019 17:07:05 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1315760C83;
        Tue, 15 Oct 2019 17:07:04 +0000 (UTC)
Date:   Tue, 15 Oct 2019 13:07:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: remove the unused ic_io_size field from
 xlog_in_core
Message-ID: <20191015170703.GD36108@bfoster>
References: <20191009142748.18005-1-hch@lst.de>
 <20191009142748.18005-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009142748.18005-3-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 15 Oct 2019 17:07:05 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 09, 2019 at 04:27:42PM +0200, Christoph Hellwig wrote:
> ic_io_size is only used inside xlog_write_iclog, where we can just use
> the count parameter intead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c      | 6 ++----
>  fs/xfs/xfs_log_priv.h | 3 ---
>  2 files changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index cd90871c2101..4f5927ddfa40 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1740,8 +1740,6 @@ xlog_write_iclog(
>  		return;
>  	}
>  
> -	iclog->ic_io_size = count;
> -
>  	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
>  	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
>  	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
> @@ -1751,9 +1749,9 @@ xlog_write_iclog(
>  	if (need_flush)
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  
> -	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, iclog->ic_io_size);
> +	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count);
>  	if (is_vmalloc_addr(iclog->ic_data))
> -		flush_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
> +		flush_kernel_vmap_range(iclog->ic_data, count);
>  
>  	/*
>  	 * If this log buffer would straddle the end of the log we will have
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b880c23cb6e4..90e210e433cf 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -179,8 +179,6 @@ typedef struct xlog_ticket {
>   * - ic_next is the pointer to the next iclog in the ring.
>   * - ic_log is a pointer back to the global log structure.
>   * - ic_size is the full size of the log buffer, minus the cycle headers.
> - * - ic_io_size is the size of the currently pending log buffer write, which
> - *	might be smaller than ic_size
>   * - ic_offset is the current number of bytes written to in this iclog.
>   * - ic_refcnt is bumped when someone is writing to the log.
>   * - ic_state is the state of the iclog.
> @@ -205,7 +203,6 @@ typedef struct xlog_in_core {
>  	struct xlog_in_core	*ic_prev;
>  	struct xlog		*ic_log;
>  	u32			ic_size;
> -	u32			ic_io_size;
>  	u32			ic_offset;
>  	unsigned short		ic_state;
>  	char			*ic_datap;	/* pointer to iclog data */
> -- 
> 2.20.1
> 
