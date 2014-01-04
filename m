Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D8DE7F4E
	for <xfs@oss.sgi.com>; Sat,  4 Jan 2014 07:46:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BE114AC007
	for <xfs@oss.sgi.com>; Sat,  4 Jan 2014 05:46:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4qMuPjSLJGQTDfH2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 04 Jan 2014 05:46:07 -0800 (PST)
Message-ID: <52C81098.1030406@oracle.com>
Date: Sat, 04 Jan 2014 21:46:00 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/10] xfs: xfs_bulkstat_single consolidation
References: <52BEB3E7.2080706@oracle.com> <52C7232B.3050807@redhat.com>
In-Reply-To: <52C7232B.3050807@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 01/04 2014 04:52 AM, Brian Foster wrote:
> On 12/28/2013 06:20 AM, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> In xfs_bulkstat_single(), xfs_bulkstat_one() and xfs_bulkstat() might
>> return different error if either call failed, we'd better return the
>> proper error in this case.  Moreover, the function argument done is
>> useless in terms of xfs_ioc_bulkstat(), hence we can get rid of it.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_ioctl.c  |  3 +--
>>  fs/xfs/xfs_itable.c | 59 ++++++++++++++++++++++++++---------------------------
>>  fs/xfs/xfs_itable.h |  3 +--
>>  3 files changed, 31 insertions(+), 34 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 33ad9a7..2fdd750 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -828,8 +828,7 @@ xfs_ioc_bulkstat(
>>  		error = xfs_inumbers(mp, &inlast, &count,
>>  					bulkreq.ubuffer, xfs_inumbers_fmt);
>>  	else if (cmd == XFS_IOC_FSBULKSTAT_SINGLE)
>> -		error = xfs_bulkstat_single(mp, &inlast,
>> -						bulkreq.ubuffer, &done);
>> +		error = xfs_bulkstat_single(mp, &inlast, bulkreq.ubuffer);
>>  	else	/* XFS_IOC_FSBULKSTAT */
>>  		error = xfs_bulkstat(mp, &inlast, &count, xfs_bulkstat_one,
>>  				     sizeof(xfs_bstat_t), bulkreq.ubuffer,
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index b5bb7b6..692671c 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -509,51 +509,50 @@ xfs_bulkstat(
>>  }
>>  
>>  /*
>> - * Return stat information in bulk (by-inode) for the filesystem.
>> - * Special case for non-sequential one inode bulkstat.
>> + * Return stat information in bulk (by-inode) for the filesystem.  Special case
>> + * for non-sequential one inode bulkstat.
>>   */
>> -int					/* error status */
>> +int
>>  xfs_bulkstat_single(
>> -	xfs_mount_t		*mp,	/* mount point for filesystem */
>> +	struct xfs_mount	*mp,	/* mount point for filesystem */
>>  	xfs_ino_t		*lastinop, /* inode to return */
>> -	char			__user *buffer, /* buffer with inode stats */
>> -	int			*done)	/* 1 if there are more stats to get */
>> +	char			__user *buffer) /* buffer with inode stats */
>>  {
>> -	int			count;	/* count value for bulkstat call */
>> -	int			error;	/* return value */
>> -	xfs_ino_t		ino;	/* filesystem inode number */
>> +	xfs_ino_t		ino = *lastinop;
>>  	int			res;	/* result from bs1 */
>> +	int			error;
>>  
>>  	/*
>> -	 * note that requesting valid inode numbers which are not allocated
>> +	 * Note that requesting valid inode numbers which are not allocated
>>  	 * to inodes will most likely cause xfs_imap_to_bp to generate warning
>> -	 * messages about bad magic numbers. This is ok. The fact that
>> -	 * the inode isn't actually an inode is handled by the
>> -	 * error check below. Done this way to make the usual case faster
>> -	 * at the expense of the error case.
>> +	 * messages about bad magic numbers. This is ok. The fact that the
>> +	 * inode isn't actually an inode is handled by the error check below.
>> +	 * Done this way to make the usual case faster at the expense of the
>> +	 * error case.
>>  	 */
>> -
>> -	ino = *lastinop;
>> -	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
>> +	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(struct xfs_bstat),
>>  				 NULL, &res);
>>  	if (error) {
>> +		int		count = 1;
>> +		int		done, error2;
>> +
>>  		/*
>> -		 * Special case way failed, do it the "long" way
>> -		 * to see if that works.
>> +		 * Special case way failed, do it the "long" way to see if
>> +		 * that works.
>>  		 */
>>  		(*lastinop)--;
>> -		count = 1;
>> -		if (xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
>> -				sizeof(xfs_bstat_t), buffer, done))
>> -			return error;
>> -		if (count == 0 || (xfs_ino_t)*lastinop != ino)
>> -			return error == EFSCORRUPTED ?
>> -				XFS_ERROR(EINVAL) : error;
>> -		else
>> -			return 0;
>> +		error2 = xfs_bulkstat(mp, lastinop, &count, xfs_bulkstat_one,
>> +				      sizeof(struct xfs_bstat), buffer, &done);
>> +		if (error2)
>> +			return error2;
>> +
>> +		if (count == 0 || *lastinop != ino) {
>> +			if (error == EFSCORRUPTED)
>> +				error = XFS_ERROR(EINVAL);
>> +		}
>>  	}
>> -	*done = 0;
>> -	return 0;
>> +
>> +	return error;
> 
> Here it looks like you return an error value if the initial
> xfs_bulkstat_one() fails and the fallback xfs_bulkstat() succeeds.
Good catch, thanks for for your review.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
