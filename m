Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B772AC56201
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 00:31:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AACC207DE
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 00:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BuwArRLb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgJ1Wb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56382 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387895AbgJ1Wb0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 18:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603924285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7+jwzQF0mpu5S6XCR4XY493w936NSTbYPTr+dJlZ1qI=;
        b=BuwArRLbmw6iuZeYgXLefPZLn+UUt474Q9jLN9uaRlfwDUnRBkuQ4fyIZXurEKFfLgIJB0
        PIykk7R4ZCuO3mzFlhiWOOVISJe27PQHkKqBYH6JlxZuKcgYwCWGu5CSVB31HC097wvZXm
        qE4ptTXY26pWt5kqgqp4IX0T12PM59c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-ujEa2nnBPHyF-kvUAlRVZA-1; Wed, 28 Oct 2020 13:30:03 -0400
X-MC-Unique: ujEa2nnBPHyF-kvUAlRVZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 248C4108E1AD;
        Wed, 28 Oct 2020 17:30:02 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A275260BF1;
        Wed, 28 Oct 2020 17:30:01 +0000 (UTC)
Date:   Wed, 28 Oct 2020 13:29:59 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs_repair: check inode btree block counters in AGI
Message-ID: <20201028172959.GE1611922@bfoster>
References: <160375518573.880355.12052697509237086329.stgit@magnolia>
 <160375522427.880355.15446960142376313542.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160375522427.880355.15446960142376313542.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 26, 2020 at 04:33:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that both inode btree block counters in the AGI are correct.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/scan.c |   38 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 35 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 2a38ae5197c6..c826af7dee86 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
...
> @@ -2022,6 +2029,17 @@ scan_inobt(
>  			return;
>  	}
>  
> +	switch (magic) {
> +	case XFS_FIBT_MAGIC:
> +	case XFS_FIBT_CRC_MAGIC:
> +		ipriv->fino_blocks++;
> +		break;
> +	case XFS_IBT_MAGIC:
> +	case XFS_IBT_CRC_MAGIC:
> +		ipriv->ino_blocks++;
> +		break;
> +	}
> +

Is this intentionally not folded into the earlier magic switch
statement?

>  	/*
>  	 * check for btree blocks multiply claimed, any unknown/free state
>  	 * is ok in the bitmap block.
...
> @@ -2393,6 +2414,17 @@ validate_agi(
>  		}
>  	}
>  
> +	if (xfs_sb_version_hasinobtcounts(&mp->m_sb)) {
> +		if (be32_to_cpu(agi->agi_iblocks) != priv.ino_blocks)
> +			do_warn(_("bad inobt block count %u, saw %u\n"),
> +					priv.ino_blocks,
> +					be32_to_cpu(agi->agi_iblocks));

These two params are backwards (here and below), no?

Brian

> +		if (be32_to_cpu(agi->agi_fblocks) != priv.fino_blocks)
> +			do_warn(_("bad finobt block count %u, saw %u\n"),
> +					priv.fino_blocks,
> +					be32_to_cpu(agi->agi_fblocks));
> +	}
> +
>  	if (be32_to_cpu(agi->agi_count) != agcnts->agicount) {
>  		do_warn(_("agi_count %u, counted %u in ag %u\n"),
>  			 be32_to_cpu(agi->agi_count), agcnts->agicount, agno);
> 

