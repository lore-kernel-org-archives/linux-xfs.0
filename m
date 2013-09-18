Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67B137F55
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 18:00:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03AFCAC007
	for <xfs@oss.sgi.com>; Wed, 18 Sep 2013 16:00:13 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	f9BuarbgZ0SJ9RjS for <xfs@oss.sgi.com>;
	Wed, 18 Sep 2013 16:00:12 -0700 (PDT)
Date: Thu, 19 Sep 2013 09:00:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: push down inactive transaction mgmt for truncate
Message-ID: <20130918230009.GD9901@dastard>
References: <1379520960-22972-1-git-send-email-bfoster@redhat.com>
	<1379520960-22972-3-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379520960-22972-3-git-send-email-bfoster@redhat.com>
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

On Wed, Sep 18, 2013 at 12:15:59PM -0400, Brian Foster wrote:
> Create the new xfs_inactive_truncate() function to handle the
> truncate portion of xfs_inactive(). Push the locking and
> transaction management into the new function.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 112 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 63 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 30db70e..9416462 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1663,6 +1663,53 @@ xfs_release(
>  }
>  
>  /*
> + * xfs_inactive_truncate
> + *
> + * Called to perform a truncate when an inode becomes unlinked.
> + */
> +STATIC int
> +xfs_inactive_truncate(
> +	struct xfs_inode *ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);
> +
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_itruncate, 0, 0);
> +	if (error) {
> +		ASSERT(XFS_FORCED_SHUTDOWN(mp));
> +		goto error0;

error_trans_cancel...

> +	}
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
> +
> +	ip->i_d.di_size = 0;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

Can you add a comment here that we are logging the inode size so
that if the system crashes part way through the truncation we don't
need to worry about stale data exposure?  There's a similar, more
expansive comment in xfs_setattr_size() - maybe a quick one-line
explaination and a "see setattr_size for more info" woul dbe
sufficient.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
