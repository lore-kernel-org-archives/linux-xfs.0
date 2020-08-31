Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F37C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F33720866
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oh+Y9t/2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbgHaTG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:06:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56688 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727993AbgHaTG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JhoOjPhBio/b8ca0FXsQmNeBSk1DQocK7Myi0ATQ65I=;
        b=Oh+Y9t/2XSXnYNnM12UWHw6EpSYCsRAmdyGYd6pj9vjJHgHM2VOG6TrFu+/wFqClc2x4eZ
        5Xi9YiwlXtxDShSE4+2A/4p8QIL96+2LPDIRPFkc22MguF4AHGMR7ywzmQrhaWVJdxh/Wo
        GTDyu7ydROC3MDk10M1P/iU2Zeg4WkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335--pHzOAoiNNOAU7bWq1Yn7w-1; Mon, 31 Aug 2020 15:06:56 -0400
X-MC-Unique: -pHzOAoiNNOAU7bWq1Yn7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F2631074642;
        Mon, 31 Aug 2020 19:06:55 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E3C805C1BB;
        Mon, 31 Aug 2020 19:06:54 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:06:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: support inode btree blockcounts in online scrub
Message-ID: <20200831190653.GE12035@bfoster>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858220970.3058056.11436591208519179894.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159858220970.3058056.11436591208519179894.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:36:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add the necessary bits to the online scrub code to check the inode btree
> counters when enabled.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks reasonable:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/scrub/agheader.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> 
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index e9bcf1faa183..ae8e2e0ac64a 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -781,6 +781,35 @@ xchk_agi_xref_icounts(
>  		xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
>  }
>  
> +/* Check agi_[fi]blocks against tree size */
> +static inline void
> +xchk_agi_xref_fiblocks(
> +	struct xfs_scrub	*sc)
> +{
> +	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
> +	xfs_agblock_t		blocks;
> +	int			error = 0;
> +
> +	if (!xfs_sb_version_hasinobtcounts(&sc->mp->m_sb))
> +		return;
> +
> +	if (sc->sa.ino_cur) {
> +		error = xfs_btree_count_blocks(sc->sa.ino_cur, &blocks);
> +		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
> +			return;
> +		if (blocks != be32_to_cpu(agi->agi_iblocks))
> +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> +	}
> +
> +	if (sc->sa.fino_cur) {
> +		error = xfs_btree_count_blocks(sc->sa.fino_cur, &blocks);
> +		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
> +			return;
> +		if (blocks != be32_to_cpu(agi->agi_fblocks))
> +			xchk_block_xref_set_corrupt(sc, sc->sa.agi_bp);
> +	}
> +}
> +
>  /* Cross-reference with the other btrees. */
>  STATIC void
>  xchk_agi_xref(
> @@ -804,6 +833,7 @@ xchk_agi_xref(
>  	xchk_agi_xref_icounts(sc);
>  	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
>  	xchk_xref_is_not_shared(sc, agbno, 1);
> +	xchk_agi_xref_fiblocks(sc);
>  
>  	/* scrub teardown will take care of sc->sa for us */
>  }
> 

