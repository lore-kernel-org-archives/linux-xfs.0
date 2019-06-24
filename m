Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbfFXOyJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 10:54:09 -0400
Date: Mon, 24 Jun 2019 07:53:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/12] xfs: fix a comment typo in xfs_submit_ioend
Message-ID: <20190624145341.GG5387@magnolia>
References: <20190624055253.31183-1-hch@lst.de>
 <20190624055253.31183-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624055253.31183-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 24, 2019 at 07:52:44AM +0200, Christoph Hellwig wrote:
> The fail argument is long gone, update the comment.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 9cceb90e77c5..dc60aec0c5a7 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -626,7 +626,7 @@ xfs_map_blocks(
>   * reference to the ioend to ensure that the ioend completion is only done once
>   * all bios have been submitted and the ioend is really done.
>   *
> - * If @fail is non-zero, it means that we have a situation where some part of
> + * If @status is non-zero, it means that we have a situation where some part of
>   * the submission process has failed after we have marked paged for writeback
>   * and unlocked them. In this situation, we need to fail the bio and ioend
>   * rather than submit it to IO. This typically only happens on a filesystem
> -- 
> 2.20.1
> 
