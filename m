Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AA0C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C0F22A83
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Jan 2021 17:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbhAKRe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 12:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbhAKRe2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 12:34:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB86229CA;
        Mon, 11 Jan 2021 17:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610386428;
        bh=rYLA10+aFN9VPFi+pMI7KUEcrsjjomOLRTJGd0KcYMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3RFrH/efVR9yHofouxdf/JgksgF8m1s66OXodcminCLClzX88b78jo8HLoAvmUGv
         +d31VMRPqaYZGrFAP4hYk7EqokE8IwDWCG591v9wIzoXWaIB/H/jrhZ44DAmoIKKm3
         2NYMD6DtjM2A+E+Px8leihdt028shx1X+q28hiTgbF/J9vSHGcVgCGHDb5C8wsc1p5
         4EZwqCcH8W8XsYDbTU0rM+mqDtZ8NJSOZVGI555hXGjK9A/gTQQXH9XylsWepZfd82
         N4BviY5J6IVKaqc70ZdIYwZ1zvnL8TiwDFpWhb45YfrOIPE1A+daQkbk409RW5SW5S
         wb23qa4OHpQrQ==
Date:   Mon, 11 Jan 2021 09:33:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/4] xfs: rename `new' to `delta' in
 xfs_growfs_data_private()
Message-ID: <20210111173347.GB1164246@magnolia>
References: <20210111132243.1180013-1-hsiangkao@redhat.com>
 <20210111132243.1180013-2-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111132243.1180013-2-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 09:22:40PM +0800, Gao Xiang wrote:
> It actually means the delta block count of growfs. Rename it in order
> to make it clear. Also introduce nb_div to avoid reusing `delta`.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks good now,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_fsops.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 5870db855e8b..6ad31e6b4a04 100644
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
