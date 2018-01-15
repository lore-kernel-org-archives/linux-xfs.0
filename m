Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933521AbeAOOmT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 09:42:19 -0500
Date: Mon, 15 Jan 2018 09:42:17 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: btree format ifork loader should check for zero
 numrecs
Message-ID: <20180115144216.GE47688@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579467015.8694.7629126647166170386.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579467015.8694.7629126647166170386.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 12, 2018 at 02:04:30PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> A btree format inode fork with zero records makes no sense, so reject it
> if we see it, or else we can miscalculate memory allocations.  Found by
> zeroes fuzzing {a,u3}.bmbt.numrecs in xfs/{374,378,412} with KASAN.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_fork.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 84eaf17..8c01dd5 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -307,6 +307,7 @@ xfs_iformat_btree(
>  	 */
>  	if (unlikely(XFS_IFORK_NEXTENTS(ip, whichfork) <=
>  					XFS_IFORK_MAXEXT(ip, whichfork) ||
> +		     nrecs == 0 ||
>  		     XFS_BMDR_SPACE_CALC(nrecs) >
>  					XFS_DFORK_SIZE(dip, mp, whichfork) ||
>  		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks) ||
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
