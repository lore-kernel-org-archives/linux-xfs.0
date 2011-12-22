Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBMA7k5h148447 for <xfs@oss.sgi.com>; Thu, 22 Dec 2011 04:07:47 -0600
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id exdPaGH60CGvKcs5 for
	<xfs@oss.sgi.com>; Thu, 22 Dec 2011 02:07:44 -0800 (PST)
Message-ID: <4EF30160.1080808@oracle.com>
Date: Thu, 22 Dec 2011 18:07:28 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE  to XFS V3
References: <4EE7691D.6040807@oracle.com>
	<20111221163251.GA19398@infradead.org>
In-Reply-To: <20111221163251.GA19398@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Christoph,

Thanks for your feedback.

On 12/22/2011 12:32 AM, Christoph Hellwig wrote:

> Hi Jeff,
> 
> sorry for the delay getting back to this - last week has been very busy
> for me.
> 
>> Tests:
>> ======
>> 1. General tests I have mentioned before.
>> 2. Cover look up DIRTY pages through fallocate(2).
> 
> Can you send your actual test cases to the list?  Preferably wired up
> to xfstests, and also verified against btrfs and ocfs2 which already
> have the feature.

I'll includes the test cases together in next post.

> 
>> The issue is I have not yet successfully worked out a test case can
>> cover look up WRITEBACK pages easily,

