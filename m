Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C6AC4361B
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 13:58:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB7B22B2A
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Dec 2020 13:58:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgLDN6K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Dec 2020 08:58:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727855AbgLDN6J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Dec 2020 08:58:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607090203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nkbT2ItngEnxCQGqhh8HsNXcgtK3tZjo4rdQcr16H38=;
        b=ZCcnuLc87iv8/A9TFEJpzkKl2iTmbS+PZzGlBhYMwgc7KtZZ0JpKkRTmzJZNjOe2pHEL8Q
        3fS0WkHq5iuhufOdBHOZ2CYGCFyAQS+O6MHM7ZyhJa2o+ZBMQ/4mSHGdku37jcPaBtgTI4
        MulQo9484zjjb41MwOjWIktml1/6v0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-jJrLV9HUOLuzM3NznXQmNQ-1; Fri, 04 Dec 2020 08:56:41 -0500
X-MC-Unique: jJrLV9HUOLuzM3NznXQmNQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A36EF800D55;
        Fri,  4 Dec 2020 13:56:40 +0000 (UTC)
Received: from bfoster (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33E8460861;
        Fri,  4 Dec 2020 13:56:40 +0000 (UTC)
Date:   Fri, 4 Dec 2020 08:56:38 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/10] xfs: improve the code that checks recovered bmap
 intent items
Message-ID: <20201204135638.GD1404170@bfoster>
References: <160704429410.734470.15640089119078502938.stgit@magnolia>
 <160704430659.734470.2948483798298982986.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160704430659.734470.2948483798298982986.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 03, 2020 at 05:11:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The code that validates recovered bmap intent items is kind of a mess --
> it doesn't use the standard xfs type validators, and it doesn't check
> for things that it should.  Fix the validator function to use the
> standard validation helpers and look for more types of obvious errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_bmap_item.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 555453d0e080..78346d47564b 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
...
> @@ -448,13 +442,19 @@ xfs_bui_validate(
>  		return false;
>  	}
>  
> -	if (startblock_fsb == 0 ||
> -	    bmap->me_len == 0 ||
> -	    inode_fsb == 0 ||
> -	    startblock_fsb >= mp->m_sb.sb_dblocks ||
> -	    bmap->me_len >= mp->m_sb.sb_agblocks ||
> -	    inode_fsb >= mp->m_sb.sb_dblocks ||
> -	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
> +	if (!xfs_verify_ino(mp, bmap->me_owner))
> +		return false;
> +
> +	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
> +		return false;
> +
> +	if (bmap->me_startblock + bmap->me_len <= bmap->me_startblock)
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, bmap->me_startblock))
> +		return false;
> +
> +	if (!xfs_verify_fsbno(mp, bmap->me_startblock + bmap->me_len - 1))
>  		return false;

If this is going to be a common pattern, I wonder if an
xfs_verify_extent() or some such helper that covers the above range
checks would be helpful. Regardless:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	return true;
> 

