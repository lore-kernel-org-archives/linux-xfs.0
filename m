Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADD387F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:00:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97ED830406B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 19:00:48 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id F89WxDx9of8rsB0O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 19:00:46 -0800 (PST)
Message-ID: <52A926D8.50107@oracle.com>
Date: Thu, 12 Dec 2013 11:00:40 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfs: use xfs_ialloc_blks_per_cluster in xfs_bulkstat
References: <52A86D1E.6090507@oracle.com> <20131211232741.GO10988@dastard>
In-Reply-To: <20131211232741.GO10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 12/12 2013 07:27 AM, Dave Chinner wrote:
> On Wed, Dec 11, 2013 at 09:48:14PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Use xfs_ialloc_blks_per_cluster() in xfs_bulkstat(), make the
>> related variables more meaningful and remove an unused variable
>> nimask from it.
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_itable.c | 20 ++++++++------------
>>  1 file changed, 8 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
>> index c237ad1..6671f5b 100644
>> --- a/fs/xfs/xfs_itable.c
>> +++ b/fs/xfs/xfs_itable.c
>> @@ -209,9 +209,8 @@ xfs_bulkstat(
>>  	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
>>  	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
>>  	xfs_ino_t		lastino; /* last inode number returned */
>> -	int			nbcluster; /* # of blocks in a cluster */
>> -	int			nicluster; /* # of inodes in a cluster */
>> -	int			nimask;	/* mask for inode clusters */
>> +	int			blks_per_cluster; /* # of blocks in a cluster */
>> +	int			ninodes; /* # of inodes in a cluster */
> 
> inodes_per_cluster?
Ok.
> 
>>  	int			nirbuf;	/* size of irbuf */
>>  	int			rval;	/* return value error code */
>>  	int			tmp;	/* result value from btree calls */
>> @@ -243,11 +242,8 @@ xfs_bulkstat(
>>  	*done = 0;
>>  	fmterror = 0;
>>  	ubufp = ubuffer;
>> -	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
>> -		mp->m_sb.sb_inopblock :
>> -		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
>> -	nimask = ~(nicluster - 1);
>> -	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
>> +	blks_per_cluster = xfs_ialloc_blks_per_cluster(mp);
> 
> Ok, now I see the helper name, perhaps it shoul dbe more like all
> the other conversion functions. "ialloc" means nothing in the
> context, and "blks" doesn't tell us the unit we are converting to
> - if could be basic blocks, it could be filesystem blocks. So,
> perhaps something like xfs_icluster_size_fsb()?
Sounds make sense to me, I'd like to adopt this name.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
