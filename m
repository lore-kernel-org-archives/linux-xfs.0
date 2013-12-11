Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 55E707F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 17:39:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1152AC00B
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 15:39:55 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	POVoAzhKFV3TFaIm for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 15:39:53 -0800 (PST)
Date: Thu, 12 Dec 2013 10:39:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: use xfs_ialloc_blks_per_cluster in xfs_imap
Message-ID: <20131211233938.GR10988@dastard>
References: <52A86D33.2020102@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A86D33.2020102@oracle.com>
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

On Wed, Dec 11, 2013 at 09:48:35PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Use xfs_ialloc_blks_per_cluster() in xfs_imap().  Please note that we
> previously calculate the number of blocks per cluster without taking
> the situation of that the inode cluster size might be equal to or less
> than the SB blocksize into account.  Maybe there is a chance to cause
> potential issues after handling an untrusted inode number lookup and
> proceed to check if the inode number maps to a block is outsides the
> file system bounds or not.

I don't think there's any issues here - after all the inode lookups
and mapping is done, the code in xfs_imap checks that the cluster
that the inode is mapped to lies wholly within the filesystem
boundaries. Hence I think you can remove that from the patch
descritpion.

Otherwise, looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
