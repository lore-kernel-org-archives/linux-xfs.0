Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB09BC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A228361937
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhCVL21 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:28:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhCVL2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 07:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616412497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eyxj2rdZtO+C0wlL63VSWhG8cQxipkfDtVrPVsTMHGM=;
        b=QvrviWFqaPUEaw9UnmWc8WOSEuTcLwnhwAKWPako71Xj2Z+yWfozyHJAmSkuiRTNl3jQx+
        b0GpmkjagBs9UbxCDVAzadEzgt+mmzuKg8ando38jbUBrJvYYEIwmXj/yw6Kyf+CCj3ROA
        JYK9s8kE/HXdKID2l3Ouv5Uk47j3R0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-_4_5vV2fPbOMeVbZg15k9A-1; Mon, 22 Mar 2021 07:28:15 -0400
X-MC-Unique: _4_5vV2fPbOMeVbZg15k9A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D59439CC03;
        Mon, 22 Mar 2021 11:28:13 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E726D60C5F;
        Mon, 22 Mar 2021 11:28:09 +0000 (UTC)
Date:   Mon, 22 Mar 2021 07:28:07 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v8 2/5] xfs: hoist out xfs_resizefs_init_new_ags()
Message-ID: <YFh/R/XMvCXnA3Q9@bfoster>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-3-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305025703.3069469-3-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 10:57:00AM +0800, Gao Xiang wrote:
> Move out related logic for initializing new added AGs to a new helper
> in preparation for shrinking. No logic changes.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 107 +++++++++++++++++++++++++++------------------
>  1 file changed, 64 insertions(+), 43 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 9f9ba8bd0213..fc9e799b2ae3 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -20,6 +20,64 @@
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
> +	struct xfs_trans	*tp,
> +	struct aghdr_init_data	*id,
> +	xfs_agnumber_t		oagcount,
> +	xfs_agnumber_t		nagcount,
> +	xfs_rfsblock_t		delta,
> +	bool			*lastag_resetagres)

Nit: I'd just call this lastag_extended or something that otherwise
indicates what this function reports (as opposed to trying to tell the
caller what to do).

> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_rfsblock_t		nb = mp->m_sb.sb_dblocks + delta;
> +	int			error;
> +
> +	*lastag_resetagres = false;
> +
> +	INIT_LIST_HEAD(&id->buffer_list);
> +	for (id->agno = nagcount - 1;
> +	     id->agno >= oagcount;
> +	     id->agno--, delta -= id->agsize) {
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
> +
> +	error = xfs_buf_delwri_submit(&id->buffer_list);
> +	if (error)
> +		return error;
> +
> +	xfs_trans_agblocks_delta(tp, id->nfree);
> +
> +	if (delta) {
> +		*lastag_resetagres = true;
> +		error = xfs_ag_extend_space(mp, tp, id, delta);
> +	}
> +	return error;
> +}
> +
>  /*
>   * growfs operations
>   */
...
> @@ -123,9 +145,8 @@ xfs_growfs_data_private(
>  	 */
>  	if (nagcount > oagcount)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_AGCOUNT, nagcount - oagcount);
> -	if (nb > mp->m_sb.sb_dblocks)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS,
> -				 nb - mp->m_sb.sb_dblocks);
> +	if (delta > 0)
> +		xfs_trans_mod_sb(tp, XFS_TRANS_SB_DBLOCKS, delta);

Hm.. isn't delta still unsigned as of this patch?

Brian

>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
>  
> @@ -152,7 +173,7 @@ xfs_growfs_data_private(
>  	 * If we expanded the last AG, free the per-AG reservation
>  	 * so we can reinitialize it with the new size.
>  	 */
> -	if (delta) {
> +	if (lastag_resetagres) {
>  		struct xfs_perag	*pag;
>  
>  		pag = xfs_perag_get(mp, id.agno);
> -- 
> 2.27.0
> 

