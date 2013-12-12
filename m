Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 824597F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 21:06:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EF228F8035
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 19:06:21 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id jpdpK8ZWvrpAfOSo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 19:06:20 -0800 (PST)
Message-ID: <52A92825.6020406@oracle.com>
Date: Thu, 12 Dec 2013 11:06:13 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: use xfs_ialloc_blks_per_cluster in
	xfs_ifree_cluster
References: <52A86D2B.50409@oracle.com> <20131211233101.GQ10988@dastard>
In-Reply-To: <20131211233101.GQ10988@dastard>
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

On 12/12 2013 07:31 AM, Dave Chinner wrote:
> On Wed, Dec 11, 2013 at 09:48:27PM +0800, Jeff Liu wrote:
>> From: Jie Liu <jeff.liu@oracle.com>
>>
>> Use xfs_ialloc_blks_per_cluster() in xfs_ifree_cluster()
>>
>> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
>> ---
>>  fs/xfs/xfs_inode.c | 13 +++----------
>>  1 file changed, 3 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 001aa89..7e75b8e 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -2152,16 +2152,9 @@ xfs_ifree_cluster(
>>  	struct xfs_perag	*pag;
>>  
>>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
>> -	if (mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp)) {
>> -		blks_per_cluster = 1;
>> -		ninodes = mp->m_sb.sb_inopblock;
>> -		nbufs = XFS_IALLOC_BLOCKS(mp);
>> -	} else {
>> -		blks_per_cluster = XFS_INODE_CLUSTER_SIZE(mp) /
>> -					mp->m_sb.sb_blocksize;
>> -		ninodes = blks_per_cluster * mp->m_sb.sb_inopblock;
>> -		nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
>> -	}
>> +	blks_per_cluster = xfs_ialloc_blks_per_cluster(mp);
>> +	ninodes = blks_per_cluster << mp->m_sb.sb_inopblog;
>> +	nbufs = XFS_IALLOC_BLOCKS(mp) / blks_per_cluster;
> 
> I'd get rid of the XFS_IALLOC_BLOCKS() macros there and just use
> mp->m_ialloc_blks directly. Otherwise looks good.
Agree, for the same reason as XFS_INODE_CLUSTER_SIZE() macros, I will
kill it.  Oh, it looks we can get rid of XFS_IALLOC_INODES() marcos as
well...

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
