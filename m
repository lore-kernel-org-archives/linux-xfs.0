Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CCrmIH256612 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 06:53:48 -0600
Message-ID: <4F0ED7C9.7050905@oracle.com>
Date: Thu, 12 Jan 2012 20:53:29 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: Introduce SEEK_DATA/SEEK_HOLE to XFS V5
References: <4F06F71A.2010301@oracle.com> <20120111154318.GY6390@sgi.com>
In-Reply-To: <20120111154318.GY6390@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Ben,

On 01/11/2012 11:43 PM, Ben Myers wrote:

> Hey Jeff,
> 
> Here are a few additional minor comments from yesterday.
> 
> I'm looking forward to seeing your next version, and I'm still working
> through this one.
> 
> I would like to suggest that you split this into two patches.  The first
> patch should be the 'simple' implementation that that you began with
> that only looks at extents, and assumes that unwritten extents contain
> data.  The second patch can remove the assumption that unwritten extents
> contain data, and go over pages over the extent to determine if it is
> clean.  I feel we have a better chance of coming to consensus that the
> first patch is correct in the near term, and then we can move on to the
> more complicated matter of whether the unwritten extent can be treated
> as a hole safe in the knowledge that the initial implementation was
> awesome.
> 
> Regards,
> Ben
> 
> On Fri, Jan 06, 2012 at 09:28:58PM +0800, Jeff Liu wrote:
>> This is a revised patch according to Christoph's comments at V4.
>>
>> Changes to V5:
>> --------------
>> * Revise xfs_has_unwritten_buffer() to lookup pages match tag.
>> * For unwritten extents, in both xfs_seek_data() and xfs_seek_hole(), call xfs_has_unwritten_buffer() to search
>>   DIRTY pages firstly, if no dirty data found, call it again to search WRITEBACK pages.
>> * In xfs_seek_hole(), if dirty data was found in page cache for an unwritten extents, but its start offset past the start block
>>   of the map,  treat it as a hole, returns the offset if possible(data_buffer_offset > max(seek_offset, start_block_of_map)).
>>
>> Tests:
>> ------
>> seek sanity tester:
>> http://patchwork.xfs.org/patch/3108/
>> seek copy tester:
>> http://patchwork.xfs.org/patch/3109/
>>
>>
>> Thanks,
>> -Jeff
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> ---
>>  fs/xfs/xfs_file.c |  466 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 465 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 753ed9b..24ae40a 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -38,6 +38,7 @@
>>  
>>  #include <linux/dcache.h>
>>  #include <linux/falloc.h>
>> +#include <linux/pagevec.h>
>>  
>>  static const struct vm_operations_struct xfs_file_vm_ops;
>>  
>> @@ -1141,8 +1142,471 @@ xfs_vm_page_mkwrite(
>>  	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
>>  }
>>  
>> +/*
>> + * Probe the data buffer offset in page cache for unwritten extents.
>> + * Fetch all the pages match @tag, and iterate each page to find out
>> + * if a buffer head state has BH_Unwritten or BH_Uptodate set.
>> + */
>> +STATIC bool
>> +xfs_has_unwritten_buffer(
>> +	struct inode		*inode,
>> +	struct xfs_bmbt_irec	*map,
>> +	int			tag,
>> +	loff_t			*offset)
>> +{
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct pagevec		pvec;
>> +	pgoff_t			index;
>> +	pgoff_t			end;
>> +	bool			found = false;
>> +
>> +	pagevec_init(&pvec, 0);
>> +
>> +	index = XFS_FSB_TO_B(mp, map->br_startoff) >> PAGE_CACHE_SHIFT;
>> +	end = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount)
>> +			   >> PAGE_CACHE_SHIFT;
>> +
>> +	do {
>> +		unsigned int	i;
>> +		unsigned	nr_pages;
>> +		int		want = min_t(pgoff_t, end - index,
>> +					     (pgoff_t)PAGEVEC_SIZE - 1) + 1;
>> +		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
>> +					      &index, tag, want);
>> +		if (nr_pages == 0)
>> +			break;
>> +
>> +		for (i = 0; i < nr_pages; i++) {
>> +			struct page		*page = pvec.pages[i];
>> +			struct buffer_head	*bh;
>> +			struct buffer_head	*head;
>> +			xfs_fileoff_t		last;
>> +
>> +			if (!page_has_buffers(page))
>> +				continue;
>> +
>> +			/*
>> +			 * There is no need to check the following pages
>> +			 * if the current page offset is out of range.
>> +			 */
>> +			if (page->index > end)
>> +				goto out;
>> +
>> +			last = XFS_B_TO_FSBT(mp,
>> +					     page->index << PAGE_CACHE_SHIFT);
>> +
>> +			bh = head = page_buffers(page);
>> +			do {
>> +				/*
>> +				 * An extent in XFS_EXT_UNWRITTEN have disk
>> +				 * blocks already mapped to it, but no data
>> +				 * has been committed to them yet. If it has
>> +				 * dirty data in the page cache it can be
>> +				 * identified by having BH_Unwritten set in
>> +				 * each buffer. Also, the buffer head state
>> +				 * might be in BH_Uptodate too if the buffer
>> +				 * writeback procedure was fired, we need to
>> +				 * examine it as well.
>> +				 */
>> +				if (buffer_unwritten(bh) ||
>> +				    buffer_uptodate(bh)) {
>> +					found = true;
>> +					*offset = XFS_FSB_TO_B(mp, last);
>> +					goto out;
>> +				}
>> +				last++;
>> +			} while ((bh = bh->b_this_page) != head);
>> +		}
>> +
>> +		/*
>> +		 * If the number of probed pages less than our desired,
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
>> +	if (!found)
>> +		*offset = 0;
>> +
>> +	return found;
>> +}
>> +
>> +STATIC loff_t
>> +xfs_seek_data(
>> +	struct file		*file,
>> +	loff_t			start)
>> +{
>> +	struct inode		*inode = file->f_mapping->host;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	xfs_fsize_t		isize = i_size_read(inode);
>> +	loff_t			offset = 0;
>> +	struct xfs_ifork	*ifp;
>> +	xfs_fileoff_t		fsbno;
>> +	xfs_filblks_t		len;
>> +	int			lock;
>> +	int			error;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
>> +
>> +	if (start >= isize) {
>> +		error = ENXIO;
>> +		goto out_lock;
>> +	}
> 
> In Christoph's v3 review he asked you to move this check to after the
> lock is taken, which you've done.  Note that you've read from ip->i_size
> using i_size_read before taking the lock, so isize could be stale.  Call
> i_size_read only after taking the ilock shared.

Thank you for pointing this out!

> 
>> +
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>> +	len = XFS_B_TO_FSB(mp, isize);
> 
> Put calculation of start_fsb and end_fsb next to each other.

ok. I will take care the same issues below too.

> 
>> +
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>> +		loff_t			seekoff;
>> +
>> +		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
>> +				       XFS_BMAPI_ENTIRE);
>> +		if (error)
>> +			goto out_lock;
>> +
>> +		/* No extents at given offset, must be beyond EOF */
>> +		if (!nmap) {
>> +			error = ENXIO;
>> +			goto out_lock;
>> +		}
>> +
>> +		seekoff = XFS_FSB_TO_B(mp, fsbno);
>> +		/*
>> +		 * Landed in a hole, skip to check the next extent.
>> +		 * If the next extent landed in an in-memory data extent,
>> +		 * or it is a normal extent, its fine to return.
>> +		 * If the next extent landed in a hole extent, calculate
>> +		 * the start file system block number for the next scan.
>> +		 * If the next extent landed in an unwritten extent, we
>> +		 * need to lookup the page cache to examine the data
>> +		 * buffer offset, if nothing found, treat it as a hole
>> +		 * extent too.
>> +		 */
>> +		if (map[0].br_startblock == HOLESTARTBLOCK) {
>> +			/*
>> +			 * Return ENXIO if no data extent behind
>> +			 * the given offset. In this case, the seek
>> +			 * offset should be landed in a hole.
>> +			 */
>> +			if (nmap == 1) {
>> +				error = ENXIO;
>> +				break;
>> +			}
>> +
>> +			if (map[1].br_state == XFS_EXT_NORM ||
>> +			    map[1].br_startblock == DELAYSTARTBLOCK) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +
>> +				break;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				if (xfs_has_unwritten_buffer(inode, &map[1],
>> +						     PAGECACHE_TAG_DIRTY,
>> +						     &offset) ||
>> +				    xfs_has_unwritten_buffer(inode, &map[1],
>> +						     PAGECACHE_TAG_WRITEBACK,
>> +						     &offset)) {
>> +					offset = max_t(loff_t, seekoff, offset);
>> +					break;
>> +				}
>> +			}
>> +
>> +			fsbno = map[1].br_startoff + map[1].br_blockcount;
>> +		}
>> +
>> +		/*
>> +		 * Landed in an unwritten extent, try to find out the data
>> +		 * buffer offset from page cache firstly. If nothing was
>> +		 * found, treat it as a hole, and skip to check the next
>> +		 * extent, something just like above.
>> +		 */
>> +		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
>> +			if (xfs_has_unwritten_buffer(inode, &map[0],
>> +						     PAGECACHE_TAG_DIRTY,
>> +						     &offset) ||
>> +			    xfs_has_unwritten_buffer(inode, &map[0],
>> +						     PAGECACHE_TAG_WRITEBACK,
>> +						     &offset)) {
>> +				offset = max_t(loff_t, seekoff, offset);
>> +				break;
>> +			}
>> +
>> +			/* No data extent at the given offset */
>> +			if (nmap == 1) {
>> +				error = ENXIO;
>> +				break;
>> +			}
>> +
>> +			if (map[1].br_state == XFS_EXT_NORM ||
>> +			    map[1].br_startblock == DELAYSTARTBLOCK) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				if (xfs_has_unwritten_buffer(inode, &map[1],
>> +						     PAGECACHE_TAG_DIRTY,
>> +						     &offset) ||
>> +				    xfs_has_unwritten_buffer(inode, &map[1],
>> +						     PAGECACHE_TAG_WRITEBACK,
>> +						     &offset)) {
>> +					offset = max_t(loff_t, seekoff, offset);
>> +					break;
>> +				}
>> +			}
>> +
>> +			fsbno = map[1].br_startoff + map[1].br_blockcount;
>> +		}
>> +
>> +		/* Landed in a delay allocated extent or a real data extent */
>> +		if (map[0].br_startblock == DELAYSTARTBLOCK ||
>> +		    map[0].br_state == XFS_EXT_NORM) {
>> +			offset = max_t(loff_t, seekoff,
>> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
>> +			break;
>> +		}
>> +
>> +		/* Return ENXIO if beyond eof */
>> +		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
>> +			error = ENXIO;
>> +			goto out_lock;
>> +		}
>> +	}
>> +
>> +	if (offset < start)
>> +		offset = start;
>> +
>> +	if (offset != file->f_pos)
>> +		file->f_pos = offset;
>> +
>> +out_lock:
>> +	xfs_iunlock_map_shared(ip, lock);
>> +	if (error)
>> +		return -error;
>> +
>> +	return offset;
>> +}
>> +
>> +STATIC loff_t
>> +xfs_seek_hole(
>> +	struct file		*file,
>> +	loff_t			start)
>> +{
>> +	struct inode		*inode = file->f_mapping->host;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	xfs_fsize_t		isize = i_size_read(inode);
> 
> Call i_size_read under ilock.
> 
>> +	loff_t			offset = 0;
>> +	struct xfs_ifork	*ifp;
>> +	xfs_fileoff_t		fsbno;
>> +	xfs_filblks_t		len;
>> +	int			lock;
> 
> lock should be a uint
> 
>> +	int			error;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
>> +
>> +	if (start >= isize) {
>> +		error = ENXIO;
>> +		goto out_lock;
>> +	}
>> +
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>> +	len = XFS_B_TO_FSB(mp, isize);
> 
> Calculation of start_fsb and end_fsb look nicer next to each other.

> 
>> +
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>> +		loff_t			seekoff;
>> +
>> +		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
>> +				       XFS_BMAPI_ENTIRE);
>> +		if (error)
>> +			goto out_lock;
>> +
>> +		/* No extents at given offset, must be beyond EOF */
>> +		if (!nmap) {
>> +			error = ENXIO;
>> +			goto out_lock;
>> +		}
>> +
>> +		seekoff = XFS_FSB_TO_B(mp, fsbno);
>> +		/*
>> +		 * Landed in an unwritten extent, try to lookup the page
>> +		 * cache to find out if there is dirty data or not. If
>> +		 * nothing was found, treate it as a hole. If there has
>> +		 * dirty data and its offset starts past both the start
>> +		 * block of the map and the current seek offset, it should
>> +		 * be treated as hole too. Otherwise, go through the next
>> +		 * extent to fetch holes.
>> +		 */
>> +		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
>> +			if (xfs_has_unwritten_buffer(inode, &map[0],
>> +						     PAGECACHE_TAG_DIRTY,
>> +						     &offset) ||
>> +			    xfs_has_unwritten_buffer(inode, &map[0],
>> +						     PAGECACHE_TAG_WRITEBACK,
>> +						     &offset)) {
>> +				if (offset > max_t(loff_t, seekoff,
>> +						   XFS_FSB_TO_B(mp,
>> +						   map[0].br_startoff))) {
>> +					offset = max_t(loff_t, seekoff,
>> +						       XFS_FSB_TO_B(mp,
>> +						       map[0].br_startoff));
>> +					break;
>> +				}
>> +			} else {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[0].br_startoff));
>> +				break;
>> +			}
>> +
>> +			/*
>> +			 * No more extent at the given offst, return the total
>> +			 * file size.
>> +			 */
>> +			if (nmap == 1) {
>> +				offset = isize;
>> +				break;
>> +			}
>> +
>> +			if (map[1].br_startblock == HOLESTARTBLOCK) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				if (xfs_has_unwritten_buffer(inode, &map[1],
>> +							PAGECACHE_TAG_DIRTY,
>> +							&offset) ||
>> +				    xfs_has_unwritten_buffer(inode, &map[1],
>> +							PAGECACHE_TAG_WRITEBACK,
>> +							&offset)) {
>> +					if (offset > max_t(loff_t, seekoff,
>> +							XFS_FSB_TO_B(mp,
>> +							map[1].br_startoff))) {
>> +						offset = max_t(loff_t, seekoff,
>> +							XFS_FSB_TO_B(mp,
>> +							map[1].br_startoff));
>> +						break;
>> +					}
>> +				} else {
>> +					offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +					break;
>> +				}
>> +			}
>> +
>> +			fsbno = map[1].br_startoff + map[1].br_blockcount;
>> +		}
>> +
>> +		/*
>> +		 * Landed in a delay allocated extent or a real data extent,
>> +		 * if the next extent is landed in a hole or in an unwritten
>> +		 * extent but without data committed in the page cache, return
>> +		 * its offset. If the next extent has dirty data in page cache,
>> +		 * but its offset starts past both the start block of the map
>> +		 * and the seek offset, it still be a hole.
>> +		 */
>> +		if (map[0].br_startblock == DELAYSTARTBLOCK ||
>> +		    map[0].br_state == XFS_EXT_NORM) {
>> +			/*
>> +			 * No more extent at the give offset, return the
>> +			 * total file size.
>> +			 */
>> +			if (nmap == 1) {
>> +				offset = isize;
>> +				break;
>> +			}
>> +
>> +			if (map[1].br_startblock == HOLESTARTBLOCK) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				if (xfs_has_unwritten_buffer(inode, &map[1],
>> +							PAGECACHE_TAG_DIRTY,
>> +							&offset) ||
>> +				    xfs_has_unwritten_buffer(inode, &map[1],
>> +							PAGECACHE_TAG_WRITEBACK,
>> +							&offset)) {
>> +					if (offset > max_t(loff_t, seekoff,
>> +							XFS_FSB_TO_B(mp,
>> +							map[1].br_startoff))) {
>> +						offset = max_t(loff_t, seekoff,
>> +							XFS_FSB_TO_B(mp,
>> +							map[1].br_startoff));
>> +						break;
>> +					}
>> +				} else {
>> +					offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +					break;
>> +				}
>> +			}
>> +
>> +			fsbno = map[1].br_startoff + map[1].br_blockcount;
>> +		}
>> +
>> +		/* Landed in a hole, its fine to return */
>> +		if (map[0].br_startblock == HOLESTARTBLOCK) {
>> +			offset = max_t(loff_t, seekoff,
>> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
>> +			break;
>> +		}
>> +
>> +		/* Return ENXIO if beyond eof */
>> +		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
>> +			error = ENXIO;
>> +			goto out_lock;
>> +		}
>> +	}
>> +
>> +	if (offset < start)
>> +		offset = start;
>> +
>> +	if (offset != file->f_pos)
>> +		file->f_pos = offset;
>> +
>> +out_lock:
> 
> name this out_unlock

