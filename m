Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbeJAVFH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:05:07 -0400
Date: Mon, 1 Oct 2018 10:27:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: fix fork selection in xfs_find_trim_cow_extent
Message-ID: <20181001142701.GH53694@bfoster>
References: <20181001123741.32005-1-hch@lst.de>
 <20181001123741.32005-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001123741.32005-7-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 05:37:40AM -0700, Christoph Hellwig wrote:
> We should want to write directly into the data fork for blocks that don't
> have an extent in the COW fork covering them yet.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_reflink.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 1e39a7d21c7e..ead35209ffae 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -369,9 +369,13 @@ xfs_find_trim_cow_extent(
>  	 * If we don't find an overlapping extent, trim the range we need to
>  	 * allocate to fit the hole we found.
>  	 */
> -	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got) ||
> -	    got.br_startoff > offset_fsb)
> +	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
> +		got.br_startoff = offset_fsb + count_fsb;
> +	if (got.br_startoff > offset_fsb) {
> +		xfs_trim_extent(imap, imap->br_startoff,
> +				got.br_startoff - imap->br_startoff);
>  		return xfs_reflink_trim_around_shared(ip, imap, shared);
> +	}
>  
>  	*shared = true;
>  	if (isnullstartblock(got.br_startblock)) {
> -- 
> 2.19.0
> 
