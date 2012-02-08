Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q18DB5qP071755 for <xfs@oss.sgi.com>; Wed, 8 Feb 2012 07:11:05 -0600
Message-ID: <4F327434.10100@oracle.com>
Date: Wed, 08 Feb 2012 21:10:12 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V7
References: <4F2FE66C.80303@oracle.com> <20120208050129.GE20305@dastard>
In-Reply-To: <20120208050129.GE20305@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chris Mason <chris.mason@oracle.com>, xfs@oss.sgi.com

Hi Dave,

Thanks for your review.
On 02/08/2012 01:01 PM, Dave Chinner wrote:

> On Mon, Feb 06, 2012 at 10:40:44PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> There is one bug fix in this version, in xfs_seek_data()/xfs_seek_hole(), call xfs_bmapi_read() or
>> xfs_bmap_first_unused() maybe failed, they should return ENXIO in this case.
>> Thanks Mark for pointing this out!
>>
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> 
> Can you post a final version with the real commit message attached?
> 
> The normal way of making comments like this about a patch posting is
> to put the comments after the first "---" line, like the diffstat is
> below....

> 
> As it is,my comments are mainly about error handling and putting in
> some comments to explain exactly why the code ended up this way....

Ok, the commit message will added in next post.

But I still have a concern about error handing as below.

> 
>> ---
>>  fs/xfs/xfs_file.c |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 files changed, 171 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index 753ed9b..3822b15 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1141,8 +1141,178 @@ xfs_vm_page_mkwrite(
>>  	return block_page_mkwrite(vma, vmf, xfs_get_blocks);
>>  }
>>  
>> +STATIC loff_t
>> +xfs_seek_data(
>> +	struct file		*file,
>> +	loff_t			start,
>> +	u32			type)
>> +{
>> +	struct inode		*inode = file->f_mapping->host;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	loff_t			uninitialized_var(offset);
>> +	xfs_fsize_t		isize;
>> +	xfs_fileoff_t		fsbno;
>> +	xfs_filblks_t		len;
>> +	uint			lock;
>> +	int			error;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
>> +
>> +	isize = i_size_read(inode);
>> +	if (start >= isize) {
>> +		error = ENXIO;
>> +		goto out_unlock;
>> +	}
>> +
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>> +	len = XFS_B_TO_FSB(mp, isize);
> 
> It's not entirely obvious why len is based on isize rather than the
> (isize - start), the range being mapped. A comment might be in order
> so we don't make silly mistakes reading the code in a couple of
> years time.
> 
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>> +		loff_t			seekoff;
>> +
>> +		error = xfs_bmapi_read(ip, fsbno, len - fsbno, map, &nmap,
>> +				       XFS_BMAPI_ENTIRE);
>> +		if (error) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
> 
> I don't think that is correct. ENXIO means "offset beyond EOF", and
> this will typically only return errors due to extent tree corruption
> or filesystem shutdown. I'd just return the error as it stands.

Currently, both OCFS2 and Btrfs return ENXIO in case of their particular extent fetch routine failed.
So return other internal errors in XFS will introduce incompatibility IMHO.
But just as you pointed out, as well as ENXIO semantics defined at http://linux.die.net/man/2/lseek,
return ENXIO is not proper to internal issue, and that might confuse user in such situation for return value check up.

Maybe it's better to reach a consensus with other file systems with SEEK_DATA/SEEK_HOLE supports, I'd suggest
either:
1) return the error as it stands in particular file system.
or:
2) return EIO or another meaningful error number.
look all those file systems need to fix up accordingly.

>> +		/* No extents at given offset, must be beyond EOF */
>> +		if (nmap == 0) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
> 
> But we can't be beyond EOF - we've already checked that. Hence we
> should *always* get a mapping back. To fail to get one back is a
> sign of extent tree corruption, I think, so this should probably be
> a XFS_WANT_CORRUPTED_GOTO() case....

checking "nmap == 0" also has another option, since there might have continuous hole extents in mapped file range,
i.e, both map[0] and map[1] are holes(for now, I have not yet worked out a test case to verify this scenario).
I still need some time to verify that.

