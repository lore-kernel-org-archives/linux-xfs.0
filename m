Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697B0C5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B5D620752
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R19gXsPh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCROsb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 10:48:31 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:33619 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726308AbgCROsb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 10:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584542910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0NECbJnDCl+z1jT+tlSf1DqeEwdHLIZcR4cu+fV8K2Y=;
        b=R19gXsPhDaXIKIPYrzDUuEMPTBCXjimcsgpBkiOfLmvTJlTazUbLxSyM7K1gwJq4k1xtWL
        HdGzcPZ2KH0izEn3FR2WcyO2J2CQUY/wRmh8XbSPiQfQMifdawvzJlJxjtgH5pBRfYhe6S
        asyudH+QFDtjFKlpdb5e2gILiduj/pk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-t7V9G7pdOj6PO2Mp9wBgoQ-1; Wed, 18 Mar 2020 10:48:28 -0400
X-MC-Unique: t7V9G7pdOj6PO2Mp9wBgoQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76616192D786;
        Wed, 18 Mar 2020 14:48:27 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01CFA5D9E5;
        Wed, 18 Mar 2020 14:48:26 +0000 (UTC)
Date:   Wed, 18 Mar 2020 10:48:25 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/14] xfs: move log shut down handling out of
 xlog_state_iodone_process_iclog
Message-ID: <20200318144825.GB32848@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-10-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:28PM +0100, Christoph Hellwig wrote:
> Move handling of a shut down log out of xlog_state_iodone_process_iclog
> and into xlog_state_do_callback so that it can be moved into an entirely
> separate branch.  While doing so switch to using XLOG_FORCED_SHUTDOWN to
> check the shutdown condition global to the log instead of the per-iclog
> flag, and make sure the comments match reality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 64 ++++++++++++++++++++----------------------------
>  1 file changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c534d7007aa3..4efaa248a03d 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -2795,39 +2785,41 @@ STATIC void
>  xlog_state_do_callback(
>  	struct xlog		*log)
>  {
> -	struct xlog_in_core	*iclog;
> -	struct xlog_in_core	*first_iclog;
>  	bool			cycled_icloglock;
> -	bool			ioerror;
>  	int			flushcnt = 0;
>  	int			repeats = 0;
>  
> +	/*
> +	 * Scan all iclogs starting with the one pointed to by the log.  Reset
> +	 * this starting point each time the log is unlocked (during callbacks).
> +	 *
> +	 * Keep looping through iclogs until one full pass is made without
> +	 * running any callbacks.
> +	 *
> +	 * If the log has been shut down, still perform the callbacks once per
> +	 * iclog to abort all log items, but don't bother to restart the loop
> +	 * after dropping the log as no new callbacks can show up.
> +	 */

"after dropping the lock ..."

>  	spin_lock(&log->l_icloglock);
>  	do {
> -		/*
> -		 * Scan all iclogs starting with the one pointed to by the
> -		 * log.  Reset this starting point each time the log is
> -		 * unlocked (during callbacks).
> -		 *
> -		 * Keep looping through iclogs until one full pass is made
> -		 * without running any callbacks.
> -		 */
> -		first_iclog = log->l_iclog;
> -		iclog = log->l_iclog;
> +		struct xlog_in_core	*first_iclog = log->l_iclog;
> +		struct xlog_in_core	*iclog = first_iclog;
> +
>  		cycled_icloglock = false;
> -		ioerror = false;
>  		repeats++;
>  
>  		do {
> -			if (xlog_state_iodone_process_iclog(log, iclog,
> -							&ioerror))
> +			if (XLOG_FORCED_SHUTDOWN(log)) {
> +				xlog_state_do_iclog_callbacks(log, iclog);
> +				wake_up_all(&iclog->ic_force_wait);
> +				continue;
> +			}
> +

Why do we need to change the flow here? The current code looks like it
proceeds with the _do_iclog_callbacks() call below..

As it is, I also don't think this reflects the comment above because if
we catch the shutdown partway through a loop, the outer loop will
execute one more time through. That doesn't look like a problem at a
glance, but I think we should try to retain closer to existing behavior
by folding the shutdown check into the ic_state check below as well as
the outer loop conditional.

This (and the next patch) also raises the issue of whether to maintain
state validity once the iclog ioerror state goes away. Currently we see
the IOERROR state and kind of have free reign on busting through the
normal runtime logic to clear out callbacks, etc. on the iclog
regardless of what the pre-error state was. It certainly makes sense to
continue to do that based on XLOG_FORCED_SHUTDOWN(), but the iclog state
sort of provides a platform that allows us to do that because any
particular context can see it and handle an iclog with care. With
IOERROR replaced with the (potentially racy) log flag check, I think we
should try to maintain the coherence of other states wherever possible.
IOW, XLOG_FORCED_SHUTDOWN() means we can run callbacks and abort and
whatnot, but we should probably still consider and update the iclog
state as we progress (as opposed to leaving it in the DONE_SYNC state,
for example) because there's no guarantee some other context will
(always) behave just as it did with IOERROR.

Brian

> +			if (xlog_state_iodone_process_iclog(log, iclog))
>  				break;
>  
> -			if (iclog->ic_state != XLOG_STATE_CALLBACK &&
> -			    iclog->ic_state != XLOG_STATE_IOERROR) {
> -				iclog = iclog->ic_next;
> +			if (iclog->ic_state != XLOG_STATE_CALLBACK)
>  				continue;
> -			}
>  
>  			/*
>  			 * Running callbacks will drop the icloglock which means
> @@ -2835,12 +2827,8 @@ xlog_state_do_callback(
>  			 */
>  			cycled_icloglock = true;
>  			xlog_state_do_iclog_callbacks(log, iclog);
> -			if (XLOG_FORCED_SHUTDOWN(log))
> -				wake_up_all(&iclog->ic_force_wait);
> -			else
> -				xlog_state_clean_iclog(log, iclog);
> -			iclog = iclog->ic_next;
> -		} while (first_iclog != iclog);
> +			xlog_state_clean_iclog(log, iclog);
> +		} while ((iclog = iclog->ic_next) != first_iclog);
>  
>  		if (repeats > 5000) {
>  			flushcnt += repeats;
> @@ -2849,7 +2837,7 @@ xlog_state_do_callback(
>  				"%s: possible infinite loop (%d iterations)",
>  				__func__, flushcnt);
>  		}
> -	} while (!ioerror && cycled_icloglock);
> +	} while (cycled_icloglock);
>  
>  	if (log->l_iclog->ic_state == XLOG_STATE_ACTIVE ||
>  	    log->l_iclog->ic_state == XLOG_STATE_IOERROR)
> -- 
> 2.24.1
> 

