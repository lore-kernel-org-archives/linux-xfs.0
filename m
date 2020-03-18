Return-Path: <SRS0=sZmN=5D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95BBBC5ACD6
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D6A20714
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Mar 2020 14:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPzkX8T2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgCROsk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Mar 2020 10:48:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56654 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgCROsj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Mar 2020 10:48:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584542918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqbZicw5QuvLHBy6Nz5VnBekJkZWOK21TkYzJvV1hO0=;
        b=bPzkX8T2RmNr/Vsn7m9ZlMTOfDgEJZair90UNma6WRluZ7U95e0j7hmDz/bcuK0DVd28K6
        VX5iZotgEnNWicJDoXwuQU8KBMhJZQFRVdpzCp6D0CoErGBHNUZh9Y2rIwMCP27ojKjvUQ
        uzOs8DPJAC8aZ04nAl/iPM+De/CcfOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-ZRZVJuh1P7Gb-5OWsu79AQ-1; Wed, 18 Mar 2020 10:48:36 -0400
X-MC-Unique: ZRZVJuh1P7Gb-5OWsu79AQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A17ED800D50;
        Wed, 18 Mar 2020 14:48:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E15860BFB;
        Wed, 18 Mar 2020 14:48:35 +0000 (UTC)
Date:   Wed, 18 Mar 2020 10:48:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/14] xfs: merge xlog_state_clean_iclog into
 xlog_state_iodone_process_iclog
Message-ID: <20200318144833.GC32848@bfoster>
References: <20200316144233.900390-1-hch@lst.de>
 <20200316144233.900390-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316144233.900390-12-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 16, 2020 at 03:42:30PM +0100, Christoph Hellwig wrote:
> Merge xlog_state_clean_iclog into its only caller, which makes the iclog
> I/O completion handling a little easier to follow.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c | 25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index a38d495b6e81..899c324d07e2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2625,22 +2625,6 @@ xlog_covered_state(
>  	return XLOG_STATE_COVER_NEED;
>  }
>  
> -STATIC void
> -xlog_state_clean_iclog(
> -	struct xlog		*log,
> -	struct xlog_in_core	*dirty_iclog)
> -{
> -	int			iclogs_changed = 0;
> -
> -	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
> -
> -	xlog_state_activate_iclogs(log, &iclogs_changed);
> -	wake_up_all(&dirty_iclog->ic_force_wait);
> -
> -	if (iclogs_changed)
> -		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
> -}
> -
>  STATIC xfs_lsn_t
>  xlog_get_lowest_lsn(
>  	struct xlog		*log)
> @@ -2744,6 +2728,7 @@ xlog_state_iodone_process_iclog(
>  	struct xlog_in_core	*iclog)
>  {
>  	xfs_lsn_t		header_lsn, lowest_lsn;
> +	int			iclogs_changed = 0;
>  
>  	/*
>  	 * Now that we have an iclog that is in the DONE_SYNC state, do one more
> @@ -2758,7 +2743,13 @@ xlog_state_iodone_process_iclog(
>  
>  	xlog_state_set_callback(log, iclog, header_lsn);
>  	xlog_state_do_iclog_callbacks(log, iclog);
> -	xlog_state_clean_iclog(log, iclog);
> +
> +	iclog->ic_state = XLOG_STATE_DIRTY;
> +	xlog_state_activate_iclogs(log, &iclogs_changed);
> +
> +	wake_up_all(&iclog->ic_force_wait);
> +	if (iclogs_changed)
> +		log->l_covered_state = xlog_covered_state(log, iclogs_changed);
>  	return true;
>  }
>  
> -- 
> 2.24.1
> 

