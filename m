Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37780 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754629AbcJQPDm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 11:03:42 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F110F43A55
        for <linux-xfs@vger.kernel.org>; Mon, 17 Oct 2016 15:03:41 +0000 (UTC)
Date: Mon, 17 Oct 2016 10:03:39 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfs: remove pointless error goto in xfs_bmap_remap_alloc
Message-ID: <20161017150339.GA25408@redhat.com>
References: <3f9689e1-3e1a-c874-f6ae-88ac40f9cde1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9689e1-3e1a-c874-f6ae-88ac40f9cde1@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Oct 17, 2016 at 08:54:25AM -0500, Eric Sandeen wrote:
> The commit:
> 
> f65306ea xfs: map an inode's offset to an exact physical block
> 
> added a pointless error0: target; remove it.
> 
> Addresses-Coverity-Id: 1373865
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index c27344c..861cf8d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3974,9 +3974,6 @@ xfs_bmap_remap_alloc(
>  	 * allocating, so skip that check by pretending to be freeing.
>  	 */
>  	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
> -	if (error)
> -		goto error0;
> -error0:
>  	xfs_perag_put(args.pag);
>  	if (error)
>  		trace_xfs_bmap_remap_alloc_error(ap->ip, error, _RET_IP_);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
