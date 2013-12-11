Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C18077F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:27:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C9828F8039
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:27:46 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	fl9xx8szO9YMr95B for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:27:45 -0800 (PST)
Date: Thu, 12 Dec 2013 10:27:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use xfs_ialloc_blks_per_cluster in xfs_bulkstat
Message-ID: <20131211232741.GO10988@dastard>
References: <52A86D1E.6090507@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A86D1E.6090507@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Dec 11, 2013 at 09:48:14PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_ialloc_blks_per_cluster() in xfs_bulkstat(), make the
> related variables more meaningful and remove an unused variable
> nimask from it.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_itable.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c237ad1..6671f5b 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -209,9 +209,8 @@ xfs_bulkstat(
>  	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
>  	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
>  	xfs_ino_t		lastino; /* last inode number returned */
> -	int			nbcluster; /* # of blocks in a cluster */
> -	int			nicluster; /* # of inodes in a cluster */
> -	int			nimask;	/* mask for inode clusters */
> +	int			blks_per_cluster; /* # of blocks in a cluster */
> +	int			ninodes; /* # of inodes in a cluster */

inodes_per_cluster?

>  	int			nirbuf;	/* size of irbuf */
>  	int			rval;	/* return value error code */
>  	int			tmp;	/* result value from btree calls */
> @@ -243,11 +242,8 @@ xfs_bulkstat(
>  	*done = 0;
>  	fmterror = 0;
>  	ubufp = ubuffer;
> -	nicluster = mp->m_sb.sb_blocksize >= XFS_INODE_CLUSTER_SIZE(mp) ?
> -		mp->m_sb.sb_inopblock :
> -		(XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog);
> -	nimask = ~(nicluster - 1);
> -	nbcluster = nicluster >> mp->m_sb.sb_inopblog;
> +	blks_per_cluster = xfs_ialloc_blks_per_cluster(mp);

Ok, now I see the helper name, perhaps it shoul dbe more like all
the other conversion functions. "ialloc" means nothing in the
context, and "blks" doesn't tell us the unit we are converting to
- if could be basic blocks, it could be filesystem blocks. So,
perhaps something like xfs_icluster_size_fsb()?

Otherwise this patch looks ok.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