Yes! Finally, I got a few hits by tuning the dirty_background_bytes to a
very little size, but it not a reasonable approach for our tests :(

> 
> It's probably fairly hard to hit, as you'd need a relatively slow device
> to hit it reliably.  Doing a sync_file_range call with
> SYNC_FILE_RANGE_WRITE as the flags argument just before the lseek call
> probably is the best way to get it.

Coool, I'm play with it now.

> 
>> +/*
>> + * Try to find out the data buffer offset in page cache for unwritten
>> + * extents. Firstly, try to probe the DIRTY pages in current extent range,
>> + * and iterate each page to lookup all theirs data buffers, if a buffer
>> + * head status is unwritten, return its offset. If there is no DIRTY pages
>> + * found or lookup done, we need to lookup the WRITEBACK pages again and
>> + * perform the same operation as previously to avoid data loss.
>> + */
>> +STATIC loff_t
>> +xfs_probe_unwritten_buffer(
>> +	struct inode		*inode,
>> +	struct xfs_bmbt_irec	*map,
>> +	int			*found)
>> +{
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	struct pagevec		pvec;
>> +	pgoff_t			index;
>> +	pgoff_t			end;
>> +	loff_t			offset = 0;
>> +	int			tag = PAGECACHE_TAG_DIRTY;
>> +
>> +	pagevec_init(&pvec, 0);
>> +
>> +probe_writeback_pages:
>> +	index = XFS_FSB_TO_B(mp, map->br_startoff) >> PAGE_CACHE_SHIFT;
>> +	end = XFS_FSB_TO_B(mp, map->br_startoff + map->br_blockcount)
>> +			   >> PAGE_CACHE_SHIFT;
>> +
>> +	do {
>> +		unsigned	nr_pages;
>> +		unsigned int	i;
>> +		int		want = min_t(pgoff_t, end - index,
>> +					     PAGEVEC_SIZE - 1) + 1;
>> +		nr_pages = pagevec_lookup_tag(&pvec, inode->i_mapping,
>> +					      &index, tag, want);
>> +		if (nr_pages == 0) {
>> +			/*
>> +			 * No dirty pages returns for this extent, try
>> +			 * to lookup the writeback pages again.
>> +			 * FIXME: If this is the first time for probing
>> +			 * DIRTY pages but nothing returned, we need to
>> +			 * search the WRITEBACK pages from the extent
>> +			 * beginning offset, but if we have found out
>> +			 * some DIRTY pages before, maybe we should
>> +			 * continue to probe the WRITEBACK pages from
>> +			 * the current page index rather than beginning?
>> +			 */
>> +			if (tag == PAGECACHE_TAG_DIRTY) {
>> +				tag = PAGECACHE_TAG_WRITEBACK;
>> +				goto probe_writeback_pages;
>> +			}
> 
> I don't think this is correct.  Even if we have dirty pages we migt have
> writeback pages at an lower index.  Given that the we can't look for
> multiple tags at the same time it seems like we need a normal pagecache
> lookup and iterate over all pages.  Later we could optimize this by
> adding a multiple tag lookup helper, but let's get the code functional
> for now.

The idea which I have mentioned is definitely wrong, we have to lookup
writeback pages from the beginning offset again.

> Btw, did you look what btrfs and ocfs2 do here?

Looks they don't check page caches for unwritten extent, in other
worlds, they treat it as data return to user.

> 
>> +				/*
>> +				 * In XFS, if an extent in XFS_EXT_UNWRITTEN
>> +				 * state, that means the disk blocks were
>> +				 * already mapped for it, but the data is
>> +				 * still lived at page caches. For buffers
>> +				 * resides at DIRTY pages, their BH state
>> +				 * should be in (dirty && mapped && unwritten
>> +				 * && uptodate) status. For buffers resides
>> +				 * at WRITEBACK pages, their BH state should
>> +				 * be in (mapped && unwritten && uptodate)
>> +				 * status. So we only need to check unwritten
>> +				 * buffer status here.
> 
> Remove the "In XFS" - this is XFS code so that part is redudant.
> 
> XFS_EXT_UNWRITTEN do not need to have data at all, in fact they most
> likely don't.  So I'd reword this to:
> 
> An extent in XFS_EXT_UNWRITTEN has disk blocks already mapped to it, but
> no data has been commiteed to them yet.  If it has dirty data in the
> pagecache it can be identified by having BH_Unwritten set in each
> buffer.

Thanks again!

> 
>> +STATIC loff_t
>> +xfs_seek_data(
>> +	struct file		*file,
>> +	loff_t			start,
>> +	u32			type)
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
>> +	if (start >= isize)
>> +		return -ENXIO;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
> 
> I'd move the check after acquiring the lock just to be sure.

yes, it should be present after

> 
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>> +	len = XFS_B_TO_FSB(mp, isize);
>> +
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>> +		int			found = 0;
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
>> +		 * the start file system block number for next bmapi read.
>> +		 * If the next extent landed in an unwritten extent, we
>> +		 * need to probe the page cache to find out the data buffer
>> +		 * offset, if nothing found, treat it as a hole extent too.
>> +		 */
>> +		if (map[0].br_startblock == HOLESTARTBLOCK) {
>> +			if (map[1].br_startblock == HOLESTARTBLOCK) {
>> +				fsbno = map[1].br_startoff +
>> +					map[1].br_blockcount;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				offset = xfs_probe_unwritten_buffer(inode,
>> +								    &map[1],
>> +								    &found);
>> +				if (found) {
>> +					offset = max_t(loff_t, seekoff, offset);
>> +					break;
>> +				}
>> +				/*
>> +				 * No data buffer found in pagecache, treate it
>> +				 * as a hole.
>> +				 */
>> +				fsbno = map[1].br_startoff +
>> +					map[1].br_blockcount;
>> +			} else {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			}
> 
> It seems like the hole handling is the same for this case and what we
> handle below.

looks we only need to add unwritten extent lookup for hole handing.
Return the offset if nothing found, for HOLESTARTBLOCK, return the
offset. for DELAYSTARTBLOCK and NORM_EXTENT, examine the index fsbno for
next xfs_bmapi_read().

> 
>> +		/* Landed in a delay allocated extent or a read data extent */
> 
> s/read/real/
> 
>> +STATIC loff_t
>> +xfs_seek_hole(
>> +	struct file		*file,
>> +	loff_t			start,
>> +	u32			type)

Just realized that we can omit 'type' argument here as well as
xfs_seek_data(). both interface should be xfs_seek_xxx(struct file
*file, loff_t start). :)

>> +{
>> +	struct inode		*inode = file->f_mapping->host;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	xfs_fsize_t		isize = i_size_read(inode);
>> +	xfs_fileoff_t		fsbno;
>> +	loff_t			holeoff;
>> +	loff_t			offset = 0;
>> +	int			lock;
>> +	int			error;
>> +
>> +	if (start >= isize)
>> +		return -ENXIO;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
> 
> I'd move the check after acquiring the lock just to be sure.
> 
>> +	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
>> +	if (error)
>> +		goto out_lock;
> 
> Hmm - this misses the unwritten cases that we handle in SEEK_DATA.  But
> if we want to handle it we probably can't use the simple
> xfs_bmap_first_unused call that Dave suggested but need to use the
> xfs_bmapi_read loop, too.

Oops! sorry, I have not took care this function when revising the patch
last time. just as your above comments, in most cases, the unwritten
extent fetched but without data committed to page cache, in this case,
it should be treated as holes too. :)


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
