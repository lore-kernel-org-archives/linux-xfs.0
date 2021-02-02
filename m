Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD83C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F9364E56
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239859AbhBBTkN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:40:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27340 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233185AbhBBTjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612294706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUPvwpQQf3URByohS6Jq0KkJYBwuMrOA0QMRFuiz7Ho=;
        b=fNZEAgUVerOd7XPWGGPfcFksSxhOUQ+E0E+p6OBw7IUaZvezDuMZAmCbw8aCuOCFfGs2BV
        K/CXDGj3xZcJAIWYmZvFljlYJV+id/5E7nHh4XE5SAmFtDTf2wwh9rjRwo087GZTtIO+I9
        SVplfbNaHcOtxJ4K0o6EscXoAp1T2eY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-8ber2lxfNAiWL8tqsSYQOw-1; Tue, 02 Feb 2021 14:38:22 -0500
X-MC-Unique: 8ber2lxfNAiWL8tqsSYQOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE145134C4D;
        Tue,  2 Feb 2021 19:38:20 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CE2F60C69;
        Tue,  2 Feb 2021 19:38:17 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:38:15 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 4/7] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <20210202193815.GO3336100@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-5-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126125621.3846735-5-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:56:18PM +0800, Gao Xiang wrote:
> Move out related logic for initializing new added AGs to a new helper
> in preparation for shrinking. No logic changes.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c | 74 +++++++++++++++++++++++++++-------------------
>  1 file changed, 44 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 2e490fb75832..6c4ab5e31054 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -20,6 +20,49 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  
> +/*
> + * Write new AG headers to disk. Non-transactional, but need to be
> + * written and completed prior to the growfs transaction being logged.
> + * To do this, we use a delayed write buffer list and wait for
> + * submission and IO completion of the list as a whole. This allows the
> + * IO subsystem to merge all the AG headers in a single AG into a single
> + * IO and hide most of the latency of the IO from us.
> + *
> + * This also means that if we get an error whilst building the buffer
> + * list to write, we can cancel the entire list without having written
> + * anything.
> + */
> +static int
> +xfs_resizefs_init_new_ags(
> +	struct xfs_mount	*mp,
> +	struct aghdr_init_data	*id,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount,
> +	xfs_rfsblock_t		*delta)
> +{
> +	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + *delta;
> +	int			error;
> +
> +	INIT_LIST_HEAD(&id->buffer_list);
> +	for (id->agno = nagcount - 1;
> +	     id->agno >= oagcount;
> +	     id->agno--, *delta -= id->agsize) {
> +
> +		if (id->agno == nagcount - 1)
> +			id->agsize = nb - (id->agno *
> +					(xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> +		else
> +			id->agsize = mp->m_sb.sb_agblocks;
> +
> +		error = xfs_ag_init_headers(mp, id);
> +		if (error) {
> +			xfs_buf_delwri_cancel(&id->buffer_list);
> +			return error;
> +		}
> +	}
> +	return xfs_buf_delwri_submit(&id->buffer_list);
> +}
> +
>  /*
>   * growfs operations
>   */
> @@ -74,36 +117,7 @@ xfs_growfs_data_private(
>  	if (error)
>  		return error;
>  
> -	/*
> -	 * Write new AG headers to disk. Non-transactional, but need to be
> -	 * written and completed prior to the growfs transaction being logged.
> -	 * To do this, we use a delayed write buffer list and wait for
> -	 * submission and IO completion of the list as a whole. This allows the
> -	 * IO subsystem to merge all the AG headers in a single AG into a single
> -	 * IO and hide most of the latency of the IO from us.
> -	 *
> -	 * This also means that if we get an error whilst building the buffer
> -	 * list to write, we can cancel the entire list without having written
> -	 * anything.
> -	 */
> -	INIT_LIST_HEAD(&id.buffer_list);
> -	for (id.agno = nagcount - 1;
> -	     id.agno >= oagcount;
> -	     id.agno--, delta -= id.agsize) {
> -
> -		if (id.agno == nagcount - 1)
> -			id.agsize = nb -
> -				(id.agno * (xfs_rfsblock_t)mp->m_sb.sb_agblocks);
> -		else
> -			id.agsize = mp->m_sb.sb_agblocks;
> -
> -		error = xfs_ag_init_headers(mp, &id);
> -		if (error) {
> -			xfs_buf_delwri_cancel(&id.buffer_list);
> -			goto out_trans_cancel;
> -		}
> -	}
> -	error = xfs_buf_delwri_submit(&id.buffer_list);
> +	error = xfs_resizefs_init_new_ags(mp, &id, oagcount, nagcount, &delta);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.27.0
> 

