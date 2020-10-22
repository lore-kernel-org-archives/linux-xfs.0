Return-Path: <SRS0=jqsF=D5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B824C388F7
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 19:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E749924656
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Oct 2020 19:02:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FE6F80eO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369841AbgJVTCz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:02:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33213 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438462AbgJVTCy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Oct 2020 15:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603393373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=82JgajNHnhEQlCEhUKSdeIHi8Nlfl3yO5UUt6ec4Yeo=;
        b=FE6F80eOrtyDEdkbGpwJiIOoroHEIE7gR0xa+tBAnXS/M8ZFMmGW0UK2FAZBPZHT4FPP/n
        xx7T4Oaj+2prMR6MIv5Mkn9MZt7r4KbyCUKUhYEoDnSoC7ynwboOvdAEJAwW74Hu7CbWnf
        aB55gy8J22Y8zGeBYP89PQ+LrK2/THE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-0-XOxKyBP7Cfdggo4FkVnA-1; Thu, 22 Oct 2020 15:02:50 -0400
X-MC-Unique: 0-XOxKyBP7Cfdggo4FkVnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 898BB1006CAA;
        Thu, 22 Oct 2020 19:02:49 +0000 (UTC)
Received: from bfoster (ovpn-113-186.rdu2.redhat.com [10.10.113.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 343BD1002388;
        Thu, 22 Oct 2020 19:02:49 +0000 (UTC)
Date:   Thu, 22 Oct 2020 15:02:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: set xefi_discard when creating a deferred agfl free
 log intent item
Message-ID: <20201022190247.GA1376790@bfoster>
References: <20201022184649.GT9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022184649.GT9832@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 22, 2020 at 11:46:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we actually initialize xefi_discard when we're scheduling
> a deferred free of an AGFL block.  This was (eventually) found by the
> UBSAN while I was banging on realtime rmap problems, but it exists in
> the upstream codebase.  While we're at it, rearrange the structure to
> reduce the struct size from 64 to 56 bytes.
> 
> Fixes: fcb762f5de2e ("xfs: add bmapi nodiscard flag")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_alloc.c |    1 +
>  fs/xfs/libxfs/xfs_bmap.h  |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 852b536551b5..15640015be9d 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2467,6 +2467,7 @@ xfs_defer_agfl_block(
>  	new->xefi_startblock = XFS_AGB_TO_FSB(mp, agno, agbno);
>  	new->xefi_blockcount = 1;
>  	new->xefi_oinfo = *oinfo;
> +	new->xefi_skip_discard = false;
>  
>  	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index e1bd484e5548..6747e97a7949 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -52,9 +52,9 @@ struct xfs_extent_free_item
>  {
>  	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
>  	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
> +	bool			xefi_skip_discard;
>  	struct list_head	xefi_list;
>  	struct xfs_owner_info	xefi_oinfo;	/* extent owner */
> -	bool			xefi_skip_discard;
>  };
>  
>  #define	XFS_BMAP_MAX_NMAP	4
> 

