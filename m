Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FBCC4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FF420756
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 16:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYvoYPLN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728952AbgJEQTk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53061 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728950AbgJEQTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 12:19:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601914774;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GPqQNN/3Bnl1TExIliEelC2U+9nJ6S+bABKkRxsMgTU=;
        b=PYvoYPLNJlUciok1WChtPnw2ARuNVBTushXuDV3tuK2bDlqyMHPfZP9E3VBX3wD1Sww9JN
        DJq1CSzeDitbAgjy5Xq7frJ3s8HECuwOc28x0K/tVAmki1BmjzHGqiHGz1uLzLr5WAiixw
        V+3sVjFBhxwWbvHSY2hHnkE7LiAoRV0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283--Y8wjlo9MWyIbG1Yf7l3tA-1; Mon, 05 Oct 2020 12:19:32 -0400
X-MC-Unique: -Y8wjlo9MWyIbG1Yf7l3tA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 423D210BBEF4;
        Mon,  5 Oct 2020 16:19:31 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2C5019C4F;
        Mon,  5 Oct 2020 16:19:30 +0000 (UTC)
Date:   Mon, 5 Oct 2020 12:19:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v3.2 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20201005161928.GA6539@bfoster>
References: <160140142711.830434.5161910313856677767.stgit@magnolia>
 <160140144017.830434.9012644788797432565.stgit@magnolia>
 <20201004190939.GB49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201004190939.GB49547@magnolia>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 04, 2020 at 12:09:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In most places in XFS, we have a specific order in which we gather
> resources: grab the inode, allocate a transaction, then lock the inode.
> xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> consistent.  This also makes the error bailout code a bit less weird.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
> v3.2: don't remove the iunlock/irele if the defer commit succeeds
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_item.c |   41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index c1f2cc3c42cb..852411568d14 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -475,25 +475,26 @@ xfs_bui_item_recover(
>  	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
>  		return -EFSCORRUPTED;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> -			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> -	if (error)
> -		return error;
> -
> -	budp = xfs_trans_get_bud(tp, buip);
> -
>  	/* Grab the inode. */
> -	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
>  	if (error)
> -		goto err_inode;
> +		return error;
>  
> -	error = xfs_qm_dqattach_locked(ip, false);
> +	error = xfs_qm_dqattach(ip);
>  	if (error)
> -		goto err_inode;
> +		goto err_rele;
>  
>  	if (VFS_I(ip)->i_nlink == 0)
>  		xfs_iflags_set(ip, XFS_IRECOVERY);
>  
> +	/* Allocate transaction and do the work. */
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> +			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> +	if (error)
> +		goto err_rele;
> +
> +	budp = xfs_trans_get_bud(tp, buip);
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
>  	count = bmap->me_len;
> @@ -501,7 +502,7 @@ xfs_bui_item_recover(
>  			whichfork, bmap->me_startoff, bmap->me_startblock,
>  			&count, state);
>  	if (error)
> -		goto err_inode;
> +		goto err_cancel;
>  
>  	if (count > 0) {
>  		ASSERT(bui_type == XFS_BMAP_UNMAP);
> @@ -512,17 +513,21 @@ xfs_bui_item_recover(
>  		xfs_bmap_unmap_extent(tp, ip, &irec);
>  	}
>  
> +	/* Commit transaction, which frees the transaction. */
>  	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> +	if (error)
> +		goto err_unlock;
> +
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	xfs_irele(ip);
> -	return error;
> +	return 0;
>  
> -err_inode:
> +err_cancel:
>  	xfs_trans_cancel(tp);
> -	if (ip) {
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -		xfs_irele(ip);
> -	}
> +err_unlock:
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +err_rele:
> +	xfs_irele(ip);
>  	return error;
>  }
>  
> 