> 
>> +		seekoff = XFS_FSB_TO_B(mp, fsbno);
>> +
>> +		if ((map[0].br_state == XFS_EXT_NORM &&
>> +		     !isnullstartblock(map[0].br_startblock)) ||
>> +		    map[0].br_startblock == DELAYSTARTBLOCK) {
> 
> So this skips holes and unwritten regions.
> 
>> +			offset = max_t(loff_t, seekoff,
>> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
>> +			break;
>> +		} else if (map[0].br_state == XFS_EXT_UNWRITTEN) {
>> +			offset = max_t(loff_t, seekoff,
>> +				       XFS_FSB_TO_B(mp, map[0].br_startoff));
>> +			break;

Using "map[0].br_startblock != HOLESTARTBLOCK" to simplify the logic for offset calculation is cool!
However, treat unwritten extent as data is temporarily for us, it will finally split up to an individual check when
trying to add dirty data lookup. Given that, how about if we keep the current logic so that we don't need much
code change in future, does it make sense? :)

> 
> But unwritten regions have an identical offset caclulation to
> delayed and written regions. So that entire piece of logic becomes:
> 
> 		if (map[0].br_startblock != HOLESTARTBLOCK)) {
> 			offset = max_t(loff_t, seekoff,
> 				       XFS_FSB_TO_B(mp, map[0].br_startoff));
> 			break;
> 		} else {

> 
> A comment might be in order there, too, indicating why we are
> handling unwritten regions as data, just like written and delalloc
> regions....

Ok.

> 
>> +		} else if (map[0].br_startblock == HOLESTARTBLOCK) {
>> +			if (nmap == 1) {
>> +				error = ENXIO;
>> +				goto out_unlock;
>> +			}
>> +
>> +			if ((map[1].br_state == XFS_EXT_NORM &&
>> +			     !isnullstartblock(map[1].br_startblock)) ||
>> +			    map[1].br_startblock == DELAYSTARTBLOCK) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			} else if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +				offset = max_t(loff_t, seekoff,
>> +					XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +				break;
>> +			} else if (map[1].br_startblock == HOLESTARTBLOCK) {
>> +				fsbno = map[1].br_startoff +
>> +					map[1].br_blockcount;
> 
> Same again:
> 			if (map[1].br_startblock != HOLESTARTBLOCK) {
> 				offset = max_t(loff_t, seekoff
> 					XFS_FSB_TO_B(mp, map[1].br_startoff));
> 				break;
> 			} else {
> 				fsbno = map[1].br_startoff +
> 					map[1].br_blockcount;
> 			}
> 
>> +			} else {
>> +				BUG();
>> +			}
>> +		} else {
>> +			BUG();
>> +		}
> 
> Panicing the machine just because the filesystem might be corrupted
> in not a very nice way to handle the error. Given that we don't even
> need to handle wierd map states here (because the xfs_bmapi_read()
> will have found any corruption during the lookup) i don't think this
> is at all necessary.

Yes, looks we can safely remove them. :)

I'll take care below things too.

Thanks,
-Jeff

> 
>> +
>> +		if (XFS_FSB_TO_B(mp, fsbno) > isize) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
>> +	}
>> +
>> +	if (offset < start)
>> +		offset = start;
>> +
>> +	if (offset != file->f_pos)
>> +		file->f_pos = offset;
>> +
>> +out_unlock:
>> +	xfs_iunlock_map_shared(ip, lock);
>> +
>> +	if (error)
>> +		return -error;
>> +	return offset;
>> +}
>> +
>> +STATIC loff_t
>> +xfs_seek_hole(
>> +	struct file		*file,
>> +	loff_t			start,
>> +	u32			type)
>> +{
>> +	struct inode		*inode = file->f_mapping->host;
>> +	struct xfs_inode	*ip = XFS_I(inode);
>> +	struct xfs_mount	*mp = ip->i_mount;
>> +	loff_t			uninitialized_var(offset);
>> +	loff_t			holeoff;
>> +	xfs_fsize_t		isize;
>> +	xfs_fileoff_t		fsbno;
>> +	uint			lock;
>> +	int			error;
>> +
>> +	lock = xfs_ilock_map_shared(ip);
>> +
>> +	isize = i_size_read(inode);
>> +	if (start >= isize) {
>> +		error = ENXIO;
>> +		goto out_unlock;
>> +	}
>> +
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>> +	error = xfs_bmap_first_unused(NULL, ip, 1, &fsbno, XFS_DATA_FORK);
>> +	if (error) {
>> +		error = ENXIO;
>> +		goto out_unlock;
>> +	}
> 
> Same comment here about error handling. xfs_bmap_first_unused()
> failing usually indicates a corruption, not a "offset beyond EOF",
> so we should be returning the error that the filesystem has returned
> rather than ENXIO.
> 
>> +
>> +	holeoff = XFS_FSB_TO_B(mp, fsbno);
>> +	if (holeoff <= start)
>> +		offset = start;
>> +	else
>> +		offset = min_t(loff_t, holeoff, isize);
>> +
>> +	if (offset != file->f_pos)
>> +		file->f_pos = offset;
>> +
>> +out_unlock:
>> +	xfs_iunlock_map_shared(ip, lock);
>> +
>> +	if (error)
>> +		return -error;
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
>> +		return xfs_seek_data(file, offset, origin);
>> +	case SEEK_HOLE:
>> +		return xfs_seek_hole(file, offset, origin);
>> +	default:
>> +		return -EINVAL;
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
>> 1.7.9
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
