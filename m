Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40090 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbfARLuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Jan 2019 06:50:35 -0500
Date: Fri, 18 Jan 2019 03:50:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 3/5] xfs: validate writeback mapping using data fork
 seq counter
Message-ID: <20190118115034.GB7807@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117192004.49346-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 02:20:02PM -0500, Brian Foster wrote:
> The writeback code caches the current extent mapping across multiple
> xfs_do_writepage() calls to avoid repeated lookups for sequential
> pages backed by the same extent. This is known to be slightly racy
> with extent fork changes in certain difficult to reproduce
> scenarios. The cached extent is trimmed to within EOF to help avoid
> the most common vector for this problem via speculative
> preallocation management, but this is a band-aid that does not
> address the fundamental problem.
> 
> Now that we have an xfs_ifork sequence counter mechanism used to
> facilitate COW writeback, we can use the same mechanism to validate
> consistency between the data fork and cached writeback mappings. On
> its face, this is somewhat of a big hammer approach because any
> change to the data fork invalidates any mapping currently cached by
> a writeback in progress regardless of whether the data fork change
> overlaps with the range under writeback. In practice, however, the
> impact of this approach is minimal in most cases.
> 
> First, data fork changes (delayed allocations) caused by sustained
> sequential buffered writes are amortized across speculative
> preallocations. This means that a cached mapping won't be
> invalidated by each buffered write of a common file copy workload,
> but rather only on less frequent allocation events. Second, the
> extent tree is always entirely in-core so an additional lookup of a
> usable extent mostly costs a shared ilock cycle and in-memory tree
> lookup. This means that a cached mapping reval is relatively cheap
> compared to the I/O itself. Third, spurious invalidations don't
> impact ioend construction. This means that even if the same extent
> is revalidated multiple times across multiple writepage instances,
> we still construct and submit the same size ioend (and bio) if the
> blocks are physically contiguous.
> 
> Update struct xfs_writepage_ctx with a new field to hold the
> sequence number of the data fork associated with the currently
> cached mapping. Check the wpc seqno against the data fork when the
> mapping is validated and reestablish the mapping whenever the fork
> has changed since the mapping was cached. This ensures that
> writeback always uses a valid extent mapping and thus prevents lost
> writebacks and stale delalloc block problems.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_aops.c  | 60 ++++++++++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_iomap.c |  5 ++--
>  2 files changed, 49 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index d9048bcea49c..649e4ad76add 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -29,6 +29,7 @@
>  struct xfs_writepage_ctx {
>  	struct xfs_bmbt_irec    imap;
>  	unsigned int		io_type;
> +	unsigned int		data_seq;
>  	unsigned int		cow_seq;
>  	struct xfs_ioend	*ioend;
>  };
> @@ -301,6 +302,42 @@ xfs_end_bio(
>  		xfs_destroy_ioend(ioend, blk_status_to_errno(bio->bi_status));
>  }
>  
> +/*
> + * Fast revalidation of the cached writeback mapping. Return true if the current
> + * mapping is valid, false otherwise.
> + */
> +static bool
> +xfs_imap_valid(
> +	struct xfs_writepage_ctx	*wpc,
> +	struct xfs_inode		*ip,
> +	xfs_fileoff_t			offset_fsb)
> +{
> +	/*
> +	 * If this is a COW mapping, it is sufficient to check that the mapping
> +	 * covers the offset. Be careful to check this first because the caller
> +	 * can revalidate a COW mapping without updating the data seqno.
> +	 */
> +	if (offset_fsb < wpc->imap.br_startoff ||
> +	    offset_fsb >= wpc->imap.br_startoff + wpc->imap.br_blockcount)
> +		return false;
> +	if (wpc->io_type == XFS_IO_COW)
> +		return true;

Maybe the comment should move below the first range check? 

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
