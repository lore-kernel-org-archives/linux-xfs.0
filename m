Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E271029DF8
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:52:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7E2C8F8033
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 14:52:08 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BQON1GwsmJ7LIDZ0 for <xfs@oss.sgi.com>;
	Wed, 15 Jan 2014 14:52:06 -0800 (PST)
Message-ID: <52D71115.1070309@sandeen.net>
Date: Wed, 15 Jan 2014 16:52:05 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: allow logical-sector sized O_DIRECT for any fs sector
	size
References: <52D6CC91.6000408@redhat.com> <20140115223848.GZ3469@dastard>
In-Reply-To: <20140115223848.GZ3469@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On 1/15/14, 4:38 PM, Dave Chinner wrote:
> On Wed, Jan 15, 2014 at 11:59:45AM -0600, Eric Sandeen wrote:
>> Some time ago, mkfs.xfs started picking the storage physical
>> sector size as the default filesystem "sector size" in order
>> to avoid RMW costs incurred by doing IOs at logical sector
>> size alignments.
>>
>> However, this means that for a filesystem made with i.e.
>> a 4k sector size on an "advanced format" 4k/512 disk,
>> 512-byte direct IOs are no longer allowed.  This means
>> that XFS has essentially turned this AF drive into a hard
>> 4K device, from the filesystem on up.
>>
>> XFS's mkfs-specified "sector size" is really just controlling
>> the minimum size & alignment of filesystem metadata IO.
>>
>> There is no real need to tightly couple XFS's minimal
>> metadata size to the minimum allowed direct IO size;
>> XFS can continue doing metadata in optimal sizes, but
>> still allow smaller DIOs for apps which issue them,
>> for whatever reason.
> 
> Given that we already serialise sub-block IO completely, doing
> "sub-sector" IO will also be serialised so there shouldn't be any
> new issues introduced by this change.
> 
>> This patch adds 2 new fields to the xfs_buftarg, so that
>> we now track 3 sizes:
>>
>>  1) The device logical sector size
>>  2) The device physical sector size
>>  3) The filesystem sector size, which is the minimum unit and
>>     alignment of IO which will be performed by metadata operations.
> 
> I wouldn't call it the "filesystem sector size" because it's clear
> that it doesn't apply to everything in the filesystem. I'd prefer
> that we call it the "metadata sector size", similar to the "log
> sector size" we keep for situations where the external log device
> has a different sector size to the data device.

Ok, fair enough.

>> The first is used for the minimum allowed direct IO alignment,
>> the 2nd is used to report DIO sizes in XFS_IOC_DIOINFO
>> (the theory being, if an app actually asks, we can give them
>> the optimal answer, even if we allow smaller IOs), and the
>> 3rd is used internally by the filesystem for metadata IOs.
> 
> Terminology nit: the 3rd is set by mkfs to define the physical
> format constraints that metadata in the filesystem must obey. If we
> ever have to allocate sector sized metadata, then it will be used
> for more than just IO....

Ok.  I can fix comments.  :D

