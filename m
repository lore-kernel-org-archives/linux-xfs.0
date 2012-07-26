Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFHt8C046798 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:17:55 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id Qpd1rTRCDfF7EGn5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 08:17:54 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by rcsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id q6QFHqnE019096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:17:53 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	q6QFHqR5012329
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 15:17:52 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	q6QFHqrA016838 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:17:52 -0500
Message-ID: <50115F63.5060405@oracle.com>
Date: Thu, 26 Jul 2012 23:16:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/4]xfs: Introduce a new function to find the desired
	type of offset from page cache
References: <50110629.4090304@oracle.com>
In-Reply-To: <50110629.4090304@oracle.com>
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 07/26/2012 04:56 PM, Jeff Liu wrote:

> This function is called by xfs_seek_data() and xfs_seek_hole() to find
> the desired offset from page cache.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_file.c |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 203 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 98642cf..43f5e61 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -36,6 +36,7 @@
>  
>  #include <linux/dcache.h>
>  #include <linux/falloc.h>
> +#include <linux/pagevec.h>
>  
>  static const struct vm_operations_struct xfs_file_vm_ops;
>  
> @@ -966,6 +967,208 @@ xfs_vm_page_mkwrite(
>  	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
>  }
>  
> +/*
> + * This type is designed to indicate the type of offset we would like
> + * to search from page cache for either xfs_seek_data() or xfs_seek_hole().
> + */
> +enum {
> +	HOLE_OFF = 0,
> +	DATA_OFF,
> +};
> +
> +/*
> + * This routine is called to find out and return a data or hole offset
> + * from the page cache for unwritten extents according to the desired
> + * type for xfs_seek_data() or xfs_seek_hole().
> + *
> + * The argument offset is used to tell where we start to search from the
> + * page cache, and it will be filled with the desired type of offset if
> + * it was found, or it will keep unchanged.  map is used to figure out
> + * the end points of the range to lookup pages.
> + */
> +STATIC bool
> +xfs_find_get_desired_pgoff(
> +	struct inode		*inode,
> +	struct xfs_bmbt_irec	*map,
> +	unsigned int		type,
> +	loff_t			*offset)
> +{
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct pagevec		pvec;
> +	pgoff_t			index;
> +	pgoff_t			end;
> +	loff_t			endoff;
> +	loff_t			coff = *offset; /* current search offset */
> +	bool			found = false;
> +
> +	pagevec_init(&pvec, 0);
> +	index = XFS_FSB_TO_B(mp, XFS_B_TO_FSBT(mp, coff)) >> PAGE_CACHE_SHIFT;
> +
> +	/* The end offset to search for */
> +	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
> +	end = endoff >> PAGE_CACHE_SHIFT;
> +
> +	do {
> +		unsigned int	i;
> +		unsigned	nr_pages;
> +		int		want = min_t(pgoff_t, end - index,
> +					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
> +
> +		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
> +					  want);
> +		/*
> +		 * No page mapped into given range.  If we are searching holes
> +		 * and if this is the first time we got into the loop, it means
> +		 * that the given offset is landed in a hole and return ture.
> +		 *
> +		 * If we have already stepped through some block buffers to find
> +		 * holes but those buffers are all contains data, in this case,
> +		 * the current search offset is already aligned to block buffer
> +		 * unit boundary and pointed to the end of the last mapped page.
> +		 * If it's location is less than the end range given for search,
> +		 * that means there should be a hole between them, so return the
> +		 * current search offset if we are searching hole.
> +		 */
> +		if (nr_pages == 0) {
> +			if (type == HOLE_OFF) {
> +				if (coff == *offset)
> +					found = true;
> +				if (coff < endoff) {
> +					found = true;
> +					*offset = coff;
> +				}
> +			}
> +			/* Search data but nothing found */
> +			break;
> +		}
> +
> +		/*
> +		 * At least we found one page.  If this the first time we step
> +		 * into the loop, and if the first page index offset is greater
> +		 * than the given search offset, a hole was found, return true
> +		 * if we are searching holes.
> +		 */
> +		if ((type == HOLE_OFF) && (coff == *offset)) {
> +			if (coff < pvec.pages[0]->index << PAGE_CACHE_SHIFT) {
> +				found = true;
> +				break;
> +			}
> +		}
> +
> +		for (i = 0; i < nr_pages; i++) {
> +			struct page		*page = pvec.pages[i];
> +			struct buffer_head	*bh;
> +			struct buffer_head	*head;
> +			xfs_fileoff_t		last;
> +
> +			/*
> +			 * Page index is out of range, we need to deal with
> +			 * hole search condition in paticular if that is the
> +			 * desired type for the lookup.
> +			 * stepping into the block buffer checkup, it probably
> +			 * means that there is no page mapped at all in the
> +			 * specified range to search, so we found a hole.
> +			 * If we have already done some block buffer checking
> +			 * and found one or more data buffers before, in this
> +			 * case, the coff is already updated and it point to
> +			 * the end of the last data buffer, so the left range
> +			 * behind it might be a hole.  In either case, we will
> +			 * return the coff to indicate a hole's location because
> +			 * it must be greater than or equal to the search start.
> +			 */
> +			if (page->index > end) {
> +				if (type == HOLE_OFF && coff < endoff) {
> +					*offset = coff;
> +					found = true;
> +				}
> +				goto out;
> +			}
> +
> +			if (!trylock_page(page))
> +				goto out;
> +
> +			if (!page_has_buffers(page)) {
> +				unlock_page(page);
> +				continue;
> +			}
> +
> +			last = XFS_B_TO_FSBT(mp,
> +					     page->index << PAGE_CACHE_SHIFT);
> +			bh = head = page_buffers(page);
> +			do {
> +				off_t		lastoff = 0;
> +
> +				/*
> +				 * The 1st block buffer offset in current page.
> +				 */
> +				lastoff = XFS_FSB_TO_B(mp, last);
> +				/*
> +				 * An extent in XFS_EXT_UNWRITTEN has disk
> +				 * blocks already mapped to it, but no data
> +				 * has been committed to them yet.  If it has
> +				 * dirty data in the page cache it can be
> +				 * identified by having BH_Unwritten set in
> +				 * each buffers.  Also, the buffer head state
> +				 * might be in BH_Uptodate too if the buffer
> +				 * writeback procedure was fired, we have to
> +				 * check it up as well.
> +				 */
> +				if (buffer_unwritten(bh) ||
> +				    buffer_uptodate(bh)) {
> +					/*
> +					 * Found a data buffer and we are
> +					 * searching data, great.
> +					 */
> +					if (type == DATA_OFF)
> +						found = true;
> +				} else {
> +					/*
> +					 * Nothing was found and we are
> +					 * searching holes, great.
> +					 */
> +					if (type == HOLE_OFF)
> +						found = true;
> +				}
> +				if (found) {
> +					/*
> +					 * Return if we found the desired
> +					 * page offset.
> +					 */
> +					*offset = max_t(loff_t, coff, lastoff);
> +					unlock_page(page);
> +					goto out;
> +				}
> +				/*
> +				 * We either searching data but nothing was
> +				 * found, or searching hole but found a data
> +				 * block buffer.  In either case, probably the
> +				 * next block buffer is what we are desired,
> +				 * so that we need to round up the current
> +				 * offset to it.
> +				 */
> +				coff = round_up(lastoff + 1, bh->b_size);
> +				last++;
> +			} while ((bh = bh->b_this_page) != head);
> +			unlock_page(page);
> +		}
> +
> +		/*
> +		 * If the number of returned pages less than our desired,
> +		 * there should no more pages mapped, search done.
> +		 */
> +		if (nr_pages < want)
> +			break;

Just found an issue here, should check the 'nr_pages < want' condition
for searching hole, I'll re-send this patch set a little while.
Sorry for the noise!

-Jeff

> +
> +		index = pvec.pages[i - 1]->index + 1;
> +		pagevec_release(&pvec);
> +	} while (index < end);
> +
> +out:
> +	pagevec_release(&pvec);
> +	return found;
> +}
> +
>  STATIC loff_t
>  xfs_seek_data(
>  	struct file		*file,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
