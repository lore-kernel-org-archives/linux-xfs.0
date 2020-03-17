Return-Path: <SRS0=h+lF=5C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB8EC18E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46F7920754
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Mar 2020 13:25:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LhhOT/nT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgCQNZL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Mar 2020 09:25:11 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60886 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgCQNZL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Mar 2020 09:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b2QFc4NMv22dl6QvVMZj6evt5NcfTA+f3FMaz1ae6ZQ=;
        b=LhhOT/nTX9vfLloWgdXtmyX30jlA8HNuJ+USkH8AyAcqYZnnl17mrcfZm21T3RHIKlrxC8
        SJk3UNzGR7fr6syDqEbgcl5WBKY6y2pOmHOn7s/Knyf7x24WPtgygAPJ9bffa8BA6I9PE8
        9ENRcOz0lUiVoQY7zDRs0ZCbbgNJPR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-WCkeFcnNOhWSRmFmGWtTRg-1; Tue, 17 Mar 2020 09:25:08 -0400
X-MC-Unique: WCkeFcnNOhWSRmFmGWtTRg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B144180455C;
        Tue, 17 Mar 2020 13:25:07 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DEE1748;
        Tue, 17 Mar 2020 13:25:06 +0000 (UTC)
Date:   Tue, 17 Mar 2020 09:25:05 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/14] xfs: refactor xlog_state_clean_iclog
Message-ID: <20200317132505.GG24078@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-7-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:25PM +0100, Christoph Hellwig wrote:
> Factor out a few self-container helper from xlog_state_clean_iclog, and
> update the documentation so it primarily documents why things happens
> instead of how.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 180 +++++++++++++++++++++++------------------------
>  1 file changed, 87 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 8ede2852f104..23979d08a2a3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2540,112 +2540,106 @@ xlog_write(
...
> +static int
> +xlog_covered_state(
> +	struct xlog		*log,
> +	int			iclogs_changed)
> +{
>  	/*
> -	 * Wake up threads waiting in xfs_log_force() for the dirty iclog
> -	 * to be cleaned.
> +	 * We usually go to NEED. But we go to NEED2 if the changed indicates we
> +	 * are done writing the dummy record.  If we are done with the second
> +	 * dummy recored (DONE2), then we go to IDLE.
>  	 */
> -	wake_up_all(&dirty_iclog->ic_force_wait);
> +	switch (log->l_covered_state) {
> +	case XLOG_STATE_COVER_IDLE:
> +	case XLOG_STATE_COVER_NEED:
> +	case XLOG_STATE_COVER_NEED2:
> +		break;
> +	case XLOG_STATE_COVER_DONE:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_NEED2;
> +		break;
> +	case XLOG_STATE_COVER_DONE2:
> +		if (iclogs_changed == 1)
> +			return XLOG_STATE_COVER_IDLE;
> +		break;
> +	default:
> +		ASSERT(0);
> +	}

The code looks mostly fine, but I'm not a fan of this factoring where we
deref ->l_covered_state here and return a value only for the caller to
assign it to ->l_covered_state again. Can we just let this function
assign ->l_covered_state itself (i.e. assign a local variable rather than
return within the switch)?

Brian

>  
> -	/*
> -	 * Change state for the dummy log recording.
> -	 * We usually go to NEED. But we go to NEED2 if the changed indicates
> -	 * we are done writing the dummy record.
> -	 * If we are done with the second dummy recored (DONE2), then
> -	 * we go to IDLE.
> -	 */
> -	if (changed) {
> -		switch (log->l_covered_state) {
> -		case XLOG_STATE_COVER_IDLE:
> -		case XLOG_STATE_COVER_NEED:
> -		case XLOG_STATE_COVER_NEED2:
> -			log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	return XLOG_STATE_COVER_NEED;
> +}
>  
> -		case XLOG_STATE_COVER_DONE:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_NEED2;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +STATIC void
> +xlog_state_clean_iclog(
> +	struct xlog		*log,
> +	struct xlog_in_core	*dirty_iclog)
> +{
> +	int			iclogs_changed = 0;
>  
> -		case XLOG_STATE_COVER_DONE2:
> -			if (changed == 1)
> -				log->l_covered_state = XLOG_STATE_COVER_IDLE;
> -			else
> -				log->l_covered_state = XLOG_STATE_COVER_NEED;
> -			break;
> +	if (dirty_iclog->ic_state != XLOG_STATE_IOERROR)
> +		dirty_iclog->ic_state = XLOG_STATE_DIRTY;
>  
> -		default:
> -			ASSERT(0);
> -		}
> -	}
> +	xlog_state_activate_iclogs(log, &iclogs_changed);
> +	wake_up_all(&dirty_iclog->ic_force_wait);
> +
> +	if (iclogs_changed)
> +		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
>  }
>  
>  STATIC xfs_lsn_t
> -- 
> 2.24.1
> 