>> This has passed xfstests on filesystems made with 4k sectors,
>> including when run under the patch I sent to ignore
>> XFS_IOC_DIOINFO, and issue 512 DIOs anyway.  I also directly
>> tested end of block behavior on preallocated, sparse, and
>> existing files when we do a 512 IO into a 4k file on a 
>> 4k-sector filesystem, to be sure there were no unexpected
>> behaviors.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> NB: This depends on this patch which is in the xfs tree,
>> but not yet upstream:
>>  xfs: simplify xfs_setsize_buftarg callchain; remove unused arg
>>
>>
>>
>> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
>> index 9fccfb5..a89dcdf 100644
>> --- a/fs/xfs/xfs_buf.c
>> +++ b/fs/xfs/xfs_buf.c
>> @@ -1599,6 +1599,7 @@ xfs_setsize_buftarg(
>>  	unsigned int		blocksize,
>>  	unsigned int		sectorsize)
>>  {
>> +	/* Set up filesystem block and sector sizes */
>>  	btp->bt_bsize = blocksize;
>>  	btp->bt_sshift = ffs(sectorsize) - 1;
> 
> The two places that use bt_sshift convert it back to a byte count.
> We should change this simply to being a byte count.

Ok, yeah, good point.  I think I considered that along the way.

>>  	btp->bt_smask = sectorsize - 1;
>> @@ -1614,6 +1615,9 @@ xfs_setsize_buftarg(
>>  		return EINVAL;
>>  	}
>>  
>> +	/* Set up device logical & physical sector size info */
>> +	btp->bt_lsmask = bdev_logical_block_size(btp->bt_bdev) - 1;
>> +	btp->bt_pssize = bdev_physical_block_size(btp->bt_bdev);
>>  	return 0;
>>  }
>>  
>> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
>> index 1cf21a4..29a0db9 100644
>> --- a/fs/xfs/xfs_buf.h
>> +++ b/fs/xfs/xfs_buf.h
>> @@ -88,14 +88,28 @@ typedef unsigned int xfs_buf_flags_t;
>>   */
>>  #define XFS_BSTATE_DISPOSE	 (1 << 0)	/* buffer being discarded */
>>  
>> +/*
>> + * The xfs_buftarg contains 3 notions of "sector size" -
>> + *
>> + * 1) The device logical sector size
>> + * 2) The device physical sector size
>> + * 3) The filesystem sector size, which is the minimum unit and
>> + *    alignment of IO which will be performed by metadata operations.
>> + *
>> + * The latter is specified at mkfs time, stored on-disk in the
>> + * superblock's sb_sectsize, and is set from there.
>> + */
>> +
>>  typedef struct xfs_buftarg {
>>  	dev_t			bt_dev;
>>  	struct block_device	*bt_bdev;
>>  	struct backing_dev_info	*bt_bdi;
>>  	struct xfs_mount	*bt_mount;
>> -	unsigned int		bt_bsize;
>> -	unsigned int		bt_sshift;
>> -	size_t			bt_smask;
>> +	unsigned int		bt_bsize;	/* fs block size */
>> +	unsigned int		bt_sshift;	/* fs sector size shift */
>> +	size_t			bt_smask;	/* fs sector size mask */
>> +	size_t			bt_lsmask;	/* dev logical sectsz mask */
>> +	unsigned int		bt_pssize;	/* dev physical sector size */
> 
> This patch makes bt_smask unused, so it can be removed. bt_bsize is
> also unused, so that should be removed, too. indeed, the buftarg has
> a backpointer to the xfs_mount, so we can get the block size from
> there if it is ever necessary.

bt_bsize is used, until your suggestion below.  :)  But I can
remove it with that change, sure.


> And I think we should make these names a little more descriptive
> while we are touching them so comments to describe them are
> unnecessary:
> 
> 	unsigned int		bt_meta_sectorsize;
> 	unsigned int		bt_physical_sectorsize;
> 	size_t			bt_logical_sectormask;

Ok.  I was just sticking with the tradtional (lack of) verbosity.

>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 33ad9a7..1f3431f 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1587,7 +1587,12 @@ xfs_file_ioctl(
>>  			XFS_IS_REALTIME_INODE(ip) ?
>>  			mp->m_rtdev_targp : mp->m_ddev_targp;
>>  
>> -		da.d_mem = da.d_miniosz = 1 << target->bt_sshift;
>> +		/*
>> +		 * Report device physical sector size as "optimal" minimum,
>> +		 * unless blocksize is smaller than that.
>> +		 */
>> +		da.d_miniosz = min(target->bt_pssize, target->bt_bsize);
> 
> Just grab the filesysetm block size from the xfs_mount:
> 
> 		da.d_miniosz = min(target->bt_pssize, mp->m_sb.sb_blocksize);
> 
>> +		da.d_mem = da.d_miniosz;
> 
> I'd suggest that this should be PAGE_SIZE - it's for memory buffer
> alignment, not IO alignment, so using the IO alignment just seems
> wrong to me...

Ok.  Was just sticking close to what we had before.

So:
 		da.d_miniosz = min(target->bt_pssize, mp->m_sb.sb_blocksize);
		da.d_mem = PAGE_SIZE;

?  Then we can have a minimum IO size of 512, and a memory alignment of
4k, isn't that a little odd?

(IOWs we could do 512-aligned memory before, right?  What's the downside,
or the value in changing it now?)

Thanks,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
