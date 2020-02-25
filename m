Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E621AC35E04
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:12:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAEA02084E
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 16:12:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UB+tOqr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgBYQMB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 11:12:01 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50889 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729206AbgBYQMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 11:12:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582647120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0LueULNPwZe5OXtTZrTIXk7A2oBck5hxwvLF6iMfDtk=;
        b=UB+tOqr1BYop2a5WeZC+XoRhwAufbb1P/gSw86Jjz6DesnxnHimm2f9M3RePvrlwVDUgmP
        KQOHBXZ7erp5R2/wyCMVWkNhI4BKLvww30pK/FwxKRWINscyCSwgkBzw8jUWe4uvpFSTVp
        aCZPovaK3IWg6XOx/2hNuQuv9UBsZkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-4sTx4yTwOSm0Y1w8aGZPQw-1; Tue, 25 Feb 2020 11:11:56 -0500
X-MC-Unique: 4sTx4yTwOSm0Y1w8aGZPQw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EDA5D1005514;
        Tue, 25 Feb 2020 16:11:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12B542718C;
        Tue, 25 Feb 2020 16:11:53 +0000 (UTC)
Date:   Tue, 25 Feb 2020 11:11:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Chandan Rajendra <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, amir73il@gmail.com
Subject: Re: [PATCH V4 RESEND 3/7] xfs: xfs_attr_calc_size: Calculate Bmbt
 blks only once
Message-ID: <20200225161152.GC54181@bfoster>
References: <20200224040044.30923-1-chandanrlinux@gmail.com>
 <20200224040044.30923-4-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224040044.30923-4-chandanrlinux@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 24, 2020 at 09:30:40AM +0530, Chandan Rajendra wrote:
> The number of Bmbt blocks that is required can be calculated only once by
> passing the sum of total number of dabtree blocks and remote blocks to
> XFS_NEXTENTADD_SPACE_RES() macro.
> 
> Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
> ---

According to the cover letter this is fixing a reservation calculation
issue, though the commit log kind of gives the impression it's a
refactor. Can you elaborate on what this fixes in the commit log?

Brian

>  fs/xfs/libxfs/xfs_attr.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 942ba552e0bdd..a708b142f69b6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -154,12 +154,10 @@ xfs_attr_calc_size(
>  	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
>  			args->valuelen, local);
>  	total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
> -	bmbt_blks = XFS_DAENTER_BMAPS(mp, XFS_ATTR_FORK);
>  	if (*local) {
>  		if (size > (args->geo->blksize / 2)) {
>  			/* Double split possible */
>  			total_dablks *= 2;
> -			bmbt_blks *= 2;
>  		}
>  		rmt_blks = 0;
>  	} else {
> @@ -168,10 +166,11 @@ xfs_attr_calc_size(
>  		 * make room for the attribute value itself.
>  		 */
>  		rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
> -		bmbt_blks += XFS_NEXTENTADD_SPACE_RES(mp, rmt_blks,
> -				XFS_ATTR_FORK);
>  	}
>  
> +	bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp, total_dablks + rmt_blks,
> +			XFS_ATTR_FORK);
> +
>  	return total_dablks + rmt_blks + bmbt_blks;
>  }
>  
> -- 
> 2.19.1
> 

