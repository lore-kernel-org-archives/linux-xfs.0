Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7A8DnOH036425 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 03:13:49 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id LdOOGT5n0tzXjJNq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Aug 2012 01:13:48 -0700 (PDT)
Message-ID: <5024C2B2.3010103@oracle.com>
Date: Fri, 10 Aug 2012 16:13:38 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/4] xfs: Introduce a new function to find the desired
	type of offset from page cache
References: <501B6B6F.2090101@oracle.com> <20120809232448.GA2877@dastard>
In-Reply-To: <20120809232448.GA2877@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 08/10/12 07:24, Dave Chinner wrote:
> On Fri, Aug 03, 2012 at 02:10:55PM +0800, Jeff Liu wrote:
>> Introduce helpers to probe data or hole offset from page cache for unwritten extents.
> .....
>> + * Lookup the desired type of offset from the given page.
>> + *
>> + * On success, return true and the offset argument will point to the
>> + * searched offset.  Otherwise this function will return false and
> I'm not sure what the "searched offset" is. Is it the start of the
> data or hole region that has been found?
Yes, it is.
> If so, it woul dbe clearer
> to write:
>
>  * On success, return true and the offset argument will point to the
>  * start of the region that was found. Otherwise this function will return false and
I'll fix the comments for it.
>
>> + * keep the offset argument unchanged.
>> + */
>> +STATIC bool
>> +xfs_lookup_buffer_offset(
>> +	struct page		*page,
>> +	loff_t			*offset,
>> +	unsigned int		type)
>> +{
>> +	loff_t			lastoff = page_offset(page);
>> +	bool			found = false;
>> +	struct buffer_head	*bh, *head;
>> +
>> +	bh = head = page_buffers(page);
>> +	do {
>> +		/*
>> +		 * Unwritten extents that have data in the page
>> +		 * cache covering them can be identified by the
>> +		 * BH_Unwritten state flag.  Pages with multiple
>> +		 * buffers might have a mix of holes, data and
>> +		 * unwritten extents - any buffer with valid
>> +		 * data in it should have BH_Uptodate flag set
>> +		 * on it.
>> +		 */
>> +		if (buffer_unwritten(bh) ||
>> +		    buffer_uptodate(bh)) {
>> +			if (type == DATA_OFF)
>> +				found = true;
>> +		} else {
>> +			if (type == HOLE_OFF)
>> +				found = true;
>> +		}
>> +
>> +		if (found) {
>> +			*offset = lastoff;
>> +			unlock_page(page);
>> +			break;
> You don't lock the page in this function, so you shouldn't unlock
> it, either. Let the caller handle that.
>
>> +		}
>> +		lastoff += bh->b_size;
>> +	} while ((bh = bh->b_this_page) != head);
>> +
>> +	return found;
>> +}
>> +
>> +/*
>> + * This routine is called to find out and return a data or hole offset
>> + * from the page cache for unwritten extents according to the desired
>> + * type for xfs_seek_data() or xfs_seek_hole().
>> + *
>> + * The argument offset is used to tell where we start to search from the
>> + * page cache.  Map is used to figure out the end points of the range to
>> + * lookup pages.
>> + *
>> + * Return true if the desired type of offset was found, and the argument
>> + * offset is filled with that address.  Otherwise, return false and keep
>> + * offset unchanged.
>> + */
>> +STATIC bool
>> +xfs_find_get_desired_pgoff(
>> +	struct inode		*inode,
>> +	struct xfs_bmbt_irec	*map,
>> +	unsigned int		type,
>> +	loff_t			*offset)
>> +{
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct pagevec		pvec;
>> +	pgoff_t			index;
>> +	pgoff_t			end;
>> +	loff_t			endoff;
>> +	loff_t			startoff = *offset;
>> +	loff_t			lastoff = startoff;
>> +	bool			found = false;
>> +
>> +	pagevec_init(&pvec, 0);
>> +
>> +	index = startoff >> PAGE_CACHE_SHIFT;
>> +	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
>> +	end = endoff >> PAGE_CACHE_SHIFT;
>> +	do {
>> +		int		want;
>> +		unsigned	nr_pages;
>> +		unsigned int	i;
>> +
>> +		want = min_t(pgoff_t, end - index, (pgoff_t)PAGEVEC_SIZE);
>> +		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>> +					  want);
>> +		/*
>> +		 * No page mapped into given range.  If we are searching holes
>> +		 * and if this is the first time we got into the loop, it means
>> +		 * that the given offset is landed in a hole, return it.
>> +		 *
>> +		 * If we have already stepped through some block buffers to find
>> +		 * holes but they all contains data.  In this case, the last
>> +		 * offset is already updated and pointed to the end of the last
>> +		 * mapped page, if it does not reach the endpoint to search,
>> +		 * that means there should be a hole between them.
>> +		 */
>> +		if (nr_pages == 0) {
>> +			/* Data search found nothing */
>> +			if (type == DATA_OFF)
>> +				break;
>> +
>> +			ASSERT(type == HOLE_OFF);
>> +			if (lastoff == startoff || lastoff < endoff) {
>> +				found = true;
>> +				*offset = lastoff;
>> +			}
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * At lease we found one page.  If this is the first time we
>> +		 * step into the loop, and if the first page index offset is
>> +		 * greater than the given search offset, a hole was found.
>> +		 */
>> +		if (type == HOLE_OFF && lastoff == startoff &&
>> +		    lastoff < page_offset(pvec.pages[0])) {
>> +			found = true;
>> +			break;
>> +		}
>> +
>> +		for (i = 0; i < nr_pages; i++) {
>> +			struct page	*page = pvec.pages[i];
>> +			loff_t		b_offset;
>> +
>> +			/*
>> +			 * Page index is out of range, searching done.
>> +			 * If the current offset is not reaches the end
>> +			 * of the specified search range, there should
>> +			 * be a hole between them.
>> +			 */
>> +			if (page->index > end) {
>> +				if (type == HOLE_OFF && lastoff < endoff) {
>> +					*offset = lastoff;
>> +					found = true;
>> +				}
>> +				goto out;
>> +			}
>> +
>> +			lock_page(page);
>> +			/*
>> +			 * Page truncated or invalidated(page->mapping == NULL).
>> +			 * We can freely skip it and proceed to check the next
>> +			 * page.
>> +			 */
>> +			if (unlikely(page->mapping != inode->i_mapping)) {
>> +				unlock_page(page);
>> +				continue;
>> +			}
>> +
>> +			if (!page_has_buffers(page)) {
>> +				unlock_page(page);
>> +				continue;
>> +			}
>> +
>> +			found = xfs_lookup_buffer_offset(page, &b_offset, type);
>> +			if (found) {
>> +				/*
>> +				 * The found offset may be less than the start
>> +				 * point to search if this is the first time to
>> +				 * come here.
>> +				 */
>> +				*offset = max_t(loff_t, startoff, b_offset);
> You should unlock the page here.
exactly.
>
>> +				goto out;
>> +			}
>> +
>> +			/*
>> +			 * We either searching data but nothing was found, or
>> +			 * searching hole but found a data buffer.  In either
>> +			 * case, probably the next page contains the desired
>> +			 * things, update the last offset to it so.
>> +			 */
>> +			lastoff = page_offset(page) + PAGE_SIZE;
>> +			unlock_page(page);
>> +		}
>> +
>> +		/*
>> +		 * The number of returned pages less than our desired, search
>> +		 * done.  In this case, nothing was found for searching data,
>> +		 * but we found a hole behind the last offset.
>> +		 */
>> +		if (nr_pages < want) {
>> +			if (type == HOLE_OFF) {
>> +				*offset = lastoff;
>> +				found = true;
>> +			}
>> +			break;
>> +		}
>> +
>> +		index = pvec.pages[i - 1]->index + 1;
> You have to sample the index while the page is locked, otherwise it
> can be invalid. Hence you have to update index every time through
> the above page array loop.
I'll take care of it, thanks!

-Jeff
>
> Other than that, it looks fine.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
