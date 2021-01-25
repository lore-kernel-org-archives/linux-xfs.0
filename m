Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA08CC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93D4322583
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jan 2021 18:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbhAYSPm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:15:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731214AbhAYSPk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jan 2021 13:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611598453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9aiOSMoFJWu8qbhYa3wTLZqRJl16rQM2+e9i9UHkfp8=;
        b=Ma+tGSrQppyBBQGaqXxaEiwPodn1PS4S/axf/1m+zkplr2oujkiL3/DmKPRxf8GnfwAHFO
        RYKyL8xXDQcXn/lPZykxQ20YssSkFyKpHJ97tNK+r/VY+24GiyeyDGVF7QuDIVsu8I/7sI
        DvkClw6hEM0lpnJDr/6k63GcyGt+P4s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-W9yAwtJePEG0qiEeJe1i1Q-1; Mon, 25 Jan 2021 13:14:09 -0500
X-MC-Unique: W9yAwtJePEG0qiEeJe1i1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8941F8144E0;
        Mon, 25 Jan 2021 18:14:08 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E06191981B;
        Mon, 25 Jan 2021 18:14:07 +0000 (UTC)
Date:   Mon, 25 Jan 2021 13:14:06 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210125181406.GH2047559@bfoster>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793080.2171939.11486862758521454210.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142793080.2171939.11486862758521454210.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 23, 2021 at 10:52:10AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't stall the cowblocks scan on a locked inode if we possibly can.
> We'd much rather the background scanner keep moving.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index c71eb15e3835..89f9e692fde7 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
>  	void			*args)
>  {
>  	struct xfs_eofblocks	*eofb = args;
> +	bool			wait;
>  	int			ret = 0;
>  
> +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> +
>  	if (!xfs_prep_free_cowblocks(ip))
>  		return 0;
>  
>  	if (!xfs_inode_matches_eofb(ip, eofb))
>  		return 0;
>  
> -	/* Free the CoW blocks */
> -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> +	/*
> +	 * If the caller is waiting, return -EAGAIN to keep the background
> +	 * scanner moving and revisit the inode in a subsequent pass.
> +	 */
> +	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +		if (wait)
> +			return -EAGAIN;
> +		return 0;
> +	}
> +	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
> +		if (wait)
> +			ret = -EAGAIN;
> +		goto out_iolock;
> +	}

Hmm.. I'd be a little concerned over this allowing a scan to repeat
indefinitely with a competing workload because a restart doesn't carry
over any state from the previous scan. I suppose the
xfs_prep_free_cowblocks() checks make that slightly less likely on a
given file, but I more wonder about a scenario with a large set of
inodes in a particular AG with a sufficient amount of concurrent
activity. All it takes is one trylock failure per scan to have to start
the whole thing over again... hm?

Brian

>  
>  	/*
>  	 * Check again, nobody else should be able to dirty blocks or change
> @@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
>  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
>  
>  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> +out_iolock:
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  
>  	return ret;
> 

