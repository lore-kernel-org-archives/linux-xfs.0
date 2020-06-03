Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64599C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B51207D5
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 15:02:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQhuMw8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgFCPCQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 11:02:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42251 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgFCPCP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 11:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591196533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7t4u5VXmZ0ft9xILUZF6NZ3lHmI+DmkH7oL0Pz9FBE8=;
        b=HQhuMw8Jdr3MRQzzJXB6LNYEY1NuIWgA36IN5LA+9gYNPo6OZc2vnGnhGuiVPKm7g2diKg
        PzMzGwMf1r46MHy/XsgM9JozRZeuy1B7+Q6IYa+sWDoG+sK7MoovwAF2PA/EKP5SZe+G2Y
        9IE2u7qz9fTUgBWD+komgDWp9yGWD3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-Hlxjx1pvP2e-v8ncoZEo7w-1; Wed, 03 Jun 2020 11:02:11 -0400
X-MC-Unique: Hlxjx1pvP2e-v8ncoZEo7w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5F548CCBF8;
        Wed,  3 Jun 2020 15:02:09 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A76478FDD;
        Wed,  3 Jun 2020 15:02:09 +0000 (UTC)
Date:   Wed, 3 Jun 2020 11:02:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200603150207.GG12332@bfoster>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-14-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601214251.4167140-14-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 07:42:34AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently when a buffer with attached log items has an IO error
> it called ->iop_error for each attched log item. These all call
> xfs_set_li_failed() to handle the error, but we are about to change
> the way log items manage buffers. hence we first need to remove the
> per-item dependency on buffer handling done by xfs_set_li_failed().
> 
> We already have specific buffer type IO completion routines, so move
> the log item error handling out of the generic error handling and
> into the log item specific functions so we can implement per-type
> error handling easily.
> 
> This requires a more complex return value from the error handling
> code so that we can take the correct action the failure handling
> requires.  This results in some repeated boilerplate in the
> functions, but that can be cleaned up later once all the changes
> cascade through this code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

I reiterate some of Darrick's comments in that it's slightly annoying to
see refactoring squashed together that looks like it could be done in a
couple smaller and more simple patches. That aside, the only thing that
kind of bothers me is...

>  fs/xfs/xfs_buf_item.c | 167 ++++++++++++++++++++++++++++--------------
>  1 file changed, 112 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 09bfe9c52dbdb..b6995719e877b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
...
> @@ -1031,36 +1025,80 @@ xfs_buf_iodone_callback_error(
...
> +static int
> +xfs_buf_iodone_error(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_error_cfg	*cfg;
> +
> +	if (xfs_buf_ioerror_sync(bp))
> +		goto out_stale;
> +
> +	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> +
> +	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> +	if (xfs_buf_ioerror_retry(bp, cfg)) {
> +		xfs_buf_ioerror(bp, 0);
> +		xfs_buf_submit(bp);
> +		return 1;
> +	}
> +
> +	if (xfs_buf_ioerror_permanent(bp, cfg))
>  		goto permanent_error;
>  
>  	/*
>  	 * Still a transient error, run IO completion failure callbacks and let
>  	 * the higher layers retry the buffer.
>  	 */
> -	xfs_buf_do_callbacks_fail(bp);
>  	xfs_buf_ioerror(bp, 0);
> -	xfs_buf_relse(bp);
> -	return true;
> +	return 2;

... that we now clear the buffer error code before running the failure
callbacks. I know that nothing in the callbacks looks at it right now,
but I think it's subtle and inelegant to split it off this way. Can we
just move this entire block together into the type callbacks?

Brian

>  
>  	/*
>  	 * Permanent error - we need to trigger a shutdown if we haven't already
> @@ -1072,30 +1110,7 @@ xfs_buf_iodone_callback_error(
>  	xfs_buf_stale(bp);
>  	bp->b_flags |= XBF_DONE;
>  	trace_xfs_buf_error_relse(bp, _RET_IP_);
> -	return false;
> -}
> -
> -static inline bool
> -xfs_buf_had_callback_errors(
> -	struct xfs_buf		*bp)
> -{
> -
> -	/*
> -	 * If there is an error, process it. Some errors require us to run
> -	 * callbacks after failure processing is done so we detect that and take
> -	 * appropriate action.
> -	 */
> -	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
> -		return true;
> -
> -	/*
> -	 * Successful IO or permanent error. Either way, we can clear the
> -	 * retry state here in preparation for the next error that may occur.
> -	 */
> -	bp->b_last_error = 0;
> -	bp->b_retries = 0;
> -	bp->b_first_retry_time = 0;
> -	return false;
> +	return 0;
>  }
>  
>  static void
> @@ -1122,6 +1137,15 @@ xfs_buf_item_done(
>  	xfs_buf_rele(bp);
>  }
>  
> +static inline void
> +xfs_buf_clear_ioerror_retry_state(
> +	struct xfs_buf		*bp)
> +{
> +	bp->b_last_error = 0;
> +	bp->b_retries = 0;
> +	bp->b_first_retry_time = 0;
> +}
> +
>  /*
>   * Inode buffer iodone callback function.
>   */
> @@ -1129,9 +1153,20 @@ void
>  xfs_buf_inode_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_iflush_done(bp);
>  	xfs_buf_ioend_finish(bp);
> @@ -1144,9 +1179,20 @@ void
>  xfs_buf_dquot_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	/* a newly allocated dquot buffer might have a log item attached */
>  	xfs_buf_item_done(bp);
>  	xfs_dquot_done(bp);
> @@ -1163,9 +1209,20 @@ void
>  xfs_buf_iodone(
>  	struct xfs_buf		*bp)
>  {
> -	if (xfs_buf_had_callback_errors(bp))
> +	if (bp->b_error) {
> +		int ret = xfs_buf_iodone_error(bp);
> +		if (!ret)
> +			goto finish_iodone;
> +		if (ret == 1)
> +			return;
> +		ASSERT(ret == 2);
> +		xfs_buf_do_callbacks_fail(bp);
> +		xfs_buf_relse(bp);
>  		return;
> +	}
>  
> +finish_iodone:
> +	xfs_buf_clear_ioerror_retry_state(bp);
>  	xfs_buf_item_done(bp);
>  	xfs_buf_ioend_finish(bp);
>  }
> -- 
> 2.26.2.761.g0e0b3e54be
> 

