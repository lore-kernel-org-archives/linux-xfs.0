Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36410 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932463AbdKFUTF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 15:19:05 -0500
Date: Mon, 6 Nov 2017 12:18:55 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: mark xfs_btree_check_lblock and
 xfs_btree_check_ptr static
Message-ID: <20171106201855.GH6244@magnolia>
References: <20171106143456.13567-1-hch@lst.de>
 <20171106143456.13567-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171106143456.13567-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 03:34:54PM +0100, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_btree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 994fc1c8c7c6..5f33adf8eecb 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -109,7 +109,7 @@ __xfs_btree_check_lblock(
>  }
>  
>  /* Check a long btree block header. */
> -int
> +static int
>  xfs_btree_check_lblock(
>  	struct xfs_btree_cur	*cur,
>  	struct xfs_btree_block	*block,
> @@ -239,7 +239,7 @@ xfs_btree_check_sptr(
>   * Check that a given (indexed) btree pointer at a certain level of a
>   * btree is valid and doesn't point past where it should.
>   */
> -int
> +static int
>  xfs_btree_check_ptr(
>  	struct xfs_btree_cur	*cur,
>  	union xfs_btree_ptr	*ptr,
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
