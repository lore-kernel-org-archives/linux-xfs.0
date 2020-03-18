Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90126C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F2B20714
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gJi3es+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgCROsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 10:48:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:54761 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726473AbgCROsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 10:48:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584542925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jAoe2V3JoTgBOUzPQIkzLS8T/t9DiWUsv9Fb7lLs814=;
        b=gJi3es+3mL7sRNCiuovN/wVEKsDtgwZRFYZi28kX5p/RyvneKy5/1CJd3z25v97oH2jjh7
        i6kF05UVCBMOCGS6GPDPkso/L1zgmrdm6kDe+gQnSHY0MYXGgMVvQCH1c0oFW2izLInaYY
        5jEbqCrR4G/6//dCnAfuWecYG9HAjk8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-TKODsHEgNYyhV6mj3qDwYA-1; Wed, 18 Mar 2020 10:48:43 -0400
X-MC-Unique: TKODsHEgNYyhV6mj3qDwYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA5161005509;
        Wed, 18 Mar 2020 14:48:42 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4819D5C1D8;
        Wed, 18 Mar 2020 14:48:42 +0000 (UTC)
Date:   Wed, 18 Mar 2020 10:48:40 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/14] xfs: merge xlog_state_set_callback into
 xlog_state_iodone_process_iclog
Message-ID: <20200318144840.GD32848@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-13-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-13-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:31PM +0100, Christoph Hellwig wrote:
> Merge xlog_state_set_callback into its only caller, which makes the iclog
> I/O completion handling a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 74 +++++++++++++++++++++---------------------------
>  1 file changed, 33 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 899c324d07e2..865dd1e08679 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2645,46 +2645,6 @@ xlog_get_lowest_lsn(
>  	return lowest_lsn;
>  }
>  
> -/*
> - * Completion of a iclog IO does not imply that a transaction has completed, as
> - * transactions can be large enough to span many iclogs. We cannot change the
> - * tail of the log half way through a transaction as this may be the only
> - * transaction in the log and moving the tail to point to the middle of it
> - * will prevent recovery from finding the start of the transaction. Hence we
> - * should only update the last_sync_lsn if this iclog contains transaction
> - * completion callbacks on it.
> - *
> - * We have to do this before we drop the icloglock to ensure we are the only one
> - * that can update it.
> - *
> - * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
> - * the reservation grant head pushing. This is due to the fact that the push
> - * target is bound by the current last_sync_lsn value. Hence if we have a large
> - * amount of log space bound up in this committing transaction then the
> - * last_sync_lsn value may be the limiting factor preventing tail pushing from
> - * freeing space in the log. Hence once we've updated the last_sync_lsn we
> - * should push the AIL to ensure the push target (and hence the grant head) is
> - * no longer bound by the old log head location and can move forwards and make
> - * progress again.
> - */
> -static void
> -xlog_state_set_callback(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	xfs_lsn_t		header_lsn)
> -{
> -	iclog->ic_state = XLOG_STATE_CALLBACK;
> -
> -	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> -			   header_lsn) <= 0);
> -
> -	if (list_empty_careful(&iclog->ic_callbacks))
> -		return;
> -
> -	atomic64_set(&log->l_last_sync_lsn, header_lsn);
> -	xlog_grant_push_ail(log, 0);
> -}
> -
>  /*
>   * Keep processing entries in the iclog callback list until we come around and
>   * it is empty.  We need to atomically see that the list is empty and change the
> @@ -2741,7 +2701,39 @@ xlog_state_iodone_process_iclog(
>  	if (lowest_lsn && XFS_LSN_CMP(lowest_lsn, header_lsn) < 0)
>  		return false;
>  
> -	xlog_state_set_callback(log, iclog, header_lsn);
> +	iclog->ic_state = XLOG_STATE_CALLBACK;
> +
> +	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
> +			   header_lsn) <= 0);
> +
> +	/*
> +	 * Completion of an iclog I/O does not imply that a transaction has
> +	 * completed, as transactions can be large enough to span multiple
> +	 * iclogs.  We cannot change the tail of the log half way through a
> +	 * transaction as this may be the only transaction in the log and moving
> +	 * the tail to point to the middle of it will prevent recovery from
> +	 * finding the start of the transaction. Hence we should only update
> +	 * the last_sync_lsn if this iclog contains transaction completion
> +	 * callbacks on it.
> +	 *
> +	 * We have to do this before we drop the icloglock to ensure we are the
> +	 * only one that can update it.
> +	 *
> +	 * If we are moving last_sync_lsn forwards, we also need to ensure we
> +	 * kick the reservation grant head pushing. This is due to the fact that
> +	 * the push target is bound by the current last_sync_lsn value.  If we
> +	 * have a large amount of log space bound up in this committing
> +	 * transaction then the last_sync_lsn value may be the limiting factor
> +	 * preventing tail pushing from freeing space in the log.  Hence once
> +	 * we've updated the last_sync_lsn we should push the AIL to ensure the
> +	 * push target (and hence the grant head) is no longer bound by the old
> +	 * log head location and can move forwards and make progress again.
> +	 */
> +	if (!list_empty_careful(&iclog->ic_callbacks)) {
> +		atomic64_set(&log->l_last_sync_lsn, header_lsn);
> +		xlog_grant_push_ail(log, 0);
> +	}
> +
>  	xlog_state_do_iclog_callbacks(log, iclog);
>  
>  	iclog->ic_state = XLOG_STATE_DIRTY;
> -- 
> 2.24.1
> 