ok. :)

> 
>> +	xfs_iunlock_map_shared(ip, lock);
>> +	if (error)
>> +		return -error;
>> +
>> +	return offset;
>> +}
>> +
>> +STATIC loff_t
>> +xfs_file_llseek(
>> +	struct file	*file,
>> +	loff_t		offset,
>> +	int		origin)
>> +{
>> +	switch (origin) {
>> +	case SEEK_END:
>> +	case SEEK_CUR:
>> +	case SEEK_SET:
>> +		return generic_file_llseek(file, offset, origin);
>> +	case SEEK_DATA:
>> +		return xfs_seek_data(file, offset);
>> +	case SEEK_HOLE:
>> +		return xfs_seek_hole(file, offset);
>> +	default:
>> +		return -EOPNOTSUPP;
> 
> I suggest -EINVAL here, as per http://linux.die.net/man/2/lseek

Definitely! I have gone through other file systems have SEEK_XXX stuff
support, OCFS2 returns -EINVAL in this case.
Btrfs will return -EINVAL too.

Thanks,
-Jeff

> 
>> +	}
>> +}
>> +
>>  const struct file_operations xfs_file_operations = {
>> -	.llseek		= generic_file_llseek,
>> +	.llseek		= xfs_file_llseek,
>>  	.read		= do_sync_read,
>>  	.write		= do_sync_write,
>>  	.aio_read	= xfs_file_aio_read,
>> -- 
>> 1.7.4.1
>>
>>
>>
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
