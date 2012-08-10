Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7A8I6nI036928 for <xfs@oss.sgi.com>; Fri, 10 Aug 2012 03:18:06 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id OQ8o2tp1DkeLxi8A (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Aug 2012 01:18:05 -0700 (PDT)
Message-ID: <5024C3B4.2080306@oracle.com>
Date: Fri, 10 Aug 2012 16:17:56 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v6 3/4] xfs: xfs_seek_data() refinement with lookup data
	buffer offset from page cache
References: <501B6B7B.5040602@oracle.com> <20120809233747.GC2877@dastard>
In-Reply-To: <20120809233747.GC2877@dastard>
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

On 08/10/12 07:37, Dave Chinner wrote:
> On Fri, Aug 03, 2012 at 02:11:07PM +0800, Jeff Liu wrote:
>> Refine xfs_seek_data() to check up data buffer offset from page cache for unwritten extents.
>>
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>>
>> ---
>>  fs/xfs/xfs_file.c |   77 ++++++++++++++++++++++++++++++++++++++++------------
>>  1 files changed, 59 insertions(+), 18 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
>> index aff0c30..e852e52 100644
>> --- a/fs/xfs/xfs_file.c
>> +++ b/fs/xfs/xfs_file.c
>> @@ -1187,8 +1187,6 @@ xfs_seek_data(
>>  	struct inode		*inode = file->f_mapping->host;
>>  	struct xfs_inode	*ip = XFS_I(inode);
>>  	struct xfs_mount	*mp = ip->i_mount;
>> -	struct xfs_bmbt_irec	map[2];
>> -	int			nmap = 2;
>>  	loff_t			uninitialized_var(offset);
>>  	xfs_fsize_t		isize;
>>  	xfs_fileoff_t		fsbno;
>> @@ -1204,34 +1202,77 @@ xfs_seek_data(
>>  		goto out_unlock;
>>  	}
>>  
>> -	fsbno = XFS_B_TO_FSBT(mp, start);
>> -
>>  	/*
>>  	 * Try to read extents from the first block indicated
>>  	 * by fsbno to the end block of the file.
>>  	 */
>> +	fsbno = XFS_B_TO_FSBT(mp, start);
>>  	end = XFS_B_TO_FSB(mp, isize);
>> +	for (;;) {
>> +		struct xfs_bmbt_irec	map[2];
>> +		int			nmap = 2;
>>  
>> -	error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
>> -			       XFS_BMAPI_ENTIRE);
>> -	if (error)
>> -		goto out_unlock;
>> +		error = xfs_bmapi_read(ip, fsbno, end - fsbno, map, &nmap,
>> +				       XFS_BMAPI_ENTIRE);
>> +		if (error)
>> +			goto out_unlock;
>>  
>> -	/*
>> -	 * Treat unwritten extent as data extent since it might
>> -	 * contains dirty data in page cache.
>> -	 */
>> -	if (map[0].br_startblock != HOLESTARTBLOCK) {
>> -		offset = max_t(loff_t, start,
>> -			       XFS_FSB_TO_B(mp, map[0].br_startoff));
>> -	} else {
>> +		/* No extents at given offset, must be beyond EOF */
>> +		if (nmap == 0) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
>> +
>> +		offset = start;
>> +		/* Landed in a data extent */
>> +		if (map[0].br_startblock == DELAYSTARTBLOCK ||
>> +		    (map[0].br_state == XFS_EXT_NORM &&
>> +		     !isnullstartblock(map[0].br_startblock)))
>> +			break;
>> +
>> +		/*
>> +		 * Landed in an unwritten extent, try to search data
>> +		 * from page cache.
>> +		 */
>> +		if (map[0].br_state == XFS_EXT_UNWRITTEN) {
>> +			if (xfs_find_get_desired_pgoff(inode, &map[0],
>> +						       DATA_OFF, &offset))
>> +				break;
>> +		}
>> +
>> +		/*
>> +		 * map[0] is hole or its an unwritten extent but
>> +		 * without data in page cache.  Probably means that
>> +		 * we are reading after EOF if nothing in map[1].
>> +		 */
>>  		if (nmap == 1) {
>>  			error = ENXIO;
>>  			goto out_unlock;
>>  		}
>>  
>> -		offset = max_t(loff_t, start,
>> -			       XFS_FSB_TO_B(mp, map[1].br_startoff));
>> +		/* We have two mappings, proceed to check map[1] */
>> +		offset = XFS_FSB_TO_B(mp, map[1].br_startoff);
>> +		if (map[1].br_startblock == DELAYSTARTBLOCK ||
>> +		    (map[1].br_state == XFS_EXT_NORM &&
>> +		     !isnullstartblock(map[1].br_startblock)))
>> +			break;
>> +
>> +		if (map[1].br_state == XFS_EXT_UNWRITTEN) {
>> +			if (xfs_find_get_desired_pgoff(inode, &map[1],
>> +						DATA_OFF, &offset))
>> +				break;
>> +		}
> That's now duplicate code, so a loop would be much better to make it
> simpler to maintain an enhance in future:
>
> 		for (i = 0; i < nmap; i++) {
> 			offset = max_t(loff_t, start,
> 				       XFS_FSB_TO_B(mp, map[i].br_startoff));
>
> 			/* Landed in a data extent */
> 			if (map[i].br_startblock == DELAYSTARTBLOCK ||
> 			    (map[i].br_state == XFS_EXT_NORM &&
> 			     !isnullstartblock(map[i].br_startblock)))
> 				break;
>
> 			/*
> 			 * Landed in an unwritten extent, try to search data
> 			 * from page cache.
> 			 */
> 			if (map[i].br_state == XFS_EXT_UNWRITTEN) {
> 				if (xfs_find_get_desired_pgoff(inode, &map[i],
> 							       DATA_OFF, &offset))
> 					break;
> 			}
> 		}
>
> 		/*
> 		 * map[0] is hole or its an unwritten extent but
> 		 * without data in page cache.  Probably means that
> 		 * we are reading after EOF if nothing in map[1].
> 		 */
> 		if (nmap == 1) {
> 			error = ENXIO;
> 			goto out_unlock;
> 		}
It looks very nice to wrap up those check ups in loop.

Thanks,
-Jeff
>
>> +
>> +		/*
>> +		 * Nothing was found, proceed to the next round of search
>> +		 * if reading offset not beyond or hit EOF.
>> +		 */
>> +		fsbno = map[1].br_startoff + map[1].br_blockcount;
> 		fsbno = map[i].br_startoff + map[i].br_blockcount;
>
>> +		start = XFS_FSB_TO_B(mp, fsbno);
>> +		if (start >= isize) {
>> +			error = ENXIO;
>> +			goto out_unlock;
>> +		}
>>  	}
> Otherwise this looks just fine.
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
