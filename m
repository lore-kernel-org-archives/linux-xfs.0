Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51670 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVABK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 20:01:10 -0400
Date: Fri, 21 Jun 2019 16:58:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 03/11] xfs: skip small alloc cntbt logic on NULL cursor
Message-ID: <20190621235848.GB5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190522180546.17063-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:38PM -0400, Brian Foster wrote:
> The small allocation helper is implemented in a way that is fairly
> tightly integrated to the existing allocation algorithms. It expects
> a cntbt cursor beyond the end of the tree, attempts to locate the
> last record in the tree and only attempts an AGFL allocation if the
> cntbt is empty.
> 
> The upcoming generic algorithm doesn't rely on the cntbt processing
> of this function. It will only call this function when the cntbt
> doesn't have a big enough extent or is empty and thus AGFL
> allocation is the only remaining option. Tweak
> xfs_alloc_ag_vextent_small() to handle a NULL cntbt cursor and skip
> the cntbt logic. This facilitates use by the existing allocation
> code and new code that only requires an AGFL allocation attempt.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index b345fe771c54..436f8eb0bc4c 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -713,9 +713,16 @@ xfs_alloc_ag_vextent_small(
>  	int			error = 0;
>  	xfs_agblock_t		fbno = NULLAGBLOCK;
>  	xfs_extlen_t		flen = 0;
> -	int			i;
> +	int			i = 0;
>  
> -	error = xfs_btree_decrement(ccur, 0, &i);
> +	/*
> +	 * If a cntbt cursor is provided, try to allocate the largest record in
> +	 * the tree. Try the AGFL if the cntbt is empty, otherwise fail the
> +	 * allocation. Make sure to respect minleft even when pulling from the
> +	 * freelist.
> +	 */
> +	if (ccur)
> +		error = xfs_btree_decrement(ccur, 0, &i);
>  	if (error)
>  		goto error;
>  	if (i) {
> -- 
> 2.17.2
> 
