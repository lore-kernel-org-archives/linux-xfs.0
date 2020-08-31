Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F783C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F06820EDD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:07:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cMhI5r8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgHaTHU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:07:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727993AbgHaTHT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598900838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vGr7fNt9BJTkX3cAa98ZA31zBxgGsmAuYl/Z8Jid2tc=;
        b=cMhI5r8hC4MKUfXveGr7xuFi0mYbMGfNFOEwuzP80BxWMzJCX7WAYOqSEoem63pYBuMNe7
        YoW3F5vN8G75pdiuBcQcV/RhAqeXKJy1fDVd0e2uHrl0Sa1muBPheyQU7lKaLifZsAuj1x
        GU5xurLwbzDFVjFxgwGV27v9pH/OsBs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-d1U3mXUwOSSvPlg2P-C0Ew-1; Mon, 31 Aug 2020 15:07:16 -0400
X-MC-Unique: d1U3mXUwOSSvPlg2P-C0Ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16B5C8030A8;
        Mon, 31 Aug 2020 19:07:15 +0000 (UTC)
Received: from bfoster (ovpn-113-130.rdu2.redhat.com [10.10.113.130])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFCD978B35;
        Mon, 31 Aug 2020 19:07:14 +0000 (UTC)
Date:   Mon, 31 Aug 2020 15:07:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: support inode btree blockcounts in online repair
Message-ID: <20200831190712.GF12035@bfoster>
References: <159858219107.3058056.6897728273666872031.stgit@magnolia>
 <159858221586.3058056.4012330529904111156.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159858221586.3058056.4012330529904111156.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 27, 2020 at 07:36:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add the necessary bits to the online repair code to support logging the
> inode btree counters when rebuilding the btrees, and to support fixing
> the counters when rebuilding the AGI.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   16 +++++++++++++---
>  fs/xfs/scrub/agheader_repair.c   |   23 +++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 3 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
> index bca2ab1d4be9..efa8152a0139 100644
> --- a/fs/xfs/scrub/agheader_repair.c
> +++ b/fs/xfs/scrub/agheader_repair.c
> @@ -810,10 +810,33 @@ xrep_agi_calc_from_btrees(
>  	error = xfs_ialloc_count_inodes(cur, &count, &freecount);
>  	if (error)
>  		goto err;
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		xfs_agblock_t	blocks;
> +
> +		error = xfs_btree_count_blocks(cur, &blocks);
> +		if (error)
> +			goto err;
> +		agi->agi_iblocks = cpu_to_be32(blocks);
> +	}
>  	xfs_btree_del_cursor(cur, error);
>  
>  	agi->agi_count = cpu_to_be32(count);
>  	agi->agi_freecount = cpu_to_be32(freecount);
> +
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		xfs_agblock_t	blocks;
> +
> +		cur = xfs_inobt_init_cursor(mp, sc->tp, agi_bp, sc->sa.agno,
> +				XFS_BTNUM_FINO);
> +		if (error)
> +			goto err;
> +		error = xfs_btree_count_blocks(cur, &blocks);
> +		if (error)
> +			goto err;
> +		xfs_btree_del_cursor(cur, error);
> +		agi->agi_fblocks = cpu_to_be32(blocks);

Similar question as for patch 1 around using hasfinobt()...

Brian

> +	}
> +
>  	return 0;
>  err:
>  	xfs_btree_del_cursor(cur, error);
> 

