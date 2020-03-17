Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E04AC18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246E020752
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IG+3S/C3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgCQNXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:23:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:31443 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgCQNXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jVgw4+9B/4dXeNF0eWUsmTh9MDY+byp2wf0eVL6ReQ0=;
        b=IG+3S/C3LcpHxYXXTWofSylQfVFEdjdW8zCdpQcBxjO+caixnl6wwk74m02h5bFdeY4zKg
        MluAYmu8gSRFciIN1MnRmreC3ANV7CtgeW6q+FhWisrai/GfL+bHPbnqCIl6+0Utw0ukBS
        30yd+XlU3Ndu7WwukbJe0HGmrTfko3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-qPezSOLwMFusj1K0xXdGaQ-1; Tue, 17 Mar 2020 09:23:16 -0400
X-MC-Unique: qPezSOLwMFusj1K0xXdGaQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 265051005513;
        Tue, 17 Mar 2020 13:23:15 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF5A660BF3;
        Tue, 17 Mar 2020 13:23:14 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:23:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/14] xfs: factor out a xlog_wait_on_iclog helper
Message-ID: <20200317132313.GC24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:21PM +0100, Christoph Hellwig wrote:
> Factor out the shared code to wait for a log force into a new helper.
> This helper uses the XLOG_FORCED_SHUTDOWN check previous only used
> by the unmount code over the equivalent iclog ioerror state used by
> the other two functions.
> 
> There is a slight behavior change in that the force of the unmount
> record is now accounted in the log force statistics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 76 ++++++++++++++++++++----------------------------
>  1 file changed, 31 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 0986983ef6b5..955df2902c2c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -859,6 +859,31 @@ xfs_log_mount_cancel(
>  	xfs_log_unmount(mp);
>  }
>  
> +/*
> + * Wait for the iclog to be written disk, or return an error if the log has been
> + * shut down.
> + */
> +static int
> +xlog_wait_on_iclog(
> +	struct xlog_in_core	*iclog)
> +		__releases(iclog->ic_log->l_icloglock)
> +{
> +	struct xlog		*log = iclog->ic_log;
> +
> +	if (!XLOG_FORCED_SHUTDOWN(log) &&
> +	    iclog->ic_state != XLOG_STATE_ACTIVE &&
> +	    iclog->ic_state != XLOG_STATE_DIRTY) {
> +		XFS_STATS_INC(log->l_mp, xs_log_force_sleep);
> +		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> +	} else {
> +		spin_unlock(&log->l_icloglock);
> +	}
> +
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return -EIO;
> +	return 0;
> +}
> +
>  /*
>   * Final log writes as part of unmount.
>   *
> @@ -926,18 +951,7 @@ xfs_log_write_unmount_record(
>  	atomic_inc(&iclog->ic_refcnt);
>  	xlog_state_want_sync(log, iclog);
>  	error = xlog_state_release_iclog(log, iclog);
> -	switch (iclog->ic_state) {
> -	default:
> -		if (!XLOG_FORCED_SHUTDOWN(log)) {
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -		/* fall through */
> -	case XLOG_STATE_ACTIVE:
> -	case XLOG_STATE_DIRTY:
> -		spin_unlock(&log->l_icloglock);
> -		break;
> -	}
> +	xlog_wait_on_iclog(iclog);
>  
>  	if (tic) {
>  		trace_xfs_log_umount_write(log, tic);
> @@ -3230,9 +3244,6 @@ xfs_log_force(
>  		 * previous iclog and go to sleep.
>  		 */
>  		iclog = iclog->ic_prev;
> -		if (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -		    iclog->ic_state == XLOG_STATE_DIRTY)
> -			goto out_unlock;
>  	} else if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		if (atomic_read(&iclog->ic_refcnt) == 0) {
>  			/*
> @@ -3248,8 +3259,7 @@ xfs_log_force(
>  			if (xlog_state_release_iclog(log, iclog))
>  				goto out_error;
>  
> -			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn ||
> -			    iclog->ic_state == XLOG_STATE_DIRTY)
> +			if (be64_to_cpu(iclog->ic_header.h_lsn) != lsn)
>  				goto out_unlock;
>  		} else {
>  			/*
> @@ -3269,17 +3279,8 @@ xfs_log_force(
>  		;
>  	}
>  
> -	if (!(flags & XFS_LOG_SYNC))
> -		goto out_unlock;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto out_error;
> -	XFS_STATS_INC(mp, xs_log_force_sleep);
> -	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		return -EIO;
> -	return 0;
> -
> +	if (flags & XFS_LOG_SYNC)
> +		return xlog_wait_on_iclog(iclog);
>  out_unlock:
>  	spin_unlock(&log->l_icloglock);
>  	return 0;
> @@ -3310,9 +3311,6 @@ __xfs_log_force_lsn(
>  			goto out_unlock;
>  	}
>  
> -	if (iclog->ic_state == XLOG_STATE_DIRTY)
> -		goto out_unlock;
> -
>  	if (iclog->ic_state == XLOG_STATE_ACTIVE) {
>  		/*
>  		 * We sleep here if we haven't already slept (e.g. this is the
> @@ -3346,20 +3344,8 @@ __xfs_log_force_lsn(
>  			*log_flushed = 1;
>  	}
>  
> -	if (!(flags & XFS_LOG_SYNC) ||
> -	    (iclog->ic_state == XLOG_STATE_ACTIVE ||
> -	     iclog->ic_state == XLOG_STATE_DIRTY))
> -		goto out_unlock;
> -
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		goto out_error;
> -
> -	XFS_STATS_INC(mp, xs_log_force_sleep);
> -	xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -	if (iclog->ic_state == XLOG_STATE_IOERROR)
> -		return -EIO;
> -	return 0;
> -
> +	if (flags & XFS_LOG_SYNC)
> +		return xlog_wait_on_iclog(iclog);
>  out_unlock:
>  	spin_unlock(&log->l_icloglock);
>  	return 0;
> -- 
> 2.24.1
> 

