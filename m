Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E852C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4743164F4D
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbhBBTj0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:39:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239978AbhBBTjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Feb 2021 14:39:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612294668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bWgvU9XR3tM2Gnq6kF5oXfxShMGY31rdjEdCrv/EIbw=;
        b=SAnxtb6dEzoHh5LDjvl7MQmu1h0BLpoEEtkyQYOei2N5/jPmWy7FYvoi/PI0MlePVzQaGM
        cQ2Q/84kYUrDgTe4yUntkk7pAwj03jE2LUb31bGKxTMiToNs9T9/hOB2VVb0p+tGPpiU8q
        xdL3Pxzziln2lq0m9HEhRFIHvDvcueU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-VlqwKLx8MOq9i1irnaSyKQ-1; Tue, 02 Feb 2021 14:37:44 -0500
X-MC-Unique: VlqwKLx8MOq9i1irnaSyKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D5E3189CD23;
        Tue,  2 Feb 2021 19:37:43 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E26460C66;
        Tue,  2 Feb 2021 19:37:39 +0000 (UTC)
Date:   Tue, 2 Feb 2021 14:37:37 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 1/7] xfs: rename `new' to `delta' in
 xfs_growfs_data_private()
Message-ID: <20210202193737.GL3336100@bfoster>
References: <20210126125621.3846735-1-hsiangkao@redhat.com>
 <20210126125621.3846735-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126125621.3846735-2-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:56:15PM +0800, Gao Xiang wrote:
> It actually means the delta block count of growfs. Rename it in order
> to make it clear. Also introduce nb_div to avoid reusing `delta`.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---

Looks reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 959ce91a3755..62600d78bbf1 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -32,8 +32,8 @@ xfs_growfs_data_private(
>  	int			error;
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
> -	xfs_rfsblock_t		nb, nb_mod;
> -	xfs_rfsblock_t		new;
> +	xfs_rfsblock_t		nb, nb_div, nb_mod;
> +	xfs_rfsblock_t		delta;
>  	xfs_agnumber_t		oagcount;
>  	xfs_trans_t		*tp;
>  	struct aghdr_init_data	id = {};
> @@ -50,16 +50,16 @@ xfs_growfs_data_private(
>  		return error;
>  	xfs_buf_relse(bp);
>  
> -	new = nb;	/* use new as a temporary here */
> -	nb_mod = do_div(new, mp->m_sb.sb_agblocks);
> -	nagcount = new + (nb_mod != 0);
> +	nb_div = nb;
> +	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
> +	nagcount = nb_div + (nb_mod != 0);
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
>  		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
>  		if (nb < mp->m_sb.sb_dblocks)
>  			return -EINVAL;
>  	}
> -	new = nb - mp->m_sb.sb_dblocks;
> +	delta = nb - mp->m_sb.sb_dblocks;
>  	oagcount = mp->m_sb.sb_agcount;
>  
>  	/* allocate the new per-ag structures */
> @@ -89,7 +89,7 @@ xfs_growfs_data_private(
>  	INIT_LIST_HEAD(&id.buffer_list);
>  	for (id.agno = nagcount - 1;
>  	     id.agno >= oagcount;
> -	     id.agno--, new -= id.agsize) {
> +	     id.agno--, delta -= id.agsize) {
>  
>  		if (id.agno == nagcount - 1)
>  			id.agsize = nb -
> @@ -110,8 +110,8 @@ xfs_growfs_data_private(
>  	xfs_trans_agblocks_delta(tp, id.nfree);
>  
>  	/* If there are new blocks in the old last AG, extend it. */
> -	if (new) {
> -		error = xfs_ag_extend_space(mp, tp, &id, new);
> +	if (delta) {
> +		error = xfs_ag_extend_space(mp, tp, &id, delta);
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> @@ -143,7 +143,7 @@ xfs_growfs_data_private(
>  	 * If we expanded the last AG, free the per-AG reservation
>  	 * so we can reinitialize it with the new size.
>  	 */
> -	if (new) {
> +	if (delta) {
>  		struct xfs_perag	*pag;
>  
>  		pag = xfs_perag_get(mp, id.agno);
> -- 
> 2.27.0
> 

