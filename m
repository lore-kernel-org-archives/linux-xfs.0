Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKDxsUt158977 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 07:59:54 -0600
Message-ID: <4EC907C3.7020901@oracle.com>
Date: Sun, 20 Nov 2011 21:59:31 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V1
References: <4E887D7F.2010306@oracle.com>	<20111114102444.GA27791@infradead.org>	<4EC10DE8.6030607@oracle.com>
	<20111114125044.GA9802@infradead.org>	<4EC768F5.4050904@oracle.com>
	<4EC76AB9.9030604@oracle.com> <20111120003031.GM7046@dastard>
In-Reply-To: <20111120003031.GM7046@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>, aelder@sgi.com

Hi Dave,

Thanks for your further comments!

On 11/20/2011 08:30 AM, Dave Chinner wrote:

> On Sat, Nov 19, 2011 at 04:37:13PM +0800, Jeff Liu wrote:
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Christoph has commented on the code-related aspects of the patch, so
> I won't repeat that. I'll comment on structural/design issues
> instead.
> 
> Firstly, the patch splits the functionality arbitrarily over three
> different files, and I don't think that is necessary. There really
> is no reason at all for xfs_bmap.c to know anything aout
> SEEK_HOLE/SEEK_DATA semantics - that file is for extent manipulation
> and search functions. SEEK semantics should be entirely encoded into
> the function that deals with the seeking.

Yes, I should merge and isolate those functions in xfs_file.c.

> 
> Secondly, xfs_find_desired_extent() and xfs_seek_hole_data() should
> be one function, and named something like xfs_file_seek_extent().

Definitely!  and sorry for my poor english, xfs_file_seek_extent() is distinct in this case.

> 
> Finally, don't think using low level extent search functions like
> xfs_bmap_search_extents() is the right level to implement this
> functionality (see my comments about SEEK_HOLE/SEEK_DATA semantics
> in xfs-bmap.c above), especially as we already have functions for
> looking up holes and extents at given offsets.
> 
> That is, to find the next hole at or after after a given offset, we
> already have xfs_bmap_first_unused(). Indeed, this function already
> has the exact semantics that SEEK_HOLE requires. Simply put:
> 
> 	case SEEK_HOLE:
> 		fsb = XFS_B_TO_FSBT(mp, start_offset);
> 		error = xfs_bmap_first_unused(NULL, ip, 1, &fsb,
> 						XFS_DATA_FORK);
> 		if (error)
> 			return -error;
> 
> 		if (fsb <= XFS_B_TO_FSBT(mp, start_offset))
> 			return start_offset;
> 		return XFS_FSB_TO_B(mp, fsb);

Thanks for pointing it out, I even don't know XFS has this convenient routine at that time. :(

