Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DDEB87F37
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 19:29:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 890D9AC001
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 17:29:45 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	WgvJeDkETi0o8BDW for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 17:29:44 -0700 (PDT)
Date: Mon, 30 Sep 2013 10:29:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 1/4] xfs: push down inactive transaction mgmt for
	remote symlinks
Message-ID: <20130930002925.GI26872@dastard>
References: <1379689572-5543-1-git-send-email-bfoster@redhat.com>
	<1379689572-5543-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379689572-5543-2-git-send-email-bfoster@redhat.com>
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

On Fri, Sep 20, 2013 at 11:06:09AM -0400, Brian Foster wrote:
> Push down the transaction management for remote symlinks from
> xfs_inactive() down to xfs_inactive_symlink_rmt(). The latter is
> cleaned up to avoid transaction management intended for the
> calling context (i.e., trans duplication, reservation, item
> attachment).
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good. One minor quibble if you need to respin the patches
again, but otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

>  
> @@ -563,41 +552,46 @@ xfs_inactive_symlink_rmt(
>   */
>  int
>  xfs_inactive_symlink(
> -	struct xfs_inode	*ip,
> -	struct xfs_trans	**tp)
> +	struct xfs_inode	*ip)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			pathlen;
>  
>  	trace_xfs_inactive_symlink(ip);
>  
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> -
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return XFS_ERROR(EIO);
>  
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +
>  	/*
>  	 * Zero length symlinks _can_ exist.
>  	 */
>  	pathlen = (int)ip->i_d.di_size;
> -	if (!pathlen)
> +	if (!pathlen) {
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		return 0;
> +	}

Minor quibble: this repeated "unlock, return error" pattern could
be done with:

....
	if (!pathlen)
		goto out_unlock;
....
	/* remove the remote symlink */
	return xfs_inactive_symlink_rmt(ip);

out_unlock:
	xfs_iunlock(ip, XFS_ILOCK_EXCL);
	return error;
}

But, like I said, there's no need to do this unless I find other
things in the rest of the series that require a respin...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
