Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CEEC433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 028982064B
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YMYlMffS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgHaTGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:06:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727993AbgHaTGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:06:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b1TFDFO9vJgrHDZbk1c9szXSivT6WWJ+2/9fG1j3Icc=;
        b=YMYlMffSSVPQn2dbCMPON7B1J5FGPyQxOQ6GG2CaFMcMKJ8SmjUlKrTlYs0XRSrVicKH05
        4WKDuuu9yRo/8xUtPTZylTtGQOujTb2OXgSqY1st1LjopLcQI8V5JQg7whLqqe7J74f1qt
        LRNNgMKJj0fDdVqKJuL5rPOVHGV6K4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-9GYN2rM4PvSGYIuPF0V5eQ-1; Mon, 31 Aug 2020 15:06:49 -0400
X-MC-Unique: 9GYN2rM4PvSGYIuPF0V5eQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 157BB64080;
        Mon, 31 Aug 2020 19:06:48 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3C1A5C1BB;
        Mon, 31 Aug 2020 19:06:47 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:06:45 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: use the finobt block counts to speed up mount
 times
Message-ID: <20200831190645.GD12035@bfoster>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858220352.3058056.14870764546265114620.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159858220352.3058056.14870764546265114620.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:36:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we have reliable finobt block counts, use them to speed up the
> per-AG block reservation calculations at mount time.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ialloc_btree.c |   28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> index ee9d407ab9da..a5461091ba7b 100644
> --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> @@ -694,6 +694,28 @@ xfs_inobt_count_blocks(
>  	return error;
>  }
>  
> +/* Read finobt block count from AGI header. */
> +static int
> +xfs_finobt_read_blocks(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	*tp,
> +	xfs_agnumber_t		agno,
> +	xfs_extlen_t		*tree_blocks)
> +{
> +	struct xfs_buf		*agbp;
> +	struct xfs_agi		*agi;
> +	int			error;
> +
> +	error = xfs_ialloc_read_agi(mp, tp, agno, &agbp);
> +	if (error)
> +		return error;
> +
> +	agi = agbp->b_addr;
> +	*tree_blocks = be32_to_cpu(agi->agi_fblocks);
> +	xfs_trans_brelse(tp, agbp);
> +	return 0;
> +}
> +
>  /*
>   * Figure out how many blocks to reserve and how many are used by this btree.
>   */
> @@ -711,7 +733,11 @@ xfs_finobt_calc_reserves(
>  	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
>  		return 0;
>  
> -	error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO, &tree_len);
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb))
> +		error = xfs_finobt_read_blocks(mp, tp, agno, &tree_len);
> +	else
> +		error = xfs_inobt_count_blocks(mp, tp, agno, XFS_BTNUM_FINO,
> +				&tree_len);
>  	if (error)
>  		return error;
>  
> 

