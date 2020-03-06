Return-Path: <SRS0=P3J0=4X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF0AC10DCE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8203B2073B
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Mar 2020 16:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QDzsMDqm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgCFQKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Mar 2020 11:10:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33860 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726083AbgCFQKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 11:10:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583511020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzM/OnanyEIM9Odca01HFzcc9GbGBf3sogOy8HqQCp0=;
        b=QDzsMDqm2w7UGqEDrW1SiThJic9H41SxTwsoj8RNR6kKl75YUNgXsGv/pEfW3C8IOdfREJ
        KEQGEBhr4g7j0YSa92YmCYdSjpsbzUyjkG7EMLhAZR/3086ahiGMVTaPTgxC05oDvzXhZo
        dwrXaq6hwocSocyqqqN6QvUCZSpWN+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-onLtxnsRP0ikNKrSiQzKfQ-1; Fri, 06 Mar 2020 11:10:19 -0500
X-MC-Unique: onLtxnsRP0ikNKrSiQzKfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C9B98018C2;
        Fri,  6 Mar 2020 16:10:18 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A05FA91289;
        Fri,  6 Mar 2020 16:10:17 +0000 (UTC)
Date:   Fri, 6 Mar 2020 11:10:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: remove dead code from xfs_log_unmount_write
Message-ID: <20200306161015.GE2773@bfoster>
References: <20200306143137.236478-1-hch@lst.de>
 <20200306143137.236478-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200306143137.236478-3-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 06, 2020 at 07:31:32AM -0700, Christoph Hellwig wrote:
> When the log is shut down all iclogs are in the XLOG_STATE_IOERROR state,
> which means that xlog_state_want_sync and xlog_state_release_iclog are
> no-ops.  Remove the whole section of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 35 +++--------------------------------
>  1 file changed, 3 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index fa499ddedb94..b56432d4a9b8 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -984,38 +984,9 @@ xfs_log_unmount_write(xfs_mount_t *mp)
>  		iclog = iclog->ic_next;
>  	} while (iclog != first_iclog);
>  #endif
> -	if (! (XLOG_FORCED_SHUTDOWN(log))) {
> -		xfs_log_write_unmount_record(mp);
> -	} else {
> -		/*
> -		 * We're already in forced_shutdown mode, couldn't
> -		 * even attempt to write out the unmount transaction.
> -		 *
> -		 * Go through the motions of sync'ing and releasing
> -		 * the iclog, even though no I/O will actually happen,
> -		 * we need to wait for other log I/Os that may already
> -		 * be in progress.  Do this as a separate section of
> -		 * code so we'll know if we ever get stuck here that
> -		 * we're in this odd situation of trying to unmount
> -		 * a file system that went into forced_shutdown as
> -		 * the result of an unmount..
> -		 */
> -		spin_lock(&log->l_icloglock);
> -		iclog = log->l_iclog;
> -		atomic_inc(&iclog->ic_refcnt);
> -		xlog_state_want_sync(log, iclog);
> -		xlog_state_release_iclog(log, iclog);
> -		switch (iclog->ic_state) {
> -		case XLOG_STATE_ACTIVE:
> -		case XLOG_STATE_DIRTY:
> -		case XLOG_STATE_IOERROR:
> -			spin_unlock(&log->l_icloglock);
> -			break;
> -		default:
> -			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> -			break;
> -		}
> -	}
> +	if (XLOG_FORCED_SHUTDOWN(log))
> +		return;
> +	xfs_log_write_unmount_record(mp);
>  }
>  
>  /*
> -- 
> 2.24.1
> 