> 
> 
> As to the data extent search, I'd prefer you to use xfs_bmapi_read()
> rather than xfs_bmap_search_extents() directly. I'd prefer that we
> return unwritten extents as holes rather than data from the initial
> implementation, and using the low level xfs_bmap_search_extents()
> makes that quite complex. However, we already have a function for
> handling that complexity: xfs_bmapi_read().
> 
> That is, xfs_bmapi_read() needs to be passed an array of two maps,
> one for the current offset, and one for the next extent type. This
> makes one call sufficient for most transitions. Done in a simple
> loop it will handle all conditions of hole->unwritten->hole....
> until it finds a data extent of EOF.
> 
> 
> 	start_fsbno = XFS_B_TO_FSBT(mp, start_offset);
> 	while (1) {
> 		struct xfs_bmbt_irec	maps[2];
> 		int			nmaps = 2;
> 
> 		count_fsb = XFS_B_TO_FSB(mp, XFS_MAXIOFFSET(mp));
> 		error = xfs_bmapi_read(ip, fsbno, count_fsb,
> 					&maps, &nmaps, XFS_BMAPI_ENTIRE);
> 
> 		if (error)
> 			return -error;
> 		if (!nmaps) {
> 			/* no extents at given offset, must be beyond EOF */
> 			return -ENXIO;
> 		}
> 
> 		switch (map[0].br_startblock) {
> 		case DELAYSTARTBLOCK:
> 			/* landed in an in-memory data extent */
> 			return map[0].br_startoff;
> 
> 		default:
> 			/* landed in an allocated extent */
> 			if (map[0].br_state == XFS_EXT_NORM) {
> 				/* a real data extent */
> 				return map[0].br_startoff;
> 			}
> 			/* Fall through to hole handling for unwritten extents */
> 
> 		case HOLESTARTBLOCK:
> 			/*
> 			 * landed in a hole. If the next extent is a data
> 			 * extent, then return the start of it, otherwise
> 			 * we need to move the start offset and map more
> 			 * blocks.
> 			 */
> 			if (map[1].br_startblock == DELAYSTARTBLOCK ||
> 			   ((map[1].br_startblock != HOLESTARTBLOCK &&
> 			     map[1].br_state == XFS_EXT_NORM)))
> 				return map[1].br_startoff;
> 
> 			start_fsbno = map[1].br_startoff + map[1].br_blockcount;
> 			break;
> 		}
> 
> 		if (XFS_FSB_TO_B(mp, start_fsbno) > ip->i_size) {
> 			/* Beyond EOF now */
> 			return -ENXIO;
> 		}
> 	}
> 
> This can pretty much all be done in
> fs/xfs/xfs_file.c::xfs_file_seek_extent() because all the functions
> used by the above code are exported from xfs_bmap.c for external use
> - that solves the scattering problem and uses interfaces that we
> already know work in the intended manner.... ;)

Thanks again for the detailed info!
At first, I have spent a few hours to think it over using xfs_bmap_search_extents() or xfs_bmapi_read().
Indeed, it will be more complex to deal with the unwritten extents later if using xfs_bmap_search_extents().
This change will reflected in my next post.

> 
> BTW:
> 
>> +xfs_file_llseek(
>> +	struct file *file,
>> +	loff_t offset,
>> +	int origin)
>> +{
>> +	struct inode *inode = file->f_mapping->host;
>> +	int ret;
>> +
>> +	if (origin != SEEK_DATA && origin != SEEK_HOLE)
>> +		return generic_file_llseek(file, offset, origin);
>> +
>> +	mutex_lock(&inode->i_mutex);
>> +	switch (origin) {
> 
> We don't need the i_mutex to be held here. We only need to hold the
> ilock in shared mode for this operation to protect against extent
> list modifications (like unwritten extent conversion and
> truncation).

looks we only need to hold the ilock in shared mode in xfs_file_seek_extent().

> 
>> +int
>> +xfs_find_desired_extent(
>> +	struct inode		*inode,
>> +	loff_t			*start,
>> +	u32			type)
>> +{
>> +	xfs_inode_t		*ip = XFS_I(inode);
>> +	xfs_mount_t		*mp = ip->i_mount;
>> +	struct xfs_ifork	*ifp;
>> +	int			lock;
>> +	int			error;
>> +
>> +	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
>> +	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
>> +	    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
>> +		return XFS_ERROR(EINVAL);
>> +
>> +	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>> +
>> +	/*
>> +	 * Flush the delay alloc blocks. Even after flushing the inode,
>> +	 * there can still be delalloc blocks on the inode beyond EOF
>> +	 * due to speculative preallocation. These are not removed until
>> +	 * the release function is called or the inode is inactivated.
>> +	 * Hence we cannot assert here that ip->i_delayed_blks == 0.
>> +	 */
>> +	if (ip->i_delayed_blks || ip->i_size > ip->i_d.di_size) {
>> +		error = xfs_flush_pages(ip, 0, -1, 0, FI_REMAPF);
>> +		if (error)
>> +			goto out_unlock_iolock;
>> +	}
> 
> i.e. this IOLOCK and flush is completely unnecessary because we'll
> find delayed allocation extents in the extent lookup and can handle
> them just like real allocated extents....
> 
>> +	lock = xfs_ilock_map_shared(ip);
> 
> i.e. this is the only lock we need to take.

Yes, if we get rid of the the flush pages here, xfs_ilock() can be removed safely.

Thanks,
-Jeff

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
