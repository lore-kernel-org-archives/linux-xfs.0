Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C678B7F37
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 16:19:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B19E18F8049
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:19:57 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MIfoASiWRrPI1Fdp for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 14:19:56 -0800 (PST)
Date: Fri, 13 Dec 2013 09:19:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/8] xfs: Introduce a common helper to calculate the
	number of blocks per cluster
Message-ID: <20131212221951.GI10988@dastard>
References: <52A967C6.1050303@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A967C6.1050303@oracle.com>
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

On Thu, Dec 12, 2013 at 03:37:42PM +0800, Jeff Liu wrote:
> Hi Folks,
> 
> Here is the v2 patch series to introduce a common helper which could be used
> to calculate the number of file system blocks in an inode cluster.
> 
> v2->v1:
> * Rename xfs_ialloc_blks_per_cluster() to xfs_icluster_size_fsb() as per dave's
>   suggestion.
> * Remove three macros XFS_IALLOC_INODES/XFS_INODE_CLUSTER_SIZE/XFS_IALLOC_BLOCKS
>   separately as preparation steps.
> * s/ninodes/inodes_per_cluster/g, as the later is more meaningful.
> * Remove wrong commit notes I previously written for using xfs_ialloc_blks_per_cluster
>   in xfs_imap(). 

All looks good, Jeff. Nice work, and thanks for adding all the extra
cleanups to it :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
