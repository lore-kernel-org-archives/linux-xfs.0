Return-Path: <SRS0=UH25=7B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFB0C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E9A120657
	for <linux-xfs@archiver.kernel.org>; Tue, 19 May 2020 12:46:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JxxDnVap"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgESMqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 May 2020 08:46:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35130 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727077AbgESMqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 08:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589892360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Se8PzoSspuJqVLETUVuDHKFdN4jGDeLW5tYnb75RZLs=;
        b=JxxDnVapxPAnPG+oylb2iMvZsxxe5cw53iK8A4DnYS0pavPwyhBYXk1ziCEs8shF5iwVez
        qtDg3biIEbnvWm6P58I3zUOAJ2TfHRENN2EccaT7hO6gWV4Xijb9fyzuHftF4Rg/UUId3x
        mwXbd0vLHmyecfmO11DXTe3q8yh1dNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-VH0v_ZBqN5257jnzvN1z9g-1; Tue, 19 May 2020 08:45:56 -0400
X-MC-Unique: VH0v_ZBqN5257jnzvN1z9g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96049105251E;
        Tue, 19 May 2020 12:45:55 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F14725799C;
        Tue, 19 May 2020 12:45:54 +0000 (UTC)
Date:   Tue, 19 May 2020 08:45:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH 1/3] xfs: force writes to delalloc regions to unwritten
Message-ID: <20200519124553.GA23387@bfoster>
References: <158984934500.619853.3585969653869086436.stgit@magnolia>
 <158984935136.619853.1558687512700172480.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158984935136.619853.1558687512700172480.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 05:49:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When writing to a delalloc region in the data fork, commit the new
> allocations (of the da reservation) as unwritten so that the mappings
> are only marked written once writeback completes successfully.  This
> fixes the problem of stale data exposure if the system goes down during
> targeted writeback of a specific region of a file, as tested by
> generic/042.
> 

We could probably add generic/042 into the auto group once this patch
lands.

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |   28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fda13cd7add0..825d170e1503 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
...
> @@ -4611,8 +4601,24 @@ xfs_bmapi_convert_delalloc(
>  	bma.offset = bma.got.br_startoff;
>  	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
>  	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
> +
> +	/*
> +	 * When we're converting the delalloc reservations backing dirty pages
> +	 * in the page cache, we must be careful about how we create the new
> +	 * extents:
> +	 *
> +	 * New CoW fork extents are created unwritten, turned into real extents
> +	 * when we're about to write the data to disk, and mapped into the data
> +	 * fork after the write finishes.  End of story.
> +	 *
> +	 * New data fork extents must be mapped in as unwritten and converted
> +	 * to real extents after the write succeeds to avoid exposing stale
> +	 * disk contents if we crash.
> +	 */
>  	if (whichfork == XFS_COW_FORK)
>  		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
> +	else
> +		bma.flags = XFS_BMAPI_PREALLOC;

The following seems a bit cleaner:

	bma.flags = XFS_BMAPI_PREALLOC;
	if (whichfork == XFS_COW_FORK)
		bma.flags |= XFS_BMAPI_COWFORK;

... but nit aside, LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  
>  	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
>  		bma.prev.br_startoff = NULLFILEOFF;
> 

