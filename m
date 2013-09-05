Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E11EF29DFC
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 20:40:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7FDDAAC003
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 18:40:43 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	tCtYW18ub3S7ls3B for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 18:40:40 -0700 (PDT)
Date: Thu, 5 Sep 2013 11:40:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 07/11] xfs: retry trans reservation on ENOSPC in
	xfs_inactive()
Message-ID: <20130905014016.GU23571@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378232708-57156-8-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 02:25:04PM -0400, Brian Foster wrote:
> An ifree data block reservation can fail with ENOSPC. Flush inodes
> to try and free up space or attempt without a data block
> reservation to avoid failing out of xfs_inactive().
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 56cbf63..92de4b7 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1779,7 +1779,18 @@ xfs_inactive(
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
>  	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
>  				  XFS_IFREE_SPACE_RES(mp), 0);
> +	if (error == ENOSPC) {
> +		/* flush outstanding delalloc blocks and retry */
> +		xfs_flush_inodes(mp);
> +		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ifree,
> +					  XFS_IFREE_SPACE_RES(mp), 0);
> +	}

We don't want to be blocking for inode flushes here. We might be in
a shrinker context, for example, and blocking those for a filesystem
sync is going to be unfriendly.

If this really is a problem, then the right thing to do is to allow
this transaction to dip into the reserve block pool so the
transaction can complete and make progress - other write operations
will trigger the flushing of the filesystem, and freeing of whole
inode chunks should return more free space than we need for the
finobt modifications in the removing lots of zero length inodes
at ENOSPC case....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
