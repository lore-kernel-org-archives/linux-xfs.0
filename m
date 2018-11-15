Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728634AbeKOT54 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 14:57:56 -0500
Date: Thu, 15 Nov 2018 01:50:50 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix shared extent data corruption due to missing
 cow reservation
Message-ID: <20181115095050.GB10264@infradead.org>
References: <20181113170819.15220-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181113170819.15220-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 13, 2018 at 12:08:19PM -0500, Brian Foster wrote:
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index ecdb086bc23e..c56bdbfcf7ae 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -296,6 +296,7 @@ xfs_reflink_reserve_cow(
>  	if (error)
>  		return error;
>  
> +	xfs_trim_extent(imap, got.br_startoff, got.br_blockcount);
>  	trace_xfs_reflink_cow_alloc(ip, &got);
>  	return 0;

It would be kinda nice to have a comment explaining this trimming,
and a goto label to share it with the case where we find existing
delalloc reservations.

That being said my always_cow series totally reshuffles this area, so
it might not be worth to spend the effort here, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>
