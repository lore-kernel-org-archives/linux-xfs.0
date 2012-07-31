Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V7Qouh156225 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 02:26:50 -0500
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id H8wFqoFxrs8xbJs8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 00:26:48 -0700 (PDT)
Message-ID: <501788AC.40802@oracle.com>
Date: Tue, 31 Jul 2012 15:26:36 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v5 2/4]xfs: Introduce a new function to find the desired
	type of offset from page cache
References: <50110629.4090304@oracle.com> <20120730234331.GL2877@dastard>
In-Reply-To: <20120730234331.GL2877@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/31/12 07:43, Dave Chinner wrote:
> On Thu, Jul 26, 2012 at 04:56:09PM +0800, Jeff Liu wrote:
>> This function is called by xfs_seek_data() and xfs_seek_hole() to find
>> the desired offset from page cache.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> Reviewed-by: Mark Tinguely <tinguely@sgi.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> BTW, when you make a significant modification to a patch set, it is
> customary to drop existing reviewed-by tags on modified/new patches
> so that the reviewers know that it is new code and that they need to
> review at it again...
I'll take care of it, thanks.
>
>> +/*
>> + * This routine is called to find out and return a data or hole offset
>> + * from the page cache for unwritten extents according to the desired
>> + * type for xfs_seek_data() or xfs_seek_hole().
>> + *
>> + * The argument offset is used to tell where we start to search from the
>> + * page cache, and it will be filled with the desired type of offset if
>> + * it was found, or it will keep unchanged.  map is used to figure out
>> + * the end points of the range to lookup pages.
> What's the return value? True for data, false for hole? Needs to be
> documented....
True if an offset of the desired type was found, or false,  the fix will 
be reflected in the next post.
>
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
>> +	loff_t			coff = *offset; /* current search offset */
>> +	bool			found = false;
>> +
>> +	pagevec_init(&pvec, 0);
>> +	index = XFS_FSB_TO_B(mp, XFS_B_TO_FSBT(mp, coff)) >> PAGE_CACHE_SHIFT;
> That's a very complex way to find the page index. You are basically
> doing this for a 4k FSB/page size combination;
>
> 	index = ((coff >> 12) << 12) >> 12
>
> For smaller block sizes, the one that matters is the
> PAGE_CACHE_SHIFT at the end. i.e:
>
> 	index = ((coff >> 9) << 9) >> 12
> 	      = coff >> 12
>
> So why not just:
>
> 	index = coff >> PAGE_CACHE_SHIFT;
Yes, I was silly to do so much redundant conversions.  :(
>
>> +
>> +	/* The end offset to search for */
>> +	endoff = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount);
>> +	end = endoff >> PAGE_CACHE_SHIFT;
> I think there's an off-by-one here.  Say we map fsb 0 for 2 blocks
> w/ 4k fsbs.  that means byte offsets 0-8191 are in the range of the
> mapping. The above gives:
>
> 	endoff = (0 + 2) << 12 = 8192
> 	end = 8192 >> 12 = 2
>
> so now we have start index 0, end index = 2. That's 3 pages, yes?
>
>> +	do {
>> +		unsigned int	i;
>> +		unsigned	nr_pages;
>> +		int		want = min_t(pgoff_t, end - index,
>> +					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
> And that means here we do:
>
> 	want = min(2 - 0, 13) + 1
> 	     = 3.
>
> So we are looking for 3 pages instead of only 2. And further down,
> the limits are (page->index > end) so this really does consider page
> index of 2 as part of the range asked for which it isn't....
Exactly!
>
>> +		nr_pages = pagevec_lookup(&pvec, inode->i_mapping, index,
>> +					  want);
>> +		/*
>> +		 * No page mapped into given range.  If we are searching holes
>> +		 * and if this is the first time we got into the loop, it means
>> +		 * that the given offset is landed in a hole and return ture.
>                                                                          true
>
>> +		 *
>> +		 * If we have already stepped through some block buffers to find
>> +		 * holes but those buffers are all contains data, in this case,
>> +		 * the current search offset is already aligned to block buffer
>> +		 * unit boundary and pointed to the end of the last mapped page.
>> +		 * If it's location is less than the end range given for search,
>> +		 * that means there should be a hole between them, so return the
>> +		 * current search offset if we are searching hole.
>> +		 */
>> +		if (nr_pages == 0) {
>> +			if (type == HOLE_OFF) {
>> +				if (coff == *offset)
>> +					found = true;
>> +				if (coff < endoff) {
>> +					found = true;
>> +					*offset = coff;
>> +				}
>> +			}
>> +			/* Search data but nothing found */
>> +			break;
>> +		}
> I'd just write that as:
> 			/* data search found nothing */
> 			if (type == DATA_OFF)
> 				break;
Make sense to break earlier for searching data.
>
> 			ASSERT(type == HOLE_OFF);
I wonder if we really need to assert or not, as this helper only used to 
lookup either data or hole.
> 			if (coff == *offset || coff < endoff) {
> 				found = true;
> 				*offset = coff;
> 			}
> 			break;
>
>> +
>> +		/*
>> +		 * At least we found one page.  If this the first time we step
>> +		 * into the loop, and if the first page index offset is greater
>> +		 * than the given search offset, a hole was found, return true
>> +		 * if we are searching holes.
>> +		 */
>> +		if ((type == HOLE_OFF) && (coff == *offset)) {
> No need for the extra () here....
>
>> +			if (coff < pvec.pages[0]->index << PAGE_CACHE_SHIFT) {
> ... but that definitely needs them for clarity.
>
>> +				found = true;
>> +				break;
>> +			}
>> +		}
> 		if (type == HOLE_OFF && coff == *offset &&
> 		    coff < page_offset(pvec.pages[0])) {
> 			found = true;
> 			break;
> 		}
Ok.
>> +
>> +		for (i = 0; i < nr_pages; i++) {
>> +			struct page		*page = pvec.pages[i];
>> +			struct buffer_head	*bh;
>> +			struct buffer_head	*head;
>> +			xfs_fileoff_t		last;
> Indenting is starting to get excessive. Perhaps the page processing
> loop could be pushed into it's own function....
I'll try to isolate it in an individual function.
>
>> +
>> +			/*
>> +			 * Page index is out of range, we need to deal with
>> +			 * hole search condition in paticular if that is the
>> +			 * desired type for the lookup.
>> +			 * stepping into the block buffer checkup, it probably
>> +			 * means that there is no page mapped at all in the
>> +			 * specified range to search, so we found a hole.
>> +			 * If we have already done some block buffer checking
>> +			 * and found one or more data buffers before, in this
>> +			 * case, the coff is already updated and it point to
>> +			 * the end of the last data buffer, so the left range
>> +			 * behind it might be a hole.  In either case, we will
>> +			 * return the coff to indicate a hole's location because
>> +			 * it must be greater than or equal to the search start.
>> +			 */
> The comment could do with some work - it seems to be very verbose fo
> the amount of information it conveys. Perhaps:
>
> 			/*
> 			 * If the page index is out of range, then it means we
> 			 * found a hole. If we have already found some data
> 			 * buffers, we need to update the start location of the
> 			 * hole before returning.
> 			 */
Will fix it combine with Mark's comments.
>
>> +			if (page->index > end) {
>> +				if (type == HOLE_OFF && coff < endoff) {
>> +					*offset = coff;
>> +					found = true;
>> +				}
>> +				goto out;
>> +			}
>> +
>> +			if (!trylock_page(page))
>> +				goto out;
> Just lock the page - there is no deadlock we need to avoid and
> we really need to know the state of the page to be accurate. Also,
> once the page is locked you need to check against page->index again,
> as we could be racing with memory reclaim or truncate here. It is
> also worth checking page->mapping is still correctly set, too, for
> the same reason.
Thanks for the teaching! I was not aware of memory reclaim/truncate 
procedures which are behind the scene.
>   
>
>> +
>> +			if (!page_has_buffers(page)) {
>> +				unlock_page(page);
>> +				continue;
>> +			}
>> +
>> +			last = XFS_B_TO_FSBT(mp,
>> +					     page->index << PAGE_CACHE_SHIFT);
> Why calculate the last offset in FSB?
>
> 			last = page_offset(page);
well... Duh. :)
>
>> +			bh = head = page_buffers(page);
>> +			do {
>> +				off_t		lastoff = 0;
> 				off_t	lastoff = last;
>
>> +				/*
>> +				 * An extent in XFS_EXT_UNWRITTEN has disk
>> +				 * blocks already mapped to it, but no data
>> +				 * has been committed to them yet.  If it has
>> +				 * dirty data in the page cache it can be
>> +				 * identified by having BH_Unwritten set in
>> +				 * each buffers.  Also, the buffer head state
>> +				 * might be in BH_Uptodate too if the buffer
>> +				 * writeback procedure was fired, we have to
>> +				 * check it up as well.
>> +				 */
> buffer_uptodate() is also set in .commit_write when a page is fully written, and
> canbe set on read when mpage_readpages() gets confused and falls back to
> block_read_full_page. So that flag is no necessarily an indicator of
> dirty/writeback data. It is an indicator of data being present in the page
> cache, though, that may not be on disk. Hence the comment might be better
> written as:
>
> 				/*
> 				 * Unwritten extents that have data in the page
> 				 * cache covering them can be identified by the
> 				 * buffer_unwritten() state flag. Pages with
> 				 * multiple buffers might have a mix of holes,
> 				 * data and unwritten extents - any buffer with
> 				 * valid data in it should have the
> 				 * buffer_uptodate(bh) flag set on it.
> 				 */
Definitely, I'll change it accordingly.
>
>> +				if (buffer_unwritten(bh) ||
>> +				    buffer_uptodate(bh)) {
>> +					/*
>> +					 * Found a data buffer and we are
>> +					 * searching data, great.
>> +					 */
>> +					if (type == DATA_OFF)
>> +						found = true;
>
>> +				} else {
>> +					/*
>> +					 * Nothing was found and we are
>> +					 * searching holes, great.
>> +					 */
>> +					if (type == HOLE_OFF)
>> +						found = true;
>> +				}
>> +				if (found) {
>> +					/*
>> +					 * Return if we found the desired
>> +					 * page offset.
>> +					 */
>> +					*offset = max_t(loff_t, coff, lastoff);
> When would lastoff < coff be true?
If this is the first time we stepped to here for searching data, and a 
data buffer was found.
The 'coff' might be greater than the 'lastoff', assuming 'coff = *offset 
= 4097',
but the data buffer offset(lastoff) located at 4096, in this case, we 
need to return the maximum value.

>
>> +					unlock_page(page);
>> +					goto out;
>> +				}
>> +				/*
>> +				 * We either searching data but nothing was
>> +				 * found, or searching hole but found a data
>> +				 * block buffer.  In either case, probably the
>> +				 * next block buffer is what we are desired,
>> +				 * so that we need to round up the current
>> +				 * offset to it.
>> +				 */
>> +				coff = round_up(lastoff + 1, bh->b_size);
> I don't see the point of this round_up call. It's just a complex way
> of saying:
> 				coff = lastoff + bh->b_size;
ok, will fix it.
>
>> +				last++;
> 				last += bh->b_size;
>
> So by the time we get to this buffer loop we will always update coff, or return
> lastoff which is updated at the start of the loop. So why do we even need last
> and lastoff? can't you just use coff?
Similar to above.
If this is the first time for searching data and we found a data buffer.
'coff' does not updated in this stage, it still point to '*offset', but 
the 'lastoff' is point to the current data
buffer offset.

So 'coff' might be greater than, less than or equtal to 'lastoff'.
If it is greater than or equtal to the lastoff, return 'coff' is ok.  
However, if it is less than the 'lastoff', we should
return 'lastoff' instead.
>
> i.e. you are doing this:
>
> 				last = offset
> 				do {
> 					lastoff = last;
> 					....
> 					if (found)
> 						return lastoff
> 					...
> 					coff = lastoff + bh->b_size;
> 					last += bh->b_size
> 				} while()
>
> Which is simply:
>
> 				coff = offset
> 				do {
> 					....
> 					if (found)
> 						return coff
> 					...
> 					coff += bh->b_size
> 				} while()
>
>> +			} while ((bh = bh->b_this_page) != head);
>> +			unlock_page(page);
>> +		}
>> +
>> +		/*
>> +		 * If the number of returned pages less than our desired,
>> +		 * there should no more pages mapped, search done.
>> +		 */
>> +		if (nr_pages < want)
>> +			break;
>> +
>> +		index = pvec.pages[i - 1]->index + 1;
>> +		pagevec_release(&pvec);
>> +	} while (index < end);
>> +
>> +out:
>> +	pagevec_release(&pvec);
>> +	return found;
>> +}
>> +
>>   STATIC loff_t
>>   xfs_seek_data(
>>   	struct file		*file,
>> -- 
>> 1.7.4.1
Thanks,
-Jeff
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>> -- 
>> This message has been scanned for viruses and
>> dangerous content by MailScanner, and is
>> believed to be clean.
>>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
